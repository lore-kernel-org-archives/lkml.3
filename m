Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3KONtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:49:24 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:35379 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab3KONrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:47:40 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 3/6] ima: remove unneeded size_limit argument from ima_eventdigest_init_common()
Date: Fri, 15 Nov 2013 14:45:41 +0100
Message-Id: <1384523146-9290-4-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384523146-9290-1-git-send-email-roberto.sassu@polito.it>
References: <1384523146-9290-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----2C1FC58227FBFF80ECBDB65C7EFCFFAF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------2C1FC58227FBFF80ECBDB65C7EFCFFAF

This patch removes the 'size_limit' argument
from ima_eventdigest_init_common(). Since the 'd' field will never include
the hash algorithm as prefix and the 'd-ng' will always have it, we can
use the hash algorithm to differentiate the two cases in the modified
function (it is equal to HASH_ALGO__LAST in the first case, the opposite
in the second).

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_template_lib.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 4752a53..6d01c69 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -158,8 +158,7 @@ void ima_show_template_sig(struct seq_file *m, enum ima_show_type show,
 }
 
 static int ima_eventdigest_init_common(u8 *digest, u32 digestsize, u8 hash_algo,
-				       struct ima_field_data *field_data,
-				       bool size_limit)
+				       struct ima_field_data *field_data)
 {
 	/*
 	 * digest formats:
@@ -172,11 +171,10 @@ static int ima_eventdigest_init_common(u8 *digest, u32 digestsize, u8 hash_algo,
 	enum data_formats fmt = DATA_FMT_DIGEST;
 	u32 offset = 0;
 
-	if (!size_limit) {
+	if (hash_algo < HASH_ALGO__LAST) {
 		fmt = DATA_FMT_DIGEST_WITH_ALGO;
-		if (hash_algo < HASH_ALGO__LAST)
-			offset += snprintf(buffer, CRYPTO_MAX_ALG_NAME + 1,
-					   "%s", hash_algo_name[hash_algo]);
+		offset += snprintf(buffer, CRYPTO_MAX_ALG_NAME + 1, "%s",
+				   hash_algo_name[hash_algo]);
 		buffer[offset] = ':';
 		offset += 2;
 	}
@@ -240,7 +238,7 @@ int ima_eventdigest_init(struct integrity_iint_cache *iint, struct file *file,
 	cur_digestsize = hash.hdr.length;
 out:
 	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
-					   HASH_ALGO__LAST, field_data, true);
+					   HASH_ALGO__LAST, field_data);
 }
 
 /*
@@ -264,7 +262,7 @@ int ima_eventdigest_ng_init(struct integrity_iint_cache *iint,
 	hash_algo = iint->ima_hash->algo;
 out:
 	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
-					   hash_algo, field_data, false);
+					   hash_algo, field_data);
 }
 
 static int ima_eventname_init_common(struct integrity_iint_cache *iint,
-- 
1.8.1.4


------2C1FC58227FBFF80ECBDB65C7EFCFFAF
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMTUxMzQ2MTBaMCMGCSqG
SIb3DQEJBDEWBBQ3kAPODfM31zmOR0iBgOJjzVAkkjB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQBw18CGJSHraq2pE6PcHu+0OZAc
ng7trT7xwc0fIFpHvIn5On2JCtXlzisQNH7Q6D5Es9ZGV5gCgIovACj9UB0PCrTI
kh+TASlulg0M38Enj0jvb65qrIYCghMTWXpDX9Zk6be7OoFTRo2Zzz/1w+tILEoI
n9iUBYESS6kpxu8of4AIoiY+kFl5EiO8iHQijis2v7pcQhVNnowCNZewrpuilxWX
Ra4HWcZ/4LIODKy7iIpZ/Bm9p7oVS/MHVWOzivVX282FWKd3ujODN/m8wRPz9h70
lXegmkZzASOZHQzEoBkK02GNfL28cIdW464gzp5InE3QlezwF4EqM9H2kDGn

------2C1FC58227FBFF80ECBDB65C7EFCFFAF--


