Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3KGODh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:03:37 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:50576 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab3KGOC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:02:58 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 3/4] ima: display template format in meas. list if template name length is zero
Date: Thu,  7 Nov 2013 15:00:44 +0100
Message-Id: <1383832849-17125-4-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383832849-17125-1-git-send-email-roberto.sassu@polito.it>
References: <1383832849-17125-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----C34A592FBF72A5F6D6543C3E3F87D3A9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------C34A592FBF72A5F6D6543C3E3F87D3A9

With the introduction of the 'ima_template_fmt' kernel cmdline parameter,
an user can define a new template descriptor with custom format. However,
in this case, userspace tools will be unable to parse the measurements
list because the new template is unknown. For this reason, this patch
modifies the current IMA behavior to display in the list the template
format instead of the name so that a tool can extract needed information
if it can handle listed fields.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima_fs.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index d47a7c8..6db74ff 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -118,6 +118,7 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	/* the list never shrinks, so we don't need a lock here */
 	struct ima_queue_entry *qe = v;
 	struct ima_template_entry *e;
+	char *template_name;
 	int namelen;
 	u32 pcr = CONFIG_IMA_MEASURE_PCR_IDX;
 	int i;
@@ -127,6 +128,10 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	if (e == NULL)
 		return -1;
 
+	template_name = e->template_desc->name;
+	if (strlen(e->template_desc->name) == 0)
+		template_name = e->template_desc->fmt;
+
 	/*
 	 * 1st: PCRIndex
 	 * PCR used is always the same (config option) in
@@ -138,14 +143,14 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	ima_putc(m, e->digest, TPM_DIGEST_SIZE);
 
 	/* 3rd: template name size */
-	namelen = strlen(e->template_desc->name);
+	namelen = strlen(template_name);
 	ima_putc(m, &namelen, sizeof namelen);
 
 	/* 4th:  template name */
-	ima_putc(m, e->template_desc->name, namelen);
+	ima_putc(m, template_name, namelen);
 
 	/* 5th:  template length (except for 'ima' template) */
-	if (strcmp(e->template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
+	if (strcmp(template_name, IMA_TEMPLATE_IMA_NAME) != 0)
 		ima_putc(m, &e->template_data_len,
 			 sizeof(e->template_data_len));
 
@@ -190,6 +195,7 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 	/* the list never shrinks, so we don't need a lock here */
 	struct ima_queue_entry *qe = v;
 	struct ima_template_entry *e;
+	char *template_name;
 	int i;
 
 	/* get entry */
@@ -197,6 +203,10 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 	if (e == NULL)
 		return -1;
 
+	template_name = e->template_desc->name;
+	if (strlen(e->template_desc->name) == 0)
+		template_name = e->template_desc->fmt;
+
 	/* 1st: PCR used (config option) */
 	seq_printf(m, "%2d ", CONFIG_IMA_MEASURE_PCR_IDX);
 
@@ -204,7 +214,7 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 	ima_print_digest(m, e->digest, TPM_DIGEST_SIZE);
 
 	/* 3th:  template name */
-	seq_printf(m, " %s", e->template_desc->name);
+	seq_printf(m, " %s", template_name);
 
 	/* 4th:  template specific data */
 	for (i = 0; i < e->template_desc->num_fields; i++) {
-- 
1.8.1.4


------C34A592FBF72A5F6D6543C3E3F87D3A9
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMDcxNDAxMzJaMCMGCSqG
SIb3DQEJBDEWBBSac2dUj6QaycfgSronpc5GG2a7IzB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQAzUS2WnZKHQsQMX1SXhcBxS/lF
/xl5Di+rAuAHTCwYGyc3W/093dMEBo+5a+SyNCMdP1juKd5KETG0tSbZM9pYqmIG
naYNk3fugw/mbE+1aatDMif20et/d5Z4oHPRQbCNGMwwHQZjNjKYAKNeliyx30Za
9zrc4TcE4vyas+F+FJFYIfUgmshznYQr/XupfmORm2hTmf9gxwKtdOXNs6VekR69
nEfxJvpVghIGur7QSUyEjJepUEDW7TQwjOEdPvoOzm0McTtDKbZZ6ilvN5drPMzP
8IXaJfG7HYyprF8Al3+Ks7mokXopf06YmfEdAEmlxwmeRSsHw4o1Os4W5bhj

------C34A592FBF72A5F6D6543C3E3F87D3A9--


