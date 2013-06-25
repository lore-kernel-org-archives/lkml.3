Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab3FYPJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:09:51 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:50441 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3FYPJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:09:49 -0400
Date: Tue, 25 Jun 2013 16:09:41 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: scripts/kallsyms: Avoid ARM veneer symbols
Message-ID: <20130625150941.GF2327@linaro.org>
References: <2983817.Xe2505Drlj@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2983817.Xe2505Drlj@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 04:01:43PM +0200, Arnd Bergmann wrote:
> When building ARM kernels that exceed a certain size, the linker
> will add "veneers" that allow long branches. Unfortunately,
> using a longer kallsyms section may lead to the extra veneers
> being needed, which leads to inconsistent kallsyms data with the
> message
> 
> Inconsistent kallsyms data
> Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> 
> In some case, not just one but up to three extra passes were
> needed before getting to a state that needed no extra veneers.

Do you understand why this was happening?  It sounds like there
must have been branches crossing from one side of the kallsyms
data to the other, triggering veneer insertion any time the
kallsyms data grows.

Branches between .{init,exit}.text and .text (crossing .rodata) seem the
likeliest culprits, but that's guesswork on my part.


If that's whats going on, multiple kallsyms passes is actually a correct
approach here: I think they should terminate after a number of steps
roughly proportional to log(number of branches across .rodata). We
could come up with a heuristic which allows us to choose the right
limit with a high degree of reliability, since branch density in
compiled C code is likely to be roughly.

But including the veneer symbols in kallsyms is arguably not all
that useful.

The main potential effect is that profiling might occasionally
sample the PC as being in a completely bogus function which it
never passed through at all, because of the way kallsyms tracks
only symbol locations and not sizes (if I remember right) --
so a veneer will actually get accounted against some arbitrary
adjacent function.

I don't know how much this matters.

> The easiest solution is to skip veneers in kallsyms in the
> same way we already skip a couple of other symbols.

The other symbols are not stripped for the purpose of making
kallsyms terminate quickly.  The mapping symbols are rather
different: masses of symbols with duplicate names which are
not very interesting for most people.

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index 487ac6f..53ec0bb 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -69,14 +69,32 @@ static void usage(void)
>  	exit(1);
>  }
>  
> -/*
> - * This ignores the intensely annoying "mapping symbols" found
> - * in ARM ELF files: $a, $t and $d.
> - */
>  static inline int is_arm_mapping_symbol(const char *str)

The function's name is now wrong.  Should it be renamed or split up?

Cheers
---Dave

>  {
> -	return str[0] == '$' && strchr("atd", str[1])
> -	       && (str[2] == '\0' || str[2] == '.');
> +	size_t len;
> +
> +	/*
> +	 * This ignores the intensely annoying "mapping symbols" found
> +	 * in ARM ELF files: $a, $t and $d.
> +	 */
> +	if (str[0] == '$' && strchr("atd", str[1])
> +	       && (str[2] == '\0' || str[2] == '.'))
> +		return 1;
> +
> +	len = strlen(str);
> +	if (len < 10)
> +		return 0;
> +
> +	/*
> +	 * This ignores any __.*_veneer symbol, which get
> +	 * inserted for large kernels, in order to avoid
> +	 * inconsistent data.
> +	 */
> +	if (str[0] == '_' && str[1] == '_' &&
> +	    strcmp(str + len - 7, "_veneer") == 0)
> +		return 1; 
> +
> +	return 0;
>  }
>  
>  static int read_symbol_tr(const char *sym, unsigned long long addr)
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
