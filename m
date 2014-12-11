Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbaLKUah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:30:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:59858 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaLKUag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:30:36 -0500
Date: Thu, 11 Dec 2014 21:30:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:x86/apic] iommu/vt-d: Move iommu preparatory allocations
 to irq_remap_ops.prepare
In-Reply-To: <CAE9FiQVPGfcXOFx448ABV4zGcq70nvE4pEE4PzaWZMNj+9rHtA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412112106440.13233@nanos>
References: <20141205084147.313026156@linutronix.de> <tip-e9220e591375af6d02604c261999df570fba744f@git.kernel.org> <CAE9FiQU=Q8paxTJpqN8GFGYeq6u-E=VBtyQSVzVNYnJGEybtqw@mail.gmail.com> <5489AB40.2010609@linux.intel.com>
 <CAE9FiQVPGfcXOFx448ABV4zGcq70nvE4pEE4PzaWZMNj+9rHtA@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014, Yinghai Lu wrote:
> On Thu, Dec 11, 2014 at 6:33 AM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> > On 2014/12/11 15:35, Yinghai Lu wrote:
> >> On Fri, Dec 5, 2014 at 3:26 PM, tip-bot for Thomas Gleixner
> >> <tipbot@zytor.com> wrote:
> >>> Commit-ID:  e9220e591375af6d02604c261999df570fba744f
> >>> Gitweb:     http://git.kernel.org/tip/e9220e591375af6d02604c261999df570fba744f
> >>> Author:     Thomas Gleixner <tglx@linutronix.de>
> >>> AuthorDate: Fri, 5 Dec 2014 08:48:32 +0000
> >>> Committer:  Thomas Gleixner <tglx@linutronix.de>
> >>> CommitDate: Sat, 6 Dec 2014 00:19:25 +0100
> >>>
> >>> iommu/vt-d: Move iommu preparatory allocations to irq_remap_ops.prepare
> >>>
> >>> The whole iommu setup for irq remapping is a convoluted mess. The
> >>> iommu detect function gets called from mem_init() and the prepare
> >>> callback gets called from enable_IR_x2apic() for unknown reasons.
> >>
> >> Got
> >>
> > Hi Yinghai,
> >         From following log messages, it seems that the AHCI controllers
> > allocates 16 MSI/MSI-X interrupt, and triggers NULL pointer reference
> > when enabling interrupts for AHCI.
> >         It doesn't trigger panic with this code path (allocate/enable
> > MSI/MSI-X interrupts with IR enabled) on my test system. So could you
> > please help to get more info with the attached test patch?
> 
> [  113.486917] calling  ahci_pci_driver_init+0x0/0x1b @ 1
> [  113.487299] ahci 0000:00:1f.2: version 3.0
> [  113.507317] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
> [  113.507713] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3
> Gbps 0x3f impl SATA mode
> [  113.527019] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led
> clo pio slum part ccc ems sxs
> [  113.583977] iommu: chip_data ffff881022b97740, iommu
> ffff88103d80ae00, index 32, subindex 0, ir_table ffff88103d802af0,
> table_base ffff881026c00000, queue ffff88102770c000
> [  113.597261] iommu: chip_data ffff881022b97780, iommu
> (null), index 0, subindex 0, ir_table           (null), table_base
>       (null), queue           (null)

So irq_2_iommu is empty. That's a multi MSI, and that's the second
interrupt which gets enabled.

The patch below should fix it.

Thanks,

	tglx

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index ff35b0336d2b..46da573a4746 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -1131,7 +1131,7 @@ static int intel_irq_remapping_alloc(struct irq_domain *domain,
 {
 	struct intel_iommu *iommu = domain->host_data;
 	struct irq_alloc_info *info = arg;
-	struct intel_ir_data *data;
+	struct intel_ir_data *data, *ird;
 	struct irq_data *irq_data;
 	struct irq_cfg *irq_cfg;
 	int i, ret, index;
@@ -1176,14 +1176,20 @@ static int intel_irq_remapping_alloc(struct irq_domain *domain,
 		}
 
 		if (i > 0) {
-			data = kzalloc(sizeof(*data), GFP_KERNEL);
-			if (!data)
+			ird = kzalloc(sizeof(*data), GFP_KERNEL);
+			if (!ird)
 				goto out_free_data;
+			/* Initialize the common data */
+			ird->irq_2_iommu = data->irq_2_iommu;
+			ird->irq_2_iommu.sub_handle = i;
+		} else {
+			ird = data;
 		}
+
 		irq_data->hwirq = (index << 16) + i;
-		irq_data->chip_data = data;
+		irq_data->chip_data = ird;
 		irq_data->chip = &intel_ir_chip;
-		intel_irq_remapping_prepare_irte(data, irq_cfg, info, index, i);
+		intel_irq_remapping_prepare_irte(ird, irq_cfg, info, index, i);
 		irq_set_status_flags(virq + i, IRQ_MOVE_PCNTXT);
 	}
 	return 0;


