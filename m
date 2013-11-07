Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab3KGPvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:51:52 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:50936 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3KGPvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:51:47 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 4/6] ima: replace ima_template_desc_current() with ima_get_template_desc()
Date: Thu,  7 Nov 2013 16:49:39 +0100
Message-Id: <1383839383-18152-5-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383839383-18152-1-git-send-email-roberto.sassu@polito.it>
References: <1383839383-18152-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----00ABDC4C8CB84FAE4C93BEBB78BD5A26"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------00ABDC4C8CB84FAE4C93BEBB78BD5A26

This patch replaces calls to ima_template_desc_current() in ima_api.c
and ima_main.c with ima_get_template_desc() as the former function
is called by the latter when passed arguments are both NULL. The patch
also declares the former function as static so that it will not be
longer available outside ima_template.c.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima.h          | 1 -
 security/integrity/ima/ima_api.c      | 3 ++-
 security/integrity/ima/ima_main.c     | 6 ++++--
 security/integrity/ima/ima_template.c | 2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index d7b4c19..f72c488 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -106,7 +106,6 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 int ima_init_crypto(void);
 void ima_putc(struct seq_file *m, void *data, int datalen);
 void ima_print_digest(struct seq_file *m, u8 *digest, int size);
-struct ima_template_desc *ima_template_desc_current(void);
 struct ima_template_desc *ima_get_template_desc(char *template_name,
 						char *template_fmt);
 int ima_init_template(void);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 0e75408..f10328d 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -29,9 +29,10 @@ int ima_alloc_init_template(struct integrity_iint_cache *iint,
 			    struct evm_ima_xattr_data *xattr_value,
 			    int xattr_len, struct ima_template_entry **entry)
 {
-	struct ima_template_desc *template_desc = ima_template_desc_current();
+	struct ima_template_desc *template_desc;
 	int i, result = 0;
 
+	template_desc = ima_get_template_desc(NULL, NULL);
 	*entry = kzalloc(sizeof(**entry) + template_desc->num_fields *
 			 sizeof(struct ima_field_data), GFP_NOFS);
 	if (!*entry)
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 149ee11..6e1d3db 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -41,12 +41,13 @@ static int hash_setup_done;
 
 static int __init hash_setup(char *str)
 {
-	struct ima_template_desc *template_desc = ima_template_desc_current();
+	struct ima_template_desc *template_desc;
 	int i;
 
 	if (hash_setup_done)
 		return 1;
 
+	template_desc = ima_get_template_desc(NULL, NULL);
 	if (strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0) {
 		if (strncmp(str, "sha1", 4) == 0)
 			ima_hash_algo = HASH_ALGO_SHA1;
@@ -166,7 +167,7 @@ static int process_measurement(struct file *file, const char *filename,
 {
 	struct inode *inode = file_inode(file);
 	struct integrity_iint_cache *iint;
-	struct ima_template_desc *template_desc = ima_template_desc_current();
+	struct ima_template_desc *template_desc;
 	char *pathbuf = NULL;
 	const char *pathname = NULL;
 	int rc = -ENOMEM, action, must_appraise, _func;
@@ -210,6 +211,7 @@ static int process_measurement(struct file *file, const char *filename,
 		goto out_digsig;
 	}
 
+	template_desc = ima_get_template_desc(NULL, NULL);
 	if (strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0) {
 		if (action & IMA_APPRAISE_SUBMASK)
 			xattr_ptr = &xattr_value;
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 7daf2ba..f66e06d 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -240,7 +240,7 @@ static int init_defined_templates(void)
 	return result;
 }
 
-struct ima_template_desc *ima_template_desc_current(void)
+static struct ima_template_desc *ima_template_desc_current(void)
 {
 	if (!ima_template)
 		ima_template =
-- 
1.8.1.4


------00ABDC4C8CB84FAE4C93BEBB78BD5A26
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMDcxNTUwMjFaMCMGCSqG
SIb3DQEJBDEWBBSa7NlqUxFjXXiJwYe2fqTpXRfzUzB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCL1uxo6yJhT4pgIC7YAvyQeu17
21lhCdMcde/m3X2ocxSHYADbD9xZ8h0u15d9c0hl4pfYpoYVBXOg/yxDWXownHFi
nIUlPNLNYAYCVwMPRehKZKXRIg4e/NRJ8K9rsGHcTR6pof3hOR0aJaKbRLm0rZ/J
rQPMhrkuIIePwdRP3kI0MKlRagrgnzl3z8wf/e5+B6gPqx4+cVQiqqFMneFN4krA
8AAHJhBB4Ttc85reCUt9PTW+f+9KhYl/JBaryhFOvuEkhn6jshGKwV5+tqGw3tEu
doqFJh++RhvvK7T0ZJdeYikmX8bLA97QQHLpzPSzs7EaBdxOJTDn14o7QfJj

------00ABDC4C8CB84FAE4C93BEBB78BD5A26--


