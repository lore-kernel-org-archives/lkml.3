Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaLOPab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:30:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:35288 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaLOPa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:30:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="498951349"
Message-ID: <548EFE88.3000307@linux.intel.com>
Date: Mon, 15 Dec 2014 23:30:16 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/5] Fix Intel IRQ remapping initialization order
References: <1418656404-28575-1-git-send-email-joro@8bytes.org>
In-Reply-To: <1418656404-28575-1-git-send-email-joro@8bytes.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/15 23:13, Joerg Roedel wrote:
> Hi,
> 
> here is a patch-set against tip/x86/apic to fix an initialization order
> problem with the IRQ remapping code.  The problem is in the ordering of
> the irq_remapping_prepare and irq_remapping_supported functions.
> 
> Currently the call-order is irq_remapping_prepare ->
> irq_remapping_supported, so that 'prepare' can succeed but 'supported'
> fails, so that interrupt remapping gets initialized but not enabled.
> This causes a broken interrupt setup on affected systems (machines with
> an Intel IOMMU without, or broken, IRQ remapping support). The result
> are lost interrupts and a non-bootable system.
> 
> Both functions do checks whether IRQ remapping can be enabled on the
> machine.  The reason for this is that some checks rely on
> dmar_table_init() and thus have to be done in irq_remapping_prepare().
> 
> This patch-set moves all these checks into the irq_remapping_prepare()
> path with the right ordering and removes the irq_remapping_supported()
> function and its call-backs. This fixes the initializion order problem
> and simplifies the exported API from the IOMMU code.
> 
> Please review.
Hi Joerg,
	I have posted a patch set for the same purpose at:
https://lkml.org/lkml/2014/12/10/20
	Seems we need to combine these two patch sets:)
Regards!
Gerry


> 
> Thanks,
> 
> 	Joerg
> 
> Joerg Roedel (5):
>   iommu/vt-d: Allocate IRQ remapping data structures only for all IOMMUs
>   iommu/vt-d: Don't check for ecap_ir_support in
>     intel_irq_remapping_supported
>   iommu/vt-d: Move supported-checks to intel_prepare_irq_remapping()
>   iommu/amd: Check for irq-remap support amd_iommu_prepare()
>   iommu, x86, apic: Remove irq_remapping_supported()
> 
>  arch/x86/kernel/apic/apic.c         |  5 ---
>  drivers/iommu/amd_iommu.c           |  1 -
>  drivers/iommu/amd_iommu_init.c      |  8 ++---
>  drivers/iommu/amd_iommu_proto.h     |  1 -
>  drivers/iommu/intel_irq_remapping.c | 62 +++++++++++++++++--------------------
>  drivers/iommu/irq_remapping.c       | 11 -------
>  drivers/iommu/irq_remapping.h       |  3 --
>  7 files changed, 31 insertions(+), 60 deletions(-)
> 
