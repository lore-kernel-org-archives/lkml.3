Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3KGPwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:52:05 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:62515 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab3KGPwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:52:00 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 6/6] ima: use custom template obtained from a matched policy rule
Date: Thu,  7 Nov 2013 16:49:41 +0100
Message-Id: <1383839383-18152-7-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383839383-18152-1-git-send-email-roberto.sassu@polito.it>
References: <1383839383-18152-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----E8E7FB19E2A2D9C8151CC69B15081FF8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------E8E7FB19E2A2D9C8151CC69B15081FF8

This patch modifies existing IMA functions to retrieve the template name
or format specified in a matched policy rule and provide it to
ima_alloc_init_template(). The latter calls ima_get_template_desc()
to obtain the template descriptor to use for creating a new measurement
entry.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima.h        | 10 ++++++----
 security/integrity/ima/ima_api.c    | 23 ++++++++++++++---------
 security/integrity/ima/ima_init.c   |  2 +-
 security/integrity/ima/ima_main.c   |  9 ++++++---
 security/integrity/ima/ima_policy.c |  7 ++++++-
 5 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index f72c488..bc7668d 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -130,7 +130,8 @@ static inline unsigned long ima_hash_key(u8 *digest)
 }
 
 /* LIM API function definitions */
-int ima_get_action(struct inode *inode, int mask, int function);
+int ima_get_action(struct inode *inode, int mask, int function,
+		   char **template_name, char **template_fmt);
 int ima_must_measure(struct inode *inode, int mask, int function);
 int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct file *file,
@@ -139,13 +140,14 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
 			   const unsigned char *filename,
 			   struct evm_ima_xattr_data *xattr_value,
-			   int xattr_len);
+			   int xattr_len, struct ima_template_desc *desc);
 void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename);
 int ima_alloc_init_template(struct integrity_iint_cache *iint,
 			    struct file *file, const unsigned char *filename,
 			    struct evm_ima_xattr_data *xattr_value,
-			    int xattr_len, struct ima_template_entry **entry);
+			    int xattr_len, struct ima_template_desc *desc,
+			    struct ima_template_entry **entry);
 int ima_store_template(struct ima_template_entry *entry, int violation,
 		       struct inode *inode, const unsigned char *filename);
 const char *ima_d_path(struct path *path, char **pathbuf);
@@ -160,7 +162,7 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 enum ima_hooks { FILE_CHECK = 1, MMAP_CHECK, BPRM_CHECK, MODULE_CHECK, POST_SETATTR };
 
 int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
