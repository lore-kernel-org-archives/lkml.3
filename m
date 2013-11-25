Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab3KYTVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:21:15 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:65498 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3KYTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:21:12 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: jmorris@namei.org, zohar@linux.vnet.ibm.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH] ima: make a copy of template_fmt in template_desc_init_fields()
Date: Mon, 25 Nov 2013 20:18:52 +0100
Message-Id: <1385407140-20817-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <alpine.LRH.2.02.1311260235020.9714@tundra.namei.org>
References: <alpine.LRH.2.02.1311260235020.9714@tundra.namei.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----2B6DB63526BCDD34A0DD5A93F48BA64C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------2B6DB63526BCDD34A0DD5A93F48BA64C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch makes a copy of the 'template_fmt' function argument so that
the latter will not be modified by strsep(), which does the splitting by
replacing the given separator with '\0'.

 IMA: No TPM chip found, activating TPM-bypass!
 Unable to handle kernel pointer dereference at virtual kernel address 0000000000842000
 Oops: 0004 [#1] SMP
 Modules linked in:
 CPU: 3 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc2-00098-g3ce1217d6cd5 #17
 task: 000000003ffa0000 ti: 000000003ff84000 task.ti: 000000003ff84000
 Krnl PSW : 0704e00180000000 000000000044bf88 (strsep+0x7c/0xa0)
            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 EA:3
 Krnl GPRS: 000000000000007c 000000000000007c 000000003ff87d90 0000000000821fd8
            0000000000000000 000000000000007c 0000000000aa37e0 0000000000aa9008
            0000000000000051 0000000000a114d8 0000000100000002 0000000000842bde
            0000000000842bdf 00000000006f97f0 000000000040062c 000000003ff87cf0
 Krnl Code: 000000000044bf7c: a7f4000a           brc     15,44bf90
            000000000044bf80: b90200cc           ltgr    %r12,%r12
           #000000000044bf84: a7840006           brc     8,44bf90
           >000000000044bf88: 9200c000           mvi     0(%r12),0
            000000000044bf8c: 41c0c001           la      %r12,1(%r12)
            000000000044bf90: e3c020000024       stg     %r12,0(%r2)
            000000000044bf96: b904002b           lgr     %r2,%r11
            000000000044bf9a: ebbcf0700004       lmg     %r11,%r12,112(%r15)
 Call Trace:
 ([<00000000004005fe>] ima_init_template+0xa2/0x1bc)
  [<0000000000a7c896>] ima_init+0x7a/0xa8
  [<0000000000a7c938>] init_ima+0x24/0x40
  [<00000000001000e8>] do_one_initcall+0x68/0x128
  [<0000000000a4eb56>] kernel_init_freeable+0x20a/0x2b4
  [<00000000006a1ff4>] kernel_init+0x30/0x178
  [<00000000006b69fe>] kernel_thread_starter+0x6/0xc
  [<00000000006b69f8>] kernel_thread_starter+0x0/0xc
 Last Breaking-Event-Address:
  [<000000000044bf42>] strsep+0x36/0xa0

Fixes commit: adf53a7 ima: new templates management mechanism

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 security/integrity/ima/ima_template.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 4e5da99..913e192 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -90,7 +90,7 @@ static struct ima_template_field *lookup_template_field(const char *field_id)
 	return NULL;
 }
 
-static int template_fmt_size(char *template_fmt)
+static int template_fmt_size(const char *template_fmt)
 {
 	char c;
 	int template_fmt_len = strlen(template_fmt);
@@ -106,23 +106,28 @@ static int template_fmt_size(char *template_fmt)
 	return j + 1;
 }
 
-static int template_desc_init_fields(char *template_fmt,
+static int template_desc_init_fields(const char *template_fmt,
 				     struct ima_template_field ***fields,
 				     int *num_fields)
 {
-	char *c, *template_fmt_ptr = template_fmt;
+	char *c, *template_fmt_copy;
 	int template_num_fields = template_fmt_size(template_fmt);
 	int i, result = 0;
 
 	if (template_num_fields > IMA_TEMPLATE_NUM_FIELDS_MAX)
 		return -EINVAL;
 
+	/* copying is needed as strsep() modifies the original buffer */
+	template_fmt_copy = kstrdup(template_fmt, GFP_KERNEL);
+	if (template_fmt_copy == NULL)
+		return -ENOMEM;
+
 	*fields = kzalloc(template_num_fields * sizeof(*fields), GFP_KERNEL);
 	if (*fields == NULL) {
 		result = -ENOMEM;
 		goto out;
 	}
-	for (i = 0; (c = strsep(&template_fmt_ptr, "|")) != NULL &&
+	for (i = 0; (c = strsep(&template_fmt_copy, "|")) != NULL &&
 	     i < template_num_fields; i++) {
 		struct ima_template_field *f = lookup_template_field(c);
 
@@ -133,10 +138,12 @@ static int template_desc_init_fields(char *template_fmt,
 		(*fields)[i] = f;
 	}
 	*num_fields = i;
-	return 0;
 out:
-	kfree(*fields);
-	*fields = NULL;
+	if (result < 0) {
+		kfree(*fields);
+		*fields = NULL;
+	}
+	kfree(template_fmt_copy);
 	return result;
 }
 
-- 
1.8.1.4


------2B6DB63526BCDD34A0DD5A93F48BA64C
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMjUxOTE5MDBaMCMGCSqG
SIb3DQEJBDEWBBTYPI66AYvbwnD10VOZRC9VkmWY5TB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQDD4A+qJoH7H5Hulc8Vzmu9iyzI
Uj2xWc/zJ8+U3JMtYpt1SnH9zE0NyB1P8Tze3Tw2B2DAP41M01dSiiq0eDtS+CWc
meZitz0e59RpozUFktatUGFjfXExIkIRPAu9+LmE5tj+Vq7zpsnY1+Avi1cgQCBt
vvGPZunMg8GcOlph4BU155u1MVnyT4U0i+MIK89KNsGwSx84h5oilaO55a4t4XBc
WpuPWWuSiwFWpxPLAehMiHbBZmE0pcIdheTZahWBI3uE4ZbnWawkblTWExAIVDbV
DYYknivwBv7vRF36Ow9P3uDEsLVV11YuEgpo+y0MOBBovlkBmrrmpU30UCd2

------2B6DB63526BCDD34A0DD5A93F48BA64C--


