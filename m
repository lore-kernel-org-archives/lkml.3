Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaLPQhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:37:01 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:34778 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaLPQg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:36:59 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Tue, 16 Dec 2014 11:36:57 -0500
To: Nishanth Menon <nm@ti.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>, t-kristo@ti.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 2/2] ARM: omap5/dra7xx: Fix counter frequency drift for
 AM572x errata i856.
Message-ID: <20141216163657.GL24110@csclub.uwaterloo.ca>
References: <cover.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <358281a880ccd89873efeea75edaa6c953eac2bd.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <20141214044517.GD24110@csclub.uwaterloo.ca>
 <549018EC.8020207@ti.com>
 <20141216145856.GA23358@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216145856.GA23358@kahuna>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 08:58:56AM -0600, Nishanth Menon wrote:
> On 17:05-20141216, Lokesh Vutla wrote:
> [...]
> >  
> > @@ -545,6 +546,16 @@ static void __init realtime_counter_init(void)
> >  		break;
> >  	}
> >  
> > +	if (soc_is_dra7xx()) {
> > +		reg = omap_ctrl_readl(DRA7_CTRL_CORE_BOOTSTRAP);
> > +		reg = reg & DRA7_SPEEDSELECT_MASK;
> > +
> > +		if (reg) {
> > +			num = 75;
> > +			den = 244;
> > +		}
> > +	}
> > +
> >  	/* Program numerator and denumerator registers */
> >  	reg = readl_relaxed(base + INCREMENTER_NUMERATOR_OFFSET) &
> >  			NUMERATOR_DENUMERATOR_MASK;
> 
> A) So, it does look like the 32k node is actually wrong then -> Tero:
> any comments? should'nt this now be modeled based on
> CTRL_CORE_BOOTSTRAP::SPEEDSELECT considering that clock nodes do have
> clk mux options based on the 32k..
> sys_32k_ck: sys_32k_ck {
> 	#clock-cells = <0>;
> 	compatible = "fixed-clock";
> 	clock-frequency = <32768>;
> };

Hmm, I hadn't considered other things that might care.  Certainly if
you were to use a SYSCLK1 other than 20MHz, it certainly won't be 32KHz
anymore.

> B) Since rate switch is no longer needed, how about something like the
> following:
> diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
> index a3c0133..315d6d1 100644
> --- a/arch/arm/mach-omap2/control.h
> +++ b/arch/arm/mach-omap2/control.h
> @@ -286,6 +286,11 @@
>  #define OMAP5XXX_CONTROL_STATUS                0x134
>  #define OMAP5_DEVICETYPE_MASK          (0x7 << 6)
>  
> +
> +/* DRA7XX CONTROL CORE BOOTSTRAP */
> +#define DRA7_CTRL_CORE_BOOTSTRAP	0x6c4
> +#define DRA7_SPEEDSELECT_MASK		(0x3 << 8)
> +
>  /*
>   * REVISIT: This list of registers is not comprehensive - there are more
>   * that should be added.

I like that as a place for those.

> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index 4f61148..783d3c3 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -54,6 +54,7 @@
>  
>  #include "soc.h"
>  #include "common.h"
> +#include "control.h"
>  #include "powerdomain.h"
>  #include "omap-secure.h"
>  

How about this version for the rest of the file.  It handles that for
the errata case we would like to do rate * num / den, which given how
small the num is will fit in 32bit and gives the best accuracy for the
calculation, while the non errata case the existing calculation works
well and fits in 32 bit for all other cases.  It just has to be moved
up so that the goto can skip it.  I changed sysclk to sysclk1 since on
the dra7xx there is in fact a sysclk1 and a sysclk2 and it is probably
worth keeping it clear which one this is referring to.

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index fb0cb2b..be254bf 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -511,6 +511,36 @@ static void __init realtime_counter_init(void)
 	}
 
 	rate = clk_get_rate(sys_clk);
+
+	if (soc_is_dra7xx()) {
+		/*
+		 * Errata i856 says the 32.768KHz crystal does not start at
+		 * power on, so the CPU falls back to an emulated 32KHz clock
+		 * based on sysclk1 / 610 instead. This causes the master counter
+		 * frequency to not be 6.144MHz but at sysclk1 / 610 * 375 / 2
+		 * (OR sysclk1 * 75 / 244)
+		 *
+		 * This affects at least the DRA7/AM572x 1.0, 1.1 revisions.
+		 * Of course any board built without a populated 32.768KHz
+	         * crystal would also need this fix even if the CPU is fixed
+		 * later.
+		 *
+		 * Either case can be detected by using the two speedselect bits
+		 * If they are not 0, then the 32.768KHz clock driving the
+		 * coarse counter that corrects the fine counter every time it
+		 * ticks is actually rate/610 rather than 32.768KHz and we
+		 * should compensate to avoid the 570ppm (at 20MHz, much worse
+		 * at other rates) too fast system time.
+		 */
+		reg = omap_ctrl_readl(DRA7_CTRL_CORE_BOOTSTRAP);
+		if (reg & DRA7_SPEEDSELECT_MASK) {
+			num = 75;
+			den = 244;
+			arch_timer_freq = (rate * num) / den;
+			goto sysclk1_based;
+		}
+	}
+
 	/* Numerator/denumerator values refer TRM Realtime Counter section */
 	switch (rate) {
 	case 12000000:
@@ -544,7 +574,9 @@ static void __init realtime_counter_init(void)
 		den = 25;
 		break;
 	}
+	arch_timer_freq = (rate / den) * num;
 
+sysclk1_based:
 	/* Program numerator and denumerator registers */
 	reg = readl_relaxed(base + INCREMENTER_NUMERATOR_OFFSET) &
 			NUMERATOR_DENUMERATOR_MASK;
@@ -556,7 +588,6 @@ static void __init realtime_counter_init(void)
 	reg |= den;
 	writel_relaxed(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
 
-	arch_timer_freq = (rate / den) * num;
 	set_cntfreq();
 
 	iounmap(base);

-- 
Len Sorensen
