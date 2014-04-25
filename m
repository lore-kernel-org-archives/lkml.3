Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaDYGGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 02:06:08 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:63445 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaDYGGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 02:06:05 -0400
Message-ID: <5359FB48.1020007@codesourcery.com>
Date: Fri, 25 Apr 2014 14:06:00 +0800
From: Chung-Lin Tang <cltang@codesourcery.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, Ley Foon Tan <lftan@altera.com>,
        Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Andrew Pinski <apinski@cavium.com>,
        "Tang, Chung-Lin" <ChungLin_Tang@mentor.com>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
References: <1397824031-4892-1-git-send-email-lftan@altera.com> <5354AD36.5090809@zytor.com> <CAFiDJ5861HE4AXtio-8uNJppWE2oaPt9_OKyGV=Myb_3vPrOVA@mail.gmail.com> <16597012.pEkDc99HDN@wuerfel> <CAFiDJ5_dUpVTSeC36AfNKVN7BOa9GQ5vwSEWricm=8Sam9mR2A@mail.gmail.com> <5357FF8E.9010809@codesourcery.com> <E780DB23-B6A3-427B-8F33-71378088A3F5@caviumnetworks.com> <5358AE96.9010006@codesourcery.com> <5358D17D.1040609@codesourcery.com> <20140424152819.GI8521@arm.com>,<535959DF.6050009@codesourcery.com> <3AD1421B-E5FC-41F3-AE33-29655052DA4B@caviumnetworks.com>
In-Reply-To: <3AD1421B-E5FC-41F3-AE33-29655052DA4B@caviumnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Apr 2014 06:06:01.0473 (UTC) FILETIME=[6F191710:01CF604C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/25 02:42 AM, Pinski, Andrew wrote:
> 
> 
>> On Apr 24, 2014, at 11:37 AM, "Chung-Lin Tang" <cltang@codesourcery.com> wrote:
>>
>>> On 2014/4/24 11:28 PM, Catalin Marinas wrote:
>>>> On Thu, Apr 24, 2014 at 09:55:25AM +0100, Chung-Lin Tang wrote:
>>>>> On 2014/4/24 02:26 PM, Chung-Lin Tang wrote:
>>>>>> On 2014/4/24 上午 02:15, Pinski, Andrew wrote:
>>>>>>
>>>>>>>> On Apr 23, 2014, at 10:59 AM, "Chung-Lin Tang" <cltang@codesourcery.com> wrote:
>>>>>>>>
>>>>>>>>>> On 2014/4/22 07:20 PM, Ley Foon Tan wrote:
>>>>>>>>>> On Tue, Apr 22, 2014 at 6:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>>>>>>>>>>> On Tuesday 22 April 2014 18:37:11 Ley Foon Tan wrote:
>>>>>>>>>>>>>>>>>> Hi Arnd and Peter Anvin,
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> Other than 64-bit time_t, clock_t and suseconds_t, can you confirm
>>>>>>>>>>>>>>>>>> that we don't need to have 64 bit off_t? See detail in link below.
>>>>>>>>>>>>>>>>>> I can submit the patches for 64-bit time changes
>>>>>>>>>>>>>>>>>> (include/asm-generic/posix_types.h and other archs) if everyone is
>>>>>>>>>>>>>>>>>> agreed on this.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Yes.
>>>>>>>>>> Okay, will doing that.
>>>>>>>>
>>>>>>>> I believe that arm64 ILP32 will also be affected. What is the status of
>>>>>>>> this configuration? Has the glibc/kernel ABI been finalized?
>>>>>> Not yet.  I am still working out the signal handling part. But we
>>>>>> already agreed on 64bit time_t, clock_t, and suseconds_t.  And we
>>>>>> agreed to a 64bit offset_t too. 
>>>>>>
>>>>>> On a related note suseconds in the timespec in posix is defined to
>>>>>> be long. So it would nice if the kernel ignores the upper 32bits so
>>>>>> we (glibc developers) can fix this for new targets including x32
>>>>>> and arm64/ilp32.
>>>>>
>>>>> Hmm, but that means for purely 32-bit architectures like nios2, which
>>>>> unlike x86_64 or arm64, never has a 64-bit mode, suseconds_t as a 64-bit
>>>>> type in the kernel is simply wasted.
>>>>
>>>> The more I think of this, the more I feel that suseconds_t should jsut
>>>> be 'long', not strictly 64-bitified. An ILP32 sub-mode in a 64-bit
>>>> kernel should be using compat_* code paths, something like a
>>>> COMPAT_USE_32BIT_SUSECONDS case.
>>>
>>> ILP32 mode should use LP64 syscalls as much as possible and that's the
>>> aim with arm64 as well (of course, we still have a few that wouldn't be
>>> possible and we route them via compat).
>>>
>>> But here if time_t is 64-bit while susecconds_t is 32-bit, the compat
>>> code wouldn't help.
>>
>> Why not? You can define the arm64 'struct compat_timeval' with
>> suseconds_t as s32, and add the 32<-->64 case in the
>> compat_get/put_timeval path, triggered when the process is ILP32 (test
>> wrapped in the above hypothetical COMPAT_USE_32BIT_SUSECONDS macro).
>> Similar to how x32 does COMPAT_USE_64BIT_TIME.
> 
> We would three timeval then. One for aarch32, one for lp64 and one for ilp32. We really don't want three. Two is already one too many in my mind after developing the ilp32 syscall abi. 
> 
> Thanks,
> Andrew

Okay I now see you're already doing that for 32-bit ARM.

Still, you would probably just need to have an arm64-ILP32 specific case
to be careful about the last padding word upon kernel entry/exit.
(accommodating the difference in sizeof(long))  Penalizing all
architectures does not seem like the best solution.

Having suseconds_t as a strictly 64-bit C type in the kernel, while
defined as <= long in user-space may cause other problems.

I'll try to explain a probable situation for Nios II. I'm not sure about
other soft-cores, but nios2 is sort of uncommon in that the maximum
alignment is 4-bytes (32-bits), even for doubles/long-longs.

So if time_t is 64-bits (which makes sense), then struct timeval, which
is time_t+suseconds_t in userspace is 12-bytes/aligned-4 (unlike many
archs where a 64-bit time_t will expand the size to 16-bytes, due to
align-8)

If the kernel suseconds_t is forced to be 64-bits, then nios2 will have
a 16-byte kernel timeval vs. 12-byte userspace timeval situation. Just
this will require us to do something using compat_*, or weird hacks in
glibc, which is unfair. Nios II has no "other-mode". We are just
strictly ILP32, everywhere.

Of course, we can probably still at the end just use a Nios II specific
posix_types.h header to override things, but I'm just stating this as a
matter of which are the most reasonable default settings in the generic
headers. Making pure ILP32 archs diverge from POSIX standards by default
does not seem to be right.

Thanks,
Chung-Lin

