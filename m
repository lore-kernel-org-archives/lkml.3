Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab3HUQDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:03:19 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41359 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3HUQDS convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Wed, 21 Aug 2013 12:03:18 -0400
Message-Id: <521500E102000078000ED65C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 21 Aug 2013 17:03:13 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>,
        "David Vrabel" <david.vrabel@citrix.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <Xen-devel@lists.xen.org>,
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
In-Reply-To: <20130821154238.GV18673@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.08.13 at 17:42, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Wed, Aug 21, 2013 at 03:53:36PM +0100, Jan Beulich wrote:
>> >>> On 21.08.13 at 16:12, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> > David, could you please explain, Xen keeps and analyze _PTE_PAT bit
>> > for ptes which are not present?
>> 
>> No, the problem isn't with not-present PTEs (i.e. swap entries),
>> but with present ones - the same bit (7) is being used for both,
>> according to this comment:
>> 
>> /*
>>  * Tracking soft dirty bit when a page goes to a swap is tricky.
>>  * We need a bit which can be stored in pte _and_ not conflict
>>  * with swap entry format. On x86 bits 6 and 7 are *not* involved
>>  * into swap entry computation, but bit 6 is used for nonlinear
>>  * file mapping, so we borrow bit 7 for soft dirty tracking.
>>  */
>> 
>> Or are you telling me that the comment is misleading (at least me),
>> and this applies only to not-present PTEs? And even then - where
>> would the value of the original PAT bit be stored while swapped
>> out (or is it impossible - now and forever - for WC pages to get
>> swapped)?
> 
> Only to non-present ptes, as far as I know.

That's not really any guarantee. And the accessor functions also
don't check that they'd be used on non-present PTEs only.

> do_swap_page
> 	...
> 	pte = mk_pte(page, vma->vm_page_prot);
> 
> 	/* new pte from vm_page_prot generated */
> 	...
> 	set_pte_at(mm, address, page_table, pte);
> 	/* and assigned to old place */
> 
> with soft dirty in swap it is somehow more weirdy
> 
> 	pte = mk_pte(page, vma->vm_page_prot);
> 	...
> 	if (pte_swp_soft_dirty(orig_pte))
> 		pte = pte_mksoft_dirty(pte);
> 	set_pte_at(mm, address, page_table, pte);
> 
> orig_pte has pse bit set if page has been soft dirty
> when it reached swap.

"when it reached swap" to me again implies that it could come
from a live page table, with the present bit set. So that
explanation attempt of yours confuses me more than it
clarifies things for me. (And referring to this bit as PSE bit is
sort of wrong here too - there's no PSE bit for 4k PTEs, that
bit is the PAT one, and that's what the whole discussion
started from.)

Jan

