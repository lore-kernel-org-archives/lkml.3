Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523AbbA1EZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:25:05 -0500
Received: from mail.kernel.org ([198.145.29.136]:40909 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933897AbbA1EZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:25:00 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 141/177] tty: Prevent "read/write wait queue active!" log flooding
Date: Wed, 28 Jan 2015 12:09:59 +0800
Message-Id: <1422418236-12852-232-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 494c1eac7e73f719af9d474a96ec8494c33efd6a upstream.

Only print one warning when a task is on the read_wait or write_wait
wait queue at final tty release.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/tty/tty_io.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 2d66beed..a07eb4c 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1634,6 +1634,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	int	idx;
 	char	buf[64];
 	long	timeout = 0;
+	int	once = 1;
 
 	if (tty_paranoia_check(tty, inode, __func__))
 		return 0;
@@ -1714,8 +1715,11 @@ int tty_release(struct inode *inode, struct file *filp)
 		if (!do_sleep)
 			break;
 
-		printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
+		if (once) {
+			once = 0;
+			printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
 				__func__, tty_name(tty, buf));
+		}
 		tty_unlock();
 		mutex_unlock(&tty_mutex);
 		schedule_timeout_killable(timeout);
-- 
1.9.1

