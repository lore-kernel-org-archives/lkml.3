Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbaKERVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:21:37 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50549 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753303AbaKERNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:13:35 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 07/26] tty: Re-open /dev/tty without tty_mutex
Date: Wed,  5 Nov 2014 12:12:50 -0500
Message-Id: <1415207589-15967-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Opening /dev/tty (ie., the controlling tty for the current task)
is always a re-open of the underlying tty. Because holding the
tty_lock is sufficient for safely re-opening a tty, and because
having a tty kref is sufficient for safely acquiring the tty_lock [1],
tty_open_current_tty() does not require holding tty_mutex.

Repurpose tty_open_current_tty() to perform the re-open itself and
refactor tty_open().

[1] Analysis of safely re-opening the current tty w/o tty_mutex

get_current_tty() gets a tty kref from the already kref'ed tty value of
current->signal->tty while holding the sighand lock for the current
task. This guarantees that the tty pointer returned from
get_current_tty() points to a tty which remains referenceable
while holding the kref.

Although release_tty() may run concurrently, and thus the driver
reference may be removed, release_one_tty() cannot have run, and
won't while holding the tty kref.

This, in turn, guarantees the tty_lock() can safely be acquired
(since tty->magic and tty->legacy_mutex are still a valid dereferences).
The tty_lock() also gets a tty kref to prevent the tty_unlock() from
dereferencing a released tty. Thus, the kref returned from
get_current_tty() can be released.

Lastly, the first operation of tty_reopen() is to check the tty count.
If non-zero, this ensures release_tty() is not running concurrently,
and the driver references have not been removed.

Reviewed-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 53 ++++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 97445c2..fb4583c 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1944,20 +1944,20 @@ int tty_release(struct inode *inode, struct file *filp)
 }
 
 /**
- *	tty_open_current_tty - get tty of current task for open
+ *	tty_open_current_tty - get locked tty of current task
  *	@device: device number
  *	@filp: file pointer to tty
- *	@return: tty of the current task iff @device is /dev/tty
+ *	@return: locked tty of the current task iff @device is /dev/tty
+ *
+ *	Performs a re-open of the current task's controlling tty.
  *
  *	We cannot return driver and index like for the other nodes because
  *	devpts will not work then. It expects inodes to be from devpts FS.
- *
- *	We need to move to returning a refcounted object from all the lookup
- *	paths including this one.
  */
 static struct tty_struct *tty_open_current_tty(dev_t device, struct file *filp)
 {
 	struct tty_struct *tty;
+	int retval;
 
 	if (device != MKDEV(TTYAUX_MAJOR, 0))
 		return NULL;
@@ -1968,9 +1968,14 @@ static struct tty_struct *tty_open_current_tty(dev_t device, struct file *filp)
 
 	filp->f_flags |= O_NONBLOCK; /* Don't let /dev/tty block */
 	/* noctty = 1; */
-	tty_kref_put(tty);
-	/* FIXME: we put a reference and return a TTY! */
-	/* This is only safe because the caller holds tty_mutex */
+	tty_lock(tty);
+	tty_kref_put(tty);	/* safe to drop the kref now */
+
+	retval = tty_reopen(tty);
+	if (retval < 0) {
+		tty_unlock(tty);
+		tty = ERR_PTR(retval);
+	}
 	return tty;
 }
 
@@ -2068,13 +2073,9 @@ retry_open:
 	index  = -1;
 	retval = 0;
 
-	mutex_lock(&tty_mutex);
-	/* This is protected by the tty_mutex */
 	tty = tty_open_current_tty(device, filp);
-	if (IS_ERR(tty)) {
-		retval = PTR_ERR(tty);
-		goto err_unlock;
-	} else if (!tty) {
+	if (!tty) {
+		mutex_lock(&tty_mutex);
 		driver = tty_lookup_driver(device, filp, &noctty, &index);
 		if (IS_ERR(driver)) {
 			retval = PTR_ERR(driver);
@@ -2087,21 +2088,21 @@ retry_open:
 			retval = PTR_ERR(tty);
 			goto err_unlock;
 		}
-	}
 
-	if (tty) {
-		tty_lock(tty);
-		retval = tty_reopen(tty);
-		if (retval < 0) {
-			tty_unlock(tty);
-			tty = ERR_PTR(retval);
-		}
-	} else	/* Returns with the tty_lock held for now */
-		tty = tty_init_dev(driver, index);
+		if (tty) {
+			tty_lock(tty);
+			retval = tty_reopen(tty);
+			if (retval < 0) {
+				tty_unlock(tty);
+				tty = ERR_PTR(retval);
+			}
+		} else	/* Returns with the tty_lock held for now */
+			tty = tty_init_dev(driver, index);
 
-	mutex_unlock(&tty_mutex);
-	if (driver)
+		mutex_unlock(&tty_mutex);
 		tty_driver_kref_put(driver);
+	}
+
 	if (IS_ERR(tty)) {
 		retval = PTR_ERR(tty);
 		goto err_file;
-- 
2.1.3

