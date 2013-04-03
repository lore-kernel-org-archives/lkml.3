Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721Ab3DCHMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:12:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58067 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762698Ab3DCHMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:12:33 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <515BD638.8070307@jp.fujitsu.com>
Date: Wed, 03 Apr 2013 16:11:52 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: joro@8bytes.org
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, kexec@lists.infradead.org
Subject: Re: [PATCH] intel-iommu: Synchronize gcmd value with global command
 register
References: <1363829556-2128-1-git-send-email-indou.takao@jp.fujitsu.com> <20130326144629.GB2727@8bytes.org> <51527D74.9080209@jp.fujitsu.com> <20130327103122.GK30540@8bytes.org> <51591EEE.60401@jp.fujitsu.com> <20130402140546.GA15687@8bytes.org>
In-Reply-To: <20130402140546.GA15687@8bytes.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/02 23:05), Joerg Roedel wrote:
> On Mon, Apr 01, 2013 at 02:45:18PM +0900, Takao Indoh wrote:
>> <Current flow on kdump boot>
>> enable_IR
>>    intel_enable_irq_remapping
>>      iommu_disable_irq_remapping  <== IRES/QIES/TES disabled here
>>      dmar_disable_qi              <== do nothing
>>      dmar_enable_qi               <== QIES enabled
>>      intel_setup_irq_remapping    <== IRES enabled
> 
> But what we want to do here in the kdumo case is to disable translation
> too, right? Because the former kernel might have translation and
> irq-remapping enabled and the kdump kernel might be compiled without
> support for dma-remapping. So if we don't disable translation here too
> the kdump kernel is unable to do DMA.

Yeah, you are right. I forgot such a case.

To be honest, I also expected the side effect of this patch. As I wrote
in the previous mail, I'm working on kdump problem with iommu, that is,
ongoing DMA causes DMAR fault in 2nd kernel and sometimes kdump fails
due to this fault. What we have to do is stopping DMA transaction
before DMA-remapping is disabled in 2nd kernel. To do this, we need to
reset devices before intel_enable_irq_remapping() is called, but it is
very difficult because struct pci_dev is not prepared in this stage.
After applying this patch, DMA-remapping is disabled in init_dmars where
struct pci_dev is ready, so it's easier to handle. For example we can
add pci quirk to reset devices.

So, disabling translation in 2nd kernel is necessary, and it's better if
we can do it after struct pci_dev is prepared. (after subsys_initcall?)
Any idea?

Thanks,
Takao Indoh

> 
> I agree that disabling translation should be a bit more explicit instead
> of the current code.
> 
> 
> 	Joerg
> 

