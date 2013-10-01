Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab3JAIGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:06:45 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1922 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab3JAIGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:06:41 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <524A823F.6070209@broadcom.com>
Date: Tue, 1 Oct 2013 10:05:19 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-Version: 1.0
To: "Roger Quadros" <rogerq@ti.com>
cc: "Tony Lindgren" <tony@atomide.com>, linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: using mmc2 on panda [was: Regression 3.11-rc1: omap4panda: no
 usb and consequently no ethernet]
References: <51E7AA24.6080600@broadcom.com>
 <20130718085951.GT7656@atomide.com> <51E916C0.8080206@broadcom.com>
 <51E919CA.8060805@ti.com> <51E91B80.1050609@broadcom.com>
In-Reply-To: <51E91B80.1050609@broadcom.com>
X-WSS-ID: 7E54A0742L890248187-08-01
Content-Type: multipart/mixed;
 boundary=------------000307010108090003000303
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--------------000307010108090003000303
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit

On 07/19/2013 12:57 PM, Arend van Spriel wrote:
> On 07/19/2013 12:49 PM, Roger Quadros wrote:
>> On 07/19/2013 01:36 PM, Arend van Spriel wrote:
>>> On 07/18/2013 10:59 AM, Tony Lindgren wrote:
>>>> Then for the SDIO with device tree, take a look at the following
>>>> patches:
>>>>
>>>> [PATCH 0/3] WLAN support for omap4 when booted with devicetree
>>>> http://comments.gmane.org/gmane.linux.ports.arm.omap/97522#
>>>
>>> I have been looking at the pandaboard patch in the series above and I
>>> do have a question. Among other things the patch adds these dt entries.
>>>
>>> +            0x108 0x118    /* sdmmc5_clk.sdmmc5_clk INPUT_PULLUP |
>>> MODE0 */
>>> +            0x10a 0x118    /* sdmmc5_cmd.sdmmc5_cmd INPUT_PULLUP |
>>> MODE0 */
>>>
>>> If I look at the similar names in the deceased board-omap4panda.c:
>>>
>>> board-omap4panda.c:    OMAP4_MUX(SDMMC5_CMD, OMAP_MUX_MODE0 |
>>> OMAP_PIN_INPUT_PULLUP),
>>> board-omap4panda.c:    OMAP4_MUX(SDMMC5_CLK, OMAP_MUX_MODE0 |
>>> OMAP_PIN_INPUT_PULLUP),
>>>
>>> and in mux44xx.h:
>>>
>>> mux44xx.h:#define OMAP4_CTRL_MODULE_PAD_SDMMC5_CLK_OFFSET    0x0148
>>> mux44xx.h:#define OMAP4_CTRL_MODULE_PAD_SDMMC5_CMD_OFFSET    0x014a
>>>
>>> So how did 0x0148 get 0x0108 in DT and 0x014a get 0x010a. There is
>>> probably an explanation to it and it would help my understanding to
>>> know where this difference comes from. Hope you can help me out here.
>>>
>>
>> If you see omap4.dtsi, omap4_pmx_core starts at register address
>> 0x4a100040.
>>
>> So, you need to subtract 0x40 from the offsets defined in mux44xx.h
>> for pmx_core registers.
>
> That was what I was looking for. Thanks!

Hi Roger,

It has been a while, but I would like to pickup this thread. We have a 
couple of pandaboards used as test setup. These have an SDIO adapter 
hooked up to expansion connector A using MMC2. I have attached the patch 
file (just ignore platform_data stuff). Now on one board it works, but 
not for the other. I suspect a board issue so listing the two types that 
we use:

PandaBoard rev A2 (dmesg: OMAP4430 ES2.1): works
PandaBoardES rev B1 (dmesg: OMAP4460 ES1.1): nope

Any hints for me.

Regards,
Arend

>> NOTE: omap4_pmx_wkup starts at a different address. Those are for
>> wakeup domain
>> control registers.
>
> Will keep that in mind.
>
> Regards,
> Arend
>


--------------000307010108090003000303
Content-Type: text/plain;
 name=0001-brcmfmac-add-device-tree-support-for-panda-board.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-brcmfmac-add-device-tree-support-for-panda-board.patch

>From 4a20162935b27e23ec7ddc818c9fe6b451c1a968 Mon Sep 17 00:00:00 2001
From: Arend van Spriel <arend@broadcom.com>
Date: Thu, 22 Aug 2013 12:29:23 +0200
Subject: [PATCH] brcmfmac: add device tree support for panda board

