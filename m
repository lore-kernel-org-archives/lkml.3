Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3HVHrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:47:24 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:43906 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab3HVHrX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Thu, 22 Aug 2013 03:47:23 -0400
Message-Id: <5215DE2702000078000ED8AE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 22 Aug 2013 08:47:19 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Andy Lutomirski" <luto@amacapital.net>,
        "David Vrabel" <david.vrabel@citrix.com>,
        "Cyrill Gorcunov" <gorcunov@gmail.com>,
        "Andrew Morton" <akpm@linux-foundation.org>, <Xen-devel@lists.xen.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Pavel Emelyanov" <xemul@parallels.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts
 with existing use
References: <5214C524.1050900@citrix.com> <20130821141223.GS18673@moon>
 <5214F09002000078000ED5C3@nat28.tlf.novell.com>
 <20130821154238.GV18673@moon>
 <521500E102000078000ED65C@nat28.tlf.novell.com>
 <20130821161946.GW18673@moon> <5214F128.1000901@citrix.com>
 <20130821172547.GY18673@moon> <20130821181733.GC3814@moon>
 <4fec3e5b-695c-438b-ad6d-55ca50becc4c@email.android.com>
 <20130821190307.GB18673@moon>
 <CA+55aFw_tWio_ABFUocNHU+_RKe-27U9_=4ATfp3-vSWVZkdug@mail.gmail.com>
In-Reply-To: <CA+55aFw_tWio_ABFUocNHU+_RKe-27U9_=4ATfp3-vSWVZkdug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.08.13 at 01:04, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Aug 21, 2013 at 12:03 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>
>> I personally don't see bug here because
>>
>>  - this swapped page soft dirty bit is set for non-present entries only,
>>    never for present ones, just at moment we form swap pte entry
>>
>>  - i don't find any code which would test for this bit directly without
>>    is_swap_pte call
> 
> Ok, having gone through the places that use swp_*soft_dirty(), I have
> to agree. Afaik, it's only ever used on a swap-entry that has (by
> definition) the P bit clear. So with or without Xen, I don't see how
> it can make any difference.
> 
> David/Konrad - did you actually see any issues, or was this just from
> (mis)reading the code?

It was actually me (mis)reading the code - as pointed out to Cyrill
already, setting _PAGE_PAT in a pte_t without even a comment
saying that this can only ever be done with a non-present entry
made me expect problems on Xen, because it's clear that to date
bare metal Linux doesn't care about the state of _PAGE_PAT in
present entries due to the way the PAT MSR gets set (and hence
quite likely no-one would have noticed the supposed problem
while testing).

So a comment either alongside the definition of _PAGE_SWP_SOFT_DIRTY
or directly in pte_swp_{mk,clear_}soft_dirty() would have been
the minimal thing I'd have expected for this sort of re-use of bits.
Ideally even a VM_BUG_ON(pte_present()) or similar. And perhaps
pte_swp_soft_dirty() should be either looking at the present bit
too or similarly asserting that it's clear...

In any event - I'm sorry for the red herring.

Jan

