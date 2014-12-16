Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbaLPO7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:59:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51965 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaLPO7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:59:21 -0500
Date: Tue, 16 Dec 2014 08:58:56 -0600
From: Nishanth Menon <nm@ti.com>
To: Lokesh Vutla <lokeshvutla@ti.com>, <t-kristo@ti.com>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Kristo, Tero" <t-kristo@ti.com>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 2/2] ARM: omap5/dra7xx: Fix counter frequency drift for
 AM572x errata i856.
Message-ID: <20141216145856.GA23358@kahuna>
References: <cover.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <358281a880ccd89873efeea75edaa6c953eac2bd.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <20141214044517.GD24110@csclub.uwaterloo.ca>
 <549018EC.8020207@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <549018EC.8020207@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:05-20141216, Lokesh Vutla wrote:
[...]
>  
> @@ -545,6 +546,16 @@ static void __init realtime_counter_init(void)
>  		break;
>  	}
>  
> +	if (soc_is_dra7xx()) {
> +		reg = omap_ctrl_readl(DRA7_CTRL_CORE_BOOTSTRAP);
> +		reg = reg & DRA7_SPEEDSELECT_MASK;
> +
> +		if (reg) {
> +			num = 75;
> +			den = 244;
> +		}
> +	}
> +
>  	/* Program numerator and denumerator registers */
>  	reg = readl_relaxed(base + INCREMENTER_NUMERATOR_OFFSET) &
>  			NUMERATOR_DENUMERATOR_MASK;

A) So, it does look like the 32k node is actually wrong then -> Tero:
any comments? should'nt this now be modeled based on
CTRL_CORE_BOOTSTRAP::SPEEDSELECT considering that clock nodes do have
clk mux options based on the 32k..
sys_32k_ck: sys_32k_ck {
	#clock-cells = <0>;
	compatible = "fixed-clock";
	clock-frequency = <32768>;
};

B) Since rate switch is no longer needed, how about something like the
following:
diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
index a3c0133..315d6d1 100644
--- a/arch/arm/mach-omap2/control.h
+++ b/arch/arm/mach-omap2/control.h
@@ -286,6 +286,11 @@
 #define OMAP5XXX_CONTROL_STATUS                0x134
 #define OMAP5_DEVICETYPE_MASK          (0x7 << 6)
 
+
+/* DRA7XX CONTROL CORE BOOTSTRAP */
+#define DRA7_CTRL_CORE_BOOTSTRAP	0x6c4
+#define DRA7_SPEEDSELECT_MASK		(0x3 << 8)
+
 /*
  * REVISIT: This list of registers is not comprehensive - there are more
  * that should be added.
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 4f61148..783d3c3 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -54,6 +54,7 @@
 
 #include "soc.h"
 #include "common.h"
+#include "control.h"
 #include "powerdomain.h"
 #include "omap-secure.h"
 
@@ -511,6 +512,35 @@ static void __init realtime_counter_init(void)
 	}
 
 	rate = clk_get_rate(sys_clk);
+
+	if (soc_is_dra7xx()) {
+		/*
+		 * Errata i856 says the 32.768KHz crystal does not start at
+		 * power on, so the CPU falls back in an emulated 32KHz clock
+		 * based on sysclk / 610 instead. This causes the master counter
+		 * frequency to not be 6.144MHz but at sysclk / 610  * 375 / 2
+		 * (OR sysclk * 75 / 244)
+		 *
+		 * This affects at least the DRA7/AM572x 1.0, 1.1 revisions.
+		 * Of course any board built without a populated 32.768KHz
+		 * crystal would also need this fix even if the CPU is fixed
+		 * later.
+		 *
+		 * Either case can be detected by using the two speedselect bits
+		 * If they are not 0, then the 32.768KHz clock driving the
+		 * course counter that corrects the fine counter every time it
+		 * ticks is actually rate/610 rather than 32.768KHz and we
+		 * should compensate to avoid the 570ppm (At 20MHz, much worse
+		 * at other rates) too fast system time.
+		 */
+		reg = omap_ctrl_readl(DRA7_CTRL_CORE_BOOTSTRAP);
+		if (reg & DRA7_SPEEDSELECT_MASK) {
+			num = 75;
+			den = 244;
+			goto sysclk_based;
+		}
+	}
+
 	/* Numerator/denumerator values refer TRM Realtime Counter section */
 	switch (rate) {
 	case 1200000:
@@ -545,6 +575,7 @@ static void __init realtime_counter_init(void)
 		break;
 	}
 
+sysclk_based:
 	/* Program numerator and denumerator registers */
 	reg = readl_relaxed(base + INCREMENTER_NUMERATOR_OFFSET) &
 			NUMERATOR_DENUMERATOR_MASK;

-- 
Regards,
Nishanth Menon
