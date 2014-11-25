Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbaKYL5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:57:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58158 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbaKYKkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 040/254] tty: Prevent "read/write wait queue active!" log flooding
Date: Tue, 25 Nov 2014 10:36:30 +0000
Message-Id: <1416912004-5928-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 494c1eac7e73f719af9d474a96ec8494c33efd6a upstream.

Only print one warning when a task is on the read_wait or write_wait
wait queue at final tty release.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/tty_io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index fd682252bbac..fd4095cd4bd6 100644
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
2.1.0

