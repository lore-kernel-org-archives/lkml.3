Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3CTDmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 23:42:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3CTDmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 23:42:04 -0400
Date: Tue, 19 Mar 2013 20:43:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Bob Liu <lliubbo@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: make[2]: execvp: /bin/bash: Argument list too long
Message-Id: <20130319204313.041b6c71.akpm@linux-foundation.org>
In-Reply-To: <87vc8mpxys.fsf@rustcorp.com.au>
References: <5148064c.NHUmXnvVxwyYN+nc%fengguang.wu@intel.com>
	<20130318235058.8c3c78ec.akpm@linux-foundation.org>
	<20130319131025.GC2706@phenom.dumpdata.com>
	<20130319150204.GA11928@localhost>
	<87vc8mpxys.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013 13:41:07 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> Fengguang Wu <fengguang.wu@intel.com> writes:
> > On Tue, Mar 19, 2013 at 09:10:25AM -0400, Konrad Rzeszutek Wilk wrote:
> >> On Mon, Mar 18, 2013 at 11:50:58PM -0700, Andrew Morton wrote:
> >> > On Tue, 19 Mar 2013 14:31:40 +0800 kbuild test robot <fengguang.wu@intel.com> wrote:
> >> > 
> >> > > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next master
> >> > > head:   0e78c0989334e9c1d578ba25621de14e8441d8b4
> >> > > commit: 7cac5501aa2bd4777906fa0cdccc1b1ce18b3166 staging: zcache: enable zcache to be built/loaded as a module
> >> > > date:   26 hours ago
> >> > > config: make ARCH=i386 allmodconfig
> >> > > 
> >> > > All error/warnings:
> >> > > 
> >> > > >> make[2]: execvp: /bin/bash: Argument list too long
> >> > >    make[2]: *** [__modpost] Error 127
> >> > >    make[2]: Target `_modpost' not remade because of errors.
> >> > > 
> >> > 
> >> > Hey, I see that very occasionally, but it goes away all by itself.  Are
> >> > you sure that
> >> > staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
> >> > causes it?
> >
> > Sorry, I confirmed that it's a wrong bisect..
> >
> >> Is there a way to print out what the argument list is?
> >
> > Good idea! I managed to catch the error command with
> >
> >         strace -e trace=process -s 4096 -f -o argtoolong make -j1 --debug=j V=1 ARCH=i386 modules
> 
> Wow, nice!

That's what I thought.  A better approach would be to delete a few
thousand drivers ;)

I worry that we'll also explode some internal limit in make(1) when
preparing that list.  We'll see.

> modpost really does want all the modules at once, so it can check for
> unresolved symbols.  So xargs is out, we need to implement stdin-reading
> directly.
> 
> Bikeshedding on the option name reveals no established standard:
> -S/--stdin-file-list in shar, -T/--files-from=i in tar, --files-from=-
> in rsync.

Could just read the filenames from stdin if none were provided on the
command line, but whatever.

> Now, if someone can find a better way of getting the module list into a
> file/stdin, I'm all ears.  I'm not sure the find works in all cases...

How is that list generated at present?

So we have a vast string within make(1) and need to get it into a temp
file without using shell commands?  Tricky.

> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index cf82c83..421e14f 100644
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -78,12 +78,13 @@ modpost = scripts/mod/modpost                    \
>   $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
>   $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
>  
> -quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
> -      cmd_modpost = $(modpost) -s
> +# We can go over command line length here, so be careful.
> +quiet_cmd_modpost = MODPOST modules
> +      cmd_modpost = find * -name '*.ko' | $(modpost) -s -T -

I guess that's OK, as long as modpost handles non-object files
gracefully.

What's the risk that the find stumbles across random .ko files from
last month?  Pretty small, I guess - a `make clean' appears to rubs out
all .o files, even for different architectures.

>  PHONY += __modpost
>  __modpost: $(modules:.ko=.o) FORCE
> -	$(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)
> +	$(call cmd,modpost) $(wildcard vmlinux)
>  
>  quiet_cmd_kernel-mod = MODPOST $@
>        cmd_kernel-mod = $(modpost) $@
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 282decf..ff6b40b 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -15,6 +15,7 @@
>  #include <stdio.h>
>  #include <ctype.h>
>  #include <string.h>
> +#include <limits.h>
>  #include "modpost.h"
>  #include "../../include/generated/autoconf.h"
>  #include "../../include/linux/license.h"
> @@ -1756,6 +1757,28 @@ static void read_symbols(char *modname)
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
> +		/* Strip \n */
> +		if (strlen(fname))
> +			fname[strlen(fname)-1] = '\0';

That'll screw up if the file doesn't end in \n?

> +		read_symbols(fname);
> +	}
> +
> +	if (in != stdin)
> +		fclose(in);
> +}
> +

