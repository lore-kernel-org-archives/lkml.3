Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab3HVKQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 06:16:18 -0400
Received: from relay.parallels.com ([195.214.232.42]:40821 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3HVKQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 06:16:16 -0400
Message-ID: <5215E4E7.1020808@parallels.com>
Date: Thu, 22 Aug 2013 14:16:07 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jan Beulich <JBeulich@suse.com>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>, <Xen-devel@lists.xen.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
References: <5214C524.1050900@citrix.com>	<20130821141223.GS18673@moon>	<5214F09002000078000ED5C3@nat28.tlf.novell.com>	<20130821154238.GV18673@moon>	<521500E102000078000ED65C@nat28.tlf.novell.com>	<20130821161946.GW18673@moon>	<5214F128.1000901@citrix.com>	<20130821172547.GY18673@moon>	<20130821181733.GC3814@moon>	<4fec3e5b-695c-438b-ad6d-55ca50becc4c@email.android.com>	<20130821190307.GB18673@moon> <CA+55aFw_tWio_ABFUocNHU+_RKe-27U9_=4ATfp3-vSWVZkdug@mail.gmail.com> <5215DAC0.8080806@citrix.com>
In-Reply-To: <5215DAC0.8080806@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 01:32 PM, David Vrabel wrote:
> On 22/08/13 00:04, Linus Torvalds wrote:
>> On Wed, Aug 21, 2013 at 12:03 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>
>>> I personally don't see bug here because
>>>
>>>  - this swapped page soft dirty bit is set for non-present entries only,
>>>    never for present ones, just at moment we form swap pte entry
>>>
>>>  - i don't find any code which would test for this bit directly without
>>>    is_swap_pte call
>>
>> Ok, having gone through the places that use swp_*soft_dirty(), I have
>> to agree. Afaik, it's only ever used on a swap-entry that has (by
>> definition) the P bit clear. So with or without Xen, I don't see how
>> it can make any difference.
>>
>> David/Konrad - did you actually see any issues, or was this just from
>> (mis)reading the code?
> 
> There are no Xen related bugs in the code, we were misreading it.
> 
> It was my call to raise this as a regression without a repro and clearly
> this was the wrong decision.
> 
> However, having looked at the soft dirty implementation and specifically
> the userspace ABI I think that it is far to closely coupled to the
> current implementation.  I think this will constrain future development
> of the feature should userspace require a more efficient ABI than
> scanning all of /proc/<pid>/pagemaps.
> 
> Minimal downtime during 'live' checkpointing of a running task needs the
> checkpointer to find and write out dirty pages faster than the task can
> dirty them.

Absolutely, but in "find and write" the "write" component is likely to take
the majority of time -- we can scan PTEs of a mapping MUCH faster, than
transmitting those over even 10Gbit link.

We actually see this IRL -- in CRIU there's an atomic test, that checks
mappings get dumped and restored properly. One of sub-tests is one 512Mb mapping.
With it total dump time _minus_ memory dump time (which includes not only pagemap
file scan, but also files, registers, process tree, sessions, etc.) is fractions 
of one second, while only the memory dump part's time is several seconds.

That said, the super-fast API for getting "what has changed" is not as tempting
to have as faster network/disk.

What is _more_ time consuming in iterative migration in our case is the need to
re-scan the whole /proc tree to get which processes had died and appeared, mess 
with /proc/pid/fd finding out what files were (re-)opened/closed/changed, talking
to sock_diag subsystem for sockets information and alike. However, we haven't yet
done careful analysis for what the slowest part is, but pagemap scans is definitely
not.

> This seems less likely to be possible if every iteration
> all PTEs have to be scanned by the checkpointer instead of (e.g.,)
> accessing a separate list of dirtied pages.

But we don't scan all the x64 virtual address space's PTEs, instead we first
analyze the /proc/pid/maps and scan only PTEs sitting in private mappings.

> David
> .
> 

Thanks,
Pavel
