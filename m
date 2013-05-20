Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab3ETJMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:12:52 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:54025 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3ETJMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:12:50 -0400
Message-ID: <5199E907.4010700@linux.vnet.ibm.com>
Date: Mon, 20 May 2013 17:12:39 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 3/7] KVM: MMU: fast invalidate all pages
References: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1368738782-18649-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130519100439.GD4725@redhat.com>
In-Reply-To: <20130519100439.GD4725@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052009-5564-0000-0000-000007FFFC32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2013 06:04 PM, Gleb Natapov wrote:

>> +		/*
>> +		 * Do not repeatedly zap a root page to avoid unnecessary
>> +		 * KVM_REQ_MMU_RELOAD, otherwise we may not be able to
>> +		 * progress:
>> +		 *    vcpu 0                        vcpu 1
>> +		 *                         call vcpu_enter_guest():
>> +		 *                            1): handle KVM_REQ_MMU_RELOAD
>> +		 *                                and require mmu-lock to
>> +		 *                                load mmu
>> +		 * repeat:
>> +		 *    1): zap root page and
>> +		 *        send KVM_REQ_MMU_RELOAD
>> +		 *
>> +		 *    2): if (cond_resched_lock(mmu-lock))
>> +		 *
>> +		 *                            2): hold mmu-lock and load mmu
>> +		 *
>> +		 *                            3): see KVM_REQ_MMU_RELOAD bit
>> +		 *                                on vcpu->requests is set
>> +		 *                                then return 1 to call
>> +		 *                                vcpu_enter_guest() again.
>> +		 *            goto repeat;
>> +		 *
>> +		 */
> I am not sure why the above scenario will prevent us from progressing.
> There is finite number of root pages with invalid generation number, so
> eventually we will zap them all and vcpu1 will stop seeing KVM_REQ_MMU_RELOAD
> request.

This patch does not "zap pages in batch", so kvm_zap_obsolete_pages() can
just zap invalid root pages and lock-break due to the lock contention on the
path of handing KVM_REQ_MMU_RELOAD.

Yes, after "zap pages in batch", this issue does not exist any more. I should
update this into that patch.

> 
> This check here prevent unnecessary KVM_REQ_MMU_RELOAD as you say, but
> this races the question, why don't we check for sp->role.invalid in
> kvm_mmu_prepare_zap_page before calling kvm_reload_remote_mmus()?
> Something like this:
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 40d7b2d..d2ae3a4 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2081,7 +2081,8 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>  		kvm_mod_used_mmu_pages(kvm, -1);
>  	} else {
>  		list_move(&sp->link, &kvm->arch.active_mmu_pages);
> -		kvm_reload_remote_mmus(kvm);
> +		if (!sp->role.invalid)
> +			kvm_reload_remote_mmus(kvm);
>  	}
> 
>  	sp->role.invalid = 1;

Yes, it is better.

> 
> Actually we can add check for is_obsolete_sp() there too since
> kvm_mmu_invalidate_all_pages() already calls kvm_reload_remote_mmus()
> after incrementing mmu_valid_gen.

Yes, I agree.

> 
> Or do I miss something?

No, you are right. ;)

