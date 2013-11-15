Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3KONsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:48:24 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:35572 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab3KONrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:47:51 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 5/6] ima: do not include field length in template digest calc for ima template
Date: Fri, 15 Nov 2013 14:45:43 +0100
Message-Id: <1384523146-9290-6-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384523146-9290-1-git-send-email-roberto.sassu@polito.it>
References: <1384523146-9290-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----44513CDA44CB6F2A7B249314A8AA8320"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------44513CDA44CB6F2A7B249314A8AA8320

To maintain compatibility with userspace tools, the field length must not
be included in the template digest calculation for the 'ima' template.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h        |  3 ++-
 security/integrity/ima/ima_api.c    |  1 +
 security/integrity/ima/ima_crypto.c | 20 ++++++++++++--------
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index bf03c6a..a21cf70 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -97,7 +97,8 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode,
 			   const unsigned char *filename);
 int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash);
-int ima_calc_field_array_hash(struct ima_field_data *field_data, int num_fields,
+int ima_calc_field_array_hash(struct ima_field_data *field_data,
+			      struct ima_template_desc *desc, int num_fields,
 			      struct ima_digest_data *hash);
 int __init ima_calc_boot_aggregate(struct ima_digest_data *hash);
 void ima_add_violation(struct file *file, const unsigned char *filename,
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 0e75408..8037484 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -94,6 +94,7 @@ int ima_store_template(struct ima_template_entry *entry,
 		/* this function uses default algo */
 		hash.hdr.algo = HASH_ALGO_SHA1;
 		result = ima_calc_field_array_hash(&entry->template_data[0],
+						   entry->template_desc,
 						   num_fields, &hash.hdr);
 		if (result < 0) {
 			integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index e22708b..fdf60de 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -140,6 +140,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
  * Calculate the hash of template data
  */
 static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
+					 struct ima_template_desc *td,
 					 int num_fields,
 					 struct ima_digest_data *hash,
 					 struct crypto_shash *tfm)
@@ -160,12 +161,13 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
 		return rc;
 
 	for (i = 0; i < num_fields; i++) {
-		rc = crypto_shash_update(&desc.shash,
-					 (const u8 *) &field_data[i].len,
-					 sizeof(field_data[i].len));
-		if (rc)
-			break;
-
+		if (strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
+			rc = crypto_shash_update(&desc.shash,
+						(const u8 *) &field_data[i].len,
+						sizeof(field_data[i].len));
+			if (rc)
+				break;
+		}
 		rc = crypto_shash_update(&desc.shash, field_data[i].data,
 					 field_data[i].len);
 		if (rc)
@@ -178,7 +180,8 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
 	return rc;
 }
 
-int ima_calc_field_array_hash(struct ima_field_data *field_data, int num_fields,
+int ima_calc_field_array_hash(struct ima_field_data *field_data,
+			      struct ima_template_desc *desc, int num_fields,
 			      struct ima_digest_data *hash)
 {
 	struct crypto_shash *tfm;
@@ -188,7 +191,8 @@ int ima_calc_field_array_hash(struct ima_field_data *field_data, int num_fields,
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 
-	rc = ima_calc_field_array_hash_tfm(field_data, num_fields, hash, tfm);
+	rc = ima_calc_field_array_hash_tfm(field_data, desc, num_fields,
+					   hash, tfm);
 
 	ima_free_tfm(tfm);
 
-- 
1.8.1.4


------44513CDA44CB6F2A7B249314A8AA8320
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMTUxMzQ2MTlaMCMGCSqG
SIb3DQEJBDEWBBROm260Lpws9be4QiH3MjFDpsTSsTB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQAfV/pDaY3BX1eAJyuNGLHEhJUC
mO9AlbKQ2OAaFBGYM9NBzWgiiDb2rsvB5yVQaoY81BdpSJulfvNGSIZZXA6yu8+L
3TYliJ4JVcBv6mz8JuegOKdzaGeH/Xbfk6k5UUGoNd7Q3L1Pm8eNlLLcwK6uc/Ej
aKzMGg9YMCR3U86bplmGV+WyAhI0aDOmnYwZIJjz3KwSv2fzGbszLt0RzQ5+rYsA
Lz8FkWdejmHXIMZMlV5KeWyavgDyE2qslIrj8fZ5jqAoHNTMauuoB/j6IYGeYhdE
IaL7fdvK7CnwOAkLSmo2XbMdln8Qkt7SaXn6UTvHidTLAs7DCFgbcPQaaPwq

------44513CDA44CB6F2A7B249314A8AA8320--


