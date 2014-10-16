Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaJPRzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:55:16 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:39361 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751864AbaJPRzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:55:13 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] tty: Prevent "read/write wait queue active!" log flooding
Date: Thu, 16 Oct 2014 13:54:36 -0400
Message-Id: <1413482076-14302-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only print one warning when a task is on the read_wait or write_wait
wait queue at final tty release.

Cc: <stable@vger.kernel.org> # 3.4.x+
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 1019025..cf7c9b8 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1709,6 +1709,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	int	idx;
 	char	buf[64];
 	long	timeout = 0;
+	int	once = 1;
 
 	if (tty_paranoia_check(tty, inode, __func__))
 		return 0;
@@ -1789,8 +1790,11 @@ int tty_release(struct inode *inode, struct file *filp)
 		if (!do_sleep)
 			break;
 
-		printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
-				__func__, tty_name(tty, buf));
+		if (once) {
+			once = 0;
+			printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
+			       __func__, tty_name(tty, buf));
+		}
 		tty_unlock_pair(tty, o_tty);
 		mutex_unlock(&tty_mutex);
 		schedule_timeout_killable(timeout);
-- 
2.1.1

