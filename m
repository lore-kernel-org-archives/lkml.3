Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab3JNMuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:50:10 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:34139 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab3JNMuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:50:05 -0400
Date: Mon, 14 Oct 2013 14:50:01 +0200
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] init: fix in-place parameter modification regression
Message-ID: <20131014125001.GA6015@shrek.podlesie.net>
References: <1381601100-5622-1-git-send-email-krzysiek@podlesie.net>
 <1381750442.3247.48.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381750442.3247.48.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 12:34:02PM +0100, Pawel Moll wrote:
> On Sat, 2013-10-12 at 19:05 +0100, Krzysztof Mazur wrote:
> > Before commit 026cee0086fe1df4cf74691cf273062cc769617d
> > ("params: <level>_initcall-like kernel parameters") the __setup
> > parameter parsing code could modify parameter in the
> > static_command_line buffer and such modifications were kept. After
> > that commit such modifications are destroyed during per-initcall level
> > parameter parsing because the same static_command_line buffer is used
> > and only parameters for appropriate initcall level are parsed.
> > 
> > That change broke at least parsing "ubd" parameter in the ubd driver
> > when the COW file is used.
> > 
> > Now the separate buffer is used for per-initcall parameter parsing,
> > like in parsing early params.
> > 
> > Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
> > ---
> >
> >  init/main.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/init/main.c b/init/main.c
> > index 63d3e8f..e5b322a 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -742,12 +742,13 @@ static char *initcall_level_names[] __initdata = {
> >  
> >  static void __init do_initcall_level(int level)
> >  {
> > +	static __initdata char tmp_cmdline[COMMAND_LINE_SIZE];
> >  	extern const struct kernel_param __start___param[], __stop___param[];
> >  	initcall_t *fn;
> >  
> > -	strcpy(static_command_line, saved_command_line);
> > +	strcpy(tmp_cmdline, saved_command_line);
> >  	parse_args(initcall_level_names[level],
> > -		   static_command_line, __start___param,
> > +		   tmp_cmdline, __start___param,
> >  		   __stop___param - __start___param,
> >  		   level, level,
> >  		   &repair_env_string);
> 
> Hold on. static_command_line can be only accessed within init/main.c. As
> far as I can say, it is only used by unknown_bootoption() (so your
> __setup callbacks) and then in the do_initcall_level().

But I think it's legal to keep the pointer to the option argument
(which points to static_command_line) in __setup callback and use it later,
and assume that the argument value will never change.

However, with my patch it's no longer true for per-initcall arguments
because they share the same command line buffer, so the tmp_cmdline
have the __initdata attribute. The same restriction applies to
the "early params".

> 
> So, assuming that it is actually legal to modify static_command_line in
> __setup()-s (and I must say I have rather mixed feelings about it ;-),

I also have mixed feelings about that, but the parse_args() already
does that, because some characters are replaced with '\0' to split
command line into separate strings. The ubd driver does the same
to split parameter into two strings.

So after parsing, the command line:

	"ubd0=cow_file,file hostfs=/path"

is changed to:

	"ubd0\0cow_file\0file\0hostfs\0path"


However after do_initcalls(), because __setup("ubd", ...) callback is not
called, it's changed to:

	"ubd0\0cow_file,file\0hostfs\0path"

and the ubd driver tries to use "cow_file,file" as COW file because
it just saves pointer.


With my patch because do_initcall_level() uses different scratch buffer
this difference is not visible to the ubd driver.
 
> the only place that will be able to make use of this changes will be
> do_initcall_level().
> 
> But your change actually uses *saved*_command_line instead of
> *static*_command_line as the base for parse_args.

Yes, because static_command_line is already destroyed by parsing
(NUL terminators are added).

> 
> Generally I agree that the commit in question changed the semantics in a
> subtle way - it makes the do_initcalls() use saved_command_line as a
> string to be parsed instead of static_command_line. I was convinced that
> at this stage of execution they must be identical (and the

No, at that stage the static_command_line is already parsed by
parse_args("Booting kernel", ...).

> static_command_line is a de-facto scratch buffer). You're saying that is
> may not be the case, which can be true, but you're keeping the same
> behaviour :-)
> 
> So either you have some extra changes in your kernel actually using
> static_command_line for some other reason, or your change makes no
> difference. The third option is me being brain dead today, which is not
> impossible ;-)
> 

I've been using vanilla v3.12-rc4-92-gb68ba36. Now I'm using v3.12-rc5.

Thanks,
Krzysiek