In linux mainline the pandaboard specific code moved to using
the device tree. Changing our internal patches to get platform
specific info from the device tree.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 arch/arm/boot/dts/omap4-panda-common.dtsi |   20 +++++++++++++++-
 arch/arm/mach-omap2/devices.c             |   36 ++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index faa95b5..6ebeb8e 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -226,6 +226,22 @@
 			0xf0 (PIN_INPUT_PULLUP | MUX_MODE0)	/* i2c4_sda */
 		>;
 	};
+	mmc2_brcmf_en: pinmux_mmc2_brcmf_en {
+		pinctrl-single,pins = <
+			0x92 (PIN_OUTPUT | MUX_MODE3)		/* brcmf-power */
+		>;
+	};
+	mmc2_pins: pinmux_mmc2_pins {
+		pinctrl-single,pins = <
+			0x44 (MUX_MODE1 | PIN_INPUT_PULLUP)	/* mmc2-cmd */
+			0x42 (MUX_MODE1 | PIN_INPUT_PULLUP)	/* mmc2-clk */
+			0x00 (MUX_MODE1 | PIN_INPUT_PULLUP)	/* mmc2-dat 0-3 */
+			0x02 (MUX_MODE1 | PIN_INPUT_PULLUP)
+			0x04 (MUX_MODE1 | PIN_INPUT_PULLUP)
+			0x06 (MUX_MODE1 | PIN_INPUT_PULLUP)
+			0x9a (MUX_MODE3 | PIN_INPUT_PULLDOWN)	/* oob-irq */
+		>;
+	};
 };
 
 &omap4_pmx_wkup {
@@ -302,7 +318,9 @@
 };
 
 &mmc2 {
-	status = "disabled";
+	vmmc-supply = <&vaux1>;
+	bus-width = <4>;
+	non-removable;
 };
 
 &mmc3 {
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 3c1279f..7a47535 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -21,7 +21,7 @@
 #include <linux/platform_data/omap4-keypad.h>
 #include <linux/wl12xx.h>
 #include <linux/platform_data/mailbox-omap.h>
-
+#include <linux/platform_data/brcmfmac-sdio.h>
 #include <asm/mach-types.h>
 #include <asm/mach/map.h>
 
@@ -547,6 +547,39 @@ static inline void omap_init_wl12xx_of(void)
 }
 #endif
 
+#define GPIO_BRCMF_SDIO_PWR	134
+#define GPIO_BRCMF_SDIO_OOB	138
+static struct brcmfmac_sdio_platform_data brcmfmac_sdio_pdata;
+
+static struct platform_device brcmf_sdio_device = {
+	.name		= BRCMFMAC_SDIO_PDATA_NAME,
+	.id		= PLATFORM_DEVID_NONE,
+	.dev.platform_data	= &brcmfmac_sdio_pdata
+};
+
+static struct gpio brcmf_sdio_gpios[] __initdata = {
+	{ GPIO_BRCMF_SDIO_PWR,	GPIOF_OUT_INIT_HIGH,	"brcmf_sdio_pwr"},
+	{ GPIO_BRCMF_SDIO_OOB,	GPIOF_IN,		"brcmf_sdio_oob"},
+};
+
+void __init omap_init_brcmfmac_of(void)
+{
+	if (!of_have_populated_dt())
+		return;
+
+	if (!of_machine_is_compatible("ti,omap4-panda"))
+		return;
+
+	if (gpio_request_array(brcmf_sdio_gpios,
+			       ARRAY_SIZE(brcmf_sdio_gpios))) {
+		pr_err("%s: failed to request gpio array\n", __func__);
+		return;
+	}
+
+	brcmfmac_sdio_pdata.oob_irq_supported = false;
+	platform_device_register(&brcmf_sdio_device);
+}
+
 /*-------------------------------------------------------------------------*/
 
 static int __init omap2_init_devices(void)
@@ -573,6 +606,7 @@ static int __init omap2_init_devices(void)
 	} else {
 		/* These can be removed when bindings are done */
 		omap_init_wl12xx_of();
+		omap_init_brcmfmac_of();
 	}
 	omap_init_sti();
 	omap_init_rng();
-- 
1.7.10.4


--------------000307010108090003000303--

