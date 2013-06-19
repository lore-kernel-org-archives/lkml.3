Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934889Ab3FSPN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:13:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61422 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934860Ab3FSPNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:13:53 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-42-51c1cab083b4
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-security-module@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/4] security: smack: avoid kmalloc() in smk_parse_long_rule()
Date: Wed, 19 Jun 2013 17:13:33 +0200
Message-id: <1371654816-20772-3-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371654816-20772-1-git-send-email-t.stanislaws@samsung.com>
References: <1371654816-20772-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e+xoO6GUwcDDY7/U7a4t+0Xm8XZpjfs
	Fpd3zWGz+NDziM1i7ZG77BZvJ61gtpjX/pLVgd2jb8sqRo+j+xexeXzeJBfAHMVlk5Kak1mW
	WqRvl8CVcaDlIEvBSemKvQfPsDQwfhPtYuTkkBAwkZjdtYsVwhaTuHBvPVsXIxeHkMB0RolZ
	y14wQzhdTBIXl65jA6liA+o4tuQzI4gtIqApcWw6RAezwDZGiY4XU5lAEsICfhIPVxxjBrFZ
	BFQlVh79CxbnFfCQaHz0mQlinbzE0/t9YEM5BTwlrp9/BzZUCKhm8dV1rBMYeRcwMqxiFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECA6iZ1I7GFc2WBxiFOBgVOLhbVh5IFCINbGsuDL3EKME
	B7OSCO/SowcDhXhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBK
	NTCuWqp02yM7p3uf9YU5W++YHotdqpT23+SLQtKeMPPM7cd3fZ08XeigV4WQbWFJx+8Ze8M1
	E404qpQvfcmY42/sJFwt8+7bIV++rcvLVr+NK10snx3FFd1Yxcl91Ep3y8c4lc6mnhP6dnaL
	OM1mGvXtrxHhyhE+Lu+yKObizryf97u2bVqjwqDEUpyRaKjFXFScCAC5ecpPHgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function smk_parse_long_rule() allocates a number of temporary strings on heap
(kmalloc cache). Moreover, the sizes of those allocations might be large if
user calls write() for a long chunk. A big kmalloc triggers a heavy reclaim
havoc and it is very likely to fail.

This patch introduces smk_parse_substrings() function that parses a string into
substring separated by whitespaces.  The buffer for substring is preallocated.
It must store substring the worst case scenario which is SMK_LOAD2LEN in case
of long rule parsing.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 security/smack/smackfs.c |   68 ++++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 5dcd520..34d146b 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -364,6 +364,33 @@ static int smk_parse_rule(const char *data, struct smack_parsed_rule *rule,
 }
 
 /**
+ * smk_parse_strings - parse white-space separated substring from a string
+ * @src: a long string to be parsed, null terminated
+ * @dst: a buffer for substrings, should be at least strlen(src)+1 bytes
+ * @args: table for parsed substring
+ * @size: number of slots in args table
+ *
+ * Returns number of parsed substrings
+ */
+static int smk_parse_substrings(const char *src, char *dst,
+	char *args[], int size)
+{
+	int cnt;
+
+	for (cnt = 0; cnt < size; ++cnt) {
+		src = skip_spaces(src);
+		if (*src == 0)
+			break;
+		args[cnt] = dst;
+		for (; *src && !isspace(*src); ++src, ++dst)
+			*dst = *src;
+		*(dst++) = 0;
+	}
+
+	return cnt;
+}
+
+/**
  * smk_parse_long_rule - parse Smack rule from rule string
  * @data: string to be parsed, null terminated
  * @rule: Will be filled with Smack parsed rule
@@ -375,48 +402,29 @@ static int smk_parse_rule(const char *data, struct smack_parsed_rule *rule,
 static int smk_parse_long_rule(const char *data, struct smack_parsed_rule *rule,
 				int import, int change)
 {
-	char *subject;
-	char *object;
-	char *access1;
-	char *access2;
 	int datalen;
+	char *buffer;
+	char *args[4];
 	int rc = -1;
 
-	/* This is inefficient */
-	datalen = strlen(data);
+	datalen = strlen(data) + 1;
 
-	/* Our first element can be 64 + \0 with no spaces */
-	subject = kzalloc(datalen + 1, GFP_KERNEL);
-	if (subject == NULL)
+	buffer = kmalloc(datalen, GFP_KERNEL);
+	if (!buffer)
 		return -1;
-	object = kzalloc(datalen, GFP_KERNEL);
-	if (object == NULL)
-		goto free_out_s;
-	access1 = kzalloc(datalen, GFP_KERNEL);
-	if (access1 == NULL)
-		goto free_out_o;
-	access2 = kzalloc(datalen, GFP_KERNEL);
-	if (access2 == NULL)
-		goto free_out_a;
 
 	if (change) {
-		if (sscanf(data, "%s %s %s %s",
-			subject, object, access1, access2) == 4)
-			rc = smk_fill_rule(subject, object, access1, access2,
+		if (smk_parse_substrings(data, buffer, args, 4) == 4)
+			rc = smk_fill_rule(args[0], args[1], args[2], args[3],
 				rule, import, 0);
 	} else {
-		if (sscanf(data, "%s %s %s", subject, object, access1) == 3)
-			rc = smk_fill_rule(subject, object, access1, NULL,
+		if (smk_parse_substrings(data, buffer, args, 3) == 3)
+			rc = smk_fill_rule(args[0], args[1], args[2], NULL,
 				rule, import, 0);
 	}
 
-	kfree(access2);
-free_out_a:
-	kfree(access1);
-free_out_o:
-	kfree(object);
-free_out_s:
-	kfree(subject);
+	kfree(buffer);
+
 	return rc;
 }
 
-- 
1.7.9.5

