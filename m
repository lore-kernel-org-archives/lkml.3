Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaJMMJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:09:54 -0400
Received: from fm2nodo1.polito.it ([130.192.180.12]:57594 "EHLO
	fm2nodo1.polito.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbaJMMJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:09:52 -0400
X-AttachExt: p7s
X-ExtScanner: Niversoft's FindAttachments (free)
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, jmorris@namei.org,
        Roberto Sassu <roberto.sassu@polito.it>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH-v4 1/5] ima: added error messages to template-related functions
Date: Mon, 13 Oct 2014 14:08:38 +0200
Message-Id: <1413202125-7062-2-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413202125-7062-1-git-send-email-roberto.sassu@polito.it>
References: <1413202125-7062-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----884690C5B65D152D3A2689A3A486CA74"
X-FEAS-SYSTEM-WL: 130.192.180.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------884690C5B65D152D3A2689A3A486CA74

This patch adds some error messages to inform users about the following
events: template descriptor not found, invalid template descriptor,
template field not found and template initialization failed.

Changelog:
 - v2:
   - display an error message if the format string contains too many
     fields (Roberto Sassu)

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_template.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index e854862..1310afc 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -52,8 +52,11 @@ static int __init ima_template_setup(char *str)
 	 * If not, use CONFIG_IMA_DEFAULT_TEMPLATE.
 	 */
 	template_desc = lookup_template_desc(str);
-	if (!template_desc)
+	if (!template_desc) {
+		pr_err("template %s not found, using %s\n",
+		       str, CONFIG_IMA_DEFAULT_TEMPLATE);
 		return 1;
+	}
 
 	/*
 	 * Verify whether the current hash algorithm is supported
@@ -117,8 +120,11 @@ static int template_desc_init_fields(const char *template_fmt,
 	int template_num_fields = template_fmt_size(template_fmt);
 	int i, result = 0;
 
-	if (template_num_fields > IMA_TEMPLATE_NUM_FIELDS_MAX)
+	if (template_num_fields > IMA_TEMPLATE_NUM_FIELDS_MAX) {
+		pr_err("format string '%s' contains too many fields\n",
+		       template_fmt);
 		return -EINVAL;
+	}
 
 	/* copying is needed as strsep() modifies the original buffer */
 	template_fmt_copy = kstrdup(template_fmt, GFP_KERNEL);
@@ -137,6 +143,7 @@ static int template_desc_init_fields(const char *template_fmt,
 		struct ima_template_field *f = lookup_template_field(c);
 
 		if (!f) {
+			pr_err("field '%s' not found\n", c);
 			result = -ENOENT;
 			goto out;
 		}
@@ -163,8 +170,13 @@ struct ima_template_desc *ima_template_desc_current(void)
 int __init ima_init_template(void)
 {
 	struct ima_template_desc *template = ima_template_desc_current();
+	int result;
 
-	return template_desc_init_fields(template->fmt,
-					 &(template->fields),
-					 &(template->num_fields));
+	result = template_desc_init_fields(template->fmt,
+					   &(template->fields),
+					   &(template->num_fields));
+	if (result < 0)
+		pr_err("template %s init failed, result: %d\n", template->name);
+
+	return result;
 }
-- 
1.9.3


------884690C5B65D152D3A2689A3A486CA74
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNDEwMTMxMjA5MjdaMCMGCSqG
SIb3DQEJBDEWBBTKDMmbcm5sPKe3jyJ/bN3JsSjWwjB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQDDJuYa3H4nmalk8foBKg2W0mkq
Q8pAdWHS7mdpKmuQuz5+p0mErlSvkCxz1PcSIEckGOj82xmrFTEAJKJxdJrmvWpz
kNBKDgNCwKEtRgZZJWCLuXt9xz/qoQpGZaS4l2WTXEKiKVfYEXJakGVHDak5xxgi
ZpNiaWZumz8R0Wy5Xun32V11Ag+ehUcJRDOad/tvxVq+slw7XN7b79/CLQ3OiFrR
PlNGtRTwf3iCADex7hvo6KEfx7eeRXS7cuu33FoNFeiDW9qNEblcFtFdWBM382ih
6sD/AHtNPZOY6q63o6MXNAqLv0A+NFzOp0LFO34a9DikIiaucNGt7cPTJwuH

------884690C5B65D152D3A2689A3A486CA74--


