Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3JUDua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 23:50:30 -0400
Received: from ozlabs.org ([203.10.76.45]:50513 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab3JUDu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 23:50:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: Pawel Moll <pawel.moll@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] init: fix in-place parameter modification regression
In-Reply-To: <20131018091921.GA7301@shrek.podlesie.net>
References: <1381601100-5622-1-git-send-email-krzysiek@podlesie.net> <1381750442.3247.48.camel@hornet> <20131014125001.GA6015@shrek.podlesie.net> <87wqlbjkz5.fsf@rustcorp.com.au> <20131018091921.GA7301@shrek.podlesie.net>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 21 Oct 2013 12:27:10 +1030
Message-ID: <871u3fmlmx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Mazur <krzysiek@podlesie.net> writes:
> On Fri, Oct 18, 2013 at 02:20:38PM +1030, Rusty Russell wrote:
>> Back when there was almost no parameter parsing support, everyone got
>> used to keeping pointers into the original.  Making everyone kstrdup()
>> seems like gratuitous churn which is likely to make more bugs.
>> 
>> Your fix means __setup() gets treated specially, in that only it can
>> mangle the command line.  That makes sense.  But it introduces another
>> regression: normal parsing functions can't keep pointers, since that's
>> now __initdata.
>> 
>> There are two possible solutions:
>> (1) Audit all __setup to make sure they copy if they want to mangle.
>>     There are about 750 of them, but many are trivial.
>> (2) alloc_bootmem() a third commandline for parsing.
>> 
>> Now, many functions of form __setup("XXX=") should be turned into
>> module_param anyway.
>> 
>> I suggest we do (2) for the moment, and start sweeping through cleaning
>> up __setup() in the longer term.
>> 
>
> Yes, the buffer cannot be __initdata. I'm sending an updated patch.
>
>
> However, keeping pointers to buffer, that will be reinitialized
> in next initcall parameters parsing pass, might cause some race
> conditions.

Thanks, applied.

Cheers,
Rusty.

> Thanks,
> Krzysiek
>
> -- >8 --
> Subject: [PATCH v2] init: fix in-place parameter modification regression
>
> Before commit 026cee0086fe1df4cf74691cf273062cc769617d
> ("params: <level>_initcall-like kernel parameters") the __setup
> parameter parsing code could modify parameter in the
> static_command_line buffer and such modifications were kept. After
> that commit such modifications are destroyed during per-initcall level
> parameter parsing because the same static_command_line buffer is used
> and only parameters for appropriate initcall level are parsed.
>
> That change broke at least parsing "ubd" parameter in the ubd driver
> when the COW file is used.
>
> Now the separate buffer is used for per-initcall parameter parsing.
>
> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
> ---
>  init/main.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/init/main.c b/init/main.c
> index 63d3e8f..c093b5c 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -132,6 +132,8 @@ char __initdata boot_command_line[COMMAND_LINE_SIZE];
>  char *saved_command_line;
>  /* Command line for parameter parsing */
>  static char *static_command_line;
> +/* Command line for per-initcall parameter parsing */
> +static char *initcall_command_line;
>  
>  static char *execute_command;
>  static char *ramdisk_execute_command;
> @@ -348,6 +350,7 @@ static inline void smp_prepare_cpus(unsigned int maxcpus) { }
>  static void __init setup_command_line(char *command_line)
>  {
>  	saved_command_line = alloc_bootmem(strlen (boot_command_line)+1);
> +	initcall_command_line = alloc_bootmem(strlen (boot_command_line)+1);
>  	static_command_line = alloc_bootmem(strlen (command_line)+1);
>  	strcpy (saved_command_line, boot_command_line);
>  	strcpy (static_command_line, command_line);
> @@ -745,9 +748,9 @@ static void __init do_initcall_level(int level)
>  	extern const struct kernel_param __start___param[], __stop___param[];
>  	initcall_t *fn;
>  
> -	strcpy(static_command_line, saved_command_line);
> +	strcpy(initcall_command_line, saved_command_line);
>  	parse_args(initcall_level_names[level],
> -		   static_command_line, __start___param,
> +		   initcall_command_line, __start___param,
>  		   __stop___param - __start___param,
>  		   level, level,
>  		   &repair_env_string);
> -- 
> 1.8.4.1.635.g55556a5
