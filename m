Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaLSF0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 00:26:43 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:59125 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaLSF0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 00:26:41 -0500
MIME-Version: 1.0
In-Reply-To: <1418964455.26403.21.camel@intel.com>
References: <1418964455.26403.21.camel@intel.com>
Date: Fri, 19 Dec 2014 10:56:40 +0530
X-Google-Sender-Auth: tZEBgHpn5UbbSOfu0jo9lywPBTk
Message-ID: <CAOh2x=mJoFhZj==YCD4dhhUaSDeRBZFP7ntQR7epTRWZ6D4Pxg@mail.gmail.com>
Subject: Re: [LKP] [cpufreq] BUG: sleeping function called from invalid
 context at mm/slub.c:1241
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 10:17 AM, Huang Ying <ying.huang@intel.com> wrote:
> FYI, we noticed the below changes on
>
> https://git.linaro.org/people/vireshk/linux cpufreq/stats/cleanups
> commit 2136fa84639adcc0727e968f99ad222c8146810c ("cpufreq: stats: Fix locking")
>
>
> +----------------------+------------+------------+
> |                      | 0063f8602b | 2136fa8463 |
> +----------------------+------------+------------+
> | boot_successes       | 9          | 9          |
> | boot_failures        | 1          | 1          |
> | BUG:kernel_boot_hang | 1          | 1          |
> +----------------------+------------+------------+
>
>
> [   24.295182] Freeing unused kernel memory: 1972K (ffff880001a13000 - ffff880001c00000)
> [   24.304471] Freeing unused kernel memory: 1780K (ffff880002043000 - ffff880002200000)
> [   24.704332] acpi-cpufreq: overriding BIOS provided _PSD data
> [   24.716589] BUG: sleeping function called from invalid context at mm/slub.c:1241
> [   24.726087] in_atomic(): 1, irqs_disabled(): 0, pid: 2393, name: modprobe
> [   24.726092] CPU: 21 PID: 2393 Comm: modprobe Not tainted 3.18.0-g0a0a28c #1
> [   24.726093] Hardware name: Supermicro H8DGU/H8DGU, BIOS 2.0        09/08/11
> [   24.726097]  00000000000004d9 ffff8810071a3ae8 ffffffff81a02d59 000000000f340f34
> [   24.726099]  ffffffff81effec4 ffff8810071a3af8 ffffffff8110adca ffff8810071a3b28
> [   24.726101]  ffffffff8110ae7d 0000000000000000 00000000000080d0 ffff88040f803b00
> [   24.726102] Call Trace:
> [   24.726111]  [<ffffffff81a02d59>] dump_stack+0x4c/0x65
> [   24.726117]  [<ffffffff8110adca>] ___might_sleep+0x10e/0x110
> [   24.726119]  [<ffffffff8110ae7d>] __might_sleep+0xb1/0xb9
> [   24.726123]  [<ffffffff811ea2af>] kmem_cache_alloc_trace+0x48/0x1e6
> [   24.726128]  [<ffffffff818a25df>] ? __cpufreq_stats_create_table+0x68/0x194
> [   24.726131]  [<ffffffff818a25df>] __cpufreq_stats_create_table+0x68/0x194
> [   24.726138]  [<ffffffff818a27b6>] cpufreq_stat_notifier_policy+0x1b/0x32
> [   24.726141]  [<ffffffff81105a7d>] notifier_call_chain+0x6d/0x95
> [   24.726143]  [<ffffffff81105d20>] __blocking_notifier_call_chain+0x4a/0x63
> [   24.726145]  [<ffffffff81105d4d>] blocking_notifier_call_chain+0x14/0x16
> [   24.726148]  [<ffffffff818a181e>] __cpufreq_add_dev+0x71d/0x8ce
> [   24.726150]  [<ffffffff818a1a3c>] cpufreq_add_dev+0xe/0x10
> [   24.726154]  [<ffffffff8155dd93>] subsys_interface_register+0xb8/0xdf
> [   24.726157]  [<ffffffff818a0792>] cpufreq_register_driver+0x156/0x268
> [   24.726159]  [<ffffffffa009f000>] ? 0xffffffffa009f000
> [   24.726163]  [<ffffffffa009f220>] acpi_cpufreq_init+0x220/0x1000 [acpi_cpufreq]
> [   24.726165]  [<ffffffffa009f000>] ? 0xffffffffa009f000
> [   24.726168]  [<ffffffff8100032a>] do_one_initcall+0xfd/0x18f
> [   24.726172]  [<ffffffff811d4383>] ? __vunmap+0xac/0xb7
> [   24.726176]  [<ffffffff81150cd3>] load_module+0x1a35/0x1ff7
> [   24.726179]  [<ffffffff81205653>] ? kernel_read+0x48/0x5f
> [   24.726183]  [<ffffffff811513ef>] SyS_finit_module+0x85/0x92
> [   24.726187]  [<ffffffff81a0a1e9>] system_call_fastpath+0x12/0x17
> [   25.539283] microcode: CPU0: patch_level=0x06000613
> [   25.544884] microcode: CPU1: patch_level=0x06000613
> [   25.550137] microcode: CPU2: patch_level=0x06000613

Okay, thanks Huang..

The problem is that we are trying to allocate memory from within spinlock's
critical region..

Fixed by replacing spinlock with a mutex. Pushed my branch again.
