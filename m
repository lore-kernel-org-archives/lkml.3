Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3HANaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:30:16 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:49642 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3HANaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:30:13 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [PATCH] Xen: Fix retry calls into PRIVCMD_MMAPBATCH*.
From: Andres Lagar-Cavilla <andreslc@gridcentric.ca>
In-Reply-To: <51FA4EDD.4040509@citrix.com>
Date: Thu, 1 Aug 2013 09:30:08 -0400
Cc: Andres Lagar-Cavilla <andreslc@gridcentric.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andres Lagar-Cavilla <andres@lagarcavilla.com>,
        <boris.ostrovsky@oracle.com>
Content-Transfer-Encoding: 7BIT
Message-Id: <36C91A76-8C6D-47F0-8229-099779634A53@gridcentric.ca>
References: <1375203632-23854-1-git-send-email-andres@lagarcavilla.org> <2BE2F119-7375-4C8D-933D-9BCD5A9B7552@gridcentric.ca> <51FA4547.7080408@citrix.com> <5373EBB3-5CF1-4A2F-B821-1DD788877F75@gridcentric.ca> <51FA4EDD.4040509@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 1, 2013, at 8:04 AM, David Vrabel <david.vrabel@citrix.com> wrote:

> On 01/08/13 12:49, Andres Lagar-Cavilla wrote:
>> On Aug 1, 2013, at 7:23 AM, David Vrabel <david.vrabel@citrix.com> wrote:
>> 
>>> On 01/08/13 04:30, Andres Lagar-Cavilla wrote:
>>>> -- Resend as I haven't seen this hit the lists. Maybe some smtp misconfig. Apologies. Also expanded cc --
>>>> 
>>>> When a foreign mapper attempts to map guest frames that are paged out,
>>>> the mapper receives an ENOENT response and will have to try again
>>>> while a helper process pages the target frame back in.
>>>> 
>>>> Gating checks on PRIVCMD_MMAPBATCH* ioctl args were preventing retries
>>>> of mapping calls.
>>> 
>>> This breaks the auto_translated_physmap case as will allocate another
>>> set of empty pages and leak the previous set.
>> 
>> David,
>> not able to follow you here. Under what circumstances will another
>> set of empty pages be allocated? And where? are we talking page table pages?
> 
> 	....
> 	vma = find_vma(mm, m.addr);
> 	if (!vma ||
> 	    vma->vm_ops != &privcmd_vm_ops ||
> 	    (m.addr != vma->vm_start) ||
> 	    ((m.addr + (nr_pages << PAGE_SHIFT)) != vma->vm_end) ||
> 	    !privcmd_enforce_singleshot_mapping(vma)) {
> 		up_write(&mm->mmap_sem);
> 		ret = -EINVAL;
> 		goto out;
> 	}
> 	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> 		ret = alloc_empty_pages(vma, m.num);
> 
> Here.

Right right right. Excellent observation thanks. I fwd ported from 3.4 and this slipped through the cracks. Ok, V2 coming.
> 
> 		if (ret < 0) {
> 			up_write(&mm->mmap_sem);
> 			goto out;
> 		}
> 	}
> 
> 
>>> This privcmd_enforce_singleshot_mapping() stuff seems very odd anyway.
>>> Does anyone know what it was for originally?  It would be preferrable if
>>> we could update the mappings with a new set of foreign MFNs without
>>> having to tear down the VMA and recreate a new VMA.
>> 
>> I believe it's mostly historical. I agree with you on principle, but recreating VMAs is super-cheap.
> 
> Tearing them down is not cheap as each page requires a trap-and-emulate
> to clear the PTE (see ptep_get_and_clear_full() in zap_pte_range()).

You need to tell the hypervisor to drop the ref on the mapped page. So you'd need a hyper call (arguably a multi-call) to do that, which is not free. Then you'd need privcmd and libxc to collude on agreeing to reuse the vma -- which has very low value in itself, just a piece of metadata. And you still need to deal with cleaning up the mapped refs when the mapping process crashes.

So a whole lot of new complexity for small value, imho.

Probably that's the whole point of the singleshot: don't forget you have something mapped in there. Because if you do you might leak the ref forever.

Andres
> 
> David

