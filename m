Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3EPNtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:49:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab3EPNtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:49:22 -0400
Message-ID: <5194E3D7.2090808@redhat.com>
Date: Thu, 16 May 2013 15:49:11 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 3/8] KVM: MMU: fast invalidate all pages
References: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1368706673-8530-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130516124349.GC14597@redhat.com> <5194DBBB.3060102@redhat.com> <20130516134130.GD14597@redhat.com>
In-Reply-To: <20130516134130.GD14597@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/05/2013 15:41, Gleb Natapov ha scritto:
> On Thu, May 16, 2013 at 03:14:35PM +0200, Paolo Bonzini wrote:
>> Il 16/05/2013 14:43, Gleb Natapov ha scritto:
>>>>> +restart:
>>>>> +	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
>>>>> +		if (!is_obsolete_sp(kvm, sp))
>>>>> +			continue;
>>> What if we save kvm->arch.active_mmu_pages on the stack and init
>>> kvm->arch.active_mmu_pages to be empty at the entrance to
>>> zap_invalid_pages(). This loop will iterate over saved list. This will
>>> allow us to drop the is_obsolete_sp() check and will save time since we
>>> will not be iterating over newly created sps.
>>>
>>
>> But when you add cond_resched_lock a thread may want to zap pages itself
>> (e.g. from prepare_zap_oldest_mmu_page) and it won't find them.
>>
> Yes, this will break mmu pages accounting. We can make
> prepare_zap_oldest_mmu_page() wait while zap_invalid_pages()
> frees needed amount of pages if one is in progress.
> 
>> Here is another proposal...  The idea is to avoid looking at new pages
>> more than necessary after a "goto restart".
>>
>> Basically, you alternate between two phases:
>>
>> - look for pages to be zapped, group them together
>>
>> - zap the pages
>>
>> Something like:
>>
>>       moved = 0;
>> restart:
>>       zapping = true;
>>       for each page in active_mmu_pages [reverse and safe] {
>>              if (!is_obsolete || invalid) {
>>                  /*
>>                   * Found a new page, stop zapping for now and
>>                   * try to segregate the invalid ones at one end
>>                   * of the list.
>>                   */
>>                  zapping = false;
>>                  continue;
>>              }
>>
>>              if (batch > 10 && ...) {
>>                  cond_resched_lock
>>                  batch = 0;
>>                  goto restart;
>>              }
>>
>>              if (!zapping) {
>>                  /*
>>                   * Segregate pages to one end of the list where
>>                   * new pages don't get in the way.
>>                   */
>>                  list_move_tail(page, active_mmu_pages)
>>                  batch++; /* or maybe not? */
>>                  moved++;
>>              } else {
>>                  batch += prepare_zap_page
>>                  goto restart;
>>              }
>>      }
>>
>>      /* Need another pass to look at segregated pages?  */
>>      if (moved) {
>>          moved = 0;
>>          goto restart;
>>      }
> Not sure what are you trying to achieve with "moved" tricks. Just
> walking the list from the end and stopping on first valid sp should be
> enough since active_mmu_pages list is a FIFO right now.

Right, I missed that "sp->role.invalid = 1" will ensure anyway that
pages are visited at most twice.

Paolo
