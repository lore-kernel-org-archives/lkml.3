Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaJBTIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:08:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46050 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaJBTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:08:39 -0400
Message-ID: <542DA2B6.3020201@codeaurora.org>
Date: Thu, 02 Oct 2014 12:08:38 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-arm-msm@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: qcom: add description of KPSS WDT for IPQ8064
References: <cover.1412182773.git.joshc@codeaurora.org> <50c0ec1514173ce07641a95839e939dcda41b110.1412182773.git.joshc@codeaurora.org> <20141001172855.GL10233@codeaurora.org> <20141001181557.GQ868@joshc.qualcomm.com>
In-Reply-To: <20141001181557.GQ868@joshc.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/14 11:15, Josh Cartwright wrote:
> Yeah, the description of this thing is a bit awkward.

:-/ I tried to make the binding future proof.

>
> I'm not sure how I'd feel about just just adding "qcom,kpss-wdt" to the
> timer node compatible.  I'm wondering if the WDT(s) should be a
> subnode(s) of the timer node instead?

But then we don't make the timers subnodes? That seems odd. What's the
benefit of multiple sub-nodes for the watchdogs?

It would also be fine to use the current compatible string and just
append the extra two interrupts for the two watchdogs and then make an
optional clocks property and deprecate the clock-frequency property.

>
> The percpu-ness of the two WDTs makes configuration even more
> interesting, as it's possible you'd want to independently configure
> timeouts for CPU0_WDT0 and CPU1_WDT0, supporting this with a coalesced
> timer/wdt would be cumbersome.

We already do similar things for the timers on each cpu. It doesn't seem
that bad, but that's a matter of opinion.

>
> Something like this perhaps:
>
> 	timer@200a000 {
> 		compatible = "qcom,kpss-timer", "qcom,msm-timer";
> 		interrupts = <1 1 0x301>,
> 			     <1 2 0x301>,
> 			     <1 3 0x301>;
> 		reg = <0x0200a000 0x100>;
> 		clock-frequency = <25000000>,
> 				  <32768>;
> 		cpu-offset = <0x80000>;
>
> 		#address-cells = <1>;
> 		#size-cells = <1>;
> 		ranges;
>
> 		cpu0_wdt0: watchdog@208a038 {
> 			compatible = "qcom,kpss-wdt";
> 			reg = <0x208a038 0x40>;
> 			interrupts = <1 4 0x301>,
> 			clocks = <&sleep_clk>;
> 			timeout-sec = <10>;
> 			cpu = <&cpu0>;
> 		};
>
> 		cpu0_wdt1: watchdog@208a060 {
> 			compatible = "qcom,kpss-wdt";
> 			reg = <0x208a060 0x40>;
> 			interrupts = <1 5 0x301>,
> 			clocks = <&sleep_clk>;
> 			timeout-sec = <20>;
> 			cpu = <&cpu0>;
> 		};
>
> 		cpu1_wdt0: watchdog@209a038 {
> 			compatible = "qcom,kpss-wdt";
> 			reg = <0x209a038 0x40>;
> 			interrupts = <1 4 0x301>,
> 			clocks = <&sleep_clk>;
> 			timeout-sec = <8>;
> 			cpu = <&cpu1>;
> 		};
>
> 		cpu1_wdt1: watchdog@209a060 {
> 			compatible = "qcom,kpss-wdt";
> 			reg = <0x209a060 0x40>;
> 			interrupts = <1 5 0x301>,
> 			clocks = <&sleep_clk>;
> 			timeout-sec = <15>;
> 			cpu = <&cpu1>;
> 		};
> 	};
>
>

I'm thinking:

                timer@200a000 {
                        compatible = "qcom,kpss-timer", "qcom,msm-timer";
                        interrupts = <1 1 0x301>,
                                     <1 2 0x301>,
                                     <1 3 0x301>,
				     <1 4 0x301>,
				     <1 5 0x301>;
                        reg = <0x0200a000 0x100>;
                        clock-frequency = <27000000>,
                                          <32768>;
			clocks = <&cxo>, <&sleep_clk>;
			clock-names = "ref", "sleep";
                        cpu-offset = <0x80000>;
                };

Can you explain the need for the cpu handle? Luckily this device only
exists in configurations that have up to 4 CPUs and so mapping the
logical CPU number to the watchdog for that CPU is "easy" in that we can
convert the CPU from logical to physical and then do the math taking
into account the cpu-offset to figure out where the non-aliased
registers are. Once we get into pairs of watchdogs for different
clusters this isn't so easy and it's better to have the phandle
somewhere (either in the watchdog node or the cpu node) and then have
multiple nodes for the watchdog block per-cpu so that we can map the CPU
to the device. We realized this when making the saw binding.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

