Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147Ab3HSTVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 15:21:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50293 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3HSTV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 15:21:28 -0400
Message-ID: <52127035.7000909@wwwdotorg.org>
Date: Mon, 19 Aug 2013 13:21:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Lars Poeschel <poeschel@lemonage.de>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2] pinctrl: queue GPIO operations instead of defering
References: <1376751410-14560-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1376751410-14560-1-git-send-email-linus.walleij@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2013 08:56 AM, Linus Walleij wrote:
> We currently defer probing of the caller if a pinctrl GPIO
> request or direction setting comes in before the range mapping
> a certain GPIO to a certain pin controller is available.
> 
> This can end up with a circular dependency: the GPIO driver
> needs the pin controller to be ready and the pin controller
> need the GPIO driver to be ready. This also happens if
> pin controllers and GPIO controllers compiled as modules
> are inserted in a certain order.
> 
> To break this circular dependence, queue any GPIO
> operations coming to the framework until the range is ready,
> instead of deferring the probe of the caller.

I just noticed that next-20130819 is failing on the Tegra114 Dalmore
board because of this patch. The kernel log is below. Reverting this
patch solves the problem

> [   12.427751] tegra114-pinctrl 70000868.pinmux: pin USB_VBUS_EN0 PN4 already requested by Tegra GPIOs:108; cannot claim for Tegra GPIOs:108
> [   12.440320] tegra114-pinctrl 70000868.pinmux: pin-108 (Tegra GPIOs:108) status -22
> [   12.447965] usb1_vbus: Failed to request enable GPIO108: -22
> [   12.454306] reg-fixed-voltage 3.regulator: Failed to register regulator: -22
> [   12.461508] reg-fixed-voltage: probe of 3.regulator failed with error -22
> [   12.469659] tegra114-pinctrl 70000868.pinmux: pin SPDIF_IN PK6 already requested by Tegra GPIOs:86; cannot claim for Tegra GPIOs:86
> [   12.481606] tegra114-pinctrl 70000868.pinmux: pin-86 (Tegra GPIOs:86) status -22
> [   12.489052] usb2_vbus: Failed to request enable GPIO86: -22
> [   12.495226] reg-fixed-voltage 4.regulator: Failed to register regulator: -22
> [   12.502449] reg-fixed-voltage: probe of 4.regulator failed with error -22
> [   12.510542] tegra114-pinctrl 70000868.pinmux: pin GMI_CLK PK1 already requested by Tegra GPIOs:81; cannot claim for Tegra GPIOs:81
> [   12.522403] tegra114-pinctrl 70000868.pinmux: pin-81 (Tegra GPIOs:81) status -22
> [   12.529896] vdd_hdmi_5v0: Failed to request enable GPIO81: -22
> [   12.536281] reg-fixed-voltage 5.regulator: Failed to register regulator: -22
> [   12.543465] reg-fixed-voltage: probe of 5.regulator failed with error -22
> [   12.552509] vdd_cam_1v8_reg: 1800 mV 
> [   12.558205] platform 7d008000.usb: Driver tegra-ehci requests probe deferral
> [   12.566600] platform 7d008000.usb-phy: Driver tegra-phy requests probe deferral
> [   12.577475] input: gpio-keys.2 as /devices/soc0/gpio-keys.2/input/input1
> [   12.588329] platform 7d008000.usb: Driver tegra-ehci requests probe deferral
> [   12.596967] platform 7d008000.usb-phy: Driver tegra-phy requests probe deferral

