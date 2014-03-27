Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbaC0WhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 18:37:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60410 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370AbaC0Wg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 18:36:57 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <53348D90.1030300@linaro.org>
References: <1395094933-14252-1-git-send-email-stefani@seibold.net> <1395094933-14252-11-git-send-email-stefani@seibold.net> <53348D90.1030300@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v23 10/13] x86, vdso: Add 32 bit VDSO time support for 64 bit kernel
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 27 Mar 2014 15:35:28 -0700
To: John Stultz <john.stultz@linaro.org>,
        Stefani Seibold <stefani@seibold.net>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
CC: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com
Message-ID: <99bf6cc3-9543-43a6-9c56-ea577c07667f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am hoping that we well get further cleanups, but art this point I'm not sure it is worth blocking it for 3.15 over that 

On March 27, 2014 1:44:00 PM PDT, John Stultz <john.stultz@linaro.org> wrote:
>On 03/17/2014 03:22 PM, Stefani Seibold wrote:
>> This patch add the VDSO time support for the IA32 Emulation Layer.
>>
>> Due the nature of the kernel headers and the LP64 compiler where the
>> size of a long and a pointer differs against a 32 bit compiler, there
>> is some type hacking necessary for optimal performance.
>>
>> The vsyscall_gtod_data struture must be a rearranged to serve 32- and
>> 64-bit code access at the same time:
>>
>> - The seqcount_t was replaced by an unsigned, this makes the
>>   vsyscall_gtod_data intedepend of kernel configuration and internal
>functions.
>> - All kernel internal structures are replaced by fix size elements
>>   which works for 32- and 64-bit access
>> - The inner struct clock was removed to pack the whole struct.
>>
>> The "unsigned seq" would be handled by functions derivated from
>seqcount_t.
>
>Sorry for being a bit late on the review here. I've been focused on
>some
>other things and figured I'd leave things to the x86 maintainers, since
>it didn't touch any core timekeeping code. But Andy pinged me after
>LSF-MM and so I'm trying to take a closer look.
>
>I know this has gone through tons of iterations, and I really am glad
>for Stefani's persistence. Also I do realize its already in the tip
>tree, so my thoughts here are probably too late to be worth much.
>
>
>> Signed-off-by: Stefani Seibold <stefani@seibold.net>
>> ---
>>  arch/x86/include/asm/vgtod.h          | 71
>+++++++++++++++++++++------
>>  arch/x86/include/asm/vvar.h           |  5 ++
>>  arch/x86/kernel/vsyscall_gtod.c       | 34 ++++++++-----
>>  arch/x86/vdso/vclock_gettime.c        | 91
>+++++++++++++++++++----------------
>>  arch/x86/vdso/vdso32/vclock_gettime.c | 21 ++++++++
>>  5 files changed, 155 insertions(+), 67 deletions(-)
>
>My initial issue with this patch is it is doing quite a few things that
>could have been split up a bit. There's a number of separate cleanups:
>seqlock change, the read_hpet_counter() cleanup, the vsyscall_gtod_data
>structure rework, and finally the gtod_long_t and  VDSO32_64 changes.
>
>Its probably too late now, but in the future it might be good to try to
>split these sorts of things up in smaller chunks.
>
>Overall, I don't see any obvious correctness issues with the code, so
>it
>looks ok to me, but I really worry the amount of open-coded logic and
>the quirkiness of trying to make the vsyscall_gtod_data structure
>usable
>for both architectures at the same time really makes this code quite
>fragile. Looking over this there were lots of "oh, that's broken..
>wait.. no.. actually that will work" moments. So I'm worried about the
>maintenance burden in the future from it. 
>
>Having separate structures that are filled by update_vsyscall might be
>nice to avoid needing the open-coded bits, but that would require
>basically making a copy of all the data in the structure each update,
>so
>that might not be worth the cost.
>
>So as long as the x86 folks are ok with being on the hook for it, I'll
>not get in the way (most other arches have quirky/ugly implementations
>for their vdso/vsyscall/fsyscall/etc, so why not join the club :).
>
>I did run this through my timekeeping test suite and on 64bit nothing
>broke w/ either 32 or 64bit binaries, but I also don't have the glibc
>changes to enable the 32bit vdso, so all that says is its not showing
>any regressions for my existing setup.
>
>thanks
>-john

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
