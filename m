Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3DWATQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 20:19:16 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:60135 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab3DWATO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 20:19:14 -0400
Message-ID: <5175D376.6060908@linux.vnet.ibm.com>
Date: Tue, 23 Apr 2013 08:19:02 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: mtosatti@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/15] KVM: MMU: fast zap all shadow pages
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130421130346.GE8997@redhat.com> <5173F319.2040106@linux.vnet.ibm.com> <20130422092117.GM8997@redhat.com>
In-Reply-To: <20130422092117.GM8997@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042300-1618-0000-0000-000003BE8D51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 05:21 PM, Gleb Natapov wrote:
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
> So what about mixed approach: use generation numbers and reload roots to
> quickly invalidate all shadow pages and then do kvm_mmu_zap_all_invalid().
> kvm_mmu_zap_all_invalid() is a new function that invalidates only shadow
> pages with stale generation number (and uses lock break technique). It
> may traverse active_mmu_pages from tail to head since new shadow pages
> will be added to the head of the list or it may use invalid slot rmap to
> find exactly what should be invalidated.

I prefer to unmapping the invalid rmap instead of zapping stale shadow pages
in kvm_mmu_zap_all_invalid(), the former is faster.

This way may help but not good, after reload mmu with the new generation number,
all of the vcpu will fault in a long time, try to hold mmu-lock is not good even
if use lock break technique.

I think we can do this step first, then unmapping invalid rmap out of mmu-lock
later.

> 
>> I still think the right way to fix this kind of thing is optimization for
>> mmu-lock.
>> ======
>>
>> Which parts scare you? Let's find a way to optimize for it. ;). For example,
>> if you do not like unmap_memslot_rmap_nolock(), we can simplify it - We can
>> use walk_shadow_page_lockless_begin() and walk_shadow_page_lockless_end() to
>> protect spte instead of kvm->being_unmaped_rmap.
>>
> 
> kvm->being_unmaped_rmap is particularly tricky, although looks

Okay. Will use walk_shadow_page_lockless_begin() and walk_shadow_page_lockless_end
instead.

> correct. Additional indirection with rmap ops also does not help following
> the code. I'd rather have if(slot is invalid) in a couple of places where
> things should be done differently. In most places it will be WARN_ON(slot
> is invalid).

Less change, good to me, will do. ;)

Thanks!

