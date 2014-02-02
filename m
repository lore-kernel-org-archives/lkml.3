Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbaBBA5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 19:57:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37215 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbaBBA5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 19:57:41 -0500
Message-ID: <52ED97D8.50809@zytor.com>
Date: Sat, 01 Feb 2014 16:56:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Stefani Seibold <stefani@seibold.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com, Roland McGrath <roland@hack.frob.com>
Subject: Re: [PATCH 3/4] Add 32 bit VDSO time support for 32 bit kernel
References: <1391268756-10766-1-git-send-email-stefani@seibold.net> <1391268756-10766-4-git-send-email-stefani@seibold.net> <CALCETrVp+aTm_mT4bg6kcaX3QOnqyjVdfM9vdhHZPsKG276X0A@mail.gmail.com> <52ED90A3.9080802@zytor.com> <CALCETrV-odpkNyFFSDRcrOdT1m11FTXgZJ+oASKKWa_wn8hUWw@mail.gmail.com> <384f3ba9-ce01-4779-8988-556cea724f07@email.android.com>
In-Reply-To: <384f3ba9-ce01-4779-8988-556cea724f07@email.android.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2014 04:41 PM, H. Peter Anvin wrote:
>>
>> Right.  But there's some obscure ABI reason for CONFIG_COMPAT_VDSO,
>> and if this breaks it, then it's no good.  From extremely vague
>> memory, there's some version of SuSE that breaks if the 32-bit vdso
>> moves.  I have no idea what the bug is, but moving a "compat" address
>> seems suspect.
>>

Sure enough:

> config COMPAT_VDSO
>         def_bool y
>         prompt "Compat VDSO support"
>         depends on X86_32 || IA32_EMULATION
>         ---help---
>           Map the 32-bit VDSO to the predictable old-style address too.
> 
>           Say N here if you are running a sufficiently recent glibc
>           version (2.3.3 or later), to remove the high-mapped
>           VDSO mapping and to exclusively use the randomized VDSO.
> 
>           If unsure, say Y.

So we need this for 32-bit glibc < 2.3.3, and we effecively have the
same problem as on 64 bits.  Next question is if those old glibcs rely
on the entry point alone or if they also expect the vdso header at that
address.

I looked at the glibc diffs from 2.3.2 to 2.3.3, but it isn't really
obvious to me what assumptions the 2.3.2 glibc made.  Perhaps Roland has
any idea?

The safest thing for that might be to have the compat vdso be a
completely separate object from the real vdso, and let the former be an
object as similar to the current one as possible.

	-hpa

