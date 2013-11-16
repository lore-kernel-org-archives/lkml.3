Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab3KPIYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 03:24:50 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55589 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3KPIYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 03:24:40 -0500
From: "Du, Changbin" <changbin.du@gmail.com>
To: jbaron@akamai.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org,
        akpm@linux-foundation.org, "Du, Changbin" <changbin.du@gmail.com>
Subject: [PATCH v5 1/3] lib/parser.c: add match_wildcard function
Date: Sat, 16 Nov 2013 16:24:07 +0800
Message-Id: <1384590249-16672-2-git-send-email-changbin.du@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1384590249-16672-1-git-send-email-changbin.du@gmail.com>
References: <1384590249-16672-1-git-send-email-changbin.du@gmail.com>
In-Reply-To: <CABgQ-Th3arUm=rLcv4FGRamAN00kGnDsO_VsHkRp4ZfFGOjaZQ@mail.gmail.com>
References: <CABgQ-Th3arUm=rLcv4FGRamAN00kGnDsO_VsHkRp4ZfFGOjaZQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Du, Changbin" <changbin.du@gmail.com>

match_wildcard function is a simple implementation of wildcard
matching algorithm. It only supports two usual wildcardes:
    '*' - matches zero or more characters
    '?' - matches one character
This algorithm is safe since it's of non-recursion.

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
---
 include/linux/parser.h |  1 +
 lib/parser.c           | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/linux/parser.h b/include/linux/parser.h
index ea2281e..39d5b79 100644
--- a/include/linux/parser.h
+++ b/include/linux/parser.h
@@ -29,5 +29,6 @@ int match_token(char *, const match_table_t table, substring_t args[]);
 int match_int(substring_t *, int *result);
 int match_octal(substring_t *, int *result);
 int match_hex(substring_t *, int *result);
+bool match_wildcard(const char *pattern, const char *str);
 size_t match_strlcpy(char *, const substring_t *, size_t);
 char *match_strdup(const substring_t *);
diff --git a/lib/parser.c b/lib/parser.c
index 807b2aa..ee52955 100644
--- a/lib/parser.c
+++ b/lib/parser.c
@@ -193,6 +193,56 @@ int match_hex(substring_t *s, int *result)
 }
 
 /**
+ * match_wildcard: - parse if a string matches given wildcard pattern
+ * @pattern: wildcard pattern
+ * @str: the string to be parsed
+ *
+ * Description: Parse the string @str to check if matches wildcard
+ * pattern @pattern. The pattern may contain two type wildcardes:
+ *   '*' - matches zero or more characters
+ *   '?' - matches one character
+ * If it's matched, return true, else return false.
+ */
+bool match_wildcard(const char *pattern, const char *str)
+{
+	const char *s = str;
+	const char *p = pattern;
+	bool star = false;
+
+	while (*s) {
+		switch (*p) {
+		case '?':
+			s++;
+			p++;
+			break;
+		case '*':
+			star = true;
+			str = s;
+			if (!*++p)
+				return true;
+			pattern = p;
+			break;
+		default:
+			if (*s == *p) {
+				s++;
+				p++;
+			} else {
+				if (!star)
+					return false;
+				str++;
+				s = str;
+				p = pattern;
+			}
+			break;
+		}
+	}
+
+	if (*p == '*')
+		++p;
+	return !*p;
+}
+
+/**
  * match_strlcpy: - Copy the characters from a substring_t to a sized buffer
  * @dest: where to copy to
  * @src: &substring_t to copy
@@ -235,5 +285,6 @@ EXPORT_SYMBOL(match_token);
 EXPORT_SYMBOL(match_int);
 EXPORT_SYMBOL(match_octal);
 EXPORT_SYMBOL(match_hex);
+EXPORT_SYMBOL(match_wildcard);
 EXPORT_SYMBOL(match_strlcpy);
 EXPORT_SYMBOL(match_strdup);
-- 
1.8.3.2

