Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaGLOoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 10:44:39 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49642 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaGLOoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 10:44:23 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH v2 8/8] kallsyms: exclude pseudo symbols for __init / __exit strings
Date: Sat, 12 Jul 2014 16:43:32 +0200
Message-Id: <1405176212-12175-9-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405176212-12175-1-git-send-email-minipli@googlemail.com>
References: <1405176212-12175-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __init_str() / __exit_str() annotations create pseudo symbols.
Ignore them, they have no value for us.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 scripts/kallsyms.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index dc7aa45e80..8fd0f2965d 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -88,6 +88,16 @@ static inline int is_arm_mapping_symbol(const char *str)
 	       && (str[2] == '\0' || str[2] == '.');
 }
 
+/*
+ * This ignores the pseudo symbols for __init_str() / __exit_str() annotated
+ * strings.
+ */
+static inline int is_init_exit_str_symbol(const char *str)
+{
+	return strncmp(str, "__UNIQUE_ID__init_str_", 22) == 0 ||
+	       strncmp(str, "__UNIQUE_ID__exit_str_", 22) == 0;
+}
+
 static int check_symbol_range(const char *sym, unsigned long long addr,
 			      struct addr_range *ranges, int entries)
 {
@@ -158,6 +168,9 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 	/* exclude debugging symbols */
 	else if (stype == 'N')
 		return -1;
+	/* exclude pseudo symbols for __init / __exit strings */
+	else if (stype == 't' && is_init_exit_str_symbol(sym))
+		return -1;
 
 	/* include the type field in the symbol name, so that it gets
 	 * compressed together */
-- 
1.7.10.4

