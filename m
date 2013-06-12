Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab3FLDh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 23:37:26 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:35070 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab3FLDhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 23:37:24 -0400
MIME-Version: 1.0
In-Reply-To: <1371000607-1787-1-git-send-email-sboyd@codeaurora.org>
References: <1371000607-1787-1-git-send-email-sboyd@codeaurora.org>
Date: Tue, 11 Jun 2013 22:37:23 -0500
Message-ID: <CAL_JsqLJ7ZD9-VR+vgOZZ_q-RD6FCDvKPSNSCjAADxy94SU1Xg@mail.gmail.com>
Subject: Re: [PATCH] ARM: mmu: Add debug_ll_io_init() mappings to early mappings
From: Rob Herring <robherring2@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 8:30 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index e0d8565..04fe160 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -938,8 +938,12 @@ static void __init pci_reserve_io(void)
>  #ifdef CONFIG_DEBUG_LL
>  void __init debug_ll_io_init(void)
>  {
> +       struct vm_struct *vm;
> +       struct static_vm *svm;
>         struct map_desc map;
>
> +       svm = early_alloc_aligned(sizeof(*svm), __alignof__(*svm));
> +
>         debug_ll_addr(&map.pfn, &map.virtual);
>         if (!map.pfn || !map.virtual)
>                 return;
> @@ -948,6 +952,15 @@ void __init debug_ll_io_init(void)
>         map.length = PAGE_SIZE;
>         map.type = MT_DEVICE;
>         create_mapping(&map);
> +
> +       vm = &svm->vm;
> +       vm->addr = (void *)map.virtual;
> +       vm->size = map.length;
> +       vm->phys_addr = __pfn_to_phys(map.pfn);
> +       vm->flags = VM_IOREMAP | VM_ARM_STATIC_MAPPING;
> +       vm->flags |= VM_ARM_MTYPE(map.type);
> +       vm->caller = debug_ll_io_init;
> +       add_static_vm_early(svm);

Can you use vm_reserve_area_early here or perhaps just call
iotable_init instead of create_mapping directly? I don't recall if
there was some reason I didn't do that.

Rob
