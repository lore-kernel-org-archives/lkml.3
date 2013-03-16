Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3CPU0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 16:26:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915Ab3CPU0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 16:26:02 -0400
Date: Sat, 16 Mar 2013 21:23:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH 1/2] teach argv_split() to handle the mutable strings
Message-ID: <20130316202353.GB18613@redhat.com>
References: <20130312182210.GA15862@redhat.com> <CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com> <20130312191118.GA17439@redhat.com> <CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com> <20130312203514.GA23488@redhat.com> <20130313174641.GA28083@redhat.com> <20130313174705.GB28083@redhat.com> <20130314152819.7fb1242b493e8bad2d34671b@linux-foundation.org> <20130315163916.GA31995@redhat.com> <20130316202327.GA18613@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316202327.GA18613@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

argv_split() allocates argv[count_argc(str)] array and assumes that
it will find the same number of arguments later. This is obviously
wrong if this string can be changed, say, by sysctl.

With this patch argv_split() kstrndup's the whole string and does
not split it, we simply replace the spaces with zeroes and keep the
allocated memory in argv[-1] for argv_free(arg).

We do not use argv[0] because:

	- str can be all-spaces or empty. In fact this case is fine,
	  we could kfree() it before return, but:

	- str can have a space at the start, and we can not rely on
	  kstrndup(skip_arg(str)) because it can equally race if this
	  string is mutable.

Also, simplify count_argc() and kill the no longer used skip_arg().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 lib/argv_split.c |   82 +++++++++++++++++++++++-------------------------------
 1 files changed, 35 insertions(+), 47 deletions(-)

diff --git a/lib/argv_split.c b/lib/argv_split.c
index 1e9a6cb..dfa534d 100644
--- a/lib/argv_split.c
+++ b/lib/argv_split.c
@@ -8,23 +8,17 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 
-static const char *skip_arg(const char *cp)
-{
-	while (*cp && !isspace(*cp))
-		cp++;
-
-	return cp;
-}
-
 static int count_argc(const char *str)
 {
 	int count = 0;
+	bool was_space;
 
-	while (*str) {
-		str = skip_spaces(str);
-		if (*str) {
+	for (was_space = true; *str; str++) {
+		if (isspace(*str)) {
+			was_space = true;
+		} else if (was_space) {
+			was_space = false;
 			count++;
-			str = skip_arg(str);
 		}
 	}
 
@@ -39,10 +33,7 @@ static int count_argc(const char *str)
  */
 void argv_free(char **argv)
 {
-	char **p;
-	for (p = argv; *p; p++)
-		kfree(*p);
-
+	kfree(argv[-1]);
 	kfree(argv);
 }
 EXPORT_SYMBOL(argv_free);
@@ -62,40 +53,37 @@ EXPORT_SYMBOL(argv_free);
  */
 char **argv_split(gfp_t gfp, const char *str, int *argcp)
 {
-	int argc = count_argc(str);
-	char **argv = kzalloc(sizeof(*argv) * (argc+1), gfp);
-	char **argvp;
-
-	if (argv == NULL)
-		goto out;
-
-	if (argcp)
-		*argcp = argc;
-
-	argvp = argv;
-
-	while (*str) {
-		str = skip_spaces(str);
-
-		if (*str) {
-			const char *p = str;
-			char *t;
-
-			str = skip_arg(str);
+	char *argv_str;
+	bool was_space;
+	char **argv, **argv_ret;
+	int argc;
+
+	argv_str = kstrndup(str, KMALLOC_MAX_SIZE, gfp);
+	if (!argv_str)
+		return NULL;
+
+	argc = count_argc(argv_str);
+	argv = kmalloc(sizeof(*argv) * (argc + 2), gfp);
+	if (!argv) {
+		kfree(argv_str);
+		return NULL;
+	}
 
-			t = kstrndup(p, str-p, gfp);
-			if (t == NULL)
-				goto fail;
-			*argvp++ = t;
+	*argv = argv_str;
+	argv_ret = ++argv;
+	for (was_space = true; *argv_str; argv_str++) {
+		if (isspace(*argv_str)) {
+			was_space = true;
+			*argv_str = 0;
+		} else if (was_space) {
+			was_space = false;
+			*argv++ = argv_str;
 		}
 	}
-	*argvp = NULL;
-
-  out:
-	return argv;
+	*argv = NULL;
 
-  fail:
-	argv_free(argv);
-	return NULL;
+	if (argcp)
+		*argcp = argc;
+	return argv_ret;
 }
 EXPORT_SYMBOL(argv_split);
-- 
1.5.5.1


