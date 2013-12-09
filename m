Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901Ab3LIPBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:01:53 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48715 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933807Ab3LIPAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:00:21 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 08/13] staging/lustre/llite: pass correct pointer to obd_iocontrol()
Date: Mon,  9 Dec 2013 22:57:00 +0800
Message-Id: <1386601025-422-9-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
References: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
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

