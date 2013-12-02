Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3LBSnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:43:10 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:64217 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3LBSnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:43:06 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: jmorris@namei.org, zohar@linux.vnet.ibm.com
Cc: d.kasatkin@samsung.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH] ima: properly free ima_template_entry structures
Date: Mon,  2 Dec 2013 19:40:34 +0100
Message-Id: <1386009638-32590-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----6229AA4E521AC437C362661DC56F05E7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------6229AA4E521AC437C362661DC56F05E7

The new templates management mechanism records information associated
to an event into an array of 'ima_field_data' structures and makes it
available through the 'template_data' field of the 'ima_template_entry'
structure (the element of the measurements list created by IMA).

Since 'ima_field_data' contains dynamically allocated data (which length
varies depending on the data associated to a selected template field),
it is not enough to just free the memory reserved for a
'ima_template_entry' structure if something goes wrong.

This patch creates the new function ima_free_template_entry() which
walks the array of 'ima_field_data' structures, frees the memory
referenced by the 'data' pointer and finally the space reserved for
the 'ima_template_entry' structure. Further, it replaces existing kfree()
that have a pointer to an 'ima_template_entry' structure as argument
with calls to the new function.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima.h      |  1 +
 security/integrity/ima/ima_api.c  | 21 +++++++++++++++++----
 security/integrity/ima/ima_init.c |  2 +-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 9636e17..0356e1d 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -148,6 +148,7 @@ int ima_alloc_init_template(struct integrity_iint_cache *iint,
 			    int xattr_len, struct ima_template_entry **entry);
 int ima_store_template(struct ima_template_entry *entry, int violation,
 		       struct inode *inode, const unsigned char *filename);
+void ima_free_template_entry(struct ima_template_entry *entry);
 const char *ima_d_path(struct path *path, char **pathbuf);
 
 /* rbtree tree calls to lookup, insert, delete
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 8037484..c38bbce 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -22,6 +22,19 @@
 #include "ima.h"
 
 /*
+ * ima_free_template_entry - free an existing template entry
+ */
+void ima_free_template_entry(struct ima_template_entry *entry)
+{
+	int i;
+
+	for (i = 0; i < entry->template_desc->num_fields; i++)
+		kfree(entry->template_data[i].data);
+
+	kfree(entry);
+}
+
+/*
  * ima_alloc_init_template - create and initialize a new template entry
  */
 int ima_alloc_init_template(struct integrity_iint_cache *iint,
@@ -37,6 +50,7 @@ int ima_alloc_init_template(struct integrity_iint_cache *iint,
 	if (!*entry)
 		return -ENOMEM;
 
+	(*entry)->template_desc = template_desc;
 	for (i = 0; i < template_desc->num_fields; i++) {
 		struct ima_template_field *field = template_desc->fields[i];
 		u32 len;
@@ -51,10 +65,9 @@ int ima_alloc_init_template(struct integrity_iint_cache *iint,
 		(*entry)->template_data_len += sizeof(len);
 		(*entry)->template_data_len += len;
 	}
-	(*entry)->template_desc = template_desc;
 	return 0;
 out:
-	kfree(*entry);
+	ima_free_template_entry(*entry);
 	*entry = NULL;
 	return result;
 }
@@ -134,7 +147,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 	}
 	result = ima_store_template(entry, violation, inode, filename);
 	if (result < 0)
-		kfree(entry);
+		ima_free_template_entry(entry);
 err_out:
 	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
 			    op, cause, result, 0);
@@ -269,7 +282,7 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 	if (!result || result == -EEXIST)
 		iint->flags |= IMA_MEASURED;
 	if (result < 0)
-		kfree(entry);
+		ima_free_template_entry(entry);
 }
 
 void ima_audit_measurement(struct integrity_iint_cache *iint,
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 76b8e2c..3712276 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -75,7 +75,7 @@ static void __init ima_add_boot_aggregate(void)
 	result = ima_store_template(entry, violation, NULL,
 				    boot_aggregate_name);
 	if (result < 0)
-		kfree(entry);
+		ima_free_template_entry(entry);
 	return;
 err_out:
 	integrity_audit_msg(AUDIT_INTEGRITY_PCR, NULL, boot_aggregate_name, op,
-- 
1.8.1.4


------6229AA4E521AC437C362661DC56F05E7
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzEyMDIxODQwMzhaMCMGCSqG
SIb3DQEJBDEWBBT9XhbCJz+JlXpq8yjYeKKmShRAJDB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQDMw6viwEeuv48HgGgGj0GefLt/
k7exgELJSdhzrRBkY+lqGFubEFxe2JZRvq7nRNdpXFx7Um5Io9zfDSy1WjOit6YF
1IkmFnYfXPBR5hGN76XK9qKn0TqVvPq3LwkVJmYvixuWXIrLEbfpF3fuoeSqktOe
QENd5TGoe9aNPCfWj2HU+tWZVrG3kZPyuAt+URVk5/fE0INHJcx3iucOz8pwGNX0
u+tf/3l+gJX2CCsjonaHPpx+V/5Yo4jfepgUFhaaEaZq/KDc8MKhkhqO2y9Rr0h8
EoZ9wf5wVHonTT3AF70tfAodz8tpap2TClMPHDnOMfsmPEGdNk0NNTL85K0f

------6229AA4E521AC437C362661DC56F05E7--


