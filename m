Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaCJKji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:39:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:49209 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaCJKjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:39:37 -0400
Date: Mon, 10 Mar 2014 11:39:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Julian Wollrath <jwollrath@web.de>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
In-Reply-To: <20140310110410.5b2218f6@ilfaris>
Message-ID: <alpine.DEB.2.02.1403101123470.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014, Julian Wollrath wrote:
> on a Thinkpad x121e (AMD E-450 APU) with version 3.13.5 and earlier of
> the kernel I get:
> [...]
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.001000] tsc: Detected 1646.619 MHz processor
> [    0.000004] Calibrating delay loop (skipped), value calculated using
> timer frequency.. 3293.23 BogoMIPS (lpj=1646619)
> [...]
> 
> 
> but starting with v3.14-rc1 the fast TSC calibration fails:
> [...]
> [    0.000000] tsc: Fast TSC calibration failed
> [    0.000000] tsc: PIT calibration matches HPET. 1 loops
> [    0.000000] tsc: Detected 1646.490 MHz processor
> [...]

The only change in the calibration code post 3.13 is that we added the
MSR based calibration for ATOM:

@@ -419,6 +651,13 @@ unsigned long native_calibrate_tsc(void)
 	unsigned long flags, latch, ms, fast_calibrate;
 	int hpet = is_hpet_enabled(), i, loopmin;
 
+	/* Calibrate TSC using MSR for Intel Atom SoCs */
+	local_irq_save(flags);
+	fast_calibrate = try_msr_calibrate_tsc();
+	local_irq_restore(flags);
+	if (fast_calibrate)
+		return fast_calibrate;
+
 	local_irq_save(flags);
 	fast_calibrate = quick_pit_calibrate();
 	local_irq_restore(flags);

And that definitely does not affect the quick calibration. No idea,
except bisecting.

Thanks,

	tglx


