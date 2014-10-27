Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaJ0UNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:13:51 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:43676 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaJ0UNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:13:49 -0400
MIME-Version: 1.0
Date: Mon, 27 Oct 2014 13:13:48 -0700
Message-ID: <CAADnVQ+bZdb5wETaj8b8WYnZD4Myhexy8iHDoxsu3-srZwyRxQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] perf, x86, uncore: Add Haswell-EP uncore support
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 4:57 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> my E5-1630 v3 crashes hard during boot in
>> snbep_uncore_msr_init_box()+0x3c
>
>> I don't have a setup to capture the screen so early in the boot.
>> So this is just heads up.
>
> Is it a general general protection fault or a page fault?
>
> If it's a page fault please post the disassembled code:
>
> gdb vmlinux
> disassemble  snbep_uncore_msr_init_box
>

snbep_uncore_msr_init_box() is called with:
[    1.055678] msr 0
[    1.056027] msr 3584
[    1.056376] msr 3600
[    1.056725] msr 3616
[    1.057074] msr 3632
[    1.057424] msr 1824
[    1.057773] msr 1834
[    1.058123] msr 1844
[    1.058473] msr 1854
[    1.058822] msr 1808

since msr 3584 is HSWEP_C0_MSR_PMON_BOX_CTL
I've tried the following workaround which helped as well:
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index adf138eac85c..1ca46523a541 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -368,7 +368,7 @@ static void snbep_uncore_msr_init_box(struct
intel_uncore_box *box)
 {
        unsigned msr = uncore_msr_box_ctl(box);

-       if (msr)
+       if (msr && msr >= 3584)
                wrmsrl(msr, SNBEP_PMON_BOX_CTL_INT);
 }
