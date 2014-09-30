Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaI3OLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:11:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50124 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaI3OLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:11:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140930134525.GA20166@wfg-t540p.sh.intel.com>
References: <20140930134525.GA20166@wfg-t540p.sh.intel.com>
Date: Tue, 30 Sep 2014 16:11:15 +0200
Message-ID: <CABPqkBR6hLZbP9ysWkkutb7cogFbiXCM09gbfNJ8JVgM5w4R-w@mail.gmail.com>
Subject: Re: [perf/x86/intel/uncore] WARNING: CPU: 3 PID: 1 at
 arch/x86/mm/ioremap.c:183 __ioremap_caller+0x24c/0x2d0()
From: Stephane Eranian <eranian@google.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 30, 2014 at 3:45 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> Hi Stephane,
>
> FYI, we noticed the below WARNING on
>
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit 521e8bac67a71a6544274f39d5c61473e0e54ac0 ("perf/x86/intel/uncore: Update support for client uncore IMC PMU")
>
> +-------------------------+------------+------------+
> |                         | b10fc1c3e3 | 521e8bac67 |
> +-------------------------+------------+------------+
> | boot_successes          | 10         | 1          |
> | boot_failures           | 0          | 9          |
> | BUG:kernel_test_crashed | 0          | 9          |
> +-------------------------+------------+------------+
>
>
> [    6.773342] software IO TLB [mem 0xa5015000-0xa9015000] (64MB) mapped at [ffff8800a5015000-ffff8800a9014fff]
> [    6.784010] resource sanity check: requesting [mem 0xfed10000-0xfed15fff], which spans more than reserved [mem 0xfed10000-0xfed13fff]
> [    6.784951] ------------[ cut here ]------------
> [    6.785331] WARNING: CPU: 3 PID: 1 at arch/x86/mm/ioremap.c:183 __ioremap_caller+0x24c/0x2d0()
> [    6.786149] Info: mapping multiple BARs. Your kernel is fine.


This is the typical problem noted in the past. There is a BIOS problem
with the way the size of the IMC BAR is reported.
I copied Bjorn here. He will be more able to explain the problem to you.

> [    6.786601] Modules linked in:
> [    6.787046] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc6-wl-ath-00314-g3ec2e1e #1
> [    6.787755] Hardware name: Intel Corporation 2012 Client Platform/LosLunas CRB, BIOS ACRVMBY1.86C.0054.B00.1107311147 07/31/2011
> [    6.788670]  0000000000000009 ffff880437e0bb00 ffffffff818571f9 ffff880437e0bb48
> [    6.789551]  ffff880437e0bb38 ffffffff8106ef1d ffffc900018d0000 0000000000006000
> [    6.790349]  ffffc900018d0000 ffffc900018d0000 00000000fed10000 ffff880437e0bb98
> [    6.791228] Call Trace:
> [    6.791552]  [<ffffffff818571f9>] dump_stack+0x4d/0x66
> [    6.791961]  [<ffffffff8106ef1d>] warn_slowpath_common+0x7d/0xa0
> [    6.792413]  [<ffffffff8106ef8c>] warn_slowpath_fmt+0x4c/0x50
> [    6.792939]  [<ffffffff8107544f>] ? iomem_map_sanity_check+0xcf/0xe0
> [    6.793425]  [<ffffffff8105b82c>] __ioremap_caller+0x24c/0x2d0
> [    6.793955]  [<ffffffff8105b8c7>] ioremap_nocache+0x17/0x20
> [    6.794394]  [<ffffffff8103504d>] snb_uncore_imc_init_box+0x6d/0x90
> [    6.794951]  [<ffffffff8103341c>] uncore_pci_probe+0xcc/0x1f0
> [    6.795388]  [<ffffffff8142e8b5>] local_pci_probe+0x45/0xa0
> [    6.795902]  [<ffffffff8142fba5>] ? pci_match_device+0xe5/0x110
> [    6.796352]  [<ffffffff8142fce1>] pci_device_probe+0xd1/0x120
> [    6.796864]  [<ffffffff815024c0>] driver_probe_device+0x90/0x3e0
> [    6.797327]  [<ffffffff815028db>] __driver_attach+0x8b/0x90
> [    6.797839]  [<ffffffff81502850>] ? __device_attach+0x40/0x40
> [    6.798287]  [<ffffffff8150038b>] bus_for_each_dev+0x6b/0xb0
> [    6.798796]  [<ffffffff81501f6e>] driver_attach+0x1e/0x20
> [    6.799222]  [<ffffffff81501b60>] bus_add_driver+0x180/0x250
> [    6.799730]  [<ffffffff81df6e52>] ? uncore_cpu_setup+0x13/0x13
> [    6.800184]  [<ffffffff815030a4>] driver_register+0x64/0xf0
> [    6.800698]  [<ffffffff8142e14c>] __pci_register_driver+0x4c/0x50
> [    6.801161]  [<ffffffff81df6f19>] intel_uncore_init+0xc7/0x2ae
> [    6.801691]  [<ffffffff81df6e52>] ? uncore_cpu_setup+0x13/0x13
> [    6.802142]  [<ffffffff81002130>] do_one_initcall+0xc0/0x1f0
> [    6.802650]  [<ffffffff8108d900>] ? parse_args+0x1c0/0x4e0
> [    6.803075]  [<ffffffff81dea11b>] kernel_init_freeable+0x1b3/0x23b
> [    6.803628]  [<ffffffff8184a930>] ? rest_init+0x90/0x90
> [    6.804034]  [<ffffffff8184a93e>] kernel_init+0xe/0xf0
> [    6.804433]  [<ffffffff8185fe3c>] ret_from_fork+0x7c/0xb0
> [    6.804928]  [<ffffffff8184a930>] ? rest_init+0x90/0x90
> [    6.805336] ---[ end trace 31a6fa76e4d9f116 ]---
> [    6.808747] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
>
> Thanks,
> Fengguang
>
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
>
