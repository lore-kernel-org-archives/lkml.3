Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3J1Fu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:50:57 -0400
Received: from ozlabs.org ([203.10.76.45]:42235 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3J1Fu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:50:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chen Gang <gang.chen@asianux.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Michal Marek <mmarek@suse.cz>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [RFC PATCH] kernel/kallsyms.c: only show legal kernel symbol
In-Reply-To: <20131028132348.62f7e368@tom-ThinkPad-T410>
References: <1382498320-26594-1-git-send-email-tom.leiming@gmail.com> <87eh7bfoq9.fsf@rustcorp.com.au> <20131024084559.GD16735@n2100.arm.linux.org.uk> <87mwlyclng.fsf@rustcorp.com.au> <CACVXFVO86u0h0V-1_DCkO5HNyUp2i_UsjPrVWDb-ZBtmwVk28A@mail.gmail.com> <87y55h7vcd.fsf@rustcorp.com.au> <CACVXFVPXEUX9JQ2NZvL8=J34zbw2fn202QW2SQtpKjdQ+tv=vg@mail.gmail.com> <87sivp7eai.fsf@rustcorp.com.au> <CACVXFVN7PiU1dorkeamtC9-Wg_TVQE8xFiJtad-C8q4_=Rc1Ow@mail.gmail.com> <874n82gk89.fsf@rustcorp.com.au> <20131028132348.62f7e368@tom-ThinkPad-T410>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 28 Oct 2013 16:20:19 +1030
Message-ID: <87ob6aeyg4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <tom.leiming@gmail.com> writes:
> On Mon, 28 Oct 2013 13:44:30 +1030
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> Ming Lei <tom.leiming@gmail.com> writes:
>> 
>> I don't know...  It would be your job, as the person making the change,
>> to find all the users of kallsyms and prove that.
>> 
>> This is why it is easier not to include incorrect values in the kernel's
>> kallsyms in the first place.
>
> OK, thanks for your comment, and I figured out one way to do it in
> scripts/kallsyms.c, could you comment on below patch?

Looks great! Seems like we spent more time arguing than it took you to
code that up.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Russell, this seems logical for you to take along with the changes which
caused the problem?

Thanks,
Rusty.

> --
> From 4327534dedfa60d208ac3e23db7556c243e1c7dc Mon Sep 17 00:00:00 2001
> From: Ming Lei <tom.leiming@gmail.com>
> Date: Mon, 28 Oct 2013 13:04:49 +0800
> Subject: [PATCH] scripts/kallsyms: filter symbols not in kernel address space
>
> This patch uses CONFIG_PAGE_OFFSET to filter symbols which
> are not in kernel address space because these symbols are
> generally for generating code purpose and can't be run at
> kernel mode, so we needn't keep them in /proc/kallsyms.
>
> For example, on ARM there are some symbols which may be
> linked in relocatable code section, then perf can't parse
> symbols any more from /proc/kallsyms, this patch fixes the
> problem.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  scripts/kallsyms.c      |   12 +++++++++++-
>  scripts/link-vmlinux.sh |    2 ++
>  2 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index 487ac6f..9a11f9f 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -55,6 +55,7 @@ static struct sym_entry *table;
>  static unsigned int table_size, table_cnt;
>  static int all_symbols = 0;
>  static char symbol_prefix_char = '\0';
> +static unsigned long long kernel_start_addr = 0;
>  
>  int token_profit[0x10000];
>  
> @@ -65,7 +66,10 @@ unsigned char best_table_len[256];
>  
>  static void usage(void)
>  {
> -	fprintf(stderr, "Usage: kallsyms [--all-symbols] [--symbol-prefix=<prefix char>] < in.map > out.S\n");
> +	fprintf(stderr, "Usage: kallsyms [--all-symbols] "
> +			"[--symbol-prefix=<prefix char>] "
> +			"[--page-offset=<CONFIG_PAGE_OFFSET>] "
> +			"< in.map > out.S\n");
>  	exit(1);
>  }
>  
> @@ -194,6 +198,9 @@ static int symbol_valid(struct sym_entry *s)
>  	int i;
>  	int offset = 1;
>  
> +	if (s->addr < kernel_start_addr)
> +		return 0;
> +
>  	/* skip prefix char */
>  	if (symbol_prefix_char && *(s->sym + 1) == symbol_prefix_char)
>  		offset++;
> @@ -646,6 +653,9 @@ int main(int argc, char **argv)
>  				if ((*p == '"' && *(p+2) == '"') || (*p == '\'' && *(p+2) == '\''))
>  					p++;
>  				symbol_prefix_char = *p;
> +			} else if (strncmp(argv[i], "--page-offset=", 14) == 0) {
> +				const char *p = &argv[i][14];
> +				kernel_start_addr = strtoull(p, NULL, 16);
>  			} else
>  				usage();
>  		}
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index 0149949..32b10f5 100644
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -82,6 +82,8 @@ kallsyms()
>  		kallsymopt="${kallsymopt} --all-symbols"
>  	fi
>  
> +	kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
> +
>  	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
>  		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
>  
> -- 
> 1.7.9.5
>
>
>
>
> Thanks,
> -- 
> Ming Lei
