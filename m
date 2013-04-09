Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936115Ab3DIJJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:09:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37608 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935153Ab3DIJI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:08:59 -0400
Date: Tue, 9 Apr 2013 10:08:43 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH 1/4] Documentation: Add memory mapped ARM architected
 timer binding
Message-ID: <20130409090843.GS23725@e106331-lin.cambridge.arm.com>
References: <1365474623-29181-1-git-send-email-sboyd@codeaurora.org>
 <1365474623-29181-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365474623-29181-2-git-send-email-sboyd@codeaurora.org>
Thread-Topic: [PATCH 1/4] Documentation: Add memory mapped ARM architected
 timer binding
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Apr 09, 2013 at 03:30:20AM +0100, Stephen Boyd wrote:
> Add a binding for the arm architected timer hardware's memory
> mapped interface. The mmio timer hardware is made up of one base
> frame and a collection of up to 8 timer frames, where each of the
> 8 timer frames can have either one or two views. A frame
> typically maps to a privilege level (user/kernel, hypervisor,
> secure). The first view has full access to the registers within a
> frame, while the second view can be restricted to particular
> registers within a frame. Each frame must support a physical
> timer. It's optional for a frame to support a virtual timer.
> 
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  .../devicetree/bindings/arm/arch_timer.txt         | 62 ++++++++++++++++++++--
>  1 file changed, 59 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
> index 20746e5..69ef711 100644
> --- a/Documentation/devicetree/bindings/arm/arch_timer.txt
> +++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
> @@ -1,10 +1,14 @@
>  * ARM architected timer
>  
> -ARM cores may have a per-core architected timer, which provides per-cpu timers.
> +ARM cores may have a per-core architected timer, which provides per-cpu timers,
> +or a memory mapped architected timer, which provides up to 8 frames with a
> +physical and optional virtual timer per frame.
>  
> -The timer is attached to a GIC to deliver its per-processor interrupts.
> +The per-core architected timer is attached to a GIC to deliver its
> +per-processor interrupts via PPIs. The memory mapped timer is attached to a GIC
> +to deliver its interrupts via SPIs.
>  
> -** Timer node properties:
> +** CP15 Timer node properties:
>  
>  - compatible : Should at least contain one of
>  	"arm,armv7-timer"
> @@ -26,3 +30,55 @@ Example:
>  			     <1 10 0xf08>;
>  		clock-frequency = <100000000>;
>  	};
> +
> +** Memory mapped timer node properties
> +
> +- compatible : Should at least contain "arm,armv7-timer-mem".
> +
> +- #address-cells : Must be 1.

What about LPAE systems?

How about something like the following:

#address-cells : If the ranges property is empty, the same value as the
                 parent node's #address-cells property. Otherwise, a
		 value such that the ranges property specifies a
		 mapping to the parent node's address space.            

> +
> +- #size-cells : Must be 1.
> +
> +- ranges : Indicates parent and child bus address space are the same.
> +

Similarly, what if someone wants to write a more complex mapping for some
reason?

We should be able to handle it if we use the standard accessors.

> +- clock-frequency : The frequency of the main counter, in Hz. Optional.
> +
> +- reg : The control frame base address.
> +
> +Frame:
> +
> +- frame-id: Encoded as follows:
> +		bits[3:0]  frame number: 0 to 7.
> +		bits[10:8] frame usage:
> +			0 - user/kernel
> +			1 - hyp
> +			2 - secure
> +

Could we not just have a disabled status property for those frames claimed by a
higher level (either secure firmware or hypervisor)? Or have I missed something
here?

Then we'd just have a frame-number property, which is easier for humans to read
and understand.

> +- interrupts : Interrupt list for physical and virtual timers in that order.
> +  The virtual timer interrupt is optional.
> +
> +- reg : The first and second view base addresses in that order. The second view
> +  base address is optional.
> +
> +Example:
> +
> +	timer@f0000000 {
> +		compatible = "arm,armv7-timer-mem";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +		reg = <0xf0000000 0x1000>;
> +		clock-frequency = <50000000>;
> +		frame0@f0001000 {
> +			frame-id = <0x0>
> +			interrupts = <0 13 0x8>,
> +				     <0 14 0x8>;
> +			reg = <0xf0001000 0x1000>,
> +			      <0xf0002000 0x1000>;
> +		};
> +		frame1@f0003000 {
> +			frame-id = <0x11>
> +			interrupts = <0 15 0x8>;
> +			reg = <0xf0003000 0x1000>;
> +		};
> +	};
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 

Mark.
