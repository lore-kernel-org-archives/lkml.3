Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaJASVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:21:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51381 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaJASVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:21:41 -0400
Date: Wed, 1 Oct 2014 13:15:57 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-arm-msm@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: qcom: add description of KPSS WDT for IPQ8064
Message-ID: <20141001181557.GQ868@joshc.qualcomm.com>
References: <cover.1412182773.git.joshc@codeaurora.org>
 <50c0ec1514173ce07641a95839e939dcda41b110.1412182773.git.joshc@codeaurora.org>
 <20141001172855.GL10233@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001172855.GL10233@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Stephen-

Thanks for taking a look.

On Wed, Oct 01, 2014 at 10:28:55AM -0700, Stephen Boyd wrote:
> On 10/01, Josh Cartwright wrote:
> > @@ -96,6 +104,13 @@
> >  			cpu-offset = <0x80000>;
> >  		};
> >
> > +		watchdog@208a038 {
> > +			compatible = "qcom,kpss-wdt-ipq8064";
> > +			reg = <0x0208a038 0x40>;
>
> Not being aligned to 4k or 1k raises red flags.
>
> The watchdog is part of the timer block (on this chip it's
> "qcom,kpss-timer"). We should add qcom,kpss-wdt to the compatible
> list in the timer binding and extend that binding to have clocks
> and timeout-sec (watchdog-timeout-sec?).

Yeah, the description of this thing is a bit awkward.

I'm not sure how I'd feel about just just adding "qcom,kpss-wdt" to the
timer node compatible.  I'm wondering if the WDT(s) should be a
subnode(s) of the timer node instead?

The percpu-ness of the two WDTs makes configuration even more
interesting, as it's possible you'd want to independently configure
timeouts for CPU0_WDT0 and CPU1_WDT0, supporting this with a coalesced
timer/wdt would be cumbersome.

Something like this perhaps:

	timer@200a000 {
		compatible = "qcom,kpss-timer", "qcom,msm-timer";
		interrupts = <1 1 0x301>,
			     <1 2 0x301>,
			     <1 3 0x301>;
		reg = <0x0200a000 0x100>;
		clock-frequency = <25000000>,
				  <32768>;
		cpu-offset = <0x80000>;

		#address-cells = <1>;
		#size-cells = <1>;
		ranges;

		cpu0_wdt0: watchdog@208a038 {
			compatible = "qcom,kpss-wdt";
			reg = <0x208a038 0x40>;
			interrupts = <1 4 0x301>,
			clocks = <&sleep_clk>;
			timeout-sec = <10>;
			cpu = <&cpu0>;
		};

		cpu0_wdt1: watchdog@208a060 {
			compatible = "qcom,kpss-wdt";
			reg = <0x208a060 0x40>;
			interrupts = <1 5 0x301>,
			clocks = <&sleep_clk>;
			timeout-sec = <20>;
			cpu = <&cpu0>;
		};

		cpu1_wdt0: watchdog@209a038 {
			compatible = "qcom,kpss-wdt";
			reg = <0x209a038 0x40>;
			interrupts = <1 4 0x301>,
			clocks = <&sleep_clk>;
			timeout-sec = <8>;
			cpu = <&cpu1>;
		};

		cpu1_wdt1: watchdog@209a060 {
			compatible = "qcom,kpss-wdt";
			reg = <0x209a060 0x40>;
			interrupts = <1 5 0x301>,
			clocks = <&sleep_clk>;
			timeout-sec = <15>;
			cpu = <&cpu1>;
		};
	};

> This would follow DT best practices of having one node per device. We
> could also add the interrupts too, even if they're not used by the
> driver right now.
> 
> > +			clocks = <&sleep_clk>;
> > +			timeout-sec = <10>;
> > +		};
> > +

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
