Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066AbaEGOVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:21:54 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:53731 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812AbaEGOVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:21:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140506174445.b64dffb78d0676b48fa68eea@skynet.be>
References: <CALZtONB-wT16fPX7GjBVFO_5Bof3=zxviG22p6_9ymbnzA9QAA@mail.gmail.com>
 <1399300985-11137-1-git-send-email-ddstreet@ieee.org> <20140505133517.71b7dc7cf327cb304e8a9edc@linux-foundation.org>
 <CALZtONAVTQuOF3ddZ6jVZqCGgKBicAtT=_w5w4GEueYAsf3jtw@mail.gmail.com> <20140506174445.b64dffb78d0676b48fa68eea@skynet.be>
From: Dan Streetman <ddstreet@ieee.org>
Date: Wed, 7 May 2014 10:21:28 -0400
X-Google-Sender-Auth: JNDb9Ujx1QhzoESeHmJENCoAfSQ
Message-ID: <CALZtONBADrb_yCPqCAUfw1ei9sYxw_-MopPko3dcfas2mqsVZg@mail.gmail.com>
Subject: Re: [PATCH] plist: replace pr_debug with printk in plist_test()
To: Fabian Frederick <fabf@skynet.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 11:44 AM, Fabian Frederick <fabf@skynet.be> wrote:
> On Tue, 6 May 2014 08:30:56 -0400
> Dan Streetman <ddstreet@ieee.org> wrote:
>
>> On Mon, May 5, 2014 at 4:35 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > On Mon,  5 May 2014 10:43:05 -0400 Dan Streetman <ddstreet@ieee.org> wrote:
>> >
>> >> Replace pr_debug() in lib/plist.c test function plist_test() with
>> >> printk(KERN_DEBUG ...).
>> >>
>> >> Without DEBUG defined, pr_debug() is complied out, but the entire
>> >> plist_test() function is already inside CONFIG_DEBUG_PI_LIST, so
>> >> printk should just be used directly.
>> >>
>> >> --- a/lib/plist.c
>> >> +++ b/lib/plist.c
>> >> @@ -175,7 +175,7 @@ static int  __init plist_test(void)
>> >>       int nr_expect = 0, i, loop;
>> >>       unsigned int r = local_clock();
>> >>
>> >> -     pr_debug("start plist test\n");
>> >> +     printk(KERN_DEBUG "start plist test\n");
>> >
>> > Now someone will come along and helpfully switch it back to pr_debug()
>> > again :(
>> >
>> > What about adding a #define DEBUG?
>> >
>> >
>> >
>> > This aspect of pr_debug() is rather surprising and unfortunate and I
>> > guess we screwed it up.  pr_debug() should unconditionally do the
>> > printk, just like pr_warn, pr_emerg, etc.  And there should be a
>> > separate pr_debug_cond() which honours the DEBUG setting.
>>
>> I agree, it's definitely surprising and not obvious.  At the least,
>> maybe some clearer comments/docs would help; besides actually
>> reviewing the printk.h code, the only other indication of this
>> behavior is CodingStyle which currently says:
>>
>> "For messages that aren't associated with a particular device,
>> <linux/printk.h> defines pr_debug() and pr_info()."
>>
>> Listing pr_debug() and pr_info() on the same line with no
>> qualifications kind of implies they behave the same.  Maybe the
>> example should be pr_err() and pr_info(), or really anything besides
>> pr_debug(), which is discussed in (very brief) detail in the next
>> paragraph...
>>
>> "Such messages should be compiled out when the DEBUG symbol is not
>> defined (that is, by default they are not included).  When you use
>> dev_dbg() or pr_debug(), that's automatic.  Many subsystems have
>> Kconfig options to turn on -DDEBUG."
>>
>> While that does explain that pr_debug() won't actually print anything
>> without DEBUG defined, it's hardly in a way that jumps out, clearly
>> indicating that pr_debug() is unlike all the other pr_XXX() functions.
>>
>> I'll try sending a patch to update the docs to make pr_debug()'s
>> behavior clearer...
>
> Admitting checkpatch is the authority in that matter and that per subsystem
> debug granularity would be kept, we could at least add some specification
> like below ?

It would be even better if the note could clarify that sometimes it is
ok to use printk(KERN_DEBUG


>
> [PATCH 1/1] scripts/checkpatch.pl: add printk(KERN_DEBUG to pr_debug specification
>
> Such conversions can't be done as trivially as other printk occurences.
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  scripts/checkpatch.pl | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 34eb216..4e462d7 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2863,9 +2863,14 @@ sub process {
>                         my $level = lc($orig);
>                         $level = "warn" if ($level eq "warning");
>                         my $level2 = $level;
> -                       $level2 = "dbg" if ($level eq "debug");
> +                       my $note = "";
> +                       if ($level eq "debug"){
> +                               $level2 = "dbg";
> +                               $note = "Note that printk(KERN_DEBUG conversions to pr_debug require local DEBUG definition.\n";
> +                       }
>                         WARN("PREFER_PR_LEVEL",
> -                            "Prefer [subsystem eg: netdev]_$level2([subsystem]dev, ... then dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n" . $herecurr);
> +                            "Prefer [subsystem eg: netdev]_$level2([subsystem]dev, ... then dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n$note" . $herecurr);
> +
>                 }
>
>                 if ($line =~ /\bpr_warning\s*\(/) {
> --
> 1.8.4.5
>
