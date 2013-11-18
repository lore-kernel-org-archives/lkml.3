Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3KRNFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:05:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab3KRNFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:05:12 -0500
Date: Mon, 18 Nov 2013 15:02:24 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PROBLEM] possible divide by 0 in kernel/sched/cputime.c
 scale_stime()
Message-ID: <20131118140224.GA3330@redhat.com>
References: <20131116223740.3cd579cb@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131116223740.3cd579cb@spike>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian 

On Sat, Nov 16, 2013 at 10:37:40PM +0100, Christian Engelmayer wrote:
> Since upgrading from v3.8 to v3.12 I see random crashes in function scale_stime()
> in kernel/sched/cputime.c:
> 
>    divide error: 0000 [#1] SMP 
>    Modules linked in: parport_pc(F) ppdev(F) bnep rfcomm bluetooth binfmt_misc(F)
>    zl10353 cx88_dvb cx88_vp3054_i2c videobuf_dvb dvb_core intel_powerclamp coretemp
>    kvm_intel(F) tuner_xc2028 kvm(F) i915 snd_hda_codec_hdmi snd_hda_codec_realtek
>    cx8800 cx8802 tuner snd_hda_intel snd_hda_codec cx88_alsa crct10dif_pclmul(F)
>    crc32_pclmul(F) snd_hwdep(F) snd_pcm(F) snd_page_alloc(F) ghash_clmulni_intel(F)
>    aesni_intel(F) snd_seq_midi(F) snd_seq_midi_event(F) snd_rawmidi(F) snd_seq(F)
>    joydev(F) cx88xx snd_seq_device(F) snd_timer(F) aes_x86_64(F) lrw(F) gf128mul(F)
>    glue_helper(F) video(F) btcx_risc drm_kms_helper ablk_helper(F) tveeprom cryptd(F)
>    lp(F) videobuf_dma_sg rc_core drm v4l2_common videobuf_core mei_me parport(F)
>    snd(F) mei soundcore(F) videodev i2c_algo_bit serio_raw(F) microcode(F) mac_hid
>    lpc_ich asus_atk0110 hid_generic usbhid hid usb_storage(F) firewire_ohci ahci(F)
>    libahci(F) firewire_core r8169 crc_itu_t(F) mii(F)
>    CPU: 3 PID: 15367 Comm: htop Tainted: GF            3.12.0-031200-generic #201311031935
>    Hardware name: System manufacturer System Product Name/P7H55-M PRO, BIOS 1709    01/04/2011
>    task: ffff8800cc09e000 ti: ffff8800af620000 task.ti: ffff8800af620000
>    RIP: 0010:[<ffffffff81099de0>]  [<ffffffff81099de0>] cputime_adjust+0xf0/0x110
>    RSP: 0018:ffff8800af621cc8  EFLAGS: 00010847
>    RAX: 85fdc1fef4047c00 RBX: 0000000000000000 RCX: ffff8800af621df8
>    RDX: 0000000000000000 RSI: ffff8800cc0634d0 RDI: 0000000000000000
>    RBP: ffff8800af621cd8 R08: 00000000fffffffe R09: 0000000000000000
>    R10: 0000000000000000 R11: fffffffe03427acc R12: ffff8800af621df0
>    R13: ffff8800af621df8 R14: 0000000000000000 R15: ffff8800cc063300
>    FS:  00007f22a387d740(0000) GS:ffff880117c60000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: 00007f22a3892000 CR3: 0000000097023000 CR4: 00000000000007e0
>    Stack:
>     ffff8800c37f0000 ffff8800af621df0 ffff8800af621d18 ffffffff8109aa51
>     000000000a7d8c00 0000000042fee100 fffffffe03427acc ffff8800bf112a80
>     ffff8800c37f0000 ffff8800c307c280 ffff8800af621e50 ffffffff8121f74b
>    Call Trace:
>     [<ffffffff8109aa51>] thread_group_cputime_adjusted+0x41/0x50
>     [<ffffffff8121f74b>] do_task_stat+0x8eb/0xb60
>     [<ffffffff81176400>] ? vma_compute_subtree_gap+0x50/0x50
>     [<ffffffff81220314>] proc_tgid_stat+0x14/0x20
>     [<ffffffff8121b16d>] proc_single_show+0x4d/0x90
>     [<ffffffff811d6eee>] seq_read+0x14e/0x390
>     [<ffffffff811b3725>] vfs_read+0x95/0x160
>     [<ffffffff811b4239>] SyS_read+0x49/0xa0
>     [<ffffffff81723ced>] system_call_fastpath+0x1a/0x1f
>    Code: 89 fa 49 c1 ea 20 4d 85 d2 74 ca 4c 89 c2 48 d1 ef 49 89 c0 48 d1 ea 48
>          89 d0 eb 9f 0f 1f 80 00 00 00 00 89 c0 31 d2 49 0f af c0 <48> f7 f7 4c
>          89 df 48 29 c7 49 89 c3 e9 31 ff ff ff 66 66 66 66 
>    RIP  [<ffffffff81099de0>] cputime_adjust+0xf0/0x110
>     RSP <ffff8800af621cc8>
>    ---[ end trace dbafd2159a385dd6 ]---
> 
> The affected LOC performing the division by 0 was introduced in commit
> 
>    commit 55eaa7c1f511af5fb6ef808b5328804f4d4e5243
>    Author: Stanislaw Gruszka <sgruszka@redhat.com>
>    Date:   Tue Apr 30 17:14:42 2013 +0200
>    sched: Avoid cputime scaling overflow
> 
> For the problem to occur the function is called eg. with the following
> input parameters
> 
>    stime: 0x3567e00
>    rtime: 0xffffffffbf1abfdb
>    total: 0x3938700
> 
> which leads to 'total' being shifted to 0 during the adaption of the precision
> and is then used without further check in
> 
>    scaled = div_u64((u64) (u32) stime * (u64) (u32) rtime, (u32)total);
> 
> The root cause triggering this issue seems to be an overflowed value of
> 
>    rtime = nsecs_to_cputime(curr->sum_exec_runtime);
> 
> On the affected machine the problem can be triggered by loading the
> previously idle system by starting a full kernel build. The problem occurs
> within a minute after the ondemand frequency scaling governor adjusts the
> frequency from the minimum to the maximum.
> 
> The x86 init check whether all booted CPUs have their TSC's synchronized, never
> failed so far, however, the tsc clocksource is sporadically marked unstable.
> 
>    Clocksource tsc unstable (delta = -74994678 ns)
> 
> The used CPU provides an Intel Invariant TSC as stated by CPUID.80000007H:EDX[8]:
> 
>     eax in    eax      ebx      ecx      edx
>    00000000 0000000b 756e6547 6c65746e 49656e69
>    00000001 00020652 04100800 0298e3ff bfebfbff
>    00000002 55035a01 00f0b2e3 00000000 09ca212c
>    00000003 00000000 00000000 00000000 00000000
>    00000004 00000000 00000000 00000000 00000000
>    00000005 00000040 00000040 00000003 00001120
>    00000006 00000005 00000002 00000001 00000000
>    00000007 00000000 00000000 00000000 00000000
>    00000008 00000000 00000000 00000000 00000000
>    00000009 00000000 00000000 00000000 00000000
>    0000000a 07300403 00000004 00000000 00000603
>    0000000b 00000000 00000000 0000002c 00000004
>    80000000 80000008 00000000 00000000 00000000
>    80000001 00000000 00000000 00000001 28100800
>    80000002 65746e49 2952286c 726f4320 4d542865
>    80000003 35692029 55504320 20202020 20202020
>    80000004 30353620 20402020 30322e33 007a4847
>    80000005 00000000 00000000 00000000 00000000
>    80000006 00000000 00000000 01006040 00000000
>    80000007 00000000 00000000 00000000 00000100
>    80000008 00003024 00000000 00000000 00000000
> 
>    Vendor ID: "GenuineIntel"; CPUID level 11
> 
>    Intel-specific functions:
>    Version 00020652:
>    Type 0 - Original OEM
>    Family 6 - Pentium Pro
>    Model 5 - Pentium II Model 5/Xeon/Celeron
>    Stepping 2
>    Reserved 8
> 
>    Extended brand string: "Intel(R) Core(TM) i5 CPU         650  @ 3.20GHz"
>    CLFLUSH instruction cache line size: 8
>    Initial APIC ID: 4
>    Hyper threading siblings: 16
> 
>    Feature flags bfebfbff:
>    FPU    Floating Point Unit
>    VME    Virtual 8086 Mode Enhancements
>    DE     Debugging Extensions
>    PSE    Page Size Extensions
>    TSC    Time Stamp Counter
>    MSR    Model Specific Registers
>    PAE    Physical Address Extension
>    MCE    Machine Check Exception
>    CX8    COMPXCHG8B Instruction
>    APIC   On-chip Advanced Programmable Interrupt Controller present and enabled
>    SEP    Fast System Call
>    MTRR   Memory Type Range Registers
>    PGE    PTE Global Flag
>    MCA    Machine Check Architecture
>    CMOV   Conditional Move and Compare Instructions
>    FGPAT  Page Attribute Table
>    PSE-36 36-bit Page Size Extension
>    CLFSH  CFLUSH instruction
>    DS     Debug store
>    ACPI   Thermal Monitor and Clock Ctrl
>    MMX    MMX instruction set
>    FXSR   Fast FP/MMX Streaming SIMD Extensions save/restore
>    SSE    Streaming SIMD Extensions instruction set
>    SSE2   SSE2 extensions
>    SS     Self Snoop
>    HT     Hyper Threading
>    TM     Thermal monitor
>    31     reserved
> 
> Nevertheless, when looking into the issue I saw occurences of sched_clock going
> backwards as if the TSCs were read out of sync. Accordingly the problem does
> not occur when either booting with option 'nosmp' or when forcing the TSC to be
> marked as unstable for sched_clock. Booting with 'acpi=off' and no frequency
> scaling works too.
> 
> Having a look at the scheduler code I see the following pattern that would also
> catch a time warp, eg. kernel/sched/rt.c update_curr_rt():
> 
>    u64 delta_exec;
>    delta_exec = rq_clock_task(rq) - curr->se.exec_start;
>    if (unlikely((s64)delta_exec <= 0))
>            return;
> 
> However, there are still vulnerable places, eg. kernel/sched/fair.c update_curr():
> 
>    /*
>     * Get the amount of time the current task was running
>     * since the last time we changed load (this cannot
>     * overflow on 32 bits):
>     */
>    delta_exec = (unsigned long)(now - curr->exec_start);
>    if (!delta_exec)
>            return;

Thanks for great analyse. I'm not sure where this problem should be
fixed (in TSC clocksource or sched/fair.c or sched/cputime.c), however
since RT scheduler is protected for sched_clock going backward, we
probably can protect fair scheduler as well (also do_task_delta_exec()
has similar check).

Does the below patch fixes the issue on affected machine?

Stanislaw

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c70201..f02a567 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -727,7 +727,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	u64 now = rq_clock_task(rq_of(cfs_rq));
 	unsigned long delta_exec;
 
-	if (unlikely(!curr))
+	if (unlikely(!curr || now <= curr->exec_start))
 		return;
 
 	/*
@@ -736,8 +736,6 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	 * overflow on 32 bits):
 	 */
 	delta_exec = (unsigned long)(now - curr->exec_start);
-	if (!delta_exec)
-		return;
 
 	__update_curr(cfs_rq, curr, delta_exec);
 	curr->exec_start = now;
