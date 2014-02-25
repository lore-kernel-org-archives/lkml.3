Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaBYWv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:51:27 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54917 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaBYWvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:51:25 -0500
Message-ID: <530D1E69.7010504@wwwdotorg.org>
Date: Tue, 25 Feb 2014 15:51:21 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>, Rob Herring <robh+dt@kernel.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [RFC] dt: bindings: add bindings for Broadcom bcm43xx sdio devices
References: <1392059868-8782-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1392059868-8782-1-git-send-email-arend@broadcom.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 12:17 PM, Arend van Spriel wrote:
> The Broadcom bcm43xx sdio devices are fullmac devices that may be
> integrated in ARM platforms. Currently, the brcmfmac driver for
> these devices support use of platform data. This patch specifies
> the bindings that allow this platform data to be expressed in the
> devicetree.

> diff --git a/Documentation/devicetree/bindings/staging/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/staging/net/wireless/brcm,bcm43xx-fmac.txt

> + - compatible : Should be "brcm,bcm43xx-fmac".
> + - wlan-supply : phandle for fixed regulator used to control power for
> +	the device/module.

Ignoring the fact that perhaps this should just be a GPIO instead and
assuming it actually make sense for this to be a regulator:

Why "fixed regulator" not just "the regulator". There shouldn't be any
requirement for the power supply to the device to be fixed; the driver
should (a) set the voltage (which will be a no-op for a fixed regulator
already providing that voltage), then (b) enable the regulator. That
would allow a PMIC with programmable voltage to be feeding the device.

Now, if this property was really intended to control some enable GPIO on
the device, as others have said, this shouldn't be a regulator property
but rather a GPIO property. However, there is definitely some power
supply fed to the device, so you definitely need /some/ supply property
here.

Aren't there other enable GPIOs required? These should be specified in DT.

Doesn't the WiFi chip/module require a (32KHz?) clock? If so, that needs
to be represented in DT. Preferably write the binding to require
clock-names (name-based lookup) rather than just clocks (index-based
lookup).

> +Optional properties:
> + - drive-strength : drive strength used for SDIO pins on device (default = 6mA).

As mentioned elsewhere, since that's a binding-specific property, rename
it brcm,drive-strength.

> + - interrupt-parent : the phandle for the interrupt controller to which the
> +	device interrupt (HOST_WAKE) is connected.

That's such a common property, individual bindings don't typically
mention it.

> + - interrupts : interrupt specifier encoded according the interrupt controller
> +	specified by interrupt-parent property.

The description of the property should say which interrupt (name and/or
description) it's describing, even if there's only 1.


> +mmc3: mmc@01c20000 {
> +	pinctrl-0 = <&mmc3_pins>;
> +	pinctrl-1 = <&wifi_host_wake>;
> +	vmmc-supply = <&mmc3_supply>;
> +	bus-width = <4>;

None of that is really relevant to this binding, and may vary from SDIO
controller to SDIO controller, so may end up being wrong.

I'm not sure whether it makes sense to show the example inside some
arbitrary SDIO controller node. Perhaps /just/ put the WiFi node in the
example? The text above should be enough to describe that the node
should be inside an SDIO controller.

> +	bcm4335: bcm4335@0 {
> +		compatible = "brcm,bcm43xx-fmac";
> +		wlan-supply = <&wlan-reg>;
> +		drive-strength = <4>;
> +		interrupt-parent = <&gpx2>;
> +		interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
> +		interrupt-names = "HOST_WAKE";

interrupt-names wasn't documented in the list of properties above.
Entries in *-names properties are usually lower-case.
