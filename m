Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3KGPvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:51:44 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:38431 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3KGPvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:51:40 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 3/6] ima: added ima_get_template_desc() for templates dynamic registration
Date: Thu,  7 Nov 2013 16:49:38 +0100
Message-Id: <1383839383-18152-4-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383839383-18152-1-git-send-email-roberto.sassu@polito.it>
References: <1383839383-18152-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----6DF40AE3B345A64BB7391EC8958F611A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------6DF40AE3B345A64BB7391EC8958F611A

This patch introduces the ima_get_template_desc() function which returns
a template descriptor depending on the template name and format passed
as arguments. If the first argument is not NULL, the new function
searches an existing template descriptor by name among those defined
and returns it to the caller. Instead, if the second argument is not
NULL and the first is NULL, it does a template lookup by format and,
if not found, creates a new one before returning the pointer to the
caller. Finally, if both arguments are NULL or the template creation
failed, it returns the default template descriptor.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima.h          |  2 ++
 security/integrity/ima/ima_template.c | 40 +++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 5cbe881..d7b4c19 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -107,6 +107,8 @@ int ima_init_crypto(void);
 void ima_putc(struct seq_file *m, void *data, int datalen);
 void ima_print_digest(struct seq_file *m, u8 *digest, int size);
 struct ima_template_desc *ima_template_desc_current(void);
+struct ima_template_desc *ima_get_template_desc(char *template_name,
+						char *template_fmt);
 int ima_init_template(void);
 
 int ima_init_template(void);
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index c849723..7daf2ba 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -248,6 +248,46 @@ struct ima_template_desc *ima_template_desc_current(void)
 	return ima_template;
 }
 
+struct ima_template_desc *ima_get_template_desc(char *template_name,
+						char *template_fmt)
+{
+	struct ima_template_desc *desc = NULL;
+	int result;
+
+	if (template_name == NULL && template_fmt == NULL)
+		goto out;
+
+	if (template_name) {
+		desc = lookup_template_desc_by_name(template_name);
+	} else {
+		desc = lookup_template_desc_by_fmt(template_fmt);
+		if (desc == NULL) {
+			desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+			if (desc == NULL)
+				goto out;
+		}
+		desc->name = "";
+		desc->fmt = kstrdup(template_fmt, GFP_KERNEL);
+		if (desc->fmt == NULL)
+			goto out_free;
+
+		result = template_desc_init_fields(desc->fmt, &(desc->fields),
+						   &(desc->num_fields));
+		if (result < 0)
+			goto out_free_fmt;
+	}
+out:
+	if (desc == NULL)
+		desc = ima_template_desc_current();
+	return desc;
+out_free_fmt:
+	kfree(desc->fmt);
+out_free:
+	kfree(desc);
+	desc = NULL;
+	goto out;
+}
+
 int ima_init_template(void)
 {
 	int result;
-- 
1.8.1.4


------6DF40AE3B345A64BB7391EC8958F611A
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMDcxNTUwMTVaMCMGCSqG
SIb3DQEJBDEWBBTVgDo50UZQk+PglGOHPL6ueJfsGTB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQB/ttm8RW3rqXX7dWG5IoUWRueI
j4kumW/Nrgx1n2fKy5QDWakI7h7XUeTquBY1CdeIAq0H43jEWjj8SwNVMW+bHAue
IR346UHDDqqA7khuXD/99eA4Z8aeWzBPFtnJhMEIvjmg2jr5l/NM95kSCjF4zFtT
hm0guMnYxT+dnafXnYjDsiR32ILE4DoFgJrZ/c03istLsl+y8IOlKBGPepmFw9YX
N6YlyXNTCdUL+iKzrMTg1wlY2sP7OPl+1fYNYFms9JZTDqjH9bNqS0ADCQTWt32M
JQxGTlJ4+fqF6ZFP1zD2ODJpESZksN12i6fydbBbKPO7xJbIeLYi1slz53l1

------6DF40AE3B345A64BB7391EC8958F611A--


