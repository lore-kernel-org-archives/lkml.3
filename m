Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3JHECn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 00:02:43 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:39938 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3JHECl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 00:02:41 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v2 12/15] KVM: MMU: allow locklessly access shadow page table out of vcpu thread
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20131008012355.GA3588@amt.cnet>
Date: Tue, 8 Oct 2013 12:02:32 +0800
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@redhat.com,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CAD6C3B4-DD55-47EB-9BC0-17867937AE2D@gmail.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1378376958-27252-13-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20131008012355.GA3588@amt.cnet>
To: Marcelo Tosatti <mtosatti@redhat.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Marcelo,

On Oct 8, 2013, at 9:23 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:

>> 
>> +	if (kvm->arch.rcu_free_shadow_page) {
>> +		kvm_mmu_isolate_pages(invalid_list);
>> +		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
>> +		list_del_init(invalid_list);
>> +		call_rcu(&sp->rcu, free_pages_rcu);
>> +		return;
>> +	}
> 
> This is unbounded (there was a similar problem with early fast page fault
> implementations):
> 
> From RCU/checklist.txt:
> 
> "        An especially important property of the synchronize_rcu()
>        primitive is that it automatically self-limits: if grace periods
>        are delayed for whatever reason, then the synchronize_rcu()
>        primitive will correspondingly delay updates.  In contrast,
>        code using call_rcu() should explicitly limit update rate in
>        cases where grace periods are delayed, as failing to do so can
>        result in excessive realtime latencies or even OOM conditions.
> "

I understand what you are worrying about… Hmm, can it be avoided by
just using kvm->arch.rcu_free_shadow_page in a small window? - Then
there are slight chance that the page need to be freed by call_rcu.

> 
> Moreover, freeing pages differently depending on some state should 
> be avoided.
> 
> Alternatives:
> 
> - Disable interrupts at write protect sites.

The write-protection can be triggered by KVM ioctl that is not in the VCPU
context, if we do this, we also need to send IPI to the KVM thread when do
TLB flush. And we can not do much work while interrupt is disabled due to
interrupt latency.

> - Rate limit the number of pages freed via call_rcu
> per grace period.

Seems complex. :(

> - Some better alternative.

Gleb has a idea that uses RCU_DESTORY to protect the shadow page table
and encodes the page-level into the spte (since we need to check if the spte
is the last-spte. ).  How about this?

I planned to do it after this patchset merged, if you like it and if you think
that "using kvm->arch.rcu_free_shadow_page in a small window" can not avoid
the issue, i am happy to do it in the next version. :)

Thanks, Marcelo!


