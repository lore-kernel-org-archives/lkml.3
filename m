Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3JNLeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:34:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43182 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab3JNLeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:34:04 -0400
Message-ID: <1381750442.3247.48.camel@hornet>
Subject: Re: [PATCH] init: fix in-place parameter modification regression
From: Pawel Moll <pawel.moll@arm.com>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 14 Oct 2013 12:34:02 +0100
In-Reply-To: <1381601100-5622-1-git-send-email-krzysiek@podlesie.net>
References: <1381601100-5622-1-git-send-email-krzysiek@podlesie.net>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 14 Oct 2013 11:34:02.0362 (UTC) FILETIME=[4818ADA0:01CEC8D1]
X-MC-Unique: 113101412340300201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-12 at 19:05 +0100, Krzysztof Mazur wrote:
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
> Now the separate buffer is used for per-initcall parameter parsing,
> like in parsing early params.
> 
> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
> ---
>
>  init/main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index 63d3e8f..e5b322a 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -742,12 +742,13 @@ static char *initcall_level_names[] __initdata = {
>  
>  static void __init do_initcall_level(int level)
>  {
> +	static __initdata char tmp_cmdline[COMMAND_LINE_SIZE];
>  	extern const struct kernel_param __start___param[], __stop___param[];
>  	initcall_t *fn;
>  
> -	strcpy(static_command_line, saved_command_line);
> +	strcpy(tmp_cmdline, saved_command_line);
>  	parse_args(initcall_level_names[level],
> -		   static_command_line, __start___param,
> +		   tmp_cmdline, __start___param,
>  		   __stop___param - __start___param,
>  		   level, level,
>  		   &repair_env_string);

Hold on. static_command_line can be only accessed within init/main.c. As
far as I can say, it is only used by unknown_bootoption() (so your
__setup callbacks) and then in the do_initcall_level().

So, assuming that it is actually legal to modify static_command_line in
__setup()-s (and I must say I have rather mixed feelings about it ;-),
the only place that will be able to make use of this changes will be
do_initcall_level().

But your change actually uses *saved*_command_line instead of
*static*_command_line as the base for parse_args.

Generally I agree that the commit in question changed the semantics in a
subtle way - it makes the do_initcalls() use saved_command_line as a
string to be parsed instead of static_command_line. I was convinced that
at this stage of execution they must be identical (and the
static_command_line is a de-facto scratch buffer). You're saying that is
may not be the case, which can be true, but you're keeping the same
behaviour :-)

So either you have some extra changes in your kernel actually using
static_command_line for some other reason, or your change makes no
difference. The third option is me being brain dead today, which is not
impossible ;-)

Paweł


