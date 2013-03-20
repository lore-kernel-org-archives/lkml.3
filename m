Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177Ab3CTDNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 23:13:49 -0400
Received: from ozlabs.org ([203.10.76.45]:40848 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150Ab3CTDNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 23:13:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Bob Liu <lliubbo@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: make[2]: execvp: /bin/bash: Argument list too long
In-Reply-To: <20130319150204.GA11928@localhost>
References: <5148064c.NHUmXnvVxwyYN+nc%fengguang.wu@intel.com> <20130318235058.8c3c78ec.akpm@linux-foundation.org> <20130319131025.GC2706@phenom.dumpdata.com> <20130319150204.GA11928@localhost>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 20 Mar 2013 13:41:07 +1030
Message-ID: <87vc8mpxys.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:
> On Tue, Mar 19, 2013 at 09:10:25AM -0400, Konrad Rzeszutek Wilk wrote:
>> On Mon, Mar 18, 2013 at 11:50:58PM -0700, Andrew Morton wrote:
>> > On Tue, 19 Mar 2013 14:31:40 +0800 kbuild test robot <fengguang.wu@intel.com> wrote:
>> > 
>> > > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next master
>> > > head:   0e78c0989334e9c1d578ba25621de14e8441d8b4
>> > > commit: 7cac5501aa2bd4777906fa0cdccc1b1ce18b3166 staging: zcache: enable zcache to be built/loaded as a module
>> > > date:   26 hours ago
>> > > config: make ARCH=i386 allmodconfig
>> > > 
>> > > All error/warnings:
>> > > 
>> > > >> make[2]: execvp: /bin/bash: Argument list too long
>> > >    make[2]: *** [__modpost] Error 127
>> > >    make[2]: Target `_modpost' not remade because of errors.
>> > > 
>> > 
>> > Hey, I see that very occasionally, but it goes away all by itself.  Are
>> > you sure that
>> > staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
>> > causes it?
>
> Sorry, I confirmed that it's a wrong bisect..
>
>> Is there a way to print out what the argument list is?
>
> Good idea! I managed to catch the error command with
>
>         strace -e trace=process -s 4096 -f -o argtoolong make -j1 --debug=j V=1 ARCH=i386 modules

Wow, nice!

modpost really does want all the modules at once, so it can check for
unresolved symbols.  So xargs is out, we need to implement stdin-reading
directly.

Bikeshedding on the option name reveals no established standard:
-S/--stdin-file-list in shar, -T/--files-from=i in tar, --files-from=-
in rsync.

Now, if someone can find a better way of getting the module list into a
file/stdin, I'm all ears.  I'm not sure the find works in all cases...

Thanks,
Rusty.

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index cf82c83..421e14f 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -78,12 +78,13 @@ modpost = scripts/mod/modpost                    \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
 
-quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
-      cmd_modpost = $(modpost) -s
+# We can go over command line length here, so be careful.
+quiet_cmd_modpost = MODPOST modules
+      cmd_modpost = find * -name '*.ko' | $(modpost) -s -T -
 
 PHONY += __modpost
 __modpost: $(modules:.ko=.o) FORCE
-	$(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)
+	$(call cmd,modpost) $(wildcard vmlinux)
 
 quiet_cmd_kernel-mod = MODPOST $@
       cmd_kernel-mod = $(modpost) $@
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 282decf..ff6b40b 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -15,6 +15,7 @@
 #include <stdio.h>
 #include <ctype.h>
 #include <string.h>
+#include <limits.h>
 #include "modpost.h"
 #include "../../include/generated/autoconf.h"
 #include "../../include/linux/license.h"
@@ -1756,6 +1757,28 @@ static void read_symbols(char *modname)
 		mod->unres = alloc_symbol("module_layout", 0, mod->unres);
 }
 
+static void read_symbols_from_files(const char *filename)
+{
+	FILE *in = stdin;
+	char fname[PATH_MAX];
+
+	if (strcmp(filename, "-") != 0) {
+		in = fopen(filename, "r");
+		if (!in)
+			fatal("Can't open filenames file %s: %m", filename);
+	}
+
+	while (fgets(fname, PATH_MAX, in) != NULL) {
+		/* Strip \n */
+		if (strlen(fname))
+			fname[strlen(fname)-1] = '\0';
+		read_symbols(fname);
+	}
+
+	if (in != stdin)
+		fclose(in);
+}
+
 #define SZ 500
 
 /* We first write the generated file into memory using the
@@ -2116,13 +2139,13 @@ int main(int argc, char **argv)
 	struct module *mod;
 	struct buffer buf = { };
 	char *kernel_read = NULL, *module_read = NULL;
-	char *dump_write = NULL;
+	char *dump_write = NULL, *files_source = NULL;
 	int opt;
 	int err;
 	struct ext_sym_list *extsym_iter;
 	struct ext_sym_list *extsym_start = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:e:msSo:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:msST:o:awM:K:")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2154,6 +2177,9 @@ int main(int argc, char **argv)
 		case 'S':
 			sec_mismatch_verbose = 0;
 			break;
+		case 'T':
+			files_source = optarg;
+			break;
 		case 'w':
 			warn_unresolved = 1;
 			break;
@@ -2176,6 +2202,9 @@ int main(int argc, char **argv)
 	while (optind < argc)
 		read_symbols(argv[optind++]);
 
+	if (files_source)
+		read_symbols_from_files(files_source);
+
 	for (mod = modules; mod; mod = mod->next) {
 		if (mod->skip)
 			continue;


