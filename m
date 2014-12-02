Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746AbaLBT0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:26:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46966 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933624AbaLBT0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 038/121] tty: Prevent "read/write wait queue active!" log flooding
Date: Tue,  2 Dec 2014 11:18:37 -0800
Message-Id: <1417548000-1794-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 494c1eac7e73f719af9d474a96ec8494c33efd6a upstream.

Only print one warning when a task is on the read_wait or write_wait
wait queue at final tty release.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/tty_io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 25d0741..da7d0a2 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1702,6 +1702,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	int	idx;
 	char	buf[64];
 	long	timeout = 0;
+	int	once = 1;
 
 	if (tty_paranoia_check(tty, inode, __func__))
 		return 0;
@@ -1782,8 +1783,11 @@ int tty_release(struct inode *inode, struct file *filp)
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
1.9.1

