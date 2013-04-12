Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3DLMar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:30:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:37038 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab3DLMao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:30:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,462,1363158000"; 
   d="scan'208";a="321404552"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/4] binfmt_misc: reuse string_unescape_inplace()
Date: Fri, 12 Apr 2013 15:30:20 +0300
Message-Id: <1365769820-28953-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1365769820-28953-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1365769820-28953-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is string_unescape_inplace() function which decodes strings in generic
way. Let's use it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/binfmt_misc.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 751df5e..1c740e1 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -23,6 +23,7 @@
 #include <linux/binfmts.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <linux/string_helpers.h>
 #include <linux/file.h>
 #include <linux/pagemap.h>
 #include <linux/namei.h>
@@ -234,24 +235,6 @@ static char *scanarg(char *s, char del)
 	return s;
 }
 
-static int unquote(char *from)
-{
-	char c = 0, *s = from, *p = from;
-
-	while ((c = *s++) != '\0') {
-		if (c == '\\' && *s == 'x') {
-			s++;
-			c = toupper(*s++);
-			*p = (c - (isdigit(c) ? '0' : 'A' - 10)) << 4;
-			c = toupper(*s++);
-			*p++ |= c - (isdigit(c) ? '0' : 'A' - 10);
-			continue;
-		}
-		*p++ = c;
-	}
-	return p - from;
-}
-
 static char * check_special_flags (char * sfs, Node * e)
 {
 	char * p = sfs;
@@ -354,8 +337,9 @@ static Node *create_entry(const char __user *buffer, size_t count)
 		p[-1] = '\0';
 		if (!e->mask[0])
 			e->mask = NULL;
-		e->size = unquote(e->magic);
-		if (e->mask && unquote(e->mask) != e->size)
+		e->size = string_unescape_inplace(e->magic, UNESCAPE_HEX);
+		if (e->mask &&
+		    string_unescape_inplace(e->mask, UNESCAPE_HEX) != e->size)
 			goto Einval;
 		if (e->size + e->offset > BINPRM_BUF_SIZE)
 			goto Einval;
-- 
1.8.2.rc0.22.gb3600c3

