Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaBYBhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:37:10 -0500
Received: from ozlabs.org ([203.10.76.45]:33685 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbaBYBhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:37:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Ming Lei <tom.leiming@gmail.com>, Andy Honig <ahonig@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [PATCH] kallsyms: fix absolute addresses for kASLR
In-Reply-To: <20140221201031.GA8089@www.outflux.net>
References: <20140221201031.GA8089@www.outflux.net>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 25 Feb 2014 11:59:20 +1030
Message-ID: <87sir856a7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> From: Andy Honig <ahonig@google.com>
>
> Currently symbols that are absolute addresses are incorrectly
> displayed in /proc/kallsyms if the kernel is loaded with kASLR.
>
> The problem was that the scripts/kallsyms.c file which generates
> the array of symbol names and addresses uses an relocatable value
> for all symbols, even absolute symbols.  This patch fixes that.

Hi Andy, Kees,

        This is not a good patch.  See the commit where this was
introduced:

[PATCH] relocatable kernel: Fix kallsyms on avr32 after relocatable kernel changes
    
    o On some platforms like avr32, section init comes before .text and
      not necessarily a symbol's relative position w.r.t _text is positive.
      In such cases assembler detects the overflow and emits warning. This
      patch fixes it.

Did you just break avr32?

And absolute symbols are supposed to be handled in the other branch:

	for (i = 0; i < table_cnt; i++) {
		if (toupper(table[i].sym[0]) != 'A') {
			if (_text <= table[i].addr)
				printf("\tPTR\t_text + %#llx\n",
					table[i].addr - _text);
			else
				printf("\tPTR\t_text - %#llx\n",
					_text - table[i].addr);
		} else {
			printf("\tPTR\t%#llx\n", table[i].addr);
		}
	}

__per_cpu_start is not an absolute symbol anyway.

You need to fix this properly.
Rusty.

> Several kallsyms output in different boot states for comparison:
>
> $ egrep '_(stext|_per_cpu_(start|end))' /root/kallsyms.nokaslr
> 0000000000000000 D __per_cpu_start
> 0000000000014280 D __per_cpu_end
> ffffffff810001c8 T _stext
> $ egrep '_(stext|_per_cpu_(start|end))' /root/kallsyms.kaslr1
> 000000001f200000 D __per_cpu_start
> 000000001f214280 D __per_cpu_end
> ffffffffa02001c8 T _stext
> $ egrep '_(stext|_per_cpu_(start|end))' /root/kallsyms.kaslr2
> 000000000d400000 D __per_cpu_start
> 000000000d414280 D __per_cpu_end
> ffffffff8e4001c8 T _stext
> $ egrep '_(stext|_per_cpu_(start|end))' /root/kallsyms.kaslr-fixed
> 0000000000000000 D __per_cpu_start
> 0000000000014280 D __per_cpu_end
> ffffffffadc001c8 T _stext
>
> Signed-off-by: Andy Honig <ahonig@google.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  scripts/kallsyms.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index 10085de886fe..276e84b8a8e5 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -330,8 +330,7 @@ static void write_src(void)
>  				printf("\tPTR\t_text + %#llx\n",
>  					table[i].addr - _text);
>  			else
> -				printf("\tPTR\t_text - %#llx\n",
> -					_text - table[i].addr);
> +				printf("\tPTR\t%#llx\n", table[i].addr);
>  		} else {
>  			printf("\tPTR\t%#llx\n", table[i].addr);
>  		}
