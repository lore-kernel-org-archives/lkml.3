Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3H2TTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:19:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42855 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab3H2TTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:19:16 -0400
Message-ID: <521F9EAF.4060701@wwwdotorg.org>
Date: Thu, 29 Aug 2013 13:19:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: balbi@ti.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org, rob@landley.net,
        ian.campbell@citrix.com, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, bcousson@baylibre.com,
        davidb@codeaurora.org, arnd@arndb.de, swarren@nvidia.com,
        popcornmix@gmail.com
Subject: Re: [PATCH v3 1/3] extcon: extcon-gpio-usbvid: Generic USB VBUS/ID
 detection via GPIO
References: <1377711185-31238-1-git-send-email-george.cherian@ti.com> <1377711185-31238-2-git-send-email-george.cherian@ti.com>
In-Reply-To: <1377711185-31238-2-git-send-email-george.cherian@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 11:33 AM, George Cherian wrote:
> Add a generic USB VBUS/ID detection EXTCON driver. This driver expects
> the ID/VBUS pin are connected via GPIOs. This driver is tested on
> DRA7x board were the ID pin is routed via GPIOs. The driver supports
> both VBUS and ID pin configuration and ID pin only configuration.

> diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio-usbvid.txt b/Documentation/devicetree/bindings/extcon/extcon-gpio-usbvid.txt

> +EXTCON FOR USB VIA GPIO

Please write a brief explanation of the HW that this binding represents.

"Extcon" is a Linux-specific term. Binding documentation should be
written in an OS-agnostic manner. Bindings should not reference
OS-specific terminology, and should be a pure description of the HW.

> +Required Properties:
> + - compatible : Should be "ti,gpio-usb-vid" for USB VBUS-ID detector
> +		using gpios or "ti,gpio-usb-id" for USB ID pin detector

Those souond like two rather different things. Should they be separate
bindings, or at the least, separate sections in the document?

If this binding is meant to represent some generic hardware, the vendor
prefix probably isn't required. So, remove "ti," from the compatible values.

> + - gpios : phandle and args ID pin gpio and VBUS gpio.

s/and args/and specifier/.

> +	   The first gpio used  for ID pin detection
> +	   and the second used for VBUS detection.
> +	   ID pin gpio is mandatory and VBUS is optional
> +	   depending on implementation.

It'd be better to use named GPIO properties here, rather than having
multiple different kinds of GPIO in the same property. How about
"id-gpios" and "vbus-gpios" as the property names?

The semantics of each property should be specified. Are these input
GPIOs that reflect the ID and VBUS state? Do they directly represent the
signal state on the connector, or are they processed somehow? Does the
VBUS GPIO control the board's VBUS output, or is it an input? If it
controls VBUS output, it probably should be represented as a regulator
rather than a GPIO.

I think the following might work:

Required properties:

id-gpios: GPIO specifier for the connector's ID pin input. This directly
represents the value present on the ID pin at the connector.

Optional properties:

vbus-gpios: GPIO specifier for the connector's VBUS signal. This
directly represents whether VBUS being driven by the USB cable itself.

(although perhaps that isn't an optional property, but rather a required
property of the second compatible value?)

> +Please refer to ../gpio/gpio.txt for details of the common GPIO bindings
> +
> +Example:
> +
> +	gpio_usbvid_extcon1 {
> +		compatible = "ti,gpio-usb-vid";
> +		gpios = <&gpio1 1 0>,
> +			<&gpio2 2 0>;
> +	};

