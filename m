Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3IATks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 15:40:48 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:57488 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753022Ab3IATkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 15:40:33 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, rdunlap@infradead.org, hans.verkuil@cisco.com,
        mkrufky@linuxtv.org, lkundrak@v3.sk, linux-kernel@vger.kernel.org
Subject: [RFC v3] Add a driver for the Somagic smi2021 chip
Date: Sun,  1 Sep 2013 21:42:51 +0200
Message-Id: <1378064571-10537-2-git-send-email-jonarne@jonarne.no>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1378064571-10537-1-git-send-email-jonarne@jonarne.no>
References: <1378064571-10537-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This chip is found in a series of usb video capture devices
branded as Easycap.

On first insertion, the device will identify as 0x1c88:0x0007.
This is just a bootloader stage. After uploading the firmware, the
device will reconnect with usb product id 0x003c, 0x003d, 0x003e or 0x003f
depending on the firmware.

The device uses the gm7113c chip for video ADC, this is a clone of the
saa7113 chip. This chip is controlled over i2c-bus from the bridge
chip by a proprietary usb control transfer.

The device also has a CirrusLogic CS5340 chip for audio ADC.

Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
---
 drivers/media/usb/Kconfig                      |   1 +
 drivers/media/usb/Makefile                     |   1 +
 drivers/media/usb/smi2021/Kconfig              |  11 +
 drivers/media/usb/smi2021/Makefile             |   9 +
 drivers/media/usb/smi2021/smi2021.h            | 193 +++++
 drivers/media/usb/smi2021/smi2021_audio.c      | 401 +++++++++++
 drivers/media/usb/smi2021/smi2021_bootloader.c | 256 +++++++
 drivers/media/usb/smi2021/smi2021_main.c       | 952 +++++++++++++++++++++++++
 drivers/media/usb/smi2021/smi2021_v4l2.c       | 277 +++++++
 9 files changed, 2101 insertions(+)
 create mode 100644 drivers/media/usb/smi2021/Kconfig
 create mode 100644 drivers/media/usb/smi2021/Makefile
 create mode 100644 drivers/media/usb/smi2021/smi2021.h
 create mode 100644 drivers/media/usb/smi2021/smi2021_audio.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_bootloader.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_main.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_v4l2.c

diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index cfe8056..da6376c 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -28,6 +28,7 @@ source "drivers/media/usb/hdpvr/Kconfig"
 source "drivers/media/usb/tlg2300/Kconfig"
 source "drivers/media/usb/usbvision/Kconfig"
 source "drivers/media/usb/stk1160/Kconfig"
+source "drivers/media/usb/smi2021/Kconfig"
 endif
 
 if (MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT)
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 0935f47..0e4fda5 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -21,3 +21,4 @@ obj-$(CONFIG_VIDEO_CX231XX) += cx231xx/
 obj-$(CONFIG_VIDEO_TM6000) += tm6000/
 obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
 obj-$(CONFIG_VIDEO_USBTV) += usbtv/
