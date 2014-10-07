Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbaJGWQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:16:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51741 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaJGWQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:16:36 -0400
Date: Tue, 7 Oct 2014 17:10:44 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-arm-msm@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: qcom: add description of KPSS WDT for IPQ8064
Message-ID: <20141007221044.GR868@joshc.qualcomm.com>
References: <cover.1412182773.git.joshc@codeaurora.org>
 <50c0ec1514173ce07641a95839e939dcda41b110.1412182773.git.joshc@codeaurora.org>
 <20141001172855.GL10233@codeaurora.org>
 <20141001181557.GQ868@joshc.qualcomm.com>
 <542DA2B6.3020201@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542DA2B6.3020201@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 12:08:38PM -0700, Stephen Boyd wrote:
[..]
> On 10/01/14 11:15, Josh Cartwright wrote:
> > The percpu-ness of the two WDTs makes configuration even more
> > interesting, as it's possible you'd want to independently configure
> > timeouts for CPU0_WDT0 and CPU1_WDT0, supporting this with a coalesced
> > timer/wdt would be cumbersome.
> 
> We already do similar things for the timers on each cpu. It doesn't seem
> that bad, but that's a matter of opinion.

I think the difference in this case is that each of the 2 per-cpu WDTs
can conceivably be registered independently, each with their own default
timeout configuration.  If we wanted to allow the most flexibility, it
seemed to me that making use of subnodes would be the best, but maybe
you have some other idea.

> > Something like this perhaps:
> >
> > 	timer@200a000 {
> > 		compatible = "qcom,kpss-timer", "qcom,msm-timer";
> > 		interrupts = <1 1 0x301>,
> > 			     <1 2 0x301>,
> > 			     <1 3 0x301>;
> > 		reg = <0x0200a000 0x100>;
> > 		clock-frequency = <25000000>,
> > 				  <32768>;
> > 		cpu-offset = <0x80000>;
> >
> > 		#address-cells = <1>;
> > 		#size-cells = <1>;
> > 		ranges;
> >
> > 		cpu0_wdt0: watchdog@208a038 {
> > 			compatible = "qcom,kpss-wdt";
> > 			reg = <0x208a038 0x40>;
> > 			interrupts = <1 4 0x301>,
> > 			clocks = <&sleep_clk>;
> > 			timeout-sec = <10>;
> > 			cpu = <&cpu0>;
> > 		};
> >
> > 		cpu0_wdt1: watchdog@208a060 {
> > 			compatible = "qcom,kpss-wdt";
> > 			reg = <0x208a060 0x40>;
> > 			interrupts = <1 5 0x301>,
> > 			clocks = <&sleep_clk>;
> > 			timeout-sec = <20>;
> > 			cpu = <&cpu0>;
> > 		};
> >
> > 		cpu1_wdt0: watchdog@209a038 {
> > 			compatible = "qcom,kpss-wdt";
> > 			reg = <0x209a038 0x40>;
> > 			interrupts = <1 4 0x301>,
> > 			clocks = <&sleep_clk>;
> > 			timeout-sec = <8>;
> > 			cpu = <&cpu1>;
> > 		};
> >
> > 		cpu1_wdt1: watchdog@209a060 {
> > 			compatible = "qcom,kpss-wdt";
> > 			reg = <0x209a060 0x40>;
> > 			interrupts = <1 5 0x301>,
> > 			clocks = <&sleep_clk>;
> > 			timeout-sec = <15>;
> > 			cpu = <&cpu1>;
> > 		};
> > 	};
> >
> >
> 
> I'm thinking:
> 
>                 timer@200a000 {
>                         compatible = "qcom,kpss-timer", "qcom,msm-timer";
>                         interrupts = <1 1 0x301>,
>                                      <1 2 0x301>,
>                                      <1 3 0x301>,
>                                      <1 4 0x301>,
>                                      <1 5 0x301>;
>                         reg = <0x0200a000 0x100>;
>                         clock-frequency = <27000000>,
>                                           <32768>;
>                         clocks = <&cxo>, <&sleep_clk>;
>                         clock-names = "ref", "sleep";
>                         cpu-offset = <0x80000>;
>                 };

Where'd the default timeout configuration go?  Or, should we have one
timeout-sec property and not allow setting the default timeouts per WDT
instance?  Or no configurable timeout at all?

> Can you explain the need for the cpu handle? Luckily this device only
> exists in configurations that have up to 4 CPUs and so mapping the
> logical CPU number to the watchdog for that CPU is "easy" in that we can
> convert the CPU from logical to physical and then do the math taking
> into account the cpu-offset to figure out where the non-aliased
> registers are. Once we get into pairs of watchdogs for different
> clusters this isn't so easy and it's better to have the phandle
> somewhere (either in the watchdog node or the cpu node) and then have
> multiple nodes for the watchdog block per-cpu so that we can map the CPU
> to the device. We realized this when making the saw binding.

Ah, yeah, now that I think about it, it's fairly straightforward to map
backward using the parent cpu-offset to determine the corresponding CPU,
so it wouldn't be necessary.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
