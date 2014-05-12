Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaELX2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 19:28:35 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55960 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaELX2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 19:28:33 -0400
Message-ID: <1399937259.25932.1.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC PATCH] ima: audit log files opened with O_DIRECT flag
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module <linux-security-module@vger.kernel.org>
Cc: "J. R. Okajima" <hooanon05g@gmail.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 12 May 2014 19:27:39 -0400
In-Reply-To: <1399926266.6471.25.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1399926266.6471.25.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051223-7164-0000-0000-000001B4072F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reposting unmangled version ...

As a temporary fix, do not measure, appraise, or audit files
opened with the O_DIRECT flag set.  Just audit log it.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
---
 security/integrity/ima/ima_api.c  | 10 +++++++++-
 security/integrity/ima/ima_main.c |  5 ++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index ba9e4d7..d719978 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -199,6 +199,7 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct evm_ima_xattr_data **xattr_value,
 			    int *xattr_len)
 {
+	const char *audit_cause = "failed";
 	struct inode *inode = file_inode(file);
 	const char *filename = file->f_dentry->d_name.name;
 	int result = 0;
@@ -213,6 +214,12 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	if (!(iint->flags & IMA_COLLECTED)) {
 		u64 i_version = file_inode(file)->i_version;
 
+		if (file->f_flags & O_DIRECT) {
+			audit_cause = "failed(directio)";
+			result = -EACCES;
+			goto out;
+		}
+	
 		/* use default hash algorithm */
 		hash.hdr.algo = ima_hash_algo;
 
@@ -233,9 +240,10 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 				result = -ENOMEM;
 		}
 	}
+out:
 	if (result)
 		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
-				    filename, "collect_data", "failed",
+				    filename, "collect_data", audit_cause,
 				    result, 0);
 	return result;
 }
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 654111f..3e5b732 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -214,8 +214,11 @@ static int process_measurement(struct file *file, const char *filename,
 		xattr_ptr = &xattr_value;
 
 	rc = ima_collect_measurement(iint, file, xattr_ptr, &xattr_len);
-	if (rc != 0)
+	if (rc != 0) { 
+		if (file->f_flags & O_DIRECT)
+			rc = 0;
 		goto out_digsig;
+	}
 
 	pathname = filename ?: ima_d_path(&file->f_path, &pathbuf);
 
-- 
1.8.1.4



