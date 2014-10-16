Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaJPU0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:26:31 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37201 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752885AbaJPUZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:25:50 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 08/27] tty: Drop tty_mutex before tty reopen
Date: Thu, 16 Oct 2014 16:25:06 -0400
Message-Id: <1413491125-20134-9-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Holding tty_mutex for a tty re-open is no longer necessary since
"tty: Clarify re-open behavior of master ptys". Because the
slave tty count is no longer accessed by tty_reopen(), holding
tty_mutex to prevent concurrent final tty_release() of the slave
pty is not required.

As with "tty: Re-open /dev/tty without tty_mutex", holding a
tty kref until the tty_lock is acquired is sufficient to ensure
the tty has not been freed, which, in turn, is sufficient to
ensure the tty_lock can be safely acquired and the tty count
can be safely retrieved. A non-zero tty count with the tty lock
held guarantees that release_tty() has not run and cannot
run concurrently with tty_reopen().

Change tty_driver_lookup_tty() to acquire the tty kref, which
allows the tty_mutex to be dropped before acquiring the tty lock.
Dropping the tty_mutex before attempting the tty_lock allows
other ttys to be opened and released, without needing this
tty_reopen() to complete.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 1b6f38c..ded0445 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1344,19 +1344,24 @@ static ssize_t tty_line_name(struct tty_driver *driver, int index, char *p)
  *	@driver: the driver for the tty
  *	@idx:	 the minor number
  *
- *	Return the tty, if found or ERR_PTR() otherwise.
+ *	Return the tty, if found. If not found, return NULL or ERR_PTR() if the
+ *	driver lookup() method returns an error.
  *
- *	Locking: tty_mutex must be held. If tty is found, the mutex must
- *	be held until the 'fast-open' is also done. Will change once we
- *	have refcounting in the driver and per driver locking
+ *	Locking: tty_mutex must be held. If the tty is found, bump the tty kref.
  */
 static struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
 		struct inode *inode, int idx)
 {
+	struct tty_struct *tty;
+
 	if (driver->ops->lookup)
-		return driver->ops->lookup(driver, inode, idx);
+		tty = driver->ops->lookup(driver, inode, idx);
+	else
+		tty = driver->ttys[idx];
 
-	return driver->ttys[idx];
+	if (!IS_ERR(tty))
+		tty_kref_get(tty);
+	return tty;
 }
 
 /**
@@ -2089,16 +2094,20 @@ retry_open:
 		}
 
 		if (tty) {
+			mutex_unlock(&tty_mutex);
 			tty_lock(tty);
+			/* safe to drop the kref from tty_driver_lookup_tty() */
+			tty_kref_put(tty);
 			retval = tty_reopen(tty);
 			if (retval < 0) {
 				tty_unlock(tty);
 				tty = ERR_PTR(retval);
 			}
-		} else	/* Returns with the tty_lock held for now */
+		} else { /* Returns with the tty_lock held for now */
 			tty = tty_init_dev(driver, index);
+			mutex_unlock(&tty_mutex);
+		}
 
-		mutex_unlock(&tty_mutex);
 		tty_driver_kref_put(driver);
 	}
 
-- 
2.1.1

