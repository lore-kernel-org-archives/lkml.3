Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaKFKUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:20:03 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:57831 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751741AbaKFKTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:19:53 -0500
Date: Thu, 6 Nov 2014 10:18:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kuankuan.Yang" <ykk@rock-chips.com>
Cc: Andy Yan <andy.yan@rock-chips.com>, airlied@linux.ie, heiko@sntech.de,
        fabio.estevam@freescale.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas Stach <l.stach@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        djkurtz@google.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 0/2] make imx hdmi publicly used by dw hdmi compatible
 platform
Message-ID: <20141106101855.GN4042@n2100.arm.linux.org.uk>
References: <1415107992-34289-1-git-send-email-andy.yan@rock-chips.com>
 <20141104142908.GG4042@n2100.arm.linux.org.uk>
 <545B40EC.2030001@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="t0UkRYy7tHLRMCai"
Content-Disposition: inline
In-Reply-To: <545B40EC.2030001@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 06, 2014 at 05:35:40PM +0800, Kuankuan.Yang wrote:
> I'm working on Designware hdmi-audio, also add it as a standard ALSA device.
> Before I saw this email, I also planed to submit my patchs to upsteam.
> I'm very grateful if you can email those patchs to us.

I've attached the set of patches - they're part of a much bigger patch
set for supporting the Cubox-i in mainline, but should apply cleanly.
They're against a 3.17 base rather than 3.18-rc, but I do have these
rebased as 3.18-rc2 based patches too.

I've been waiting for imx-drm to move out of drivers/staging before
deciding where they should live - there seems to be no good place in the
sound/ subtree to place these (sound/soc is not the right place.)

They're being used not only with the SolidRun Cubox-i and Hummingboard,
but also the Novena project too.

One thing the audio part does not yet support is using SDMA on iMX6 to
feed updates to the audio DMA, so this driver should work with other
non-iMX6 SDMA.

Patches 21 to 23 are various attempts to try and fix a problem I've
noticed only on certain iMX6 SoCs (two different revisions of the DW IP
are used in iMX6 depending on whether it's the solo/dual-lite parts, or
the dual/quad parts.)  Inspite of the published errata, I found that the
given workarounds had no useful effect on the problem, and like most
bought-in IP, it's extremely difficult to resolve these kinds of issues
from an open source perspective without having commercial links with
manufacturers to gain access to internal documentation and/or support.

The CEC bits provide a mostly compatible interface with the current FSL
iMX BSP trees, but with a different structure to it, and hopefully less
buggily than the FSL driver.  There has been an effort to add support
for the FSL interface to libcec, but when I've looked at the library,
I've never been impressed by the code, nor by the authors handling of
anything but a clean transmission (which IMHO makes the whole thing
unsafe, especially if you have multiple devices on the CEC bus, you
need the logical ID arbitration to work properly.)

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0018-dw-hdmi-audio-add-audio-driver.patch"

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 018/107] dw-hdmi-audio: add audio driver
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"

Add ALSA based HDMI audio driver for imx-hdmi.  The imx-hdmi is a
Synopsis DesignWare module, so let's name it after that.  The only
buffer format supported is its own special IEC958 based format, which
is not compatible with any ALSA format.  To avoid doing too much data
manipulation within the driver, we support only ALSAs IEC958 LE, and
24-bit PCM formats for 2 to 6 channels.

This allows us to modify the buffer in place as each period is passed
for DMA without needing a separate buffer.

A more desirable solution would be to have this conversion in userspace,
but ALSA does not appear to allow such transformations outside of
libasound itself.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/staging/imx-drm/Kconfig         |   8 +
 drivers/staging/imx-drm/Makefile        |   1 +
 drivers/staging/imx-drm/dw-hdmi-audio.c | 547 ++++++++++++++++++++++++++++++++
 drivers/staging/imx-drm/dw-hdmi-audio.h |  14 +
 drivers/staging/imx-drm/imx-hdmi.c      |  29 ++
 5 files changed, 599 insertions(+)
 create mode 100644 drivers/staging/imx-drm/dw-hdmi-audio.c
 create mode 100644 drivers/staging/imx-drm/dw-hdmi-audio.h

diff --git a/drivers/staging/imx-drm/Kconfig b/drivers/staging/imx-drm/Kconfig
index 82fb758a29bc..008b544b9911 100644
--- a/drivers/staging/imx-drm/Kconfig
+++ b/drivers/staging/imx-drm/Kconfig
@@ -51,3 +51,11 @@ config DRM_IMX_HDMI
 	depends on DRM_IMX
 	help
 	  Choose this if you want to use HDMI on i.MX6.
+
+config DRM_DW_HDMI_AUDIO
+	tristate "Synopsis Designware Audio interface"
+	depends on DRM_IMX_HDMI != n
+	help
+	  Support the Audio interface which is part of the Synopsis
+	  Designware HDMI block.  This is used in conjunction with
+	  the i.MX HDMI driver.
diff --git a/drivers/staging/imx-drm/Makefile b/drivers/staging/imx-drm/Makefile
index 582c438d8cbd..07e65a410f8f 100644
--- a/drivers/staging/imx-drm/Makefile
+++ b/drivers/staging/imx-drm/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_DRM_IMX_LDB) += imx-ldb.o
 imx-ipuv3-crtc-objs  := ipuv3-crtc.o ipuv3-plane.o
 obj-$(CONFIG_DRM_IMX_IPUV3)	+= imx-ipuv3-crtc.o
 obj-$(CONFIG_DRM_IMX_HDMI) += imx-hdmi.o
