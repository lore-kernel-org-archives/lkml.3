Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaJMMKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:10:03 -0400
Received: from fm1nodo1.polito.it ([130.192.180.11]:53447 "EHLO
	antispam.polito.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaJMMKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:10:00 -0400
X-AttachExt: p7s
X-ExtScanner: Niversoft's FindAttachments (free)
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, jmorris@namei.org,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH-v4 4/5] ima: allocate field pointers array on demand in template_desc_init_fields()
Date: Mon, 13 Oct 2014 14:08:41 +0200
Message-Id: <1413202125-7062-5-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413202125-7062-1-git-send-email-roberto.sassu@polito.it>
References: <1413202125-7062-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----BFE7051D03129C819E02136D33B8B8A3"
X-FEAS-SYSTEM-WL: 130.192.180.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------BFE7051D03129C819E02136D33B8B8A3

The allocation of a field pointers array is moved at the end of
template_desc_init_fields() and done only if the value of the 'fields'
and 'num_fields' parameters is not NULL. For just validating a template
format string, retrieved template field pointers are placed in a temporary
array.

Changelog:
 - v3:
   - do not check in this patch if 'fields' and 'num_fields' are NULL
     (suggested by Mimi Zohar)

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima_template.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index d93a58e..65117ba 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -117,8 +117,9 @@ static int template_desc_init_fields(const char *template_fmt,
 				     int *num_fields)
 {
 	const char *template_fmt_ptr;
+	struct ima_template_field *found_fields[IMA_TEMPLATE_NUM_FIELDS_MAX];
 	int template_num_fields = template_fmt_size(template_fmt);
-	int i, len, result = 0;
+	int i, len;
 
 	if (template_num_fields > IMA_TEMPLATE_NUM_FIELDS_MAX) {
 		pr_err("format string '%s' contains too many fields\n",
@@ -126,41 +127,32 @@ static int template_desc_init_fields(const char *template_fmt,
 		return -EINVAL;
 	}
 
-	*fields = kzalloc(template_num_fields * sizeof(*fields), GFP_KERNEL);
-	if (*fields == NULL) {
-		result = -ENOMEM;
-		goto out;
-	}
-
 	for (i = 0, template_fmt_ptr = template_fmt; i < template_num_fields;
 	     i++, template_fmt_ptr += len + 1) {
 		char tmp_field_id[IMA_TEMPLATE_FIELD_ID_MAX_LEN + 1];
-		struct ima_template_field *f;
 
 		len = strchrnul(template_fmt_ptr, '|') - template_fmt_ptr;
 		if (len == 0 || len > IMA_TEMPLATE_FIELD_ID_MAX_LEN) {
 			pr_err("Invalid field with length %d\n", len);
-			result = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 
 		memcpy(tmp_field_id, template_fmt_ptr, len);
 		tmp_field_id[len] = '\0';
-		f = lookup_template_field(tmp_field_id);
-		if (!f) {
+		found_fields[i] = lookup_template_field(tmp_field_id);
+		if (!found_fields[i]) {
 			pr_err("field '%s' not found\n", tmp_field_id);
-			result = -ENOENT;
-			goto out;
+			return -ENOENT;
 		}
-		(*fields)[i] = f;
 	}
+
+	*fields = kmalloc_array(i, sizeof(*fields), GFP_KERNEL);
+	if (*fields == NULL)
+		return -ENOMEM;
+
+	memcpy(*fields, found_fields, i * sizeof(*fields));
 	*num_fields = i;
-out:
-	if (result < 0) {
-		kfree(*fields);
-		*fields = NULL;
-	}
-	return result;
+	return 0;
 }
 
 struct ima_template_desc *ima_template_desc_current(void)
-- 
1.9.3


------BFE7051D03129C819E02136D33B8B8A3
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNDEwMTMxMjA5NDBaMCMGCSqG
SIb3DQEJBDEWBBSFkgBQwEUpGq4pP5+EXwT8JVZkVTB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQB6d02pqQf9I88LpADf0cu+lyGZ
uoWv7lfwM0q3MlL60Rf8SbVEqRJe1Ftk2ysUcaXJkfyBRVO5GXtFuofMfznFI+Xx
gb7keroW4QFZmuZLfJlwotOuuXkK167FRj/bjD3U5VfSQAUfnmO/Gwls3NidUdlV
J+qMUixWQ3smN4XpXCXgCcMofZCBm4VNnSWGtvDkB1jB04kqOpZU3rfmXaUcGApd
8f++YTumwvNQUfAoYr3QeMN/4ZTEehUQXDu91BRwBYAuxZOyMKpOxlPyzMe8gnuf
9rG/AlUxI6pKFxVLUvmcARP0mJI2odXVCWsHAhgztOkhKqPafaxWnKeEAmQz

------BFE7051D03129C819E02136D33B8B8A3--


