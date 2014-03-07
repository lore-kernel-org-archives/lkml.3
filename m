Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaCGVjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:39:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57660 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbaCGVjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:39:08 -0500
Date: Fri, 7 Mar 2014 22:38:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at
 arch/x86/kernel/cpu/amd.c:220 init_amd()
Message-ID: <20140307213856.GF5255@pd.tnic>
References: <20140307015833.GA10048@localhost>
 <53195336.9080606@linux.intel.com>
 <20140307055035.GA5230@localhost>
 <531A164B.8040402@linux.intel.com>
 <20140307191050.GA10961@redhat.com>
 <531A33A2.5030706@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <531A33A2.5030706@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Paolo.

(drop Andreas' old, invalid now email).

On Fri, Mar 07, 2014 at 01:01:22PM -0800, H. Peter Anvin wrote:
> > qemu64 triggers this ? That spew comes from amd_k7_smp_check() 
> > which should only run on family 6, which was all 32bit.
> 
> [    0.152749] smpboot: CPU0: AMD QEMU Virtual CPU version 1.6.0 (fam:
> 06, model: 02, stepping: 03)
> 
> Seems they are using a really odd CPUID combination, then.

qemu64 is (family, model, stepping) (6/6/3) and it runs into the
amd_k7_smp_check() when booting a 32-bit kernel:

[    0.022004] smpboot: CPU0: AMD QEMU Virtual CPU version 1.7.50 (fam: 06, model: 06, stepping: 03)
[    0.028000] APIC calibration not consistent with PM-Timer: 98ms instead of 100ms
[    0.028000] APIC delta adjusted to PM-Timer: 6288351 (6193101)
[    0.028160] Performance Events: Broken PMU hardware detected, using software events only.
[    0.031003] Failed to access perfctr msr (MSR c0010001 is ffffffffffffffff)
[    0.033821] CPU 1 irqstacks, hard=80064000 soft=80066000
[    0.034004] x86: Booting SMP configuration:
[    0.035003] .... node  #0, CPUs:      #1
[    0.003000] Initializing CPU#1
[    0.004000] kvm-clock: cpu 1, msr 0:777fd041, secondary cpu clock
[    0.004000] ------------[ cut here ]------------
[    0.004000] WARNING: CPU: 1 PID: 0 at arch/x86/kernel/cpu/amd.c:220 init_amd+0x752/0x780()
[    0.004000] WARNING: This combination of AMD processors is not suitable for SMP.
[    0.004000] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc5-01789-g014abf290f3f #5
[    0.004000]  00000000 00000000 80059ec0 95bc1c08 80059f00 80059ef0 9564571f 95d867cc
[    0.004000]  80059f1c 00000000 95d823e0 000000dc 956125c2 956125c2 f540ef80 f540efd0
[    0.004000]  f540effc 80059f08 9564579e 00000009 80059f00 95d867cc 80059f1c 80059f44
[    0.004000] Call Trace:
[    0.004000]  [<95bc1c08>] dump_stack+0x48/0x60
[    0.004000]  [<9564571f>] warn_slowpath_common+0x6f/0x90
[    0.004000]  [<956125c2>] ? init_amd+0x752/0x780
[    0.004000]  [<956125c2>] ? init_amd+0x752/0x780
[    0.004000]  [<9564579e>] warn_slowpath_fmt+0x2e/0x30
[    0.004000]  [<956125c2>] init_amd+0x752/0x780
[    0.004000]  [<95610497>] identify_cpu+0x117/0x4d0
[    0.004000]  [<9561085f>] identify_secondary_cpu+0xf/0x20
[    0.004000]  [<95628f9d>] smp_store_cpu_info+0x2d/0x40
[    0.004000]  [<9562965c>] start_secondary+0xec/0x270
[    0.004000] ---[ end trace 3e723b7fa3855706 ]---
[    0.004000] Disabling lock debugging due to kernel taint

So, even if we enable X86_FEATURE_MP in qemu for the "qemu64" model
(diff below), which is, or rather used to be CPUID_80000001[19] for K7,
qemu goes and asks the host which CPUID bits it supports and filters
those bits out from the requested features.

Now, on both modern AMDs and Intels, bit 19 in CPUID_80000001 is
reserved, which means 0, which means it gets filtered out.

So, long story short and unless I'm missing something else, there should
be a cmdline option for qemu which says:

--I-know-what-im-doing-enable-these-features +mp

which doesn't get filtered out.

* Another option would be if we change the f/m/s of "qemu64" so that
the test doesn't fire.

What also makes me wonder is why is this thing even called qemu64?? AMD
family 6 was 32-bit only CPUs so 64 is kinda wrong IMO. I mean, the
kernel code is in "ifdef CONFIG_X86_32" block so "qemu64" is patently
wrong naming.

Oh, and the thing has CPUID_EXT2_LM which is also a WTH moment for me.
Paolo, what's going on here?

Anyway, this is how it looks from here.

diff --git a/target-i386/cpu.c b/target-i386/cpu.c
index 0e8812a11d1e..981ce9ea992b 100644
--- a/target-i386/cpu.c
+++ b/target-i386/cpu.c
@@ -565,7 +565,8 @@ static x86_def_t builtin_x86_defs[] = {
             CPUID_EXT_SSE3 | CPUID_EXT_CX16 | CPUID_EXT_POPCNT,
         .features[FEAT_8000_0001_EDX] =
             (PPRO_FEATURES & CPUID_EXT2_AMD_ALIASES) |
-            CPUID_EXT2_LM | CPUID_EXT2_SYSCALL | CPUID_EXT2_NX,
+            CPUID_EXT2_LM | CPUID_EXT2_SYSCALL | CPUID_EXT2_NX |
+           CPUID_EXT2_MP,
         .features[FEAT_8000_0001_ECX] =
             CPUID_EXT3_LAHF_LM | CPUID_EXT3_SVM |
             CPUID_EXT3_ABM | CPUID_EXT3_SSE4A,


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
