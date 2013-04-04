Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763793Ab3DDHva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:51:30 -0400
Received: from ozlabs.org ([203.10.76.45]:56545 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763745Ab3DDHv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:51:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Bob Liu <lliubbo@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: make[2]: execvp: /bin/bash: Argument list too long
In-Reply-To: <87boadpluf.fsf@rustcorp.com.au>
References: <5148064c.NHUmXnvVxwyYN+nc%fengguang.wu@intel.com> <20130318235058.8c3c78ec.akpm@linux-foundation.org> <20130319131025.GC2706@phenom.dumpdata.com> <20130319150204.GA11928@localhost> <87vc8mpxys.fsf@rustcorp.com.au> <20130319204313.041b6c71.akpm@linux-foundation.org> <87boadpluf.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 04 Apr 2013 17:35:41 +1030
Message-ID: <87li8y3hdm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:
> If this passes review, I'll split properly into three patches.
>
> Thanks,
> Rusty.

Noone commented, so split into 3 and into modules-next it goes...

Cheers,
Rusty.

> modpost: handle huge numbers of modules.
>
> (FIXME: Split into multiple patches).
>
> strace shows:
> 72102 execve("/bin/sh", ["/bin/sh", "-c", "echo '  scripts/mod/modpost -m -a
> -o /cc/wfg/sound-compiletest/Module.symvers      -s'; scripts/
> mod/modpost -m -a -o /cc/wfg/sound-compiletest/Module.symvers      -s vmlinux
> arch/x86/crypto/ablk_helper.o arch/x86/crypto/aes-i586.o arch
> /x86/crypto/aesni-intel.o arch/x86/crypto/crc32-pclmul.o
> ...
> drivers/ata/sata_promise.o "...], [/* 119 vars */] <unfinished ...>
> 71827 wait4(-1,  <unfinished ...>
> 72102 <... execve resumed> )            = -1 E2BIG (Argument list too long)
>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index cf82c83..8dcdca2 100644
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -60,7 +60,8 @@ kernelsymfile := $(objtree)/Module.symvers
>  modulesymfile := $(firstword $(KBUILD_EXTMOD))/Module.symvers
>  
>  # Step 1), find all modules listed in $(MODVERDIR)/
> -__modules := $(sort $(shell grep -h '\.ko$$' /dev/null $(wildcard $(MODVERDIR)/*.mod)))
> +MODLISTCMD := find $(MODVERDIR) -name '*.mod' | xargs -r grep -h '\.ko$$' | sort -u
> +__modules := $(shell $(MODLISTCMD))
>  modules   := $(patsubst %.o,%.ko, $(wildcard $(__modules:.ko=.o)))
>  
>  # Stop after building .o files if NOFINAL is set. Makes compile tests quicker
> @@ -78,12 +79,13 @@ modpost = scripts/mod/modpost                    \
>   $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
>   $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
>  
> +# We can go over command line length here, so be careful.
>  quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
> -      cmd_modpost = $(modpost) -s
> +      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$$/.o/' | $(modpost) -s -T -
>  
>  PHONY += __modpost
>  __modpost: $(modules:.ko=.o) FORCE
> -	$(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)
> +	$(call cmd,modpost) $(wildcard vmlinux)
>  
>  quiet_cmd_kernel-mod = MODPOST $@
>        cmd_kernel-mod = $(modpost) $@
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index f6913db..1f90961 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -15,6 +15,8 @@
>  #include <stdio.h>
>  #include <ctype.h>
>  #include <string.h>
> +#include <limits.h>
> +#include <stdbool.h>
>  #include "modpost.h"
>  #include "../../include/generated/autoconf.h"
>  #include "../../include/linux/license.h"
> @@ -78,6 +80,14 @@ PRINTF void merror(const char *fmt, ...)
>  	va_end(arglist);
>  }
>  
> +static inline bool strends(const char *str, const char *postfix)
> +{
> +	if (strlen(str) < strlen(postfix))
> +		return false;
> +
> +	return strcmp(str + strlen(str) - strlen(postfix), postfix) == 0;
> +}
> +
>  static int is_vmlinux(const char *modname)
>  {
>  	const char *myname;
> @@ -113,22 +123,20 @@ static struct module *find_module(char *modname)
>  	return mod;
>  }
>  
> -static struct module *new_module(char *modname)
> +static struct module *new_module(const char *modname)
>  {
>  	struct module *mod;
> -	char *p, *s;
> +	char *p;
>  
>  	mod = NOFAIL(malloc(sizeof(*mod)));
>  	memset(mod, 0, sizeof(*mod));
>  	p = NOFAIL(strdup(modname));
>  
>  	/* strip trailing .o */
> -	s = strrchr(p, '.');
> -	if (s != NULL)
> -		if (strcmp(s, ".o") == 0) {
> -			*s = '\0';
> -			mod->is_dot_o = 1;
> -		}
> +	if (strends(p, ".o")) {
> +		p[strlen(p) - 2] = '\0';
> +		mod->is_dot_o = 1;
> +	}
>  
>  	/* add to list */
>  	mod->name = p;
> @@ -1756,6 +1764,27 @@ static void read_symbols(char *modname)
>  		mod->unres = alloc_symbol("module_layout", 0, mod->unres);
>  }
>  
> +static void read_symbols_from_files(const char *filename)
> +{
> +	FILE *in = stdin;
> +	char fname[PATH_MAX];
> +
> +	if (strcmp(filename, "-") != 0) {
> +		in = fopen(filename, "r");
> +		if (!in)
> +			fatal("Can't open filenames file %s: %m", filename);
> +	}
> +
> +	while (fgets(fname, PATH_MAX, in) != NULL) {
> +		if (strends(fname, "\n"))
> +			fname[strlen(fname)-1] = '\0';
> +		read_symbols(fname);
> +	}
> +
> +	if (in != stdin)
> +		fclose(in);
> +}
> +
>  #define SZ 500
>  
>  /* We first write the generated file into memory using the
> @@ -2117,13 +2146,13 @@ int main(int argc, char **argv)
>  	struct module *mod;
>  	struct buffer buf = { };
>  	char *kernel_read = NULL, *module_read = NULL;
> -	char *dump_write = NULL;
> +	char *dump_write = NULL, *files_source = NULL;
>  	int opt;
>  	int err;
>  	struct ext_sym_list *extsym_iter;
>  	struct ext_sym_list *extsym_start = NULL;
>  
> -	while ((opt = getopt(argc, argv, "i:I:e:msSo:awM:K:")) != -1) {
> +	while ((opt = getopt(argc, argv, "i:I:e:msST:o:awM:K:")) != -1) {
>  		switch (opt) {
>  		case 'i':
>  			kernel_read = optarg;
> @@ -2155,6 +2184,9 @@ int main(int argc, char **argv)
>  		case 'S':
>  			sec_mismatch_verbose = 0;
>  			break;
> +		case 'T':
> +			files_source = optarg;
> +			break;
>  		case 'w':
>  			warn_unresolved = 1;
>  			break;
> @@ -2177,6 +2209,9 @@ int main(int argc, char **argv)
>  	while (optind < argc)
>  		read_symbols(argv[optind++]);
>  
> +	if (files_source)
> +		read_symbols_from_files(files_source);
> +
>  	for (mod = modules; mod; mod = mod->next) {
>  		if (mod->skip)
>  			continue;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
