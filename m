Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaBCWFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:05:09 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:51892 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaBCWFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:05:07 -0500
MIME-Version: 1.0
In-Reply-To: <1391464885.1080.18.camel@wall-e.seibold.net>
References: <1391340435-5130-1-git-send-email-stefani@seibold.net>
 <1391340435-5130-8-git-send-email-stefani@seibold.net> <CALCETrXNVoJBUncHbWWuQ7LAf2ZoWOY8uJBeg_VD1+MmwJ07Rg@mail.gmail.com>
 <1391377190.9266.6.camel@wall-e.seibold.net> <CALCETrX2K6DeGO7v+8Qed03xbKd0dcsoWVPg6fp6+KNGHnC+eA@mail.gmail.com>
 <1391413467.965.21.camel@wall-e.seibold.net> <CALCETrWvPkJo=3o3EZ+ZnFJgKak-7GjcJbsinn6z7wsB3393hg@mail.gmail.com>
 <1391464885.1080.18.camel@wall-e.seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Feb 2014 14:04:45 -0800
Message-ID: <CALCETrXPraCrvUR=L1iw+=dnxDHwf3AM0QMNPtSEf40G+80pPg@mail.gmail.com>
Subject: Re: [PATCH 7/8] Add 32 bit VDSO time support for 32 bit kernel
To: Stefani Seibold <stefani@seibold.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 2:01 PM, Stefani Seibold <stefani@seibold.net> wrote:
> Am Montag, den 03.02.2014, 08:36 -0800 schrieb Andy Lutomirski:
>> On Sun, Feb 2, 2014 at 11:44 PM, Stefani Seibold <stefani@seibold.net> wrote:
>> > Am Sonntag, den 02.02.2014, 16:12 -0800 schrieb Andy Lutomirski:
>> >> On Sun, Feb 2, 2014 at 1:39 PM, Stefani Seibold <stefani@seibold.net> wrote:
>> >> > Am Sonntag, den 02.02.2014, 08:46 -0800 schrieb Andy Lutomirski:
>> >> >> On Sun, Feb 2, 2014 at 3:27 AM,  <stefani@seibold.net> wrote:
>> >> >> > From: Stefani Seibold <stefani@seibold.net>
>> >> >> >
>> >> >> > This patch add the time support for 32 bit a VDSO to a 32 bit kernel.
>> >> >>
>> >> >> [...]
>> >> >>
>> >> >> Can you address the review comments from last time around?  For
>> >> >> example, this still seems to have redundant vvar and hpet mappings, it
>> >> >> doesn't use the VVAR macro, it moves the 32-bit compat vDSO, etc.
>> >> >>
>> >> >
>> >> > I will address the compat VDSO issue.
>> >> >
>> >> > But the VVAR macro will be not a part of this patch set. If you depend
>> >> > on this, feel free to create one. From my point of view this is not
>> >> > feasible without a macro hacking, because the address accessing the vvar
>> >> > area differs in kernel and VDSO user mode.
>> >>
>> >> Sorry, but "I will make the code messier for no apparent reason and I
>> >> will not offer to fix it in the same series" gets my NAK.
>> >>
>> >> Hint: I'm talking about two or three lines of code in vvar.h.
>> >>
>> >
>> > A hint back: if you threat me with a NAK for a requested code sequence
>> > which currently no user, this is far away from professional. I am not
>> > your trainee.
>> >
>> > BTW: If it is so easy, send me the two or three lines and i will merge
>> > it ;-)
>>
>> Something to the effect of:
>>
>> #elif defined(BUILD_VDSO32)
>> #define VVAR(name) (*vvar_ ## name)
>> #endif
>>
>> Should do the trick.
>
> You are wrong...
>
> #ifdef BUILD_VDSO32
>
> #define DECLARE_VVAR(offset, type, name) \
>         extern type vvar_ ## name __attribute__((visibility("hidden")));
>
> #define VVAR(name) (vvar_ ## name)
>
> #else
>
> /* Base address of vvars.  This is not ABI. */
> #ifdef CONFIG_X86_64
> #define VVAR_ADDRESS (-10*1024*1024 - 4096)
> #else
> extern char __vvar_page;
>
> #define VVAR_ADDRESS (&__vvar_page)
> #endif
>
> This would do the trick!
>
> But for 64 bit to 32 bit conversation layer in vclock_gettime.c there is
> still a
>
> struct arch_vsyscall_gtod_data arch_vvar_vsyscall_gtod_data
>         __attribute__((visibility("hidden")));
> #define gtod (&arch_vvar_vsyscall_gtod_data)
>
> needed, because vvar_vsyscall_gtod_data is the 32 bit version, which
> would result in incorrect access of the struct members. So my code can't
> use this VVAR macro.

For 32-on-64, I must have read your code wrong.  Are you sticking two
copies of the same struct with different layout into the vvar page?
If so, wouldn't it be better to only have the variant with a common
layout and use it for all versions of the vdso?

--Andy
