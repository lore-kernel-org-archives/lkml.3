Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaJMMJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:09:59 -0400
Received: from fm1nodo5.polito.it ([130.192.180.13]:37200 "EHLO
	fm1nodo5.polito.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaJMMJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:09:56 -0400
X-AttachExt: p7s
X-ExtScanner: Niversoft's FindAttachments (free)
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, jmorris@namei.org,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH-v4 3/5] ima: don't allocate a copy of template_fmt in template_desc_init_fields()
Date: Mon, 13 Oct 2014 14:08:40 +0200
Message-Id: <1413202125-7062-4-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413202125-7062-1-git-send-email-roberto.sassu@polito.it>
References: <1413202125-7062-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----FE574AE16BE66E2A7F5D420E5D195329"
X-FEAS-SYSTEM-WL: 130.192.180.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------FE574AE16BE66E2A7F5D420E5D195329

This patch removes the allocation of a copy of 'template_fmt', needed for
iterating over all fields in the passed template format string. The removal
was possible by replacing strcspn(), which modifies the passed string,
with strchrnul(). The currently processed template field is copied in
a temporary variable.

The purpose of this change is use template_desc_init_fields() in two ways:
for just validating a template format string (the function should work
if called by a setup function, when memory cannot be allocated), and for
actually initializing a template descriptor. The implementation of this
feature will be complete with the next patch.

Changelog:
 - v3:
   - added 'goto out' in template_desc_init_fields() to free allocated
     memory if a template field length is not valid (suggested by
     Mimi Zohar)

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima_template.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index b7b359c..d93a58e 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -116,9 +116,9 @@ static int template_desc_init_fields(const char *template_fmt,
 				     struct ima_template_field ***fields,
 				     int *num_fields)
 {
-	char *c, *template_fmt_copy, *template_fmt_ptr;
+	const char *template_fmt_ptr;
 	int template_num_fields = template_fmt_size(template_fmt);
-	int i, result = 0;
+	int i, len, result = 0;
 
 	if (template_num_fields > IMA_TEMPLATE_NUM_FIELDS_MAX) {
 		pr_err("format string '%s' contains too many fields\n",
@@ -126,24 +126,29 @@ static int template_desc_init_fields(const char *template_fmt,
 		return -EINVAL;
 	}
 
-	/* copying is needed as strsep() modifies the original buffer */
-	template_fmt_copy = kstrdup(template_fmt, GFP_KERNEL);
-	if (template_fmt_copy == NULL)
-		return -ENOMEM;
-
 	*fields = kzalloc(template_num_fields * sizeof(*fields), GFP_KERNEL);
 	if (*fields == NULL) {
 		result = -ENOMEM;
 		goto out;
 	}
 
-	template_fmt_ptr = template_fmt_copy;
-	for (i = 0; (c = strsep(&template_fmt_ptr, "|")) != NULL &&
-	     i < template_num_fields; i++) {
-		struct ima_template_field *f = lookup_template_field(c);
+	for (i = 0, template_fmt_ptr = template_fmt; i < template_num_fields;
+	     i++, template_fmt_ptr += len + 1) {
+		char tmp_field_id[IMA_TEMPLATE_FIELD_ID_MAX_LEN + 1];
+		struct ima_template_field *f;
+
+		len = strchrnul(template_fmt_ptr, '|') - template_fmt_ptr;
+		if (len == 0 || len > IMA_TEMPLATE_FIELD_ID_MAX_LEN) {
+			pr_err("Invalid field with length %d\n", len);
+			result = -EINVAL;
+			goto out;
+		}
 
+		memcpy(tmp_field_id, template_fmt_ptr, len);
+		tmp_field_id[len] = '\0';
+		f = lookup_template_field(tmp_field_id);
 		if (!f) {
-			pr_err("field '%s' not found\n", c);
+			pr_err("field '%s' not found\n", tmp_field_id);
 			result = -ENOENT;
 			goto out;
 		}
@@ -155,7 +160,6 @@ out:
 		kfree(*fields);
 		*fields = NULL;
 	}
-	kfree(template_fmt_copy);
 	return result;
 }
 
-- 
1.9.3


------FE574AE16BE66E2A7F5D420E5D195329
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNDEwMTMxMjA5MzVaMCMGCSqG
SIb3DQEJBDEWBBRkY1Pd/UhKZupaDNPyBemxiu4mJjB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQAVM+JSsgZRb1YLMG2DxhscJuhO
yifzHS/yTZ5pg086q7As/hhaIhroj12q+UA4VnvepRkOddVcay2Eqf5DFR29eS2y
tVG3ju07vpFqO8/xUKGKe+AejtkYXDP5/r41sW3AS3VxiktfS1r0B1rjpJ6AjR50
4qUixYrgTZB0glBnuDNi5LDZqtQgiVkczfA2fF1NclWCP2Cjw5Ra7vDyHKMyN53U
eJg1NnXyBvgKT8R7qbqWszpP6NQuFWg2eajPy22KiHsHD98GyF7qPVsC7Jpy9J/E
c2XrG3Qz5egQ+jdA28DwTynwhVQI+DEnqBa9NCue2TGY2mouNDf9/5vAEsd8

------FE574AE16BE66E2A7F5D420E5D195329--


