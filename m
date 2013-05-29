Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966170Ab3E2NTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:19:50 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:44609 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759507Ab3E2NTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:19:49 -0400
Message-ID: <51A6006D.5060601@linux.vnet.ibm.com>
Date: Wed, 29 May 2013 21:19:41 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 10/11] KVM: MMU: collapse TLB flushes when zap all
 pages
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1369252560-11611-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130528003611.GA1958@amt.cnet> <51A4CAED.7060608@linux.vnet.ibm.com> <51A56FF7.2000907@linux.vnet.ibm.com> <20130529123959.GC5931@amt.cnet>
In-Reply-To: <20130529123959.GC5931@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052913-5816-0000-0000-0000082E5541
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 08:39 PM, Marcelo Tosatti wrote:
> On Wed, May 29, 2013 at 11:03:19AM +0800, Xiao Guangrong wrote:
>>>>> the pages since other vcpus may be doing locklessly shadow
>>>>> page walking
>>>
>>> Ah, yes, i agree with you.
>>>
>>> We can introduce a list, say kvm->arch.obsolte_pages, to link all of the
>>> zapped-page, the page-shrink will free the page on that list first.
>>>
>>> Marcelo, if you do not have objection on  patch 1 ~ 8 and 11, could you please
>>> let them merged first, and do add some comments and tlb optimization later?
>>
>> Exclude patch 11 please, since it depends on the "collapse" optimization.
> 
> I'm fine with patch 1 being merged. I think the remaining patches need better
> understanding or explanation. The problems i see are:
> 
> 1) The magic number "10" to zap before considering reschedule is
> annoying. It would be good to understand why it is needed at all.

......

> 
> But then again, the testcase is measuring kvm_mmu_zap_all performance
> alone which we know is not a common operation, so perhaps there is
> no need for that minimum-pages-to-zap-before-reschedule.

Well. Although, this is not the common operation, but this operation
can be triggered by VCPU - it one VCPU take long time on zap-all-pages,
other vcpus is missing IPI-synce, or missing IO. This is easily cause
soft lockups if the vcpu is doing memslot-releated things.

> 
> 2) The problem above (retention of large number of pages while zapping)
> can be fatal, it can lead to OOM and host crash.

This problem is introduced in this patch (patch 10), without this patch,
the pages are always be zapped before release the mmu-lock.

> 
> 3) Make sure that introduction of obsolete pages can not lead to a 
> huge number of shadow pages around (the correct reason you gave for not merging
> https://patchwork.kernel.org/patch/2309641/ is not true anymore
> obsolete pages).

Actually, this question is the same as 2). It also the page-reclaim problem.
Without patch #10, no problem.

> 
> Other than these points, i'm fine with obsolete pages optimization
> to speed up kvm_mmu_zap_all and the rest of the patchset.

Thank you!


