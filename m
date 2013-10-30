Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3J3AHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:07:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47898 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3J3AH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:07:27 -0400
Date: Tue, 29 Oct 2013 17:07:25 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH 4/6] edac: Document Krait L1/L2 EDAC driver binding
Message-ID: <20131030000725.GH21983@codeaurora.org>
References: <1383006690-6754-1-git-send-email-sboyd@codeaurora.org>
 <1383006690-6754-5-git-send-email-sboyd@codeaurora.org>
 <90D2FDE5-C43F-4ACF-B287-4E0AD8617892@codeaurora.org>
 <526FF7DB.5040805@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526FF7DB.5040805@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29, Stephen Boyd wrote:
> On 10/29/13 01:21, Kumar Gala wrote:
> > On Oct 28, 2013, at 7:31 PM, Stephen Boyd wrote:
> >
> >> The Krait L1/L2 error reporting device is made up of two
> >> interrupts, one per-CPU interrupt for the L1 caches and one
> >> interrupt for the L2 cache.
> >>
> >> Cc: <devicetree@vger.kernel.org>
> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >> ---
> >> .../devicetree/bindings/arm/qcom,krait-cache-erp.txt     | 16 ++++++++++++++++
> >> 1 file changed, 16 insertions(+)
> >> create mode 100644 Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt b/Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt
> >> new file mode 100644
> >> index 0000000..01fe8a8
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt
> >> @@ -0,0 +1,16 @@
> >> +* Qualcomm Krait L1 / L2 cache error reporting
> >> +
> >> +Required properties:
> >> +- compatible: Should be "qcom,krait-cache-erp"
> >> +- interrupts: Should contain the L1/CPU error interrupt number and
> >> +  then the L2 cache error interrupt number
> >> +
> >> +Optional properties:
> >> +- interrupt-names: Should contain the interrupt names "l1_irq" and
> >> +  "l2_irq"
> >> +
> >> +Example:
> >> +	edac {
> >> +		compatible = "qcom,krait-cache-erp";
> >> +		interrupts = <1 9 0xf04>, <0 2 0x4>;
> >> +	};
> > Why wouldn't we have these as part of cache nodes in the dts?  (which begs the question why we don't have cache nodes?)
> >
> 
> I can certainly add cache nodes and cpu nodes and then put the
> interrupts in those nodes. I was thinking along those same lines when I
> ported this driver but figured it would be good to get something out
> there. The only question I have is how am I supposed to hook that up
> into the linux device model? Will the edac driver bind to the device
> created for the cpus node and the cache node? I guess it will have to be
> a driver that binds to two devices.
> 
> One could argue that we should put the cp15 based architected timers in
> the cpus node also but so far nobody has done that and I think there was
> some reasoning behind that, Mark?
> 

Ok I've come up with this:

	cpus {
		#address-cells = <1>;
		#size-cells = <0>;
		compatible = "qcom,krait";
		interrupts = <1 9 0xf04>;

		cpu@0 {
			reg = <0>;
			next-level-cache = <&L2>;
		};

		cpu@1 {
			reg = <1>;
			next-level-cache = <&L2>;
		};

		cpu@2 {
			reg = <2>;
			next-level-cache = <&L2>;
		};

		cpu@3 {
			reg = <3>;
			next-level-cache = <&L2>;
		};

		L2: l2-cache {
			compatible = "qcom,krait-l2", "cache";
			cache-level = <2>;
			interrupts = <0 2 0x4>;
		};
	};

But now I don't know where to document this. Should I make a
krait-edac.txt file and document it there? The problem is now
we're documenting more than the error interrupts.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
