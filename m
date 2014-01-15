Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaAONKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:10:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaAONKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:10:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Carino <marc.ceeeee@gmail.com>
Subject: Re: [PATCH v3 7/7] ARM: brcmstb: dts: add a reference DTS for Broadcom 7445
Date: Wed, 15 Jan 2014 14:10:38 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Christian Daudt <bcm@fixthebug.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com> <1389743333-16741-8-git-send-email-marc.ceeeee@gmail.com>
In-Reply-To: <1389743333-16741-8-git-send-email-marc.ceeeee@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401151410.39112.arnd@arndb.de>
X-Provags-ID: V02:K0:R8yzhaq74/5ImIqQLwSSFd6ILoxNDJJRlnP6fo3y0GA
 lhGiKZjMOFAfih4ZSm+7cSGGGX7Wkdc8fh4VelsQrnCipOfauz
 L6hTehjy0nwWtTblL5YYN/86LIonZ+pkq01yNqMTS7o+x+BWNm
 Z7/86YSj+JhlgAD64JHq/xr5yBWoXgaz34Mq+NjiYLS+ZlLFDt
 LF7iK/cF9pTBymgbtOSEfwXPQZhTyoPmXJ5d2qgfsmlqXI2SJ2
 h81NnyXq4qG6nFqFLRTbPmvId6rBGzVcOEddQjOGtcK9d5Ho1B
 PRJD4GPs4n/MlvFUFIqtArPLLKE1bRhwvw4/gORPoDob+yYMQG
 vmmdYoYbeimrhdwFOYqA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 January 2014, Marc Carino wrote:
> +       gen-ctrl {
> +               compatible = "brcm,brcmstb-gen-ctrl-v1";
> +               reg = <0xf0404304 0x4
> +                      0xf0404308 0x4
> +                      0xf03e2578 0x4
> +                      0xf03e2488 0x10
> +                      0xf0452000 0x20>;
> +       };

Sorry I didn't get back to you on this when we discussed the previous
version. I'm actually less happy with this DT representation than the
original. What I take from your description is that you have multiple
register ranges that basically combine more-or-less random registers
that belong into different Linux subsystems.

I think the best way to deal with this is to have the "syscon" driver
handle the multiplexing between the various drivers that need access
to the registers. It would look something like (taking the numbers
from your previous patch):

	ahb {
		ranges = <0 0xf0000000 0x1000000>; /* 16 MB remapped registers */

		hif-cpubuictrl: syscon@3e2400 {
			compatible = "brcm,7445-cpubioctrl", "syscon";
			reg = <0x3e2000, 0x1000>;
		};

		hif-continuation: syscon@45200 {
			compatible = "brcm,7445-hif-continuation", "syscon";
			reg = <0x452000, 0x1000>;
		};

		sun-top-ctrl: ...
	};

This lets the syscon driver find and map the three register areas.
Drivers that need access to the registers then do 

	reset {
		compatible = "brcm,7445-reset-ctrl";
		syscon = <&sun-top-ctrl 0x300 0x100>;
		#reset-cells = <1>;
	};

And then you can add a regular device driver to drivers/reset that provides
a device_reset() API to other drivers, or a system-reset function to be
registered as arm_pm_restart. This driver would use
syscon_regmap_lookup_by_phandle() to get access to a regmap pointer,
and then use either hardcoded offsets into the regmap, or get those
offsets from numbers in the devicetree, as provided in the example
above.

	Arnd
