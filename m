Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3KGODL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:03:11 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:64277 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3KGODH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:03:07 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 4/4] ima: added support for new kernel cmdline parameter ima_template_fmt
Date: Thu,  7 Nov 2013 15:00:45 +0100
Message-Id: <1383832849-17125-5-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383832849-17125-1-git-send-email-roberto.sassu@polito.it>
References: <1383832849-17125-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----F98F5BF86BCC3F7046534F1656A3BDB7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------F98F5BF86BCC3F7046534F1656A3BDB7

This patch allows users to provide a custom template format through the
new kernel command line parameter 'ima_template_fmt'. If the supplied
format is not valid, IMA uses the default template descriptor.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 Documentation/kernel-parameters.txt      |  4 +++
 Documentation/security/IMA-templates.txt | 29 +++++++++---------
 security/integrity/ima/ima_template.c    | 50 ++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1e8761c..27b14b2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1199,6 +1199,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Formats: { "ima" | "ima-ng" }
 			Default: "ima-ng"
 
+	ima_template_fmt=
+	                [IMA] Define a custom template format.
+			Format: { "field1|...|fieldN" }
+
 	init=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /sbin/init as init
diff --git a/Documentation/security/IMA-templates.txt b/Documentation/security/IMA-templates.txt
index a777e5f..08ea2da 100644
--- a/Documentation/security/IMA-templates.txt
+++ b/Documentation/security/IMA-templates.txt
@@ -27,25 +27,22 @@ Managing templates with these structures is very simple. To support
 a new data type, developers define the field identifier and implement
 two functions, init() and show(), respectively to generate and display
 measurement entries. Defining a new template descriptor requires
-specifying the template format, a string of field identifiers separated
-by the '|' character. While in the current implementation it is possible
-to define new template descriptors only by adding their definition in the
-template specific code (ima_template.c), in a future version it will be
-possible to register a new template on a running kernel by supplying to IMA
-the desired format string. In this version, IMA initializes at boot time
-all defined template descriptors by translating the format into an array
-of template fields structures taken from the set of the supported ones.
+specifying the template format (a string of field identifiers separated
+by the '|' character) through the 'ima_template_fmt' kernel command line
+parameter. At boot time, IMA initializes all defined template descriptors
+by translating the format into an array of template fields structures taken
+from the set of the supported ones.
 
 After the initialization step, IMA will call ima_alloc_init_template()
 (new function defined within the patches for the new template management
 mechanism) to generate a new measurement entry by using the template
 descriptor chosen through the kernel configuration or through the newly
-introduced 'ima_template=' kernel command line parameter. It is during this
-phase that the advantages of the new architecture are clearly shown:
-the latter function will not contain specific code to handle a given template
-but, instead, it simply calls the init() method of the template fields
-associated to the chosen template descriptor and store the result (pointer
-to allocated data and data length) in the measurement entry structure.
+introduced 'ima_template' and 'ima_template_fmt' kernel command line parameters.
+It is during this phase that the advantages of the new architecture are
+clearly shown: the latter function will not contain specific code to handle
+a given template but, instead, it simply calls the init() method of the template
+fields associated to the chosen template descriptor and store the result
+(pointer to allocated data and data length) in the measurement entry structure.
 
 The same mechanism is employed to display measurements entries.
 The functions ima[_ascii]_measurements_show() retrieve, for each entry,
@@ -84,4 +81,6 @@ currently the following methods are supported:
  - select a template descriptor among those supported in the kernel
    configuration ('ima-ng' is the default choice);
  - specify a template descriptor name from the kernel command line through
