Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaCKRPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:15:22 -0400
Received: from mout.web.de ([212.227.17.12]:58722 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbaCKRPU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:15:20 -0400
Date: Tue, 11 Mar 2014 18:15:13 +0100
From: Julian Wollrath <jwollrath@web.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, Lee@linutronix.de,
        Chun-Yi <jlee@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
Message-ID: <20140311181513.0f73383c@ilfaris>
In-Reply-To: <alpine.DEB.2.02.1403111454140.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>
 <alpine.DEB.2.02.1403101123470.18573@ionos.tec.linutronix.de>
 <20140311142910.27594027@ilfaris>
 <alpine.DEB.2.02.1403111454140.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:H57QrV7TImx6M+3mSUzwN+ndxgpj8QQ7Y1OGLBT8yl6FO7TXUDF
 e/ik2OanEGcfv4YMptkadTWtHGGcSKPXtX63bV1IbOW/AS9rn3unX3YgLYxUjNz/LWsaWT6
 MdkG+70AyvBneD3bPYnWRuPCxehj5K6M6PwpVfis9wvEN55YV5hz2bgHimVkgmLkm5kl/5o
 8/AMjWVofMPKSk7NQE/yw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tue, 11 Mar 2014 14:56:41 +0100 (CET)
schrieb Thomas Gleixner <tglx@linutronix.de>:
> > Ok, via bisecting I found commit
> > 73f7d1ca32638028e3271f54616773727e2f9f26 (see below) to be the one
> > that introduced this regression.
> 
> Interesting. I have no idea what's going on. But maybe can the ACPI
> folks shed some light on it.

I have absolutely no idea, if it is the right thing to do and why it
works, but the patch below fixes the problem. Thank you for your help.


Cheers,
Julian Wollrath

>From 7664f495039d93adfce073e58840a46549904f04 Mon Sep 17 00:00:00 2001
From: Julian Wollrath <jwollrath@web.de>
Date: Tue, 11 Mar 2014 18:05:43 +0100
Subject: [PATCH] Fix fast TSC calibration

Since commit 73f7d1ca32638028e3271f54616773727e2f9f26 the fast TSC calibration
failed on a Thinkpad X121e with an AMD E450 APU. Moving acpi_early_init() after
late_time_init() fixes this.

Signed-off-by: Julian Wollrath <jwollrath@web.de>
---
 init/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index eb03090cdced..bf9d99148bd6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -561,7 +561,6 @@ asmlinkage void __init start_kernel(void)
 	init_timers();
 	hrtimers_init();
 	softirq_init();
-	acpi_early_init();
 	timekeeping_init();
 	time_init();
 	sched_clock_postinit();
@@ -609,6 +608,7 @@ asmlinkage void __init start_kernel(void)
 	numa_policy_init();
 	if (late_time_init)
 		late_time_init();
+	acpi_early_init();
 	sched_clock_init();
 	calibrate_delay();
 	pidmap_init();
-- 
1.9.0