+obj-$(CONFIG_VIDEO_SMI2021) += smi2021/
diff --git a/drivers/media/usb/smi2021/Kconfig b/drivers/media/usb/smi2021/Kconfig
new file mode 100644
index 0000000..6a6fb8a
--- /dev/null
+++ b/drivers/media/usb/smi2021/Kconfig
@@ -0,0 +1,11 @@
+config VIDEO_SMI2021
+	tristate "Somagic SMI2021 USB video/audio capture support"
+	depends on VIDEO_DEV && I2C && SND && USB
+	select VIDEOBUF2_VMALLOC
+	select VIDEO_SAA711X
+	select SND_PCM
+	help
+	  This is a video4linux driver for SMI2021 based video capture devices.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called smi2021
diff --git a/drivers/media/usb/smi2021/Makefile b/drivers/media/usb/smi2021/Makefile
new file mode 100644
index 0000000..b04ff4e
--- /dev/null
+++ b/drivers/media/usb/smi2021/Makefile
@@ -0,0 +1,9 @@
+smi2021-y := smi2021_main.o		\
+	     smi2021_bootloader.o	\
+	     smi2021_v4l2.o		\
+	     smi2021_audio.o		\
+
+
+obj-$(CONFIG_VIDEO_SMI2021) += smi2021.o
+
+ccflags-y += -Idrivers/media/i2c
diff --git a/drivers/media/usb/smi2021/smi2021.h b/drivers/media/usb/smi2021/smi2021.h
new file mode 100644
index 0000000..70d3254
--- /dev/null
+++ b/drivers/media/usb/smi2021/smi2021.h
@@ -0,0 +1,193 @@
+/************************************************************************
+ * smi2021.h								*
+ *									*
+ * USB Driver for SMI2021 - EasyCap					*
+ * **********************************************************************
+ *
+ * Copyright 2011-2013 Jon Arne Jørgensen
+ * <jonjon.arnearne--a.t--gmail.com>
+ *
+ * Copyright 2011, 2012 Tony Brown, Michal Demin, Jeffry Johnston
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ * This driver is heavily influensed by the STK1160 driver.
+ * Copyright (C) 2012 Ezequiel Garcia
+ * <elezegarcia--a.t--gmail.com>
+ *
+ */
+
+#ifndef SMI2021_H
+#define SMI2021_H
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/i2c.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ctrls.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-vmalloc.h>
+#include <media/saa7115.h>
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/initval.h>
+
+#define SMI2021_DRIVER_VERSION "0.1"
+
+#define SMI2021_ISOC_TRANSFERS	16
+#define SMI2021_ISOC_PACKETS	10
+#define SMI2021_ISOC_EP		0x82
+
+/* General USB control setup */
+#define SMI2021_USB_REQUEST	0x01
+#define SMI2021_USB_INDEX	0x00
+#define SMI2021_USB_SNDPIPE	0x00
+#define SMI2021_USB_RCVPIPE	0x80
+
+/* General video constants */
+#define SMI2021_BYTES_PER_LINE	1440
+#define SMI2021_PAL_LINES	576
+#define SMI2021_NTSC_LINES	484
+
+/* Timing Referance Codes, see saa7113 datasheet */
+#define SMI2021_TRC_EAV		0x10
+#define SMI2021_TRC_VBI		0x20
+#define SMI2021_TRC_FIELD_2	0x40
+#define SMI2021_TRC		0x80
+
+#ifdef DEBUG
+#define smi2021_dbg(fmt, args...)		\
+	pr_debug("smi2021::%s: " fmt, __func__, \
+			##args)
+#else
+#define smi2021_dbg(fmt, args...)
+#endif
+
+#define smi2021_info(fmt, args...)		\
+	pr_info("smi2021::%s: " fmt,		\
+		__func__, ##args)
+
+#define smi2021_warn(fmt, args...)		\
+	pr_warn("smi2021::%s: " fmt,		\
+		__func__, ##args)
+
+#define smi2021_err(fmt, args...)		\
+	pr_err("smi2021::%s: " fmt,		\
+		__func__, ##args)
+
+/* Structs passed on USB for device setup */
+struct smi2021_set_hw_state {
+	u8 head;
+	u8 state;
+} __packed;
+
+/* A single videobuf2 frame buffer */
+struct smi2021_buf {
+	/* Common vb2 stuff, must be first */
+	struct vb2_buffer		vb;
+	struct list_head		list;
+
+	void				*mem;
+	unsigned int			length;
+
+	bool				active;
+	bool				second_field;
+	bool				in_blank;
+	unsigned int			pos;
+
+	/* ActiveVideo - Line counter */
+	u16				trc_av;
+};
+
+struct smi2021_vid_input {
+	char				*name;
+	int				type;
+};
+
+enum smi2021_sync {
+	HSYNC,
+	SYNCZ1,
+	SYNCZ2,
+	TRC
+};
+
+struct smi2021 {
+	struct device			*dev;
+	struct usb_device		*udev;
+	struct i2c_adapter		i2c_adap;
+	struct i2c_client		i2c_client;
+	struct v4l2_ctrl_handler	ctrl_handler;
+	struct v4l2_subdev		*gm7113c_subdev;
+	struct v4l2_device		v4l2_dev;
+	struct video_device		vdev;
+	struct vb2_queue		vb2q;
+	struct mutex			v4l2_lock;
+	struct mutex			vb2q_lock;
+
+	/* List of videobuf2 buffers protected by a lock. */
+	spinlock_t			buf_lock;
+	struct list_head		bufs;
+	struct smi2021_buf		*cur_buf;
+
+	int				sequence;
+
+	/* Frame settings */
+	int				cur_height;
+	v4l2_std_id			cur_norm;
+	enum smi2021_sync		sync_state;
+
+	struct snd_card			*snd_card;
+	struct snd_pcm_substream	*pcm_substream;
+
+	unsigned int			pcm_write_ptr;
+	unsigned int			pcm_complete_samples;
+
+	u8				pcm_read_offset;
+	struct work_struct		adev_capture_trigger;
+	atomic_t			adev_capturing;
+
+	/* Device settings */
+	unsigned int		vid_input_count;
+	const struct smi2021_vid_input	*vid_inputs;
+	int				cur_input;
+
+	int				iso_size;
+	struct urb			*isoc_urbs[SMI2021_ISOC_TRANSFERS];
+};
+
+/* Provided by smi2021_bootloader.c */
+int smi2021_bootloader_probe(struct usb_interface *intf,
+					const struct usb_device_id *devid);
+void smi2021_bootloader_disconnect(struct usb_interface *intf);
+
+/* Provided by smi2021_main.c */
+void smi2021_toggle_audio(struct smi2021 *smi2021, bool enable);
+int smi2021_start(struct smi2021 *smi2021);
+void smi2021_stop(struct smi2021 *smi2021);
+
+/* Provided by smi2021_v4l2.c */
+int smi2021_vb2_setup(struct smi2021 *smi2021);
+int smi2021_video_register(struct smi2021 *smi2021);
+
+/* Provided by smi2021_audio.c */
+int smi2021_snd_register(struct smi2021 *smi2021);
+void smi2021_snd_unregister(struct smi2021 *smi2021);
+void smi2021_stop_audio(struct smi2021 *smi2021);
+void smi2021_audio(struct smi2021 *smi2021, u8 *data, int len);
+#endif /* SMI2021_H */
diff --git a/drivers/media/usb/smi2021/smi2021_audio.c b/drivers/media/usb/smi2021/smi2021_audio.c
new file mode 100644
index 0000000..b4d6e76
--- /dev/null
+++ b/drivers/media/usb/smi2021/smi2021_audio.c
@@ -0,0 +1,401 @@
+/************************************************************************
+ * smi2021_audio.c							*
+ *									*
+ * USB Driver for SMI2021 - EasyCap					*
+ * **********************************************************************
+ *
+ * Copyright 2011-2013 Jon Arne Jørgensen
+ * <jonjon.arnearne--a.t--gmail.com>
+ *
+ * Copyright 2011, 2012 Tony Brown, Michal Demin, Jeffry Johnston
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ * This driver is heavily influensed by the STK1160 driver.
+ * Copyright (C) 2012 Ezequiel Garcia
+ * <elezegarcia--a.t--gmail.com>
+ *
+ */
+
+#include "smi2021.h"
+
+static void pcm_buffer_free(struct snd_pcm_substream *substream)
+{
+	vfree(substream->runtime->dma_area);
+	substream->runtime->dma_area = NULL;
+	substream->runtime->dma_bytes = 0;
+}
+
+static int pcm_buffer_alloc(struct snd_pcm_substream *substream, int size)
+{
+	if (substream->runtime->dma_area) {
+		if (substream->runtime->dma_bytes > size)
+			return 0;
+		pcm_buffer_free(substream);
+	}
+
+	substream->runtime->dma_area = vmalloc(size);
+	if (substream->runtime->dma_area == NULL)
+		return -ENOMEM;
+
+	substream->runtime->dma_bytes = size;
+
+	return 0;
+}
+
+static const struct snd_pcm_hardware smi2021_pcm_hw = {
+	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
+		SNDRV_PCM_INFO_INTERLEAVED    |
+		SNDRV_PCM_INFO_MMAP           |
+		SNDRV_PCM_INFO_MMAP_VALID     |
+		SNDRV_PCM_INFO_BATCH,
+
+	.formats = SNDRV_PCM_FMTBIT_S32_LE,
+
+	.rates = SNDRV_PCM_RATE_48000,
+	.rate_min = 48000,
+	.rate_max = 48000,
+	.channels_min = 2,
+	.channels_max = 2,
+	.period_bytes_min = 992,	/* 32640 */ /* 15296 */
+	.period_bytes_max = 15872,	/* 65280 */
+	.periods_min = 1,		/* 1 */
+	.periods_max = 16,		/* 2 */
+	.buffer_bytes_max = 65280,	/* 65280 */
+};
+
+static int smi2021_pcm_open(struct snd_pcm_substream *substream)
+{
+	struct smi2021 *smi2021 = snd_pcm_substream_chip(substream);
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	int rc;
+
+	rc = snd_pcm_hw_constraint_pow2(runtime, 0,
+					SNDRV_PCM_HW_PARAM_PERIODS);
+	if (rc < 0)
+		return rc;
+
+	smi2021->pcm_substream = substream;
+
+	runtime->hw = smi2021_pcm_hw;
+	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
+
+	return 0;
+}
+
+static int smi2021_pcm_close(struct snd_pcm_substream *substream)
+{
+	struct smi2021 *smi2021 = snd_pcm_substream_chip(substream);
+
+	if (atomic_read(&smi2021->adev_capturing)) {
+		atomic_set(&smi2021->adev_capturing, 0);
+		schedule_work(&smi2021->adev_capture_trigger);
+	}
+	return 0;
+
+}
+
+
+static int smi2021_pcm_hw_params(struct snd_pcm_substream *substream,
+				struct snd_pcm_hw_params *hw_params)
+{
+	int size, rc;
+	size = params_period_bytes(hw_params) * params_periods(hw_params);
+
+	rc = pcm_buffer_alloc(substream, size);
+	if (rc < 0)
+		return rc;
+
+
+	return 0;
+}
+
+static int smi2021_pcm_hw_free(struct snd_pcm_substream *substream)
+{
+	struct smi2021 *smi2021 = snd_pcm_substream_chip(substream);
+
+	if (atomic_read(&smi2021->adev_capturing)) {
+		atomic_set(&smi2021->adev_capturing, 0);
+		schedule_work(&smi2021->adev_capture_trigger);
+	}
+
+	pcm_buffer_free(substream);
+	return 0;
+}
+
+static int smi2021_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct smi2021 *smi2021 = snd_pcm_substream_chip(substream);
+
+	smi2021->pcm_complete_samples = 0;
+	smi2021->pcm_read_offset = 0;
+	smi2021->pcm_write_ptr = 0;
+
+	return 0;
+}
+
+static void capture_trigger(struct work_struct *work)
+{
+	struct smi2021 *smi2021 = container_of(work, struct smi2021,
+						adev_capture_trigger);
+
+	if (atomic_read(&smi2021->adev_capturing))
+		smi2021_toggle_audio(smi2021, true);
+	else
+		smi2021_toggle_audio(smi2021, false);
+}
+
+/* This callback is ATOMIC, must not sleep */
+static int smi2021_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	struct smi2021 *smi2021 = snd_pcm_substream_chip(substream);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_START:
+		atomic_set(&smi2021->adev_capturing, 1);
+		break;
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_STOP:
+		atomic_set(&smi2021->adev_capturing, 0);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	schedule_work(&smi2021->adev_capture_trigger);
+
+	return 0;
+}
+
+static snd_pcm_uframes_t smi2021_pcm_pointer(
+				struct snd_pcm_substream *substream)
+{
+	struct smi2021 *smi2021 = snd_pcm_substream_chip(substream);
+	return smi2021->pcm_write_ptr / 8;
+}
+
+static struct page *smi2021_pcm_get_vmalloc_page(
+					struct snd_pcm_substream *subs,
+					unsigned long offset)
+{
+	void *pageptr = subs->runtime->dma_area + offset;
+
+	return vmalloc_to_page(pageptr);
+}
+
+static struct snd_pcm_ops smi2021_pcm_ops = {
+	.open = smi2021_pcm_open,
+	.close = smi2021_pcm_close,
+	.ioctl = snd_pcm_lib_ioctl,
+	.hw_params = smi2021_pcm_hw_params,
+	.hw_free = smi2021_pcm_hw_free,
+	.prepare = smi2021_pcm_prepare,
+	.trigger = smi2021_pcm_trigger,
+	.pointer = smi2021_pcm_pointer,
+	.page = smi2021_pcm_get_vmalloc_page,
+};
+
+int smi2021_snd_register(struct smi2021 *smi2021)
+{
+	struct snd_card	*card;
+	struct snd_pcm *pcm;
+	int rc = 0;
+
+	rc = snd_card_create(SNDRV_DEFAULT_IDX1, "smi2021 Audio", THIS_MODULE,
+				0, &card);
+	if (rc < 0)
+		return rc;
+
+	rc = snd_pcm_new(card, "smi2021 Audio", 0, 0, 1, &pcm);
+	if (rc < 0)
+		goto err_free_card;
+
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &smi2021_pcm_ops);
+	pcm->info_flags = 0;
+	pcm->private_data = smi2021;
+	strcpy(pcm->name, "Somagic smi2021 Capture");
+
+	strcpy(card->driver, "smi2021-Audio");
+	strcpy(card->shortname, "smi2021 Audio");
+	strcpy(card->longname, "Somagic smi2021 Audio");
+
+	INIT_WORK(&smi2021->adev_capture_trigger, capture_trigger);
+
+	rc = snd_card_register(card);
+	if (rc < 0)
+		goto err_free_card;
+
+	smi2021->snd_card = card;
+
+	return 0;
+
+err_free_card:
+	snd_card_free(card);
+	return rc;
+}
+
+void smi2021_snd_unregister(struct smi2021 *smi2021)
+{
+	if (smi2021 == NULL)
+		return;
+
+	if (smi2021->snd_card == NULL)
+		return;
+
+	snd_card_free(smi2021->snd_card);
+	smi2021->snd_card = NULL;
+}
+
+void smi2021_stop_audio(struct smi2021 *smi2021)
+{
+	/*
+	 * HACK: Stop the audio subsystem,
+	 * without this, the pcm middle-layer will hang waiting for more data.
+	 *
+	 * Is there a better way to do this?
+	 */
+	if (smi2021->pcm_substream && smi2021->pcm_substream->runtime) {
+		struct snd_pcm_runtime *runtime;
+
+		runtime = smi2021->pcm_substream->runtime;
+		if (runtime->status) {
+			runtime->status->state = SNDRV_PCM_STATE_DRAINING;
+			wake_up(&runtime->sleep);
+		}
+	}
+}
+
+void smi2021_audio(struct smi2021 *smi2021, u8 *data, int len)
+{
+	struct snd_pcm_runtime *runtime;
+	u8 offset;
+	int new_offset = 0;
+
+	int skip;
+	unsigned int stride, oldptr, headptr;
+
+	int diff = 0;
+	int samples = 0;
+	bool period_elapsed = false;
+
+
+	if (smi2021->udev == NULL)
+		return;
+
+	if (atomic_read(&smi2021->adev_capturing) == 0)
+		return;
+
+	if (smi2021->pcm_substream == NULL)
+		return;
+
+	runtime = smi2021->pcm_substream->runtime;
+	if (!runtime || !runtime->dma_area)
+		return;
+
+	offset = smi2021->pcm_read_offset;
+	stride = runtime->frame_bits >> 3;
+
+	if (stride == 0)
+		return;
+
+	diff = smi2021->pcm_write_ptr;
+
+	/*
+	 * Check that the end of the last buffer was correct.
+	 * If not correct, we mark any partial frames in buffer as complete
+	 */
+	headptr = smi2021->pcm_write_ptr - offset - 4;
+	if (smi2021->pcm_write_ptr > 10
+	    && runtime->dma_area[headptr] != 0x00) {
+		skip = stride - (smi2021->pcm_write_ptr % stride);
+		snd_pcm_stream_lock(smi2021->pcm_substream);
+		smi2021->pcm_write_ptr += skip;
+
+		if (smi2021->pcm_write_ptr >= runtime->dma_bytes)
+			smi2021->pcm_write_ptr -= runtime->dma_bytes;
+
+		snd_pcm_stream_unlock(smi2021->pcm_substream);
+		offset = smi2021->pcm_read_offset = 0;
+	}
+	/*
+	 * The device is actually sending 24Bit pcm data
+	 * with 0x00 as the header byte before each sample.
+	 * We look for this byte to make sure we did not
+	 * loose any bytes during transfer.
+	 */
+	while (len > stride && (data[offset] != 0x00 ||
+			data[offset + (stride / 2)] != 0x00)) {
+		new_offset++;
+		data++;
+		len--;
+	}
+
+	if (len <= stride) {
+		/* We exhausted the buffer looking for 0x00 */
+		smi2021->pcm_read_offset = 0;
+		return;
+	}
+	if (new_offset != 0) {
+		/*
+		 * This buffer can not be appended to the current buffer,
+		 * so we mark any partial frames in the buffer as complete.
+		 */
+		skip = stride - (smi2021->pcm_write_ptr % stride);
+		snd_pcm_stream_lock(smi2021->pcm_substream);
+		smi2021->pcm_write_ptr += skip;
+
+		if (smi2021->pcm_write_ptr >= runtime->dma_bytes)
+			smi2021->pcm_write_ptr -= runtime->dma_bytes;
+
+		snd_pcm_stream_unlock(smi2021->pcm_substream);
+
+		offset = smi2021->pcm_read_offset = new_offset % (stride / 2);
+
+	}
+
+	oldptr = smi2021->pcm_write_ptr;
+	if (oldptr + len >= runtime->dma_bytes) {
+		unsigned int cnt = runtime->dma_bytes - oldptr;
+		memcpy(runtime->dma_area + oldptr, data, cnt);
+		memcpy(runtime->dma_area, data + cnt, len - cnt);
+	} else {
+		memcpy(runtime->dma_area + oldptr, data, len);
+	}
+
+	snd_pcm_stream_lock(smi2021->pcm_substream);
+	smi2021->pcm_write_ptr += len;
+
+	if (smi2021->pcm_write_ptr >= runtime->dma_bytes)
+		smi2021->pcm_write_ptr -= runtime->dma_bytes;
+
+	samples = smi2021->pcm_write_ptr - diff;
+	if (samples < 0)
+		samples += runtime->dma_bytes;
+
+	samples /= (stride / 2);
+
+	smi2021->pcm_complete_samples += samples;
+	if (smi2021->pcm_complete_samples / 2 >= runtime->period_size) {
+		smi2021->pcm_complete_samples -= runtime->period_size * 2;
+		period_elapsed = true;
+	}
+	snd_pcm_stream_unlock(smi2021->pcm_substream);
+
+	if (period_elapsed)
+		snd_pcm_period_elapsed(smi2021->pcm_substream);
+
+}
diff --git a/drivers/media/usb/smi2021/smi2021_bootloader.c b/drivers/media/usb/smi2021/smi2021_bootloader.c
new file mode 100644
index 0000000..52b4edd
--- /dev/null
+++ b/drivers/media/usb/smi2021/smi2021_bootloader.c
@@ -0,0 +1,256 @@
+/************************************************************************
+ * smi2021_bootloader.c							*
+ *									*
+ * USB Driver for SMI2021 - EasyCAP					*
+ * **********************************************************************
+ *
+ * Copyright 2011-2013 Jon Arne Jørgensen
+ * <jonjon.arnearne--a.t--gmail.com>
+ *
+ * Copyright 2011, 2012 Tony Brown, Michal Demin, Jeffry Johnston
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ * This driver is heavily influensed by the STK1160 driver.
+ * Copyright (C) 2012 Ezequiel Garcia
+ * <elezegarcia--a.t--gmail.com>
+ *
+ */
+
+#include "smi2021.h"
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/firmware.h>
+#include <linux/slab.h>
+
+#define FIRMWARE_CHUNK_SIZE	62
+#define FIRMWARE_HEADER_SIZE	2
+
+#define FIRMWARE_CHUNK_HEAD_0	0x05
+#define FIRMWARE_CHUNK_HEAD_1	0xff
+#define FIRMWARE_HW_STATE_HEAD	0x01
+#define FIRMWARE_HW_READY_STATE	0x07
+
+#define SMI2021_3C_FIRMWARE	"smi2021_3c.bin"
+#define SMI2021_3E_FIRMWARE	"smi2021_3e.bin"
+#define SMI2021_3F_FIRMWARE	"smi2021_3f.bin"
+
+static unsigned int firmware_version;
+module_param(firmware_version, int, 0644);
+MODULE_PARM_DESC(firmware_version,
+			"Firmware version to be uploaded to device\n"
+			"if there are more than one firmware present");
+
+struct smi2021_firmware {
+	int		id;
+	const char	*name;
+	int		found;
+};
+
+struct smi2021_firmware available_fw[] = {
+	{
+		.id = 0x3c,
+		.name = SMI2021_3C_FIRMWARE,
+	},
+	{
+		.id = 0x3e,
+		.name = SMI2021_3E_FIRMWARE,
+	},
+	{
+		.id = 0x3f,
+		.name = SMI2021_3F_FIRMWARE,
+	}
+};
+
+static const struct firmware *firmware[ARRAY_SIZE(available_fw)];
+static int firmwares = -1;
+
+static int smi2021_load_firmware(struct usb_device *udev,
+					const struct firmware *firmware)
+{
+	int i, size, rc;
+	struct smi2021_set_hw_state *hw_state;
+	u8 *chunk;
+
+	size = FIRMWARE_CHUNK_SIZE + FIRMWARE_HEADER_SIZE;
+	chunk = kzalloc(size, GFP_KERNEL);
+
+	if (chunk == NULL) {
+		dev_err(&udev->dev,
+			"could not allocate space for firmware chunk\n");
+		rc = -ENOMEM;
+		goto end_out;
+	}
+
+	hw_state = kzalloc(sizeof(*hw_state), GFP_KERNEL);
+	if (hw_state == NULL) {
+		dev_err(&udev->dev, "could not allocate space for usb data\n");
+		rc = -ENOMEM;
+		goto free_out;
+	}
+
+	if (firmware == NULL) {
+		dev_err(&udev->dev, "firmware is NULL\n");
+		rc = -ENODEV;
+		goto free_out;
+	}
+
+	if (firmware->size % FIRMWARE_CHUNK_SIZE) {
+		dev_err(&udev->dev, "firmware has wrong size\n");
+		rc = -ENODEV;
+		goto free_out;
+	}
+
+	rc = usb_control_msg(udev, usb_rcvctrlpipe(udev, SMI2021_USB_RCVPIPE),
+			SMI2021_USB_REQUEST,
+			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			FIRMWARE_HW_STATE_HEAD, SMI2021_USB_INDEX,
+			hw_state, sizeof(*hw_state), 1000);
+
+	if (rc < 0 || hw_state->state != FIRMWARE_HW_READY_STATE) {
+		dev_err(&udev->dev,
+			"device is not ready for firmware upload: %d\n", rc);
+		goto free_out;
+	}
+
+	chunk[0] = FIRMWARE_CHUNK_HEAD_0;
+	chunk[1] = FIRMWARE_CHUNK_HEAD_1;
+
+	for (i = 0; i < firmware->size / FIRMWARE_CHUNK_SIZE; i++) {
+		memcpy(chunk + FIRMWARE_HEADER_SIZE,
+			firmware->data + (i * FIRMWARE_CHUNK_SIZE),
+			FIRMWARE_CHUNK_SIZE);
+
+		rc = usb_control_msg(udev,
+			usb_sndctrlpipe(udev, SMI2021_USB_SNDPIPE),
+			SMI2021_USB_REQUEST,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			FIRMWARE_CHUNK_HEAD_0, SMI2021_USB_INDEX,
+			chunk, size, 1000);
+		if (rc < 0) {
+			dev_err(&udev->dev, "firmware upload failed: %d\n",
+				rc);
+			goto free_out;
+		}
+	}
+
+	hw_state->head = FIRMWARE_HW_READY_STATE;
+	hw_state->state = 0x00;
+	rc = usb_control_msg(udev, usb_sndctrlpipe(udev, SMI2021_USB_SNDPIPE),
+			SMI2021_USB_REQUEST,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			FIRMWARE_HW_READY_STATE, SMI2021_USB_INDEX,
+			hw_state, sizeof(*hw_state), 1000);
+
+	if (rc < 0) {
+		dev_err(&udev->dev, "device failed to ack firmware: %d\n", rc);
+		goto free_out;
+	}
+
+	rc = 0;
+
+free_out:
+	kfree(chunk);
+	kfree(hw_state);
+end_out:
+	return rc;
+}
+
+static int smi2021_choose_firmware(struct usb_device *udev)
+{
+	int i, found, id;
+	for (i = 0; i < ARRAY_SIZE(available_fw); i++) {
+		found = available_fw[i].found;
+		id = available_fw[i].id;
+		if (firmware_version == id && found >= 0) {
+			dev_info(&udev->dev, "uploading firmware for 0x%x\n",
+					id);
+			return smi2021_load_firmware(udev, firmware[found]);
+		}
+	}
+
+	dev_info(&udev->dev,
+	"could not decide what firmware to upload, user action required\n");
+	return 0;
+}
+
+int smi2021_bootloader_probe(struct usb_interface *intf,
+					const struct usb_device_id *devid)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	int rc, i;
+
+	/* Check what firmwares are available in the system */
+	for (i = 0; i < ARRAY_SIZE(available_fw); i++) {
+		dev_info(&udev->dev, "Looking for: %s\n",
+			 available_fw[i].name);
+		rc = request_firmware(&firmware[firmwares + 1],
+			available_fw[i].name, &udev->dev);
+
+		if (rc == 0) {
+			firmwares++;
+			available_fw[i].found = firmwares;
+			dev_info(&udev->dev, "Found firmware for 0x00%x\n",
+				available_fw[i].id);
+		} else if (rc == -ENOENT) {
+			available_fw[i].found = -1;
+		} else {
+			dev_err(&udev->dev,
+				"request_firmware failed with: %d\n", rc);
+			goto err_out;
+		}
+	}
+
+	if (firmwares < 0) {
+		dev_err(&udev->dev,
+			"could not find any firmware for this device\n");
+		goto no_dev;
+	} else if (firmwares == 0) {
+		rc = smi2021_load_firmware(udev, firmware[0]);
+		if (rc < 0)
+			goto err_out;
+	} else {
+		smi2021_choose_firmware(udev);
+	}
+
+	return 0;
+
+no_dev:
+	rc = -ENODEV;
+err_out:
+	return rc;
+}
+
+void smi2021_bootloader_disconnect(struct usb_interface *intf)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(available_fw); i++) {
+		if (available_fw[i].found >= 0) {
+			dev_info(&udev->dev, "Releasing firmware for 0x00%x\n",
+							available_fw[i].id);
+			release_firmware(firmware[available_fw[i].found]);
+			firmware[available_fw[i].found] = NULL;
+			available_fw[i].found = -1;
+		}
+	}
+	firmwares = -1;
+
+}
+
+MODULE_FIRMWARE(SMI2021_3C_FIRMWARE);
+MODULE_FIRMWARE(SMI2021_3E_FIRMWARE);
+MODULE_FIRMWARE(SMI2021_3F_FIRMWARE);
diff --git a/drivers/media/usb/smi2021/smi2021_main.c b/drivers/media/usb/smi2021/smi2021_main.c
new file mode 100644
index 0000000..5844379
--- /dev/null
+++ b/drivers/media/usb/smi2021/smi2021_main.c
@@ -0,0 +1,952 @@
+/************************************************************************
+ * smi2021_main.c							*
+ *									*
+ * USB Driver for SMI2021 - EasyCAP					*
+ * **********************************************************************
+ *
+ * Copyright 2011-2013 Jon Arne Jørgensen
+ * <jonjon.arnearne--a.t--gmail.com>
+ *
+ * Copyright 2011, 2012 Tony Brown, Michal Demin, Jeffry Johnston
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ * This driver is heavily influensed by the STK1160 driver.
+ * Copyright (C) 2012 Ezequiel Garcia
+ * <elezegarcia--a.t--gmail.com>
+ *
+ */
+
+#include "smi2021.h"
+
+#define VENDOR_ID 0x1c88
+#define BOOTLOADER_ID 0x0007
+
+#define SMI2021_MODE_CTRL_HEAD		0x01
+#define SMI2021_MODE_CAPTURE		0x05
+#define SMI2021_MODE_STANDBY		0x03
+#define SMI2021_REG_CTRL_HEAD		0x0b
+
+static int smi2021_set_mode(struct smi2021 *smi2021, u8 mode)
+{
+	int pipe, rc;
+	struct mode_ctrl_transfer {
+		u8 head;
+		u8 mode;
+	} *transfer_buf = kzalloc(sizeof(*transfer_buf), GFP_KERNEL);
+	if (transfer_buf == NULL)
+		return -ENOMEM;
+
+	transfer_buf->head = SMI2021_MODE_CTRL_HEAD;
+	transfer_buf->mode = mode;
+
+	pipe = usb_sndctrlpipe(smi2021->udev, SMI2021_USB_SNDPIPE);
+	rc = usb_control_msg(smi2021->udev, pipe, SMI2021_USB_REQUEST,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			transfer_buf->head, SMI2021_USB_INDEX,
+			transfer_buf, sizeof(*transfer_buf), 1000);
+
+	kfree(transfer_buf);
+
+	return rc;
+}
+
+/*
+ * The smi2021 chip will handle two different types of register settings.
+ * Settings for the gm7113c chip via i2c or settings for the smi2021 chip.
+ * All settings are passed with the following struct.
+ * Some bits in data_offset and data_cntl parameters tells the device what
+ * kind of setting it's receiving and if it's a read or write request.
+ */
+struct smi2021_reg_ctrl_transfer {
+	u8 head;
+	u8 i2c_addr;
+	u8 data_cntl;
+	u8 data_offset;
+	u8 data_size;
+	union data {
+		u8 val;
+		struct i2c_data {
+			u8 reg;
+			u8 val;
+		} __packed i2c_data;
+		struct smi_data {
+			u8 reg_hi;
+			u8 reg_lo;
+			u8 val;
+		} __packed smi_data;
+		u8 reserved[8];
+	} __packed data;
+} __packed;
+
+static int smi2021_set_reg(struct smi2021 *smi2021, u8 i2c_addr,
+			   u16 reg, u8 val)
+{
+	int rc, pipe;
+	struct smi2021_reg_ctrl_transfer *transfer_buf;
+
+	static const struct smi2021_reg_ctrl_transfer smi_data = {
+		.head = SMI2021_REG_CTRL_HEAD,
+		.i2c_addr = 0x00,
+		.data_cntl = 0x00,
+		.data_offset = 0x82,
+		.data_size = sizeof(u8),
+	};
+
+	static const struct smi2021_reg_ctrl_transfer i2c_data = {
+		.head = SMI2021_REG_CTRL_HEAD,
+		.i2c_addr = 0x00,
+		.data_cntl = 0xc0,
+		.data_offset = 0x01,
+		.data_size = sizeof(u8)
+	};
+
+	if (smi2021->udev == NULL) {
+		rc = -ENODEV;
+		goto out;
+	}
+
+	transfer_buf = kzalloc(sizeof(*transfer_buf), GFP_KERNEL);
+	if (transfer_buf == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (i2c_addr) {
+		memcpy(transfer_buf, &i2c_data, sizeof(*transfer_buf));
+		transfer_buf->i2c_addr = i2c_addr;
+		transfer_buf->data.i2c_data.reg = reg;
+		transfer_buf->data.i2c_data.val = val;
+	} else {
+		memcpy(transfer_buf, &smi_data, sizeof(*transfer_buf));
+		transfer_buf->data.smi_data.reg_lo = __cpu_to_le16(reg) & 0xff;
+		transfer_buf->data.smi_data.reg_hi = __cpu_to_le16(reg) >> 8;
+		transfer_buf->data.smi_data.val = val;
+	}
+
+	pipe = usb_sndctrlpipe(smi2021->udev, SMI2021_USB_SNDPIPE);
+	rc = usb_control_msg(smi2021->udev, pipe, SMI2021_USB_REQUEST,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			transfer_buf->head, SMI2021_USB_INDEX,
+			transfer_buf, sizeof(*transfer_buf), 1000);
+
+	kfree(transfer_buf);
+out:
+	return rc;
+}
+
+static int smi2021_get_reg(struct smi2021 *smi2021, u8 i2c_addr,
+			   u16 reg, u8 *val)
+{
+	int rc, pipe;
+	struct smi2021_reg_ctrl_transfer *transfer_buf;
+
+	static const struct smi2021_reg_ctrl_transfer i2c_prepare_read = {
+		.head = SMI2021_REG_CTRL_HEAD,
+		.i2c_addr = 0x00,
+		.data_cntl = 0x84,
+		.data_offset = 0x00,
+		.data_size = sizeof(u8)
+	};
+
+	static const struct smi2021_reg_ctrl_transfer smi_read = {
+		.head = SMI2021_REG_CTRL_HEAD,
+		.i2c_addr = 0x00,
+		.data_cntl = 0x20,
+		.data_offset = 0x82,
+		.data_size = sizeof(u8)
+	};
+
+	*val = 0;
+
+	if (smi2021->udev == NULL) {
+		rc = -ENODEV;
+		goto out;
+	}
+
+	transfer_buf = kzalloc(sizeof(*transfer_buf), GFP_KERNEL);
+	if (transfer_buf == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	pipe = usb_sndctrlpipe(smi2021->udev, SMI2021_USB_SNDPIPE);
+
+	if (i2c_addr) {
+		memcpy(transfer_buf, &i2c_prepare_read, sizeof(*transfer_buf));
+		transfer_buf->i2c_addr = i2c_addr;
+		transfer_buf->data.i2c_data.reg = reg;
+
+		rc = usb_control_msg(smi2021->udev, pipe, SMI2021_USB_REQUEST,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			transfer_buf->head, SMI2021_USB_INDEX,
+			transfer_buf, sizeof(*transfer_buf), 1000);
+		if (rc < 0)
+			goto free_out;
+
+		transfer_buf->data_cntl = 0xa0;
+	} else {
+		memcpy(transfer_buf, &smi_read, sizeof(*transfer_buf));
+		transfer_buf->data.smi_data.reg_lo = __cpu_to_le16(reg) & 0xff;
+		transfer_buf->data.smi_data.reg_hi = __cpu_to_le16(reg) >> 8;
+	}
+
+	rc = usb_control_msg(smi2021->udev, pipe, SMI2021_USB_REQUEST,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			transfer_buf->head, SMI2021_USB_INDEX,
+			transfer_buf, sizeof(*transfer_buf), 1000);
+	if (rc < 0)
+		goto free_out;
+
+	pipe = usb_rcvctrlpipe(smi2021->udev, SMI2021_USB_RCVPIPE);
+	rc = usb_control_msg(smi2021->udev, pipe, SMI2021_USB_REQUEST,
+			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			transfer_buf->head, SMI2021_USB_INDEX,
+			transfer_buf, sizeof(*transfer_buf), 1000);
+	if (rc < 0)
+		goto free_out;
+
+	*val = transfer_buf->data.val;
+
+free_out:
+	kfree(transfer_buf);
+out:
+	return rc;
+}
+
+static int smi2021_i2c_xfer(struct i2c_adapter *i2c_adap,
+				struct i2c_msg msgs[], int num)
+{
+	struct smi2021 *smi2021 = i2c_adap->algo_data;
+
+	switch (num) {
+	case 2:  /* Read reg */
+		if (msgs[0].len != 1 || msgs[1].len != 1)
+			goto err_out;
+
+		if ((msgs[1].flags & I2C_M_RD) != I2C_M_RD)
+			goto err_out;
+		smi2021_get_reg(smi2021, msgs[0].addr, msgs[0].buf[0],
+							msgs[1].buf);
+		break;
+	case 1: /* Write reg */
+		if (msgs[0].len == 0)
+			break;
+		else if (msgs[0].len != 2)
+			goto err_out;
+		if (msgs[0].buf[0] == 0)
+			break;
+		smi2021_set_reg(smi2021, msgs[0].addr, msgs[0].buf[0],
+							msgs[0].buf[1]);
+		break;
+	default:
+		goto err_out;
+	}
+	return num;
+
+err_out:
+	return -EOPNOTSUPP;
+}
+
+static u32 smi2021_i2c_functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_SMBUS_EMUL;
+}
+
+static struct i2c_algorithm smi2021_algo = {
+	.master_xfer = smi2021_i2c_xfer,
+	.functionality = smi2021_i2c_functionality,
+};
+
+/* gm7113c_init table overrides */
+static enum saa7113_r10_ofts r10_ofts = SAA7113_OFTS_VFLAG_BY_VREF;
+static bool r10_vrln = true;
+static bool r13_adlsb = true;
+
+static struct saa7115_platform_data gm7113c_data = {
+	.saa7113_r10_ofts = &r10_ofts,
+	.saa7113_r10_vrln = &r10_vrln,
+	.saa7113_r13_adlsb = &r13_adlsb,
+};
+
+static struct i2c_board_info gm7113c_info = {
+	.type = "gm7113c",
+	.addr = 0x4a,
+	.platform_data = &gm7113c_data,
+};
+
+static int smi2021_initialize(struct smi2021 *smi2021)
+{
+	int i, rc;
+
+	/*
+	 * These registers initializes the smi2021 chip,
+	 * but I have not been able to figure out exactly what they do.
+	 * My guess is that they toggle the reset pins of the
+	 * cs5350 and gm7113c chips.
+	 */
+	static const u16 init[][2] = {
+		{ 0x3a, 0x80 },
+		{ 0x3b, 0x00 },
+		{ 0x34, 0x01 },
+		{ 0x35, 0x00 },
+		{ 0x34, 0x11 },
+		{ 0x35, 0x11 },
+		{ 0x3b, 0x80 },
+		{ 0x3b, 0x00 },
+	};
+
+	for (i = 0; i < ARRAY_SIZE(init); i++) {
+		rc = smi2021_set_reg(smi2021, 0x00, init[i][0], init[i][1]);
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
+
+static struct smi2021_buf *smi2021_get_buf(struct smi2021 *smi2021)
+{
+	unsigned long flags;
+	struct smi2021_buf *buf = NULL;
+
+	spin_lock_irqsave(&smi2021->buf_lock, flags);
+	if (list_empty(&smi2021->bufs)) {
+		/* No free buffers, userspace likely to slow! */
+		spin_unlock_irqrestore(&smi2021->buf_lock, flags);
+		return NULL;
+	}
+	buf = list_first_entry(&smi2021->bufs, struct smi2021_buf, list);
+	list_del(&buf->list);
+	spin_unlock_irqrestore(&smi2021->buf_lock, flags);
+
+	return buf;
+}
+
+static void smi2021_buf_done(struct smi2021 *smi2021)
+{
+	struct smi2021_buf *buf = smi2021->cur_buf;
+
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	buf->vb.v4l2_buf.sequence = smi2021->sequence++;
+	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
+
+	if (buf->pos < (SMI2021_BYTES_PER_LINE * smi2021->cur_height)) {
+		vb2_set_plane_payload(&buf->vb, 0, 0);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	} else {
+		vb2_set_plane_payload(&buf->vb, 0, buf->pos);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	}
+
+	smi2021->cur_buf = NULL;
+}
+
+#define is_sav(trc)						\
+	((trc & SMI2021_TRC_EAV) == 0x00)
+#define is_field2(trc)						\
+	((trc & SMI2021_TRC_FIELD_2) == SMI2021_TRC_FIELD_2)
+#define is_active_video(trc)					\
+	((trc & SMI2021_TRC_VBI) == 0x00)
+/*
+ * Parse the TRC.
+ * Grab a new buffer from the queue if don't have one
+ * and we are recieving the start of a video frame.
+ *
+ * Mark video buffers as done if we have one full frame.
+ */
+static void parse_trc(struct smi2021 *smi2021, u8 trc)
+{
+	struct smi2021_buf *buf = smi2021->cur_buf;
+	int lines_per_field = smi2021->cur_height / 2;
+	int line = 0;
+
+	if (buf == NULL) {
+		if (!is_sav(trc))
+			return;
+
+		if (!is_active_video(trc))
+			return;
+
+		if (is_field2(trc))
+			return;
+
+		buf = smi2021_get_buf(smi2021);
+		if (buf == NULL)
+			return;
+
+		smi2021->cur_buf = buf;
+	}
+
+	if (is_sav(trc)) {
+		/* Start of VBI or ACTIVE VIDEO */
+		if (is_active_video(trc)) {
+			buf->in_blank = false;
+			buf->trc_av++;
+		} else {
+			/* VBI */
+			buf->in_blank = true;
+		}
+
+		if (!buf->second_field && is_field2(trc)) {
+			line = buf->pos / SMI2021_BYTES_PER_LINE;
+			if (line < lines_per_field)
+				goto buf_done;
+
+			buf->second_field = true;
+			buf->trc_av = 0;
+		}
+
+		if (buf->second_field && !is_field2(trc))
+			goto buf_done;
+	} else {
+		/* End of VBI or ACTIVE VIDEO */
+		buf->in_blank = true;
+	}
+
+	return;
+
+buf_done:
+	smi2021_buf_done(smi2021);
+}
+
+static void copy_video(struct smi2021 *smi2021, u8 p)
+{
+	struct smi2021_buf *buf = smi2021->cur_buf;
+
+	int lines_per_field = smi2021->cur_height / 2;
+	int line = 0;
+	int pos_in_line = 0;
+	unsigned int offset = 0;
+	u8 *dst;
+
+	if (buf == NULL)
+		return;
+
+	if (buf->in_blank)
+		return;
+
+	if (buf->pos >= buf->length) {
+		smi2021_buf_done(smi2021);
+		return;
+	}
+
+	pos_in_line = buf->pos % SMI2021_BYTES_PER_LINE;
+	line = buf->pos / SMI2021_BYTES_PER_LINE;
+	if (line >= lines_per_field)
+			line -= lines_per_field;
+
+	if (line != buf->trc_av - 1) {
+		/* Keep video synchronized.
+		 * The device will sometimes give us too many bytes
+		 * for a line, before we get a new TRC.
+		 * We just drop these bytes */
+		return;
+	}
+
+	if (buf->second_field)
+		offset += SMI2021_BYTES_PER_LINE;
+
+	offset += (SMI2021_BYTES_PER_LINE * line * 2) + pos_in_line;
+
+	/* Will this ever happen? */
+	if (offset >= buf->length)
+		return;
+
+	dst = buf->mem + offset;
+	*dst = p;
+	buf->pos++;
+}
+
+/*
+ * Scan the saa7113 Active video data.
+ * This data is:
+ *	4 bytes header (0xff 0x00 0x00 [TRC/SAV])
+ *	1440 bytes of UYUV Video data
+ *	4 bytes footer (0xff 0x00 0x00 [TRC/EAV])
+ *
+ * TRC = Time Reference Code.
+ * SAV = Start Active Video.
+ * EAV = End Active Video.
+ * This is described in the saa7113 datasheet.
+ */
+static void parse_video(struct smi2021 *smi2021, u8 *p, int size)
+{
+	int i;
+
+	for (i = 0; i < size; i++) {
+		switch (smi2021->sync_state) {
+		case HSYNC:
+			if (p[i] == 0xff)
+				smi2021->sync_state = SYNCZ1;
+			else
+				copy_video(smi2021, p[i]);
+			break;
+		case SYNCZ1:
+			if (p[i] == 0x00) {
+				smi2021->sync_state = SYNCZ2;
+			} else {
+				smi2021->sync_state = HSYNC;
+				copy_video(smi2021, 0xff);
+				copy_video(smi2021, p[i]);
+			}
+			break;
+		case SYNCZ2:
+			if (p[i] == 0x00) {
+				smi2021->sync_state = TRC;
+			} else {
+				smi2021->sync_state = HSYNC;
+				copy_video(smi2021, 0xff);
+				copy_video(smi2021, 0x00);
+				copy_video(smi2021, p[i]);
+			}
+			break;
+		case TRC:
+			smi2021->sync_state = HSYNC;
+			parse_trc(smi2021, p[i]);
+			break;
+		}
+	}
+}
+
+/*
+ * The device delivers data in chunks of 0x400 bytes.
+ * The four first bytes is a magic header to identify the chunks.
+ *	0xaa 0xaa 0x00 0x00 = saa7113 Active Video Data
+ *	0xaa 0xaa 0x00 0x01 = PCM - 24Bit 2 Channel audio data
+ */
+static void process_packet(struct smi2021 *smi2021, u8 *p, int size)
+{
+	int i;
+	u32 *header;
+
+	if (size % 0x400 != 0) {
+		printk_ratelimited(KERN_INFO "smi2021::%s: size: %d\n",
+				__func__, size);
+		return;
+	}
+
+	for (i = 0; i < size; i += 0x400) {
+		header = (u32 *)(p + i);
+		switch (*header) {
+		case cpu_to_be32(0xaaaa0000):
+			parse_video(smi2021, p+i+4, 0x400-4);
+			break;
+		case cpu_to_be32(0xaaaa0001):
+			smi2021_audio(smi2021, p+i+4, 0x400-4);
+			break;
+		}
+	}
+}
+
+static void smi2021_iso_cb(struct urb *ip)
+{
+	int i, rc;
+	struct smi2021 *smi2021 = ip->context;
+
+	switch (ip->status) {
+	case 0:
+	/* All fine */
+		break;
+	/* Device disconnected or capture stopped? */
+	case -ENODEV:
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+		return;
+	/* Unknown error, retry */
+	default:
+		dev_warn(smi2021->dev, "urb error! status %d\n", ip->status);
+		goto resubmit;
+	}
+
+	for (i = 0; i < ip->number_of_packets; i++) {
+		int size = ip->iso_frame_desc[i].actual_length;
+		unsigned char *data = ip->transfer_buffer +
+				ip->iso_frame_desc[i].offset;
+		process_packet(smi2021, data, size);
+	}
+
+resubmit:
+	rc = usb_submit_urb(ip, GFP_ATOMIC);
+	if (rc)
+		dev_warn(smi2021->dev, "urb re-submit failed (%d)\n", rc);
+
+}
+
+static struct urb *smi2021_setup_iso_transfer(struct smi2021 *smi2021)
+{
+	struct urb *ip;
+	int i, size = smi2021->iso_size;
+
+	ip = usb_alloc_urb(SMI2021_ISOC_PACKETS, GFP_KERNEL);
+	if (ip == NULL)
+		return NULL;
+
+	ip->dev = smi2021->udev;
+	ip->context = smi2021;
+	ip->pipe = usb_rcvisocpipe(smi2021->udev, SMI2021_ISOC_EP);
+	ip->interval = 1;
+	ip->transfer_flags = URB_ISO_ASAP;
+	ip->transfer_buffer = kzalloc(SMI2021_ISOC_PACKETS * size, GFP_KERNEL);
+	ip->complete = smi2021_iso_cb;
+	ip->number_of_packets = SMI2021_ISOC_PACKETS;
+	ip->transfer_buffer_length = SMI2021_ISOC_PACKETS * size;
+	for (i = 0; i < SMI2021_ISOC_PACKETS; i++) {
+		ip->iso_frame_desc[i].offset = size * i;
+		ip->iso_frame_desc[i].length = size;
+	}
+
+	return ip;
+}
+
+void smi2021_toggle_audio(struct smi2021 *smi2021, bool enable)
+{
+	/*
+	 * I know that setting this register enables and disables
+	 * the transfer of audio data over usb.
+	 * I have no idea about what the number 0x1d really represents.
+	 * */
+	if (enable)
+		smi2021_set_reg(smi2021, 0, 0x1740, 0x1d);
+	else
+		smi2021_set_reg(smi2021, 0, 0x1740, 0x00);
+}
+
+int smi2021_start(struct smi2021 *smi2021)
+{
+	int i, rc;
+	u8 reg;
+	smi2021->sync_state = HSYNC;
+
+	v4l2_device_call_all(&smi2021->v4l2_dev, 0, video, s_stream, 1);
+
+	/*
+	 * Enble automatic field detection on gm7113c (Bit 7)
+	 * It seems the device needs this to not fail when receiving bad video
+	 * i.e. from an old VHS tape.
+	 */
+	smi2021_get_reg(smi2021, 0x4a, 0x08, &reg);
+	smi2021_set_reg(smi2021, 0x4a, 0x08, reg | 0x80);
+
+	/*
+	 * Reset RTSO0 6 Times (Bit 7)
+	 * The Windows driver does this, not sure if it's really needed.
+	 */
+	smi2021_get_reg(smi2021, 0x4a, 0x0e, &reg);
+	reg |= 0x80;
+	for (i = 0; i < 6; i++)
+		smi2021_set_reg(smi2021, 0x4a, 0x0e, reg);
+
+	rc = smi2021_set_mode(smi2021, SMI2021_MODE_CAPTURE);
+	if (rc < 0)
+		goto start_fail;
+
+	rc = usb_set_interface(smi2021->udev, 0, 2);
+	if (rc < 0)
+		goto start_fail;
+
+	smi2021_toggle_audio(smi2021, false);
+
+	for (i = 0; i < SMI2021_ISOC_TRANSFERS; i++) {
+		struct urb *ip;
+
+		ip = smi2021_setup_iso_transfer(smi2021);
+		if (ip == NULL) {
+			rc = -ENOMEM;
+			goto start_fail;
+		}
+		smi2021->isoc_urbs[i] = ip;
+		rc = usb_submit_urb(ip, GFP_KERNEL);
+		if (rc < 0)
+			goto start_fail;
+	}
+
+	/* I have no idea about what this register does with this value. */
+	smi2021_set_reg(smi2021, 0, 0x1800, 0x0d);
+
+	return 0;
+
+start_fail:
+	smi2021_stop(smi2021);
+
+	return rc;
+
+}
+
+void smi2021_stop(struct smi2021 *smi2021)
+{
+	int i;
+	unsigned long flags;
+
+	/* Cancel running transfers */
+	for (i = 0; i < SMI2021_ISOC_TRANSFERS; i++) {
+		struct urb *ip = smi2021->isoc_urbs[i];
+		if (ip == NULL)
+			continue;
+		usb_kill_urb(ip);
+		kfree(ip->transfer_buffer);
+		usb_free_urb(ip);
+		smi2021->isoc_urbs[i] = NULL;
+	}
+
+	usb_set_interface(smi2021->udev, 0, 0);
+	smi2021_set_mode(smi2021, SMI2021_MODE_STANDBY);
+
+	smi2021_stop_audio(smi2021);
+
+	/* Return buffers to userspace */
+	spin_lock_irqsave(&smi2021->buf_lock, flags);
+	while (!list_empty(&smi2021->bufs)) {
+		struct smi2021_buf *buf = list_first_entry(&smi2021->bufs,
+						struct smi2021_buf, list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		list_del(&buf->list);
+	}
+	spin_unlock_irqrestore(&smi2021->buf_lock, flags);
+
+	return;
+}
+
+static void smi2021_release(struct v4l2_device *v4l2_dev)
+{
+	struct smi2021 *smi2021 = container_of(v4l2_dev, struct smi2021,
+								v4l2_dev);
+	i2c_del_adapter(&smi2021->i2c_adap);
+
+	v4l2_ctrl_handler_free(&smi2021->ctrl_handler);
+	v4l2_device_unregister(&smi2021->v4l2_dev);
+	vb2_queue_release(&smi2021->vb2q);
+	kfree(smi2021);
+}
+
+/************************************************************************
+ *									*
+ *          DEVICE  -  PROBE   &   DISCONNECT				*
+ *									*
+ ***********************************************************************/
+
+static const struct usb_device_id smi2021_usb_device_id_table[] = {
+	{ USB_DEVICE(VENDOR_ID, BOOTLOADER_ID)	},
+	{ USB_DEVICE(VENDOR_ID, 0x003c)		},
+	{ USB_DEVICE(VENDOR_ID, 0x003d)		},
+	{ USB_DEVICE(VENDOR_ID, 0x003e)		},
+	{ USB_DEVICE(VENDOR_ID, 0x003f)		},
+	{ }
+};
+MODULE_DEVICE_TABLE(usb, smi2021_usb_device_id_table);
+
+static const struct smi2021_vid_input dual_input[] = {
+	{
+		.name = "Composite",
+		.type = SAA7115_COMPOSITE0,
+	},
+	{
+		.name = "S-Video",
+		.type = SAA7115_SVIDEO1,
+	}
+};
+
+static const struct smi2021_vid_input quad_input[] = {
+	{
+		.name = "Composite 0",
+		.type = SAA7115_COMPOSITE0,
+	},
+	{
+		.name = "Composite 1",
+		.type = SAA7115_COMPOSITE1,
+	},
+	{
+		.name = "Composite 2",
+		.type = SAA7115_COMPOSITE2,
+	},
+	{
+		.name = "Composite 3",
+		.type = SAA7115_COMPOSITE3,
+	},
+};
+
+
+static int smi2021_usb_probe(struct usb_interface *intf,
+					const struct usb_device_id *devid)
+{
+	int rc, size, input_count;
+	const struct smi2021_vid_input *vid_inputs;
+	struct device *dev = &intf->dev;
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct smi2021 *smi2021;
+
+	if (udev->descriptor.idProduct == BOOTLOADER_ID)
+		return smi2021_bootloader_probe(intf, devid);
+
+	if (intf->num_altsetting != 3)
+		return -ENODEV;
+	if (intf->altsetting[2].desc.bNumEndpoints != 1)
+		return -ENODEV;
+
+	size = usb_endpoint_maxp(&intf->altsetting[2].endpoint[0].desc);
+	size = (size & 0x07ff) * (((size & 0x1800) >> 11) + 1);
+
+	switch (udev->descriptor.idProduct) {
+	case 0x3e:
+	case 0x3f:
+		input_count = ARRAY_SIZE(quad_input);
+		vid_inputs = quad_input;
+		break;
+	case 0x3c:
+	case 0x3d:
+	default:
+		input_count = ARRAY_SIZE(dual_input);
+		vid_inputs = dual_input;
+	}
+
+	smi2021 = kzalloc(sizeof(struct smi2021), GFP_KERNEL);
+	if (dev == NULL)
+		return -ENOMEM;
+
+	smi2021->dev = dev;
+	smi2021->udev = usb_get_dev(udev);
+
+	smi2021->vid_input_count = input_count;
+	smi2021->vid_inputs = vid_inputs;
+	smi2021->iso_size = size;
+
+	/* videobuf2 struct and locks */
+	smi2021->cur_norm = V4L2_STD_NTSC;
+	smi2021->cur_height = SMI2021_NTSC_LINES;
+
+	spin_lock_init(&smi2021->buf_lock);
+	mutex_init(&smi2021->v4l2_lock);
+	mutex_init(&smi2021->vb2q_lock);
+	INIT_LIST_HEAD(&smi2021->bufs);
+
+	rc = smi2021_vb2_setup(smi2021);
+	if (rc < 0) {
+		dev_warn(dev, "Could not initialize videobuf2 queue\n");
+		goto smi2021_fail;
+	}
+
+	rc = v4l2_ctrl_handler_init(&smi2021->ctrl_handler, 0);
+	if (rc < 0) {
+		dev_warn(dev, "Could not initialize v4l2 ctrl handler\n");
+		goto ctrl_fail;
+	}
+
+	/* v4l2 struct */
+	smi2021->v4l2_dev.release = smi2021_release;
+	smi2021->v4l2_dev.ctrl_handler = &smi2021->ctrl_handler;
+	rc = v4l2_device_register(dev, &smi2021->v4l2_dev);
+	if (rc < 0) {
+		dev_warn(dev, "Could not register v4l2 device\n");
+		goto v4l2_fail;
+	}
+
+	smi2021_initialize(smi2021);
+
+	/* i2c adapter */
+	strlcpy(smi2021->i2c_adap.name, "smi2021",
+				sizeof(smi2021->i2c_adap.name));
+	smi2021->i2c_adap.dev.parent = smi2021->dev;
+	smi2021->i2c_adap.owner = THIS_MODULE;
+	smi2021->i2c_adap.algo = &smi2021_algo;
+	smi2021->i2c_adap.algo_data = smi2021;
+	i2c_set_adapdata(&smi2021->i2c_adap, &smi2021->v4l2_dev);
+	rc = i2c_add_adapter(&smi2021->i2c_adap);
+	if (rc < 0) {
+		dev_warn(dev, "Could not add i2c adapter\n");
+		goto i2c_fail;
+	}
+
+	/* i2c client */
+	strlcpy(smi2021->i2c_client.name, "smi2021 internal",
+				sizeof(smi2021->i2c_client.name));
+	smi2021->i2c_client.adapter = &smi2021->i2c_adap;
+	smi2021->gm7113c_subdev = v4l2_i2c_new_subdev_board(&smi2021->v4l2_dev,
+							&smi2021->i2c_adap,
+							&gm7113c_info, NULL);
+
+
+	v4l2_device_call_all(&smi2021->v4l2_dev, 0, video, s_routing,
+			smi2021->vid_inputs[smi2021->cur_input].type, 0, 0);
+	v4l2_device_call_all(&smi2021->v4l2_dev, 0, core, s_std,
+			smi2021->cur_norm);
+
+	usb_set_intfdata(intf, smi2021);
+	smi2021_snd_register(smi2021);
+
+
+	/* video structure */
+	rc = smi2021_video_register(smi2021);
+	if (rc < 0) {
+		dev_warn(dev, "Could not register video device\n");
+		goto vdev_fail;
+	}
+
+	dev_info(dev, "Somagic Easy-Cap Video Grabber\n");
+	return 0;
+
+vdev_fail:
+	i2c_del_adapter(&smi2021->i2c_adap);
+i2c_fail:
+	v4l2_device_unregister(&smi2021->v4l2_dev);
+v4l2_fail:
+	v4l2_ctrl_handler_free(&smi2021->ctrl_handler);
+ctrl_fail:
+	vb2_queue_release(&smi2021->vb2q);
+smi2021_fail:
+	kfree(smi2021);
+
+	return rc;
+
+}
+
+static void smi2021_usb_disconnect(struct usb_interface *intf)
+{
+	struct smi2021 *smi2021;
+	struct usb_device *udev = interface_to_usbdev(intf);
+
+	if (udev->descriptor.idProduct == BOOTLOADER_ID)
+		return smi2021_bootloader_disconnect(intf);
+
+	smi2021 = usb_get_intfdata(intf);
+	smi2021_snd_unregister(smi2021);
+
+	mutex_lock(&smi2021->vb2q_lock);
+	mutex_lock(&smi2021->v4l2_lock);
+
+	usb_set_intfdata(intf, NULL);
+	video_unregister_device(&smi2021->vdev);
+	v4l2_device_disconnect(&smi2021->v4l2_dev);
+	usb_put_dev(smi2021->udev);
+	smi2021->udev = NULL;
+
+	mutex_unlock(&smi2021->v4l2_lock);
+	mutex_unlock(&smi2021->vb2q_lock);
+
+	v4l2_device_put(&smi2021->v4l2_dev);
+}
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jon Arne Jørgensen <jonjon.arnearne--a.t--gmail.com>");
+MODULE_DESCRIPTION("SMI2021 - EasyCap");
+MODULE_VERSION(SMI2021_DRIVER_VERSION);
+
+struct usb_driver smi2021_usb_driver = {
+	.name = "smi2021",
+	.id_table = smi2021_usb_device_id_table,
+	.probe = smi2021_usb_probe,
+	.disconnect = smi2021_usb_disconnect
+};
+
+module_usb_driver(smi2021_usb_driver);
diff --git a/drivers/media/usb/smi2021/smi2021_v4l2.c b/drivers/media/usb/smi2021/smi2021_v4l2.c
new file mode 100644
index 0000000..4a4eb3c
--- /dev/null
+++ b/drivers/media/usb/smi2021/smi2021_v4l2.c
@@ -0,0 +1,277 @@
+/************************************************************************
+ * smi2021_v4l2.c							*
+ *									*
+ * USB Driver for smi2021 - EasyCap					*
+ * **********************************************************************
+ *
+ * Copyright 2011-2013 Jon Arne Jørgensen
+ * <jonjon.arnearne--a.t--gmail.com>
+ *
+ * Copyright 2011, 2012 Tony Brown, Michal Demin, Jeffry Johnston
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ * This driver is heavily influensed by the STK1160 driver.
+ * Copyright (C) 2012 Ezequiel Garcia
+ * <elezegarcia--a.t--gmail.com>
+ *
+ */
+
+#include "smi2021.h"
+
+static int vidioc_querycap(struct file *file, void *priv,
+			struct v4l2_capability *cap)
+{
+	struct smi2021 *smi2021 = video_drvdata(file);
+
+	strlcpy(cap->driver, "smi2021", sizeof(cap->driver));
+	strlcpy(cap->card, "smi2021", sizeof(cap->card));
+	usb_make_path(smi2021->udev, cap->bus_info, sizeof(cap->bus_info));
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
+			   V4L2_CAP_STREAMING |
+			   V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+static int vidioc_enum_input(struct file *file, void *priv,
+				struct v4l2_input *i)
+{
+	struct smi2021 *smi2021 = video_drvdata(file);
+
+	if (i->index >= smi2021->vid_input_count)
+		return -EINVAL;
+
+	strlcpy(i->name, smi2021->vid_inputs[i->index].name, sizeof(i->name));
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	i->std = smi2021->vdev.tvnorms;
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+			struct v4l2_fmtdesc *f)
+{
+	if (f->index != 0)
+		return -EINVAL;
+
+	strlcpy(f->description, "16bpp YU2, 4:2:2, packed",
+					sizeof(f->description));
+	f->pixelformat = V4L2_PIX_FMT_UYVY;
+	return 0;
+}
+
+static int vidioc_fmt_vid_cap(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct smi2021 *smi2021 = video_drvdata(file);
+
+	f->fmt.pix.width = SMI2021_BYTES_PER_LINE / 2;
+	f->fmt.pix.height = smi2021->cur_height;
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
+	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.bytesperline = SMI2021_BYTES_PER_LINE;
+	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
+	return 0;
+}
+
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
+{
+	struct smi2021 *smi2021 = video_drvdata(file);
+	*norm = smi2021->cur_norm;
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	struct smi2021 *smi2021 = video_drvdata(file);
+	*i = smi2021->cur_input;
+	return 0;
+}
+
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
+{
+	struct smi2021 *smi2021 = video_drvdata(file);
+
+	if (vb2_is_busy(&smi2021->vb2q))
+		return -EBUSY;
+
+	smi2021->cur_norm = norm;
+	if (norm & V4L2_STD_525_60)
+		smi2021->cur_height = SMI2021_NTSC_LINES;
+	else if (norm & V4L2_STD_625_50)
+		smi2021->cur_height = SMI2021_PAL_LINES;
+	else
+		return -EINVAL;
+
+	v4l2_device_call_all(&smi2021->v4l2_dev, 0, core, s_std,
+			     smi2021->cur_norm);
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	struct smi2021 *smi2021 = video_drvdata(file);
+	if (i >= smi2021->vid_input_count)
+		return -EINVAL;
+
+	v4l2_device_call_all(&smi2021->v4l2_dev, 0, video, s_routing,
+		smi2021->vid_inputs[i].type, 0, 0);
+	smi2021->cur_input = i;
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops smi2021_ioctl_ops = {
+	.vidioc_querycap		= vidioc_querycap,
+	.vidioc_enum_input		= vidioc_enum_input,
+	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= vidioc_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap		= vidioc_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap		= vidioc_fmt_vid_cap,
+	.vidioc_g_std			= vidioc_g_std,
+	.vidioc_s_std			= vidioc_s_std,
+	.vidioc_g_input			= vidioc_g_input,
+	.vidioc_s_input			= vidioc_s_input,
+
+	/* vb2 handle these */
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+
+	/* v4l2-event and v4l2-cntrl handle these */
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+};
+
+static struct v4l2_file_operations smi2021_fops = {
+	.owner = THIS_MODULE,
+	.open = v4l2_fh_open,
+	.release = vb2_fop_release,
+	.read = vb2_fop_read,
+	.poll = vb2_fop_poll,
+	.mmap = vb2_fop_mmap,
+	.unlocked_ioctl = video_ioctl2,
+};
+
+/************************************************************************
+ *									*
+ *          Videobuf2 operations					*
+ *									*
+ ***********************************************************************/
+static int queue_setup(struct vb2_queue *vq,
+				const struct v4l2_format *v4l2_fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct smi2021 *smi2021 = vb2_get_drv_priv(vq);
+	*nbuffers = clamp_t(unsigned int, *nbuffers, 4, 16);
+
+	*nplanes = 1;
+	sizes[0] = SMI2021_BYTES_PER_LINE * smi2021->cur_height;
+
+	return 0;
+}
+
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	unsigned long flags;
+	struct smi2021 *smi2021 = vb2_get_drv_priv(vb->vb2_queue);
+	struct smi2021_buf *buf = container_of(vb, struct smi2021_buf, vb);
+
+	if (smi2021->udev == NULL) {
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+		return;
+	}
+
+	buf->mem = vb2_plane_vaddr(vb, 0);
+	buf->length = vb2_plane_size(vb, 0);
+
+	buf->pos = 0;
+	buf->trc_av = 0;
+	buf->in_blank = true;
+	buf->second_field = false;
+
+	spin_lock_irqsave(&smi2021->buf_lock, flags);
+	if (buf->length < smi2021->cur_height * SMI2021_BYTES_PER_LINE)
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	else
+		list_add_tail(&buf->list, &smi2021->bufs);
+	spin_unlock_irqrestore(&smi2021->buf_lock, flags);
+}
+
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct smi2021 *smi2021 = vb2_get_drv_priv(vq);
+
+	if (smi2021->udev == NULL)
+		return -ENODEV;
+
+	return smi2021_start(smi2021);
+}
+
+static int stop_streaming(struct vb2_queue *vq)
+{
+	struct smi2021 *smi2021 = vb2_get_drv_priv(vq);
+
+	if (smi2021->udev == NULL)
+		return -ENODEV;
+
+	smi2021_stop(smi2021);
+	return 0;
+}
+
+static struct vb2_ops smi2021_vb2_ops = {
+	.queue_setup		= queue_setup,
+	.buf_queue		= buffer_queue,
+	.start_streaming	= start_streaming,
+	.stop_streaming		= stop_streaming,
+};
+
+int smi2021_vb2_setup(struct smi2021 *smi2021)
+{
+	smi2021->vb2q.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	smi2021->vb2q.io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
+	smi2021->vb2q.drv_priv = smi2021;
+	smi2021->vb2q.buf_struct_size = sizeof(struct smi2021_buf);
+	smi2021->vb2q.ops = &smi2021_vb2_ops;
+	smi2021->vb2q.mem_ops = &vb2_vmalloc_memops;
+	smi2021->vb2q.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	smi2021->vb2q.lock = &smi2021->vb2q_lock;
+
+	return vb2_queue_init(&smi2021->vb2q);
+}
+
+int smi2021_video_register(struct smi2021 *smi2021)
+{
+	strlcpy(smi2021->vdev.name, "smi2021", sizeof(smi2021->vdev.name));
+	smi2021->vdev.v4l2_dev = &smi2021->v4l2_dev;
+	smi2021->vdev.release = video_device_release_empty;
+	smi2021->vdev.fops = &smi2021_fops;
+	smi2021->vdev.ioctl_ops = &smi2021_ioctl_ops;
+	smi2021->vdev.tvnorms = V4L2_STD_ALL;
+	smi2021->vdev.queue = &smi2021->vb2q;
+	smi2021->vdev.lock = &smi2021->v4l2_lock;
+	set_bit(V4L2_FL_USE_FH_PRIO, &smi2021->vdev.flags);
+	video_set_drvdata(&smi2021->vdev, smi2021);
+
+	return video_register_device(&smi2021->vdev, VFL_TYPE_GRABBER, -1);
+}
-- 
1.8.3.4

