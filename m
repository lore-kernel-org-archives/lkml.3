Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaBYCNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:13:52 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9238 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaBYCNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:13:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 24 Feb 2014 18:10:14 -0800
Message-ID: <530BFC58.6020003@nvidia.com>
Date: Tue, 25 Feb 2014 11:13:44 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: add device tree for SHIELD
References: <1393237593-28121-1-git-send-email-acourbot@nvidia.com> <530B952D.2000006@wwwdotorg.org>
In-Reply-To: <530B952D.2000006@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 03:53 AM, Stephen Warren wrote:
> On 02/24/2014 03:26 AM, Alexandre Courbot wrote:
>> Add a device tree for NVIDIA SHIELD. The set of enabled features is
>> still minimal with no display option (although HDMI should be easy
>> to get to work) and USB requiring external power.
>
> You could add a simple-framebuffer node for now, I think?

That would not be useful I'm afraid, since the DSI clocks will be 
switched off in the absence of a dsi DT node in host1x, so you would end 
up with a blank screen. Our best shot at display for the moment would be 
HDMI, but I need to spend some more time on it.

Proper internal panel support would require a panel driver with the 
proper DSI initialization sequences. It is in my pipe.

>> diff --git a/arch/arm/boot/dts/tegra114-roth.dts b/arch/arm/boot/dts/tegra114-roth.dts
>
>> +	memory {
>> +		reg = <0x80000000 0x79600000>;
>
> It might be worth a comment here pointing out that the rest of RAM is
> reserved for some carveouts/..., or at least that these values are set
> this way in order to match what the bootloader usually passes to
> downstream kernels in the command-line?

Yes, absolutely right. On a more general note I feel like DTs could gain 
clarity if they had more comments (e.g. for pinmuxing which are a quite 
heavy block otherwise), do you have any objection to this? (I guess not, 
but so far the rule seems to be "no comment in DT" :P )

>
>> +	i2c@7000d000 {
>
>> +		palmas: pmic@58 {
>> +			compatible = "ti,palmas";
>> +			reg = <0x58>;
>> +			interrupts = <0 86 IRQ_TYPE_LEVEL_HIGH>;
>> +			ti,irq-externally-inverted;
>
> Unfortunately, the patch I sent to document/implement that last property
> hasn't yet been ack'd/applied, so I'll hold off applying this until it has.

That's fine, I wanted to avoid sending another patch soon after just for 
that particular change.

>
>> +	/* Wifi */
>> +	sdhci@78000000 {
>> +		status = "okay";
>> +		bus-width = <4>;
>> +		broken-cd;
>> +		keep-power-in-suspend;
>> +		cap-sdio-irq;
>
> Is non-removable better than broken-cd, or are they entirely unrelated?

They are unrelated actually. With non-removable the driver expects the 
device to always be there since boot, and does not check for the card to 
be removed/added after boot. broken-cd indicates there is no CD line and 
the device should be polled regularly.

For the Wifi chip, non-removable would be the correct setting 
hardware-wise, but there is a trap: the chip has its reset line asserted 
at boot-time, and you need to set GPIO 229 to de-assert it. Only after 
that will the device be detected on the SDIO bus. Since it lacks a CD 
line, it must be polled, hence the broken-cd property.

This also raises another, redundant problem with DT bindings: AFAIK we 
currently have no way to let the system know the device will only appear 
after a given GPIO is set. It would also be nice to be able to give some 
parameters to the Wifi driver through the DT (like the OOB interrupt). 
Right now the Wifi chip is brought up by exporting the GPIO and writing 
to it from user-space, and the OOB interrupt is not used.

Otherwise, Wifi works great with the brcmfmac driver and NVRAM file 
extracted from Android.

> Should we add broken-cd and/or cap-sdio-irq to the SDIO WiFi on other
> boards (Springbank, Ventana, Cardhu)?

If they don't have the GPIO requirement that SHIELD has, I don't think 
it is necessary. non-removable is probably a better property for 
soldered Wifi chips.

I'm not sure about cap-sdio-irq, it doesn't seem to make a difference 
for SHIELD Wifi.

>
>> +	usb-phy@7d000000 {
>> +		status = "okay";
>> +		nvidia,xcvr-setup = <7>;
>> +		nvidia,xcvr-lsfslew = <2>;
>> +		nvidia,xcvr-lsrslew = <2>;
>> +		interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
>> +		dr_mode = "otg";
>
> While opt is probably accurate, we don't actually support otg upstream,
> but only host. While the DT is supposed to represent HW rather than
> SW/OS details, I've tried to avoid putting otg into the DT, since I'm
> not sure that the DT binding for otg is stable, since we can't test it,
> whereas host probably is. Still, this is a pretty minor detail, and we
> can ignore that if you want ("otg" evidently /works/ fine on Seaboard,
> so it's OK if you keep this).

The setting works for me and the binding is documented, so maybe we can 
keep it as-is?

Thanks for the review - v2 will be on the way, as well as Tegra Note 7 
hopefully.

Alex.