-   the 'ima_template=' parameter.
+   the 'ima_template=' parameter;
+ - register a new template descriptor with custom format through the kernel
+   command line parameter 'ima_template_fmt='.
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index bb33576..5a95d06 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -21,6 +21,7 @@ static struct ima_template_desc defined_templates[] = {
 	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
 	{.name = "ima-ng",.fmt = "d-ng|n-ng"},
 	{.name = "ima-sig",.fmt = "d-ng|n-ng|sig"},
+	{.name = "",.fmt = ""},	/* placeholder for a custom format */
 };
 
 static struct ima_template_field supported_fields[] = {
@@ -38,12 +39,16 @@ static struct ima_template_field supported_fields[] = {
 
 static struct ima_template_desc *ima_template;
 static struct ima_template_desc *lookup_template_desc(const char *name);
+static struct ima_template_field *lookup_template_field(const char *field_id);
 
 static int __init ima_template_setup(char *str)
 {
 	struct ima_template_desc *template_desc;
 	int template_len = strlen(str);
 
+	if (ima_template)
+		return 1;
+
 	/*
 	 * Verify that a template with the supplied name exists.
 	 * If not, use CONFIG_IMA_DEFAULT_TEMPLATE.
@@ -70,6 +75,48 @@ static int __init ima_template_setup(char *str)
 }
 __setup("ima_template=", ima_template_setup);
 
+static int __init ima_template_fmt_setup(char *str)
+{
+	int num_templates = ARRAY_SIZE(defined_templates);
+	char *str_ptr_start = str;
+	char *str_ptr_end = str_ptr_start;
+
+	if (ima_template)
+		return 1;
+
+	while (str_ptr_start != NULL) {
+		char field_id[IMA_TEMPLATE_FIELD_ID_MAX_LEN];
+		int len;
+
+		str_ptr_end = strpbrk(str_ptr_start, "|");
+		if (str_ptr_end == NULL)
+			len = str + strlen(str) - str_ptr_start;
+		else
+			len = str_ptr_end++ - str_ptr_start;
+
+		if (len >= IMA_TEMPLATE_FIELD_ID_MAX_LEN) {
+			pr_err("IMA: field too long, using template %s\n",
+			       CONFIG_IMA_DEFAULT_TEMPLATE);
+			return 1;
+		}
+
+		memcpy(field_id, str_ptr_start, len);
+		field_id[len] = '\0';
+		if (lookup_template_field(field_id) == NULL) {
+			pr_err("IMA: field '%s' not found, using template %s\n",
+			       field_id, CONFIG_IMA_DEFAULT_TEMPLATE);
+			return 1;
+		}
+
+		str_ptr_start = str_ptr_end;
+	}
+
+	defined_templates[num_templates - 1].fmt = str;
+	ima_template = defined_templates + num_templates - 1;
+	return 1;
+}
+__setup("ima_template_fmt=", ima_template_fmt_setup);
+
 static struct ima_template_desc *lookup_template_desc(const char *name)
 {
 	int i;
@@ -160,6 +207,9 @@ static int init_defined_templates(void)
 	for (i = 0; i < ARRAY_SIZE(defined_templates); i++) {
 		struct ima_template_desc *template = &defined_templates[i];
 
+		if (strlen(template->fmt) == 0)
+			continue;
+
 		result = template_desc_init_fields(template->fmt,
 						   &(template->fields),
 						   &(template->num_fields));
-- 
1.8.1.4


------F98F5BF86BCC3F7046534F1656A3BDB7
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMDcxNDAxNDBaMCMGCSqG
SIb3DQEJBDEWBBT3QxRx3AXVJ+jdKUBo5OtZwx/6UjB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCWdyE5znLS3f0JAhRqmzaMPhCw
42qH/WKuNyxvxokWuU7IFlmGGvkWR+6W/YXlBI2tpdnzSc7PPfE6fAMKMdhp4pnd
wh1AXiVc4WBoteU4HsEkmR7Jw0716wKBS67UUi5ypyMroi+x4yxbQejDfuq4WJ31
W4Q5aAfWSD0yj+I/kwJBK/cWs5FX0KMYMdvWgB5p8G/ULMnZRiNsQ3yGM2AzgKGb
bpk/OheIc0kkKnHoBgq6incuXfV97ggv5H6C1d27IBZyWWUqbouMdLajsGwyusNt
VXanv6kdUXvucgRmzRci2/F8X46QunoCIIhWo3aiGo63tTsSeWMjAE8jj9XP

------F98F5BF86BCC3F7046534F1656A3BDB7--


