Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3H1Hum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 03:50:42 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:51695 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab3H1Huk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 03:50:40 -0400
Message-ID: <521DABC7.5080307@linux.vnet.ibm.com>
Date: Wed, 28 Aug 2013 15:50:31 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 06/12] KVM: MMU: flush tlb if the spte can be locklessly
 modified
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130828072342.GM22899@redhat.com>
In-Reply-To: <20130828072342.GM22899@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082807-5816-0000-0000-0000099D3FE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 03:23 PM, Gleb Natapov wrote:
> On Tue, Jul 30, 2013 at 09:02:04PM +0800, Xiao Guangrong wrote:
>> Relax the tlb flush condition since we will write-protect the spte out of mmu
>> lock. Note lockless write-protection only marks the writable spte to readonly
>> and the spte can be writable only if both SPTE_HOST_WRITEABLE and
>> SPTE_MMU_WRITEABLE are set (that are tested by spte_is_locklessly_modifiable)
>>
>> This patch is used to avoid this kind of race:
>>
>>       VCPU 0                         VCPU 1
>> lockless wirte protection:
>>       set spte.w = 0
>>                                  lock mmu-lock
>>
>>                                  write protection the spte to sync shadow page,
>>                                  see spte.w = 0, then without flush tlb
>>
>> 				 unlock mmu-lock
>>
>>                                  !!! At this point, the shadow page can still be
>>                                      writable due to the corrupt tlb entry
>>      Flush all TLB
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 58283bf..5a40564 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -600,7 +600,8 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
>>  	 * we always atomicly update it, see the comments in
>>  	 * spte_has_volatile_bits().
>>  	 */
>> -	if (is_writable_pte(old_spte) && !is_writable_pte(new_spte))
>> +	if (spte_is_locklessly_modifiable(old_spte) &&
>> +	      !is_writable_pte(new_spte))
>>  		ret = true;
> This will needlessly flush tlbs when dirty login is not in use (common
> case) and old spte is non writable. Can you estimate how serious the
> performance hit is?

If non write-protection caused by dirty log, the spte is always writable
if SPTE_HOST_WRITEABLE and SPTE_MMU_WRITEABLE are set. In other words,
spte_is_locklessly_modifiable(old_spte) is the same as
is_writable_pte(old_spte) in the common case.

There are two cases causing unnecessary TLB flush that are
1) guest read faults on the spte write-protected by dirty log and uses a
   readonly host pfn to fix it.
   This is really rare since read access on the readonly can not trigger
   #PF.

2) guest requires write-protect caused by syncing shadow page.
   this is only needed if ept is disabled and in the most case, the guest
   has many sptes need to be write-protected. Unnecessary TLB flush is rare
   too.

