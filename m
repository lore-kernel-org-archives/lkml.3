Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781Ab3FSMoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:44:08 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:53601 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566Ab3FSMoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:44:05 -0400
Message-ID: <51C1A78D.9050709@linux.vnet.ibm.com>
Date: Wed, 19 Jun 2013 20:43:57 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/7] KVM: MMU: document write_flooding_count
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1371632965-20077-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <51C19CD2.3080608@redhat.com>
In-Reply-To: <51C19CD2.3080608@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061912-0260-0000-0000-0000032F2CC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 07:58 PM, Paolo Bonzini wrote:
> Il 19/06/2013 11:09, Xiao Guangrong ha scritto:
>> Document write_flooding_count to Documentation/virtual/kvm/mmu.txt
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  Documentation/virtual/kvm/mmu.txt | 8 ++++++++
>>  arch/x86/include/asm/kvm_host.h   | 5 +++++
>>  2 files changed, 13 insertions(+)
>>
>> diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
>> index ce6df51..5a6b2e2 100644
>> --- a/Documentation/virtual/kvm/mmu.txt
>> +++ b/Documentation/virtual/kvm/mmu.txt
>> @@ -214,6 +214,14 @@ Shadow pages contain the following information:
>>      It is only used on 32bit host which helps us to detect whether updating the
>>      64bit spte is complete so that we can avoid reading the truncated value out
>>      of mmu-lock.
>> +  write_flooding_count:
>> +    In order to sync the page table between guest and host, the page sometimes
>> +    needs to be write-protected (see "Synchronized and unsynchronized pages"
>> +    below), any write to the page can cause write emulation. If the emulation
>> +    on the page is too frequent we'd better unmap the page to avoid the
>> +    future emulation. write_flooding_count aims at this optimization which is
>> +    increased when the page needs to be write emulated and cleared when the
>> +    page is actually used.
> 
>     A guest may write to a page table many times, causing a lot of
>     emulations if the page needs to be write-protected (see "Synchronized
>     and unsynchronized pages" below).  Leaf pages can be unsynchronized
>     so that they do not trigger frequent emulation, but this is not
>     possible for non-leafs.  This field counts the number of emulations
>     since the last time the page table was actually used; if emulation
>     is triggered too frequently on this page, KVM will unmap the page
>     to avoid emulation in the future.

very nice.

> 
>>  Reverse map
>>  ===========
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 1dac2c1..5eb5382 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -234,6 +234,11 @@ struct kvm_mmu_page {
>>  	int clear_spte_count;
>>  #endif
>>  
>> +	/*
>> +	 * Increased when the page needs to be write emulated, cleared
>> +	 * when the page is actually used as page table to avoid frequent
>> +	 * emulation on the page.
>> +	 */
> 
>         /* Number of writes since the last time traversal visited this page.  */
> 
> wdyt, better or worse?

I think it is better. :)

Thanks for your refining.

