Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3LFO1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:27:41 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:43712 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161019Ab3LFM7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:59:36 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: jmorris@namei.org, zohar@linux.vnet.ibm.com
Cc: d.kasatkin@samsung.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH-v2 2/3] ima: display template format in meas. list if template name length is zero
Date: Fri,  6 Dec 2013 13:57:16 +0100
Message-Id: <1386334640-31393-3-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386334640-31393-1-git-send-email-roberto.sassu@polito.it>
References: <1386334640-31393-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----D521EF265F3582127DC736DC140F1FE8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------D521EF265F3582127DC736DC140F1FE8

With the introduction of the 'ima_template_fmt' kernel cmdline parameter,
an user can define a new template descriptor with custom format. However,
in this case, userspace tools will be unable to parse the measurements
list because the new template is unknown. For this reason, this patch
modifies the current IMA behavior to display in the list the template
format instead of the name (only if the length of the latter is zero)
so that a tool can extract needed information if it can handle listed
fields.

Changelog:
 - fixed patch description (Roberto Sassu, suggested by Mimi Zohar)
 - set 'template_name' variable in ima_fs.c only once
   (Roberto Sassu, suggested by Mimi Zohar)

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_fs.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index db01125..8b5c182 100644
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
 
+	template_name = (strlen(e->template_desc->name) != 0) ?
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
 	ima_putc(m, &namelen, sizeof namelen);
 
 	/* 4th:  template name */
-	ima_putc(m, e->template_desc->name, namelen);
+	ima_putc(m, template_name, namelen);
 
 	/* 5th:  template length (except for 'ima' template) */
-	if (strcmp(e->template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0)
+	if (strcmp(template_name, IMA_TEMPLATE_IMA_NAME) == 0)
 		is_ima_template = true;
 
 	if (!is_ima_template)
@@ -198,6 +202,7 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 	/* the list never shrinks, so we don't need a lock here */
 	struct ima_queue_entry *qe = v;
 	struct ima_template_entry *e;
+	char *template_name;
 	int i;
 
 	/* get entry */
@@ -205,6 +210,9 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 	if (e == NULL)
 		return -1;
 
+	template_name = (strlen(e->template_desc->name) != 0) ?
+	    e->template_desc->name : e->template_desc->fmt;
+
 	/* 1st: PCR used (config option) */
 	seq_printf(m, "%2d ", CONFIG_IMA_MEASURE_PCR_IDX);
 
@@ -212,7 +220,7 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 	ima_print_digest(m, e->digest, TPM_DIGEST_SIZE);
 
 	/* 3th:  template name */
-	seq_printf(m, " %s", e->template_desc->name);
+	seq_printf(m, " %s", template_name);
 
 	/* 4th:  template specific data */
 	for (i = 0; i < e->template_desc->num_fields; i++) {
-- 
1.8.1.4


------D521EF265F3582127DC736DC140F1FE8
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzEyMDYxMjU3NDlaMCMGCSqG
SIb3DQEJBDEWBBR0R0Yh4dHO3hltTPkIsGnnBeAbvzB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCuQ6IBU4uw/Kf3vNL7CKZgOSYC
qoFqLrwZ7+xTt8LXfu7zbavi5Fd197DIwpFhmcjvhWhnBk0TWfN/0p01JQKyUeOB
TSO6dIO6SdC2AmviO6OO8q0C59+3DZwaVPHEB+xo98gY2IK+AXzmIYlufERQ0dPs
9rr6LNQ1u8A5+225t4TW3BK3hrjA5P3dAMCMfMEk7lCXHGPm04Z5IZf7w55bPMY0
sPSvhCMTdfvKKjsiXxXHIipW6Bdx4SIuyxJN/RFU4ggctwZjeM9F8xoiJ7PL2SO/
rR4XxArMG8eKNqVBArt9jFh3rrhs1u1CgA3xs9qEnlW445WT/bdETgJORpKJ

------D521EF265F3582127DC736DC140F1FE8--


