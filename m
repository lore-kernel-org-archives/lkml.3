Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3KSMgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 07:36:35 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:48324 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3KSMgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:36:31 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH-v2 6/6] ima: use custom template obtained from a matched policy rule
Date: Tue, 19 Nov 2013 13:33:45 +0100
Message-Id: <1384864428-3895-7-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384864428-3895-1-git-send-email-roberto.sassu@polito.it>
References: <1384864428-3895-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----1FADB5467239B45C89D17D71C580AA98"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------1FADB5467239B45C89D17D71C580AA98

This patch modifies existing IMA functions to retrieve the template
descriptor from a matched policy rule and provide it to
ima_alloc_init_template().

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima.h        | 5 +++--
 security/integrity/ima/ima_api.c    | 7 ++++---
 security/integrity/ima/ima_main.c   | 4 +++-
 security/integrity/ima/ima_policy.c | 5 ++++-
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index fc2fbf3..9df015c 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -133,7 +133,8 @@ static inline unsigned long ima_hash_key(u8 *digest)
 }
 
 /* LIM API function definitions */
-int ima_get_action(struct inode *inode, int mask, int function);
+int ima_get_action(struct inode *inode, int mask, int function,
+		   struct ima_template_desc **desc);
 int ima_must_measure(struct inode *inode, int mask, int function);
 int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct file *file,
@@ -165,7 +166,7 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 enum ima_hooks { FILE_CHECK = 1, MMAP_CHECK, BPRM_CHECK, MODULE_CHECK, POST_SETATTR };
 
 int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
-		     int flags);
+		     int flags, struct ima_template_desc **desc);
 void ima_init_policy(void);
 void ima_update_policy(void);
 ssize_t ima_parse_add_rule(char *);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 444ec53..ebfd6cf 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -161,19 +161,20 @@ err_out:
  * Returns IMA_MEASURE, IMA_APPRAISE mask.
  *
  */
-int ima_get_action(struct inode *inode, int mask, int function)
+int ima_get_action(struct inode *inode, int mask, int function,
+		   struct ima_template_desc **desc)
 {
 	int flags = IMA_MEASURE | IMA_AUDIT | IMA_APPRAISE;
 
 	if (!ima_appraise)
 		flags &= ~IMA_APPRAISE;
 
-	return ima_match_policy(inode, function, mask, flags);
+	return ima_match_policy(inode, function, mask, flags, desc);
 }
 
 int ima_must_measure(struct inode *inode, int mask, int function)
 {
-	return ima_match_policy(inode, function, mask, IMA_MEASURE);
+	return ima_match_policy(inode, function, mask, IMA_MEASURE, NULL);
 }
 
 /*
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index e08ce72..44a1af1 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -167,6 +167,7 @@ static int process_measurement(struct file *file, const char *filename,
 	struct inode *inode = file_inode(file);
 	struct integrity_iint_cache *iint;
 	struct ima_template_desc *template_desc = ima_template_desc_current();
+	struct ima_template_desc *tmp_desc;
 	char *pathbuf = NULL;
 	const char *pathname = NULL;
 	int rc = -ENOMEM, action, must_appraise, _func;
@@ -180,7 +181,7 @@ static int process_measurement(struct file *file, const char *filename,
 	 * bitmask based on the appraise/audit/measurement policy.
 	 * Included is the appraise submask.
 	 */
-	action = ima_get_action(inode, mask, function);
+	action = ima_get_action(inode, mask, function, &tmp_desc);
 	if (!action)
 		return 0;
 
@@ -210,6 +211,7 @@ static int process_measurement(struct file *file, const char *filename,
 		goto out_digsig;
 	}
 
+	template_desc = (tmp_desc != NULL) ? tmp_desc : template_desc;
 	if (strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0) {
 		if (action & IMA_APPRAISE_SUBMASK)
 			xattr_ptr = &xattr_value;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index f4b3fd0..edc38ac 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -260,7 +260,7 @@ static int get_subaction(struct ima_rule_entry *rule, int func)
  * change.)
  */
 int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
-		     int flags)
+		     int flags, struct ima_template_desc **desc)
 {
 	struct ima_rule_entry *entry;
 	int action = 0, actmask = flags | (flags << 1);
@@ -273,6 +273,9 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
 		if (!ima_match_rules(entry, inode, func, mask))
 			continue;
 
+		if (desc)
+			*desc = entry->desc;
+
 		action |= entry->flags & IMA_ACTION_FLAGS;
 
 		action |= entry->action & IMA_DO_MASK;
-- 
1.8.1.4


------1FADB5467239B45C89D17D71C580AA98
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMTkxMjM0NTlaMCMGCSqG
SIb3DQEJBDEWBBSF2VO89Dw0PtapVufKSpVODajwMTB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQBVMbb+44I01kZi42eHVQix9m7K
aJaGJTrSNpclGumqgJdMdNp9ahE+4DIziAnKFlxJa6jNGNC2HE3D2g7c1DXKMN4m
R/dhG77UjP6ihoSFSpHKfKObZDQOPBq4h1+W4nVE6bRPIbwyzbPO1cMFzYxs+4j+
ri1X4hnyT2k4Xa6hcyvwGp2l/mVKMrR1Wj8EkeycGq5fpKcQq8GC2OOp+E8/6mUr
5oM9v4bYFRRtwlI+q7WLFUrN+zHhJgYnIx3TdKgRuntPU7ks6BscxrDlnc24KXjP
cqVX+evR6chYdZ9tZxbWtHAovAY6Ua2CpineQAJmiivw5XvdL4Qhir6z7GOT

------1FADB5467239B45C89D17D71C580AA98--


