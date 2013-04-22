Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3DVCuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 22:50:51 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49274 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab3DVCut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 22:50:49 -0400
Message-ID: <5174A57C.5090305@linux.vnet.ibm.com>
Date: Mon, 22 Apr 2013 10:50:36 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/15] KVM: MMU: fast zap all shadow pages
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130421130346.GE8997@redhat.com> <5173F319.2040106@linux.vnet.ibm.com> <20130421152431.GA28437@amt.cnet>
In-Reply-To: <20130421152431.GA28437@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042202-9574-0000-0000-0000078D6F5C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2013 11:24 PM, Marcelo Tosatti wrote:
> On Sun, Apr 21, 2013 at 10:09:29PM +0800, Xiao Guangrong wrote:
>> On 04/21/2013 09:03 PM, Gleb Natapov wrote:
>>> On Tue, Apr 16, 2013 at 02:32:38PM +0800, Xiao Guangrong wrote:
>>>> This patchset is based on my previous two patchset:
>>>> [PATCH 0/2] KVM: x86: avoid potential soft lockup and unneeded mmu reload
>>>> (https://lkml.org/lkml/2013/4/1/2)
>>>>
>>>> [PATCH v2 0/6] KVM: MMU: fast invalid all mmio sptes
>>>> (https://lkml.org/lkml/2013/4/1/134)
>>>>
>>>> Changlog:
>>>> V3:
>>>>   completely redesign the algorithm, please see below.
>>>>
>>> This looks pretty complicated. Is it still needed in order to avoid soft
>>> lockups after "avoid potential soft lockup and unneeded mmu reload" patch?
>>
>> Yes.
>>
>> I discussed this point with Marcelo:
>>
>> ======
>> BTW, to my honest, i do not think spin_needbreak is a good way - it does
>> not fix the hot-lock contention and it just occupies more cpu time to avoid
>> possible soft lock-ups.
>>
>> Especially, zap-all-shadow-pages can let other vcpus fault and vcpus contest
>> mmu-lock, then zap-all-shadow-pages release mmu-lock and wait, other vcpus
>> create page tables again. zap-all-shadow-page need long time to be finished,
>> the worst case is, it can not completed forever on intensive vcpu and memory
>> usage.
>>
>> I still think the right way to fix this kind of thing is optimization for
>> mmu-lock.
>> ======
>>
>> Which parts scare you? Let's find a way to optimize for it. ;). For example,
>> if you do not like unmap_memslot_rmap_nolock(), we can simplify it - We can
>> use walk_shadow_page_lockless_begin() and walk_shadow_page_lockless_end() to
>> protect spte instead of kvm->being_unmaped_rmap.
>>
>> Thanks!
> 
> Xiao,
> 
> You can just remove all shadow rmaps now that you've agreed per-memslot
> flushes are not necessary. Which then gets rid of necessity for lockless 
> rmap accesses. Right?

Hi Marcelo,

I am worried about:

======
We can not release all rmaps. If we do this, ->invalidate_page and
->invalidate_range_start can not find any spte using the host page,
that means, Accessed/Dirty for host page is missing tracked.
(missing call kvm_set_pfn_accessed and kvm_set_pfn_dirty properly.)

[https://lkml.org/lkml/2013/4/18/358]
======

Do you think this is a issue? What's your idea?

Thanks!

