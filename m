Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbaICHXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:23:31 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63889 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbaICHX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:23:28 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-f4-5406c1edc6d8
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 7/8] ima: remove usage of filename parameter
Date: Wed, 03 Sep 2014 10:20:00 +0300
Message-id: <33e79df19a7c5347be058864339d7698b0bd167a.1409728712.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e/4Vd23B9lCDI6uMbG49Xcvs8WXpXUW
	L2fMY7e4vGsOm8WHnkdsFp9WTGJ2YPPYOesuu8eDQ5tZPHYv+Mzk0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBlPX6xlKVgnVfFt/zWmBsZzol2MHBwSAiYSPXeEuxg5gUwxiQv31rN1MXJx
	CAksZZS4sLWJFcLpZJKYtvAoG0gVm4CexIbmH+wgtohAjsSkMxeYQWxmgXSJT5N6weLCAjYS
	zTs2M4HYLAKqEhffbAGL8wrESbS/PMwOsU1O4uSxyawgR3AKWEnMO6oFEhYSsJRov7qMEYfw
	BEb+BYwMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCgu7rDsalx6wOMQpwMCrx8EYIsoUI
	sSaWFVfmHmKU4GBWEuH1TQQK8aYkVlalFuXHF5XmpBYfYmTi4JRqYNz6Zq7QS6ZZT90XV24K
	9vIxKRcp+Pk8QtNy0yWvwgpmWVtWHiZG3n8rvErWmO3XPDXxtstnzc6Dk2/dlhGc+rq7Zrmj
	f+pETtE3anrbtqYIxrwpeW25xyJKZt7P8mgdJyUfi/n3GSLcjWN2Nxyf8GLv33ll/+7sK90g
	zsVwZXXJl2kGNvYl7kosxRmJhlrMRcWJAJZMBlAYAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In all cases except ima_bprm_check() filename was not defined and
ima_d_path() was used to find full path.

ima_bprm_check() used to select between bprm->interp and bprm->filename.
Following dump demonstrates differences between using filename and interp.

bprm->filename
 filename: ./foo.sh, pathname: /root/bin/foo.sh
 filename: ./foo.sh, pathname: /bin/dash

bprm->interp
 filename: ./foo.sh, pathname: /root/bin/foo.sh
 filename: /bin/sh, pathname: /bin/dash

In both cases pathnames are the same.
This patch removes usage of filename and interp in favor of d_path.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_main.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index aaf5552..673a37e 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -156,8 +156,8 @@ void ima_file_free(struct file *file)
 	ima_check_last_writer(iint, inode, file);
 }
 
-static int process_measurement(struct file *file, const char *filename,
-			       int mask, int function, int opened)
+static int process_measurement(struct file *file, int mask, int function,
+			       int opened)
 {
 	struct inode *inode = file_inode(file);
 	struct integrity_iint_cache *iint;
@@ -218,7 +218,7 @@ static int process_measurement(struct file *file, const char *filename,
 		goto out_digsig;
 	}
 
-	pathname = filename ?: ima_d_path(&file->f_path, &pathbuf);
+	pathname = ima_d_path(&file->f_path, &pathbuf);
 
 	if (action & IMA_MEASURE)
 		ima_store_measurement(iint, file, pathname,
@@ -254,7 +254,7 @@ out:
 int ima_file_mmap(struct file *file, unsigned long prot)
 {
 	if (file && (prot & PROT_EXEC))
-		return process_measurement(file, NULL, MAY_EXEC, MMAP_CHECK, 0);
+		return process_measurement(file, MAY_EXEC, MMAP_CHECK, 0);
 	return 0;
 }
 
@@ -273,10 +273,7 @@ int ima_file_mmap(struct file *file, unsigned long prot)
  */
 int ima_bprm_check(struct linux_binprm *bprm)
 {
-	return process_measurement(bprm->file,
-				   (strcmp(bprm->filename, bprm->interp) == 0) ?
-				   bprm->filename : bprm->interp,
-				   MAY_EXEC, BPRM_CHECK, 0);
+	return process_measurement(bprm->file, MAY_EXEC, BPRM_CHECK, 0);
 }
 
 /**
@@ -292,7 +289,7 @@ int ima_bprm_check(struct linux_binprm *bprm)
 int ima_file_check(struct file *file, int mask, int opened)
 {
 	ima_rdwr_violation_check(file);
-	return process_measurement(file, NULL,
+	return process_measurement(file,
 				   mask & (MAY_READ | MAY_WRITE | MAY_EXEC),
 				   FILE_CHECK, opened);
 }
@@ -317,7 +314,7 @@ int ima_module_check(struct file *file)
 #endif
 		return 0;	/* We rely on module signature checking */
 	}
-	return process_measurement(file, NULL, MAY_EXEC, MODULE_CHECK, 0);
+	return process_measurement(file, MAY_EXEC, MODULE_CHECK, 0);
 }
 
 int ima_fw_from_file(struct file *file, char *buf, size_t size)
@@ -328,7 +325,7 @@ int ima_fw_from_file(struct file *file, char *buf, size_t size)
 			return -EACCES;	/* INTEGRITY_UNKNOWN */
 		return 0;
 	}
-	return process_measurement(file, NULL, MAY_EXEC, FIRMWARE_CHECK, 0);
+	return process_measurement(file, MAY_EXEC, FIRMWARE_CHECK, 0);
 }
 
 static int __init init_ima(void)
-- 
1.9.1

