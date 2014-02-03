Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaBCM4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 07:56:55 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:39589 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaBCM4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:56:52 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH 2/2] ima: reduce memory usage when a template containing the n field is used
Date: Mon,  3 Feb 2014 13:56:05 +0100
Message-Id: <1391432168-2752-2-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391432168-2752-1-git-send-email-roberto.sassu@polito.it>
References: <1391432168-2752-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----BF1B58BF574B19C91568048B6CA8FF92"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------BF1B58BF574B19C91568048B6CA8FF92

Before this change, to correctly calculate the template digest for the
'ima' template, the event name field (id: 'n') length was set to the fixed
size of 256 bytes.

This patch reduces the length of the event name field to the string
length incremented of one (to make room for the termination character '\0')
and handles the specific case of the digest calculation for the 'ima'
template directly in ima_calc_field_array_hash_tfm().

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima_crypto.c       | 11 +++++++++--
 security/integrity/ima/ima_template_lib.c | 19 ++++---------------
 2 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index fdf60de..d8b55c9 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -161,15 +161,22 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
 		return rc;
 
 	for (i = 0; i < num_fields; i++) {
+		u8 buffer[IMA_EVENT_NAME_LEN_MAX + 1] = { 0 };
+		u8 *data_to_hash = field_data[i].data;
+		u32 datalen = field_data[i].len;
+
 		if (strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
 			rc = crypto_shash_update(&desc.shash,
 						(const u8 *) &field_data[i].len,
 						sizeof(field_data[i].len));
 			if (rc)
 				break;
+		} else if (strcmp(td->fields[i]->field_id, "n") == 0) {
+			memcpy(buffer, data_to_hash, datalen);
+			data_to_hash = buffer;
+			datalen = IMA_EVENT_NAME_LEN_MAX + 1;
 		}
-		rc = crypto_shash_update(&desc.shash, field_data[i].data,
-					 field_data[i].len);
+		rc = crypto_shash_update(&desc.shash, data_to_hash, datalen);
 		if (rc)
 			break;
 	}
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 6ee76b0..3770628 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -27,7 +27,6 @@ static bool ima_template_hash_algo_allowed(u8 algo)
 enum data_formats {
 	DATA_FMT_DIGEST = 0,
 	DATA_FMT_DIGEST_WITH_ALGO,
-	DATA_FMT_EVENT_NAME,
 	DATA_FMT_STRING,
 	DATA_FMT_HEX
 };
@@ -37,18 +36,10 @@ static int ima_write_template_field_data(const void *data, const u32 datalen,
 					 struct ima_field_data *field_data)
 {
 	u8 *buf, *buf_ptr;
-	u32 buflen;
+	u32 buflen = datalen;
 
-	switch (datafmt) {
-	case DATA_FMT_EVENT_NAME:
-		buflen = IMA_EVENT_NAME_LEN_MAX + 1;
-		break;
-	case DATA_FMT_STRING:
+	if (datafmt == DATA_FMT_STRING)
 		buflen = datalen + 1;
-		break;
-	default:
-		buflen = datalen;
-	}
 
 	buf = kzalloc(buflen, GFP_KERNEL);
 	if (!buf)
@@ -63,7 +54,7 @@ static int ima_write_template_field_data(const void *data, const u32 datalen,
 	 * split into multiple template fields (the space is the delimitator
 	 * character for measurements lists in ASCII format).
 	 */
-	if (datafmt == DATA_FMT_EVENT_NAME || datafmt == DATA_FMT_STRING) {
+	if (datafmt == DATA_FMT_STRING) {
 		for (buf_ptr = buf; buf_ptr - buf < datalen; buf_ptr++)
 			if (*buf_ptr == ' ')
 				*buf_ptr = '_';
@@ -283,8 +274,6 @@ static int ima_eventname_init_common(struct integrity_iint_cache *iint,
 {
 	const char *cur_filename = NULL;
 	u32 cur_filename_len = 0;
-	enum data_formats fmt = size_limit ?
-	    DATA_FMT_EVENT_NAME : DATA_FMT_STRING;
 
 	BUG_ON(filename == NULL && file == NULL);
 
@@ -307,7 +296,7 @@ static int ima_eventname_init_common(struct integrity_iint_cache *iint,
 		cur_filename_len = IMA_EVENT_NAME_LEN_MAX;
 out:
 	return ima_write_template_field_data(cur_filename, cur_filename_len,
-					     fmt, field_data);
+					     DATA_FMT_STRING, field_data);
 }
 
 /*
-- 
1.8.5.3


------BF1B58BF574B19C91568048B6CA8FF92
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNDAyMDMxMjU2MzdaMCMGCSqG
SIb3DQEJBDEWBBRhI8qSRk8fvcU/hABSNL954rpVJTB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQAl6XKSlJPHioh4dCxR0TXdMy3L
1Jx6KyWlPEeumwYVGVBcPaklCA3dvDFJV+HWDIttFGrqw2cCLwKrUP7BUEPVICBM
1dSp50meyAIO8ssGJMwo6Sr0vREF9WczYD9lK0TckHgYyBcC0sl1cBvFfSq/Whkv
TG+IbVlGl7247IHbMDmu0XcXUY0Z5A2YSpPyioX03WX+T/2NHmJNF56Zy08JqibM
O0f51Y0l59JNBcI+mP55QIlJT6RKn7nmtlECkYDHZRoJlqiMvLJnC8N6PEQP0M+t
lwaH51KsG6DNXuzG8g8N9ZAtJziCSKBgg4fJyUframXx1UgMBDQBDZZMmsYq

------BF1B58BF574B19C91568048B6CA8FF92--


