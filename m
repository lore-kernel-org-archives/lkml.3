Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3EMOjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:39:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3EMOjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:39:22 -0400
Date: Mon, 13 May 2013 16:35:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: [RFC] teach argv_split() to ignore the spaces surrounded by \e
Message-ID: <20130513143537.GA3278@redhat.com>
References: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com> <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com> <20130510125826.GA553@redhat.com> <CAKi4VALE8tFUTZ1qYwm0Eth1zFMU8xA6XC5RTnF1KCKYQp-0NQ@mail.gmail.com> <20130510153638.GA8179@redhat.com> <CAKi4VAJPXgiik9CGrVyk7cCvz-1913p1KL8tn5FvxH4w0r27bg@mail.gmail.com> <20130510171054.GA27479@redhat.com> <CAKi4VAK7KA6WyVkuw+QMBnzF63b-67Gq-VmhWBs69Q0Wnc7wNw@mail.gmail.com> <20130513141633.GB1613@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513141633.GB1613@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Oleg Nesterov wrote:
>
> Lucas. I will be happy to resend the argv_split/call_modprobe changes,

speaking of argv_split...

What do you all think about the hack below? Sure, this is user-visible
and incompatible change, but perhaps we can do this?

Let me quote Lennart:

	Currently, if the kernel generates one command line string from the core
	pattern (if it is one with a |) and then splits that up again where it
	finds spaces. This is really broken for %e if a process name contains
	spaces.

Yes, we can change format_corename() to construct "argv" by hand, and
this was my iniital plan. But perhaps it would be better to not uglify
this code even more?

With the patch below we can trivially fix the problem,

	+	char *fmt = ispipe ? "\e%s\e" : "%s";
	...
	-	err = cn_printf(cn, "%s", current->comm);
	+	err = cn_printf(cn, fmt, current->comm);

Or this ESC hack is too ugly or can break something?

Oleg.

------------------------------------------------------------------------------
[PATCH] teach argv_split() to ignore the spaces surrounded by \e

This patch assumes that nobody ever wants "\e" in the string
passed to argv_split().

With this change argv_split() treats '\e' as white-space and
ignores all other spaces till the next '\e'. For example,
argv("1\e2  3\e \e 4 \e") returns

	[0] = "1",
	[1] = "2 3",
	[2] = " 4 ",
	[3] = NULL,

This allows us to trivially fix format_corename(), we do not
want to split, say, current->comm if it has spaces.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 lib/argv_split.c |   37 +++++++++++++++++++++++++------------
 1 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/lib/argv_split.c b/lib/argv_split.c
index e927ed0..e74221c 100644
--- a/lib/argv_split.c
+++ b/lib/argv_split.c
@@ -8,13 +8,23 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 
+static bool argv_isspace(char ch, bool *in_esc)
+{
+	if (unlikely(ch == '\e')) {
+		*in_esc = !*in_esc;
+		return true;
+	}
+
+	return !*in_esc && isspace(ch);
+}
+
 static int count_argc(const char *str)
 {
+	bool was_space, in_esc;
 	int count = 0;
-	bool was_space;
 
-	for (was_space = true; *str; str++) {
-		if (isspace(*str)) {
+	for (in_esc = false, was_space = true; *str; str++) {
+		if (argv_isspace(*str, &in_esc)) {
 			was_space = true;
 		} else if (was_space) {
 			was_space = false;
@@ -45,21 +55,24 @@ EXPORT_SYMBOL(argv_free);
  * @str: the string to be split
  * @argcp: returned argument count
  *
- * Returns an array of pointers to strings which are split out from
- * @str.  This is performed by strictly splitting on white-space; no
- * quote processing is performed.  Multiple whitespace characters are
- * considered to be a single argument separator.  The returned array
- * is always NULL-terminated.  Returns NULL on memory allocation
- * failure.
+ * Returns an array of pointers to strings which are split out from @str.
+ * The returned array is always NULL-terminated.  Returns NULL on memory
+ * allocation failure.
+ *
+ * This is performed by splitting on white-space, no quote processing is
+ * performed except: '\e' is counted as space, and all spaces till the
+ * next '\e' are ignored. Multiple whitespace characters are considered
+ * to be a single argument separator.
  *
  * The source string at `str' may be undergoing concurrent alteration via
  * userspace sysctl activity (at least).  The argv_split() implementation
  * attempts to handle this gracefully by taking a local copy to work on.
  */
+
 char **argv_split(gfp_t gfp, const char *str, int *argcp)
 {
 	char *argv_str;
-	bool was_space;
+	bool was_space, in_esc;
 	char **argv, **argv_ret;
 	int argc;
 
@@ -76,8 +89,8 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
 
 	*argv = argv_str;
 	argv_ret = ++argv;
-	for (was_space = true; *argv_str; argv_str++) {
-		if (isspace(*argv_str)) {
+	for (in_esc = false, was_space = true; *argv_str; argv_str++) {
+		if (argv_isspace(*argv_str, &in_esc)) {
 			was_space = true;
 			*argv_str = 0;
 		} else if (was_space) {
-- 
1.5.5.1


