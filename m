Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3JYVgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 17:36:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42198 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3JYVgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 17:36:10 -0400
Subject: Re: [PATCH v2 1/5] phy: Add new Exynos USB PHY driver
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1382710529-12082-2-git-send-email-k.debski@samsung.com>
Date: Fri, 25 Oct 2013 16:36:23 -0500
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org, kyungmin.park@samsung.com, kishon@ti.com,
        t.figa@samsung.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <1A9F8795-C8EC-443C-9396-49BBA589C8B7@codeaurora.org>
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com> <1382710529-12082-2-git-send-email-k.debski@samsung.com>
To: Kamil Debski <k.debski@samsung.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 25, 2013, at 9:15 AM, Kamil Debski wrote:

> Add a new driver for the Exynos USB PHY. The new driver uses the generic
> PHY framework. The driver includes support for the Exynos 4x10 and 4x12
> SoC families.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> .../devicetree/bindings/phy/samsung-usbphy.txt     |   51 +++
> drivers/phy/Kconfig                                |   21 ++
> drivers/phy/Makefile                               |    3 +
> drivers/phy/phy-exynos-usb.c                       |  245 ++++++++++++++
> drivers/phy/phy-exynos-usb.h                       |   94 ++++++
> drivers/phy/phy-exynos4210-usb.c                   |  295 +++++++++++++++++
> drivers/phy/phy-exynos4212-usb.c                   |  343 ++++++++++++++++++++
> 7 files changed, 1052 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> create mode 100644 drivers/phy/phy-exynos-usb.c
> create mode 100644 drivers/phy/phy-exynos-usb.h
> create mode 100644 drivers/phy/phy-exynos4210-usb.c
> create mode 100644 drivers/phy/phy-exynos4212-usb.c
> 
> diff --git a/Documentation/devicetree/bindings/phy/samsung-usbphy.txt b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> new file mode 100644
> index 0000000..f112b37
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> @@ -0,0 +1,51 @@
> +Samsung S5P/EXYNOS SoC series USB PHY
> +-------------------------------------------------
> +
> +Required properties:
> +- compatible : should be one of the listed compatibles:
> +	- "samsung,exynos4210-usbphy"
> +	- "samsung,exynos4212-usbphy"
> +- reg : a list of registers used by phy driver
> +	- first and obligatory is the location of phy modules registers
> +	- second and also required is the location of isolation registers
> +	  (isolation registers control the physical connection between the in
> +	  SoC modules and outside of the SoC, this also can be called enable
> +	  control in the documentation of the SoC)
> +	- third is the location of the mode switch register, this only applies
> +	  to SoCs that have such a feature; mode switching enables to have
> +	  both host and device used the same SoC pins and is commonly used
> +	  when OTG is supported
> +- #phy-cells : from the generic phy bindings, must be 1;

Please add if clock & clock-names are required properties.

> +
> +The second cell in the PHY specifier identifies the PHY its meaning is SoC
> +dependent. For the currently supported SoCs (Exynos 4210 and Exynos 4212) it
> +is as follows:

Can we say instead of 'its meaning is SoC dependent...' something like 'its meaning is compatible dependent"?

> +  0 - USB device,
> +  1 - USB host,
> +  2 - HSIC0,
> +  3 - HSIC1,
> +
> +Example:
> +
> +For Exynos 4412 (compatible with Exynos 4212):
> +
> +exynos_usbphy: exynos-usbphy@125B0000 {
> +	compatible = "samsung,exynos4212-usbphy";
> +	reg = <0x125B0000 0x100 0x10020704 0x0c 0x1001021c 0x4>;
> +	ranges;
> +	#address-cells = <1>;
> +	#size-cells = <1>;

Why do you have ranges, and #address-cells & #size-cells here?

> +	clocks = <&clock 305>, <&clock 2>, <&clock 2>, <&clock 2>,
> +							<&clock 2>;
> +	clock-names = "phy", "device", "host", "hsic0", "hsic1";
> +	status = "okay";
> +	#phy-cells = <1>;
> +};
> +
> +Then the PHY can be used in other nodes such as:
> +
> +ehci@12580000 {
> +	status = "okay";
> +	phys = <&exynos_usbphy 2>;
> +	phy-names = "hsic0";
> +};

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

