Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934557Ab3E1PTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:19:20 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:55366 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934476Ab3E1PTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:19:19 -0400
Message-ID: <51A4CAED.7060608@linux.vnet.ibm.com>
Date: Tue, 28 May 2013 23:19:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 10/11] KVM: MMU: collapse TLB flushes when zap all
 pages
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1369252560-11611-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130528003611.GA1958@amt.cnet>
In-Reply-To: <20130528003611.GA1958@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052815-5490-0000-0000-0000038ADD76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 08:36 AM, Marcelo Tosatti wrote:
> On Thu, May 23, 2013 at 03:55:59AM +0800, Xiao Guangrong wrote:
>> kvm_zap_obsolete_pages uses lock-break technique to zap pages,
>> it will flush tlb every time when it does lock-break
>>
>> We can reload mmu on all vcpus after updating the generation
>> number so that the obsolete pages are not used on any vcpus,
>> after that we do not need to flush tlb when obsolete pages
>> are zapped
> 
> After that point batching is also not relevant anymore?

no... without batching, we do not know how much time we will
spend to zap pages. It is not good for the case that
zap_all_pages is called in the vcpu context.

> 
> 
> Still concerned about a similar case mentioned earlier:
> 
> "
> Note the account for pages freed step after pages are actually
> freed: as discussed with Takuya, having pages freed and freed page
> accounting out of sync across mmu_lock is potentially problematic:
> kvm->arch.n_used_mmu_pages and friends do not reflect reality which can
> cause problems for SLAB freeing and page allocation throttling.
> "
> 
> This is a real problem, if you decrease n_used_mmu_pages at
> kvm_mmu_prepare_zap_page, but only actually free pages later 
> at kvm_mmu_commit_zap_page, there is the possibility of allowing
> a huge number to be retained. There should be a maximum number of pages
> at invalid_list.
> 
> (even higher possibility if you schedule without freeing pages reported
> as released!).
> 
>> Note: kvm_mmu_commit_zap_page is still needed before free
>> the pages since other vcpus may be doing locklessly shadow
>> page walking

Ah, yes, i agree with you.

We can introduce a list, say kvm->arch.obsolte_pages, to link all of the
zapped-page, the page-shrink will free the page on that list first.

Marcelo, if you do not have objection on  patch 1 ~ 8 and 11, could you please
let them merged first, and do add some comments and tlb optimization later?


