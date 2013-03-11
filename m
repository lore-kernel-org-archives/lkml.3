Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab3CKUpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:45:54 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:59135 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab3CKUpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:45:49 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 02/44] n_tty: Factor packet mode status change for reuse
Date: Mon, 11 Mar 2013 16:44:22 -0400
Message-Id: <1363034704-28036-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the packet mode status change from n_tty_flush_buffer
for use by follow-on patch.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 9c18e37..4d3ab2c 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -238,6 +238,18 @@ static void reset_buffer_flags(struct tty_struct *tty)
 	n_tty_set_room(tty);
 }
 
+static void n_tty_packet_mode_flush(struct tty_struct *tty)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	if (tty->link->packet) {
+		tty->ctrl_status |= TIOCPKT_FLUSHREAD;
+		wake_up_interruptible(&tty->link->read_wait);
+	}
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+}
+
 /**
  *	n_tty_flush_buffer	-	clean input queue
  *	@tty:	terminal device
@@ -252,19 +264,11 @@ static void reset_buffer_flags(struct tty_struct *tty)
 
 static void n_tty_flush_buffer(struct tty_struct *tty)
 {
-	unsigned long flags;
 	/* clear everything and unthrottle the driver */
 	reset_buffer_flags(tty);
 
-	if (!tty->link)
-		return;
-
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
-	if (tty->link->packet) {
-		tty->ctrl_status |= TIOCPKT_FLUSHREAD;
-		wake_up_interruptible(&tty->link->read_wait);
-	}
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	if (tty->link)
+		n_tty_packet_mode_flush(tty);
 }
 
 /**
-- 
1.8.1.2

