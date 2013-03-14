Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab3CNKtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:49:52 -0400
Received: from multi.imgtec.com ([194.200.65.239]:62245 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756977Ab3CNKtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:49:47 -0400
Message-ID: <5141AB3A.2060705@imgtec.com>
Date: Thu, 14 Mar 2013 10:49:30 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Sam Ravnborg <sam@ravnborg.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-next@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-mtd@lists.infradead.org>
Subject: Re: [RFC -next] linux/linkage.h: fix symbol prefix handling
References: <1362656642-2693-1-git-send-email-james.hogan@imgtec.com> <87sj46wyf2.fsf@rustcorp.com.au> <5139AC39.90805@imgtec.com> <874ngiwije.fsf@rustcorp.com.au> <20130311230731.0c610d86569d09f6e23b8e61@canb.auug.org.au> <87ppz5usts.fsf@rustcorp.com.au> <20130312233300.9d86d47bb5369923ad520a21@canb.auug.org.au> <87ehfkuq27.fsf@rustcorp.com.au> <20130313063157.GB19681@merkur.ravnborg.org> <87zjy6tytz.fsf@rustcorp.com.au>
In-Reply-To: <87zjy6tytz.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_14_10_49_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/13 04:00, Rusty Russell wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Subject: CONFIG_SYMBOL_PREFIX: cleanup.
> 
> We have CONFIG_SYMBOL_PREFIX, which three archs define to the string
> "_".  But Al Viro broke this in "consolidate cond_syscall and
> SYSCALL_ALIAS declarations" (in linux-next), and he's not the first to
> do so.
> 
> Using CONFIG_SYMBOL_PREFIX is awkward, since we usually just want to
> prefix it so something.  So various places define helpers which are
> defined to nothing if CONFIG_SYMBOL_PREFIX isn't set:
> 
> 1) include/asm-generic/unistd.h defines __SYMBOL_PREFIX.
> 2) include/asm-generic/vmlinux.lds.h defines VMLINUX_SYMBOL(sym)
> 3) include/linux/export.h defines MODULE_SYMBOL_PREFIX.
> 4) include/linux/kernel.h defines SYMBOL_PREFIX (which differs from #7)
> 5) kernel/modsign_certificate.S defines ASM_SYMBOL(sym)
> 6) scripts/modpost.c defines MODULE_SYMBOL_PREFIX
> 7) scripts/Makefile.lib defines SYMBOL_PREFIX on the commandline if
>    CONFIG_SYMBOL_PREFIX is set, so that we have a non-string version
>    for pasting.
> 
> (arch/h8300/include/asm/linkage.h defines SYMBOL_NAME(), too).
> 
> Let's solve this properly:
> 1) No more generic prefix, just CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX.
> 2) Make linux/export.h usable from asm.
> 3) Define VMLINUX_SYMBOL() and VMLINUX_SYMBOL_STR().
> 4) Make everyone use them.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Reviewed-by: James Hogan <james.hogan@imgtec.com>
Tested-by: James Hogan <james.hogan@imgtec.com> (metag)

The only other special case of symbol prefixing I'm aware of is in
scripts/genksyms/genksyms.c. It makes the decision at runtime based
on the --arch=$ARCH argument, and is the only use of the arch argument:

> 	if ((strcmp(arch, "h8300") == 0) || (strcmp(arch, "blackfin") == 0) ||
> 	    (strcmp(arch, "metag") == 0))
> 		mod_prefix = "_";

