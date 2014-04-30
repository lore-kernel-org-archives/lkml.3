Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbaD3MBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:01:02 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51653 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758770AbaD3MA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:00:59 -0400
Message-ID: <5360E5E7.8090807@linaro.org>
Date: Wed, 30 Apr 2014 17:30:39 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        sbkim73@samsung.com, rdunlap@infradead.org, dianders@chromium.org
Subject: Re: [PATCH V2] ASoC: SAMSUNG: Add sound card driver for Snow board
References: <1398243705-31151-1-git-send-email-tushar.behera@linaro.org> <20140424133920.GA12304@sirena.org.uk> <5359E18B.60600@linaro.org> <20140429222915.GU15125@sirena.org.uk>
In-Reply-To: <20140429222915.GU15125@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 03:59 AM, Mark Brown wrote:
> On Fri, Apr 25, 2014 at 09:46:11AM +0530, Tushar Behera wrote:
>> On 04/24/2014 07:09 PM, Mark Brown wrote:
> 
>>> defined.  Why is that?  Also, why is the secondary I2S playback stream
>>> not supported (this may be a reason to restrict to only the one I2S
>>> interface)?
> 
>> AFAICS, I2S driver doesn't support secondary DAI with DT (dai type is
>> always TYPE_PRI in case of DT). Hence I could not find a setup to test
>> secondary dai with this board.
> 
> OK, that should be fixed at some point.  I will hopefully be able to
> look at this myself on the Arndale Octa though (or Chromebook or Arndale
> once XCLKOUT is implemented).
> 

XCLKOUT mux register (0x10040a00) is not part of core clock SFR range,
rather it is part of pmu-system-controller node.

One option would be to add a clock provider for XCLKOUT. That would
require me to extend current clock driver to get the
pmu-system-controller phandle which in turn is dependent on the patch to
early initialize syscon driver.[1]

Will it be okay to configure XCLKOUT in snow sound-card driver by taking
the phandle of pmu-system-controller from device tree? The
implementation is provided below.

[1] article.gmane.org/gmane.linux.kernel/1679446

diff --git a/sound/soc/samsung/snow.c b/sound/soc/samsung/snow.c
index 0fa89a4..d7fe7a0 100644
--- a/sound/soc/samsung/snow.c
+++ b/sound/soc/samsung/snow.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/mfd/syscon.h>

 #include <sound/soc.h>

@@ -22,6 +23,10 @@

 #define FIN_PLL_RATE           24000000

+#define XCLKOUT_OFFSET                 0x0a00
+#define XCLKOUT_PARENT_MASK            0x1f00
+#define XCLKOUT_PARENT_XXTI            0x1000
+
 static struct snd_soc_dai_link snow_dai[] = {
        {
                .name = "Primary",
@@ -66,6 +71,7 @@ static int snow_probe(struct platform_device *pdev)
 {
        struct snd_soc_card *card = &snow_snd;
        struct device_node *i2s_node, *codec_node;
+       struct regmap *pmureg;
        int i, ret;

        i2s_node = of_parse_phandle(pdev->dev.of_node,
@@ -84,6 +90,19 @@ static int snow_probe(struct platform_device *pdev)
                return -EINVAL;
        }

+       /*
+        * On Snow board, SoC XCLKOUT line is connected to codec MCLK.
+        * One option would be to add another clock provider to configure
+        * XCLKOUT mux register. Else we can get pmu-syscon phandle from
+        * device tree and update the register here.
+        */
+       pmureg = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
+                       "samsung,pmu-syscon");
+       if (!IS_ERR(pmureg)) {
+               regmap_update_bits(pmureg, XCLKOUT_OFFSET,
+                               XCLKOUT_PARENT_MASK, XCLKOUT_PARENT_XXTI);
+       }
+
        for (i = 0; i < ARRAY_SIZE(snow_dai); i++) {
                snow_dai[i].codec_of_node = codec_node;
                snow_dai[i].cpu_of_node = i2s_node;

-- 
Tushar Behera
