Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab3DDFsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 01:48:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57801 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3DDFso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 01:48:44 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <515D1429.40707@jp.fujitsu.com>
Date: Thu, 04 Apr 2013 14:48:25 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: dwmw2@infradead.org
CC: joro@8bytes.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org
Subject: Re: [PATCH] intel-iommu: Synchronize gcmd value with global command
 register
References: <1363829556-2128-1-git-send-email-indou.takao@jp.fujitsu.com>  <20130326144629.GB2727@8bytes.org> <51527D74.9080209@jp.fujitsu.com>  <20130327103122.GK30540@8bytes.org> <51591EEE.60401@jp.fujitsu.com>  <20130402140546.GA15687@8bytes.org> <515BD638.8070307@jp.fujitsu.com> <1364977479.28127.15.camel@i7.infradead.org>
In-Reply-To: <1364977479.28127.15.camel@i7.infradead.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/03 17:24), David Woodhouse wrote:
> On Wed, 2013-04-03 at 16:11 +0900, Takao Indoh wrote:
>> (2013/04/02 23:05), Joerg Roedel wrote:
>>> On Mon, Apr 01, 2013 at 02:45:18PM +0900, Takao Indoh wrote:
>>>> <Current flow on kdump boot>
>>>> enable_IR
>>>>     intel_enable_irq_remapping
>>>>       iommu_disable_irq_remapping  <== IRES/QIES/TES disabled here
>>>>       dmar_disable_qi              <== do nothing
>>>>       dmar_enable_qi               <== QIES enabled
>>>>       intel_setup_irq_remapping    <== IRES enabled
>>>
>>> But what we want to do here in the kdumo case is to disable translation
>>> too, right? Because the former kernel might have translation and
>>> irq-remapping enabled and the kdump kernel might be compiled without
>>> support for dma-remapping. So if we don't disable translation here too
>>> the kdump kernel is unable to do DMA.
>>
>> Yeah, you are right. I forgot such a case.
> 
> If you disable translation and there's some device still doing DMA, it's
> going to scribble over random areas of memory. You really want to have
> translation enabled and all the page tables *cleared*, during kexec. I
> think it's fair to insist that the secondary kernel should use the IOMMU
> if the first one did.
> 
>> To be honest, I also expected the side effect of this patch. As I wrote
>> in the previous mail, I'm working on kdump problem with iommu, that is,
>> ongoing DMA causes DMAR fault in 2nd kernel and sometimes kdump fails
>> due to this fault.
> 
> Here you've lost me. The DMAR fault is caught and reported, and how does
> this lead to a kdump failure? Are you using dodgy hardware that just
> keeps *trying* after an abort, and floods the system with a storm of
> DMAR faults? We've occasionally spoken about working around such a
> problem by setting a bit to make subsequent faults *silent*. Would that
> work?

There are several cases.
- DMAR fault messages floods and second kernel does not boot. Recently I
  saw similar report. https://lkml.org/lkml/2013/3/8/120
- igb driver detectes error on linkup and kdump via network fails.
- On a certain platform, though kdump itself works, PCIe error like
  Unexpected Completion is detected and it gets hardware degraded.

Thanks,
Takao Indoh


> 
>>   What we have to do is stopping DMA transaction
>> before DMA-remapping is disabled in 2nd kernel.
> 
> The IOMMU is there to stop DMA transactions. That is its *job*. :)
> 


