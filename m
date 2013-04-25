Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab3DYTPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 15:15:47 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:48459 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755613Ab3DYTP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 15:15:27 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: jonjon.arnearne@gmail.com, linux-kernel@vger.kernel.org,
        hverkuil@xs4all.nl, elezegarcia@gmail.com, mkrufky@linuxtv.org,
        mchehab@redhat.com, bjorn@mork.no
Subject: [RFC V2 2/3] [smi2021] This is the smi2021 driver
Date: Thu, 25 Apr 2013 21:10:19 +0200
Message-Id: <1366917020-18217-3-git-send-email-jonarne@jonarne.no>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1366917020-18217-1-git-send-email-jonarne@jonarne.no>
References: <1366917020-18217-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
---
 drivers/media/usb/smi2021/smi2021.h            | 278 +++++++++++++
 drivers/media/usb/smi2021/smi2021_audio.c      | 380 +++++++++++++++++
 drivers/media/usb/smi2021/smi2021_bootloader.c | 261 ++++++++++++
 drivers/media/usb/smi2021/smi2021_i2c.c        | 137 +++++++
 drivers/media/usb/smi2021/smi2021_main.c       | 431 ++++++++++++++++++++
 drivers/media/usb/smi2021/smi2021_v4l2.c       | 542 ++++++++++++++++++++++++
 drivers/media/usb/smi2021/smi2021_video.c      | 544 +++++++++++++++++++++++++
 7 files changed, 2573 insertions(+)
 create mode 100644 drivers/media/usb/smi2021/smi2021.h
 create mode 100644 drivers/media/usb/smi2021/smi2021_audio.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_bootloader.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_i2c.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_main.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_v4l2.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_video.c

