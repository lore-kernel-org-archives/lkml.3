Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaDOW4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:56:13 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:44379 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaDOW4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:56:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFuJayheEHGsNEdgrw12rGz6wb8Q=v5rR5vEo20z68Aq5EA@mail.gmail.com>
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org>
	<1397526163-20126-4-git-send-email-abrestic@chromium.org>
	<CAAVeFuJayheEHGsNEdgrw12rGz6wb8Q=v5rR5vEo20z68Aq5EA@mail.gmail.com>
Date: Tue, 15 Apr 2014 15:56:07 -0700
X-Google-Sender-Auth: R5Ga2JL5OMrKJBSJamoRgfBGX4I
Message-ID: <CAL1qeaHqqGxYNgDvbm-qMofkB51CnKtzQib6tYhDJvxKKd3BuQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] mmc: sdhci: defer probing on regulator_get_optional() failures
From: Andrew Bresticker <abrestic@chromium.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 11:06 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Tue, Apr 15, 2014 at 10:42 AM, Andrew Bresticker
> <abrestic@chromium.org> wrote:
>> If regulator_get_optional() returns EPROBE_DEFER, it indicates
>> that the regulator may show up later (e.g. the DT property is
>> present but the corresponding regulator may not have probed).
>> Instead of continuing without the regulator, return EPROBE_DEFER
>> from sdhci_add_host().  Also, fix regulator leaks in the error
>> paths in sdhci_add_host().
>
> I tried this series and while it seems to fix some MMC errors I was
> seeing on a regular basis, I had to revert this particular patch which
> is causing the following oops at boot on my Venice2 (with 3.15-rc1):
>
> [    2.007916] sdhci-tegra 700b0400.sdhci: Got CD GPIO #170.
> [    2.008197] Unable to handle kernel NULL pointer dereference at
> virtual address 0000003c
> [    2.008202] pgd = c0004000
> [    2.008208] [0000003c] *pgd=00000000
> [    2.008216] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> [    2.008222] Modules linked in:
> [    2.008230] CPU: 1 PID: 79 Comm: irq/362-700b040 Not tainted
> 3.15.0-rc1-00030-g20b0e68aa3b9 #1411
> [    2.008235] task: e61ea680 ti: e5862000 task.ti: e5862000
> [    2.008248] PC is at mmc_gpio_cd_irqt+0xc/0x3c
> [    2.008258] LR is at irq_thread_fn+0x1c/0x40
> [    2.008265] pc : [<c048d740>]    lr : [<c006ae70>]    psr: 60000113
> [    2.008265] sp : e5863f18  ip : 00000000  fp : c006ae54
> [    2.008268] r10: c091e4a4  r9 : e5845340  r8 : e60e31c0
> [    2.008272] r7 : 00000001  r6 : 00000000  r5 : e60e31c0  r4 : e5844800
> [    2.008277] r3 : 00000000  r2 : 00000000  r1 : e5844800  r0 : 0000016a
> [    2.008283] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
> Segment kernel
> [    2.008289] Control: 10c5387d  Table: 8000406a  DAC: 00000015
> [    2.008293] Process irq/362-700b040 (pid: 79, stack limit = 0xe5862240)
> [    2.008298] Stack: (0xe5863f18 to 0xe5864000)
> [    2.008304] 3f00:
>     e5845340 c006ae70
> [    2.008312] 3f20: e5845360 e5862000 00000000 c006b190 c006b058
> e5862030 00000000 c006af9c
> [    2.008319] 3f40: 00000000 e5845300 00000000 e5845340 c006b058
> 00000000 00000000 00000000
> [    2.008326] 3f60: 00000000 c0040ea0 5a5a5a5a 00000000 5a5a5a5a
> e5845340 00000000 00000000
> [    2.008333] 3f80: e5863f80 e5863f80 00000000 00000000 e5863f90
> e5863f90 e5863fac e5845300
> [    2.008340] 3fa0: c0040dc8 00000000 00000000 c000e638 00000000
> 00000000 00000000 00000000
> [    2.008346] 3fc0: 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000
> [    2.008353] 3fe0: 00000000 00000000 00000000 00000000 00000013
> 00000000 00000000 00000000
> [    2.008369] [<c048d740>] (mmc_gpio_cd_irqt) from [<c006ae70>]
> (irq_thread_fn+0x1c/0x40)
> [    2.008382] [<c006ae70>] (irq_thread_fn) from [<c006b190>]
> (irq_thread+0x138/0x170)
> [    2.008393] [<c006b190>] (irq_thread) from [<c0040ea0>] (kthread+0xd8/0xf0)
> [    2.008404] [<c0040ea0>] (kthread) from [<c000e638>]
> (ret_from_fork+0x14/0x3c)
> [    2.008413] Code: eaffffea e92d4010 e1a04001 e591318c (e593303c)
> [    2.008420] ---[ end trace 4e1b9273d6367aac ]---

