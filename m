Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaKERuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:50:20 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:48053 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751746AbaKERuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:50:17 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 26/26] tty: Flush ldisc buffer atomically with tty flip buffers
Date: Wed,  5 Nov 2014 12:13:09 -0500
Message-Id: <1415207589-15967-27-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_ldisc_flush() first clears the line discipline input buffer,
then clears the tty flip buffers. However, this allows for existing
data in the tty flip buffers to be added after the ldisc input
buffer has been cleared, but before the flip buffers have been cleared.

Add an optional ldisc parameter to tty_buffer_flush() to allow
tty_ldisc_flush() to pass the ldisc to clear.

NB: Initially, the plan was to do this automatically in
tty_buffer_flush(). However, an audit of the behavior of existing
line disciplines showed that performing a ldisc buffer flush on
ioctl(TCFLSH) was not always the outcome. For example, some line
disciplines have flush_buffer() methods but not ioctl() methods,
so a ->flush_buffer() command would be unexpected.

Reviewed-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 10 ++++++++--
 drivers/tty/tty_io.c     |  2 +-
 drivers/tty/tty_ldisc.c  | 12 +++++-------
 include/linux/tty.h      |  2 +-
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 143deb6..3605103 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -202,14 +202,16 @@ static void tty_buffer_free(struct tty_port *port, struct tty_buffer *b)
 /**
  *	tty_buffer_flush		-	flush full tty buffers
  *	@tty: tty to flush
+ *	@ld:  optional ldisc ptr (must be referenced)
  *
- *	flush all the buffers containing receive data.
+ *	flush all the buffers containing receive data. If ld != NULL,
+ *	flush the ldisc input buffer.
  *
  *	Locking: takes buffer lock to ensure single-threaded flip buffer
  *		 'consumer'
  */
 
-void tty_buffer_flush(struct tty_struct *tty)
+void tty_buffer_flush(struct tty_struct *tty, struct tty_ldisc *ld)
 {
 	struct tty_port *port = tty->port;
 	struct tty_bufhead *buf = &port->buf;
@@ -223,6 +225,10 @@ void tty_buffer_flush(struct tty_struct *tty)
 		buf->head = next;
 	}
 	buf->head->read = buf->head->commit;
+
+	if (ld && ld->ops->flush_buffer)
+		ld->ops->flush_buffer(tty);
+
 	atomic_dec(&buf->priority);
 	mutex_unlock(&buf->lock);
 }
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index fabf4c0..4bd48f7 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2899,7 +2899,7 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		case TCIFLUSH:
 		case TCIOFLUSH:
 		/* flush tty buffer and allow ldisc to process ioctl */
-			tty_buffer_flush(tty);
+			tty_buffer_flush(tty, NULL);
 			break;
 		}
 		break;
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 6368dd9..b66a81d 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -397,19 +397,17 @@ static void __lockfunc tty_ldisc_unlock_pair(struct tty_struct *tty,
  *	tty_ldisc_flush	-	flush line discipline queue
  *	@tty: tty
  *
- *	Flush the line discipline queue (if any) for this tty. If there
- *	is no line discipline active this is a no-op.
+ *	Flush the line discipline queue (if any) and the tty flip buffers
+ *	for this tty.
  */
 
 void tty_ldisc_flush(struct tty_struct *tty)
 {
 	struct tty_ldisc *ld = tty_ldisc_ref(tty);
-	if (ld) {
-		if (ld->ops->flush_buffer)
-			ld->ops->flush_buffer(tty);
+
+	tty_buffer_flush(tty, ld);
+	if (ld)
 		tty_ldisc_deref(ld);
-	}
-	tty_buffer_flush(tty);
 }
 EXPORT_SYMBOL_GPL(tty_ldisc_flush);
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index e33ea1a..f6835ea 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -441,7 +441,7 @@ extern void __do_SAK(struct tty_struct *tty);
 extern void no_tty(void);
 extern void tty_flush_to_ldisc(struct tty_struct *tty);
 extern void tty_buffer_free_all(struct tty_port *port);
-extern void tty_buffer_flush(struct tty_struct *tty);
+extern void tty_buffer_flush(struct tty_struct *tty, struct tty_ldisc *ld);
 extern void tty_buffer_init(struct tty_port *port);
 extern speed_t tty_termios_baud_rate(struct ktermios *termios);
 extern speed_t tty_termios_input_baud_rate(struct ktermios *termios);
-- 
2.1.3

