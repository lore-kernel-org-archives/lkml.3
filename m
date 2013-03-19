Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab3CSAkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:40:11 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:50381 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab3CSAkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:40:09 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: ptp: Use memdup_user function
Date: Tue, 19 Mar 2013 02:39:25 +0200
Message-Id: <1363653565-16388-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used memdup_user function instead of kmalloc followed by copy_from_user.
Also, handled return error using IS_ERR and PTR_ERR.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/ptp/ptp_chardev.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 34a0c60..bd7a2ab 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -94,14 +94,9 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PTP_SYS_OFFSET:
-		sysoff = kmalloc(sizeof(*sysoff), GFP_KERNEL);
-		if (!sysoff) {
-			err = -ENOMEM;
-			break;
-		}
-		if (copy_from_user(sysoff, (void __user *)arg,
-				   sizeof(*sysoff))) {
-			err = -EFAULT;
+		sysoff = memdup_user((void __user *)arg, sizeof(*sysoff));
+		if (IS_ERR(sysoff)) {
+			err = PTR_ERR(sysoff);
 			break;
 		}
 		if (sysoff->n_samples > PTP_MAX_SAMPLES) {
-- 
1.7.9.5

