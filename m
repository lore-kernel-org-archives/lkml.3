Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab3HGNUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:20:09 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:33850 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942Ab3HGNUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:20:07 -0400
Message-ID: <52024979.1040201@linux.vnet.ibm.com>
Date: Wed, 07 Aug 2013 21:19:53 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 10/12] KVM: MMU: allow locklessly access shadow page table
 out of vcpu thread
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130807220927.bc16decbc7171f6fa5be8f84@gmail.com>
In-Reply-To: <20130807220927.bc16decbc7171f6fa5be8f84@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080713-5816-0000-0000-000009506C40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 09:09 PM, Takuya Yoshikawa wrote:
> On Tue, 30 Jul 2013 21:02:08 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> @@ -2342,6 +2358,13 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>>  	 */
>>  	kvm_flush_remote_tlbs(kvm);
>>  
>> +	if (kvm->arch.rcu_free_shadow_page) {
>> +		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
>> +		list_del_init(invalid_list);
>> +		call_rcu(&sp->rcu, free_pages_rcu);
>> +		return;
>> +	}
>> +
>>  	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
>>  		WARN_ON(!sp->role.invalid || sp->root_count);
>>  		kvm_mmu_free_page(sp);
> 
> Shouldn't we avoid calling call_rcu() when we are holding mmu_lock?

Using call_rcu() to free pages is a rare case that happen only between
lockless write-protection and zapping shadow pages, so i think we do
not need to care this case too much.

