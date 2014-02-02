Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751017AbaBBAaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 19:30:39 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50101 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaBBAai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 19:30:38 -0500
MIME-Version: 1.0
In-Reply-To: <52ED90A3.9080802@zytor.com>
References: <1391268756-10766-1-git-send-email-stefani@seibold.net>
 <1391268756-10766-4-git-send-email-stefani@seibold.net> <CALCETrVp+aTm_mT4bg6kcaX3QOnqyjVdfM9vdhHZPsKG276X0A@mail.gmail.com>
 <52ED90A3.9080802@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 1 Feb 2014 16:30:17 -0800
Message-ID: <CALCETrV-odpkNyFFSDRcrOdT1m11FTXgZJ+oASKKWa_wn8hUWw@mail.gmail.com>
Subject: Re: [PATCH 3/4] Add 32 bit VDSO time support for 32 bit kernel
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefani Seibold <stefani@seibold.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
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

On Sat, Feb 1, 2014 at 4:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/01/2014 03:59 PM, Andy Lutomirski wrote:
>>
>>   If it is, indeed, okay to use non-fixed maps on 32-bit, it might
>> also be okay on 64-bit.  If so, it could be useful to implement that,
>> which would remove a bit of a wart and allow PR_SET_TSC to work
>> usefully for 64-bit userspace.  (This would remove the need for the
>> VVAR macro and would allow shorter rip-relative address modes.)
>>
>
> We can't really move the 64-bit legacy vsyscall area, though, as it is
> an ABI.  It can be disabled with vsyscall=none, but Linus has vehemently
> vetoed removing them.

VVAR != vsyscall.  They've been different pages since I wrote the
vsyscall emulation stuff.  Any userspace code that relies on any of
the contents of the VVAR page is totally screwed already, since the
layout changes semi-regularly and depends on whether lockdep is
enabled.

>
>>  (Note that those fixmaps are a security problem on native 32-bit if
>> NX is not available.  We may not care.)
>
> Not only on native 32 bit... although the amount of 64-bit hardware
> without NX is quite small, the same is true for anywhere near modern
> 32-bit hardware.

<irrelevant>It can't be a problem for 32-bit compat mode, though,
since userspace can't address the fixmap anyway.</irrelevant>

>
>>>
>>> -#define VDSO_HIGH_BASE         0xffffe000U /* CONFIG_COMPAT_VDSO address */
>>> +#define VDSO_HIGH_BASE         0xffffc000U /* CONFIG_COMPAT_VDSO address */
>>
>> This is odd.  Can you explain it?
>>
>
> He needs 3 pages instead of 1 after his changes.

Right.  But there's some obscure ABI reason for CONFIG_COMPAT_VDSO,
and if this breaks it, then it's no good.  From extremely vague
memory, there's some version of SuSE that breaks if the 32-bit vdso
moves.  I have no idea what the bug is, but moving a "compat" address
seems suspect.

--Andy
