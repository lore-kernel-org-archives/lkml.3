Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaAENJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 08:09:33 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:39663 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaAENJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 08:09:31 -0500
Message-ID: <52C95977.5070400@koalo.de>
Date: Sun, 05 Jan 2014 14:09:11 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC] ASoC: Adding trivial codec drivers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not intended to be a real patch.
I would just like to ask if this is the preferred way 
to add codec and machine driver for codecs without
I2C or SPI configuration possibilities or should I 
rather use a more generic approach?

Grettings,
Florian

 sound/soc/bcm/Kconfig             |  7 +++
 sound/soc/bcm/Makefile            |  2 +
 sound/soc/bcm/rpi-dac.c           | 97 +++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/Kconfig          |  4 ++
 sound/soc/codecs/Makefile         |  2 +
 sound/soc/codecs/pcm1794a.c       | 62 +++++++++++++++++++++++++
 6 files changed, 174 insertions(+)
 create mode 100644 sound/soc/bcm/rpi-dac.c
 create mode 100644 sound/soc/codecs/pcm1794a.c

diff --git a/sound/soc/bcm/Kconfig b/sound/soc/bcm/Kconfig
index 8b14e37..1c1f5cf 100644
--- a/sound/soc/bcm/Kconfig
+++ b/sound/soc/bcm/Kconfig
@@ -15,3 +15,10 @@
+config SND_BCM2708_SOC_RPI_DAC
+        tristate "Support for RPi-DAC"
+        depends on SND_BCM2708_SOC_I2S
+        select SND_SOC_PCM1794A
+        help
+         Say Y or M if you want to add support for RPi-DAC.
\ No newline at end of file
diff --git a/sound/soc/bcm/Makefile b/sound/soc/bcm/Makefile
index 6834b4d..95a9d44 100644
--- a/sound/soc/bcm/Makefile
+++ b/sound/soc/bcm/Makefile
@@ -5,5 +5,7 @@ obj-$(CONFIG_SND_BCM2708_SOC_I2S) += snd-soc-bcm2708-i2s.o
 
+snd-soc-rpi-dac-objs := rpi-dac.o
+obj-$(CONFIG_SND_BCM2708_SOC_RPI_DAC) += snd-soc-rpi-dac.o
diff --git a/sound/soc/bcm/rpi-dac.c b/sound/soc/bcm/rpi-dac.c
new file mode 100644
index 0000000..ef3cd93
--- /dev/null
+++ b/sound/soc/bcm/rpi-dac.c
@@ -0,0 +1,97 @@
+/*
+ * ASoC Driver for RPi-DAC.
+ *
+ * Author:	Florian Meier <florian.meier@koalo.de>
+ *		Copyright 2013
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/jack.h>
+
+static int snd_rpi_rpi_dac_init(struct snd_soc_pcm_runtime *rtd)
+{
+	return 0;
+}
+
+static int snd_rpi_rpi_dac_hw_params(struct snd_pcm_substream *substream,
+				       struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
+
+	return snd_soc_dai_set_bclk_ratio(cpu_dai, 32*2);
+}
+
+/* machine stream operations */
+static struct snd_soc_ops snd_rpi_rpi_dac_ops = {
+	.hw_params = snd_rpi_rpi_dac_hw_params,
+};
+
+static struct snd_soc_dai_link snd_rpi_rpi_dac_dai[] = {
+{
+	.name		= "RPi-DAC",
+	.stream_name	= "RPI-DAC HiFi",
+	.cpu_dai_name	= "bcm2708-i2s.0",
+	.codec_dai_name	= "pcm1794a-hifi",
+	.platform_name	= "bcm2708-i2s.0",
+	.codec_name	= "pcm1794a-codec",
+	.dai_fmt	= SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
+				SND_SOC_DAIFMT_CBS_CFS,
+	.ops		= &snd_rpi_rpi_dac_ops,
+	.init		= snd_rpi_rpi_dac_init,
+},
+};
+
+/* audio machine driver */
+static struct snd_soc_card snd_rpi_rpi_dac = {
+	.name         = "snd_rpi_rpi_dac",
+	.dai_link     = snd_rpi_rpi_dac_dai,
+	.num_links    = ARRAY_SIZE(snd_rpi_rpi_dac_dai),
+};
+
+static int snd_rpi_rpi_dac_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+
+	snd_rpi_rpi_dac.dev = &pdev->dev;
+	ret = snd_soc_register_card(&snd_rpi_rpi_dac);
+	if (ret)
+		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n", ret);
+
+	return ret;
+}
+
+static int snd_rpi_rpi_dac_remove(struct platform_device *pdev)
+{
+	return snd_soc_unregister_card(&snd_rpi_rpi_dac);
+}
+
+static struct platform_driver snd_rpi_rpi_dac_driver = {
+        .driver = {
+                .name   = "snd-rpi-dac",
+                .owner  = THIS_MODULE,
+        },
+        .probe          = snd_rpi_rpi_dac_probe,
+        .remove         = snd_rpi_rpi_dac_remove,
+};
+
+module_platform_driver(snd_rpi_rpi_dac_driver);
+
+MODULE_AUTHOR("Florian Meier <florian.meier@koalo.de>");
+MODULE_DESCRIPTION("ASoC Driver for RPi-DAC");
+MODULE_LICENSE("GPL v2");
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 7c43413..ef9ac1e 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -55,6 +55,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_ML26124 if I2C
 	select SND_SOC_OMAP_HDMI_CODEC if OMAP4_DSS_HDMI
 	select SND_SOC_PCM3008
