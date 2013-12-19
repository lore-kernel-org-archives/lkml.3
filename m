Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab3LSXIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:08:13 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:41892 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab3LSXIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:08:12 -0500
Message-ID: <52B37C56.7090302@gmail.com>
Date: Thu, 19 Dec 2013 15:08:06 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips <linux-mips@linux-mips.org>
CC: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 29/40] mips: Replace __get_cpu_var uses
References: <20131219155015.443763038@linux.com> <20131219155033.834416420@linux.com> <52B330F3.4090603@gmail.com> <alpine.DEB.2.10.1312191506370.17603@nuc>
In-Reply-To: <alpine.DEB.2.10.1312191506370.17603@nuc>
Content-Type: multipart/mixed;
 boundary="------------070507070702050801040409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070507070702050801040409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/2013 01:10 PM, Christoph Lameter wrote:
> On Thu, 19 Dec 2013, David Daney wrote:
>
>>> 16:07:58.244398747 -0600
>>> @@ -43,7 +43,7 @@ DECLARE_PER_CPU(struct mips_fpu_emulator
>>>    #define MIPS_FPU_EMU_INC_STATS(M)					\
>>>    do {
>>> \
>>>    	preempt_disable();						\
>>> -	__local_inc(&__get_cpu_var(fpuemustats).M);			\
>>> +	__this_cpu_inc(fpuemustats.M);					\
>>>    	preempt_enable();						\
>>>    } while (0)
>>>
>>
>> Something seems to be incorrect in this bit.
>
> Hrmm.. yes this is a local_t so the this_cpu_inc would not work unless
> fpuemustats is defined differently.
>

See the attached patch.  Feel free to include it as part of your patch set.

I tested it on a 64-bit OCTEON system.  I think it will work on 32-bit 
systems as well.

> Use
>
> __local_inc(this_cpu_ptr(fpuemustats.M);
>

No, I couldn't get various incantations of that to work either.

> instead until then.
>


--------------070507070702050801040409
Content-Type: text/x-patch;
 name="0001-MIPS-Replace-__get_cpu_var-uses-in-FPU-emulator.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-MIPS-Replace-__get_cpu_var-uses-in-FPU-emulator.patch"

>From cc9590cf4d75cf7fd36a58be132d35fbbe536a64 Mon Sep 17 00:00:00 2001
From: David Daney <david.daney@cavium.com>
Date: Thu, 19 Dec 2013 14:00:17 -0800
Subject: [PATCH] MIPS: Replace __get_cpu_var uses in FPU emulator.

The use of __this_cpu_inc() requires a fundamental integer type, so
change the type of all the counters to unsigned long, which is the
same width they were before, but not wrapped in local_t.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/fpu_emulator.h | 14 +++++++-------
 arch/mips/math-emu/cp1emu.c          |  6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/mips/include/asm/fpu_emulator.h b/arch/mips/include/asm/fpu_emulator.h
index 2abb587..619fa5f 100644
--- a/arch/mips/include/asm/fpu_emulator.h
+++ b/arch/mips/include/asm/fpu_emulator.h
@@ -30,12 +30,12 @@
 #ifdef CONFIG_DEBUG_FS
 
 struct mips_fpu_emulator_stats {
-	local_t emulated;
-	local_t loads;
-	local_t stores;
-	local_t cp1ops;
-	local_t cp1xops;
-	local_t errors;
+	unsigned long emulated;
+	unsigned long loads;
+	unsigned long stores;
+	unsigned long cp1ops;
+	unsigned long cp1xops;
+	unsigned long errors;
 };
 
 DECLARE_PER_CPU(struct mips_fpu_emulator_stats, fpuemustats);
@@ -43,7 +43,7 @@ DECLARE_PER_CPU(struct mips_fpu_emulator_stats, fpuemustats);
 #define MIPS_FPU_EMU_INC_STATS(M)					\
 do {									\
 	preempt_disable();						\
-	__local_inc(&__get_cpu_var(fpuemustats).M);			\
+	__this_cpu_inc(fpuemustats.M);					\
 	preempt_enable();						\
 } while (0)
 
diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
index efe0088..b853d05 100644
--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -2110,13 +2110,13 @@ int fpu_emulator_cop1Handler(struct pt_regs *xcp, struct mips_fpu_struct *ctx,
 static int fpuemu_stat_get(void *data, u64 *val)
 {
 	int cpu;
-	unsigned long sum = 0;
+	u64 sum = 0;
 	for_each_online_cpu(cpu) {
 		struct mips_fpu_emulator_stats *ps;
-		local_t *pv;
+		unsigned long *pv;
 		ps = &per_cpu(fpuemustats, cpu);
 		pv = (void *)ps + (unsigned long)data;
-		sum += local_read(pv);
+		sum += *pv;
 	}
 	*val = sum;
 	return 0;
-- 
1.7.11.7


--------------070507070702050801040409--
