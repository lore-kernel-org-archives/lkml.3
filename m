Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaIXHEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:04:22 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61234 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaIXHEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:04:20 -0400
Message-ID: <54226CEB.9080504@redhat.com>
Date: Wed, 24 Sep 2014 09:04:11 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Andres Lagar-Cavilla <andreslc@google.com>
CC: Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4] kvm: Fix page ageing bugs
References: <1411410865-3603-1-git-send-email-andreslc@google.com> <1411422882-16245-1-git-send-email-andreslc@google.com> <20140924022729.GA2889@kernel>
In-Reply-To: <20140924022729.GA2889@kernel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/09/2014 04:27, Wanpeng Li ha scritto:
> Hi Andres,
> On Mon, Sep 22, 2014 at 02:54:42PM -0700, Andres Lagar-Cavilla wrote:
>> 1. We were calling clear_flush_young_notify in unmap_one, but we are
>> within an mmu notifier invalidate range scope. The spte exists no more
>> (due to range_start) and the accessed bit info has already been
>> propagated (due to kvm_pfn_set_accessed). Simply call
>> clear_flush_young.
>>
>> 2. We clear_flush_young on a primary MMU PMD, but this may be mapped
>> as a collection of PTEs by the secondary MMU (e.g. during log-dirty).
>> This required expanding the interface of the clear_flush_young mmu
>> notifier, so a lot of code has been trivially touched.
>>
>> 3. In the absence of shadow_accessed_mask (e.g. EPT A bit), we emulate
>> the access bit by blowing the spte. This requires proper synchronizing
>> with MMU notifier consumers, like every other removal of spte's does.
>>
> [...]
>> ---
>> +	BUG_ON(!shadow_accessed_mask);
>>
>> 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
>> 	     sptep = rmap_get_next(&iter)) {
>> +		struct kvm_mmu_page *sp;
>> +		gfn_t gfn;
>> 		BUG_ON(!is_shadow_present_pte(*sptep));
>> +		/* From spte to gfn. */
>> +		sp = page_header(__pa(sptep));
>> +		gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
>>
>> 		if (*sptep & shadow_accessed_mask) {
>> 			young = 1;
>> 			clear_bit((ffs(shadow_accessed_mask) - 1),
>> 				 (unsigned long *)sptep);
>> 		}
>> +		trace_kvm_age_page(gfn, slot, young);
> 
> IIUC, all the rmapps in this for loop are against the same gfn which
> results in the above trace point dump the message duplicated.

You're right; Andres's patch "[PATCH] kvm/x86/mmu: Pass gfn and level to
rmapp callback" helps avoiding that.

Paolo
