Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbaKUCtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:49:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:27156 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779AbaKUCtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:49:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,427,1413270000"; 
   d="scan'208";a="611562825"
Message-ID: <546EA823.8030401@linux.intel.com>
Date: Fri, 21 Nov 2014 10:49:07 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqdomain: Fix NULL pointer dererence in irq_domain_free_irqs_parent
References: <1416531745-24661-1-git-send-email-suravee.suthikulpanit@amd.com> <alpine.DEB.2.11.1411210219370.6439@nanos> <546E9E8E.5000303@amd.com>
In-Reply-To: <546E9E8E.5000303@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/11/21 10:08, Suravee Suthikulpanit wrote:
> On 11/20/2014 07:32 PM, Thomas Gleixner wrote:
>> On Thu, 20 Nov 2014, suravee.suthikulpanit@amd.com wrote:
>>> This patch checks if the parent domain is NULL before recursively
>>> freeing
>>> irqs in the parent domains.
>>
>> Which is nonsense, because if the thing has not been allocated in the
>> first place, then it cannot explode in the free path magically, except
>> there is a missing check in the allocation path error handling.
>>
>> And that's obviously not the case simply because this originates from:
>>> [<fffffe0000449278>] pci_disable_msix+0x40/0x50
>>
> 
> Thomas,
> 
> In this case, I have the following irq domain hierarchy:
> 
> [GIC] -- [GICv2m] -- [MSI]
> 
> which recursively calling the freeing function:
> 
> In GIC domain, it currently defines the struct irq_domain_ops.free() with :
>   --> irq_domain_free_irqs_top()
>     |--> irq_domain_free_irqs_common()
>       |--> irq_domain_free_irq_parent()
>         |--> irq_domain_free_irqs_recursive()
> 
> and there is no check before passing the NULL domain->parent into the
> irq_domain_free_irqs_recursive(), which causes the error.
> 
> Since the GIC is the top most domain, it does not have parent domain.
> So, I'm not sure what is missing from the allocation path error
> handling, as you mentioned.
Hi Thomas,
	We have had a discussion about this issue in another thread.
Originally irq_domain_free_irqs_common() is designed to be used by
irqdomains with parent. But there are desires to reuse it to support
irqdomains without parent too for code reduction.
So I suggest to change irq_domain_free_irqs_common() instead of
irq_domain_free_irqs_parent() because caller of
irq_domain_free_irqs_parent() should guarantee current domain do have
a parent.
I'm preparing a patch for this:)
Regards!
Gerry
> 
> Thanks,
> 
> Suravee
