Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbaDKWPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:15:40 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:34889 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaDKWPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <534865DF.2090703@linux.intel.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
 <53483487.6030103@zytor.com> <53485BB8.1000106@mit.edu> <53485D95.9030301@zytor.com>
 <5348643F.1020405@mit.edu> <534865DF.2090703@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 11 Apr 2014 15:15:16 -0700
Message-ID: <CALCETrX4BLLL1Con7+Fr5cfodHQs40qA4TE39yop2NeARdwA+A@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 2:59 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 04/11/2014 02:53 PM, Andy Lutomirski wrote:
>>
>> How big of a functionality problem is it?  Apparently it doesn't break
>> 16-bit code on wine.
>>
>
> It breaks *some* 16-bit code.  This is actually the reason that 32 bits
> has the espfix workaround - it wasn't identified as an infoleak at the time.
>
>> Since the high bits of esp have been corrupted on x86_64 since the
>> beginning, there's no regression issue here if an eventual fix writes
>> less meaningful crap to those bits -- I see no real reason to try to put
>> the correct values in there.
>
> It is a regression vs. the 32-bit kernel, and if we're going to support
> 16-bit code we should arguably support 16-bit code correctly.
>
> This is actually how I stumbled onto this problem in the first place: it
> broke a compiler test suite for gcc -m16 I was working on.  The
> workaround for *that* was to run in a VM instead.
>
>>>> I would have suggested rejecting modify_ldt() entirely, to reduce attack
>>>> surface, except that some early versions of 32-bit NPTL glibc use
>>>> modify_ldt() to exclusion of all other methods of establishing the
>>>> thread pointer, so in order to stay compatible with those we would need
>>>> to allow 32-bit segments via modify_ldt() still.
>>
>> I actually use modify_ldt for amusement: it's the only way I know of to
>> issue real 32-bit syscalls from 64-bit userspace.  Yes, this isn't
>> really a legitimate use case.
>
> That's actually wrong on no less than two levels:
>
> 1. You can issue real 32-bit system calls from 64-bit user space simply
>    by invoking int $0x80; it works in 64-bit mode as well.
>
> 2. Even if you want to be in 32-bit mode you can simply call via
>    __USER32_CS, you don't need an LDT entry.

I just looked up my hideous code.  I was doing this to test the
now-deleted int 0xcc vsyscall stuff.  I used modify_ldt because either
I didn't realize that __USER32_CS was usable or I didn't think it was
ABI.  Or I was just being silly.

But yes, breaking my hack would not matter. :)

--Andy
