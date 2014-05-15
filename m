Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaEOCg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 22:36:28 -0400
Received: from relay.parallels.com ([195.214.232.42]:43543 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaEOCg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 22:36:26 -0400
Message-ID: <5374281F.6020807@parallels.com>
Date: Thu, 15 May 2014 06:36:15 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: NULL ptr deref handling mmaping of special mappings
References: <53739201.6080604@oracle.com> <20140514132312.573e5d3cf99276c3f0b82980@linux-foundation.org> <5373D509.7090207@oracle.com> <20140514140305.7683c1c2f1e4fb0a63085a2a@linux-foundation.org> <5373DBE4.6030907@oracle.com> <20140514143124.52c598a2ba8e2539ee76558c@linux-foundation.org> <CALCETrXQOPBOBOgE_snjdmJM7zi34Ei8-MUA-U-YVrwubz4sOQ@mail.gmail.com> <20140514221140.GF28328@moon> <CALCETrUc2CpTEeo=NjLGxXQWHn-HG3uYUo-L3aOU-yVjVx3PGg@mail.gmail.com>
In-Reply-To: <CALCETrUc2CpTEeo=NjLGxXQWHn-HG3uYUo-L3aOU-yVjVx3PGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.79.130.117]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 02:23 AM, Andy Lutomirski wrote:
> On Wed, May 14, 2014 at 3:11 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> On Wed, May 14, 2014 at 02:33:54PM -0700, Andy Lutomirski wrote:
>>> On Wed, May 14, 2014 at 2:31 PM, Andrew Morton
>>> <akpm@linux-foundation.org> wrote:
>>>> On Wed, 14 May 2014 17:11:00 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
>>>>
>>>>>> In my linux-next all that code got deleted by Andy's "x86, vdso:
>>>>>> Reimplement vdso.so preparation in build-time C" anyway.  What kernel
>>>>>> were you looking at?
>>>>>
>>>>> Deleted? It appears in today's -next. arch/x86/vdso/vma.c:124 .
>>>>>
>>>>> I don't see Andy's patch removing that code either.
>>>>
>>>> ah, OK, it got moved from arch/x86/vdso/vdso32-setup.c into
>>>> arch/x86/vdso/vma.c.
>>>>
>>>> Maybe you managed to take a fault against the symbol area between the
>>>> _install_special_mapping() and the remap_pfn_range() call, but mmap_sem
>>>> should prevent that.
>>>>
>>>> Or the remap_pfn_range() call never happened.  Should map_vdso() be
>>>> running _install_special_mapping() at all if
>>>> image->sym_vvar_page==NULL?
>>>
>>> I'm confused: are we talking about 3.15-rcsomething or linux-next?
>>> That code changed.
>>>
>>> Would this all make more sense if there were just a single vma in
>>> here?  cc: Pavel and Cyrill, who might have to deal with this stuff in
>>> CRIU
>>
>> Well, for criu we've not modified any vdso kernel's code (except
>> setting VM_SOFTDIRTY for this vdso VMA in _install_special_mapping).
>> And never experienced problems Sasha points. Looks like indeed in
>> -next code is pretty different from mainline one. To figure out
>> why I need to fetch -next branch and get some research. I would
>> try to do that tomorrow (still hoping someone more experienced
>> in mm system would beat me on that).
> 
> I can summarize:
> 
> On 3.14 and before, the vdso is just a bunch of ELF headers and
> executable data.  When executed by 64-bit binaries, it reads from the
> fixmap to do its thing.  That is, it reads from kernel addresses that
> don't have vmas.  When executed by 32-bit binaries, it doesn't read
> anything, since there was no 32-bit timing code.
> 
> On 3.15, the x86_64 vdso is unchanged.  The 32-bit vdso is preceded by
> a separate vma containing two pages worth of time-varying read-only
> data.  The vdso reads those pages using PIC references.
> 
> On linux-next, all vdsos work the same way.  There are two vmas.  The
> first vma is executable text, which can be poked at by ptrace, etc
> normally.  The second vma contains time-varying state, should not
> allow poking, and is accessed by PIC references.

Is this 2nd vma seen in /proc/pid/maps? And if so, is it marked somehow?

> What does CRIU do to restore the vdso?  Will 3.15 and/or linux-next
> need to make some concession for CRIU?

We detect the vdso by "[vdso]" mark in proc at dump time and mark it in
the images. At restore time we check that vdso symbols layout hasn't changed
and just remap it in proper location.

If this remains the same in -next, then we're fine :)

Thanks,
Pavel
