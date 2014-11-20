Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbaKTPCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:02:12 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34867 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaKTPCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:02:10 -0500
Date: Thu, 20 Nov 2014 15:02:01 +0000
From: Steve Capper <steve.capper@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        William Cohen <wcohen@redhat.com>, davem@davemloft.net
Subject: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
Message-ID: <20141120135851.GA32528@linaro.org>
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416292375-29560-1-git-send-email-dave.long@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 01:32:50AM -0500, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> This patchset is heavily based on Sandeepa Prabhu's ARM v8 kprobes patches, first
> seen in October 2013.  This version attempts to address concerns raised by
> reviewers and also fixes problems discovered during testing, particularly during
> SMP testing.
> 
> This patchset adds support for kernel probes(kprobes), jump probes(jprobes)
> and return probes(kretprobes) support for ARM64.
> 
> Kprobes mechanism makes use of software breakpoint and single stepping
> support available in the ARM v8 kernel.
> 
> Changes since v2 include:
> 
> 1) Removal of NOP padding in kprobe XOL slots.  Slots are now exactly one
> instruction long.
> 2) Disabling of interrupts during execution in single-step mode.
> 3) Fixing of numerous problems in instruction simulation code.
> 4) Support for the HAVE_REGS_AND_STACK_ACCESS_API feature is added, to allow
> access to kprobes through debugfs.
> 5) kprobes is *not* enabled in defconfig.
> 6) Numerous complaints from checkpatch have been cleaned up, although a couple
> remain as removing the function pointer typedefs results in ugly code.

Hi David,
I've been playing with this on a Juno board.
I ran into one crash, which I'm not yet sure is an issue, but thought I
would flag it.

I opted to put a kprobe on memcpy, this is an assembler function so I
located it via:
$ nm ./vmlinux | grep \ memcpy$
fffffe0000408a00 T memcpy

Then placed a probe as follows:
echo "p:memcpy 0xfffffe0000408a00 %x2" > /sys/kernel/debug/tracing/kprobe_events

I was able to cat out the /sys/kernel/debug/tracing/trace_pipe file and
activate the probe via:
echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable

Everything worked well, and I got the expected output.

I then tried to record events with perf via:
perf record -e kprobes:memcpy -a sleep 5

Then I got an, easily reproducible, panic (pasted below).

The point of failure in the panic was:
fs/buffer.c:1257

static inline void check_irqs_on(void)
{
#ifdef irqs_disabled
        BUG_ON(irqs_disabled());
#endif
}

I will do some more digging; but I have managed to code up an ftrace
static probe on memcpy and record that using perf on arm64 without
issue.

Cheers,
-- 
Steve


