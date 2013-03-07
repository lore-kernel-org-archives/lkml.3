Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354Ab3CGTwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 14:52:05 -0500
Received: from mail1.windriver.com ([147.11.146.13]:58801 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab3CGTwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 14:52:03 -0500
Message-ID: <5138EF7F.1050003@windriver.com>
Date: Thu, 7 Mar 2013 14:50:23 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v2] early_printk: consolidate random copies of identical
 code
References: <1362683754-706-1-git-send-email-paul.gortmaker@windriver.com> <20130307112536.82288f41924a38a441cdf345@linux-foundation.org>
In-Reply-To: <20130307112536.82288f41924a38a441cdf345@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-03-07 02:25 PM, Andrew Morton wrote:
> On Thu, 7 Mar 2013 14:15:54 -0500 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> 
>> [v2: essentially unchanged since v1, so I've left the acked/reviewed
>>  tags.  There was a compile fail[1] for a randconfig with EARLY_PRINTK=y
>>  and PRINTK=n, because the early_console struct and early_printk calls
>>  were nested within an #ifdef CONFIG_PRINTK -- moving that whole block
>>  exactly as-is to be outside the #ifdef CONFIG_PRINTK fixes the randconfig
>>  and still works for everyday sane configs too.]
>>  [1] http://marc.info/?l=linux-next&m=136219350914998&w=2   
> 
> You did this:
> 
> --- a/kernel/printk.c~early_printk-consolidate-random-copies-of-identical-code-v2
> +++ a/kernel/printk.c
> @@ -759,29 +759,6 @@ module_param(ignore_loglevel, bool, S_IR
>  MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
>  	"print all kernel messages to the console.");
>  
> -#ifdef CONFIG_EARLY_PRINTK
> -struct console *early_console;
> -
> -void early_vprintk(const char *fmt, va_list ap)
> -{
> -	if (early_console) {
> -		char buf[512];
> -		int n = vscnprintf(buf, sizeof(buf), fmt, ap);
> -
> -		early_console->write(early_console, buf, n);
> -	}
> -}
> -
> -asmlinkage void early_printk(const char *fmt, ...)
> -{
> -	va_list ap;
> -
> -	va_start(ap, fmt);
> -	early_vprintk(fmt, ap);
> -	va_end(ap);
> -}
> -#endif
> -
>  #ifdef CONFIG_BOOT_PRINTK_DELAY
>  
>  static int boot_delay; /* msecs delay after each printk during bootup */
> @@ -1743,6 +1720,29 @@ static size_t cont_print_text(char *text
>  
>  #endif /* CONFIG_PRINTK */
>  
> +#ifdef CONFIG_EARLY_PRINTK
> +struct console *early_console;
> +
> +void early_vprintk(const char *fmt, va_list ap)
> +{
> +	if (early_console) {
> +		char buf[512];
> +		int n = vscnprintf(buf, sizeof(buf), fmt, ap);
> +
> +		early_console->write(early_console, buf, n);
> +	}
> +}
> +
> +asmlinkage void early_printk(const char *fmt, ...)
> +{
> +	va_list ap;
> +
> +	va_start(ap, fmt);
> +	early_vprintk(fmt, ap);
> +	va_end(ap);
> +}
> +#endif
> +
>  static int __add_preferred_console(char *name, int idx, char *options,
>  				   char *brl_options)
>  {
> _
> 
> Problem is, that won't fix the various compilation problems we've had. 
> See yesterday's lkml thread "linux-next: build failure after merge of
> the final tree (akpm tree related)"

Thanks for the pointer -- I'd only found Randy's original report
and had not seen this yet.  I'll go build test on sparc and have
a look there.

This brings up a recurring question.  I was tempted to just go make
CONFIG_EARLY_PRINTK depend on CONFIG_PRINTK, but lately I've faced
pushback when trying to "fix" things like seeing ARM OMAP USB options
for an x86 build[1], and GOLDFISH virt drivers being offered even
when the end user already said no to GOLDFISH[2].

Do we want to use dependencies to reflect the real world layout of
platforms/systems, or do we want to go the minimal dependency
approach, where we are building sparc specific drivers on mips just
because we can?

I think the former is better from a user specific point of view, as
the maze of Kconfig is better as a tree topology with branches that
have clear dependencies that exclude them, versus it being a flat
monolithic space where anything can select anything.

Arguments I've heard for the latter seem to be developer centric
(i.e forcing wider build coverage on the population as a whole, etc)

Thanks,
Paul.

[1] https://lkml.org/lkml/2013/2/27/204
[2] http://marc.info/?l=linux-kernel&m=136198970523568&w=3


> 
