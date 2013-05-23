Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab3EWHjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:39:03 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:47076 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3EWHjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:39:00 -0400
Message-ID: <519DC789.1080809@linux.vnet.ibm.com>
Date: Thu, 23 May 2013 15:38:49 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com, mtosatti@redhat.com,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 10/11] KVM: MMU: collapse TLB flushes when zap all
 pages
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1369252560-11611-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130523061249.GB26157@redhat.com> <519DB6B1.4070209@linux.vnet.ibm.com> <20130523072451.GD26157@redhat.com> <519DC72B.2070503@linux.vnet.ibm.com>
In-Reply-To: <519DC72B.2070503@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052307-0260-0000-0000-0000030B2CCC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 03:37 PM, Xiao Guangrong wrote:
> On 05/23/2013 03:24 PM, Gleb Natapov wrote:
>> On Thu, May 23, 2013 at 02:26:57PM +0800, Xiao Guangrong wrote:
>>> On 05/23/2013 02:12 PM, Gleb Natapov wrote:
>>>> On Thu, May 23, 2013 at 03:55:59AM +0800, Xiao Guangrong wrote:
>>>>> kvm_zap_obsolete_pages uses lock-break technique to zap pages,
>>>>> it will flush tlb every time when it does lock-break
>>>>>
>>>>> We can reload mmu on all vcpus after updating the generation
>>>>> number so that the obsolete pages are not used on any vcpus,
>>>>> after that we do not need to flush tlb when obsolete pages
>>>>> are zapped
>>>>>
>>>>> Note: kvm_mmu_commit_zap_page is still needed before free
>>>>> the pages since other vcpus may be doing locklessly shadow
>>>>> page walking
>>>>>
>>>> Since obsolete pages are not accessible for lockless page walking after
>>>> reload of all roots I do not understand why additional tlb flush is
>>>
>>> kvm_reload_remote_mmus() forces vcpus to leave guest mode, but if the
>>> vcpu is not running on guest mode, it does nothing except set the request
>>> bit. So, the vcpu can go lockless page walking after kvm_reload_remote_mmus()
>>> return on other vcpu.
>>>
>>> Like this scenario:
>>>
>>> VCPU 0                              VCPU 1
>>>                                  exit when it encounters #PF
>>>
>>> kvm_reload_remote_mmus(){
>>>     set vcpu1->request bit;
>>>
>>>     do not send IPI due to
>>>     vcpu 1 not running on guest mode
>>>
>>>                                  call page-fault handler then go lockless walking !!!
>>>     return
>>> }
>>>
>>>
>>>> needed. Also why tlb flush should prevent lockless-walking from using
>>>> the page? Making page unreachable from root_hpa does that, no?
>>>
>>> lockless-walking disables the interrupt and makes the vcpu state as
>>> READING_SHADOW_PAGE_TABLES, this state is treated as GUEST_MODE,
>>> kvm_flush_remote_tlbs() should send IPI to this vcpu in this case.
>>
>> kvm_flush_remote_tlbs() uses the same make_all_cpus_request() as
>> kvm_reload_remote_mmus() does, so why the same scenario you describe
>> above cannot happen with kvm_flush_remote_tlbs()?
> 
> 
> After call kvm_flush_remote_tlbs(), the page still exists on vcpu->root,

Sorry, should be kvm_reload_remote_mmus() here.

> so we can not protect the page is being used by other vcpu.
> 
> But before call kvm_mmu_commit_zap_page(), the page has been deleted from
> vcpu's page table, after call kvm_flush_remote_tlbs(), we can ensure that
> other vcpus can not find these pages.
> 
> 

