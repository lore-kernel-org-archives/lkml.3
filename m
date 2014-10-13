Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbaJMMKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:10:49 -0400
Received: from fm2nodo1.polito.it ([130.192.180.12]:57625 "EHLO
	fm2nodo1.polito.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaJMMKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:10:47 -0400
X-AttachExt: p7s
X-ExtScanner: Niversoft's FindAttachments (free)
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, jmorris@namei.org,
        Roberto Sassu <roberto.sassu@polito.it>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH-v4 2/5] ima: display template format in meas. list if template name length is zero
Date: Mon, 13 Oct 2014 14:08:39 +0200
Message-Id: <1413202125-7062-3-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413202125-7062-1-git-send-email-roberto.sassu@polito.it>
References: <1413202125-7062-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----316D94A49C24F74C4962BF5431BFDBD1"
X-FEAS-SYSTEM-WL: 130.192.180.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------316D94A49C24F74C4962BF5431BFDBD1

With the introduction of the 'ima_template_fmt' kernel cmdline parameter,
a user can define a new template descriptor with custom format. However,
in this case, userspace tools will be unable to parse the measurements
list because the new template is unknown. For this reason, this patch
modifies the current IMA behavior to display in the list the template
format instead of the name (only if the length of the latter is zero)
so that a tool can extract needed information if it can handle listed
fields.

This patch also correctly displays the error log message in
ima_init_template() if the selected template cannot be initialized.

Changelog:
 - v3:
   - check the first byte of 'e->template_desc->name' instead of using
     strlen() in ima_fs.c (suggested by Mimi Zohar)

 - v2:
   - print the template format in ima_init_template(), if the selected
     template is custom (Roberto Sassu)

 - v1:
   - fixed patch description (Roberto Sassu, suggested by Mimi Zohar)
   - set 'template_name' variable in ima_fs.c only once
     (Roberto Sassu, suggested by Mimi Zohar)

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_fs.c       | 16 ++++++++++++----
 security/integrity/ima/ima_template.c |  4 +++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index da92fcc..fd637ad 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -118,6 +118,7 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	/* the list never shrinks, so we don't need a lock here */
 	struct ima_queue_entry *qe = v;
 	struct ima_template_entry *e;
+	char *template_name;
 	int namelen;
 	u32 pcr = CONFIG_IMA_MEASURE_PCR_IDX;
 	bool is_ima_template = false;
@@ -128,6 +129,9 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	if (e == NULL)
 		return -1;
 
+	template_name = (e->template_desc->name[0] != '\0') ?
+	    e->template_desc->name : e->template_desc->fmt;
+
 	/*
 	 * 1st: PCRIndex
 	 * PCR used is always the same (config option) in
@@ -139,14 +143,14 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	ima_putc(m, e->digest, TPM_DIGEST_SIZE);
 
 	/* 3rd: template name size */
-	namelen = strlen(e->template_desc->name);
+	namelen = strlen(template_name);
 	ima_putc(m, &namelen, sizeof(namelen));
 
 	/* 4th:  template name */
-	ima_putc(m, e->template_desc->name, namelen);
+	ima_putc(m, template_name, namelen);
 
 	/* 5th:  template length (except for 'ima' template) */
-	if (strcmp(e->template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0)
+	if (strcmp(template_name, IMA_TEMPLATE_IMA_NAME) == 0)
 		is_ima_template = true;
 
 	if (!is_ima_template)
@@ -200,6 +204,7 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 	/* the list never shrinks, so we don't need a lock here */
 	struct ima_queue_entry *qe = v;
 	struct ima_template_entry *e;
+	char *template_name;
 	int i;
 
 	/* get entry */
@@ -207,6 +212,9 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 	if (e == NULL)
 		return -1;
 
+	template_name = (e->template_desc->name[0] != '\0') ?
+	    e->template_desc->name : e->template_desc->fmt;
+
 	/* 1st: PCR used (config option) */
 	seq_printf(m, "%2d ", CONFIG_IMA_MEASURE_PCR_IDX);
 
@@ -214,7 +222,7 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 	ima_print_digest(m, e->digest, TPM_DIGEST_SIZE);
 
 	/* 3th:  template name */
-	seq_printf(m, " %s", e->template_desc->name);
+	seq_printf(m, " %s", template_name);
 
 	/* 4th:  template specific data */
 	for (i = 0; i < e->template_desc->num_fields; i++) {
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 1310afc..b7b359c 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -176,7 +176,9 @@ int __init ima_init_template(void)
 					   &(template->fields),
 					   &(template->num_fields));
 	if (result < 0)
-		pr_err("template %s init failed, result: %d\n", template->name);
+		pr_err("template %s init failed, result: %d\n",
+		       (strlen(template->name) ?
+		       template->name : template->fmt), result);
 
 	return result;
 }
-- 
1.9.3


------316D94A49C24F74C4962BF5431BFDBD1
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNDEwMTMxMjA5MzJaMCMGCSqG
SIb3DQEJBDEWBBTZ9LLbVhtPAscNTg+ppqERV3HSEzB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCWUc6iN76jrrdUSmVVNvuCW1rm
JxKZeSDNGSqUWXoo2Fs60znNHNv8G1Ysu1dra+5taTq3wp3UwgbbHjLKOnTwVbE/
EPRQwDgrjHKkY5MbFd0VJamYIeEY6UN0oDCE863F95JWAJ5SuHHPb3kdfxMb7HCA
rgqhdV6KUQsetrQzNdedSvSA35Q/kwvgl+ZDCjTvsDZEmuyBWa6qFqIB+qepkupj
+Nq5OBI4UMy/wnzR598yEjBZFSZoKOCiVg+yeW+MJHsNjCqdE003zDvTzKio2Cxm
XPYXI+GPvEsYPFaAYZdS7TJ4w5tTkU4oe9W6+iMC3ZoqXRYXa+SKtqPpWInO

------316D94A49C24F74C4962BF5431BFDBD1--