+	select SND_SOC_PCM1794A
 	select SND_SOC_PCM5102A
 	select SND_SOC_RT5631 if I2C
 	select SND_SOC_SGTL5000 if I2C
@@ -294,6 +295,9 @@ config SND_SOC_OMAP_HDMI_CODEC
 config SND_SOC_PCM3008
        tristate
 
+config SND_SOC_PCM1794A
+	tristate
+
 config SND_SOC_PCM5102A
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 0677eb5..e98b865 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -43,6 +43,7 @@ snd-soc-mc13783-objs := mc13783.o
 snd-soc-ml26124-objs := ml26124.o
 snd-soc-omap-hdmi-codec-objs := omap-hdmi.o
 snd-soc-pcm3008-objs := pcm3008.o
+snd-soc-pcm1794a-objs := pcm1794a.o
 snd-soc-rt5631-objs := rt5631.o
 snd-soc-sgtl5000-objs := sgtl5000.o
@@ -171,6 +172,7 @@ obj-$(CONFIG_SND_SOC_MC13783)	+= snd-soc-mc13783.o
 obj-$(CONFIG_SND_SOC_ML26124)	+= snd-soc-ml26124.o
 obj-$(CONFIG_SND_SOC_OMAP_HDMI_CODEC) += snd-soc-omap-hdmi-codec.o
 obj-$(CONFIG_SND_SOC_PCM3008)	+= snd-soc-pcm3008.o
+obj-$(CONFIG_SND_SOC_PCM1794A)	+= snd-soc-pcm1794a.o
 obj-$(CONFIG_SND_SOC_RT5631)	+= snd-soc-rt5631.o
 obj-$(CONFIG_SND_SOC_SGTL5000)  += snd-soc-sgtl5000.o
diff --git a/sound/soc/codecs/pcm1794a.c b/sound/soc/codecs/pcm1794a.c
new file mode 100644
index 0000000..b4eaa44
--- /dev/null
+++ b/sound/soc/codecs/pcm1794a.c
@@ -0,0 +1,62 @@
+/*
+ * Driver for the PCM1794A codec
+ *
+ * Author:	Florian Meier <florian.meier@koalo.de>
+ *		Copyright 2013
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <sound/soc.h>
+
+static struct snd_soc_dai_driver pcm1794a_dai = {
+	.name = "pcm1794a-hifi",
+	.playback = {
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_8000_192000,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE |
+			   SNDRV_PCM_FMTBIT_S24_LE
+	},
+};
+
+static struct snd_soc_codec_driver soc_codec_dev_pcm1794a;
+
+static int pcm1794a_probe(struct platform_device *pdev)
+{
+	return snd_soc_register_codec(&pdev->dev, &soc_codec_dev_pcm1794a,
+			&pcm1794a_dai, 1);
+}
+
+static int pcm1794a_remove(struct platform_device *pdev)
+{
+	snd_soc_unregister_codec(&pdev->dev);
+	return 0;
+}
+
+static struct platform_driver pcm1794a_codec_driver = {
+	.probe 		= pcm1794a_probe,
+	.remove 	= pcm1794a_remove,
+	.driver		= {
+		.name	= "pcm1794a-codec",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(pcm1794a_codec_driver);
+
+MODULE_DESCRIPTION("ASoC PCM1794A codec driver");
+MODULE_AUTHOR("Florian Meier <florian.meier@koalo.de>");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.2
