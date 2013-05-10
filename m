Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab3EJQQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:16:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42241 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931Ab3EJQQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:16:39 -0400
Date: Fri, 10 May 2013 18:23:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
Message-ID: <20130510162340.GE22942@pd.tnic>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
 <20130510002930.GB2394@somewhere>
 <alpine.LNX.2.00.1305101702250.23038@pobox.suse.cz>
 <20130510152102.GD22942@pd.tnic>
 <20130510154349.GB9358@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130510154349.GB9358@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 05:43:50PM +0200, Frederic Weisbecker wrote:
> Right. But this is adding a timer locally, from CPU 1 to CPU 1, as
> indicated in the trace with the "1 1" line. So the only way for
> this IPI to be self-sent is if the tick is stopped locally (cf:
> wake_up_full_nohz_cpu()).
>
> But the tick is not supposed to be stopped so early in a secondary CPU
> initialization. The tick can be stopped only from two places:
>
> 1) idle loop, but we haven't yet reached that place. cpu_idle() is
> called much later 2) interrupt exit, but interrupts are supposed to be
> disabled at this stage

Hmm, I see.

> So either interrupts are spuriously enabled early, or ts->tick_stopped
> is not correctly initialized.

Hmm, it can't be interrupts disabled because add_timer_on() does
spin_lock_irqsave() before calling wake_up_nohz_cpu()... Maybe something
like the below could help check this...

Although AFAICT, we're enabling interrupts much later in
start_secondary, even after we've set the bit in the online mask.

---
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9c73b51817e4..1b679b0fa57a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -201,6 +201,8 @@ static void __cpuinit smp_callin(void)
 	 */
 	setup_vector_irq(smp_processor_id());
 
+	WARN_ON(!irqs_disabled());
+
 	/*
 	 * Save our processor parameters. Note: this information
 	 * is needed for clock calibration.


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
