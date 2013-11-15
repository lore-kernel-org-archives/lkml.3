Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3KONsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:48:20 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:53120 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3KONry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:47:54 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 6/6] ima: do not send field length to userspace for digest of ima template
Date: Fri, 15 Nov 2013 14:45:44 +0100
Message-Id: <1384523146-9290-7-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384523146-9290-1-git-send-email-roberto.sassu@polito.it>
References: <1384523146-9290-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----B1DD2BCDAE39B005B4248E4723F00076"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------B1DD2BCDAE39B005B4248E4723F00076

This patch defines a new value for the 'ima_show_type' enumerator
(IMA_SHOW_BINARY_NO_FIELD_LEN) to prevent that the field length
is transmitted through the 'binary_runtime_measurements' interface
for the digest field of the 'ima' template.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h              |  3 ++-
 security/integrity/ima/ima_fs.c           | 14 +++++++++++---
 security/integrity/ima/ima_template_lib.c |  6 +++++-
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index a21cf70..9636e17 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -26,7 +26,8 @@
 
 #include "../integrity.h"
 
-enum ima_show_type { IMA_SHOW_BINARY, IMA_SHOW_ASCII };
+enum ima_show_type { IMA_SHOW_BINARY, IMA_SHOW_BINARY_NO_FIELD_LEN,
+		     IMA_SHOW_ASCII };
 enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 
 /* digest size for IMA, fits SHA1 or MD5 */
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index d47a7c8..db01125 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -120,6 +120,7 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	struct ima_template_entry *e;
 	int namelen;
 	u32 pcr = CONFIG_IMA_MEASURE_PCR_IDX;
+	bool is_ima_template = false;
 	int i;
 
 	/* get entry */
@@ -145,14 +146,21 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	ima_putc(m, e->template_desc->name, namelen);
 
 	/* 5th:  template length (except for 'ima' template) */
-	if (strcmp(e->template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
+	if (strcmp(e->template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0)
+		is_ima_template = true;
+
+	if (!is_ima_template)
 		ima_putc(m, &e->template_data_len,
 			 sizeof(e->template_data_len));
 
 	/* 6th:  template specific data */
 	for (i = 0; i < e->template_desc->num_fields; i++) {
-		e->template_desc->fields[i]->field_show(m, IMA_SHOW_BINARY,
-							&e->template_data[i]);
+		enum ima_show_type show = IMA_SHOW_BINARY;
+		struct ima_template_field *field = e->template_desc->fields[i];
+
+		if (is_ima_template && strcmp(field->field_id, "d") == 0)
+			show = IMA_SHOW_BINARY_NO_FIELD_LEN;
+		field->field_show(m, show, &e->template_data[i]);
 	}
 	return 0;
 }
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 6d01c69..1683bbf 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -109,9 +109,12 @@ static void ima_show_template_data_binary(struct seq_file *m,
 					  enum data_formats datafmt,
 					  struct ima_field_data *field_data)
 {
-	ima_putc(m, &field_data->len, sizeof(u32));
+	if (show != IMA_SHOW_BINARY_NO_FIELD_LEN)
+		ima_putc(m, &field_data->len, sizeof(u32));
+
 	if (!field_data->len)
 		return;
+
 	ima_putc(m, field_data->data, field_data->len);
 }
 
@@ -125,6 +128,7 @@ static void ima_show_template_field_data(struct seq_file *m,
 		ima_show_template_data_ascii(m, show, datafmt, field_data);
 		break;
 	case IMA_SHOW_BINARY:
+	case IMA_SHOW_BINARY_NO_FIELD_LEN:
 		ima_show_template_data_binary(m, show, datafmt, field_data);
 		break;
 	default:
-- 
1.8.1.4


------B1DD2BCDAE39B005B4248E4723F00076
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMTUxMzQ2MjRaMCMGCSqG
SIb3DQEJBDEWBBQB/95T88TomthozKAGmmq3Bf3TQzB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQDBI3fz5tTDAxm9n/R/CXjiQE1a
FMKuoUuqGVpqm48LeeWw04rj5S2WzE8DCH0olf2BfkpxYOmQUaZFpmPt3C52DvMD
j6Cy2C0QHvui+n8qOaXwlkRWH+utV7lTdTa/WH+TjpiMr5LpO8GhHau/Xbyq65z6
0qBkApCf3kcVctfN47tKJTMDRKGIPmALHRXPfrdHXtDMpj+OkCKC6FY7Ug+406K7
EJOtn2uBXstI8QTW/A6QCyE5GOf5oaPqgtv1tD+SMV2N2iTubLPPAKcPe+hDG8mw
8duMHaQbsL/+WDwNDX8L+q2JaLzWUg1OS4FRtesuHHoJLOIIP/LFncCl76k8

------B1DD2BCDAE39B005B4248E4723F00076--


