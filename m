Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbaHGQzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:55:02 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:49655 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaHGQzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:55:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140807160739.GA29726@sepie.suse.cz>
References: <20140726163551.19857.17737.stgit@zurg>
	<53E2156E.9060700@suse.cz>
	<CALYGNiO=oiiLgJRrpycO=CWyMMf8-AiDyW=Ch3ajV5W=9dtZfA@mail.gmail.com>
	<53E24365.6020405@suse.cz>
	<20140807160739.GA29726@sepie.suse.cz>
Date: Thu, 7 Aug 2014 20:54:59 +0400
Message-ID: <CALYGNiOUwnqSYgd=TYOSjcFvz0wW87kXG5DvFtg8M3nomELL0w@mail.gmail.com>
Subject: Re: [PATCH] kbuild: escape single backslashes in macro make-cmd
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 8:07 PM, Michal Marek <mmarek@suse.cz> wrote:
> On Wed, Aug 06, 2014 at 05:01:57PM +0200, Michal Marek wrote:
>> On 2014-08-06 14:19, Konstantin Khlebnikov wrote:
>> > On Wed, Aug 6, 2014 at 3:45 PM, Michal Marek <mmarek@suse.cz> wrote:
>> >> On 2014-07-26 18:35, Konstantin Khlebnikov wrote:
>> >>> This already has been fixed in commit c353acba28fb3fa1fd05fd
>> >>> ("kbuild: make: fix if_changed when command contains backslashes")
>> >>> but escaping still isn't perfect and triggers false-positive rebuilds.
>> >>>
>> >>> For x86 problem happens every time, because rules in arch/x86/realmode/rm/
>> >>> and arch/x86/boot/ contains commands like sed -n -e 's/foo\(.*\)/\1/p'.
>> >>> Backslash in \1 isn't escaped and turns into ascii symbol with code 1.
>> >>> Macro if_changed detects command change and rebuilds target again and again.
>> >>>
>> >>> Backslash escaping conflicts with other passes because it's used for escaping
>> >>> other symbols. To avoid that current macro handles only double backslashes.
>> >>> Obviously this doesn't work for \1 like above.
>> >>>
>> >>> This patch reorders passes. It doubles all backslashes before escaping # and '
>> >>>
>> >>> Visible effect in rebuilding x86/defconfig without changes, before patch:
>> >>>
>> >>> blind@zurg:~/src/linux$ make V=2
>> >>>   CHK     include/config/kernel.release
>> >>>   CHK     include/generated/uapi/linux/version.h
>> >>>   CHK     include/generated/utsrelease.h
>> >>>   CALL    scripts/checksyscalls.sh - due to target missing
>> >>>   CHK     include/generated/compile.h
>> >>>   PASYMS  arch/x86/realmode/rm/pasyms.h - due to command line change
>> >>
>> >> With which make and shell version are you seeing this? While the patch
>> >> looks correct, I can't reproduce the error here:
>> >
>> > /bin/sh points to dash (debian default setup).
>> >
>> > I cannot reproduce this using bash. That explains why this bug is still here.
>>
>> So the difference between the shells is that their 'echo' builtin treats
>> \<number> differently:
>> $ ./dash -c "echo '\2'"
>>
>> $ ./dash -c "echo '\2'" | xxd
>> 0000000: 020a                                     ..
>> $ /bin/bash -c "echo '\2'"
>> \2
>
> The problem is that the bash echo does not interpred _any_ \-sequences
> without -e. So the nicely escaped \\ stays a \\ and we get spurious
> rebuilds with bash instead. It previously worked with bash, because the
> backslash escaping was completely broken. You not only moved it up in
> the chain, but also fixed it by removing one superflous level of
> escaping.
>
> I'm now testing this, i.e. dropping the backslash escaping completely
> and doing a printf '%s\n' instead. Can you try if it works for you?

Yes, it works. I completely forgot about printf, it's much more
reliable than echo.

So, you can add my Acked-by/Tested-by

>
>
> diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
> index 122f95c..8a9a4e1 100644
> --- a/scripts/Kbuild.include
> +++ b/scripts/Kbuild.include
> @@ -215,11 +215,13 @@ else
>  arg-check = $(if $(strip $(cmd_$@)),,1)
>  endif
>
> -# >'< substitution is for echo to work,
> -# >$< substitution to preserve $ when reloading .cmd file
> -# note: when using inline perl scripts [perl -e '...$$t=1;...']
> -# in $(cmd_xxx) double $$ your perl vars
> -make-cmd = $(subst \\,\\\\,$(subst \#,\\\#,$(subst $$,$$$$,$(call escsq,$(cmd_$(1))))))
> +# Replace >$< with >$$< to preserve $ when reloading the .cmd file
> +# (needed for make)
> +# Replace >#< with >\#< to avoid starting a comment in the .cmd file
> +# (needed for make)
> +# Replace >'< with >'\''< to be able to enclose the whole string in '...'
> +# (needed for the shell)
> +make-cmd = $(call escsq,$(subst \#,\\\#,$(subst $$,$$$$,$(cmd_$(1)))))
>
>  # Find any prerequisites that is newer than target or that does not exist.
>  # PHONY targets skipped in both cases.
> @@ -230,7 +232,7 @@ any-prereq = $(filter-out $(PHONY),$?) $(filter-out $(PHONY) $(wildcard $^),$^)
>  if_changed = $(if $(strip $(any-prereq) $(arg-check)),                       \
>         @set -e;                                                             \
>         $(echo-cmd) $(cmd_$(1));                                             \
> -       echo 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)
> +       printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)
>
>  # Execute the command and also postprocess generated .d dependencies file.
>  if_changed_dep = $(if $(strip $(any-prereq) $(arg-check) ),                  \
