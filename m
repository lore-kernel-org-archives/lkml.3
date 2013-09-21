Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3IURpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 13:45:10 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33719 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3IURpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 13:45:07 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] modpost: Optionally ignore secondary errors seen if a single module build fails
Date: Sat, 21 Sep 2013 10:44:56 -0700
Message-Id: <1379785496-20209-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ea4054a23 (modpost: handle huge numbers of modules) added
support for building a large number of modules.

Unfortunately, the commit changed the semantics of the makefile: Instead of
passing only existing object files to modpost, make now passes all expected
object files. If make was started with option -i, this results in a modpost
error if a single file failed to build.

Example with the current btrfs build falure on m68k:

fs/btrfs/btrfs.o: No such file or directory
make[1]: [__modpost] Error 1 (ignored)

This error is followed by lots of errors such as:

m68k-linux-gcc: error: arch/m68k/emu/nfcon.mod.c: No such file or directory
m68k-linux-gcc: fatal error: no input files
compilation terminated.
make[1]: [arch/m68k/emu/nfcon.mod.o] Error 1 (ignored)

This doesn't matter much for normal builds, but it is annoying for builds
started with "make -i" due to the large number of secondary errors.
Those errors unnececessarily clog any error log and make it difficult
to find the real errors in the build.

Fix the problem by adding a new parameter '-n' to modpost. If this parameter
is specified, modpost reports but ignores missing object files.

With this patch, error output from above problem is (with make -i):

m68k-linux-ld: cannot find fs/btrfs/ioctl.o: No such file or directory
make[2]: [fs/btrfs/btrfs.o] Error 1 (ignored)
...
fs/btrfs/btrfs.o: No such file or directory (ignored)

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael Marek <mmarek@suse.cz>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Yet another attempt to fix this problem. I'll be happy to change the modpost
flag to something else if so desired. Note that -i is already taken, though.

I also did not change any of the existing object name filtering in
Makefile.modpost. This is on purpose; I am concerned about introducing
some other problem.

 scripts/Makefile.modpost |    4 +++-
 scripts/mod/modpost.c    |   13 ++++++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 8dcdca2..69f0a14 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -79,9 +79,11 @@ modpost = scripts/mod/modpost                    \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
 
+MODPOST_OPT=$(subst -i,-n,$(filter -i,$(MAKEFLAGS)))
+
 # We can go over command line length here, so be careful.
 quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
-      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$$/.o/' | $(modpost) -s -T -
+      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$$/.o/' | $(modpost) $(MODPOST_OPT) -s -T -
 
 PHONY += __modpost
 __modpost: $(modules:.ko=.o) FORCE
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 8247979..393706b 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -17,6 +17,7 @@
 #include <string.h>
 #include <limits.h>
 #include <stdbool.h>
+#include <errno.h>
 #include "modpost.h"
 #include "../../include/generated/autoconf.h"
 #include "../../include/linux/license.h"
@@ -37,6 +38,8 @@ static int warn_unresolved = 0;
 /* How a symbol is exported */
 static int sec_mismatch_count = 0;
 static int sec_mismatch_verbose = 1;
+/* ignore missing files */
+static int ignore_missing_files;
 
 enum export {
 	export_plain,      export_unused,     export_gpl,
@@ -407,6 +410,11 @@ static int parse_elf(struct elf_info *info, const char *filename)
 
 	hdr = grab_file(filename, &info->size);
 	if (!hdr) {
+		if (ignore_missing_files) {
+			fprintf(stderr, "%s: %s (ignored)\n", filename,
+				strerror(errno));
+			return 0;
+		}
 		perror(filename);
 		exit(1);
 	}
@@ -2119,7 +2127,7 @@ int main(int argc, char **argv)
 	struct ext_sym_list *extsym_iter;
 	struct ext_sym_list *extsym_start = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:e:msST:o:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:mnsST:o:awM:K:")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2139,6 +2147,9 @@ int main(int argc, char **argv)
 		case 'm':
 			modversions = 1;
 			break;
+		case 'n':
+			ignore_missing_files = 1;
+			break;
 		case 'o':
 			dump_write = optarg;
 			break;
-- 
1.7.9.7

