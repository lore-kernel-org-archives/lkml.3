Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaKFTns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 14:43:48 -0500
Received: from asav22.altibox.net ([109.247.116.9]:58719 "EHLO
	asav22.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaKFTno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 14:43:44 -0500
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2014 14:43:44 EST
Message-ID: <545BCDBE.9020200@tronnes.org>
Date: Thu, 06 Nov 2014 20:36:30 +0100
From: Noralf Tronnes <notro@tronnes.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Matthias Klein <matthias.klein@linux.com>,
        linux-rpi-kernel@lists.infradead.org, swarren@wwwdotorg.org,
        lee@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: bcm2835: add device tree for Raspberry Pi model
 B+
References: <1415231123-920-1-git-send-email-matthias.klein@linux.com>
In-Reply-To: <1415231123-920-1-git-send-email-matthias.klein@linux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 141106-0, 06.11.2014), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Den 06.11.2014 00:45, skrev Matthias Klein:
> The model B and B+ differ in the GPIO lines for ACT and PWR leds, and the
> I2S interface.
>
> Signed-off-by: Matthias Klein <matthias.klein@linux.com>
> ---
> Changes in v2:
> - move the common parts between the B and B+ model into the new bcm2835-rpi.dtsi file
>
> - add the I2S signals to the B+ file which fix the problem that USB is not working
>    with the current bcm2835-rpi-b.dts file on the B+.
> ---
<snip>
> +&gpio {
> +	pinctrl-names = "default";
> +
> +	gpioout: gpioout {
> +		brcm,pins = <6>;
> +		brcm,function = <1>; /* GPIO out */
> +	};
> +
> +	alt0: alt0 {
> +		brcm,pins = <0 1 2 3 4 5 7 8 9 10 11 14 15 40 45>;
> +		brcm,function = <4>; /* alt0 */
> +	};
> +
> +	alt3: alt3 {
> +		brcm,pins = <48 49 50 51 52 53>;
> +		brcm,function = <7>; /* alt3 */
> +	};
> +};
AFAIK these pins will always be configured regardless of whether they 
are used by a driver or not.

Could we do something like this for SPI and I2C, configuring only when 
needed?

&gpio {
     spi_pins: spi_pins {
         brcm,pins = <7 8 9 10 11>;
         brcm,function = <4>; /* alt0 */
     };

     i2c0_pins: i2c0_pins {
         brcm,pins = <0 1>;
         brcm,function = <4>;
     };

     i2c1_pins: i2c1_pins {
         brcm,pins = <2 3>;
         brcm,function = <4>;
     };
};

&spi {
     pinctrl-names = "default";
     pinctrl-0 = <&spi_pins>;
};

&i2c0 {
     pinctrl-names = "default";
     pinctrl-0 = <&i2c0_pins>;
     clock-frequency = <100000>;
};

&i2c1 {
     pinctrl-names = "default";
     pinctrl-0 = <&i2c1_pins>;
     clock-frequency = <100000>;
};

> +
> +&i2c0 {
> +	status = "okay";
> +	clock-frequency = <100000>;
> +};
> +
> +&i2c1 {
> +	status = "okay";
> +	clock-frequency = <100000>;
> +};
> +
Should the I2C busses be enabled by default? On Raspian, i2c is disabled 
by blacklisting the module (/etc/modprobe.d/raspi-blacklist.conf).
At least i2c0 should be left disabled due to the HAT EEPROM and camera.
The bus number has also changed with revisions: 
http://www.raspberrypi.org/forums/viewtopic.php?p=603950#p603950

