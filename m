Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaA3SIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:08:50 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:43491 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbaA3SIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:08:49 -0500
MIME-Version: 1.0
In-Reply-To: <52EA93E4.6010504@zytor.com>
References: <1391078953-1575-1-git-send-email-stefani@seibold.net>
 <52EA704D.2000809@zytor.com> <1391097131.2898.5.camel@wall-e.seibold.net>
 <CALCETrVaKxY22=4S=mWhUgQ--H77kqnay5G8f847H=Cfper86w@mail.gmail.com> <52EA93E4.6010504@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Jan 2014 10:08:27 -0800
Message-ID: <CALCETrUGgwyf-ya4=AMnNhOohWJSH-Q0OOReourqZXxTnEP0_A@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add 32 bit VDSO time function support
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

On Thu, Jan 30, 2014 at 10:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/30/2014 09:57 AM, Andy Lutomirski wrote:
>>
>> By definition there aren't any broken users of the new functions,
>> because there aren't any users at all.  So... should we start
>> randomizing this thing from the beginning?
>>
>
> The vdso already exists.  It isn't new.  Randomizing it might be a good
> idea, though; it already is randomized on 64 bits.
>
>> Also, since the VVAR page has a real vma, should something be done to
>> prevent mprotect or ptrace from COWing it?  Users will be rather
>> surprised if it suddenly stops updating.
>
> What happens currently on 64 bits?  I think we just take the attitude
> that "don't do that, then", and it hasn't seemed to be a problem.

On 64 bits, the vvar page is not part of the vdso vma -- it lives in
the fixmap.  So mprotect will return -EINVAL, I think.

With IA32 emulation, the vvar page has to live in the user address
space range (since there is no user-addressable kernel space), so it
seems more likely that user code will at least try to poke at it.

>
>> Finally, this might be the time to kill off the userspace mapping of
>> the HPET.  I suspect that there are few if any machines for which the
>> HPET is fast enough that avoiding a syscall matters at all.  (On my
>> box at work, reading the HPET takes ~500 nanoseconds.  I can do a lot
>> of syscalls in that amount of time.)
>
> I think this can be independent of extending the current 64-bit
> functionality to 32 bits.  It is a valid question, though.

My thinking is that if we do it now then there will never be a caller
of vclock_gettime that can't deal with it being randomized.
Admittedly, this isn't too likely regardless.

--Andy

>
>         -hpa
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
