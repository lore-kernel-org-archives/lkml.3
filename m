Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084AbaFVW4I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 18:56:08 -0400
Received: from smtprelay0226.hostedemail.com ([216.40.44.226]:39081 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750781AbaFVW4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 18:56:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:966:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2525:2561:2564:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4385:4470:5007:6119:6120:7652:7875:7903:8660:8985:9025:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740
X-HE-Tag: feet13_6f1149b803c43
X-Filterd-Recvd-Size: 4569
Message-ID: <1403477762.18747.14.camel@joe-AO725>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Joe Perches <joe@perches.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Date: Sun, 22 Jun 2014 15:56:02 -0700
In-Reply-To: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 00:46 +0200, Mathias Krause wrote:
> This RFC series tries to address the problem of dangling strings of
> __init functions after initialization, as well as __exit strings for
> code not even included in the final kernel image. The code might get
> freed, but the format strings are not.
> 
> One solution to the problem might be to declare variables in the code
> and mark those variables as __initconst. That, though, makes the code
> ugly, as can be seen, e.g., in drivers/hwmon/w83627ehf.c -- a pile of
> 'static const char[] __initconst' lines just for the pr_info() call.
> 
> To be able to mark strings easily patch 1 adds macros to init.h to do so
> without the need to explicitly define variables in the code. Internally
> it'll declare ones nonetheless, as this seem to be the only way to
> attach an __attribute__() to a verbatim string. That's already enough to
> solve the problem -- mark the corresponding stings by using these
> macros. But patch 2 adds some syntactical sugar for the most popular use
> case, by providing pr_<level> alike macros, namely pi_<level> for __init
> code and pe_<level> for __exit code. This hides the use of the marker
> macros behind the commonly known printing functions -- with just a
> single character changed.
> 
> Patch 3 exemplarily changes all strings and format strings in
> arch/x86/kernel/acpi/boot.c to use the new macros. It also addresses a
> few styling issues, though. But this already leads to ~1.7 kB of r/o
> data moved to the .init.rodata section, marking it for release after
> init.
> 
> 
> Open issues with this approach:
> 
> 1/ When CONFIG_DYNAMIC_DEBUG is enabled, pi_debug() and pe_debug()
> fall-back to pr_debug() as there is currently no way of removing the
> dynamic entries from the dynamic debug code after init.
> 
> 2/ The variables used in the macros of patch 1 will pollute the symtab
> with unneeded entries. That'll be a problem in the KALLSYMS_ALL case
> only, though. But the symtab will be huge then, anyway. However,
> filtering those even in this case might be desirable.
> 
> 3/ It only seamlessly integrates for the pr_<level>() kind of use cases.
> For other literal strings it gets slightly less readable, e.g. this:
> 
>    strncmp(str, "s4_nohwsig", 10)
> 
> becomes this:
> 
>    strncmp(str, __init_str("s4_nohwsig"), 10)
> 
> That might be okay, though, as it marks the string clearly as an init
> string, so might actually increase the understanding of the life time of
> the string literal.
> 
> 
> So, is there interest in having such macros and markings? Patch 3 shows,
> that there's actual value in it. A hacked up script, dully changing
> pr_<level> to pi_<level> for __init functions under arch/x86/ already is
> able to move ~8kB of r/o data into the .init section. The script,
> though, is dump. It does not handle any of the printk() calls, nor does
> it handle panic() calls or other strings used only in initialization
> code. So there's more to squeeze out. I just want to get some feedback
> first.
> 
> Also documentation of the new macros is missing, maybe even a
> checkpatch.pl change to propose using the new macros instead of pr_*()
> or plain printk() in __init / __exit functions.
> 
> What do you think?

I once proposed a similar thing.

https://lkml.org/lkml/2009/7/21/421

Matt Mackall replied

https://lkml.org/lkml/2009/7/21/463