diff --git a/drivers/media/usb/smi2021/smi2021.h b/drivers/media/usb/smi2021/smi2021.h
new file mode 100644
index 0000000..bf2235a
--- /dev/null
+++ b/drivers/media/usb/smi2021/smi2021.h
@@ -0,0 +1,278 @@
+/*******************************************************************************
+ * smi2021.h                                                                   *
+ *                                                                             *
+ * USB Driver for SMI2021 - EasyCap                                            *
+ * *****************************************************************************
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
+#include <linux/types.h>
+#include <linux/spinlock_types.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+
+#include <media/v4l2-event.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-chip-ident.h>
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
+/* For ISOC */
+#define SMI2021_MAX_PKT_SIZE	3072
+#define SMI2021_ISOC_PACKETS	10	/* 64 */
+#define SMI2021_ISOC_BUFS	4	/* 16 */
+#define SMI2021_ISOC_EP		0x82
+
+/* General USB control setup */
+#define SMI2021_USB_REQUEST	0x01
+#define SMI2021_USB_INDEX	0x00
+#define SMI2021_USB_PIPE_OUT	0x00
+#define SMI2021_USB_PIPE_IN	0x80
+
+/* Hardware constants */
+#define SMI2021_HW_STATE_HEAD		0x01
+#define SMI2021_HW_STATE_STANDBY	0x03
+#define SMI2021_HW_STATE_CAPTURE	0x05
+
+#define SMI2021_CTRL_HEAD		0x0b
+
+/* Flags passed to the device in control transfers */
+#define SMI2021_DATA_TYPE_FLAG_I2C		0x80
+#define SMI2021_DATA_TYPE_FLAG_WRITE		0x40
+#define SMI2021_DATA_TYPE_FLAG_READ		0x20
+#define SMI2021_DATA_TYPE_FLAG_PREPARE_READ	0x04
+
+#define SMI2021_DATA_OFFSET_FLAG_SMI		0x80
+#define SMI2021_DATA_OFFSET_SIZE_MASK		0x0f
+
+/* smi2021 ports */
+#define SMI2021_DDR_PORT			0x3a
+#define SMI2021_DATA_PORT			0x3b
+#define SMI2021_RESET_PIN			0x80
+#define SMI2021_AUDIO_PORT			0x1740
+#define SMI2021_AUDIO_ENABLE			0x1d
+
+/* General video constants */
+#define SMI2021_BYTES_PER_LINE	1440
+#define SMI2021_PAL_LINES	576
+#define SMI2021_NTSC_LINES	486
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
+enum smi2021_sync {
+	HSYNC,
+	SYNCZ1,
+	SYNCZ2,
+	TRC
+};
+
+enum smi2021_config {
+	SMI2021_DUAL_INPUT,
+	SMI2021_QUAD_INPUT
+};
+
+/* Structs passed on USB for device setup */
+
+struct smi2021_set_hw_state {
+	u8 head;
+	u8 state;
+} __packed;
+
+struct smi2021_ctrl {
+	u8 head;
+	u8 i2c_addr;
+	u8 bm_data_type;
+	u8 bm_data_offset;
+	u8 size;
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
+	} __packed data;
+	u8 reserved[5];
+} __packed;
+
+/* Buffer for one video frame */
+struct smi2021_buffer {
+	/* Common vb2 stuff, must be first */
+	struct vb2_buffer		vb;
+	struct list_head		list;
+
+	void				*mem;
+	unsigned int			length;
+
+	bool				second_field;
+	bool				in_blank;
+	unsigned int			pos;
+
+	/* ActiveVideo - Line counter */
+	u16				trc_av;
+};
+
+struct smi2021_isoc_ctl {
+	int max_pkt_size;
+	int num_bufs;
+	struct urb **urb;
+	char **transfer_buffer;
+	struct smi2021_buffer *buf;
+};
+
+
+struct smi2021_fmt {
+	char				*name;
+	u32				fourcc;
+	int				depth;
+};
+
+struct smi2021_input {
+	char				*name;
+	int				type;
+};
+
+struct smi2021_dev {
+	struct v4l2_device		v4l2_dev;
+	struct video_device		vdev;
+	struct v4l2_ctrl_handler	ctrl_handler;
+
+	struct v4l2_subdev		*sd_saa7113;
+
+	struct usb_device		*udev;
+	struct device			*dev;
+
+	/* Capture buffer queue */
+	struct vb2_queue		vb_vidq;
+
+	/* ISOC control struct */
+	struct list_head		avail_bufs;
+	struct smi2021_isoc_ctl		isoc_ctl;
+
+	enum smi2021_config		device_cfg;
+
+	int				width;		/* frame width */
+	int				height;		/* frame height */
+	unsigned int			ctl_input;	/* selected input */
+	v4l2_std_id			norm;		/* current norm */
+	const struct smi2021_fmt	*fmt;		/* selected format */
+	unsigned int			buf_count;	/* for video buffers */
+
+	/* i2c i/o */
+	struct i2c_adapter		i2c_adap;
+	struct i2c_client		i2c_client;
+
+	struct mutex			v4l2_lock;
+	struct mutex			vb_queue_lock;
+	spinlock_t			buf_lock;
+
+	enum smi2021_sync		sync_state;
+
+	/* audio */
+	struct snd_card			*snd_card;
+	struct snd_pcm_substream	*pcm_substream;
+
+	unsigned int			pcm_write_ptr;
+	unsigned int			pcm_complete_samples;
+
+	u8				pcm_read_offset;
+	struct work_struct		adev_capture_trigger;
+	atomic_t			adev_capturing;
+};
+
+/* Provided by smi2021_bootloader.c */
+int smi2021_bootloader_probe(struct usb_interface *intf,
+					const struct usb_device_id *devid);
+void smi2021_bootloader_disconnect(struct usb_interface *intf);
+
+/* Provided by smi2021_main.c */
+int smi2021_write_reg(struct smi2021_dev *dev, u8 addr, u16 reg, u8 val);
+int smi2021_read_reg(struct smi2021_dev *dev, u8 addr, u16 reg, u8 *val);
+int smi2021_set_hw_state(struct smi2021_dev *dev, u8 state);
+int smi2021_enable_audio(struct smi2021_dev *dev);
+
+/* Provided by smi2021_v4l2.c */
+int smi2021_vb2_setup(struct smi2021_dev *dev);
+int smi2021_video_register(struct smi2021_dev *dev);
+void smi2021_clear_queue(struct smi2021_dev *dev);
+
+/* Provided by smi2021_video.c */
+int smi2021_alloc_isoc(struct smi2021_dev *dev);
+void smi2021_free_isoc(struct smi2021_dev *dev);
+void smi2021_cancel_isoc(struct smi2021_dev *dev);
+void smi2021_uninit_isoc(struct smi2021_dev *dev);
+
+/* Provided by smi2021_i2c.c */
+int smi2021_i2c_register(struct smi2021_dev *dev);
+int smi2021_i2c_unregister(struct smi2021_dev *dev);
+
+/* Provided by smi2021_audio.c */
+int smi2021_snd_register(struct smi2021_dev *dev);
+void smi2021_snd_unregister(struct smi2021_dev *dev);
+void smi2021_audio(struct smi2021_dev *dev, u8 *data, int len);
+#endif /* SMI2021_H */
diff --git a/drivers/media/usb/smi2021/smi2021_audio.c b/drivers/media/usb/smi2021/smi2021_audio.c
new file mode 100644
index 0000000..9637153
--- /dev/null
+++ b/drivers/media/usb/smi2021/smi2021_audio.c
@@ -0,0 +1,380 @@
+/*******************************************************************************
+ * smi2021_audio.c                                                             *
+ *                                                                             *
+ * USB Driver for SMI2021 - EasyCap                                            *
+ * *****************************************************************************
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
+	struct smi2021_dev *dev = snd_pcm_substream_chip(substream);
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	int rc;
+
+	rc = snd_pcm_hw_constraint_pow2(runtime, 0,
+					SNDRV_PCM_HW_PARAM_PERIODS);
+	if (rc < 0)
+		return rc;
+
+	dev->pcm_substream = substream;
+
+	runtime->hw = smi2021_pcm_hw;
+	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
+
+	smi2021_dbg("PCM device open!\n");
+
+	return 0;
+}
+
+static int smi2021_pcm_close(struct snd_pcm_substream *substream)
+{
+	struct smi2021_dev *dev = snd_pcm_substream_chip(substream);
+	smi2021_dbg("PCM device closing\n");
+
+	if (atomic_read(&dev->adev_capturing)) {
+		atomic_set(&dev->adev_capturing, 0);
+		schedule_work(&dev->adev_capture_trigger);
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
+	struct smi2021_dev *dev = snd_pcm_substream_chip(substream);
+
+	if (atomic_read(&dev->adev_capturing)) {
+		atomic_set(&dev->adev_capturing, 0);
+		schedule_work(&dev->adev_capture_trigger);
+	}
+
+	pcm_buffer_free(substream);
+	return 0;
+}
+
+static int smi2021_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct smi2021_dev *dev = snd_pcm_substream_chip(substream);
+
+	dev->pcm_complete_samples = 0;
+	dev->pcm_read_offset = 0;
+	dev->pcm_write_ptr = 0;
+
+	return 0;
+}
+
+static void capture_trigger(struct work_struct *work)
+{
+	struct smi2021_dev *dev = container_of(work, struct smi2021_dev,
+					adev_capture_trigger);
+
+	if (atomic_read(&dev->adev_capturing))
+		smi2021_write_reg(dev, 0, 0x1740, 0x1d);
+	else
+		smi2021_write_reg(dev, 0, 0x1740, 0x00);
+}
+
+/* This callback is ATOMIC, must not sleep */
+static int smi2021_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	struct smi2021_dev *dev = snd_pcm_substream_chip(substream);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_START:
+		atomic_set(&dev->adev_capturing, 1);
+		break;
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_STOP:
+		atomic_set(&dev->adev_capturing, 0);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	schedule_work(&dev->adev_capture_trigger);
+
+	return 0;
+}
+
+static snd_pcm_uframes_t smi2021_pcm_pointer(
+					struct snd_pcm_substream *substream)
+{
+	struct smi2021_dev *dev = snd_pcm_substream_chip(substream);
+	return dev->pcm_write_ptr / 8;
+}
+
+static struct page *smi2021_pcm_get_vmalloc_page(struct snd_pcm_substream *subs,
+						unsigned long offset)
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
+int smi2021_snd_register(struct smi2021_dev *dev)
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
+	pcm->private_data = dev;
+	strcpy(pcm->name, "Somagic smi2021 Capture");
+
+	strcpy(card->driver, "smi2021-Audio");
+	strcpy(card->shortname, "smi2021 Audio");
+	strcpy(card->longname, "Somagic smi2021 Audio");
+
+	INIT_WORK(&dev->adev_capture_trigger, capture_trigger);
+
+	rc = snd_card_register(card);
+	if (rc < 0)
+		goto err_free_card;
+
+	dev->snd_card = card;
+
+	return 0;
+
+err_free_card:
+	snd_card_free(card);
+	return rc;
+}
+
+void smi2021_snd_unregister(struct smi2021_dev *dev)
+{
+	if (!dev)
+		return;
+
+	if (!dev->snd_card)
+		return;
+
+	snd_card_free(dev->snd_card);
+	dev->snd_card = NULL;
+}
+
+void smi2021_audio(struct smi2021_dev *dev, u8 *data, int len)
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
+	if (!dev->udev)
+		return;
+
+	if (atomic_read(&dev->adev_capturing) == 0)
+		return;
+
+	if (!dev->pcm_substream)
+		return;
+
+	runtime = dev->pcm_substream->runtime;
+	if (!runtime || !runtime->dma_area)
+		return;
+
+	offset = dev->pcm_read_offset;
+	stride = runtime->frame_bits >> 3;
+
+	if (stride == 0)
+		return;
+
+	diff = dev->pcm_write_ptr;
+
+	/* Check that the end of the last buffer was correct.
+	 * If not correct, we mark any partial frames in buffer as complete
+	 */
+	headptr = dev->pcm_write_ptr - offset - 4;
+	if (dev->pcm_write_ptr > 10 && runtime->dma_area[headptr] != 0x00) {
+		skip = stride - (dev->pcm_write_ptr % stride);
+		snd_pcm_stream_lock(dev->pcm_substream);
+		dev->pcm_write_ptr += skip;
+
+		if (dev->pcm_write_ptr >= runtime->dma_bytes)
+			dev->pcm_write_ptr -= runtime->dma_bytes;
+
+		snd_pcm_stream_unlock(dev->pcm_substream);
+		offset = dev->pcm_read_offset = 0;
+	}
+	/* The device is actually sending 24Bit pcm data
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
+		dev->pcm_read_offset = 0;
+		return;
+	}
+	if (new_offset != 0) {
+		/* This buffer can not be appended to the current buffer,
+		 * so we mark any partial frames in the buffer as complete.
+		 */
+		skip = stride - (dev->pcm_write_ptr % stride);
+		snd_pcm_stream_lock(dev->pcm_substream);
+		dev->pcm_write_ptr += skip;
+
+		if (dev->pcm_write_ptr >= runtime->dma_bytes)
+			dev->pcm_write_ptr -= runtime->dma_bytes;
+
+		snd_pcm_stream_unlock(dev->pcm_substream);
+
+		offset = dev->pcm_read_offset = new_offset % (stride / 2);
+
+	}
+
+	oldptr = dev->pcm_write_ptr;
+	if (oldptr + len >= runtime->dma_bytes) {
+		unsigned int cnt = runtime->dma_bytes - oldptr;
+		memcpy(runtime->dma_area + oldptr, data, cnt);
+		memcpy(runtime->dma_area, data + cnt, len - cnt);
+	} else {
+		memcpy(runtime->dma_area + oldptr, data, len);
+	}
+
+	snd_pcm_stream_lock(dev->pcm_substream);
+	dev->pcm_write_ptr += len;
+
+	if (dev->pcm_write_ptr >= runtime->dma_bytes)
+		dev->pcm_write_ptr -= runtime->dma_bytes;
+
+	samples = dev->pcm_write_ptr - diff;
+	if (samples < 0)
+		samples += runtime->dma_bytes;
+
+	samples /= (stride / 2);
+
+	dev->pcm_complete_samples += samples;
+	if (dev->pcm_complete_samples / 2 >= runtime->period_size) {
+		dev->pcm_complete_samples -= runtime->period_size * 2;
+		period_elapsed = true;
+	}
+	snd_pcm_stream_unlock(dev->pcm_substream);
+
+	if (period_elapsed)
+		snd_pcm_period_elapsed(dev->pcm_substream);
+
+}
diff --git a/drivers/media/usb/smi2021/smi2021_bootloader.c b/drivers/media/usb/smi2021/smi2021_bootloader.c
new file mode 100644
index 0000000..ac95acf
--- /dev/null
+++ b/drivers/media/usb/smi2021/smi2021_bootloader.c
@@ -0,0 +1,261 @@
+/*******************************************************************************
+ * smi2021_bootloader.c							       *
+ *									       *
+ * USB Driver for SMI2021 - EasyCAP                                            *
+ * *****************************************************************************
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
+	rc = usb_control_msg(udev, usb_rcvctrlpipe(udev, SMI2021_USB_PIPE_IN),
+			SMI2021_USB_REQUEST,
+			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			SMI2021_HW_STATE_HEAD, SMI2021_USB_INDEX,
+			hw_state, sizeof(*hw_state), 1000);
+
+	if (rc < 0) {
+		dev_err(&udev->dev,
+			"could not check if device is ready for firmware upload: %d\n",
+			rc);
+		goto free_out;
+	}
+	if (hw_state->state != FIRMWARE_HW_READY_STATE) {
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
+			usb_sndctrlpipe(udev, SMI2021_USB_PIPE_OUT),
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
+	rc = usb_control_msg(udev, usb_sndctrlpipe(udev, SMI2021_USB_PIPE_OUT),
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
+		dev_info(&udev->dev, "Looking for: %s\n", available_fw[i].name);
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
+
diff --git a/drivers/media/usb/smi2021/smi2021_i2c.c b/drivers/media/usb/smi2021/smi2021_i2c.c
new file mode 100644
index 0000000..5d25eae
--- /dev/null
+++ b/drivers/media/usb/smi2021/smi2021_i2c.c
@@ -0,0 +1,137 @@
+/*******************************************************************************
+ * smi2021_i2c.c                                                               *
+ *                                                                             *
+ * USB Driver for SMI2021 - EasyCAP                                            *
+ * *****************************************************************************
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
+static unsigned int i2c_debug;
+module_param(i2c_debug, int, 0644);
+MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
+
+#define dprint_i2c(fmt, args...)					\
+do {									\
+	if (i2c_debug)							\
+		pr_debug("smi2021[i2c]::%s: " fmt, __func__, ##args);	\
+} while (0)
+
+
+static int i2c_xfer(struct i2c_adapter *i2c_adap,
+				struct i2c_msg msgs[], int num)
+{
+	struct smi2021_dev *dev = i2c_adap->algo_data;
+
+	switch (num) {
+	case 2:  /* Read reg */
+		if (msgs[0].len != 1 || msgs[1].len != 1) {
+			dprint_i2c("both messages must be 1 byte\n");
+			goto err_out;
+		}
+
+		if ((msgs[1].flags & I2C_M_RD) != I2C_M_RD) {
+			dprint_i2c("last message should have rd flag\n");
+			goto err_out;
+		}
+		smi2021_read_reg(dev, msgs[0].addr, msgs[0].buf[0],
+					msgs[1].buf);
+		break;
+	case 1: /* Write reg */
+		if (msgs[0].len == 0) {
+			break;
+		} else if (msgs[0].len != 2) {
+			dprint_i2c("unsupported len\n");
+			goto err_out;
+		}
+		if (msgs[0].buf[0] == 0) {
+			/* We don't handle writing to addr 0x00 */
+			break;
+		}
+		dprint_i2c("Set reg 0x%x to 0x%x\n",
+					msgs[0].buf[0], msgs[0].buf[1]);
+		smi2021_write_reg(dev, msgs[0].addr, msgs[0].buf[0],
+							msgs[0].buf[1]);
+		break;
+	default:
+		dprint_i2c("driver can only handle 1 or 2 messages\n");
+		goto err_out;
+	}
+	return num;
+
+err_out:
+	return -EOPNOTSUPP;
+}
+
+static u32 functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_SMBUS_EMUL;
+}
+
+static struct i2c_algorithm algo = {
+	.master_xfer = i2c_xfer,
+	.functionality = functionality,
+};
+
+static struct i2c_adapter adap_template = {
+	.owner = THIS_MODULE,
+	.name = "smi2021_easycap_dc60",
+	.algo = &algo,
+};
+
+static struct i2c_client client_template = {
+	.name = "smi2021 internal",
+};
+
+int smi2021_i2c_register(struct smi2021_dev *dev)
+{
+	int rc;
+
+	dev->i2c_adap = adap_template;
+	dev->i2c_adap.dev.parent = dev->dev;
+	strcpy(dev->i2c_adap.name, "smi2021");
+	dev->i2c_adap.algo_data = dev;
+
+	i2c_set_adapdata(&dev->i2c_adap, &dev->v4l2_dev);
+
+	rc = i2c_add_adapter(&dev->i2c_adap);
+	if (rc < 0) {
+		smi2021_err("can't add i2c adapter, errno: %d\n", rc);
+		return rc;
+	}
+
+	dev->i2c_client = client_template;
+	dev->i2c_client.adapter = &dev->i2c_adap;
+
+	smi2021_dbg("Registered i2c adapter\n");
+	return 0;
+}
+
+int smi2021_i2c_unregister(struct smi2021_dev *dev)
+{
+	i2c_del_adapter(&dev->i2c_adap);
+	return 0;
+}
diff --git a/drivers/media/usb/smi2021/smi2021_main.c b/drivers/media/usb/smi2021/smi2021_main.c
new file mode 100644
index 0000000..7c5315f
--- /dev/null
+++ b/drivers/media/usb/smi2021/smi2021_main.c
@@ -0,0 +1,431 @@
+/*******************************************************************************
+ * smi2021_main.c                                                              *
+ *                                                                             *
+ * USB Driver for SMI2021 - EasyCAP                                            *
+ * *****************************************************************************
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
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jon Arne Jørgensen <jonjon.arnearne--a.t--gmail.com>");
+MODULE_DESCRIPTION("SMI2021 - EasyCap");
+MODULE_VERSION(SMI2021_DRIVER_VERSION);
+
+static const struct usb_device_id smi2021_usb_device_id_table[] = {
+	{ USB_DEVICE(VENDOR_ID, BOOTLOADER_ID)	},
+	{ USB_DEVICE(VENDOR_ID, 0x003c)		},
+	{ USB_DEVICE(VENDOR_ID, 0x003d)		},
+	{ USB_DEVICE(VENDOR_ID, 0x003e)		},
+	{ USB_DEVICE(VENDOR_ID, 0x003f)		},
+	{ }
+};
+
+MODULE_DEVICE_TABLE(usb, smi2021_usb_device_id_table);
+
+/******************************************************************************/
+/*                                                                            */
+/*          Write to saa7113                                                  */
+/*                                                                            */
+/******************************************************************************/
+
+inline int transfer_usb_ctrl(struct smi2021_dev *dev,
+				struct smi2021_ctrl *data, int len)
+{
+	return usb_control_msg(dev->udev,
+			usb_sndctrlpipe(dev->udev, SMI2021_USB_PIPE_OUT),
+			SMI2021_USB_REQUEST,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			SMI2021_CTRL_HEAD, SMI2021_USB_INDEX,
+			data, len, 1000);
+}
+
+int smi2021_write_reg(struct smi2021_dev *dev, u8 addr, u16 reg, u8 val)
+{
+	int rc;
+	struct smi2021_ctrl *data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (dev->udev == NULL) {
+		rc = -ENODEV;
+		goto out;
+	}
+
+	data->head = SMI2021_CTRL_HEAD;
+	data->i2c_addr = addr;
+	data->size = sizeof(val);
+
+	if (addr) {
+		/* This is I2C data for the saa7113 chip */
+		data->bm_data_type = SMI2021_DATA_TYPE_FLAG_I2C |
+				     SMI2021_DATA_TYPE_FLAG_WRITE;
+		data->bm_data_offset =
+				sizeof(u8) & SMI2021_DATA_OFFSET_SIZE_MASK;
+
+		data->data.i2c_data.reg = reg;
+		data->data.i2c_data.val = val;
+	} else {
+		/* This is register settings for the smi2021 chip */
+		data->bm_data_offset = SMI2021_DATA_OFFSET_FLAG_SMI |
+				(sizeof(reg) & SMI2021_DATA_OFFSET_SIZE_MASK);
+
+		data->data.smi_data.reg_lo = __cpu_to_le16(reg) & 0xff;
+		data->data.smi_data.reg_hi = __cpu_to_le16(reg) >> 8;
+		data->data.smi_data.val = val;
+	}
+
+	rc = transfer_usb_ctrl(dev, data, sizeof(*data));
+	if (rc < 0) {
+		smi2021_warn("write failed on register 0x%x, errno: %d\n",
+								reg, rc);
+	}
+
+out:
+	kfree(data);
+	return rc;
+
+}
+
+int smi2021_read_reg(struct smi2021_dev *dev, u8 addr, u16 reg, u8 *val)
+{
+	int rc;
+	struct smi2021_ctrl *data = kzalloc(sizeof(*data), GFP_KERNEL);
+
+	if (data == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (dev->udev == NULL) {
+		rc = -ENODEV;
+		goto out;
+	}
+
+	data->head = SMI2021_CTRL_HEAD;
+	data->i2c_addr = addr;
+	data->bm_data_type = SMI2021_DATA_TYPE_FLAG_I2C |
+			     SMI2021_DATA_TYPE_FLAG_PREPARE_READ;
+	data->size = sizeof(*val);
+	data->data.i2c_data.reg = reg;
+
+	*val = 0;
+
+	rc = transfer_usb_ctrl(dev, data, sizeof(*data));
+	if (rc < 0) {
+		smi2021_warn(
+			"1st pass failing to read reg 0x%x, usb-errno: %d\n",
+			reg, rc);
+		goto out;
+	}
+
+	data->bm_data_type = SMI2021_DATA_TYPE_FLAG_I2C |
+			     SMI2021_DATA_TYPE_FLAG_READ;
+
+	rc = transfer_usb_ctrl(dev, data, sizeof(*data));
+	if (rc < 0) {
+		smi2021_warn(
+			"2nd pass failing to read reg 0x%x, usb-errno: %d\n",
+			reg, rc);
+		goto out;
+	}
+
+	memset(data, 0, sizeof(*data));
+	rc = usb_control_msg(dev->udev,
+		usb_rcvctrlpipe(dev->udev, SMI2021_USB_PIPE_IN),
+		SMI2021_USB_REQUEST,
+		USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		SMI2021_CTRL_HEAD, SMI2021_USB_INDEX,
+		data, sizeof(*data), 1000);
+	if (rc < 0) {
+		smi2021_warn("Failed to read reg 0x%x, usb-errno: %d\n",
+			reg, rc);
+		goto out;
+	}
+
+	*val = data->data.val;
+
+out:
+	kfree(data);
+	return rc;
+}
+
+static void smi2021_reset_device(struct smi2021_dev *dev)
+{
+	/* Set reset pin to output */
+	smi2021_write_reg(dev, 0, SMI2021_DDR_PORT, SMI2021_RESET_PIN);
+
+	/* Toggle pin */
+	smi2021_write_reg(dev, 0, SMI2021_DATA_PORT, SMI2021_RESET_PIN);
+	smi2021_write_reg(dev, 0, SMI2021_DATA_PORT, 0x00);
+}
+
+
+int smi2021_set_hw_state(struct smi2021_dev *dev, u8 state)
+{
+	int rc;
+	struct smi2021_set_hw_state *hw_state;
+
+	if (dev->udev == NULL)
+		return -ENODEV;
+
+	hw_state = kzalloc(sizeof(*hw_state), GFP_KERNEL);
+	if (hw_state == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (state == SMI2021_HW_STATE_STANDBY)
+		usb_set_interface(dev->udev, 0, 0);
+
+	hw_state->head = SMI2021_HW_STATE_HEAD;
+	hw_state->state = state;
+
+	rc = usb_control_msg(dev->udev,
+			usb_sndctrlpipe(dev->udev, SMI2021_USB_PIPE_OUT),
+			SMI2021_USB_REQUEST,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			SMI2021_HW_STATE_HEAD, SMI2021_USB_INDEX,
+			hw_state, sizeof(*hw_state), 1000);
+
+	if (rc < 0) {
+		smi2021_err("usb_control_msg returned: %d\n", rc);
+		goto out;
+	}
+
+	smi2021_dbg("Sent %lu bytes setup packet: 0x%x 0x%x\n",
+			sizeof(*hw_state), *(u8 *)hw_state,
+			*(((u8 *)hw_state)+1));
+
+	if (state == SMI2021_HW_STATE_CAPTURE) {
+		rc = usb_set_interface(dev->udev, 0, 2);
+		smi2021_dbg("%d: Interface set for capture\n", rc);
+	}
+
+
+
+out:
+	kfree(hw_state);
+	return rc;
+}
+
+static void release_v4l2_dev(struct v4l2_device *v4l2_dev)
+{
+	struct smi2021_dev *dev = container_of(v4l2_dev, struct smi2021_dev,
+								v4l2_dev);
+	smi2021_dbg("Releasing all resources\n");
+
+	smi2021_i2c_unregister(dev);
+
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	kfree(dev);
+}
+
+#define hb_mult(w_max_packet_size) (1 + (((w_max_packet_size) >> 11) & 0x03))
+
+static int smi2021_scan_usb(struct usb_interface *intf, struct usb_device *udev)
+{
+	int i, e, ifnum, sizedescr, size;
+	const struct usb_endpoint_descriptor *desc;
+	ifnum = intf->altsetting[0].desc.bInterfaceNumber;
+
+	for (i = 0; i < intf->num_altsetting; i++) {
+		for (e = 0; e < intf->altsetting[i].desc.bNumEndpoints; e++) {
+			desc = &intf->altsetting[i].endpoint[e].desc;
+			sizedescr = le16_to_cpu(desc->wMaxPacketSize);
+			size = sizedescr & 0x7ff;
+
+			if (udev->speed == USB_SPEED_HIGH)
+				size = size * hb_mult(sizedescr);
+		}
+	}
+	return 0;
+}
+
+/******************************************************************************/
+/*                                                                            */
+/*          DEVICE  -  PROBE   &   DISCONNECT                                 */
+/*                                                                            */
+/******************************************************************************/
+static int smi2021_usb_probe(struct usb_interface *intf,
+					const struct usb_device_id *devid)
+{
+	int rc;
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct smi2021_dev *dev;
+
+	if (udev == (struct usb_device *)NULL) {
+		smi2021_err("device is NULL\n");
+		return -EFAULT;
+	}
+
+	if (udev->descriptor.idProduct == BOOTLOADER_ID)
+		return smi2021_bootloader_probe(intf, devid);
+
+	smi2021_scan_usb(intf, udev);
+
+	dev = kzalloc(sizeof(struct smi2021_dev), GFP_KERNEL);
+	if (dev == NULL)
+		return -ENOMEM;
+
+	dev->udev = udev;
+	dev->dev = &intf->dev;
+	usb_set_intfdata(intf, dev);
+
+	switch (udev->descriptor.idProduct) {
+	case 0x003e:
+	case 0x003f:
+		dev->device_cfg = SMI2021_QUAD_INPUT;
+		break;
+	case 0x003c:
+	case 0x003d:
+	default:
+		dev->device_cfg = SMI2021_DUAL_INPUT;
+	}
+
+	/* Initialize videobuf2 stuff */
+	rc = smi2021_vb2_setup(dev);
+	if (rc < 0)
+		goto free_err;
+
+	spin_lock_init(&dev->buf_lock);
+	mutex_init(&dev->v4l2_lock);
+	mutex_init(&dev->vb_queue_lock);
+
+	rc = v4l2_ctrl_handler_init(&dev->ctrl_handler, 0);
+	if (rc) {
+		smi2021_err("v4l2_ctrl_handler_init failed with: %d\n", rc);
+		goto free_err;
+	}
+
+	dev->v4l2_dev.release = release_v4l2_dev;
+	dev->v4l2_dev.ctrl_handler = &dev->ctrl_handler;
+	rc = v4l2_device_register(dev->dev, &dev->v4l2_dev);
+	if (rc) {
+		smi2021_err("v4l2_device_register failed with %d\n", rc);
+		goto free_ctrl;
+	}
+
+	smi2021_reset_device(dev);
+
+	rc = smi2021_i2c_register(dev);
+	if (rc < 0)
+		goto unreg_v4l2;
+
+	dev->sd_saa7113 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+		"gm7113c", 0x4a, NULL);
+
+	smi2021_dbg("Driver version %s successfully loaded\n",
+			SMI2021_DRIVER_VERSION);
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core, reset, 0);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
+
+	rc = smi2021_snd_register(dev);
+	if (rc < 0)
+		goto unreg_i2c;
+
+	rc = smi2021_video_register(dev);
+	if (rc < 0)
+		goto unreg_snd;
+
+	return 0;
+
+unreg_snd:
+	smi2021_snd_unregister(dev);
+unreg_i2c:
+	smi2021_i2c_unregister(dev);
+unreg_v4l2:
+	v4l2_device_unregister(&dev->v4l2_dev);
+free_ctrl:
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+free_err:
+	kfree(dev);
+
+	return rc;
+}
+
+static void smi2021_usb_disconnect(struct usb_interface *intf)
+{
+
+	struct smi2021_dev *dev;
+	struct usb_device *udev = interface_to_usbdev(intf);
+
+	if (udev == (struct usb_device *)NULL) {
+		smi2021_err("device is NULL\n");
+		return;
+	}
+
+	if (udev->descriptor.idProduct == BOOTLOADER_ID)
+		return smi2021_bootloader_disconnect(intf);
+
+	dev = usb_get_intfdata(intf);
+	usb_set_intfdata(intf, NULL);
+
+	mutex_lock(&dev->vb_queue_lock);
+	mutex_lock(&dev->v4l2_lock);
+
+	smi2021_uninit_isoc(dev);
+	smi2021_clear_queue(dev);
+
+	video_unregister_device(&dev->vdev);
+	v4l2_device_disconnect(&dev->v4l2_dev);
+
+	/* This way current users can detect device is gone */
+	dev->udev = NULL;
+
+	mutex_unlock(&dev->v4l2_lock);
+	mutex_unlock(&dev->vb_queue_lock);
+
+	smi2021_snd_unregister(dev);
+
+	/*
+	 * This calls release_v4l2_dev if it's the last reference.
+	 * Otherwise, the release is postponed until there are no users left.
+	 */
+	v4l2_device_put(&dev->v4l2_dev);
+}
+
+/******************************************************************************/
+/*                                                                            */
+/*            MODULE  -  INIT  &  EXIT                                        */
+/*                                                                            */
+/******************************************************************************/
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
index 0000000..90a838b
--- /dev/null
+++ b/drivers/media/usb/smi2021/smi2021_v4l2.c
@@ -0,0 +1,542 @@
+/*******************************************************************************
+ * smi2021_v4l2.c                                                              *
+ *                                                                             *
+ * USB Driver for smi2021 - EasyCap                                            *
+ * *****************************************************************************
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
+static const struct smi2021_fmt format[] = {
+	{
+		.name = "16bpp YU2, 4:2:2, packed",
+		.fourcc = V4L2_PIX_FMT_UYVY,
+		.depth = 16,
+	}
+};
+
+static const struct smi2021_input dual_input[] = {
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
+static const struct smi2021_input quad_input[] = {
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
+static const struct smi2021_input *input = dual_input;
+static int inputs = ARRAY_SIZE(dual_input);
+
+static void smi2021_set_input(struct smi2021_dev *dev)
+{
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
+		input[dev->ctl_input].type, 0, 0);
+}
+
+/* Must be called with v4l2_lock hold */
+static void smi2021_stop_hw(struct smi2021_dev *dev)
+{
+	int rc;
+
+	rc = smi2021_set_hw_state(dev, SMI2021_HW_STATE_STANDBY);
+	if (rc < 0)
+		smi2021_err("Could not stop device!\n");
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
+}
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
+/******************************************************************************/
+/*                                                                            */
+/*          Vidioc IOCTLS                                                     */
+/*                                                                            */
+/******************************************************************************/
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+			struct v4l2_fmtdesc *f)
+{
+	if (f->index != 0)
+		return -EINVAL;
+
+	strlcpy(f->description, format[f->index].name, sizeof(f->description));
+	f->pixelformat = format[f->index].fourcc;
+
+	return 0;
+}
+
+static int vidioc_querycap(struct file *file, void *priv,
+			struct v4l2_capability *cap)
+{
+	struct smi2021_dev *dev = video_drvdata(file);
+
+	strcpy(cap->driver, "smi2021");
+	strcpy(cap->card, "smi2021");
+	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
+	cap->device_caps =
+		V4L2_CAP_VIDEO_CAPTURE |
+		V4L2_CAP_STREAMING |
+		V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct smi2021_dev *dev = video_drvdata(file);
+
+	f->fmt.pix.pixelformat = dev->fmt->fourcc;
+	f->fmt.pix.width = dev->width;
+	f->fmt.pix.height = dev->height;
+	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.bytesperline = dev->width * 2;
+	f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
+
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct smi2021_dev *dev = video_drvdata(file);
+
+	f->fmt.pix.pixelformat = dev->fmt->fourcc;
+	f->fmt.pix.width = dev->width;
+	f->fmt.pix.height = dev->height;
+	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.bytesperline = dev->width * 2;
+	f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
+
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct smi2021_dev *dev = video_drvdata(file);
+	struct vb2_queue *q = &dev->vb_vidq;
+
+	if (vb2_is_busy(q))
+		return -EBUSY;
+
+	vidioc_try_fmt_vid_cap(file, priv, f);
+	return 0;
+}
+
+static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
+{
+	struct smi2021_dev *dev = video_drvdata(file);
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, querystd, norm);
+	return 0;
+}
+
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
+{
+	struct smi2021_dev *dev = video_drvdata(file);
+
+	*norm = dev->norm;
+	return 0;
+}
+
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
+{
+	struct smi2021_dev *dev = video_drvdata(file);
+	struct vb2_queue *q = &dev->vb_vidq;
+
+	if (vb2_is_busy(q))
+		return -EBUSY;
+
+	if (!dev->udev)
+		return -ENODEV;
+
+	dev->norm = *norm;
+	if (dev->norm & V4L2_STD_525_60) {
+		dev->width = SMI2021_BYTES_PER_LINE / 2;
+		dev->height = SMI2021_NTSC_LINES;
+	} else if (dev->norm & V4L2_STD_625_50) {
+		dev->width = SMI2021_BYTES_PER_LINE / 2;
+		dev->height =  SMI2021_PAL_LINES;
+	} else {
+		smi2021_err("Invalid standard\n");
+		return -EINVAL;
+	}
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
+	return 0;
+}
+
+static int vidioc_enum_input(struct file *file, void *priv,
+				struct v4l2_input *i)
+{
+	struct smi2021_dev *dev = video_drvdata(file);
+
+	if (i->index >= inputs)
+		return -EINVAL;
+
+	strlcpy(i->name, input[i->index].name, sizeof(i->name));
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	i->std = dev->vdev.tvnorms;
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	struct smi2021_dev *dev = video_drvdata(file);
+
+	*i = dev->ctl_input;
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	struct smi2021_dev *dev = video_drvdata(file);
+
+	if (i >= inputs)
+		return -EINVAL;
+
+	dev->ctl_input = i;
+	smi2021_set_input(dev);
+
+	return 0;
+}
+
+static int vidioc_g_chip_ident(struct file *file, void *priv,
+			struct v4l2_dbg_chip_ident *chip)
+{
+	switch (chip->match.type) {
+	case V4L2_CHIP_MATCH_HOST:
+		chip->ident = V4L2_IDENT_NONE;
+		chip->revision = 0;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct v4l2_ioctl_ops smi2021_ioctl_ops = {
+	.vidioc_querycap		= vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap		= vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap		= vidioc_s_fmt_vid_cap,
+	.vidioc_querystd		= vidioc_querystd,
+	.vidioc_g_std			= vidioc_g_std,
+	.vidioc_s_std			= vidioc_s_std,
+	.vidioc_enum_input		= vidioc_enum_input,
+	.vidioc_g_input			= vidioc_g_input,
+	.vidioc_s_input			= vidioc_s_input,
+
+	/* vb2 handle these */
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+	.vidioc_g_chip_ident		= vidioc_g_chip_ident,
+
+};
+
+/******************************************************************************/
+/*                                                                            */
+/*          Videobuf2 operations                                              */
+/*                                                                            */
+/******************************************************************************/
+static int queue_setup(struct vb2_queue *vq,
+				const struct v4l2_format *v4l2_fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct smi2021_dev *dev = vb2_get_drv_priv(vq);
+	unsigned long size;
+
+	size = dev->width * dev->height * 2;
+
+	*nbuffers = clamp_t(unsigned int, *nbuffers, 4, 16);
+	smi2021_dbg("Requesting %u buffers\n", *nbuffers);
+
+	/* Packed color format */
+	*nplanes = 1;
+	sizes[0] = size;
+
+	return 0;
+}
+
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	unsigned long flags;
+	struct smi2021_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct smi2021_buffer *buf = container_of(vb, struct smi2021_buffer, vb);
+
+	spin_lock_irqsave(&dev->buf_lock, flags);
+	if (!dev->udev) {
+		/*
+		 * If the device is disconnected return the buffer to userspace
+		 * directly. The next QBUF call will fail with -ENODEV.
+		 */
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	} else {
+		buf->mem = vb2_plane_vaddr(vb, 0);
+		buf->length = vb2_plane_size(vb, 0);
+
+		buf->pos = 0;
+		buf->trc_av = 0;
+		buf->in_blank = true;
+		buf->second_field = false;
+
+		if (buf->length < dev->width * dev->height * 2)
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		else
+			list_add_tail(&buf->list, &dev->avail_bufs);
+	}
+	spin_unlock_irqrestore(&dev->buf_lock, flags);
+}
+
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct smi2021_dev *dev = vb2_get_drv_priv(vq);
+	int rc, i;
+
+	if (!dev->udev)
+		return -ENODEV;
+
+	dev->sync_state = HSYNC;
+	dev->buf_count = 0;
+
+	if (mutex_lock_interruptible(&dev->v4l2_lock))
+		return -ERESTARTSYS;
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 1);
+
+	rc = smi2021_set_hw_state(dev, SMI2021_HW_STATE_CAPTURE);
+	if (rc < 0) {
+		smi2021_err("can't start hw\n");
+		goto out_unlock;
+	}
+
+	smi2021_write_reg(dev, 0, SMI2021_AUDIO_PORT, SMI2021_AUDIO_ENABLE);
+
+	if (!dev->isoc_ctl.num_bufs) {
+		rc = smi2021_alloc_isoc(dev);
+		if (rc < 0)
+			goto out_stop_hw;
+	}
+
+	/* submit urbs and enable IRQ */
+	for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
+		rc = usb_submit_urb(dev->isoc_ctl.urb[i], GFP_KERNEL);
+		if (rc) {
+			smi2021_err("can't submit urb[%d] (%d)\n", i, rc);
+			goto out_uninit;
+		}
+	}
+
+	mutex_unlock(&dev->v4l2_lock);
+	return 0;
+
+out_uninit:
+	smi2021_uninit_isoc(dev);
+out_stop_hw:
+	usb_set_interface(dev->udev, 0, 0);
+	smi2021_clear_queue(dev);
+
+out_unlock:
+	mutex_unlock(&dev->v4l2_lock);
+
+	return rc;
+}
+
+static int stop_streaming(struct vb2_queue *vq)
+{
+	struct smi2021_dev *dev = vb2_get_drv_priv(vq);
+	/* HACK: Stop the audio subsystem,
+	 * without this, the pcm middle-layer will hang waiting for more data.
+	 *
+	 * Is there a better way to do this?
+	 */
+	if (dev->pcm_substream && dev->pcm_substream->runtime) {
+		struct snd_pcm_runtime *runtime = dev->pcm_substream->runtime;
+		if (runtime->status) {
+			runtime->status->state = SNDRV_PCM_STATE_DRAINING;
+			wake_up(&runtime->sleep);
+		}
+	}
+
+	if (mutex_lock_interruptible(&dev->v4l2_lock))
+		return -ERESTARTSYS;
+
+	smi2021_cancel_isoc(dev);
+	smi2021_free_isoc(dev);
+	smi2021_stop_hw(dev);
+	smi2021_clear_queue(dev);
+	smi2021_dbg("Streaming stopped!\n");
+
+	mutex_unlock(&dev->v4l2_lock);
+
+	return 0;
+}
+
+static struct vb2_ops smi2021_video_qops = {
+	.queue_setup		= queue_setup,
+	.buf_queue		= buffer_queue,
+	.start_streaming	= start_streaming,
+	.stop_streaming		= stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+static struct video_device v4l2_template = {
+	.name			= "easycap_smi2021_dc60",
+	.tvnorms		= V4L2_STD_ALL,
+	.fops			= &smi2021_fops,
+	.ioctl_ops		= &smi2021_ioctl_ops,
+	.release		= video_device_release_empty,
+};
+
+/* Must be called with both v4l2_lock and vb_queue_lock hold */
+void smi2021_clear_queue(struct smi2021_dev *dev)
+{
+	struct smi2021_buffer *buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->buf_lock, flags);
+	while (!list_empty(&dev->avail_bufs)) {
+		buf = list_first_entry(&dev->avail_bufs,
+			struct smi2021_buffer, list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+	dev->isoc_ctl.buf = NULL;
+	spin_unlock_irqrestore(&dev->buf_lock, flags);
+}
+
+int smi2021_vb2_setup(struct smi2021_dev *dev)
+{
+	int rc;
+	struct vb2_queue *q;
+
+	q = &dev->vb_vidq;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct smi2021_buffer);
+	q->ops = &smi2021_video_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+
+	rc = vb2_queue_init(q);
+	if (rc < 0)
+		return rc;
+
+	/* Initialize video dma queue */
+	INIT_LIST_HEAD(&dev->avail_bufs);
+
+	return 0;
+}
+
+int smi2021_video_register(struct smi2021_dev *dev)
+{
+	int rc;
+
+	dev->vdev = v4l2_template;
+	dev->vdev.queue = &dev->vb_vidq;
+
+	dev->vdev.lock = &dev->v4l2_lock;
+	dev->vdev.queue->lock = &dev->vb_queue_lock;
+
+	dev->vdev.v4l2_dev = &dev->v4l2_dev;
+	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
+
+	/* PAL is default */
+	dev->norm = V4L2_STD_PAL;
+	dev->width = SMI2021_BYTES_PER_LINE / 2;
+	dev->height = SMI2021_PAL_LINES;
+
+	if (dev->device_cfg == SMI2021_DUAL_INPUT) {
+		input = dual_input;
+		inputs = ARRAY_SIZE(dual_input);
+	} else {
+		input = quad_input;
+		inputs = ARRAY_SIZE(quad_input);
+	}
+
+	dev->fmt = &format[0];
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
+	smi2021_set_input(dev);
+
+	video_set_drvdata(&dev->vdev, dev);
+	rc = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
+	if (rc < 0) {
+		smi2021_err("video_register_device failed %d\n", rc);
+		return rc;
+	}
+
+	v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
+		video_device_node_name(&dev->vdev));
+
+	return 0;
+}
diff --git a/drivers/media/usb/smi2021/smi2021_video.c b/drivers/media/usb/smi2021/smi2021_video.c
new file mode 100644
index 0000000..4a71f20
--- /dev/null
+++ b/drivers/media/usb/smi2021/smi2021_video.c
@@ -0,0 +1,544 @@
+/*******************************************************************************
+ * smi2021_video.c                                                             *
+ *                                                                             *
+ * USB Driver for SMI2021 - EasyCAP                                            *
+ * *****************************************************************************
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
+static void print_usb_err(struct smi2021_dev *dev, int packet, int status)
+{
+	char *errmsg;
+
+	switch (status) {
+	case -ENOENT:
+		errmsg = "unlinked synchronuously";
+		break;
+	case -ECONNRESET:
+		errmsg = "unlinked asynchronuously";
+		break;
+	case -ENOSR:
+		errmsg = "Buffer error (overrun)";
+		break;
+	case -EPIPE:
+		errmsg = "Stalled (device not responding)";
+		break;
+	case -EOVERFLOW:
+		errmsg = "Babble (bad cable?)";
+		break;
+	case -EPROTO:
+		errmsg = "Bit-stuff error (bad cable?)";
+		break;
+	case -EILSEQ:
+		errmsg = "CRC/Timeout (could be anything)";
+		break;
+	case -ETIME:
+		errmsg = "Device does not respond";
+		break;
+	case -EXDEV:
+		errmsg = "Trying to capture from unconnected input?";
+		break;
+	default:
+		errmsg = "Unknown";
+	}
+
+	if (packet < 0) {
+		printk_ratelimited(KERN_WARNING "Urb status %d [%s]\n",
+					status, errmsg);
+	} else {
+		printk_ratelimited(KERN_INFO "URB packet %d, status %d [%s]\n",
+					packet, status, errmsg);
+	}
+}
+
+static struct smi2021_buffer *smi2021_next_buffer(struct smi2021_dev *dev)
+{
+	struct smi2021_buffer *buf = NULL;
+	unsigned long flags = 0;
+
+	WARN_ON(dev->isoc_ctl.buf);
+
+	spin_lock_irqsave(&dev->buf_lock, flags);
+	if (!list_empty(&dev->avail_bufs)) {
+		buf = list_first_entry(&dev->avail_bufs, struct smi2021_buffer,
+									list);
+		list_del(&buf->list);
+#ifdef DEBUG
+	} else if (printk_ratelimit()) {
+		smi2021_dbg("No buffers in queue!\n");
+#endif
+	}
+	spin_unlock_irqrestore(&dev->buf_lock, flags);
+
+	return buf;
+}
+
+static void smi2021_buffer_done(struct smi2021_dev *dev)
+{
+	struct smi2021_buffer *buf = dev->isoc_ctl.buf;
+
+	dev->buf_count++;
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	buf->vb.v4l2_buf.sequence = dev->buf_count >> 1;
+	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
+	buf->vb.v4l2_buf.flags |= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+
+	if (buf->pos < dev->width * dev->height * 2) {
+		buf->vb.v4l2_buf.bytesused = 0;
+		vb2_set_plane_payload(&buf->vb, 0, 0);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	} else {
+		buf->vb.v4l2_buf.bytesused = buf->pos;
+		vb2_set_plane_payload(&buf->vb, 0, buf->pos);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	}
+	dev->isoc_ctl.buf = NULL;
+}
+
+static void copy_video(struct smi2021_dev *dev, u8 p)
+{
+	struct smi2021_buffer *buf = dev->isoc_ctl.buf;
+
+	int lines_per_field = dev->height / 2;
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
+		if (buf->second_field == 0) {
+			/* We are probably trying to capture from
+			 * a unconnected input
+			 */
+			smi2021_buffer_done(dev);
+		} else {
+			printk_ratelimited(KERN_WARNING
+			"Buffer overflow!, max: %d bytes, av_lines_found: %d, second_field: %d\n",
+						buf->length, buf->trc_av,
+						buf->second_field);
+		}
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
+		 * The device will sometimes give us to many bytes
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
+	if (offset >= buf->length) {
+		printk_ratelimited(KERN_INFO
+		"Offset calculation error, field: %d, line: %d, pos_in_line: %d\n",
+			buf->second_field, line, pos_in_line);
+		return;
+	}
+
+	dst = buf->mem + offset;
+	*dst = p;
+	buf->pos++;
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
+static void parse_trc(struct smi2021_dev *dev, u8 trc)
+{
+	struct smi2021_buffer *buf = dev->isoc_ctl.buf;
+	int lines_per_field = dev->height / 2;
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
+		buf = smi2021_next_buffer(dev);
+		if (buf == NULL)
+			return;
+
+		dev->isoc_ctl.buf = buf;
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
+	smi2021_buffer_done(dev);
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
+static void parse_video(struct smi2021_dev *dev, u8 *p, int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++) {
+		switch (dev->sync_state) {
+		case HSYNC:
+			if (p[i] == 0xff)
+				dev->sync_state = SYNCZ1;
+			else
+				copy_video(dev, p[i]);
+			break;
+		case SYNCZ1:
+			if (p[i] == 0x00) {
+				dev->sync_state = SYNCZ2;
+			} else {
+				dev->sync_state = HSYNC;
+				copy_video(dev, 0xff);
+				copy_video(dev, p[i]);
+			}
+			break;
+		case SYNCZ2:
+			if (p[i] == 0x00) {
+				dev->sync_state = TRC;
+			} else {
+				dev->sync_state = HSYNC;
+				copy_video(dev, 0xff);
+				copy_video(dev, 0x00);
+				copy_video(dev, p[i]);
+			}
+			break;
+		case TRC:
+			dev->sync_state = HSYNC;
+			parse_trc(dev, p[i]);
+			break;
+		}
+	}
+
+}
+/*
+ *
+ * The device delivers data in chunks of 0x400 bytes.
+ * The four first bytes is a magic header to identify the chunks.
+ *	0xaa 0xaa 0x00 0x00 = saa7113 Active Video Data
+ *	0xaa 0xaa 0x00 0x01 = PCM - 24Bit 2 Channel audio data
+ */
+static void process_packet(struct smi2021_dev *dev, u8 *p, int len)
+{
+	int i;
+	u32 *header;
+
+	if (len % 0x400 != 0) {
+		printk_ratelimited(KERN_INFO "smi2021::%s: len: %d\n",
+				__func__, len);
+		return;
+	}
+
+	for (i = 0; i < len; i += 0x400) {
+		header = (u32 *)(p + i);
+		switch (*header) {
+		case cpu_to_be32(0xaaaa0000): {
+			parse_video(dev, p+i+4, 0x400-4);
+			break;
+		}
+		case cpu_to_be32(0xaaaa0001): {
+			smi2021_audio(dev, p+i+4, 0x400-4);
+			break;
+		}
+		default: {
+			/* Nothing */
+		}
+		}
+	}
+}
+
+/*
+ * Interrupt called by URB callback
+ */
+static void smi2021_isoc_isr(struct urb *urb)
+{
+	int i, rc, status, len;
+	struct smi2021_dev *dev = urb->context;
+	u8 *p;
+
+	switch (urb->status) {
+	case 0:
+		break;
+	case -ECONNRESET: /* kill */
+	case -ENOENT:
+	case -ESHUTDOWN:
+		/* uvc driver frees the queue here */
+		return;
+	default:
+		smi2021_err("urb error! status %d\n", urb->status);
+		return;
+	}
+
+	if (urb->status < 0)
+		print_usb_err(dev, -1, status);
+
+	if (dev == NULL) {
+		smi2021_warn("called with null device\n");
+		return;
+	}
+
+	for (i = 0; i < urb->number_of_packets; i++) {
+
+		status = urb->iso_frame_desc[i].status;
+
+		if (status < 0) {
+			print_usb_err(dev, i, status);
+			continue;
+		}
+
+		p = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+		len = urb->iso_frame_desc[i].actual_length;
+		process_packet(dev, p, len);
+	}
+
+	for (i = 0; i < urb->number_of_packets; i++) {
+		urb->iso_frame_desc[i].status = 0;
+		urb->iso_frame_desc[i].actual_length = 0;
+	}
+
+	rc = usb_submit_urb(urb, GFP_ATOMIC);
+	if (rc)
+		smi2021_err("urb re-submit failed (%d)\n", rc);
+}
+
+/*
+ * Cancel urbs
+ * This function can not be called in atomic context
+ */
+void smi2021_cancel_isoc(struct smi2021_dev *dev)
+{
+	int i, num_bufs = dev->isoc_ctl.num_bufs;
+	if (!num_bufs)
+		return;
+
+	smi2021_dbg("killing %d urbs...\n", num_bufs);
+
+	for (i = 0; i < num_bufs; i++)
+		usb_kill_urb(dev->isoc_ctl.urb[i]);
+
+	smi2021_dbg("all urbs killed\n");
+
+}
+
+/*
+ * Releases urb and transfer buffers
+ * Obviously, associated urb must be killed before releasing it
+ */
+void smi2021_free_isoc(struct smi2021_dev *dev)
+{
+	struct urb *urb;
+	int i, num_bufs = dev->isoc_ctl.num_bufs;
+
+	smi2021_dbg("freeing %d urb buffers...\n", num_bufs);
+
+	for (i = 0; i < num_bufs; i++) {
+		urb = dev->isoc_ctl.urb[i];
+		if (urb) {
+			if (dev->isoc_ctl.transfer_buffer[i]) {
+#ifndef CONFIG_DMA_NONCOHERENT
+				usb_free_coherent(dev->udev,
+					urb->transfer_buffer_length,
+					dev->isoc_ctl.transfer_buffer[i],
+					urb->transfer_dma);
+#else
+				kfree(dev->isoc_ctl.transfer_buffer[i]);
+#endif
+			}
+			usb_free_urb(urb);
+			dev->isoc_ctl.urb[i] = NULL;
+		}
+		dev->isoc_ctl.transfer_buffer[i] = NULL;
+	}
+
+	kfree(dev->isoc_ctl.urb);
+	kfree(dev->isoc_ctl.transfer_buffer);
+
+	dev->isoc_ctl.urb = NULL;
+	dev->isoc_ctl.transfer_buffer = NULL;
+	dev->isoc_ctl.num_bufs = 0;
+
+	smi2021_dbg("all urb buffers freed\n");
+}
+
+/*
+ * Helper for canceling and freeing urbs
+ * This function can not be called in atomic context
+ */
+void smi2021_uninit_isoc(struct smi2021_dev *dev)
+{
+	smi2021_cancel_isoc(dev);
+	smi2021_free_isoc(dev);
+}
+
+
+int smi2021_alloc_isoc(struct smi2021_dev *dev)
+{
+	struct urb *urb;
+	int i, j, k, sb_size, max_packets, num_bufs;
+
+	if (dev->isoc_ctl.num_bufs)
+		smi2021_uninit_isoc(dev);
+
+	num_bufs = SMI2021_ISOC_BUFS;
+	max_packets = SMI2021_ISOC_PACKETS;
+	sb_size = max_packets * SMI2021_MAX_PKT_SIZE;
+
+	dev->isoc_ctl.buf = NULL;
+	dev->isoc_ctl.max_pkt_size = SMI2021_MAX_PKT_SIZE;
+	dev->isoc_ctl.urb = kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
+	if (!dev->isoc_ctl.urb) {
+		smi2021_err("out of memory for urb array\n");
+		return -ENOMEM;
+	}
+
+	dev->isoc_ctl.transfer_buffer = kzalloc(sizeof(void *) * num_bufs,
+							GFP_KERNEL);
+	if (!dev->isoc_ctl.transfer_buffer) {
+		smi2021_err("out of memory for usb transfer\n");
+		kfree(dev->isoc_ctl.urb);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < num_bufs; i++) {
+		urb = usb_alloc_urb(max_packets, GFP_KERNEL);
+		if (!urb) {
+			smi2021_err("connot allocate urb[%d]\n", i);
+			goto free_i_bufs;
+		}
+		dev->isoc_ctl.urb[i] = urb;
+#ifndef CONFIG_DMA_NONCOHERENT
+		dev->isoc_ctl.transfer_buffer[i] = usb_alloc_coherent(
+					dev->udev, sb_size, GFP_KERNEL,
+					&urb->transfer_dma);
+#else
+		dev->isoc_ctl.transfer_buffer[i] = kmalloc(sb_size,
+								GFP_KERNEL);
+#endif
+		if (!dev->isoc_ctl.transfer_buffer[i]) {
+			smi2021_err("cannot alloc %d bytes for tx[%d] buffer",
+					sb_size, i);
+			goto free_i_bufs;
+		}
+		/* Do not leak kernel data */
+		memset(dev->isoc_ctl.transfer_buffer[i], 0, sb_size);
+
+		urb->dev = dev->udev;
+		urb->pipe = usb_rcvisocpipe(dev->udev, SMI2021_ISOC_EP);
+		urb->transfer_buffer = dev->isoc_ctl.transfer_buffer[i];
+		urb->transfer_buffer_length = sb_size;
+		urb->complete = smi2021_isoc_isr;
+		urb->context = dev;
+		urb->interval = 1;
+		urb->start_frame = 0;
+		urb->number_of_packets = max_packets;
+#ifndef CONFIG_DMA_NONCOHERENT
+		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
+#else
+		urb->transfer_flags = URB_ISO_ASAP;
+#endif
+		k = 0;
+		for (j = 0; j < max_packets; j++) {
+			urb->iso_frame_desc[j].offset = k;
+			urb->iso_frame_desc[j].length =
+						dev->isoc_ctl.max_pkt_size;
+			k += dev->isoc_ctl.max_pkt_size;
+		}
+	}
+	smi2021_dbg("urbs allocated\n");
+	dev->isoc_ctl.num_bufs = num_bufs;
+	return 0;
+
+free_i_bufs:
+	dev->isoc_ctl.num_bufs = i+1;
+	smi2021_free_isoc(dev);
+	return -ENOMEM;
+}
-- 
1.8.2.1

