Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbaJCWoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:44:32 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:46359 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbaJCWoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:44:25 -0400
Date: Fri, 3 Oct 2014 15:44:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fengguang Wu <fengguang.wu@intel.com>
cc: Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [perf/x86/intel] WARNING: CPU: 48 PID: 7540 at
 arch/x86/kernel/cpu/perf_event_intel_ds.c:316
 reserve_ds_buffers+0x208/0x430()
In-Reply-To: <20141003132657.GB32634@wfg-t540p.sh.intel.com>
Message-ID: <alpine.DEB.2.02.1410031542440.15421@chino.kir.corp.google.com>
References: <20141003132657.GB32634@wfg-t540p.sh.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2014, Fengguang Wu wrote:

> Hi David,
> 
> FYI, we noticed the below changes on commit
> 
> 4485154138f6ffa5b252cb490aba3e8eb30124e4 ("perf/x86/intel: Avoid spamming kernel log for BTS buffer failure")
> 
> +---------------------------------------------------------------------------+------------+------------+
> |                                                                           | 338b522ca4 | 4485154138 |
> +---------------------------------------------------------------------------+------------+------------+
> | boot_successes                                                            | 3          | 5          |
> | boot_failures                                                             | 21         | 15         |
> | page_allocation_failure:order:,mode                                       | 11         |            |
> | backtrace:reserve_ds_buffers                                              | 11         | 5          |
> | backtrace:x86_pmu_event_init                                              | 11         | 5          |
> | backtrace:perf_init_event                                                 | 11         | 5          |
> | backtrace:SYSC_perf_event_open                                            | 11         | 5          |
> | backtrace:SyS_perf_event_open                                             | 11         | 5          |
> | BUG:kernel_test_crashed                                                   | 10         | 10         |
> | WARNING:at_arch/x86/kernel/cpu/perf_event_intel_ds.c:reserve_ds_buffers() | 0          | 5          |
> +---------------------------------------------------------------------------+------------+------------+
> 
> 
> 2014-10-03 01:27:35 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-60 -E --prealloc --readonly --random 17179869184
> 2014-10-03 01:27:36 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-62 -E --prealloc --readonly --random 17179869184
> [  192.496567] ------------[ cut here ]------------
> [  192.505045] WARNING: CPU: 48 PID: 7540 at arch/x86/kernel/cpu/perf_event_intel_ds.c:316 reserve_ds_buffers+0x208/0x430()
> [  192.524168] alloc_bts_buffer: BTS buffer allocation failure
> [  192.533339] Modules linked in: loop ipmi_watchdog nfsd auth_rpcgss dm_mod fuse sg sd_mod crct10dif_generic sr_mod crc_t10dif cdrom crct10dif_common ata_generic pata_acpi mgag200 syscopyarea snd_pcm sysfillrect sysimgblt snd_timer ttm snd drm_kms_helper soundcore ata_piix pcspkr i7core_edac drm libata megaraid_sas i2c_i801 edac_core ipmi_si ipmi_msghandler acpi_cpufreq
> [  192.581450] CPU: 48 PID: 7540 Comm: perf Not tainted 3.16.0-rc2-00011-g4485154 #1
> [  192.592393] Hardware name: Quanta MP Server/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.0028.090220101116 09/02/2010
> [  192.606455]  0000000000000009 ffff88005de53ce8 ffffffff81844e55 ffff88005de53d30
> [  192.618370]  ffff88005de53d20 ffffffff8106de6d 0000000000000000 0000000000010528
> [  192.630786]  0000000000000000 0000000000000000 0000000000000000 ffff88005de53d80
> [  192.642465] Call Trace:
> [  192.647913]  [<ffffffff81844e55>] dump_stack+0x4d/0x66
> [  192.656643]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
> [  192.666961]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
> [  192.677047]  [<ffffffff81030863>] ? reserve_ds_buffers+0x2b3/0x430
> [  192.687420]  [<ffffffff810307b8>] reserve_ds_buffers+0x208/0x430
> [  192.697838]  [<ffffffff8118abec>] ? handle_mm_fault+0x8ac/0xf70
> [  192.707522]  [<ffffffff8102a354>] x86_pmu_event_init+0x434/0x450
> [  192.717351]  [<ffffffff8115241b>] perf_init_event+0xdb/0x140
> [  192.727292]  [<ffffffff81152808>] perf_event_alloc+0x388/0x440
> [  192.738117]  [<ffffffff81152c60>] SYSC_perf_event_open+0x3a0/0xd20
> [  192.750511]  [<ffffffff81153979>] SyS_perf_event_open+0x9/0x10
> [  192.761657]  [<ffffffff8184da29>] system_call_fastpath+0x16/0x1b
> [  192.771904] ---[ end trace 6d601571820ebee0 ]---

Thanks for the report.

This is the intended behavior.  Before commit 4485154138f6 
("perf/x86/intel: Avoid spamming kernel log for BTS buffer failure") this 
would result in page allocation failure warnings everytime the kzalloc() 
failed.  The patch turns this into a WARN_ON_ONCE() to only print it once 
to avoid spamming the kernel log, it just has a different format than page 
allocation failure warnings.