+obj-$(CONFIG_DRM_DW_HDMI_AUDIO) += dw-hdmi-audio.o
diff --git a/drivers/staging/imx-drm/dw-hdmi-audio.c b/drivers/staging/imx-drm/dw-hdmi-audio.c
new file mode 100644
index 000000000000..4f9790dea6db
--- /dev/null
+++ b/drivers/staging/imx-drm/dw-hdmi-audio.c
@@ -0,0 +1,547 @@
+/*
+ * DesignWare HDMI audio driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Written and tested against the (alleged) DW HDMI Tx found in iMX6S.
+ */
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <sound/asoundef.h>
+#include <sound/core.h>
+#include <sound/initval.h>
+#include <sound/pcm.h>
+
+#include "dw-hdmi-audio.h"
+
+#define DRIVER_NAME "dw-hdmi-audio"
+
+/* Provide some bits rather than bit offsets */
+enum {
+	HDMI_AHB_DMA_CONF0_SW_FIFO_RST = BIT(7),
+	HDMI_AHB_DMA_CONF0_EN_HLOCK = BIT(3),
+	HDMI_AHB_DMA_START_START = BIT(0),
+	HDMI_AHB_DMA_STOP_STOP = BIT(0),
+	HDMI_IH_MUTE_AHBDMAAUD_STAT0_ERROR = BIT(5),
+	HDMI_IH_MUTE_AHBDMAAUD_STAT0_LOST = BIT(4),
+	HDMI_IH_MUTE_AHBDMAAUD_STAT0_RETRY = BIT(3),
+	HDMI_IH_MUTE_AHBDMAAUD_STAT0_DONE = BIT(2),
+	HDMI_IH_MUTE_AHBDMAAUD_STAT0_BUFFFULL = BIT(1),
+	HDMI_IH_MUTE_AHBDMAAUD_STAT0_BUFFEMPTY = BIT(0),
+	HDMI_IH_MUTE_AHBDMAAUD_STAT0_ALL =
+		HDMI_IH_MUTE_AHBDMAAUD_STAT0_ERROR |
+		HDMI_IH_MUTE_AHBDMAAUD_STAT0_LOST |
+		HDMI_IH_MUTE_AHBDMAAUD_STAT0_RETRY |
+		HDMI_IH_MUTE_AHBDMAAUD_STAT0_DONE |
+		HDMI_IH_MUTE_AHBDMAAUD_STAT0_BUFFFULL |
+		HDMI_IH_MUTE_AHBDMAAUD_STAT0_BUFFEMPTY,
+	HDMI_IH_AHBDMAAUD_STAT0_ERROR = BIT(5),
+	HDMI_IH_AHBDMAAUD_STAT0_LOST = BIT(4),
+	HDMI_IH_AHBDMAAUD_STAT0_RETRY = BIT(3),
+	HDMI_IH_AHBDMAAUD_STAT0_DONE = BIT(2),
+	HDMI_IH_AHBDMAAUD_STAT0_BUFFFULL = BIT(1),
+	HDMI_IH_AHBDMAAUD_STAT0_BUFFEMPTY = BIT(0),
+	HDMI_IH_AHBDMAAUD_STAT0_ALL =
+		HDMI_IH_AHBDMAAUD_STAT0_ERROR |
+		HDMI_IH_AHBDMAAUD_STAT0_LOST |
+		HDMI_IH_AHBDMAAUD_STAT0_RETRY |
+		HDMI_IH_AHBDMAAUD_STAT0_DONE |
+		HDMI_IH_AHBDMAAUD_STAT0_BUFFFULL |
+		HDMI_IH_AHBDMAAUD_STAT0_BUFFEMPTY,
+	HDMI_AHB_DMA_CONF0_INCR16 = 2 << 1,
+	HDMI_AHB_DMA_CONF0_INCR8 = 1 << 1,
+	HDMI_AHB_DMA_CONF0_INCR4 = 0,
+	HDMI_AHB_DMA_CONF0_BURST_MODE = BIT(0),
+	HDMI_AHB_DMA_MASK_DONE = BIT(7),
+	HDMI_REVISION_ID = 0x0001,
+	HDMI_IH_AHBDMAAUD_STAT0 = 0x0109,
+	HDMI_IH_MUTE_AHBDMAAUD_STAT0 = 0x0189,
+	HDMI_AHB_DMA_CONF0 = 0x3600,
+	HDMI_AHB_DMA_START = 0x3601,
+	HDMI_AHB_DMA_STOP = 0x3602,
+	HDMI_AHB_DMA_THRSLD = 0x3603,
+	HDMI_AHB_DMA_STRADDR0 = 0x3604,
+	HDMI_AHB_DMA_STPADDR0 = 0x3608,
+	HDMI_AHB_DMA_MASK = 0x3614,
+	HDMI_AHB_DMA_POL = 0x3615,
+	HDMI_AHB_DMA_CONF1 = 0x3616,
+	HDMI_AHB_DMA_BUFFPOL = 0x361a,
+};
+
+struct snd_dw_hdmi {
+	struct snd_card *card;
+	struct snd_pcm *pcm;
+	struct dw_hdmi_audio_data data;
+	struct snd_pcm_substream *substream;
+	void (*reformat)(struct snd_dw_hdmi *, size_t, size_t);
+	void *buf_src;
+	void *buf_dst;
+	dma_addr_t buf_addr;
+	unsigned buf_offset;
+	unsigned buf_period;
+	unsigned buf_size;
+	unsigned channels;
+	uint8_t revision;
+	uint8_t iec_offset;
+	uint8_t cs[192][8];
+};
+
+static void dw_hdmi_writel(unsigned long val, void __iomem *ptr)
+{
+	writeb_relaxed(val, ptr);
+	writeb_relaxed(val >> 8, ptr + 1);
+	writeb_relaxed(val >> 16, ptr + 2);
+	writeb_relaxed(val >> 24, ptr + 3);
+}
+
+/*
+ * Convert to hardware format: The userspace buffer contains IEC958 samples,
+ * with the PCUV bits in bits 31..28 and audio samples in bits 27..4.  We
+ * need these to be in bits 27..24, with the IEC B bit in bit 28, and audio
+ * samples in 23..0.
+ *
+ * Default preamble in bits 3..0: 8 = block start, 4 = even 2 = odd
+ *
+ * Ideally, we could do with having the data properly formatted in userspace.
+ */
+static void dw_hdmi_reformat_iec958(struct snd_dw_hdmi *dw,
+	size_t offset, size_t bytes)
+{
+	uint32_t *src = dw->buf_src + offset;
+	uint32_t *dst = dw->buf_dst + offset;
+	uint32_t *end = dw->buf_src + offset + bytes;
+
+	do {
+		uint32_t b, sample = *src++;
+
+		b = (sample & 8) << (28 - 3);
+
+		sample >>= 4;
+
+		*dst++ = sample | b;
+	} while (src < end);
+}
+
+static uint32_t parity(uint32_t sample)
+{
+	sample ^= sample >> 16;
+	sample ^= sample >> 8;
+	sample ^= sample >> 4;
+	sample ^= sample >> 2;
+	sample ^= sample >> 1;
+	return (sample & 1) << 27;
+}
+
+static void dw_hdmi_reformat_s24(struct snd_dw_hdmi *dw,
+	size_t offset, size_t bytes)
+{
+	uint32_t *src = dw->buf_src + offset;
+	uint32_t *dst = dw->buf_dst + offset;
+	uint32_t *end = dw->buf_src + offset + bytes;
+
+	do {
+		unsigned i;
+		uint8_t *cs;
+
+		cs = dw->cs[dw->iec_offset++];
+		if (dw->iec_offset >= 192)
+			dw->iec_offset = 0;
+
+		i = dw->channels;
+		do {
+			uint32_t sample = *src++;
+
+			sample &= ~0xff000000;
+			sample |= *cs++ << 24;
+			sample |= parity(sample & ~0xf8000000);
+
+			*dst++ = sample;
+		} while (--i);
+	} while (src < end);
+}
+
+static void dw_hdmi_create_cs(struct snd_dw_hdmi *dw,
+	struct snd_pcm_runtime *runtime)
+{
+	uint8_t cs[4];
+	unsigned ch, i, j;
+
+	cs[0] = IEC958_AES0_CON_NOT_COPYRIGHT | IEC958_AES0_CON_EMPHASIS_NONE;
+	cs[1] = IEC958_AES1_CON_GENERAL;
+	cs[2] = IEC958_AES2_CON_SOURCE_UNSPEC;
+	cs[3] = IEC958_AES3_CON_CLOCK_1000PPM;
+
+	switch (runtime->rate) {
+	case 32000:
+		cs[3] |= IEC958_AES3_CON_FS_32000;
+		break;
+	case 44100:
+		cs[3] |= IEC958_AES3_CON_FS_44100;
+		break;
+	case 48000:
+		cs[3] |= IEC958_AES3_CON_FS_48000;
+		break;
+	case 88200:
+		cs[3] |= IEC958_AES3_CON_FS_88200;
+		break;
+	case 96000:
+		cs[3] |= IEC958_AES3_CON_FS_96000;
+		break;
+	case 176400:
+		cs[3] |= IEC958_AES3_CON_FS_176400;
+		break;
+	case 192000:
+		cs[3] |= IEC958_AES3_CON_FS_192000;
+		break;
+	}
+
+	memset(dw->cs, 0, sizeof(dw->cs));
+
+	for (ch = 0; ch < 8; ch++) {
+		cs[2] &= ~IEC958_AES2_CON_CHANNEL;
+		cs[2] |= (ch + 1) << 4;
+
+		for (i = 0; i < ARRAY_SIZE(cs); i++) {
+			unsigned c = cs[i];
+
+			for (j = 0; j < 8; j++, c >>= 1)
+				dw->cs[i * 8 + j][ch] = (c & 1) << 2;
+		}
+	}
+	dw->cs[0][0] |= BIT(4);
+}
+
+static void dw_hdmi_start_dma(struct snd_dw_hdmi *dw)
+{
+	void __iomem *base = dw->data.base;
+	unsigned offset = dw->buf_offset;
+	unsigned period = dw->buf_period;
+	u32 start, stop;
+
+	dw->reformat(dw, offset, period);
+
+	/* Clear all irqs before enabling irqs and starting DMA */
+	writeb_relaxed(HDMI_IH_AHBDMAAUD_STAT0_ALL,
+		       base + HDMI_IH_AHBDMAAUD_STAT0);
+
+	start = dw->buf_addr + offset;
+	stop = start + period - 1;
+
+	/* Setup the hardware start/stop addresses */
+	dw_hdmi_writel(start, base + HDMI_AHB_DMA_STRADDR0);
+	dw_hdmi_writel(stop, base + HDMI_AHB_DMA_STPADDR0);
+
+	writeb_relaxed((u8)~HDMI_AHB_DMA_MASK_DONE, base + HDMI_AHB_DMA_MASK);
+	writeb(HDMI_AHB_DMA_START_START, base + HDMI_AHB_DMA_START);
+
+	offset += period;
+	if (offset >= dw->buf_size)
+		offset = 0;
+	dw->buf_offset = offset;
+}
+
+static void dw_hdmi_stop_dma(struct snd_dw_hdmi *dw)
+{
+	dw->substream = NULL;
+
+	/* Disable interrupts before disabling DMA */
+	writeb_relaxed(~0, dw->data.base + HDMI_AHB_DMA_MASK);
+	writeb_relaxed(HDMI_AHB_DMA_STOP_STOP, dw->data.base + HDMI_AHB_DMA_STOP);
+}
+
+static irqreturn_t snd_dw_hdmi_irq(int irq, void *data)
+{
+	struct snd_dw_hdmi *dw = data;
+	struct snd_pcm_substream *substream;
+	unsigned stat;
+
+	stat = readb_relaxed(dw->data.base + HDMI_IH_AHBDMAAUD_STAT0);
+	if (!stat)
+		return IRQ_NONE;
+
+	writeb_relaxed(stat, dw->data.base + HDMI_IH_AHBDMAAUD_STAT0);
+
+	substream = dw->substream;
+	if (stat & HDMI_IH_AHBDMAAUD_STAT0_DONE && substream) {
+		snd_pcm_period_elapsed(substream);
+		if (dw->substream)
+			dw_hdmi_start_dma(dw);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static struct snd_pcm_hardware dw_hdmi_hw = {
+	.info = SNDRV_PCM_INFO_INTERLEAVED |
+		SNDRV_PCM_INFO_BLOCK_TRANSFER |
+		SNDRV_PCM_INFO_MMAP |
+		SNDRV_PCM_INFO_MMAP_VALID,
+	.formats = SNDRV_PCM_FMTBIT_IEC958_SUBFRAME_LE |
+		   SNDRV_PCM_FMTBIT_S24_LE,
+	.rates = SNDRV_PCM_RATE_32000 |
+		 SNDRV_PCM_RATE_44100 |
+		 SNDRV_PCM_RATE_48000 |
+		 SNDRV_PCM_RATE_88200 |
+		 SNDRV_PCM_RATE_96000 |
+		 SNDRV_PCM_RATE_176400 |
+		 SNDRV_PCM_RATE_192000,
+	.channels_min = 2,
+	.channels_max = 8,
+	.buffer_bytes_max = 64 * 1024,
+	.period_bytes_min = 256,
+	.period_bytes_max = 8192,	/* ERR004323: must limit to 8k */
+	.periods_min = 2,
+	.periods_max = 16,
+	.fifo_size = 0,
+};
+
+static int dw_hdmi_open(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_dw_hdmi *dw = substream->private_data;
+	void __iomem *base = dw->data.base;
+	int ret;
+
+	/* Clear FIFO */
+	writeb_relaxed(HDMI_AHB_DMA_CONF0_SW_FIFO_RST,
+		       base + HDMI_AHB_DMA_CONF0);
+
+	/* Configure interrupt polarities */
+	writeb_relaxed(~0, base + HDMI_AHB_DMA_POL);
+	writeb_relaxed(~0, base + HDMI_AHB_DMA_BUFFPOL);
+
+	/* Keep interrupts masked, and clear any pending */
+	writeb_relaxed(~0, base + HDMI_AHB_DMA_MASK);
+	writeb_relaxed(~0, base + HDMI_IH_AHBDMAAUD_STAT0);
+
+	ret = request_irq(dw->data.irq, snd_dw_hdmi_irq, IRQF_SHARED,
+			  "dw-hdmi-audio", dw);
+	if (ret)
+		return ret;
+
+	/* Un-mute done interrupt */
+	writeb_relaxed(HDMI_IH_MUTE_AHBDMAAUD_STAT0_ALL &
+		       ~HDMI_IH_MUTE_AHBDMAAUD_STAT0_DONE,
+		       base + HDMI_IH_MUTE_AHBDMAAUD_STAT0);
+
+	runtime->hw = dw_hdmi_hw;
+	snd_pcm_limit_hw_rates(runtime);
+
+	return 0;
+}
+
+static int dw_hdmi_close(struct snd_pcm_substream *substream)
+{
+	struct snd_dw_hdmi *dw = substream->private_data;
+
+	/* Mute all interrupts */
+	writeb_relaxed(HDMI_IH_MUTE_AHBDMAAUD_STAT0_ALL,
+		       dw->data.base + HDMI_IH_MUTE_AHBDMAAUD_STAT0);
+
+	free_irq(dw->data.irq, dw);
+
+	return 0;
+}
+
+static int dw_hdmi_hw_free(struct snd_pcm_substream *substream)
+{
+	return snd_pcm_lib_free_vmalloc_buffer(substream);
+}
+
+static int dw_hdmi_hw_params(struct snd_pcm_substream *substream,
+	struct snd_pcm_hw_params *params)
+{
+	return snd_pcm_lib_alloc_vmalloc_buffer(substream,
+						params_buffer_bytes(params));
+}
+
+static int dw_hdmi_prepare(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_dw_hdmi *dw = substream->private_data;
+	uint8_t threshold, conf0, conf1;
+
+	/* Setup as per 3.0.5 FSL 4.1.0 BSP */
+	switch (dw->revision) {
+	case 0x0a:
+		conf0 = HDMI_AHB_DMA_CONF0_BURST_MODE |
+			HDMI_AHB_DMA_CONF0_INCR4;
+		if (runtime->channels == 2)
+			threshold = 126;
+		else
+			threshold = 124;
+		break;
+	case 0x1a:
+		conf0 = HDMI_AHB_DMA_CONF0_BURST_MODE |
+			HDMI_AHB_DMA_CONF0_INCR8;
+		threshold = 128;
+		break;
+	default:
+		/* NOTREACHED */
+		return -EINVAL;
+	}
+
+	dw->data.set_sample_rate(dw->data.hdmi, runtime->rate);
+
+	/* Minimum number of bytes in the fifo. */
+	runtime->hw.fifo_size = threshold * 32;
+
+	conf0 |= HDMI_AHB_DMA_CONF0_EN_HLOCK;
+	conf1 = (1 << runtime->channels) - 1;
+
+	writeb_relaxed(threshold, dw->data.base + HDMI_AHB_DMA_THRSLD);
+	writeb_relaxed(conf0, dw->data.base + HDMI_AHB_DMA_CONF0);
+	writeb_relaxed(conf1, dw->data.base + HDMI_AHB_DMA_CONF1);
+
+	switch (runtime->format) {
+	case SNDRV_PCM_FORMAT_IEC958_SUBFRAME_LE:
+		dw->reformat = dw_hdmi_reformat_iec958;
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		dw_hdmi_create_cs(dw, runtime);
+		dw->reformat = dw_hdmi_reformat_s24;
+		break;
+	}
+	dw->iec_offset = 0;
+	dw->channels = runtime->channels;
+	dw->buf_src  = runtime->dma_area;
+	dw->buf_dst  = substream->dma_buffer.area;
+	dw->buf_addr = substream->dma_buffer.addr;
+	dw->buf_period = snd_pcm_lib_period_bytes(substream);
+	dw->buf_size = snd_pcm_lib_buffer_bytes(substream);
+
+	return 0;
+}
+
+static int dw_hdmi_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	struct snd_dw_hdmi *dw = substream->private_data;
+	int ret = 0;
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+		dw->buf_offset = 0;
+		dw->substream = substream;
+		dw_hdmi_start_dma(dw);
+		substream->runtime->delay = substream->runtime->period_size;
+		break;
+
+	case SNDRV_PCM_TRIGGER_STOP:
+		dw_hdmi_stop_dma(dw);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static snd_pcm_uframes_t dw_hdmi_pointer(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_dw_hdmi *dw = substream->private_data;
+
+	return bytes_to_frames(runtime, dw->buf_offset);
+}
+
+static struct snd_pcm_ops snd_dw_hdmi_ops = {
+	.open = dw_hdmi_open,
+	.close = dw_hdmi_close,
+	.ioctl = snd_pcm_lib_ioctl,
+	.hw_params = dw_hdmi_hw_params,
+	.hw_free = dw_hdmi_hw_free,
+	.prepare = dw_hdmi_prepare,
+	.trigger = dw_hdmi_trigger,
+	.pointer = dw_hdmi_pointer,
+	.page = snd_pcm_lib_get_vmalloc_page,
+};
+
+static int snd_dw_hdmi_probe(struct platform_device *pdev)
+{
+	const struct dw_hdmi_audio_data *data = pdev->dev.platform_data;
+	struct device *dev = pdev->dev.parent;
+	struct snd_dw_hdmi *dw;
+	struct snd_card *card;
+	struct snd_pcm *pcm;
+	unsigned revision;
+	int ret;
+
+	writeb_relaxed(HDMI_IH_MUTE_AHBDMAAUD_STAT0_ALL,
+		       data->base + HDMI_IH_MUTE_AHBDMAAUD_STAT0);
+	revision = readb_relaxed(data->base + HDMI_REVISION_ID);
+	if (revision != 0x0a && revision != 0x1a) {
+		dev_err(dev, "dw-hdmi-audio: unknown revision 0x%02x\n",
+			revision);
+		return -ENXIO;
+	}
+
+	ret = snd_card_new(dev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
+			      THIS_MODULE, sizeof(struct snd_dw_hdmi), &card);
+	if (ret < 0)
+		return ret;
+
+	strlcpy(card->driver, DRIVER_NAME, sizeof(card->driver));
+	strlcpy(card->shortname, "DW-HDMI", sizeof(card->shortname));
+	snprintf(card->longname, sizeof(card->longname),
+		 "%s rev 0x%02x, irq %d", card->shortname, revision,
+		 data->irq);
+
+	dw = card->private_data;
+	dw->card = card;
+	dw->data = *data;
+	dw->revision = revision;
+
+	ret = snd_pcm_new(card, "DW HDMI", 0, 1, 0, &pcm);
+	if (ret < 0)
+		goto err;
+
+	dw->pcm = pcm;
+	pcm->private_data = dw;
+	strlcpy(pcm->name, DRIVER_NAME, sizeof(pcm->name));
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &snd_dw_hdmi_ops);
+
+	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
+			dev, 64 * 1024, 64 * 1024);
+
+	ret = snd_card_register(card);
+	if (ret < 0)
+		goto err;
+
+	platform_set_drvdata(pdev, dw);
+
+	return 0;
+
+err:
+	snd_card_free(card);
+	return ret;
+}
+
+static int snd_dw_hdmi_remove(struct platform_device *pdev)
+{
+	struct snd_dw_hdmi *dw = platform_get_drvdata(pdev);
+
+	snd_card_free(dw->card);
+
+	return 0;
+}
+
+static struct platform_driver snd_dw_hdmi_driver = {
+	.probe	= snd_dw_hdmi_probe,
+	.remove	= snd_dw_hdmi_remove,
+	.driver	= {
+		.name = "dw-hdmi-audio",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(snd_dw_hdmi_driver);
+
+MODULE_AUTHOR("Russell King <rmk+kernel@arm.linux.org.uk>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/imx-drm/dw-hdmi-audio.h b/drivers/staging/imx-drm/dw-hdmi-audio.h
new file mode 100644
index 000000000000..f01979d49efd
--- /dev/null
+++ b/drivers/staging/imx-drm/dw-hdmi-audio.h
@@ -0,0 +1,14 @@
+#ifndef DW_HDMI_AUDIO_H
+#define DW_HDMI_AUDIO_H
+
+struct imx_hdmi;
+
+struct dw_hdmi_audio_data {
+	phys_addr_t phys;
+	void __iomem *base;
+	int irq;
+	struct imx_hdmi *hdmi;
+	void (*set_sample_rate)(struct imx_hdmi *, unsigned);
+};
+
+#endif
diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/staging/imx-drm/imx-hdmi.c
index 18c9ccd460b7..7efca1554d5a 100644
--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/staging/imx-drm/imx-hdmi.c
@@ -29,6 +29,7 @@
 #include <drm/drm_encoder_slave.h>
 #include <video/imx-ipu-v3.h>
 
+#include "dw-hdmi-audio.h"
 #include "imx-hdmi.h"
 #include "imx-drm.h"
 
@@ -115,6 +116,7 @@ struct imx_hdmi {
 	struct drm_connector connector;
 	struct drm_encoder encoder;
 
+	struct platform_device *audio;
 	enum imx_hdmi_devtype dev_type;
 	struct device *dev;
 	struct clk *isfr_clk;
@@ -361,6 +363,12 @@ static void hdmi_clk_regenerator_update_pixel_clock(struct imx_hdmi *hdmi)
 	hdmi_set_clk_regenerator(hdmi, hdmi->hdmi_data.video_mode.mpixelclock);
 }
 
+static void imx_hdmi_set_sample_rate(struct imx_hdmi *hdmi, unsigned rate)
+{
+	hdmi->sample_rate = rate;
+	hdmi_set_clk_regenerator(hdmi, hdmi->hdmi_data.video_mode.mpixelclock);
+}
+
 /*
  * this submodule is responsible for the video data synchronization.
  * for example, for RGB 4:4:4 input, the data map is defined as
@@ -1587,11 +1595,13 @@ MODULE_DEVICE_TABLE(of, imx_hdmi_dt_ids);
 static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
+	struct platform_device_info pdevinfo;
 	const struct of_device_id *of_id =
 				of_match_device(imx_hdmi_dt_ids, dev);
 	struct drm_device *drm = data;
 	struct device_node *np = dev->of_node;
 	struct device_node *ddc_node;
+	struct dw_hdmi_audio_data audio;
 	struct imx_hdmi *hdmi;
 	struct resource *iores;
 	int ret, irq;
@@ -1706,6 +1716,22 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	/* Unmute interrupts */
 	hdmi_writeb(hdmi, ~HDMI_IH_PHY_STAT0_HPD, HDMI_IH_MUTE_PHY_STAT0);
 
+	memset(&pdevinfo, 0, sizeof(pdevinfo));
+	pdevinfo.parent = dev;
+	pdevinfo.id = PLATFORM_DEVID_AUTO;
+
+	audio.phys = iores->start;
+	audio.base = hdmi->regs;
+	audio.irq = irq;
+	audio.hdmi = hdmi;
+	audio.set_sample_rate = imx_hdmi_set_sample_rate;
+
+	pdevinfo.name = "dw-hdmi-audio";
+	pdevinfo.data = &audio;
+	pdevinfo.size_data = sizeof(audio);
+	pdevinfo.dma_mask = DMA_BIT_MASK(32);
+	hdmi->audio = platform_device_register_full(&pdevinfo);
+
 	dev_set_drvdata(dev, hdmi);
 
 	return 0;
@@ -1723,6 +1749,9 @@ static void imx_hdmi_unbind(struct device *dev, struct device *master,
 {
 	struct imx_hdmi *hdmi = dev_get_drvdata(dev);
 
+	if (!IS_ERR(hdmi->audio))
+		platform_device_unregister(hdmi->audio);
+
 	/* Disable all interrupts */
 	hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
 
-- 
1.8.3.1


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0019-drivers-staging-imx-drm-Fix-audio-buffer-sizes.patch"

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 019/107] drivers: staging: imx-drm: Fix audio buffer sizes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"

From: Sean Cross <xobs@kosagi.com>

Pulseaudio connects to dw-hdmi-audio with a period size of 1024 and a
buffer size of 4408 or so.  Because of this, it overruns its buffer and
panics.

Inform ALSA that we'd like the buffer size to be a multiple
of the period size, to prevent this problem.

Signed-off-by: Sean Cross <xobs@kosagi.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/staging/imx-drm/dw-hdmi-audio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/imx-drm/dw-hdmi-audio.c b/drivers/staging/imx-drm/dw-hdmi-audio.c
index 4f9790dea6db..ee3f8c9b5695 100644
--- a/drivers/staging/imx-drm/dw-hdmi-audio.c
+++ b/drivers/staging/imx-drm/dw-hdmi-audio.c
@@ -331,6 +331,7 @@ static int dw_hdmi_open(struct snd_pcm_substream *substream)
 
 	runtime->hw = dw_hdmi_hw;
 	snd_pcm_limit_hw_rates(runtime);
+	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
 
 	return 0;
 }
-- 
1.8.3.1


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0020-dw-hdmi-audio-parse-ELD-from-HDMI-driver.patch"

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 020/107] dw-hdmi-audio: parse ELD from HDMI driver
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"

Parse the ELD (EDID like data) stored from the HDMI driver to restrict
the sample rates and channels which are available to ALSA.  This causes
the ALSA device to reflect the capabilities of the overall audio path,
not just what is supported at the HDMI source interface level.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/staging/imx-drm/dw-hdmi-audio.c | 51 +++++++++++++++++++++++++++++++++
 drivers/staging/imx-drm/dw-hdmi-audio.h |  1 +
 drivers/staging/imx-drm/imx-hdmi.c      |  3 ++
 3 files changed, 55 insertions(+)

diff --git a/drivers/staging/imx-drm/dw-hdmi-audio.c b/drivers/staging/imx-drm/dw-hdmi-audio.c
index ee3f8c9b5695..daa3302d82b3 100644
--- a/drivers/staging/imx-drm/dw-hdmi-audio.c
+++ b/drivers/staging/imx-drm/dw-hdmi-audio.c
@@ -300,6 +300,56 @@ static struct snd_pcm_hardware dw_hdmi_hw = {
 	.fifo_size = 0,
 };
 
+static unsigned rates_mask[] = {
+	SNDRV_PCM_RATE_32000,
+	SNDRV_PCM_RATE_44100,
+	SNDRV_PCM_RATE_48000,
+	SNDRV_PCM_RATE_88200,
+	SNDRV_PCM_RATE_96000,
+	SNDRV_PCM_RATE_176400,
+	SNDRV_PCM_RATE_192000,
+};
+
+static void dw_hdmi_parse_eld(struct snd_dw_hdmi *dw,
+	struct snd_pcm_runtime *runtime)
+{
+	u8 *sad, *eld = dw->data.eld;
+	unsigned eld_ver,  mnl, sad_count, rates, rate_mask, i;
+	unsigned max_channels;
+
+	eld_ver = eld[0] >> 3;
+	if (eld_ver != 2 && eld_ver != 31)
+		return;
+
+	mnl = eld[4] & 0x1f;
+	if (mnl > 16)
+		return;
+
+	sad_count = eld[5] >> 4;
+	sad = eld + 20 + mnl;
+
+	/* Start from the basic audio settings */
+	max_channels = 2;
+	rates = 7;
+	while (sad_count > 0) {
+		switch (sad[0] & 0x78) {
+		case 0x08: /* PCM */
+			max_channels = max(max_channels, (sad[0] & 7) + 1u);
+			rates |= sad[1];
+			break;
+		}
+		sad += 3;
+		sad_count -= 1;
+	}
+
+	for (rate_mask = i = 0; i < ARRAY_SIZE(rates_mask); i++)
+		if (rates & 1 << i)
+			rate_mask |= rates_mask[i];
+
+	runtime->hw.rates &= rate_mask;
+	runtime->hw.channels_max = min(runtime->hw.channels_max, max_channels);
+}
+
 static int dw_hdmi_open(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
@@ -330,6 +380,7 @@ static int dw_hdmi_open(struct snd_pcm_substream *substream)
 		       base + HDMI_IH_MUTE_AHBDMAAUD_STAT0);
 
 	runtime->hw = dw_hdmi_hw;
+	dw_hdmi_parse_eld(dw, runtime);
 	snd_pcm_limit_hw_rates(runtime);
 	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
 
diff --git a/drivers/staging/imx-drm/dw-hdmi-audio.h b/drivers/staging/imx-drm/dw-hdmi-audio.h
index f01979d49efd..2d91d709381d 100644
--- a/drivers/staging/imx-drm/dw-hdmi-audio.h
+++ b/drivers/staging/imx-drm/dw-hdmi-audio.h
@@ -8,6 +8,7 @@ struct dw_hdmi_audio_data {
 	void __iomem *base;
 	int irq;
 	struct imx_hdmi *hdmi;
+	u8 *eld;
 	void (*set_sample_rate)(struct imx_hdmi *, unsigned);
 };
 
diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/staging/imx-drm/imx-hdmi.c
index 7efca1554d5a..412026c3f9f9 100644
--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/staging/imx-drm/imx-hdmi.c
@@ -1408,6 +1408,8 @@ static int imx_hdmi_connector_get_modes(struct drm_connector *connector)
 
 		drm_mode_connector_update_edid_property(connector, edid);
 		ret = drm_add_edid_modes(connector, edid);
+		/* Store the ELD */
+		drm_edid_to_eld(connector, edid);
 		kfree(edid);
 	} else {
 		dev_dbg(hdmi->dev, "failed to get edid\n");
@@ -1724,6 +1726,7 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	audio.base = hdmi->regs;
 	audio.irq = irq;
 	audio.hdmi = hdmi;
+	audio.eld = hdmi->connector.eld;
 	audio.set_sample_rate = imx_hdmi_set_sample_rate;
 
 	pdevinfo.name = "dw-hdmi-audio";
-- 
1.8.3.1


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0021-dw-hdmi-audio-try-to-fix-burbling-audio.patch"

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 021/107] dw-hdmi-audio: try to fix burbling audio
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/staging/imx-drm/dw-hdmi-audio.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/staging/imx-drm/dw-hdmi-audio.c b/drivers/staging/imx-drm/dw-hdmi-audio.c
index daa3302d82b3..c2ec8213f8e1 100644
--- a/drivers/staging/imx-drm/dw-hdmi-audio.c
+++ b/drivers/staging/imx-drm/dw-hdmi-audio.c
@@ -61,6 +61,7 @@ enum {
 	HDMI_REVISION_ID = 0x0001,
 	HDMI_IH_AHBDMAAUD_STAT0 = 0x0109,
 	HDMI_IH_MUTE_AHBDMAAUD_STAT0 = 0x0189,
+	HDMI_AUD_N1 = 0x3200,
 	HDMI_AHB_DMA_CONF0 = 0x3600,
 	HDMI_AHB_DMA_START = 0x3601,
 	HDMI_AHB_DMA_STOP = 0x3602,
@@ -480,6 +481,13 @@ static int dw_hdmi_trigger(struct snd_pcm_substream *substream, int cmd)
 		dw->buf_offset = 0;
 		dw->substream = substream;
 		dw_hdmi_start_dma(dw);
+		if (dw->revision == 0x0a) {
+			void __iomem *base = dw->data.base;
+			unsigned val;
+
+			val = readb_relaxed(base + HDMI_AUD_N1);
+			writeb_relaxed(val, base + HDMI_AUD_N1);
+		}
 		substream->runtime->delay = substream->runtime->period_size;
 		break;
 
-- 
1.8.3.1


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0022-dw-hdmi-audio-try-implementing-ERR005174-to-fix-burb.patch"

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 022/107] dw-hdmi-audio: try implementing ERR005174 to fix
 burbling audio
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/staging/imx-drm/dw-hdmi-audio.c | 35 +++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/imx-drm/dw-hdmi-audio.c b/drivers/staging/imx-drm/dw-hdmi-audio.c
index c2ec8213f8e1..77094d674a55 100644
--- a/drivers/staging/imx-drm/dw-hdmi-audio.c
+++ b/drivers/staging/imx-drm/dw-hdmi-audio.c
@@ -7,6 +7,7 @@
  *
  * Written and tested against the (alleged) DW HDMI Tx found in iMX6S.
  */
+#include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
@@ -68,6 +69,8 @@ enum {
 	HDMI_AHB_DMA_THRSLD = 0x3603,
 	HDMI_AHB_DMA_STRADDR0 = 0x3604,
 	HDMI_AHB_DMA_STPADDR0 = 0x3608,
+	HDMI_AHB_DMA_STAT = 0x3612,
+	HDMI_AHB_DMA_STAT_FULL = BIT(1),
 	HDMI_AHB_DMA_MASK = 0x3614,
 	HDMI_AHB_DMA_POL = 0x3615,
 	HDMI_AHB_DMA_CONF1 = 0x3616,
@@ -474,20 +477,40 @@ static int dw_hdmi_prepare(struct snd_pcm_substream *substream)
 static int dw_hdmi_trigger(struct snd_pcm_substream *substream, int cmd)
 {
 	struct snd_dw_hdmi *dw = substream->private_data;
-	int ret = 0;
+	void __iomem *base = dw->data.base;
+	unsigned val[3];
+	unsigned timeout = 10000;
+	int ret = 0, i;
+	bool err005174;
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
+		err005174 = dw->revision == 0x0a;
+		if (err005174) {
+			for (i = 2; i >= 0; i--) {
+				val[i] = readb_relaxed(base + HDMI_AUD_N1 + i);
+				writeb_relaxed(0, base + HDMI_AUD_N1 + i);
+			}
+		}
+
 		dw->buf_offset = 0;
 		dw->substream = substream;
 		dw_hdmi_start_dma(dw);
-		if (dw->revision == 0x0a) {
-			void __iomem *base = dw->data.base;
-			unsigned val;
 
-			val = readb_relaxed(base + HDMI_AUD_N1);
-			writeb_relaxed(val, base + HDMI_AUD_N1);
+		if (err005174) {
+			do {
+				if (readb_relaxed(base + HDMI_AHB_DMA_STAT) & HDMI_AHB_DMA_STAT_FULL)
+					break;
+				udelay(1);
+			} while (timeout--);
+
+			if (!(readb_relaxed(base + HDMI_AHB_DMA_STAT) & HDMI_AHB_DMA_STAT_FULL))
+				pr_info("timeout!\n");
+
+			for (i = 2; i >= 0; i--)
+				writeb_relaxed(val[i], base + HDMI_AUD_N1 + i);
 		}
+
 		substream->runtime->delay = substream->runtime->period_size;
 		break;
 
-- 
1.8.3.1


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0023-dw-hdmi-audio-another-attempt-at-fixing-burbling.patch"

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 023/107] dw-hdmi-audio: another attempt at fixing burbling
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/staging/imx-drm/dw-hdmi-audio.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/imx-drm/dw-hdmi-audio.c b/drivers/staging/imx-drm/dw-hdmi-audio.c
index 77094d674a55..967c3d6bf8cf 100644
--- a/drivers/staging/imx-drm/dw-hdmi-audio.c
+++ b/drivers/staging/imx-drm/dw-hdmi-audio.c
@@ -63,6 +63,7 @@ enum {
 	HDMI_IH_AHBDMAAUD_STAT0 = 0x0109,
 	HDMI_IH_MUTE_AHBDMAAUD_STAT0 = 0x0189,
 	HDMI_AUD_N1 = 0x3200,
+	HDMI_AUD_CTS1 = 0x3203,
 	HDMI_AHB_DMA_CONF0 = 0x3600,
 	HDMI_AHB_DMA_START = 0x3601,
 	HDMI_AHB_DMA_STOP = 0x3602,
@@ -478,8 +479,7 @@ static int dw_hdmi_trigger(struct snd_pcm_substream *substream, int cmd)
 {
 	struct snd_dw_hdmi *dw = substream->private_data;
 	void __iomem *base = dw->data.base;
-	unsigned val[3];
-	unsigned timeout = 10000;
+	unsigned n[3], cts[3];
 	int ret = 0, i;
 	bool err005174;
 
@@ -487,9 +487,11 @@ static int dw_hdmi_trigger(struct snd_pcm_substream *substream, int cmd)
 	case SNDRV_PCM_TRIGGER_START:
 		err005174 = dw->revision == 0x0a;
 		if (err005174) {
-			for (i = 2; i >= 0; i--) {
-				val[i] = readb_relaxed(base + HDMI_AUD_N1 + i);
+			for (i = 2; i >= 1; i--) {
+				n[i] = readb_relaxed(base + HDMI_AUD_N1 + i);
+				cts[i] = readb_relaxed(base + HDMI_AUD_CTS1 + i);
 				writeb_relaxed(0, base + HDMI_AUD_N1 + i);
+				writeb_relaxed(0, base + HDMI_AUD_CTS1 + i);
 			}
 		}
 
@@ -498,17 +500,10 @@ static int dw_hdmi_trigger(struct snd_pcm_substream *substream, int cmd)
 		dw_hdmi_start_dma(dw);
 
 		if (err005174) {
-			do {
-				if (readb_relaxed(base + HDMI_AHB_DMA_STAT) & HDMI_AHB_DMA_STAT_FULL)
-					break;
-				udelay(1);
-			} while (timeout--);
-
-			if (!(readb_relaxed(base + HDMI_AHB_DMA_STAT) & HDMI_AHB_DMA_STAT_FULL))
-				pr_info("timeout!\n");
-
-			for (i = 2; i >= 0; i--)
-				writeb_relaxed(val[i], base + HDMI_AUD_N1 + i);
+			for (i = 2; i >= 1; i--)
+				writeb_relaxed(cts[i], base + HDMI_AUD_CTS1 + i);
+			for (i = 2; i >= 1; i--)
+				writeb_relaxed(n[i], base + HDMI_AUD_N1 + i);
 		}
 
 		substream->runtime->delay = substream->runtime->period_size;
-- 
1.8.3.1


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0024-dw-hdmi-audio-basic-suspend-resume-support.patch"

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 024/107] dw-hdmi-audio: basic suspend/resume support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/staging/imx-drm/dw-hdmi-audio.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/staging/imx-drm/dw-hdmi-audio.c b/drivers/staging/imx-drm/dw-hdmi-audio.c
index 967c3d6bf8cf..5243d51b4069 100644
--- a/drivers/staging/imx-drm/dw-hdmi-audio.c
+++ b/drivers/staging/imx-drm/dw-hdmi-audio.c
@@ -610,12 +610,40 @@ static int snd_dw_hdmi_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int snd_dw_hdmi_suspend(struct device *dev)
+{
+	struct snd_dw_hdmi *dw = dev_get_drvdata(dev);
+
+	snd_power_change_state(dw->card, SNDRV_CTL_POWER_D3cold);
+	snd_pcm_suspend_all(dw->pcm);
+
+	return 0;
+}
+
+static int snd_dw_hdmi_resume(struct device *dev)
+{
+	struct snd_dw_hdmi *dw = dev_get_drvdata(dev);
+
+	snd_power_change_state(dw->card, SNDRV_CTL_POWER_D0);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(snd_dw_hdmi_pm, snd_dw_hdmi_suspend,
+			 snd_dw_hdmi_resume);
+#define PM_OPS &snd_dw_hdmi_pm
+#else
+#define PM_OPS NULL
+#endif
+
 static struct platform_driver snd_dw_hdmi_driver = {
 	.probe	= snd_dw_hdmi_probe,
 	.remove	= snd_dw_hdmi_remove,
 	.driver	= {
 		.name = "dw-hdmi-audio",
 		.owner = THIS_MODULE,
+		.pm = PM_OPS,
 	},
 };
 
-- 
1.8.3.1


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0025-cec-add-generic-HDMI-CEC-driver.patch"

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 025/107] cec: add generic HDMI CEC driver
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"

Add a generic userspace API to support HDMI Consumer Electronics Control
interfaces.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/Kconfig              |   2 +
 drivers/Makefile             |   1 +
 drivers/cec/Kconfig          |  14 ++
 drivers/cec/Makefile         |   1 +
 drivers/cec/cec-dev.c        | 384 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/cec-dev.h      |  69 ++++++++
 include/uapi/linux/cec-dev.h |  34 ++++
 7 files changed, 505 insertions(+)
 create mode 100644 drivers/cec/Kconfig
 create mode 100644 drivers/cec/Makefile
 create mode 100644 drivers/cec/cec-dev.c
 create mode 100644 include/linux/cec-dev.h
 create mode 100644 include/uapi/linux/cec-dev.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 622fa266b29e..fa2b20ba644f 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -176,6 +176,8 @@ source "drivers/powercap/Kconfig"
 
 source "drivers/mcb/Kconfig"
 
+source "drivers/cec/Kconfig"
+
 source "drivers/ras/Kconfig"
 
 source "drivers/thunderbolt/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index ebee55537a05..b8208b267615 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -159,5 +159,6 @@ obj-$(CONFIG_NTB)		+= ntb/
 obj-$(CONFIG_FMC)		+= fmc/
 obj-$(CONFIG_POWERCAP)		+= powercap/
 obj-$(CONFIG_MCB)		+= mcb/
+obj-$(CONFIG_CEC)		+= cec/
 obj-$(CONFIG_RAS)		+= ras/
 obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
diff --git a/drivers/cec/Kconfig b/drivers/cec/Kconfig
new file mode 100644
index 000000000000..d67cfb83de6a
--- /dev/null
+++ b/drivers/cec/Kconfig
@@ -0,0 +1,14 @@
+#
+# Consumer Electroncs Control support
+#
+
+menu "Consumer Electronics Control devices"
+
+config CEC
+	bool
+
+config HDMI_CEC_CORE
+	tristate
+	select CEC
+
+endmenu
diff --git a/drivers/cec/Makefile b/drivers/cec/Makefile
new file mode 100644
index 000000000000..b94278bc8321
--- /dev/null
+++ b/drivers/cec/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_HDMI_CEC_CORE) += cec-dev.o
diff --git a/drivers/cec/cec-dev.c b/drivers/cec/cec-dev.c
new file mode 100644
index 000000000000..ba58d8217851
--- /dev/null
+++ b/drivers/cec/cec-dev.c
@@ -0,0 +1,384 @@
+/*
+ * HDMI Consumer Electronics Control
+ *
+ * This provides the user API for communication with HDMI CEC complaint
+ * devices in kernel drivers, and is based upon the protocol developed
+ * by Freescale for their i.MX SoCs.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/cec-dev.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+struct cec_event {
+	struct cec_user_event usr;
+	struct list_head node;
+};
+
+static struct class *cec_class;
+static int cec_major;
+
+static void cec_dev_send_message(struct cec_dev *cec_dev, u8 *msg,
+	size_t count)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cec_dev->lock, flags);
+	cec_dev->retries = 5;
+	cec_dev->write_busy = 1;
+	cec_dev->send_message(cec_dev, msg, count);
+	spin_unlock_irqrestore(&cec_dev->lock, flags);
+}
+
+void cec_dev_event(struct cec_dev *cec_dev, int type, u8 *msg, size_t len)
+{
+	struct cec_event *event;
+	unsigned long flags;
+
+	event = kzalloc(sizeof(*event), GFP_ATOMIC);
+	if (event) {
+		event->usr.event_type = type;
+		event->usr.msg_len = len;
+		if (msg)
+			memcpy(event->usr.msg, msg, len);
+
+		spin_lock_irqsave(&cec_dev->lock, flags);
+		list_add_tail(&event->node, &cec_dev->events);
+		spin_unlock_irqrestore(&cec_dev->lock, flags);
+		wake_up(&cec_dev->waitq);
+	}
+}
+EXPORT_SYMBOL_GPL(cec_dev_event);
+
+static int cec_dev_lock_write(struct cec_dev *cec_dev, struct file *file)
+	__acquires(cec_dev->mutex)
+{
+	int ret;
+
+	do {
+		if (file->f_flags & O_NONBLOCK) {
+			if (cec_dev->write_busy)
+				return -EAGAIN;
+		} else {
+			ret = wait_event_interruptible(cec_dev->waitq,
+						       !cec_dev->write_busy);
+			if (ret)
+				break;
+		}
+
+		ret = mutex_lock_interruptible(&cec_dev->mutex);
+		if (ret)
+			break;
+
+		if (!cec_dev->write_busy)
+			break;
+
+		mutex_unlock(&cec_dev->mutex);
+	} while (1);
+
+	return ret;
+}
+
+static ssize_t cec_dev_read(struct file *file, char __user *buf,
+	size_t count, loff_t *ppos)
+{
+	struct cec_dev *cec_dev = file->private_data;
+	ssize_t ret;
+
+	if (count > sizeof(struct cec_user_event))
+		count = sizeof(struct cec_user_event);
+
+	if (!access_ok(VERIFY_WRITE, buf, count))
+		return -EFAULT;
+
+	do {
+		struct cec_event *event = NULL;
+		unsigned long flags;
+
+		spin_lock_irqsave(&cec_dev->lock, flags);
+		if (!list_empty(&cec_dev->events)) {
+			event = list_first_entry(&cec_dev->events,
+					struct cec_event, node);
+			list_del(&event->node);
+		}
+		spin_unlock_irqrestore(&cec_dev->lock, flags);
+
+		if (event) {
+			ret = __copy_to_user(buf, &event->usr, count) ?
+				 -EFAULT : count;
+			kfree(event);
+			break;
+		}
+
+		if (file->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
+			break;
+		}
+
+		ret = wait_event_interruptible(cec_dev->waitq,
+					       !list_empty(&cec_dev->events));
+		if (ret)
+			break;
+	} while (1);
+
+	return ret;
+}
+
+static ssize_t cec_dev_write(struct file *file, const char __user *buf,
+	size_t count, loff_t *ppos)
+{
+	struct cec_dev *cec_dev = file->private_data;
+	u8 msg[MAX_MESSAGE_LEN];
+	int ret;
+
+	if (count > sizeof(msg))
+		return -E2BIG;
+
+	if (copy_from_user(msg, buf, count))
+		return -EFAULT;
+
+	ret = cec_dev_lock_write(cec_dev, file);
+	if (ret)
+		return ret;
+
+	cec_dev_send_message(cec_dev, msg, count);
+
+	mutex_unlock(&cec_dev->mutex);
+
+	return count;
+}
+
+static long cec_dev_ioctl(struct file *file, u_int cmd, unsigned long arg)
+{
+	struct cec_dev *cec_dev = file->private_data;
+	int ret;
+
+	switch (cmd) {
+	case HDMICEC_IOC_O_SETLOGICALADDRESS:
+	case HDMICEC_IOC_SETLOGICALADDRESS:
+		if (arg > 15) {
+			ret = -EINVAL;
+			break;
+		}
+
+		ret = cec_dev_lock_write(cec_dev, file);
+		if (ret == 0) {
+			unsigned char msg[1];
+
+			cec_dev->addresses = BIT(arg);
+			cec_dev->set_address(cec_dev, cec_dev->addresses);
+
+			/*
+			 * Send a ping message with the source and destination
+			 * set to our address; the result indicates whether
+			 * unit has chosen our address simultaneously.
+			 */
+			msg[0] = arg << 4 | arg;
+			cec_dev_send_message(cec_dev, msg, sizeof(msg));
+			mutex_unlock(&cec_dev->mutex);
+		}
+		break;
+
+	case HDMICEC_IOC_STARTDEVICE:
+		ret = mutex_lock_interruptible(&cec_dev->mutex);
+		if (ret == 0) {
+			cec_dev->addresses = BIT(15);
+			cec_dev->set_address(cec_dev, cec_dev->addresses);
+			mutex_unlock(&cec_dev->mutex);
+		}
+		break;
+
+	case HDMICEC_IOC_STOPDEVICE:
+		ret = 0;
+		break;
+
+	case HDMICEC_IOC_GETPHYADDRESS:
+		ret = put_user(cec_dev->physical, (u16 __user *)arg);
+		ret = -ENOIOCTLCMD;
+		break;
+
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+
+	return ret;
+}
+
+static unsigned cec_dev_poll(struct file *file, poll_table *wait)
+{
+	struct cec_dev *cec_dev = file->private_data;
+	unsigned mask = 0;
+
+	poll_wait(file, &cec_dev->waitq, wait);
+
+	if (cec_dev->write_busy == 0)
+		mask |= POLLOUT | POLLWRNORM;
+	if (!list_empty(&cec_dev->events))
+		mask |= POLLIN | POLLRDNORM;
+
+	return mask;
+}
+
+static int cec_dev_release(struct inode *inode, struct file *file)
+{
+	struct cec_dev *cec_dev = file->private_data;
+
+	mutex_lock(&cec_dev->mutex);
+	if (cec_dev->users >= 1)
+		cec_dev->users -= 1;
+	if (cec_dev->users == 0) {
+		/*
+		 * Wait for any write to complete before shutting down.
+		 * A message should complete in a maximum of 2.75ms *
+		 * 160 bits + 4.7ms, or 444.7ms.  Let's call that 500ms.
+		 * If we time out, shutdown anyway.
+		 */
+		wait_event_timeout(cec_dev->waitq, !cec_dev->write_busy,
+				   msecs_to_jiffies(500));
+
+		cec_dev->release(cec_dev);
+
+		while (!list_empty(&cec_dev->events)) {
+			struct cec_event *event;
+
+			event = list_first_entry(&cec_dev->events,
+					struct cec_event, node);
+			list_del(&event->node);
+			kfree(event);
+		}
+	}
+	mutex_unlock(&cec_dev->mutex);
+	return 0;
+}
+
+static int cec_dev_open(struct inode *inode, struct file *file)
+{
+	struct cec_dev *cec_dev = container_of(inode->i_cdev, struct cec_dev,
+					       cdev);
+	int ret = 0;
+
+	nonseekable_open(inode, file);
+
+	file->private_data = cec_dev;
+
+	ret = mutex_lock_interruptible(&cec_dev->mutex);
+	if (ret)
+		return ret;
+
+	if (cec_dev->users++ == 0) {
+		cec_dev->addresses = BIT(15);
+
+		ret = cec_dev->open(cec_dev);
+		if (ret < 0)
+			cec_dev->users = 0;
+	}
+	mutex_unlock(&cec_dev->mutex);
+
+	return ret;
+}
+
+static const struct file_operations hdmi_cec_fops = {
+	.owner = THIS_MODULE,
+	.read = cec_dev_read,
+	.write = cec_dev_write,
+	.open = cec_dev_open,
+	.unlocked_ioctl = cec_dev_ioctl,
+	.release = cec_dev_release,
+	.poll = cec_dev_poll,
+};
+
+void cec_dev_init(struct cec_dev *cec_dev, struct module *module)
+{
+	cec_dev->devn = MKDEV(cec_major, 0);
+
+	INIT_LIST_HEAD(&cec_dev->events);
+	init_waitqueue_head(&cec_dev->waitq);
+	spin_lock_init(&cec_dev->lock);
+	mutex_init(&cec_dev->mutex);
+
+	cec_dev->addresses = BIT(15);
+
+	cdev_init(&cec_dev->cdev, &hdmi_cec_fops);
+	cec_dev->cdev.owner = module;
+}
+EXPORT_SYMBOL_GPL(cec_dev_init);
+
+int cec_dev_add(struct cec_dev *cec_dev, struct device *dev, const char *name)
+{
+	struct device *cd;
+	int ret;
+
+	ret = cdev_add(&cec_dev->cdev, cec_dev->devn, 1);
+	if (ret < 0)
+		goto err_cdev;
+
+	cd = device_create(cec_class, dev, cec_dev->devn, NULL, name);
+	if (IS_ERR(cd)) {
+		ret = PTR_ERR(cd);
+		dev_err(dev, "can't create device: %d\n", ret);
+		goto err_dev;
+	}
+
+	return 0;
+
+ err_dev:
+	cdev_del(&cec_dev->cdev);
+ err_cdev:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cec_dev_add);
+
+void cec_dev_remove(struct cec_dev *cec_dev)
+{
+	device_destroy(cec_class, cec_dev->devn);
+	cdev_del(&cec_dev->cdev);
+}
+EXPORT_SYMBOL_GPL(cec_dev_remove);
+
+static int cec_init(void)
+{
+	dev_t dev;
+	int ret;
+
+	cec_class = class_create(THIS_MODULE, "hdmi-cec");
+	if (IS_ERR(cec_class)) {
+		ret = PTR_ERR(cec_class);
+		pr_err("cec: can't create cec class: %d\n", ret);
+		goto err_class;
+	}
+
+	ret = alloc_chrdev_region(&dev, 0, 1, "hdmi-cec");
+	if (ret) {
+		pr_err("cec: can't create character devices: %d\n", ret);
+		goto err_chrdev;
+	}
+
+	cec_major = MAJOR(dev);
+
+	return 0;
+
+ err_chrdev:
+	class_destroy(cec_class);
+ err_class:
+	return ret;
+}
+subsys_initcall(cec_init);
+
+static void cec_exit(void)
+{
+	unregister_chrdev_region(MKDEV(cec_major, 0), 1);
+	class_destroy(cec_class);
+}
+module_exit(cec_exit);
+
+MODULE_AUTHOR("Russell King <rmk+kernel@arm.linux.org.uk>");
+MODULE_DESCRIPTION("Generic HDMI CEC driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/cec-dev.h b/include/linux/cec-dev.h
new file mode 100644
index 000000000000..76a7d7f6a72d
--- /dev/null
+++ b/include/linux/cec-dev.h
@@ -0,0 +1,69 @@
+#ifndef _LINUX_CEC_DEV_H
+#define _LINUX_CEC_DEV_H
+
+#include <linux/cdev.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+
+#include <uapi/linux/cec-dev.h>
+
+struct device;
+
+struct cec_dev {
+	struct cdev cdev;
+	dev_t devn;
+
+	struct mutex mutex;
+	unsigned users;
+
+	spinlock_t lock;
+	wait_queue_head_t waitq;
+	struct list_head events;
+	u8 write_busy;
+
+	u8 retries;
+	u16 addresses;
+	u16 physical;
+
+	int (*open)(struct cec_dev *);
+	void (*release)(struct cec_dev *);
+	void (*send_message)(struct cec_dev *, u8 *, size_t);
+	void (*set_address)(struct cec_dev *, unsigned);
+};
+
+void cec_dev_event(struct cec_dev *cec_dev, int type, u8 *msg, size_t len);
+
+static inline void cec_dev_receive(struct cec_dev *cec_dev, u8 *msg,
+	unsigned len)
+{
+	cec_dev_event(cec_dev, MESSAGE_TYPE_RECEIVE_SUCCESS, msg, len);
+}
+
+static inline void cec_dev_send_complete(struct cec_dev *cec_dev, int ack)
+{
+	cec_dev->retries = 0;
+	cec_dev->write_busy = 0;
+
+	cec_dev_event(cec_dev, ack ? MESSAGE_TYPE_SEND_SUCCESS :
+		      MESSAGE_TYPE_NOACK, NULL, 0);
+}
+
+static inline void cec_dev_disconnect(struct cec_dev *cec_dev)
+{
+	cec_dev->physical = 0;
+	cec_dev_event(cec_dev, MESSAGE_TYPE_DISCONNECTED, NULL, 0);
+}
+
+static inline void cec_dev_connect(struct cec_dev *cec_dev, u32 phys)
+{
+	cec_dev->physical = phys;
+	cec_dev_event(cec_dev, MESSAGE_TYPE_CONNECTED, NULL, 0);
+}
+
+void cec_dev_init(struct cec_dev *cec_dev, struct module *);
+int cec_dev_add(struct cec_dev *cec_dev, struct device *, const char *name);
+void cec_dev_remove(struct cec_dev *cec_dev);
+
+#endif
diff --git a/include/uapi/linux/cec-dev.h b/include/uapi/linux/cec-dev.h
new file mode 100644
index 000000000000..fb7a41704c77
--- /dev/null
+++ b/include/uapi/linux/cec-dev.h
@@ -0,0 +1,34 @@
+#ifndef _UAPI_LINUX_CEC_DEV_H
+#define _UAPI_LINUX_CEC_DEV_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+#define MAX_MESSAGE_LEN 16
+
+enum {
+	HDMICEC_IOC_MAGIC = 'H',
+	/* This is wrong: we pass the argument as a number, not a pointer */
+	HDMICEC_IOC_O_SETLOGICALADDRESS	= _IOW(HDMICEC_IOC_MAGIC, 1, unsigned char),
+	HDMICEC_IOC_SETLOGICALADDRESS	= _IO(HDMICEC_IOC_MAGIC, 1),
+	HDMICEC_IOC_STARTDEVICE		= _IO(HDMICEC_IOC_MAGIC, 2),
+	HDMICEC_IOC_STOPDEVICE		= _IO(HDMICEC_IOC_MAGIC, 3),
+	HDMICEC_IOC_GETPHYADDRESS	= _IOR(HDMICEC_IOC_MAGIC, 4, unsigned char[4]),
+};
+
+enum {
+	MESSAGE_TYPE_RECEIVE_SUCCESS = 1,
+	MESSAGE_TYPE_NOACK,
+	MESSAGE_TYPE_DISCONNECTED,
+	MESSAGE_TYPE_CONNECTED,
+	MESSAGE_TYPE_SEND_SUCCESS,
+	MESSAGE_TYPE_SEND_ERROR,
+};
+
+struct cec_user_event {
+	__u32 event_type;
+	__u32 msg_len;
+	__u8 msg[MAX_MESSAGE_LEN];
+};
+
+#endif
-- 
1.8.3.1


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0026-imx-drm-dw-hdmi-cec-add-HDMI-CEC-driver.patch"

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 026/107] imx-drm: dw-hdmi-cec: add HDMI CEC driver
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"

This adds a HDMI Consumer Electronics Control driver, making use of the
generic HDMI CEC driver to provide a common user API for these devices.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/staging/imx-drm/Kconfig       |   9 ++
 drivers/staging/imx-drm/Makefile      |   1 +
 drivers/staging/imx-drm/dw-hdmi-cec.c | 207 ++++++++++++++++++++++++++++++++++
 drivers/staging/imx-drm/dw-hdmi-cec.h |  16 +++
 drivers/staging/imx-drm/imx-hdmi.c    |  63 +++++++++--
 5 files changed, 286 insertions(+), 10 deletions(-)
 create mode 100644 drivers/staging/imx-drm/dw-hdmi-cec.c
 create mode 100644 drivers/staging/imx-drm/dw-hdmi-cec.h

diff --git a/drivers/staging/imx-drm/Kconfig b/drivers/staging/imx-drm/Kconfig
index 008b544b9911..6238165f0b22 100644
--- a/drivers/staging/imx-drm/Kconfig
+++ b/drivers/staging/imx-drm/Kconfig
@@ -59,3 +59,12 @@ config DRM_DW_HDMI_AUDIO
 	  Support the Audio interface which is part of the Synopsis
 	  Designware HDMI block.  This is used in conjunction with
 	  the i.MX HDMI driver.
+
+config DRM_DW_HDMI_CEC
+	tristate "Synopsis Designware CEC interface"
+	depends on DRM_IMX_HDMI != n
+	select HDMI_CEC_CORE
+	help
+	  Support the CEC interface which is part of the Synposis
+	  Designware HDMI block.  This is used in conjunction with
+	  the i.MX HDMI driver.
diff --git a/drivers/staging/imx-drm/Makefile b/drivers/staging/imx-drm/Makefile
index 07e65a410f8f..82a368cf5979 100644
--- a/drivers/staging/imx-drm/Makefile
+++ b/drivers/staging/imx-drm/Makefile
@@ -11,3 +11,4 @@ imx-ipuv3-crtc-objs  := ipuv3-crtc.o ipuv3-plane.o
 obj-$(CONFIG_DRM_IMX_IPUV3)	+= imx-ipuv3-crtc.o
 obj-$(CONFIG_DRM_IMX_HDMI) += imx-hdmi.o
 obj-$(CONFIG_DRM_DW_HDMI_AUDIO) += dw-hdmi-audio.o
+obj-$(CONFIG_DRM_DW_HDMI_CEC) += dw-hdmi-cec.o
diff --git a/drivers/staging/imx-drm/dw-hdmi-cec.c b/drivers/staging/imx-drm/dw-hdmi-cec.c
new file mode 100644
index 000000000000..224e97d99b3b
--- /dev/null
+++ b/drivers/staging/imx-drm/dw-hdmi-cec.c
@@ -0,0 +1,207 @@
+/* http://git.freescale.com/git/cgit.cgi/imx/linux-2.6-imx.git/tree/drivers/mxc/hdmi-cec/mxc_hdmi-cec.c?h=imx_3.0.35_4.1.0 */
+#include <linux/cec-dev.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include "imx-hdmi.h"
+#include "dw-hdmi-cec.h"
+
+#define DEV_NAME "mxc_hdmi_cec"
+
+enum {
+	CEC_STAT_DONE		= BIT(0),
+	CEC_STAT_EOM		= BIT(1),
+	CEC_STAT_NACK		= BIT(2),
+	CEC_STAT_ARBLOST	= BIT(3),
+	CEC_STAT_ERROR_INIT	= BIT(4),
+	CEC_STAT_ERROR_FOLL	= BIT(5),
+	CEC_STAT_WAKEUP		= BIT(6),
+
+	CEC_CTRL_START		= BIT(0),
+	CEC_CTRL_NORMAL		= 1 << 1,
+};
+
+struct dw_hdmi_cec {
+	struct cec_dev cec;
+
+	struct device *dev;
+	void __iomem *base;
+	const struct dw_hdmi_cec_ops *ops;
+	void *ops_data;
+	int irq;
+};
+
+static void dw_hdmi_set_address(struct cec_dev *cec_dev, unsigned addresses)
+{
+	struct dw_hdmi_cec *cec = container_of(cec_dev, struct dw_hdmi_cec, cec);
+
+	writeb(addresses & 255, cec->base + HDMI_CEC_ADDR_L);
+	writeb(addresses >> 8, cec->base + HDMI_CEC_ADDR_H);
+}
+
+static void dw_hdmi_send_message(struct cec_dev *cec_dev, u8 *msg,
+	size_t count)
+{
+	struct dw_hdmi_cec *cec = container_of(cec_dev, struct dw_hdmi_cec, cec);
+	unsigned i;
+
+	for (i = 0; i < count; i++)
+		writeb(msg[i], cec->base + HDMI_CEC_TX_DATA0 + i);
+
+	writeb(count, cec->base + HDMI_CEC_TX_CNT);
+	writeb(CEC_CTRL_NORMAL | CEC_CTRL_START, cec->base + HDMI_CEC_CTRL);
+}
+
+static irqreturn_t dw_hdmi_cec_irq(int irq, void *data)
+{
+	struct dw_hdmi_cec *cec = data;
+	struct cec_dev *cec_dev = &cec->cec;
+	unsigned stat = readb(cec->base + HDMI_IH_CEC_STAT0);
+
+	if (stat == 0)
+		return IRQ_NONE;
+
+	writeb(stat, cec->base + HDMI_IH_CEC_STAT0);
+
+	if (stat & CEC_STAT_ERROR_INIT) {
+		if (cec->cec.retries) {
+			unsigned v = readb(cec->base + HDMI_CEC_CTRL);
+			writeb(v | CEC_CTRL_START, cec->base + HDMI_CEC_CTRL);
+			cec->cec.retries -= 1;
+		} else {
+			cec->cec.write_busy = 0;
+			cec_dev_event(cec_dev, MESSAGE_TYPE_SEND_ERROR, NULL, 0);
+		}
+	} else if (stat & (CEC_STAT_DONE | CEC_STAT_NACK))
+		cec_dev_send_complete(cec_dev, stat & CEC_STAT_DONE);
+
+	if (stat & CEC_STAT_EOM) {
+		unsigned len, i;
+		u8 msg[MAX_MESSAGE_LEN];
+
+		len = readb(cec->base + HDMI_CEC_RX_CNT);
+		if (len > sizeof(msg))
+			len = sizeof(msg);
+
+		for (i = 0; i < len; i++)
+			msg[i] = readb(cec->base + HDMI_CEC_RX_DATA0 + i);
+
+		writeb(0, cec->base + HDMI_CEC_LOCK);
+
+		cec_dev_receive(cec_dev, msg, len);
+	}
+
+	return IRQ_HANDLED;
+}
+EXPORT_SYMBOL(dw_hdmi_cec_irq);
+
+static void dw_hdmi_cec_release(struct cec_dev *cec_dev)
+{
+	struct dw_hdmi_cec *cec = container_of(cec_dev, struct dw_hdmi_cec, cec);
+
+	writeb(~0, cec->base + HDMI_CEC_MASK);
+	writeb(~0, cec->base + HDMI_IH_MUTE_CEC_STAT0);
+	writeb(0, cec->base + HDMI_CEC_POLARITY);
+
+	free_irq(cec->irq, cec);
+
+	cec->ops->disable(cec->ops_data);
+}
+
+static int dw_hdmi_cec_open(struct cec_dev *cec_dev)
+{
+	struct dw_hdmi_cec *cec = container_of(cec_dev, struct dw_hdmi_cec, cec);
+	unsigned irqs;
+	int ret;
+
+	writeb(0, cec->base + HDMI_CEC_CTRL);
+	writeb(~0, cec->base + HDMI_IH_CEC_STAT0);
+	writeb(0, cec->base + HDMI_CEC_LOCK);
+
+	ret = request_irq(cec->irq, dw_hdmi_cec_irq, IRQF_SHARED,
+			  DEV_NAME, cec);
+	if (ret < 0)
+		return ret;
+
+	dw_hdmi_set_address(cec_dev, cec_dev->addresses);
+
+	cec->ops->enable(cec->ops_data);
+
+	irqs = CEC_STAT_ERROR_INIT | CEC_STAT_NACK | CEC_STAT_EOM |
+	       CEC_STAT_DONE;
+	writeb(irqs, cec->base + HDMI_CEC_POLARITY);
+	writeb(~irqs, cec->base + HDMI_CEC_MASK);
+	writeb(~irqs, cec->base + HDMI_IH_MUTE_CEC_STAT0);
+
+	return 0;
+}
+
+static int dw_hdmi_cec_probe(struct platform_device *pdev)
+{
+	struct dw_hdmi_cec_data *data = dev_get_platdata(&pdev->dev);
+	struct dw_hdmi_cec *cec;
+
+	if (!data)
+		return -ENXIO;
+
+	cec = devm_kzalloc(&pdev->dev, sizeof(*cec), GFP_KERNEL);
+	if (!cec)
+		return -ENOMEM;
+
+	cec->dev = &pdev->dev;
+	cec->base = data->base;
+	cec->irq = data->irq;
+	cec->ops = data->ops;
+	cec->ops_data = data->ops_data;
+	cec->cec.open = dw_hdmi_cec_open;
+	cec->cec.release = dw_hdmi_cec_release;
+	cec->cec.send_message = dw_hdmi_send_message;
+	cec->cec.set_address = dw_hdmi_set_address;
+
+	cec_dev_init(&cec->cec, THIS_MODULE);
+
+	/* FIXME: soft-reset the CEC interface */
+
+	dw_hdmi_set_address(&cec->cec, cec->cec.addresses);
+	writeb(0, cec->base + HDMI_CEC_TX_CNT);
+	writeb(~0, cec->base + HDMI_CEC_MASK);
+	writeb(~0, cec->base + HDMI_IH_MUTE_CEC_STAT0);
+	writeb(0, cec->base + HDMI_CEC_POLARITY);
+
+	platform_set_drvdata(pdev, cec);
+
+	/*
+	 * Our device is just a convenience - we want to link to the real
+	 * hardware device here, so that userspace can see the association
+	 * between the HDMI hardware and its associated CEC chardev.
+	 */
+	return cec_dev_add(&cec->cec, cec->dev->parent, DEV_NAME);
+}
+
+static int dw_hdmi_cec_remove(struct platform_device *pdev)
+{
+	struct dw_hdmi_cec *cec = platform_get_drvdata(pdev);
+
+	cec_dev_remove(&cec->cec);
+
+	return 0;
+}
+
+static struct platform_driver dw_hdmi_cec_driver = {
+	.probe	= dw_hdmi_cec_probe,
+	.remove	= dw_hdmi_cec_remove,
+	.driver = {
+		.name = "dw-hdmi-cec",
+		.owner = THIS_MODULE,
+	},
+};
+module_platform_driver(dw_hdmi_cec_driver);
+
+MODULE_AUTHOR("Russell King <rmk+kernel@arm.linux.org.uk>");
+MODULE_DESCRIPTION("Synopsis Designware HDMI CEC driver for i.MX");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS(PLATFORM_MODULE_PREFIX "dw-hdmi-cec");
diff --git a/drivers/staging/imx-drm/dw-hdmi-cec.h b/drivers/staging/imx-drm/dw-hdmi-cec.h
new file mode 100644
index 000000000000..5ff40cc237a8
--- /dev/null
+++ b/drivers/staging/imx-drm/dw-hdmi-cec.h
@@ -0,0 +1,16 @@
+#ifndef DW_HDMI_CEC_H
+#define DW_HDMI_CEC_H
+
+struct dw_hdmi_cec_ops {
+	void (*enable)(void *);
+	void (*disable)(void *);
+};
+
+struct dw_hdmi_cec_data {
+	void __iomem *base;
+	int irq;
+	const struct dw_hdmi_cec_ops *ops;
+	void *ops_data;
+};
+
+#endif
diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/staging/imx-drm/imx-hdmi.c
index 412026c3f9f9..8806f6e74fe4 100644
--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/staging/imx-drm/imx-hdmi.c
@@ -30,6 +30,7 @@
 #include <video/imx-ipu-v3.h>
 
 #include "dw-hdmi-audio.h"
+#include "dw-hdmi-cec.h"
 #include "imx-hdmi.h"
 #include "imx-drm.h"
 
@@ -117,6 +118,7 @@ struct imx_hdmi {
 	struct drm_encoder encoder;
 
 	struct platform_device *audio;
+	struct platform_device *cec;
 	enum imx_hdmi_devtype dev_type;
 	struct device *dev;
 	struct clk *isfr_clk;
@@ -126,6 +128,7 @@ struct imx_hdmi {
 	int vic;
 
 	u8 edid[HDMI_EDID_LEN];
+	u8 mc_clkdis;
 	bool cable_plugin;
 
 	bool phy_enabled;
@@ -1152,8 +1155,6 @@ static void imx_hdmi_phy_disable(struct imx_hdmi *hdmi)
 /* HDMI Initialization Step B.4 */
 static void imx_hdmi_enable_video_path(struct imx_hdmi *hdmi)
 {
-	u8 clkdis;
-
 	/* control period minimum duration */
 	hdmi_writeb(hdmi, 12, HDMI_FC_CTRLDUR);
 	hdmi_writeb(hdmi, 32, HDMI_FC_EXCTRLDUR);
@@ -1165,23 +1166,28 @@ static void imx_hdmi_enable_video_path(struct imx_hdmi *hdmi)
 	hdmi_writeb(hdmi, 0x21, HDMI_FC_CH2PREAM);
 
 	/* Enable pixel clock and tmds data path */
-	clkdis = 0x7F;
-	clkdis &= ~HDMI_MC_CLKDIS_PIXELCLK_DISABLE;
-	hdmi_writeb(hdmi, clkdis, HDMI_MC_CLKDIS);
+	hdmi->mc_clkdis |= HDMI_MC_CLKDIS_HDCPCLK_DISABLE |
+			   HDMI_MC_CLKDIS_CSCCLK_DISABLE |
+			   HDMI_MC_CLKDIS_AUDCLK_DISABLE |
+			   HDMI_MC_CLKDIS_PREPCLK_DISABLE |
+			   HDMI_MC_CLKDIS_TMDSCLK_DISABLE;
+	hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_PIXELCLK_DISABLE;
+	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
 
-	clkdis &= ~HDMI_MC_CLKDIS_TMDSCLK_DISABLE;
-	hdmi_writeb(hdmi, clkdis, HDMI_MC_CLKDIS);
+	hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_TMDSCLK_DISABLE;
+	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
 
 	/* Enable csc path */
 	if (is_color_space_conversion(hdmi)) {
-		clkdis &= ~HDMI_MC_CLKDIS_CSCCLK_DISABLE;
-		hdmi_writeb(hdmi, clkdis, HDMI_MC_CLKDIS);
+		hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_CSCCLK_DISABLE;
+		hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
 	}
 }
 
 static void hdmi_enable_audio_clk(struct imx_hdmi *hdmi)
 {
-	hdmi_modb(hdmi, 0, HDMI_MC_CLKDIS_AUDCLK_DISABLE, HDMI_MC_CLKDIS);
+	hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_AUDCLK_DISABLE;
+	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
 }
 
 /* Workaround to clear the overflow condition */
@@ -1576,6 +1582,27 @@ static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
 	return 0;
 }
 
+static void imx_hdmi_cec_enable(void *data)
+{
+	struct imx_hdmi *hdmi = data;
+
+	hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_CECCLK_DISABLE;
+	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
+}
+
+static void imx_hdmi_cec_disable(void *data)
+{
+	struct imx_hdmi *hdmi = data;
+
+	hdmi->mc_clkdis |= HDMI_MC_CLKDIS_CECCLK_DISABLE;
+	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
+}
+
+static const struct dw_hdmi_cec_ops imx_hdmi_cec_ops = {
+	.enable = imx_hdmi_cec_enable,
+	.disable = imx_hdmi_cec_disable,
+};
+
 static struct platform_device_id imx_hdmi_devtype[] = {
 	{
 		.name = "imx6q-hdmi",
@@ -1604,6 +1631,7 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	struct device_node *np = dev->of_node;
 	struct device_node *ddc_node;
 	struct dw_hdmi_audio_data audio;
+	struct dw_hdmi_cec_data cec;
 	struct imx_hdmi *hdmi;
 	struct resource *iores;
 	int ret, irq;
@@ -1615,6 +1643,7 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	hdmi->dev = dev;
 	hdmi->sample_rate = 48000;
 	hdmi->ratio = 100;
+	hdmi->mc_clkdis = 0x7f;
 
 	if (of_id) {
 		const struct platform_device_id *device_id = of_id->data;
@@ -1735,6 +1764,18 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	pdevinfo.dma_mask = DMA_BIT_MASK(32);
 	hdmi->audio = platform_device_register_full(&pdevinfo);
 
+	cec.base = hdmi->regs;
+	cec.irq = irq;
+	cec.ops = &imx_hdmi_cec_ops;
+	cec.ops_data = hdmi;
+
+	pdevinfo.name = "dw-hdmi-cec";
+	pdevinfo.data = &cec;
+	pdevinfo.size_data = sizeof(cec);
+	pdevinfo.dma_mask = 0;
+
+	hdmi->cec = platform_device_register_full(&pdevinfo);
+
 	dev_set_drvdata(dev, hdmi);
 
 	return 0;
@@ -1754,6 +1795,8 @@ static void imx_hdmi_unbind(struct device *dev, struct device *master,
 
 	if (!IS_ERR(hdmi->audio))
 		platform_device_unregister(hdmi->audio);
+	if (!IS_ERR(hdmi->cec))
+		platform_device_unregister(hdmi->cec);
 
 	/* Disable all interrupts */
 	hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
-- 
1.8.3.1


--t0UkRYy7tHLRMCai--
