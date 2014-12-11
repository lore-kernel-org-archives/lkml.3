Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497AbaLKR5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:57:07 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:49534 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991AbaLKR5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:57:05 -0500
MIME-Version: 1.0
In-Reply-To: <5489AB40.2010609@linux.intel.com>
References: <20141205084147.313026156@linutronix.de>
	<tip-e9220e591375af6d02604c261999df570fba744f@git.kernel.org>
	<CAE9FiQU=Q8paxTJpqN8GFGYeq6u-E=VBtyQSVzVNYnJGEybtqw@mail.gmail.com>
	<5489AB40.2010609@linux.intel.com>
Date: Thu, 11 Dec 2014 09:57:04 -0800
X-Google-Sender-Auth: uL8MlSkiA08MiuegLHmMpOgR7r4
Message-ID: <CAE9FiQVPGfcXOFx448ABV4zGcq70nvE4pEE4PzaWZMNj+9rHtA@mail.gmail.com>
Subject: Re: [tip:x86/apic] iommu/vt-d: Move iommu preparatory allocations to irq_remap_ops.prepare
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 6:33 AM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> On 2014/12/11 15:35, Yinghai Lu wrote:
>> On Fri, Dec 5, 2014 at 3:26 PM, tip-bot for Thomas Gleixner
>> <tipbot@zytor.com> wrote:
>>> Commit-ID:  e9220e591375af6d02604c261999df570fba744f
>>> Gitweb:     http://git.kernel.org/tip/e9220e591375af6d02604c261999df570fba744f
>>> Author:     Thomas Gleixner <tglx@linutronix.de>
>>> AuthorDate: Fri, 5 Dec 2014 08:48:32 +0000
>>> Committer:  Thomas Gleixner <tglx@linutronix.de>
>>> CommitDate: Sat, 6 Dec 2014 00:19:25 +0100
>>>
>>> iommu/vt-d: Move iommu preparatory allocations to irq_remap_ops.prepare
>>>
>>> The whole iommu setup for irq remapping is a convoluted mess. The
>>> iommu detect function gets called from mem_init() and the prepare
>>> callback gets called from enable_IR_x2apic() for unknown reasons.
>>
>> Got
>>
> Hi Yinghai,
>         From following log messages, it seems that the AHCI controllers
> allocates 16 MSI/MSI-X interrupt, and triggers NULL pointer reference
> when enabling interrupts for AHCI.
>         It doesn't trigger panic with this code path (allocate/enable
> MSI/MSI-X interrupts with IR enabled) on my test system. So could you
> please help to get more info with the attached test patch?

[  113.486917] calling  ahci_pci_driver_init+0x0/0x1b @ 1
[  113.487299] ahci 0000:00:1f.2: version 3.0
[  113.507317] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[  113.507713] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3
Gbps 0x3f impl SATA mode
[  113.527019] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led
clo pio slum part ccc ems sxs
[  113.583977] iommu: chip_data ffff881022b97740, iommu
ffff88103d80ae00, index 32, subindex 0, ir_table ffff88103d802af0,
table_base ffff881026c00000, queue ffff88102770c000
[  113.597261] iommu: chip_data ffff881022b97780, iommu
(null), index 0, subindex 0, ir_table           (null), table_base
      (null), queue           (null)
[  113.617124] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000118
[  113.636983] IP: [<ffffffff81eacca0>] modify_irte+0x40/0xd0
[  113.637253] PGD 0
[  113.656978] Oops: 0000 [#1] SMP
[  113.657133] Modules linked in:
[  113.657322] CPU: 0 PID: 2531 Comm: kworker/0:1 Tainted: G        W
[  113.696953] Workqueue: events work_for_cpu_fn
[  113.697189] task: ffff881025535240 ti: ffff881025528000 task.ti:
ffff881025528000
[  113.716965] RIP: 0010:[<ffffffff81eacca0>]  [<ffffffff81eacca0>]
modify_irte+0x40/0xd0
