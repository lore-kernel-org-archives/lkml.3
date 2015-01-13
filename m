Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbbAMP6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:58:42 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42157 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbbAMP6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:58:39 -0500
Message-ID: <54B540A8.1020804@hitachi.com>
Date: Wed, 14 Jan 2015 00:58:32 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: linux@arm.linux.org.uk, mingo@redhat.com, x86@kernel.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net, ananth@in.ibm.com,
        dave.long@linaro.org, tixy@linaro.org, lizefan@huawei.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 00/11] Early kprobe: enable kprobes at very early
References: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/07 16:34), Wang Nan wrote:
> This patch series shows early kprobe, a mechanism allows users to track
> events at very early. It should be useful for optimization of system
> booting. This can also be used by BSP developers to hook their platform
> specific procedures at kernel booting stages after setup_arch().

Good work!! :)

> This patch series provides X86 and ARM support for early kprobes. The ARM
> portion is based on my OPTPROBES for ARM 32 patches (ARM: kprobes: OPTPROBES
> and other improvements), which have not been accepted yet.
> 
> Kprobes is very useful for tracking events. However, it can only be used
> after system fully initialized. When debugging kernel booting stage, for
> example, checking memory consumption during booting, analyzing boot
> phase processes creation and optimization of booting speed, specific
> tools must be created. Sometimes we have to modify kernel code.
> 
> Early kprobes is my idea on it. By utilizing OPTPROBES which converts probed
> instructions into branches instead of breakpoints, kprobe can be used even
> before setup of exception handlers. By adding cmdline options, one can insert
> kprobes to track kernel booting stage without code modification. 

Hmm, for arm32, this strategy is good. but on x86, not so many instructions
can be optimized. I doubt that we really need to use it before initializing
exception handlers. Since any exception can be happen on early point, we
need to initialize it on very early stage.

> BSP developers can also benefit from it. For example, when booting an
> SoC equipped with unstoppable watchdog like IMP706, wathdog writting
> code must be inserted into different places to avoid watchdog resetting
> system before watchdogd is pulled up (especially during memory
> initialization, which is the most time-consuming portion of booting).
> With early kprobe, BSP developers are able to put such code at their
> private directory without disturbing arch-independent code.
> 
> In this patch series, early kprobes simply print messagees when the
> probed instructions are hit. My futher plan is to connect 'ekprobe='
> cmdline parameters to '/sys/kernel/debug/tracing/kprobe_events', allows
> installing kprobe events from kernel cmdline, and dump early kprobe
> messages into ring buffer without print them out.

Yeah, I really need this early-ftrace (event-trace) feature to
trace booting kernel, even without kprobe events.

> Patch 1 - 4 are architecture dependent code, allow text modification
> before kprobes_initialized is setup, and alloc resources statically from
> vmlinux.lds. Currently only x86 and ARM are supported.
> 
> Patch 5 - 8 define required flags and macros.
> 
> Patch 9 is the core logic of early kprobes. When register_kprobe() is
> called before kprobes_initialized, it marks the probed kprobes as
> 'KPROBE_FLAG_EARLY' and allocs resources from slots which is reserved
> during linking. After kprobe is fully initialized, it converts early
> kprobes to normal kprobes.
> 
> Patch 10 enables cmdline option 'ekprobe=', allows setup probe at
> cmdline. However, currently the kprobe handler is only a simple printk.
> 
> Patch 11 introduces required Kconfig options to actually enable early
> kprobes.

BTW, did you ensure all patches in the series are "bisect-clean" ?
It seems some early patches in the series depend on later patches.

> 
> Usage of early kprobe is as follow:
> 
> Booting kernel with cmdline 'ekprobe=', like:
> 
> ... rdinit=/sbin/init ekprobe=0xc00f3c2c ekprobe=__free_pages ...
> 
> During boot, kernel will print trace using printk:
> 
>  ...
>  Hit early kprobe at __alloc_pages_nodemask+0x4
>  Hit early kprobe at __free_pages+0x0
>  Hit early kprobe at __alloc_pages_nodemask+0x4
>  Hit early kprobe at __free_pages+0x0
>  Hit early kprobe at __free_pages+0x0
>  Hit early kprobe at __alloc_pages_nodemask+0x4
>  ...
> 
> After fully initialized, early kprobes will be converted to normal
> kprobes, and can be turned-off using:

I think it should be just removed automatically instead of converting.

Thank you!

> 
>  echo 0 > /sys/kernel/debug/kprobes/enabled
> 
> And reenabled using:
> 
>  echo 1 > /sys/kernel/debug/kprobes/enabled
> 
> Also, optimization can be turned off using:
> 
>  echo 0 > /proc/sys/debug/kprobes-optimization
> 
> There's no way to remove specific early kprobe now. I'd like to convert
> early kprobes into kprobe events in futher patches, and then they can be
> totally removed through event interface.
> 
> Wang Nan (11):
>   ARM: kprobes: directly modify code if kprobe is not initialized.
>   ARM: kprobes: introduce early kprobes related code area.
>   x86: kprobes: directly modify code if kprobe is not initialized.
>   x86: kprobes: introduce early kprobes related code area.
>   kprobes: Add an KPROBE_FLAG_EARLY for early kprobe.
>   kprobes: makes kprobes_initialized globally visable.
>   kprobes: introduces macros for allocing early kprobe resources.
>   kprobes: allows __alloc_insn_slot() from early kprobes slots.
>   kprobes: core logic of eraly kprobes.
>   kprobes: enable 'ekprobe=' cmdline option for early kprobes.
>   kprobes: add CONFIG_EARLY_KPROBES option.
> 
>  arch/Kconfig                      |  12 ++
>  arch/arm/include/asm/kprobes.h    |  29 ++++-
>  arch/arm/kernel/vmlinux.lds.S     |   2 +
>  arch/arm/probes/kprobes/opt-arm.c |  11 +-
>  arch/x86/include/asm/insn.h       |   7 +-
>  arch/x86/include/asm/kprobes.h    |  44 +++++--
>  arch/x86/kernel/kprobes/opt.c     |   7 +-
>  arch/x86/kernel/vmlinux.lds.S     |   2 +
>  include/linux/kprobes.h           | 109 ++++++++++++++++++
>  kernel/kprobes.c                  | 237 ++++++++++++++++++++++++++++++++++++--
>  10 files changed, 437 insertions(+), 23 deletions(-)
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


