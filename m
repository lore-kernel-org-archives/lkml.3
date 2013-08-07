Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab3HGQau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:30:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43316 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757071Ab3HGQas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:30:48 -0400
Date: Wed, 7 Aug 2013 17:30:45 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Julius Werner <jwerner@chromium.org>
Cc: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH 1/3 v5] usb: phy-samsung-usb: Simplify PMU register
 handling
Message-ID: <20130807163045.GK28558@e106331-lin.cambridge.arm.com>
References: <1375812017-6287-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375812017-6287-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 07:00:17PM +0100, Julius Werner wrote:
> This patch simplifies the way the phy-samsung-usb code finds the correct
> power management register to enable PHY clock gating. Previously, the
> code would calculate the register address from a device tree supplied
> base address and add an offset based on the PHY type.
> 
> Since every PHY has its own device tree entry and needs only one
> register, we can just encode the address itself in the device tree and
> remove the diffentiation in the code. The bitmask needed to specify the
> bit within that register stays in place, allowing support for platforms
> like s3c64xx that use different bits within the same register.

This breaks compatibility, both for an old kernel and a new dt and a new
kernel with an old dt. Is anyone using these bindings?


> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  .../devicetree/bindings/usb/samsung-usbphy.txt     | 26 +++++-----------------
>  arch/arm/boot/dts/exynos5250.dtsi                  |  4 ++--
>  drivers/usb/phy/phy-samsung-usb.c                  | 18 ++++-----------
>  drivers/usb/phy/phy-samsung-usb.h                  | 23 +++++--------------
>  drivers/usb/phy/phy-samsung-usb2.c                 | 11 ++++-----
>  drivers/usb/phy/phy-samsung-usb3.c                 |  2 +-
>  6 files changed, 22 insertions(+), 62 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> index 33fd354..1cf9b68 100644
> --- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> +++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> @@ -34,14 +34,7 @@ Optional properties:
>  - The child node 'usbphy-sys' to the node 'usbphy' is for the system controller
>    interface for usb-phy. It should provide the following information required by
>    usb-phy controller to control phy.
> -  - reg : base physical address of PHY_CONTROL registers.
> -	  The size of this register is the total sum of size of all PHY_CONTROL
> -	  registers that the SoC has. For example, the size will be
> -	  '0x4' in case we have only one PHY_CONTROL register (e.g.
> -	  OTHERS register in S3C64XX or USB_PHY_CONTROL register in S5PV210)
> -	  and, '0x8' in case we have two PHY_CONTROL registers (e.g.
> -	  USBDEVICE_PHY_CONTROL and USBHOST_PHY_CONTROL registers in exynos4x).
> -	  and so on.
> +  - reg : address of PHY_CONTROL register for this PHY.
>  
>  Example:
>   - Exynos4210
> @@ -57,8 +50,8 @@ Example:
>  		clock-names = "xusbxti", "otg";
>  
>  		usbphy-sys {
> -			/* USB device and host PHY_CONTROL registers */
> -			reg = <0x10020704 0x8>;
> +			/* USB device PHY_CONTROL register */
> +			reg = <0x10020704 0x4>;
>  		};
>  	};
>  

Why are we describing fewer registers now? Are they described elsewhere?

The dt should describe the device, not only the portion of it Linux
wants to use right now.

Thanks,
Mark.
