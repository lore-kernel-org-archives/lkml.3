Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaBCM5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 07:57:23 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:41707 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaBCM4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:56:35 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH 1/2] ima: restore the original behavior for sending data with ima template
Date: Mon,  3 Feb 2014 13:56:04 +0100
Message-Id: <1391432168-2752-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----F438A4633C00B5B0E3379A2C9C449EFF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------F438A4633C00B5B0E3379A2C9C449EFF

With the new template mechanism introduced in IMA since kernel 3.13,
the format of data sent through the binary_runtime_measurements interface
is slightly changed. Now, for a generic measurement, the format of
template data (after the template name) is:

template_len | field1_len | field1 | ... | fieldN_len | fieldN

In addition, fields containing a string now include the '\0' termination
character.

Instead, the format for the 'ima' template should be:

SHA1 digest | event name length | event name

It must be noted that while in the IMA 3.13 code 'event name length' is
'IMA_EVENT_NAME_LEN_MAX + 1' (256 bytes), so that the template digest
is calculated correctly, and 'event name' contains '\0', in the pre 3.13
code 'event name length' is exactly the string length and 'event name'
does not contain the termination character.

The patch restores the behavior of the IMA code pre 3.13 for the 'ima'
template so that legacy userspace tools obtain a consistent behavior
when receiving data from the binary_runtime_measurements interface
regardless of which kernel version is used.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima.h              |  2 +-
 security/integrity/ima/ima_fs.c           |  2 ++
 security/integrity/ima/ima_template_lib.c | 10 +++++++---
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 0356e1d..f79fa8b 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -27,7 +27,7 @@
 #include "../integrity.h"
 
 enum ima_show_type { IMA_SHOW_BINARY, IMA_SHOW_BINARY_NO_FIELD_LEN,
-		     IMA_SHOW_ASCII };
+		     IMA_SHOW_BINARY_OLD_STRING_FMT, IMA_SHOW_ASCII };
 enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 
 /* digest size for IMA, fits SHA1 or MD5 */
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index db01125..468a3ba 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -160,6 +160,8 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 
 		if (is_ima_template && strcmp(field->field_id, "d") == 0)
 			show = IMA_SHOW_BINARY_NO_FIELD_LEN;
+		if (is_ima_template && strcmp(field->field_id, "n") == 0)
+			show = IMA_SHOW_BINARY_OLD_STRING_FMT;
 		field->field_show(m, show, &e->template_data[i]);
 	}
 	return 0;
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index c38adcc..6ee76b0 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -109,13 +109,16 @@ static void ima_show_template_data_binary(struct seq_file *m,
 					  enum data_formats datafmt,
 					  struct ima_field_data *field_data)
 {
+	u32 len = (show == IMA_SHOW_BINARY_OLD_STRING_FMT) ?
+	    strlen(field_data->data) : field_data->len;
+
 	if (show != IMA_SHOW_BINARY_NO_FIELD_LEN)
-		ima_putc(m, &field_data->len, sizeof(u32));
+		ima_putc(m, &len, sizeof(len));
 
-	if (!field_data->len)
+	if (!len)
 		return;
 
-	ima_putc(m, field_data->data, field_data->len);
+	ima_putc(m, field_data->data, len);
 }
 
 static void ima_show_template_field_data(struct seq_file *m,
@@ -129,6 +132,7 @@ static void ima_show_template_field_data(struct seq_file *m,
 		break;
 	case IMA_SHOW_BINARY:
 	case IMA_SHOW_BINARY_NO_FIELD_LEN:
+	case IMA_SHOW_BINARY_OLD_STRING_FMT:
 		ima_show_template_data_binary(m, show, datafmt, field_data);
 		break;
 	default:
-- 
1.8.5.3


------F438A4633C00B5B0E3379A2C9C449EFF
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNDAyMDMxMjU2MDhaMCMGCSqG
SIb3DQEJBDEWBBRXehxEYy1te17k8gdP8yVUv9af3DB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQBDnf8XLbmMhA2XK4CFLsdFppVr
fXHGRmn45xjQkeKfFUSggLekclI4yZ2UnQs1vH2ecZFndYsKOE/fj2CKTvctYb4a
kEcR2ys+XgcvRz19wlgiho2icOPyZDs5IeWsaaUked6BS/X37wfKfXnnzhZXbEC6
T1Hg5f1iGFpwCMA4LlxrjQR0R/hl88AHipe2S6XI2WCuTw7ucyoA+irsF/d1kjlK
nhYT1dUeOn6bv8I4Jp0h7ZpISUzHJlSiMdiCLT7/kCI4ASR8UGNu7QlEetW3Nc/b
rPjFyNrIAsGKOf9vixKW50b1w0WVtvR9zcivyDS4kyAo4Vns2qFHvD8htFRQ

------F438A4633C00B5B0E3379A2C9C449EFF--