The panic I got:
Kernel panic - not syncing: BUG!
CPU: 2 PID: 2065 Comm: perf Not tainted 3.18.0-rc5+ #2085
Call trace:
[<fffffe0000096d60>] dump_backtrace+0x0/0x138
[<fffffe0000096eb4>] show_stack+0x1c/0x28
[<fffffe000063109c>] dump_stack+0x74/0x94
[<fffffe000062f618>] panic+0xec/0x230
[<fffffe000021abdc>] __find_get_block+0x164/0x184	<--- fs/buffer.c:1257
[<fffffe000021b644>] __getblk_gfp+0x34/0x70
[<fffffe000027afe4>] ext4_getblk+0x84/0x200
[<fffffe0000284d38>] ext4_find_entry+0x2a8/0x4ac
[<fffffe0000284f8c>] ext4_lookup+0x50/0x170
[<fffffe00001ef780>] lookup_real+0x3c/0x7c
[<fffffe00001f0294>] __lookup_hash+0x50/0x6c
[<fffffe00001f2544>] lookup_slow+0x48/0xfc
[<fffffe00001f290c>] link_path_walk+0x314/0x8fc
[<fffffe00001f4d3c>] path_openat+0x94/0x63c
[<fffffe00001f60bc>] do_filp_open+0x3c/0xa8
[<fffffe00001eb8d4>] do_open_exec+0x2c/0x10c
[<fffffe00001ed5e4>] do_execve+0x194/0x514
[<fffffe00001edbac>] SyS_execve+0x30/0x44
CPU1: stopping
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.18.0-rc5+ #2085
Call trace:
[<fffffe0000096d60>] dump_backtrace+0x0/0x138
[<fffffe0000096eb4>] show_stack+0x1c/0x28
[<fffffe000063109c>] dump_stack+0x74/0x94
[<fffffe000009ba68>] handle_IPI+0x1e4/0x1fc
[<fffffe0000090328>] gic_handle_irq+0x80/0x88
Exception stack(0xfffffe094046be20 to 0xfffffe094046bf40)
be20: 00000001 00000000 00000e12 00000000 4046bf60 fffffe09 00094168 fffffe00
be40: 00000000 00000000 00000000 00000000 7fe60bcc fffffe09 00000000 01000000
be60: 000000dc 00000000 40590000 fffffe09 c86433fb 001c6b77 ffffc9db 00000000
be80: 404175a0 fffffe09 4046bd80 fffffe09 000003ff 00000000 7ebb0020 fffffe00
bea0: ffffffd0 ffffff80 d88957c0 000003ff ffffffd0 ffffff80 92046590 000003ff
bec0: 001e6cd0 fffffe00 924ef810 000003ff d8895570 000003ff 00000001 00000000
bee0: 00000e12 00000000 40468000 fffffe09 00a20c98 fffffe00 00a221c0 fffffe00
bf00: 009fb000 fffffe00 00666678 fffffe00 009f9cf1 fffffe00 007f2bf0 fffffe00
bf20: 00000001 00000000 4046bf60 fffffe09 00094164 fffffe00 4046bf60 fffffe09
[<fffffe0000092ce4>] el1_irq+0x64/0xc0
[<fffffe00000eedb0>] cpu_startup_entry+0x17c/0x1dc
[<fffffe000009b478>] secondary_start_kernel+0x11c/0x12c
CPU3: stopping
CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.18.0-rc5+ #2085
Call trace:
[<fffffe0000096d60>] dump_backtrace+0x0/0x138
[<fffffe0000096eb4>] show_stack+0x1c/0x28
[<fffffe000063109c>] dump_stack+0x74/0x94
[<fffffe000009ba68>] handle_IPI+0x1e4/0x1fc
[<fffffe0000090328>] gic_handle_irq+0x80/0x88
Exception stack(0xfffffe0940473e20 to 0xfffffe0940473f40)
3e20: 00000003 00000000 00000e12 00000000 40473f60 fffffe09 00094168 fffffe00
3e40: 00000000 00000000 00000000 00000000 7fea0bcc fffffe09 00000000 01000000
3e60: 00000000 00000000 41023e58 fffffe09 41023e58 fffffe09 7fea12e8 fffffe09
3e80: 40418c20 fffffe09 40473d80 fffffe09 000003ff 00000000 00667ff0 fffffe00
3ea0: 82f76000 000003ff 0041b230 00000000 0041b248 00000000 b4c583d5 000e8b8e
3ec0: 0010a6e0 fffffe00 82ece204 000003ff 0000000d 00000000 00000003 00000000
3ee0: 00000e12 00000000 40470000 fffffe09 00a20c98 fffffe00 00a221c0 fffffe00
3f00: 009fb000 fffffe00 00666678 fffffe00 009f9cf1 fffffe00 007f2bf0 fffffe00
3f20: 00000001 00000000 40473f60 fffffe09 00094164 fffffe00 40473f60 fffffe09
[<fffffe0000092ce4>] el1_irq+0x64/0xc0
[<fffffe00000eedb0>] cpu_startup_entry+0x17c/0x1dc
[<fffffe000009b478>] secondary_start_kernel+0x11c/0x12c
CPU5: stopping
CPU: 5 PID: 0 Comm: swapper/5 Not tainted 3.18.0-rc5+ #2085
Call trace:
[<fffffe0000096d60>] dump_backtrace+0x0/0x138
[<fffffe0000096eb4>] show_stack+0x1c/0x28
[<fffffe000063109c>] dump_stack+0x74/0x94
[<fffffe000009ba68>] handle_IPI+0x1e4/0x1fc
[<fffffe0000090328>] gic_handle_irq+0x80/0x88
Exception stack(0xfffffe094047be20 to 0xfffffe094047bf40)
be20: 00000005 00000000 00000e12 00000000 4047bf60 fffffe09 00094168 fffffe00
be40: 00000000 00000000 00000000 00000000 7fee0bcc fffffe09 00000000 01000000
be60: 00000020 00000000 0ccccccd 00000000 4184f3c5 0015dcf7 00000000 00000000
be80: 4041a2a0 fffffe09 4047bd80 fffffe09 000003ff 00000000 00667ff0 fffffe00
bea0: 001c43f0 fffffdff 001c4188 fffffdff 00000000 00000000 b2d46590 000003ff
bec0: 000ba99c fffffe00 b2b56050 000003ff fb2c5b90 000003ff 00000005 00000000
bee0: 00000e12 00000000 40478000 fffffe09 00a20c98 fffffe00 00a221c0 fffffe00
bf00: 009fb000 fffffe00 00666678 fffffe00 009f9cf1 fffffe00 007f2bf0 fffffe00
bf20: 00000001 00000000 4047bf60 fffffe09 00094164 fffffe00 4047bf60 fffffe09
[<fffffe0000092ce4>] el1_irq+0x64/0xc0
[<fffffe00000eedb0>] cpu_startup_entry+0x17c/0x1dc
[<fffffe000009b478>] secondary_start_kernel+0x11c/0x12c
CPU4: stopping
CPU: 4 PID: 0 Comm: swapper/4 Not tainted 3.18.0-rc5+ #2085
Call trace:
[<fffffe0000096d60>] dump_backtrace+0x0/0x138
[<fffffe0000096eb4>] show_stack+0x1c/0x28
[<fffffe000063109c>] dump_stack+0x74/0x94
[<fffffe000009ba68>] handle_IPI+0x1e4/0x1fc
[<fffffe0000090328>] gic_handle_irq+0x80/0x88
Exception stack(0xfffffe0940477e20 to 0xfffffe0940477f40)
7e20: 00000004 00000000 00000e12 00000000 40477f60 fffffe09 00094168 fffffe00
7e40: 00000000 00000000 00000000 00000000 7fec0bcc fffffe09 00000000 01000000
7e60: 00000000 00000000 7fec11a8 fffffe09 41013e58 fffffe09 7fec12e8 fffffe09
7e80: 40419760 fffffe09 40477d80 fffffe09 000003ff 00000000 00667ff0 fffffe00
7ea0: 009f3f90 fffffe00 001c4380 fffffdff 6577200a 676f6c62 7ec86590 000003ff
7ec0: 000ba99c fffffe00 7ea96050 000003ff f5b27140 000003ff 00000004 00000000
7ee0: 00000e12 00000000 40474000 fffffe09 00a20c98 fffffe00 00a221c0 fffffe00
7f00: 009fb000 fffffe00 00666678 fffffe00 009f9cf1 fffffe00 007f2bf0 fffffe00
7f20: 00000001 00000000 40477f60 fffffe09 00094164 fffffe00 40477f60 fffffe09
[<fffffe0000092ce4>] el1_irq+0x64/0xc0
[<fffffe00000eedb0>] cpu_startup_entry+0x17c/0x1dc
[<fffffe000009b478>] secondary_start_kernel+0x11c/0x12c
CPU0: stopping
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc5+ #2085
Call trace:
[<fffffe0000096d60>] dump_backtrace+0x0/0x138
[<fffffe0000096eb4>] show_stack+0x1c/0x28
[<fffffe000063109c>] dump_stack+0x74/0x94
[<fffffe000009ba68>] handle_IPI+0x1e4/0x1fc
[<fffffe0000090328>] gic_handle_irq+0x80/0x88
Exception stack(0xfffffe0000953de0 to 0xfffffe0000953f00)
3de0: 00a60000 fffffe00 00000000 00000000 00953f20 fffffe00 00094168 fffffe00
3e00: 00000000 00000000 00000000 00000000 7fe40bcc fffffe09 00000000 01000000
3e20: 0099a140 fffffe00 00000018 00000000 4184f3c5 0015dcf7 ffffc9d0 00000000
3e40: 00986e80 fffffe00 00953d40 fffffe00 d8895820 000003ff d8895820 000003ff
3e60: 005573f8 00000000 00000000 00000000 00000000 00000000 92046590 000003ff
3e80: 001710a8 fffffe00 91fc5180 000003ff d8895470 000003ff 00a60000 fffffe00
3ea0: 00000000 00000000 00950000 fffffe00 00a20c98 fffffe00 00a221c0 fffffe00
3ec0: 009fb000 fffffe00 00666678 fffffe00 009f9cf1 fffffe00 007f2bf0 fffffe00
3ee0: 00000001 00000000 00953f20 fffffe00 00094164 fffffe00 00953f20 fffffe00
[<fffffe0000092ce4>] el1_irq+0x64/0xc0
[<fffffe00000eedb0>] cpu_startup_entry+0x17c/0x1dc
[<fffffe000062d1a4>] rest_init+0x74/0x80
[<fffffe00008a0984>] start_kernel+0x3a4/0x3bc
---[ end Kernel panic - not syncing: BUG!
