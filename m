Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbaICHX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:23:26 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22683 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbaICHXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:23:24 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-e2-5406c1e9be6d
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 4/8] ima: remove unnecessary extra variable
Date: Wed, 03 Sep 2014 10:19:57 +0300
Message-id: <cce196548e1db736486e0cfff8f6b06230d23a00.1409728712.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e/4Vd2XB9lCDNp6xS1u/d3LbPFlaZ3F
	yxnz2C0u75rDZvGh5xGbxacVk5gd2Dx2zrrL7vHg0GYWj90LPjN59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8aurl3MBbv5K35v/cDUwHiFp4uRk0NCwERi+tz1jBC2mMSFe+vZQGwhgaWM
	ElNPCUHYnUwSG15lg9hsAnoSG5p/sIPYIgI5EpPOXGAGsZkF0iU+TeoFiwsLWEv8/vAGzGYR
	UJV4tnkm2ExegTiJGZMuMUPskpM4eWwyaxcjBwengJXEvKNaEKssJdqvLmPEITyBkX8BI8Mq
	RtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJCQ+7qDcekxq0OMAhyMSjy8EYJsIUKsiWXFlbmH
	GCU4mJVEeH0TgUK8KYmVValF+fFFpTmpxYcYmTg4pRoYDWY9/lD6/Jx5UPyiGZZTTm/eFmVr
	966ioKnKbcqOl2nK+rzKdw48nWUSJqZ4V/8pz6J40Sd+dv3Hql9wVd/inulUfDb66sqP7GsE
	zjR7H66ZMuXGxJWf5vSEHvDiqGTUvvdjhtjJQ6mSopGVR216ruVO2jH3zsNnOTE/k5ga1zk8
	l9DannzBRImlOCPRUIu5qDgRAIdAo2gXAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'function' variable value can be changed instead of
allocating extra '_func' variable.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index f7b85bf..aaf5552 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -164,7 +164,7 @@ static int process_measurement(struct file *file, const char *filename,
 	struct ima_template_desc *template_desc;
 	char *pathbuf = NULL;
 	const char *pathname = NULL;
-	int rc = -ENOMEM, action, must_appraise, _func;
+	int rc = -ENOMEM, action, must_appraise;
 	struct evm_ima_xattr_data *xattr_value = NULL, **xattr_ptr = NULL;
 	int xattr_len = 0;
 
@@ -182,7 +182,8 @@ static int process_measurement(struct file *file, const char *filename,
 	must_appraise = action & IMA_APPRAISE;
 
 	/*  Is the appraise rule hook specific?  */
-	_func = (action & IMA_FILE_APPRAISE) ? FILE_CHECK : function;
+	if (action & IMA_FILE_APPRAISE)
+		function = FILE_CHECK;
 
 	mutex_lock(&inode->i_mutex);
 
@@ -201,7 +202,7 @@ static int process_measurement(struct file *file, const char *filename,
 	/* Nothing to do, just return existing appraised status */
 	if (!action) {
 		if (must_appraise)
-			rc = ima_get_cache_status(iint, _func);
+			rc = ima_get_cache_status(iint, function);
 		goto out_digsig;
 	}
 
@@ -223,7 +224,7 @@ static int process_measurement(struct file *file, const char *filename,
 		ima_store_measurement(iint, file, pathname,
 				      xattr_value, xattr_len);
 	if (action & IMA_APPRAISE_SUBMASK)
-		rc = ima_appraise_measurement(_func, iint, file, pathname,
+		rc = ima_appraise_measurement(function, iint, file, pathname,
 					      xattr_value, xattr_len, opened);
 	if (action & IMA_AUDIT)
 		ima_audit_measurement(iint, pathname);
-- 
1.9.1

