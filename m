Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbaAVNhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:37:24 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51598 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbaAVNhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:37:19 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 RESEND 3/8] staging/lustre/llite: pass correct pointer to obd_iocontrol()
Date: Wed, 22 Jan 2014 21:36:14 +0800
Message-Id: <1390397779-30975-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
References: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In copy_and_ioctl() use the kernel space copy as the karg to
obd_iocontrol().

Lustre-change: http://review.whamcloud.com/6274
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3283
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Sebastien Buisson <sebastien.buisson@bull.net>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/dir.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 22d0acc9..1b217c8 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1048,20 +1048,25 @@ progress:
 }
 
 
-static int copy_and_ioctl(int cmd, struct obd_export *exp, void *data, int len)
+static int copy_and_ioctl(int cmd, struct obd_export *exp,
+			  const void __user *data, size_t size)
 {
-	void *ptr;
+	void *copy;
 	int rc;
 
-	OBD_ALLOC(ptr, len);
-	if (ptr == NULL)
+	OBD_ALLOC(copy, size);
+	if (copy == NULL)
 		return -ENOMEM;
-	if (copy_from_user(ptr, data, len)) {
-		OBD_FREE(ptr, len);
-		return -EFAULT;
+
+	if (copy_from_user(copy, data, size)) {
+		rc = -EFAULT;
+		goto out;
 	}
-	rc = obd_iocontrol(cmd, exp, len, data, NULL);
-	OBD_FREE(ptr, len);
+
+	rc = obd_iocontrol(cmd, exp, size, copy, NULL);
+out:
+	OBD_FREE(copy, size);
+
 	return rc;
 }
 
-- 
1.7.9.5

