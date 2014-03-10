Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbaCJVoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:44:01 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:36238 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaCJVn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:43:57 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwuVYds=ssv755WKBvux1ru6fcDLGi+ORSFyU8xYP7+=w@mail.gmail.com>
References: <20140307013833.GD8427@localhost> <1394176888.1018.3.camel@wall-e.seibold.net>
 <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>
 <1394229220.20013.13.camel@wall-e.seibold.net> <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com>
 <1394354848.1002.37.camel@wall-e.seibold.net> <531D044C.2090303@linux.intel.com>
 <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>
 <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>
 <531DD35A.5060202@linux.intel.com> <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com>
 <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com>
 <1394481804.980.9.camel@wall-e.seibold.net> <531E1B53.5090205@linux.intel.com>
 <CA+55aFyxbuhPKgB=U8R5C5T_iKVvju-oQDS4kHz6McW45B+1bA@mail.gmail.com> <CA+55aFwuVYds=ssv755WKBvux1ru6fcDLGi+ORSFyU8xYP7+=w@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Mar 2014 14:43:36 -0700
Message-ID: <CALCETrW5UkvOwJPvuWVAxz3y4sCPCHrJHs_GoSYtMbGWiG8WfQ@mail.gmail.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Stefani Seibold <stefani@seibold.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 2:20 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Mar 10, 2014 at 1:19 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> If the only immediate problem is the code generation size, then Andy
>> already had a (simpler) hack-around:
>>
>>   #undef CONFIG_OPTIMIZE_INLINING
>>   #undef CONFIG_X86_PPRO_FENCE
>>
>> in vclock_gettime.c
>
> Btw, we should seriously consider getting rid of CONFIG_X86_PPRO_FENCE.
>
> It was of questionable value to begin with, and I think that the
> actual PPro bug is about one of
>
>  - Errata 66, "Delayed line invalidation".
>  - Errata 92, "Potential loss of data coherency"
>
> both of which affect all PPro versions afaik (there is also a UP
> errata 51 wrt ordering of cached and uncached accesses that was fixed
> in the sB1 stepping).
>
> And as far as I know, we have never actually seen the bug in real
> life, EVEN WHEN PPRO WAS COMMON. The workaround was always based on
> knowledge of the errata afaik.

I admit I don't fully follow the description of the errata, but it's
not obvious to me that making smp_rmb() emit lfence is going to do any
good.  The description seems to be suggesting using actual LOCK
operations to work around the erratum.

>
> So I do think we might want to consider retiring that config option
> entirely as a "historical oddity".
>
> And very much so for the vdso case. Do we even do the asm alternative
> fixups for the vdso?

Yes, we've done that for a couple years for rdtsc_barrier's benefit.

>
> I also suspect we should get rid of CONFIG_X86_OOSTORE, or at least
> limit it to !SMP - I don't think anybody ever made SMP systems with
> those IDT/Centaur Winchip chips in them.

Why does OOSTORE matter for !SMP?  Is it just for poking at hardware registers?

--Andy
