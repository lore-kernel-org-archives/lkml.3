Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3KSMh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 07:37:56 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:43749 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab3KSMgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:36:13 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH-v2 3/6] ima: added ima_get_template_desc() for templates dynamic registration
Date: Tue, 19 Nov 2013 13:33:42 +0100
Message-Id: <1384864428-3895-4-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384864428-3895-1-git-send-email-roberto.sassu@polito.it>
References: <1384864428-3895-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----27B95834590406962415F09A770562C7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------27B95834590406962415F09A770562C7

This patch introduces the ima_get_template_desc() function which returns
a template descriptor depending on the template name and format passed
as arguments (at least one argument should be not NULL). If the first
argument is not NULL, the new function searches an existing template
descriptor by name among those defined and returns it to the caller.
Instead, if the second argument is not NULL and the first is NULL,
it does a template lookup by format and, if not found, creates a new one
before returning the pointer to the caller. Newly created templates
are cached to avoid duplicates.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima.h          |  2 ++
 security/integrity/ima/ima_template.c | 45 +++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 8b4a4f3..632d92e 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -109,6 +109,8 @@ int ima_init_crypto(void);
 void ima_putc(struct seq_file *m, void *data, int datalen);
 void ima_print_digest(struct seq_file *m, u8 *digest, int size);
 struct ima_template_desc *ima_template_desc_current(void);
+struct ima_template_desc *ima_get_template_desc(char *template_name,
+						char *template_fmt);
 int ima_init_template(void);
 
 int ima_init_template(void);
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index c849723..9bec7d4 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -41,6 +41,8 @@ static struct ima_template_desc *ima_template;
 static struct ima_template_desc *lookup_template_desc_by_name(const char *name);
 static struct ima_template_field *lookup_template_field(const char *field_id);
 
+static DEFINE_MUTEX(ima_templates_mutex);
+
 static int __init ima_template_setup(char *str)
 {
 	struct ima_template_desc *template_desc;
@@ -248,6 +250,49 @@ struct ima_template_desc *ima_template_desc_current(void)
 	return ima_template;
 }
 
+struct ima_template_desc *ima_get_template_desc(char *template_name,
+						char *template_fmt)
+{
+	struct ima_template_desc *desc;
+	int result;
+
+	if (template_name == NULL && template_fmt == NULL)
+		return NULL;
+
+	if (template_name)
+		desc = lookup_template_desc_by_name(template_name);
+	else {
+		mutex_lock(&ima_templates_mutex);
+		desc = lookup_template_desc_by_fmt(template_fmt);
+		if (desc == NULL) {
+			desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+			if (desc == NULL)
+				goto out_unlock;
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
+
+		list_add_tail(&desc->list, &defined_templates[0].list);
+		mutex_unlock(&ima_templates_mutex);
+	}
+
+	return desc;
+out_free_fmt:
+	kfree(desc->fmt);
+out_free:
+	kfree(desc);
+out_unlock:
+	mutex_unlock(&ima_templates_mutex);
+	return NULL;
+}
+
 int ima_init_template(void)
 {
 	int result;
-- 
1.8.1.4


------27B95834590406962415F09A770562C7
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMTkxMjM0NDFaMCMGCSqG
SIb3DQEJBDEWBBRCBv5zr4mhHbtNlBX7XHB+NV5KzDB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCffqC4phy8vsoJZl2XUTAg04CU
xk6mI7qThHouA8lutb1BqhDZSWLram7MD2g1Lx1sC8O1dCIPV2nq7iJ0NlYLWWSn
aSMqwHJH7R4RdjRj+89hn35PKAJyr9wglhITWf4b1uGOM7TpFXgV4ooO0VCVn538
Xfbufo4T66kGGGqtcXwiM9VrMPifdKoaW82etN24vPcuuvUH7nErLUYqro5Koz1J
dY1FkXLDJGXdGYl0ecr5/Q/LPU7EnPgCfSq138nHw658Hl0qJ9Bwr82o/m2XBve3
VaMA6fWmq0YXo7rcy8KVd+ik9yS2LeylLVaMuwuS59NV2qbl2RPRuctj4q2g

------27B95834590406962415F09A770562C7--