This is due to the card-detect IRQ firing (which is requested/enabled
by mmc_of_parse()) before sdhci_add_host(), so mmc->ops will be NULL.
It looks like many MMC hosts have this bug.  I suspect we weren't
hitting this before because the bootloader had configured the CD and
power GPIOs for the SD slot, and, when probe was deferred, they got
released as GPIOs.  When we re-probed, they would get re-enabled as
GPIOs and the value on the line may have changed.  Perhaps the CD IRQ
should not get requested by mmc_of_parse() and the host should be
responsible for requesting the IRQ later when it's ready.  Thoughts?
+Adrian, who it looks like has been working on the CD/WP GPIO stuff.

> [    2.008442] Unable to handle kernel paging request at virtual
> address ffffffec
> [    2.008444] pgd = c0004000
> [    2.008456] [ffffffec] *pgd=a77be821, *pte=00000000, *ppte=00000000
> [    2.008461] Internal error: Oops: 17 [#2] PREEMPT SMP ARM
> [    2.008466] Modules linked in:
> [    2.008472] CPU: 1 PID: 79 Comm: irq/362-700b040 Tainted: G      D
>      3.15.0-rc1-00030-g20b0e68aa3b9 #1411
> [    2.008477] task: e61ea680 ti: e5862000 task.ti: e5862000
> [    2.008482] PC is at kthread_data+0x4/0xc
> [    2.008489] LR is at irq_thread_dtor+0x28/0xbc
> [    2.008495] pc : [<c00413d0>]    lr : [<c006afc4>]    psr: 20000113
> [    2.008495] sp : e5863ca8  ip : e5863f84  fp : e61ea680
> [    2.008498] r10: c048d744  r9 : 00000000  r8 : e5862010
> [    2.008502] r7 : e61ea680  r6 : c0982970  r5 : 00000000  r4 : e61ea680
> [    2.008505] r3 : 00000000  r2 : e5863ca8  r1 : e5863f38  r0 : e61ea680
> [    2.008511] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [    2.008515] Control: 10c5387d  Table: 8000406a  DAC: 00000015
> [    2.008520] Process irq/362-700b040 (pid: 79, stack limit = 0xe5862240)
> [    2.008523] Stack: (0xe5863ca8 to 0xe5864000)
> [    2.008530] 3ca0:                   c006af9c e61eab6c 00000000
> c003e560 00000039 0000000b
> [    2.008539] 3cc0: e5863ed0 e5862000 0000000b c002781c e5863ce0
> 00000001 c0980ac4 c0669b70
> [    2.008546] 3ce0: c07e19d0 c0927710 00000002 c0922fc0 e5863ed0
> e5862000 0000000b 00000001
> [    2.008552] 3d00: c048d742 c048d744 c0980ac4 c0011d08 e5862240
> 0000000b 60000113 c07dd458
> [    2.008559] 3d20: e5862010 00000000 00000000 00000008 65862010
> 66666661 20616566 64323965
> [    2.008567] 3d40: 30313034 61316520 30303430 35652031 31333139
> 28206338 33393565 63333033
> [    2.008574] 3d60: c0002029 c0669b70 c08416c8 0000003c 00000005
> 00000000 e5863ed0 0000003c
> [    2.008581] 3d80: e61ea680 c091e4a4 c006ae54 c0669484 00000005
> c001b988 25e6c000 e604bfc0
> [    2.008588] 3da0: c091e478 e604aa00 00000001 e677fc00 00000530
> c0056094 5a5a5a5a a55a5a5a
> [    2.008595] 3dc0: 3a393731 5a003436 5a5a5a5a 5a5a5a5a 0183681b
> 00000000 ffff8bfa e604aa00
> [    2.008602] 3de0: c091ef7c c0913c00 c0913c00 e604aa08 00000001
> 00000002 c091ecfc e677e4a8
> [    2.008609] 3e00: c091e470 00000000 00000000 00000005 c001bc24
> c0923c20 0000003c e5863ed0
> [    2.008616] 3e20: e5845340 c091e4a4 c006ae54 c0008594 e677e4a8
> 00000000 00000000 00000020
> [    2.008623] 3e40: 00000000 00000002 0183681b 00000000 00000001
> 00000000 ffff8bfa c091e478
> [    2.008631] 3e60: e604aa00 e677fc00 ffff8b6e c0056f1c e5863ea4
> c091ef7c 0000077d 00000000
> [    2.008638] 3e80: 77ad1fda 00000000 00000000 c09180c0 c00099f0
> ffffffff 00000000 c0044cd4
> [    2.008645] 3ea0: e6084000 00000002 c0980910 00000000 00000000
> c0044f60 c048d740 60000113
> [    2.008652] 3ec0: ffffffff e5863f04 e60e31c0 c0012418 0000016a
> e5844800 00000000 00000000
> [    2.008659] 3ee0: e5844800 e60e31c0 00000000 00000001 e60e31c0
> e5845340 c091e4a4 c006ae54
> [    2.008666] 3f00: 00000000 e5863f18 c006ae70 c048d740 60000113
> ffffffff e5845340 c006ae70
> [    2.008673] 3f20: e5845360 e5862000 00000000 c006b190 c006b058
> e5862030 00000000 c006af9c
> [    2.008680] 3f40: 00000000 e5845300 00000000 e5845340 c006b058
> 00000000 00000000 00000000
> [    2.008687] 3f60: 00000000 c0040ea0 5a5a5a5a 00000000 5a5a5a5a
> e5845340 00000000 00000000
> [    2.008695] 3f80: e5863f80 e5863f80 00000001 00010001 e5863f90
> e5863f90 e5863fac e5845300
> [    2.008701] 3fa0: c0040dc8 00000000 00000000 c000e638 00000000
> 00000000 00000000 00000000
> [    2.008707] 3fc0: 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000
> [    2.008714] 3fe0: 00000000 00000000 00000000 00000000 00000013
> 00000000 00000000 00000000
> [    2.008725] [<c00413d0>] (kthread_data) from [<c006afc4>]
> (irq_thread_dtor+0x28/0xbc)
> [    2.008740] [<c006afc4>] (irq_thread_dtor) from [<c003e560>]
> (task_work_run+0xb4/0xe4)
> [    2.008754] [<c003e560>] (task_work_run) from [<c002781c>]
> (do_exit+0x2b8/0x8cc)
> [    2.008768] [<c002781c>] (do_exit) from [<c0011d08>] (die+0x400/0x418)
> [    2.008783] [<c0011d08>] (die) from [<c0669484>]
> (__do_kernel_fault.part.11+0x64/0x74)
> [    2.008795] [<c0669484>] (__do_kernel_fault.part.11) from
> [<c001b988>] (do_page_fault+0x1c8/0x3d0)
> [    2.008804] [<c001b988>] (do_page_fault) from [<c0008594>]
> (do_DataAbort+0x38/0x98)
> [    2.008814] [<c0008594>] (do_DataAbort) from [<c0012418>]
> (__dabt_svc+0x38/0x60)
> [    2.008818] Exception stack(0xe5863ed0 to 0xe5863f18)
> [    2.008824] 3ec0:                                     0000016a
> e5844800 00000000 00000000
> [    2.008831] 3ee0: e5844800 e60e31c0 00000000 00000001 e60e31c0
> e5845340 c091e4a4 c006ae54
> [    2.008838] 3f00: 00000000 e5863f18 c006ae70 c048d740 60000113 ffffffff
> [    2.008851] [<c0012418>] (__dabt_svc) from [<c048d740>]
> (mmc_gpio_cd_irqt+0xc/0x3c)
> [    2.008864] [<c048d740>] (mmc_gpio_cd_irqt) from [<c006ae70>]
> (irq_thread_fn+0x1c/0x40)
> [    2.008876] [<c006ae70>] (irq_thread_fn) from [<c006b190>]
> (irq_thread+0x138/0x170)
> [    2.008885] [<c006b190>] (irq_thread) from [<c0040ea0>] (kthread+0xd8/0xf0)
> [    2.008895] [<c0040ea0>] (kthread) from [<c000e638>]
> (ret_from_fork+0x14/0x3c)
> [    2.008903] Code: e513001c e7e00150 e12fff1e e5903374 (e5130014)
> [    2.008907] ---[ end trace 4e1b9273d6367aad ]---
> [    2.008910] Fixing recursive fault but reboot is needed!