-		     int flags);
+		     int flags, char **template_name, char **template_fmt);
 void ima_init_policy(void);
 void ima_update_policy(void);
 ssize_t ima_parse_add_rule(char *);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index f10328d..da70074 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -27,12 +27,15 @@
 int ima_alloc_init_template(struct integrity_iint_cache *iint,
 			    struct file *file, const unsigned char *filename,
 			    struct evm_ima_xattr_data *xattr_value,
-			    int xattr_len, struct ima_template_entry **entry)
+			    int xattr_len, struct ima_template_desc *desc,
+			    struct ima_template_entry **entry)
 {
-	struct ima_template_desc *template_desc;
+	struct ima_template_desc *template_desc = desc;
 	int i, result = 0;
 
-	template_desc = ima_get_template_desc(NULL, NULL);
+	if (template_desc == NULL)
+		template_desc = ima_get_template_desc(NULL, NULL);
+
 	*entry = kzalloc(sizeof(**entry) + template_desc->num_fields *
 			 sizeof(struct ima_field_data), GFP_NOFS);
 	if (!*entry)
@@ -127,7 +130,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 	atomic_long_inc(&ima_htable.violations);
 
 	result = ima_alloc_init_template(NULL, file, filename,
-					 NULL, 0, &entry);
+					 NULL, 0, NULL, &entry);
 	if (result < 0) {
 		result = -ENOMEM;
 		goto err_out;
@@ -156,19 +159,21 @@ err_out:
  * Returns IMA_MEASURE, IMA_APPRAISE mask.
  *
  */
-int ima_get_action(struct inode *inode, int mask, int function)
+int ima_get_action(struct inode *inode, int mask, int function,
+		   char **template_name, char **template_fmt)
 {
 	int flags = IMA_MEASURE | IMA_AUDIT | IMA_APPRAISE;
 
 	if (!ima_appraise)
 		flags &= ~IMA_APPRAISE;
 
-	return ima_match_policy(inode, function, mask, flags);
+	return ima_match_policy(inode, function, mask, flags,
+				template_name, template_fmt);
 }
 
 int ima_must_measure(struct inode *inode, int mask, int function)
 {
-	return ima_match_policy(inode, function, mask, IMA_MEASURE);
+	return ima_match_policy(inode, function, mask, IMA_MEASURE, NULL, NULL);
 }
 
 /*
@@ -245,7 +250,7 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 void ima_store_measurement(struct integrity_iint_cache *iint,
 			   struct file *file, const unsigned char *filename,
 			   struct evm_ima_xattr_data *xattr_value,
-			   int xattr_len)
+			   int xattr_len, struct ima_template_desc *desc)
 {
 	const char *op = "add_template_measure";
 	const char *audit_cause = "ENOMEM";
@@ -258,7 +263,7 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 		return;
 
 	result = ima_alloc_init_template(iint, file, filename,
-					 xattr_value, xattr_len, &entry);
+					 xattr_value, xattr_len, desc, &entry);
 	if (result < 0) {
 		integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
 				    op, audit_cause, result, 0);
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 15f34bd..8059ec9 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -69,7 +69,7 @@ static void __init ima_add_boot_aggregate(void)
 	}
 
 	result = ima_alloc_init_template(iint, NULL, boot_aggregate_name,
-					 NULL, 0, &entry);
+					 NULL, 0, NULL, &entry);
 	if (result < 0)
 		return;
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 6e1d3db..d1f372e 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -172,6 +172,7 @@ static int process_measurement(struct file *file, const char *filename,
 	const char *pathname = NULL;
 	int rc = -ENOMEM, action, must_appraise, _func;
 	struct evm_ima_xattr_data *xattr_value = NULL, **xattr_ptr = NULL;
+	char *custom_template_name = NULL, *custom_template_fmt = NULL;
 	int xattr_len = 0;
 
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
@@ -181,7 +182,8 @@ static int process_measurement(struct file *file, const char *filename,
 	 * bitmask based on the appraise/audit/measurement policy.
 	 * Included is the appraise submask.
 	 */
-	action = ima_get_action(inode, mask, function);
+	action = ima_get_action(inode, mask, function,
+				&custom_template_name, &custom_template_fmt);
 	if (!action)
 		return 0;
 
@@ -211,7 +213,8 @@ static int process_measurement(struct file *file, const char *filename,
 		goto out_digsig;
 	}
 
-	template_desc = ima_get_template_desc(NULL, NULL);
+	template_desc = ima_get_template_desc(custom_template_name,
+					      custom_template_fmt);
 	if (strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0) {
 		if (action & IMA_APPRAISE_SUBMASK)
 			xattr_ptr = &xattr_value;
@@ -228,7 +231,7 @@ static int process_measurement(struct file *file, const char *filename,
 
 	if (action & IMA_MEASURE)
 		ima_store_measurement(iint, file, pathname,
-				      xattr_value, xattr_len);
+				      xattr_value, xattr_len, template_desc);
 	if (action & IMA_APPRAISE_SUBMASK)
 		rc = ima_appraise_measurement(_func, iint, file, pathname,
 					      xattr_value, xattr_len);
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index df852ec..fee3dc1 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -261,7 +261,7 @@ static int get_subaction(struct ima_rule_entry *rule, int func)
  * change.)
  */
 int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
-		     int flags)
+		     int flags, char **template_name, char **template_fmt)
 {
 	struct ima_rule_entry *entry;
 	int action = 0, actmask = flags | (flags << 1);
@@ -274,6 +274,11 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
 		if (!ima_match_rules(entry, inode, func, mask))
 			continue;
 
+		if (template_name)
+			*template_name = entry->template_name;
+		if (template_fmt)
+			*template_fmt = entry->template_fmt;
+
 		action |= entry->flags & IMA_ACTION_FLAGS;
 
 		action |= entry->action & IMA_DO_MASK;
-- 
1.8.1.4


------E8E7FB19E2A2D9C8151CC69B15081FF8
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIIICQYJKoZIhvcNAQcCoIIH+jCCB/YCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3
DQEHAaCCBWQwggVgMIIESKADAgECAgICuzANBgkqhkiG9w0BAQUFADBlMQswCQYD
VQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQD
Ey1Qb2xpdGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
HhcNMTAxMjIwMTExOTU0WhcNMTUxMjMxMjM1OTU5WjBfMQswCQYDVQQGEwJJVDEe
MBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMRcwFQYDVQQDEw5Sb2JlcnRv
ICBTYXNzdTEXMBUGCgmSJomT8ixkAQETB2QwMjEzMDUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDS6p4SaJdmmJHJu9On9ZohhBFE2GgYiY7YtRnhhQJA
NfOtHEhSbpUMaSOfq/Pna6ipR5nAFrlM8cOGcSHZdxrPcgzeJU7F2v1fl2ThvFOc
TIkcC1aAJGQUuCaCXDlQt+KFecJWTrRZnalMHZueO+J6cgHcvR1CQz5e88dSzo3Q
XZy0w/hxGL9Ht9velqsl48ohBk2rs/svAOCp6GfqT1Yxwx1p87d3ViTrmuZB4/X+
da39nJqmo6AZ/y3Zg+r91BgNcfsHVqFT0JTcG6qRIaeqTtqVYpYl+rH1rZzYCakD
yQyys66sBvaXyaiMr0M+SpyH+LaGz5bDn5Odq16FYEq7AgMBAAGjggIeMIICGjAO
BgNVHQ8BAf8EBAMCA/gwJwYDVR0lBCAwHgYIKwYBBQUHAwIGCCsGAQUFBwMDBggr
BgEFBQcDBDAiBgNVHREEGzAZgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdDAMBgNV
HRMBAf8EAjAAMB0GA1UdDgQWBBQgKbXSXn+j769x0tsZQ9pSOzIIdDAfBgNVHSME
GDAWgBTNm1tbnup2IcQQaOjSLTfbHy/I5DCBywYDVR0gBIHDMIHAMD4GCisGAQQB
qQcBAQIwMDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9j
cHMvMS4yLzBEBgorBgEEAakHAgECMDYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
aXRhbHkuZXVyb3BraS5vcmcvY2EvY3BzLzEuMi8wOAYKKwYBBAGVYgECAjAqMCgG
CCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjIvMGYGCCsGAQUF
BwEBBFowWDAhBggrBgEFBQcwAYYVaHR0cDovL29jc3AucG9saXRvLml0MDMGCCsG
AQUFBzAChidodHRwOi8vY2EucG9saXRvLml0L2NlcnRzL3BvbGl0b19jYS5jZXIw
NwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NhLnBvbGl0by5pdC9jcmwvcG9saXRv
X2NybC5jcmwwDQYJKoZIhvcNAQEFBQADggEBADMe0aHcBJXV6pMJPVVSt1Vazd8Y
LuTLO45Igs9Sb2LuaO6pvcDGvq9dEJnBhP1B+zBAK6WEA1PWb66xC4QXaJnlGZTX
S3XeBivHWm6BNOH2kNeU0HBeGZCV/n5r70TPxkEAcc7u8YY2i6CiMM428YhZK8Zj
oN9D3QNIRf4HZgh0FTbf8eL/XvBbK/oPC+Rew+Qql6M3DHnaS1q2SKUwwO/4VXA4
JsOdatFI68AMXH0Xx9UIcjRi+kvsyvwHlc0Z8AoAtfRMoIl4zFF4Qaowec2UunBK
YlqPpFTtU9czuoEP12A86nqSVsoNok2mZOeYa9IdIjeE2rfdKx6k3YNRg08xggJt
MIICaQIBATBrMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBk
aSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eQICArswCQYFKw4DAhoFAKCB2DAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMDcxNTUwMzNaMCMGCSqG
SIb3DQEJBDEWBBS936xoty3bzP2qRfefme0cTD1yHDB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQC7vKDKrQ2/bs0bbRBwLzZEW9lp
ob0lIR7+FPBZ10WwOizdSuxM1Rua0YjBaOMfPHNDB0mynQuK/vJ4WyAUt4tRHSu4
QZG6XEKiM0gg8ooEhqnCzVMnNqD08iVN7dQvmJFoDbq2+X+j0GHMdDCEguuxEmBo
wUlLyMY7NR41/q5+Xmfqd0df9KtbBIzwZBrJGYV8+ejP/+eLcimwRi1m3gKZvHJP
XsTgMCuLFat50FSDyZvwPuKTftiEdVNyi4UlYQnzg7d37lss4xWLdokRjOclame/
2gkBy5nVkFB26PiA18PV46s49bWf6CQhRXNUcwqTIuTgfl32I8cv9dgg+J62

------E8E7FB19E2A2D9C8151CC69B15081FF8--


