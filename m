Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab3GQWal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:30:41 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42732 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab3GQWaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:30:39 -0400
Date: Thu, 18 Jul 2013 00:30:33 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org,
        linux-arm-kernel@lists.infradead.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
Message-ID: <20130717223033.GF3385@free.fr>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
 <20130716004727.b60b2c96.akpm@linux-foundation.org>
 <20130716005611.e4ccab02.akpm@linux-foundation.org>
 <201307161008.07643.yann.morin.1998@free.fr>
 <20130716180408.GA19863@merkur.ravnborg.org>
 <20130717211649.GA5619@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130717211649.GA5619@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam, All,

Well, while I was fighting on this on my side... ;-)

On 2013-07-17 23:16 +0200, Sam Ravnborg spake thusly:
> > We could extend the symbol option part to retreive values from a binary.
> > Something like this:
> > 
> > config FOOBAR
> >         bool
> >         option exec="true"
> > 
> > FOOBAR would assume the value "y" if the command true has exit code == 0, otherwise "n".
> > And similar conversions for other types.
> > 
> > This only extendt Kconfig slightly - using an already present method to import
> > external values.
> > 
> > The drawback I see with this approach is that we may execute a lot of small programs
> > where the value is never used.
> 
> Following is a quick patch implmenting this idea.
> You need to run gperf manually to enable this.
> 
> "gperf -C scripts/kconfig/zconf.gperf > scripts/kconfig/zconf.hash.c"
> 
> I did not figure out how to use the built-in rules to generate this file :-(

make REGENERATE_PARSERS=y menuconfig

> I have tested this lightly - as we should discuss if this is a viable way forward.

Instead of extending the Kconfig language, I was thinking (as initially
suggested by Andrew) of generating a Kconfig file before all config
targets, and source that Kconfig file from $(TOPDIR)/Kconfig.

I'm not a fan od extending the Kconfig language in this way. It feels
weird to me. Especially when we have a way to solve this specific issue
with a script that generates the needed Kconfig symbols before any
config target is called.

At the very least we'd have to decide if this is available only for
booleans/tristates, or for any type? Your implementation seems to make
it valid for strings/ints, too.

> For now I used popen() - so return value of the executed program are ignored.

Yet, pclose returns the exit status of the command.

If option exec was to be valid only for booleans, we could use the exit
value rather than the output, which would seem more logical. It would be
however a bit moretriclky for tristates, though...

Maybe using output is the best, after all...

So, how do you expect we use that to check for an external tool?
Something like this?
    config HAVE_LZ4
        bool
        option exec="which lz4c >/dev/null 2>&1 && echo y"

    config KERNEL_LZ4
        bool "compress the kernel with lz4"
        depends on HAVE_LZ4

Ot did I miss something?

> diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
> index d550300..b7179a6 100644
> --- a/scripts/kconfig/symbol.c
> +++ b/scripts/kconfig/symbol.c
[--SNIP--]
> @@ -1379,3 +1381,56 @@ static void prop_add_env(const char *env)
>  	else
>  		menu_warn(current_entry, "environment variable %s undefined", env);
>  }
> +
> +static void exec_command(const char *command, struct symbol *sym)
> +{
> +	char buffer[2048];
> +	FILE *stream;
> +
> +	stream = popen(command, "r");
> +
> +	if (stream != NULL) {
> +		if (fgets(buffer, sizeof(buffer), stream) != NULL) {
> +			int i;
> +
> +			buffer[sizeof(buffer) - 1] = '\0';
> +
> +			/* Drop any trialing newlines */
> +			i = strlen(buffer);
> +			while (i > 0 && buffer[i - 1] == '\n') {
> +				buffer[i - 1] = '\0';
> +				i--;
> +			}
> +			/* Validate the output of the command */
> +			if (strlen(buffer) == 0) {
> +				menu_warn(current_entry,
> +				          "command '%s' - invalid (empty?) return value: \"%s\"",
> +				          command, buffer);
> +				return;

Missing pclose() before return.

[--SNIP--]

I'll give it a spin here. Thank you!

BTW, I still need your help on solving that one:
    randconfig does randomise choice entries, unless KCONFIG_ALLCONFIG
    is specified.
    http://marc.info/?l=linux-kernel&m=137209757414433&w=2

My two previous attempts failed due to introducing regressions, so they
were both reverted... :-(
Any suggestion? ;-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
