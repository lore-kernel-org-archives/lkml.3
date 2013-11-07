Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3KGPv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:51:57 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:55447 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab3KGPvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:51:53 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 5/6] ima: added ima_template and ima_template_fmt new policy options
Date: Thu,  7 Nov 2013 16:49:40 +0100
Message-Id: <1383839383-18152-6-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383839383-18152-1-git-send-email-roberto.sassu@polito.it>
References: <1383839383-18152-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----AF3EF54B09DE7DE83297149D66813B95"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------AF3EF54B09DE7DE83297149D66813B95

This patch adds the support for 'ima_template' and 'ima_template_fmt'
policy options. They allow to define which template and, thus, which
information should be included in measurements entries generated from
events that match other rules' criteria.

With this feature, it is possible to include for each measurement entry
only relevant information. For example, while measurements that report
the execution of the execve() system call may contain the credentials
being installed on the current process (stored in the 'cred' field of the
'linux_binprm' structure), others should not include it (also because
the pointer to the above structure is not available from other IMA hooks).

A sample policy to produce measurements the way is described above may be:

---
measure func=BPRM_CHECK mask=MAY_EXEC ima_template_fmt=d-ng|n-ng|bprm-type
measure func=FILE_MMAP mask=MAY_EXEC
---

where 'bprm-type' is the identifier of a field (whose code is not yet
upstreamed) which displays the type part of a LSM label from credentials
stored in the 'linux_binprm' structure.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 Documentation/ABI/testing/ima_policy     |  6 ++++-
 Documentation/security/IMA-templates.txt | 19 ++++++++------
 security/integrity/ima/ima_policy.c      | 45 +++++++++++++++++++++++++++++++-
 3 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index f1c5cc9..7fbe47d 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -23,7 +23,7 @@ Description:
 				 [fowner]]
 			lsm:	[[subj_user=] [subj_role=] [subj_type=]
 				 [obj_user=] [obj_role=] [obj_type=]]
-			option:	[[appraise_type=]]
+			option:	[[appraise_type=] [ima_template=] [ima_template_fmt=]]
 
 		base: 	func:= [BPRM_CHECK][MMAP_CHECK][FILE_CHECK][MODULE_CHECK]
 			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
@@ -33,6 +33,10 @@ Description:
 			fowner:=decimal value
 		lsm:  	are LSM specific
 		option:	appraise_type:= [imasig]
+			ima_template:= an already defined template
+			ima_template_fmt:= a custom template format
+					   (see Documentation/security/IMA-templates.txt
+					   for more details)
 
 		default policy:
 			# PROC_SUPER_MAGIC
diff --git a/Documentation/security/IMA-templates.txt b/Documentation/security/IMA-templates.txt
index 08ea2da..61d9f0d 100644
--- a/Documentation/security/IMA-templates.txt
+++ b/Documentation/security/IMA-templates.txt
@@ -36,13 +36,14 @@ from the set of the supported ones.
 After the initialization step, IMA will call ima_alloc_init_template()
 (new function defined within the patches for the new template management
 mechanism) to generate a new measurement entry by using the template
-descriptor chosen through the kernel configuration or through the newly
-introduced 'ima_template' and 'ima_template_fmt' kernel command line parameters.
-It is during this phase that the advantages of the new architecture are
-clearly shown: the latter function will not contain specific code to handle
-a given template but, instead, it simply calls the init() method of the template
-fields associated to the chosen template descriptor and store the result
-(pointer to allocated data and data length) in the measurement entry structure.
+descriptor chosen through the kernel configuration, the newly introduced
+'ima_template' and 'ima_template_fmt' kernel command line parameters and
+new policy options with the same names. It is during this phase that the
+advantages of the new architecture are clearly shown: the latter function
+will not contain specific code to handle a given template but, instead, it
+simply calls the init() method of the template fields associated to the
+chosen template descriptor and store the result (pointer to allocated data
+and data length) in the measurement entry structure.
 
 The same mechanism is employed to display measurements entries.
 The functions ima[_ascii]_measurements_show() retrieve, for each entry,
@@ -83,4 +84,6 @@ currently the following methods are supported:
  - specify a template descriptor name from the kernel command line through
    the 'ima_template=' parameter;
  - register a new template descriptor with custom format through the kernel
