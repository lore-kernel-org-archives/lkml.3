Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab3KSMg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 07:36:27 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:52923 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab3KSMgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:36:23 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH-v2 5/6] ima: pass template descriptor to ima_alloc_init_template()
Date: Tue, 19 Nov 2013 13:33:44 +0100
Message-Id: <1384864428-3895-6-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384864428-3895-1-git-send-email-roberto.sassu@polito.it>
References: <1384864428-3895-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----8BD176EBFF04B5264CB6183F112325A4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------8BD176EBFF04B5264CB6183F112325A4

This patch adds the template descriptor as a new argument to the function
ima_alloc_init_template() so that callers can specify the format of the
new measurement entry being generated.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima.h      |  6 ++++--
 security/integrity/ima/ima_api.c  | 15 ++++++++++-----
 security/integrity/ima/ima_init.c |  3 ++-
 security/integrity/ima/ima_main.c |  2 +-
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 632d92e..fc2fbf3 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -142,13 +142,15 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
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
+			    int xattr_len,
+			    struct ima_template_desc *template_desc,
+			    struct ima_template_entry **entry);
 int ima_store_template(struct ima_template_entry *entry, int violation,
 		       struct inode *inode, const unsigned char *filename);
 const char *ima_d_path(struct path *path, char **pathbuf);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 8037484..444ec53 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -27,11 +27,15 @@
 int ima_alloc_init_template(struct integrity_iint_cache *iint,
 			    struct file *file, const unsigned char *filename,
 			    struct evm_ima_xattr_data *xattr_value,
-			    int xattr_len, struct ima_template_entry **entry)
+			    int xattr_len,
+			    struct ima_template_desc *template_desc,
+			    struct ima_template_entry **entry)
 {
-	struct ima_template_desc *template_desc = ima_template_desc_current();
 	int i, result = 0;
 
+	if (template_desc == NULL)
+		return -EINVAL;
+
 	*entry = kzalloc(sizeof(**entry) + template_desc->num_fields *
 			 sizeof(struct ima_field_data), GFP_NOFS);
 	if (!*entry)
@@ -120,6 +124,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 {
 	struct ima_template_entry *entry;
 	struct inode *inode = file->f_dentry->d_inode;
+	struct ima_template_desc *desc = ima_template_desc_current();
 	int violation = 1;
 	int result;
 
@@ -127,7 +132,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 	atomic_long_inc(&ima_htable.violations);
 
 	result = ima_alloc_init_template(NULL, file, filename,
-					 NULL, 0, &entry);
+					 NULL, 0, desc, &entry);
 	if (result < 0) {
 		result = -ENOMEM;
 		goto err_out;
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
index 15f34bd..3a4df15 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -44,6 +44,7 @@ static void __init ima_add_boot_aggregate(void)
 {
 	struct ima_template_entry *entry;
 	struct integrity_iint_cache tmp_iint, *iint = &tmp_iint;
+	struct ima_template_desc *desc = ima_template_desc_current();
 	const char *op = "add_boot_aggregate";
 	const char *audit_cause = "ENOMEM";
 	int result = -ENOMEM;
@@ -69,7 +70,7 @@ static void __init ima_add_boot_aggregate(void)
 	}
 
 	result = ima_alloc_init_template(iint, NULL, boot_aggregate_name,
-					 NULL, 0, &entry);
+					 NULL, 0, desc, &entry);
 	if (result < 0)
 		return;
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 149ee11..e08ce72 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -226,7 +226,7 @@ static int process_measurement(struct file *file, const char *filename,
 
 	if (action & IMA_MEASURE)
 		ima_store_measurement(iint, file, pathname,
-				      xattr_value, xattr_len);
+				      xattr_value, xattr_len, template_desc);
 	if (action & IMA_APPRAISE_SUBMASK)
 		rc = ima_appraise_measurement(_func, iint, file, pathname,
 					      xattr_value, xattr_len);
-- 
1.8.1.4


------8BD176EBFF04B5264CB6183F112325A4
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMTkxMjM0NTFaMCMGCSqG
SIb3DQEJBDEWBBTXABZHvTTMVon8l02/F6Gjky6NbTB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCGAglTtGea2HA4Rdk7EwuoD0AX
qXjcm0OxIZEX3tiO7wFhqXpsxEC4fvi42VV75311msWcnxlbjlVJxth1yfFaB1dz
Cy18IwwXIlkzfzD4DGWKl0V7AfnzP/7/MBnU59RxSl2YW1hGLofiMpfvuvUVovoG
3sIJtJl0KYGQ7damBZXY7zFAvIxocG8B3Z3afSvREGTcFweHtJL6LEFfyAZa1ty+
sHi0Hb3An9i/lhpHd5fF+teJqT8I9lfmdj67BOT0bk7SRNKZCUylza2JikwjC6lh
583N35w+tu3Vz9Qo7l6a8tCtTNX/jZb5b8v2GYcEPaFfovbIg0LK3EG2Dv+v

------8BD176EBFF04B5264CB6183F112325A4--


