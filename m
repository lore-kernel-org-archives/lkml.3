Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab3JCGaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:30:07 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33616 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab3JCGaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:30:04 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v2 03/15] KVM: MMU: lazily drop large spte
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20130930223957.GA3262@amt.cnet>
Date: Thu, 3 Oct 2013 14:29:51 +0800
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@redhat.com,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D6EACCBB-237A-485B-8128-B25545A59EB0@gmail.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1378376958-27252-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130930223957.GA3262@amt.cnet>
To: Marcelo Tosatti <mtosatti@redhat.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 1, 2013, at 6:39 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:

> On Thu, Sep 05, 2013 at 06:29:06PM +0800, Xiao Guangrong wrote:
>> Currently, kvm zaps the large spte if write-protected is needed, the later
>> read can fault on that spte. Actually, we can make the large spte readonly
>> instead of making them un-present, the page fault caused by read access can
>> be avoided
>> 
>> The idea is from Avi:
>> | As I mentioned before, write-protecting a large spte is a good idea,
>> | since it moves some work from protect-time to fault-time, so it reduces
>> | jitter.  This removes the need for the return value.
>> 
>> This version has fixed the issue reported in 6b73a9606, the reason of that
>> issue is that fast_page_fault() directly sets the readonly large spte to
>> writable but only dirty the first page into the dirty-bitmap that means
>> other pages are missed. Fixed it by only the normal sptes (on the
>> PT_PAGE_TABLE_LEVEL level) can be fast fixed
>> 
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>> arch/x86/kvm/mmu.c | 36 ++++++++++++++++++++----------------
>> arch/x86/kvm/x86.c |  8 ++++++--
>> 2 files changed, 26 insertions(+), 18 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 869f1db..88107ee 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1177,8 +1177,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
>> 
>> /*
>>  * Write-protect on the specified @sptep, @pt_protect indicates whether
>> - * spte writ-protection is caused by protecting shadow page table.
>> - * @flush indicates whether tlb need be flushed.
>> + * spte write-protection is caused by protecting shadow page table.
>>  *
>>  * Note: write protection is difference between drity logging and spte
>>  * protection:
>> @@ -1187,10 +1186,9 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
>>  * - for spte protection, the spte can be writable only after unsync-ing
>>  *   shadow page.
>>  *
>> - * Return true if the spte is dropped.
>> + * Return true if tlb need be flushed.
>>  */
>> -static bool
>> -spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
>> +static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool pt_protect)
>> {
>> 	u64 spte = *sptep;
>> 
>> @@ -1200,17 +1198,11 @@ spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
>> 
>> 	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
>> 
>> -	if (__drop_large_spte(kvm, sptep)) {
>> -		*flush |= true;
>> -		return true;
>> -	}
>> -
>> 	if (pt_protect)
>> 		spte &= ~SPTE_MMU_WRITEABLE;
>> 	spte = spte & ~PT_WRITABLE_MASK;
>> 
>> -	*flush |= mmu_spte_update(sptep, spte);
>> -	return false;
>> +	return mmu_spte_update(sptep, spte);
>> }
> 
> Is it necessary for kvm_mmu_unprotect_page to search for an entire range large 
> page range now, instead of a 4k page?

It is unnecessary. kvm_mmu_unprotect_page is used to delete the gfn's shadow pages
then vcpu will try to re-fault. If any gfn in the large range has shadow page, it will stop using large
mapping, so that the mapping will be split to small mappings when vcpu re-fault again.


