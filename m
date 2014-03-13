Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaCMJVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:21:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33151 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaCMJUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:20:09 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <nsekhar@ti.com>,
        Jyri Sarha <jsarha@ti.com>, <mporter@linaro.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Subject: [PATCH 14/18] ASoC: davinci: Add edma dmaengine platform driver
Date: Thu, 13 Mar 2014 11:18:36 +0200
Message-ID: <1394702320-21743-15-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform driver glue for SoC using eDMA3 to use dmaengine PCM.
The maximum number of periods need to be limited to 19 since the
edma dmaengine driver limits the paRAM slot use for audio at
in cyclic mode.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/davinci/Kconfig    |  1 +
 sound/soc/davinci/Makefile   |  2 +-
 sound/soc/davinci/edma-pcm.c | 77 ++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/davinci/edma-pcm.h | 26 +++++++++++++++
 4 files changed, 105 insertions(+), 1 deletion(-)
 create mode 100644 sound/soc/davinci/edma-pcm.c
 create mode 100644 sound/soc/davinci/edma-pcm.h

diff --git a/sound/soc/davinci/Kconfig b/sound/soc/davinci/Kconfig
index a8ec1fc3e4d0..f9d9f748e743 100644
--- a/sound/soc/davinci/Kconfig
+++ b/sound/soc/davinci/Kconfig
@@ -1,6 +1,7 @@
 config SND_DAVINCI_SOC
 	tristate "SoC Audio for TI DAVINCI or AM33XX/AM43XX chips"
 	depends on ARCH_DAVINCI || SOC_AM33XX || SOC_AM43XX
+	select SND_SOC_GENERIC_DMAENGINE_PCM
 
 config SND_DAVINCI_SOC_I2S
 	tristate
diff --git a/sound/soc/davinci/Makefile b/sound/soc/davinci/Makefile
index 744d4d9a0184..97d05a2f1723 100644
--- a/sound/soc/davinci/Makefile
+++ b/sound/soc/davinci/Makefile
@@ -1,5 +1,5 @@
 # DAVINCI Platform Support
-snd-soc-davinci-objs := davinci-pcm.o
+snd-soc-davinci-objs := davinci-pcm.o edma-pcm.o
 snd-soc-davinci-i2s-objs := davinci-i2s.o
 snd-soc-davinci-mcasp-objs:= davinci-mcasp.o
 snd-soc-davinci-vcif-objs:= davinci-vcif.o
diff --git a/sound/soc/davinci/edma-pcm.c b/sound/soc/davinci/edma-pcm.c
new file mode 100644
index 000000000000..eeed927a2657
--- /dev/null
+++ b/sound/soc/davinci/edma-pcm.c
@@ -0,0 +1,77 @@
+/*
+ * edma-pcm.c - eDMA PCM driver using dmaengine for AM3xxx, AM4xxx
+ *
+ * Copyright (C) 2014 Texas Instruments, Inc.
+ *
+ * Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
+ *
+ * Based on: sound/soc/tegra/tegra_pcm.c
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
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/dmaengine_pcm.h>
+#include <linux/edma.h>
+
+static const struct snd_pcm_hardware edma_pcm_hardware = {
+	.info			= SNDRV_PCM_INFO_MMAP |
+				  SNDRV_PCM_INFO_MMAP_VALID |
+				  SNDRV_PCM_INFO_BATCH |
+				  SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME |
+				  SNDRV_PCM_INFO_INTERLEAVED,
+	.buffer_bytes_max	= 128 * 1024,
+	.period_bytes_min	= 32,
+	.period_bytes_max	= 64 * 1024,
+	.periods_min		= 2,
+	.periods_max		= 19, /* Limit by edma dmaengine driver */
+};
+
+static const struct snd_dmaengine_pcm_config edma_dmaengine_pcm_config = {
+	.pcm_hardware = &edma_pcm_hardware,
+	.prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config,
+	.prealloc_buffer_size = 128 * 1024,
+};
+
+static const struct snd_dmaengine_pcm_config edma_compat_dmaengine_pcm_config = {
+	.pcm_hardware = &edma_pcm_hardware,
+	.prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config,
+	.compat_filter_fn = edma_filter_fn,
+	.prealloc_buffer_size = 128 * 1024,
+};
+
+int edma_pcm_platform_register(struct device *dev)
+{
+	if (dev->of_node)
+		return snd_dmaengine_pcm_register(dev,
+					&edma_dmaengine_pcm_config,
+					SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);
+	else
+		return snd_dmaengine_pcm_register(dev,
+					&edma_compat_dmaengine_pcm_config,
+					SND_DMAENGINE_PCM_FLAG_NO_RESIDUE |
+					SND_DMAENGINE_PCM_FLAG_NO_DT |
+					SND_DMAENGINE_PCM_FLAG_COMPAT);
+}
+EXPORT_SYMBOL_GPL(edma_pcm_platform_register);
+
+void edma_pcm_platform_unregister(struct device *dev)
+{
+	snd_dmaengine_pcm_unregister(dev);
+}
+EXPORT_SYMBOL_GPL(edma_pcm_platform_unregister);
+
+MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@ti.com>");
+MODULE_DESCRIPTION("eDMA PCM ASoC platform driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/davinci/edma-pcm.h b/sound/soc/davinci/edma-pcm.h
new file mode 100644
index 000000000000..25dc8c7ff093
--- /dev/null
+++ b/sound/soc/davinci/edma-pcm.h
@@ -0,0 +1,26 @@
+/*
+ * edma-pcm.h - eDMA PCM driver using dmaengine for AM3xxx, AM4xxx
+ *
+ * Copyright (C) 2014 Texas Instruments, Inc.
+ *
+ * Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
+ *
+ * Based on: sound/soc/tegra/tegra_pcm.h
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
+#ifndef __EDMA_PCM_H__
+#define __EDMA_PCM_H__
+
+int edma_pcm_platform_register(struct device *dev);
+void edma_pcm_platform_unregister(struct device *dev);
+
+#endif /* __EDMA_PCM_H__ */
-- 
1.9.0

