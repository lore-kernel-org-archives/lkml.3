Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3HGEG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 00:06:59 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42134 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3HGEG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 00:06:57 -0400
Message-ID: <5201C7D9.20004@linux.vnet.ibm.com>
Date: Wed, 07 Aug 2013 12:06:49 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 04/12] KVM: MMU: log dirty page after marking spte writable
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130807014828.GA4781@amt.cnet>
In-Reply-To: <20130807014828.GA4781@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080703-9574-0000-0000-000009117351
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 09:48 AM, Marcelo Tosatti wrote:
> On Tue, Jul 30, 2013 at 09:02:02PM +0800, Xiao Guangrong wrote:
>> Make sure we can see the writable spte before the dirt bitmap is visible
>>
>> We do this is for kvm_vm_ioctl_get_dirty_log() write-protects the spte based
>> on the dirty bitmap, we should ensure the writable spte can be found in rmap
>> before the dirty bitmap is visible. Otherwise, we cleared the dirty bitmap and
>> failed to write-protect the page
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Can you explain why this is safe, with regard to the rule 
> at edde99ce05290e50 ?

BTW, this log fixed this case:

     VCPU 0                KVM migration control

                           write-protects all pages
#Pf happen then the page
become writable, set dirty
bit on the bitmap

                          swap the bitmap, current bitmap is empty

write the page (no dirty log)

                          stop the guest and push
                          the remaining dirty pages
Stopped
                          See current bitmap is empty that means
                          no page is dirty.
> 
> "The rule is that all pages are either dirty in the current bitmap,
> or write-protected, which is violated here."

Actually, this rule is not complete true, there's the 3th case:
the window between write guest page and set dirty bitmap is valid.
In that window, page is write-free and not dirty logged.

This case is based on the fact that at the final step of live migration,
kvm should stop the guest and push the remaining dirty pages to the
destination.

They're some examples in the current code:
example 1, in fast_pf_fix_direct_spte():
	if (cmpxchg64(sptep, spte, spte | PT_WRITABLE_MASK) == spte)
		/* The window in here... */
		mark_page_dirty(vcpu->kvm, gfn);

example 2, in kvm_write_guest_page():
	r = __copy_to_user((void __user *)addr + offset, data, len);
	if (r)
		return -EFAULT;
	/*
	 * The window is here, the page is dirty but not logged in
         * The bitmap.
	 */
	mark_page_dirty(kvm, gfn);
	return 0;

> 
> Overall, please document what is the required order of operations for
> both set_spte and get_dirty_log and why this order is safe (right on top
> of the code).

Okay.

The order we required here is, we should 1) set spte to writable __before__
set the dirty bitmap and 2) add the spte into rmap __before__ set the dirty
bitmap.

The point 1) is the same as fast_pf_fix_direct_spte(), which i explained above.
The point 1) and 2) can ensure we can find the spte on rmap and see the spte is
writable when we do lockless write-protection, otherwise these cases will happen

VCPU 0					kvm ioctl doing get-dirty-pages

mark_page_dirty(gfn) which
set the gfn on the dirty maps
                                      mask = xchg(dirty_bitmap, 0)

                                      walk all gfns which set on "mask" and
                                      locklessly write-protect the gfn,
                                      then walk rmap, see no spte on that rmap
	

add the spte into rmap

!!!!!! Then the page can be freely wrote but not recorded in the dirty bitmap.

Or:

VCPU 0					kvm ioctl doing get-dirty-pages

mark_page_dirty(gfn) which
set the gfn on the dirty maps

add spte into rmap
                                      mask = xchg(dirty_bitmap, 0)

                                      walk all gfns which set on "mask" and
                                      locklessly write-protect the gfn,
                                      then walk rmap, see spte is on the ramp
                                      but it is readonly or nonpresent.
	
Mark spte writable

!!!!!! Then the page can be freely wrote but not recorded in the dirty bitmap.

Hopefully, i have clarified it, if you have any questions, please let me know.

> 
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 35d4b50..0fe56ad 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -2486,12 +2486,12 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>>  		}
>>  	}
>>  
>> -	if (pte_access & ACC_WRITE_MASK)
>> -		mark_page_dirty(vcpu->kvm, gfn);
>> -
>>  set_pte:
>>  	if (mmu_spte_update(sptep, spte))
>>  		kvm_flush_remote_tlbs(vcpu->kvm);
> 
> Here, there is a modified guest page without dirty log bit set (think
> another vcpu writing to the page via this spte).

This is okay since we call mark_page_dirty(vcpu->kvm, gfn) after that, this
is the same case as fast_pf_fix_direct_spte() and i have explained why it is
safe above.