Does the patch below look reasonable in addition to your patch?
(Note: I'm not sure if genksyms is only used internally or whether
it's API should be kept stable?).

Thanks
James

Subject: [PATCH] genksyms: pass symbol-prefix instead of arch

Pass symbol-prefix to genksyms instead of arch, so that the decision
what symbol prefix to use is kept in one place.

Basically genksyms used to take a -a $ARCH argument and it used that to
determine whether to add an underscore symbol prefix. It's now changed
to take a -s $SYMBOL_PREFIX argument so that the caller decides whether
a symbol prefix is required. The build system then uses
CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX to determine whether to pass the
argument.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 scripts/Makefile.build      |  3 ++-
 scripts/genksyms/genksyms.c | 18 +++++++-----------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 0e801c3..d5d859c 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -211,7 +211,8 @@ $(obj)/%.i: $(src)/%.c FORCE
 
 cmd_gensymtypes =                                                           \
     $(CPP) -D__GENKSYMS__ $(c_flags) $< |                                   \
-    $(GENKSYMS) $(if $(1), -T $(2)) -a $(ARCH)                              \
+    $(GENKSYMS) $(if $(1), -T $(2))                                         \
+     $(patsubst y,-s _,$(CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX))             \
      $(if $(KBUILD_PRESERVE),-p)                                            \
      -r $(firstword $(wildcard $(2:.symtypes=.symref) /dev/null))
 
diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
index d25e4a1..88632df 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -45,7 +45,6 @@ int in_source_file;
 
 static int flag_debug, flag_dump_defs, flag_reference, flag_dump_types,
 	   flag_preserve, flag_warnings;
-static const char *arch = "";
 static const char *mod_prefix = "";
 
 static int errors;
@@ -731,7 +730,7 @@ static void genksyms_usage(void)
 {
 	fputs("Usage:\n" "genksyms [-adDTwqhV] > /path/to/.tmp_obj.ver\n" "\n"
 #ifdef __GNU_LIBRARY__
-	      "  -a, --arch            Select architecture\n"
+	      "  -s, --symbol-prefix   Select symbol prefix\n"
 	      "  -d, --debug           Increment the debug level (repeatable)\n"
 	      "  -D, --dump            Dump expanded symbol defs (for debugging only)\n"
 	      "  -r, --reference file  Read reference symbols from a file\n"
@@ -742,7 +741,7 @@ static void genksyms_usage(void)
 	      "  -h, --help            Print this message\n"
 	      "  -V, --version         Print the release version\n"
 #else				/* __GNU_LIBRARY__ */
-	      "  -a                    Select architecture\n"
+	      "  -s                    Select symbol prefix\n"
 	      "  -d                    Increment the debug level (repeatable)\n"
 	      "  -D                    Dump expanded symbol defs (for debugging only)\n"
 	      "  -r file               Read reference symbols from a file\n"
@@ -763,7 +762,7 @@ int main(int argc, char **argv)
 
 #ifdef __GNU_LIBRARY__
 	struct option long_opts[] = {
-		{"arch", 1, 0, 'a'},
+		{"symbol-prefix", 1, 0, 's'},
 		{"debug", 0, 0, 'd'},
 		{"warnings", 0, 0, 'w'},
 		{"quiet", 0, 0, 'q'},
@@ -776,14 +775,14 @@ int main(int argc, char **argv)
 		{0, 0, 0, 0}
 	};
 
-	while ((o = getopt_long(argc, argv, "a:dwqVDr:T:ph",
+	while ((o = getopt_long(argc, argv, "s:dwqVDr:T:ph",
 				&long_opts[0], NULL)) != EOF)
 #else				/* __GNU_LIBRARY__ */
-	while ((o = getopt(argc, argv, "a:dwqVDr:T:ph")) != EOF)
+	while ((o = getopt(argc, argv, "s:dwqVDr:T:ph")) != EOF)
 #endif				/* __GNU_LIBRARY__ */
 		switch (o) {
-		case 'a':
-			arch = optarg;
+		case 's':
+			mod_prefix = optarg;
 			break;
 		case 'd':
 			flag_debug++;
@@ -826,9 +825,6 @@ int main(int argc, char **argv)
 			genksyms_usage();
 			return 1;
 		}
-	if ((strcmp(arch, "h8300") == 0) || (strcmp(arch, "blackfin") == 0) ||
-	    (strcmp(arch, "metag") == 0))
-		mod_prefix = "_";
 	{
 		extern int yydebug;
 		extern int yy_flex_debug;
-- 
1.8.1.2


