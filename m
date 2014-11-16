Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaKPWLc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:11:32 -0500
Received: from 1wt.eu ([62.212.114.60]:47918 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbaKPWAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:48 -0500
Message-Id: <20141116215330.102407774@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:54:03 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 35/48] tty: Fix high cpu load if tty is unreleaseable
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

Kernel oops can cause the tty to be unreleaseable (for example, if
n_tty_read() crashes while on the read_wait queue). This will cause
tty_release() to endlessly loop without sleeping.

Use a killable sleep timeout which grows by 2n+1 jiffies over the interval
[0, 120 secs.) and then jumps to forever (but still killable).

NB: killable just allows for the task to be rewoken manually, not
to be terminated.

Cc: <stable@vger.kernel.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 37b164578826406a173ca7c20d9ba7430134d23e)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/tty_io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 123cedf..cbdd169 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1482,6 +1482,7 @@ void tty_release_dev(struct file *filp)
 	int	devpts;
 	int	idx;
 	char	buf[64];
+	long	timeout = 0;
 	struct 	inode *inode;
 
 	inode = filp->f_path.dentry->d_inode;
@@ -1602,7 +1603,11 @@ void tty_release_dev(struct file *filp)
 		printk(KERN_WARNING "tty_release_dev: %s: read/write wait queue "
 				    "active!\n", tty_name(tty, buf));
 		mutex_unlock(&tty_mutex);
-		schedule();
+		schedule_timeout_killable(timeout);
+		if (timeout < 120 * HZ)
+			timeout = 2 * timeout + 1;
+		else
+			timeout = MAX_SCHEDULE_TIMEOUT;
 	}
 
 	/*
-- 
1.7.12.2.21.g234cd45.dirty