-   command line parameter 'ima_template_fmt='.
+   command line parameter 'ima_template_fmt=';
+ - provide desired template name or custom format for specific events through
+   the new policy options 'ima_template=' and 'ima_template_fmt='.
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index a9c3d3c..df852ec 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -50,6 +50,8 @@ struct ima_rule_entry {
 	u8 fsuuid[16];
 	kuid_t uid;
 	kuid_t fowner;
+	char *template_name;
+	char *template_fmt;
 	struct {
 		void *rule;	/* LSM file metadata specific */
 		void *args_p;	/* audit value */
@@ -351,7 +353,8 @@ enum {
 	Opt_obj_user, Opt_obj_role, Opt_obj_type,
 	Opt_subj_user, Opt_subj_role, Opt_subj_type,
 	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid, Opt_fowner,
-	Opt_appraise_type, Opt_fsuuid
+	Opt_appraise_type, Opt_fsuuid,
+	Opt_ima_template, Opt_ima_template_fmt
 };
 
 static match_table_t policy_tokens = {
@@ -373,6 +376,8 @@ static match_table_t policy_tokens = {
 	{Opt_uid, "uid=%s"},
 	{Opt_fowner, "fowner=%s"},
 	{Opt_appraise_type, "appraise_type=%s"},
+	{Opt_ima_template, "ima_template=%s"},
+	{Opt_ima_template_fmt, "ima_template_fmt=%s"},
 	{Opt_err, NULL}
 };
 
@@ -421,6 +426,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 	entry->action = UNKNOWN;
 	while ((p = strsep(&rule, " \t")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
+		struct ima_template_desc *desc;
 		int token;
 		unsigned long lnum;
 
@@ -621,6 +627,43 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			else
 				result = -EINVAL;
 			break;
+		case Opt_ima_template:
+			ima_log_string(ab, "ima_template", args[0].from);
+
+			if (entry->template_name || entry->template_fmt) {
+				result = -EINVAL;
+				break;
+			}
+
+			desc = ima_get_template_desc(args[0].from, NULL);
+			if (strcmp(desc->name, args[0].from) != 0) {
+				result = -EINVAL;
+				break;
+			}
+
+			entry->template_name = kstrdup(args[0].from,
+						       GFP_KERNEL);
+			if (!entry->template_name)
+				result = -EINVAL;
+			break;
+		case Opt_ima_template_fmt:
+			ima_log_string(ab, "ima_template_fmt", args[0].from);
+
+			if (entry->template_fmt || entry->template_name) {
+				result = -EINVAL;
+				break;
+			}
+
+			desc = ima_get_template_desc(NULL, args[0].from);
+			if (strcmp(desc->fmt, args[0].from) != 0) {
+				result = -EINVAL;
+				break;
+			}
+
+			entry->template_fmt = kstrdup(args[0].from, GFP_KERNEL);
+			if (!entry->template_fmt)
+				result = -EINVAL;
+			break;
 		case Opt_err:
 			ima_log_string(ab, "UNKNOWN", p);
 			result = -EINVAL;
-- 
1.8.1.4


------AF3EF54B09DE7DE83297149D66813B95
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMDcxNTUwMjZaMCMGCSqG
SIb3DQEJBDEWBBQGF8iA79pJJNs3swVJRqbjn0PZaTB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQBfmMjda1proN4Wzn9y3eHG+8/S
75jlPee8QXJdvRdXRPjnoMz/H92SI3LDd016aU+QBZZNC4Rq6cZZdBnutjzAzNpc
udDgG+GJIX0ug1Hpy6kv6R1cSRPoU9nxvSqRJDQlvMwDmhtVWu6MxD2XvH686AJ3
ajTaCR+o5DYj69SoFjIrN/43EYwWFpGwHR4+4tWlAPlkln+fTLYvVmsvj/+3JgJi
6USsUuUD7GtqbwAOF9LVuNk/z8haIibb2CmDGZGYLHty8r6Ifx95DIKnpbb6fLIO
rpRfR70zZH927INu6M+ixARd8YEHUHLMH7ccq3FgJZsdZ3AVzcWtWmlgXmn3

------AF3EF54B09DE7DE83297149D66813B95--


