Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3GTTBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 15:01:35 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57258 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab3GTTBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 15:01:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130716170055.GG4402@pd.tnic>
References: <20130709183601.5d567a83@fem.tu-ilmenau.de>
	<20130710073049.GA15525@pd.tnic>
	<20130711230525.40bc6491@fem.tu-ilmenau.de>
	<20130716170055.GG4402@pd.tnic>
Date: Sat, 20 Jul 2013 21:01:33 +0200
Message-ID: <CAPVoSvQuzUQUgRgk6fhsxEhjWS8oPreo00u_urntaCzmERpOtg@mail.gmail.com>
Subject: Re: early microcode on amd is broken when no initramfs provided
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Jacob Shin <jacob.shin@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.w.shin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 7:00 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jul 11, 2013 at 11:05:25PM +0200, Johannes Hirte wrote:
>> config is attached
>
> Ok, I can reproduce the hang with your config but even with:
>
> $ grep MICROCODE .config
> # CONFIG_MICROCODE is not set
> # CONFIG_MICROCODE_INTEL_EARLY is not set
> # CONFIG_MICROCODE_AMD_EARLY is not set
>
> which means, it cannot be microcode-related.
>
> And I'd bet if you wait a minute (yep, it should be exactly 60 seconds)
> the boot would probably continue. And if so, this is that 60 sec delay
> where the kernel tries to find firmware.
>
> Hmm...

I have the same problem: Booting 3.11-rc1 hangs after the line:
ACPI: Executed 3 blocks of module-level executable AML code

I bisected it down to the early microcode changes:
757885e94a22bcc82beb9b1445c95218cb20ceab (the new early loading
implementation) and 6b3389ac21b5e557b957f1497d0ff22bf733e8c3 (small
fixup) completely fail to boot (No output beyond "Booting kernel") ,
from 275bbe2e299f1820ec8faa443d689469a9e6ecc5 ("Make
find_ucode_in_initrd() __init") I'm seeing this hang.

Just turning CONFIG_MICROCODE_EARLY off solves the problem: The system
now sucessfully boots 3.11-rc1.

Trying to debug this I found the following hack to also solve the boot problem:
Removing the following two lines from collect_cpu_info_amd_early()
from arch/x86/kernel/microcode_amd_early.c:
       c->microcode = rev;
        c->x86 = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);

But I can't make sense out of that. And if I try to trace who updates
->x86 it get even more confusing.
Normaly only cpu_detect() seems to update cpuinfo_x86.x86 but now it
seems to fight with collect_cpu_info_amd_early().
On my system this happens:
(Output is always address of the struct cpuinfo_x86 -> value that gets
written into it)

Very early boot:
cpu_detect ffffffff81c8ba40 -> 16

BSP == CPU0 calls load_ucode_ap() via cpu_init():
collect_cpu_info_amd_early ffff880337c10fc0 -> 16
(That is the place I patched out to get the system to boot)

BSP == CPU0 via identify_boot_cpu():
cpu_detect ffffffff81c8ba40 -> 16

BSP == CPU0 stores boot_cpu_data in its per-cpu structure via
smp_store_boot_cpu_info():
smpboot: BSP: store ffffffff81c8ba40 in ffff880337c10fc0

smpboot starts activating the secondary CPUs: Each would in
start_secondary() first call load_ucode_ap() via cpu_init() and then
identidfy_secondary_cpu() via smp_callin():
collect_cpu_info_amd_early ffff880337c50fc0
smpboot: identify_sec_cpu:1/ffff880337c50fc0
cpu_detect ffff880337c50fc0 -> 16

collect_cpu_info_amd_early ffff880337c90fc0
smpboot: identify_sec_cpu:2/ffff880337c90fc0
cpu_detect ffff880337c90fc0 -> 16

collect_cpu_info_amd_early ffff880337cd0fc0
smpboot: identify_sec_cpu:3/ffff880337cd0fc0
cpu_detect ffff880337cd0fc0 -> 16

collect_cpu_info_amd_early ffff880337d10fc0
smpboot: identify_sec_cpu:4/ffff880337d10fc0
cpu_detect ffff880337d10fc0 -> 16

collect_cpu_info_amd_early ffff880337d50fc0
smpboot: identify_sec_cpu:5/ffff880337d50fc0
cpu_detect ffff880337d50fc0 -> 16


It seems the code for updating 'struct cpuinfo_x86 *C' in
collect_cpu_info_amd_early() is useless, because it will be
overwritten first by smp_store_cpu_info() and then again by
identify_secondary_cpu(c) and wrong, because at that point the per-cpu
structure should not be used yet, as smp_store_cpu_info() did not run
yet.
But something else seems to be using the per-cpu structure of the BSP
between its cpu_init() and smp_store_boot_cpu_info().

And its cpu_has_amd_erratum(): It uses cpuinfo_x86.x86 do decide if it
need to fall back to boot_cpu_data, but because
collect_cpu_info_amd_early() has filled that field, but not
.x86_vendor (that is still 0 == X86_VENDOR_INTEL) the erratas are not
applied to the BSP and then something in ACPI gets stuck.

Does this diagnostic make sense / should I send a patch?

Torsten
