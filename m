Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab3BSEBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:01:11 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:55524 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab3BSEAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:00:08 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrew.smirnov@gmail.com
Cc: hverkuil@xs4all.nl, broonie@opensource.wolfsonmicro.com,
        mchehab@redhat.com, sameo@linux.intel.com, perex@perex.cz,
        tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=20v4=205/7=5D=20v4l2=3A=20Add=20a=20V4L2=20driver=20for=20SI476X=20MFD?=
Date: Mon, 18 Feb 2013 19:59:33 -0800
Message-Id: <1361246375-8848-6-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361246375-8848-1-git-send-email-andrew.smirnov@gmail.com>
References: <1361246375-8848-1-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Smirnov <andreysm@charmander.(none)>

This commit adds a driver that exposes all the radio related
functionality of the Si476x series of chips via the V4L2 subsystem.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 Documentation/video4linux/si476x.txt |  187 ++++
 drivers/media/radio/Kconfig          |   17 +
 drivers/media/radio/Makefile         |    1 +
 drivers/media/radio/radio-si476x.c   | 1557 ++++++++++++++++++++++++++++++++++
 include/media/si476x.h               |  428 ++++++++++
 5 files changed, 2190 insertions(+)
 create mode 100644 Documentation/video4linux/si476x.txt
 create mode 100644 drivers/media/radio/radio-si476x.c
 create mode 100644 include/media/si476x.h

diff --git a/Documentation/video4linux/si476x.txt b/Documentation/video4linux/si476x.txt
new file mode 100644
index 0000000..d1a08db
--- /dev/null
+++ b/Documentation/video4linux/si476x.txt
@@ -0,0 +1,187 @@
+SI476x Driver Readme
+------------------------------------------------
+	Copyright (C) 2013 Andrey Smirnov <andrew.smirnov@gmail.com>
+
+TODO for the driver
+------------------------------
+
+- According to the SiLabs' datasheet it is possible to update the
+  firmware of the radio chip in the run-time, thus bringing it to the
+  most recent version. Unfortunately I couldn't find any mentioning of
+  the said firmware update for the old chips that I tested the driver
+  against, so for chips like that the driver only exposes the old
+  functionality.
+
+
+Parameters exposed over debugfs
+-------------------------------
+SI476x allow user to get multiple characteristics that can be very
+useful for EoL testing/RF performance estimation, parameters that have
+very little to do with V4L2 subsystem. Such parameters are exposed via
+debugfs and can be accessed via regular file I/O operations.
+
+The drivers exposes following files:
+
+* /sys/kernel/debug/<device-name>/acf
+  This file contains ACF(Automatically Controlled Features) status
+  information. The contents of the file is binary data of the
+  following layout:
+
+  Offset	| Name		| Description
+  ====================================================================
+  0x00		| blend_int	| Flag, set when stereo separation has
+  		|  		| crossed below the blend threshold
+  --------------------------------------------------------------------
+  0x01		| hblend_int	| Flag, set when HiBlend cutoff
+  		| 		| frequency is lower than threshold
+  --------------------------------------------------------------------
+  0x02		| hicut_int	| Flag, set when HiCut cutoff
+  		| 		| frequency is lower than threshold
+  --------------------------------------------------------------------
+  0x03		| chbw_int	| Flag, set when channel filter
+  		| 		| bandwidth is less than threshold
+  --------------------------------------------------------------------
+  0x04		| softmute_int	| Flag indicating that softmute
+  		| 		| attenuation has increased above
+		|		| softmute threshold
+  --------------------------------------------------------------------
+  0x05		| smute		| 0 - Audio is not soft muted
+  		| 		| 1 - Audio is soft muted
+  --------------------------------------------------------------------
+  0x06		| smattn	| Soft mute attenuation level in dB
+  --------------------------------------------------------------------
+  0x07		| chbw		| Channel filter bandwidth in kHz
+  --------------------------------------------------------------------
+  0x08		| hicut		| HiCut cutoff frequency in units of
+  		| 		| 100Hz
+  --------------------------------------------------------------------
+  0x09		| hiblend	| HiBlend cutoff frequency in units
+  		| 		| of 100 Hz
+  --------------------------------------------------------------------
+  0x10		| pilot		| 0 - Stereo pilot is not present
+  		| 		| 1 - Stereo pilot is present
+  --------------------------------------------------------------------
+  0x11		| stblend	| Stereo blend in %
+  --------------------------------------------------------------------
+
+
+* /sys/kernel/debug/<device-name>/rds_blckcnt
+  This file contains statistics about RDS receptions. It's binary data
+  has the following layout:
+
+  Offset	| Name		| Description
+  ====================================================================
+  0x00		| expected	| Number of expected RDS blocks
+  --------------------------------------------------------------------
+  0x02		| received	| Number of received RDS blocks
+  --------------------------------------------------------------------
+  0x04		| uncorrectable	| Number of uncorrectable RDS blocks
+  --------------------------------------------------------------------
+
+* /sys/kernel/debug/<device-name>/agc
+  This file contains information about parameters pertaining to
+  AGC(Automatic Gain Control)
+
+  The layout is:
+  Offset	| Name		| Description
+  ====================================================================
+  0x00		| mxhi		| 0 - FM Mixer PD high threshold is
+  		| 		| not tripped
+		|		| 1 - FM Mixer PD high threshold is
+		|		| tripped
+  --------------------------------------------------------------------
+  0x01		| mxlo		| ditto for FM Mixer PD low
+  --------------------------------------------------------------------
+  0x02		| lnahi		| ditto for FM LNA PD high
+  --------------------------------------------------------------------
+  0x03		| lnalo		| ditto for FM LNA PD low
+  --------------------------------------------------------------------
+  0x04		| fmagc1	| FMAGC1 attenuator resistance
+  		| 		| (see datasheet for more detail)
+  --------------------------------------------------------------------
+  0x05		| fmagc2	| ditto for FMAGC2
+  --------------------------------------------------------------------
+  0x06		| pgagain	| PGA gain in dB
+  --------------------------------------------------------------------
+  0x07		| fmwblang	| FM/WB LNA Gain in dB
+  --------------------------------------------------------------------
+
+* /sys/kernel/debug/<device-name>/rsq
+  This file contains information about parameters pertaining to
+  RSQ(Received Signal Quality)
+
+  The layout is:
+  Offset	| Name		| Description
+  ====================================================================
+  0x00		| multhint	| 0 - multipath value has not crossed
+  		| 		| the Multipath high threshold
+		|		| 1 - multipath value has crossed
+  		| 		| the Multipath high threshold
+  --------------------------------------------------------------------
+  0x01		| multlint	| ditto for Multipath low threshold
+  --------------------------------------------------------------------
+  0x02		| snrhint	| 0 - received signal's SNR has not
+  		| 		| crossed high threshold
+		|		| 1 - received signal's SNR has
+  		| 		| crossed high threshold
+  --------------------------------------------------------------------
+  0x03		| snrlint	| ditto for low threshold
+  --------------------------------------------------------------------
+  0x04		| rssihint	| ditto for RSSI high threshold
+  --------------------------------------------------------------------
+  0x05		| rssilint	| ditto for RSSI low threshold
+  --------------------------------------------------------------------
+  0x06		| bltf		| Flag indicating if seek command
+  		| 		| reached/wrapped seek band limit
+  --------------------------------------------------------------------
+  0x07		| snr_ready	| Indicates that SNR metrics is ready
+  --------------------------------------------------------------------
+  0x08		| rssiready	| ditto for RSSI metrics
+  --------------------------------------------------------------------
+  0x09		| injside	| 0 - Low-side injection is being used
+  		| 		| 1 - High-side injection is used
+  --------------------------------------------------------------------
+  0x10		| afcrl		| Flag indicating if AFC rails
+  --------------------------------------------------------------------
+  0x11		| valid		| Flag indicating if channel is valid
+  --------------------------------------------------------------------
+  0x12		| readfreq	| Current tuned frequency
+  --------------------------------------------------------------------
+  0x14		| freqoff	| Singed frequency offset in units of
+  		| 		| 2ppm
+  --------------------------------------------------------------------
+  0x15		| rssi		| Signed value of RSSI in dBuV
+  --------------------------------------------------------------------
+  0x16		| snr		| Signed RF SNR in dB
+  --------------------------------------------------------------------
+  0x17		| issi		| Signed Image Strength Signal
+  		| 		| indicator
+  --------------------------------------------------------------------
+  0x18		| lassi		| Signed Low side adjacent Channel
+  		| 		| Strength indicator
+  --------------------------------------------------------------------
+  0x19		| hassi		| ditto fpr High side
+  --------------------------------------------------------------------
+  0x20		| mult		| Multipath indicator
+  --------------------------------------------------------------------
+  0x21		| dev		| Frequency deviation
+  --------------------------------------------------------------------
+  0x24		| assi		| Adjascent channel SSI
+  --------------------------------------------------------------------
+  0x25		| usn		| Ultrasonic noise indicator
+  --------------------------------------------------------------------
+  0x26		| pilotdev	| Pilot deviation in units of 100 Hz
+  --------------------------------------------------------------------
+  0x27		| rdsdev	| ditto for RDS
+  --------------------------------------------------------------------
+  0x28		| assidev	| ditto for ASSI
+  --------------------------------------------------------------------
+  0x29		| strongdev	| Frequency deviation
+  --------------------------------------------------------------------
+  0x30		| rdspi		| RDS PI code
+  --------------------------------------------------------------------
+
+* /sys/kernel/debug/<device-name>/rsq_primary
+  This file contains information about parameters pertaining to
+  RSQ(Received Signal Quality) for primary tuner only. Layout is as
+  the one above.
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 8090b87..f6a1932 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -18,6 +18,23 @@ config RADIO_SI470X
 
 source "drivers/media/radio/si470x/Kconfig"
 
+config RADIO_SI476X
+	tristate "Silicon Laboratories Si476x I2C FM Radio"
+	depends on I2C && VIDEO_V4L2
+	select MFD_CORE
+	select MFD_SI476X_CORE
+	select SND_SOC_SI476X
+	---help---
+	  Choose Y here if you have this FM radio chip.
+
+	  In order to control your radio card, you will need to use programs
+	  that are compatible with the Video For Linux 2 API.  Information on
+	  this API and pointers to "v4l2" programs may be found at
+	  <file:Documentation/video4linux/API.html>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-si476x.
+
 config USB_MR800
 	tristate "AverMedia MR 800 USB FM radio support"
 	depends on USB && VIDEO_V4L2
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index c03ce4f..c4618e0 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_RADIO_GEMTEK) += radio-gemtek.o
 obj-$(CONFIG_RADIO_TRUST) += radio-trust.o
 obj-$(CONFIG_I2C_SI4713) += si4713-i2c.o
 obj-$(CONFIG_RADIO_SI4713) += radio-si4713.o
+obj-$(CONFIG_RADIO_SI476X) += radio-si476x.o
 obj-$(CONFIG_RADIO_MIROPCM20) += radio-miropcm20.o
 obj-$(CONFIG_USB_DSBR) += dsbr100.o
 obj-$(CONFIG_RADIO_SI470X) += si470x/
diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
new file mode 100644
index 0000000..5fe08da
--- /dev/null
+++ b/drivers/media/radio/radio-si476x.c
@@ -0,0 +1,1557 @@
+/*
+ * drivers/media/radio/radio-si476x.c -- V4L2 driver for SI476X chips
+ *
+ * Copyright (C) 2012 Innovative Converged Devices(ICD)
+ * Copyright (C) 2013 Andrey Smirnov
+ *
+ * Author: Andrey Smirnov <andrew.smirnov@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/atomic.h>
+#include <linux/videodev2.h>
+#include <linux/mutex.h>
+#include <linux/debugfs.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-device.h>
+
+#include <media/si476x.h>
+#include <linux/mfd/si476x-core.h>
+
+#define FM_FREQ_RANGE_LOW   64000000
+#define FM_FREQ_RANGE_HIGH 108000000
+
+#define AM_FREQ_RANGE_LOW    520000
+#define AM_FREQ_RANGE_HIGH 30000000
+
+#define PWRLINEFLTR (1 << 8)
+
+#define FREQ_MUL (10000000 / 625)
+
+#define SI476X_PHDIV_STATUS_LINK_LOCKED(status) (0b10000000 & (status))
+
+#define DRIVER_NAME "si476x-radio"
+#define DRIVER_CARD "SI476x AM/FM Receiver"
+
+enum si476x_freq_bands {
+	SI476X_BAND_FM,
+	SI476X_BAND_AM,
+};
+
+static const struct v4l2_frequency_band si476x_bands[] = {
+	[SI476X_BAND_FM] = {
+		.type		= V4L2_TUNER_RADIO,
+		.index		= SI476X_BAND_FM,
+		.capability	= V4L2_TUNER_CAP_LOW
+		| V4L2_TUNER_CAP_STEREO
+		| V4L2_TUNER_CAP_RDS
+		| V4L2_TUNER_CAP_RDS_BLOCK_IO
+		| V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow	=  64 * FREQ_MUL,
+		.rangehigh	= 108 * FREQ_MUL,
+		.modulation	= V4L2_BAND_MODULATION_FM,
+	},
+	[SI476X_BAND_AM] = {
+		.type		= V4L2_TUNER_RADIO,
+		.index		= SI476X_BAND_AM,
+		.capability	= V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow	= 0.52 * FREQ_MUL,
+		.rangehigh	= 30 * FREQ_MUL,
+		.modulation	= V4L2_BAND_MODULATION_AM,
+	},
+};
+
+static inline bool si476x_radio_freq_is_inside_of_the_band(u32 freq, int band)
+{
+	return freq >= si476x_bands[band].rangelow &&
+		freq <= si476x_bands[band].rangehigh;
+}
+
+static inline bool si476x_radio_range_is_inside_of_the_band(u32 low, u32 high, int band)
+{
+	return low  >= si476x_bands[band].rangelow &&
+		high <= si476x_bands[band].rangehigh;
+}
+
+#define PRIVATE_CTL_IDX(x) (x - V4L2_CID_PRIVATE_BASE)
+
+static int si476x_radio_s_ctrl(struct v4l2_ctrl *ctrl);
+static int si476x_radio_g_volatile_ctrl(struct v4l2_ctrl *ctrl);
+
+static const char * const deemphasis[] = {
+	"75 us",
+	"50 us",
+};
+
+enum phase_diversity_modes_idx {
+	SI476X_IDX_PHDIV_DISABLED,
+	SI476X_IDX_PHDIV_PRIMARY_COMBINING,
+	SI476X_IDX_PHDIV_PRIMARY_ANTENNA,
+	SI476X_IDX_PHDIV_SECONDARY_ANTENNA,
+	SI476X_IDX_PHDIV_SECONDARY_COMBINING,
+};
+
+static const char * const phase_diversity_modes[] = {
+	[SI476X_IDX_PHDIV_DISABLED]		= "Disabled",
+	[SI476X_IDX_PHDIV_PRIMARY_COMBINING]	= "Primary W/Secondary",
+	[SI476X_IDX_PHDIV_PRIMARY_ANTENNA]	= "Primary(Primary Antenna)",
+	[SI476X_IDX_PHDIV_SECONDARY_ANTENNA]	= "Primary(Seconadary Antenna)",
+	[SI476X_IDX_PHDIV_SECONDARY_COMBINING]	= "Secondary W/Primary",
+};
+
+static inline enum phase_diversity_modes_idx
+si476x_phase_diversity_mode_to_idx(enum si476x_phase_diversity_mode mode)
+{
+	switch (mode) {
+	default:		/* FALLTHROUGH */
+	case SI476X_PHDIV_DISABLED:
+		return SI476X_IDX_PHDIV_DISABLED;
+	case SI476X_PHDIV_PRIMARY_COMBINING:
+		return SI476X_IDX_PHDIV_PRIMARY_COMBINING;
+	case SI476X_PHDIV_PRIMARY_ANTENNA:
+		return SI476X_IDX_PHDIV_PRIMARY_ANTENNA;
+	case SI476X_PHDIV_SECONDARY_ANTENNA:
+		return SI476X_IDX_PHDIV_SECONDARY_ANTENNA;
+	case SI476X_PHDIV_SECONDARY_COMBINING:
+		return SI476X_IDX_PHDIV_SECONDARY_COMBINING;
+	}
+}
+
+static inline enum si476x_phase_diversity_mode
+si476x_phase_diversity_idx_to_mode(enum phase_diversity_modes_idx idx)
+{
+	static const int idx_to_value[] = {
+		[SI476X_IDX_PHDIV_DISABLED]		= SI476X_PHDIV_DISABLED,
+		[SI476X_IDX_PHDIV_PRIMARY_COMBINING]	= SI476X_PHDIV_PRIMARY_COMBINING,
+		[SI476X_IDX_PHDIV_PRIMARY_ANTENNA]	= SI476X_PHDIV_PRIMARY_ANTENNA,
+		[SI476X_IDX_PHDIV_SECONDARY_ANTENNA]	= SI476X_PHDIV_SECONDARY_ANTENNA,
+		[SI476X_IDX_PHDIV_SECONDARY_COMBINING]	= SI476X_PHDIV_SECONDARY_COMBINING,
+	};
+
+	return idx_to_value[idx];
+}
+
+static const struct v4l2_ctrl_ops si476x_ctrl_ops = {
+	.g_volatile_ctrl	= si476x_radio_g_volatile_ctrl,
+	.s_ctrl			= si476x_radio_s_ctrl,
+};
+
+
+enum si476x_ctrl_idx {
+	SI476X_IDX_RSSI_THRESHOLD,
+	SI476X_IDX_SNR_THRESHOLD,
+	SI476X_IDX_MAX_TUNE_ERROR,
+	SI476X_IDX_HARMONICS_COUNT,
+	SI476X_IDX_DEEMPHASIS,
+	SI476X_IDX_RDS_RECEPTION,
+	SI476X_IDX_DIVERSITY_MODE,
+	SI476X_IDX_INTERCHIP_LINK,
+};
+
+static struct v4l2_ctrl_config si476x_ctrls[] = {
+	/*
+	   Tuning parameters
+	   'max tune errors' is shared for both AM/FM mode of operation
+	*/
+	[SI476X_IDX_RSSI_THRESHOLD] = {
+		.ops	= &si476x_ctrl_ops,
+		.id	= SI476X_CID_RSSI_THRESHOLD,
+		.name	= "Valid RSSI Threshold",
+		.type	= V4L2_CTRL_TYPE_INTEGER,
+		.min	= -128,
+		.max	= 127,
+		.step	= 1,
+	},
+	[SI476X_IDX_SNR_THRESHOLD] = {
+		.ops	= &si476x_ctrl_ops,
+		.id	= SI476X_CID_SNR_THRESHOLD,
+		.type	= V4L2_CTRL_TYPE_INTEGER,
+		.name	= "Valid SNR Threshold",
+		.min	= -128,
+		.max	= 127,
+		.step	= 1,
+	},
+	[SI476X_IDX_MAX_TUNE_ERROR] = {
+		.ops	= &si476x_ctrl_ops,
+		.id	= SI476X_CID_MAX_TUNE_ERROR,
+		.type	= V4L2_CTRL_TYPE_INTEGER,
+		.name	= "Max Tune Errors",
+		.min	= 0,
+		.max	= 126 * 2,
+		.step	= 2,
+	},
+	/*
+	   Region specific parameters
+	*/
+	[SI476X_IDX_HARMONICS_COUNT] = {
+		.ops	= &si476x_ctrl_ops,
+		.id	= SI476X_CID_HARMONICS_COUNT,
+		.type	= V4L2_CTRL_TYPE_INTEGER,
+
+		.name	= "Count Of Harmonics To Reject",
+		.min	= 0,
+		.max	= 20,
+		.step	= 1,
+	},
+	[SI476X_IDX_DEEMPHASIS] = {
+		.ops	= &si476x_ctrl_ops,
+		.id	= SI476X_CID_DEEMPHASIS,
+		.type	= V4L2_CTRL_TYPE_MENU,
+		.name	= "De-Emphassis",
+		.qmenu	= deemphasis,
+		.min	= 0,
+		.max	= ARRAY_SIZE(deemphasis) - 1,
+		.def	= 0,
+	},
+	[SI476X_IDX_RDS_RECEPTION] = {
+		.ops	= &si476x_ctrl_ops,
+		.id	= SI476X_CID_RDS_RECEPTION,
+		.type	= V4L2_CTRL_TYPE_BOOLEAN,
+		.name	= "RDS Reception",
+		.min	= 0,
+		.max	= 1,
+		.step	= 1,
+	},
+	[SI476X_IDX_DIVERSITY_MODE] = {
+		.ops	= &si476x_ctrl_ops,
+		.id	= SI476X_CID_DIVERSITY_MODE,
+		.type	= V4L2_CTRL_TYPE_MENU,
+		.name	= "Phase Diversity Mode",
+		.qmenu	= phase_diversity_modes,
+		.min	= 0,
+		.max	= ARRAY_SIZE(phase_diversity_modes) - 1,
+	},
+	[SI476X_IDX_INTERCHIP_LINK] = {
+		.ops	= &si476x_ctrl_ops,
+		.id	= SI476X_CID_INTERCHIP_LINK,
+		.type	= V4L2_CTRL_TYPE_BOOLEAN,
+		.flags  = V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_VOLATILE,
+		.name	= "Inter-Chip Link",
+		.min	= 0,
+		.max	= 1,
+		.step	= 1,
+	},
+};
+
+struct si476x_radio;
+
+/**
+ * struct si476x_radio_ops - vtable of tuner functions
+ *
+ * This table holds pointers to functions implementing particular
+ * operations depending on the mode in which the tuner chip was
+ * configured to start in. If the function is not supported
+ * corresponding element is set to #NULL.
+ *
+ * @tune_freq: Tune chip to a specific frequency
+ * @seek_start: Star station seeking
+ * @rsq_status: Get Recieved Signal Quality(RSQ) status
+ * @rds_blckcnt: Get recived RDS blocks count
+ * @phase_diversity: Change phase diversity mode of the tuner
+ * @phase_div_status: Get phase diversity mode status
+ * @acf_status: Get the status of Automatically Controlled
+ * Features(ACF)
+ * @agc_status: Get Automatic Gain Control(AGC) status
+ */
+struct si476x_radio_ops {
+	int (*tune_freq)(struct si476x_core *, struct si476x_tune_freq_args *);
+	int (*seek_start)(struct si476x_core *, bool, bool);
+	int (*rsq_status)(struct si476x_core *, struct si476x_rsq_status_args *,
+			  struct si476x_rsq_status_report *);
+	int (*rds_blckcnt)(struct si476x_core *, bool,
+			   struct si476x_rds_blockcount_report *);
+
+	int (*phase_diversity)(struct si476x_core *,
+			       enum si476x_phase_diversity_mode);
+	int (*phase_div_status)(struct si476x_core *);
+	int (*acf_status)(struct si476x_core *,
+			  struct si476x_acf_status_report *);
+	int (*agc_status)(struct si476x_core *,
+			  struct si476x_agc_status_report *);
+};
+
+/**
+ * struct si476x_radio - radio device
+ *
+ * @core: Pointer to underlying core device
+ * @videodev: Pointer to video device created by V4L2 subsystem
+ * @ops: Vtable of functions. See struct si476x_radio_ops for details
+ * @kref: Reference counter
+ * @core_lock: An r/w semaphore to brebvent the deletion of underlying
+ * core structure is the radio device is being used
+ */
+struct si476x_radio {
+	struct v4l2_device v4l2dev;
+	struct video_device videodev;
+	struct v4l2_ctrl_handler ctrl_handler;
+
+	struct si476x_core  *core;
+	/* This field should not be accesses unless core lock is held */
+	const struct si476x_radio_ops *ops;
+
+	struct dentry	*debugfs;
+	u32 audmode;
+};
+
+static inline struct si476x_radio *v4l2_dev_to_radio(struct v4l2_device *d)
+{
+	return container_of(d, struct si476x_radio, v4l2dev);
+}
+
+static inline struct si476x_radio *v4l2_ctrl_handler_to_radio(struct v4l2_ctrl_handler *d)
+{
+	return container_of(d, struct si476x_radio, ctrl_handler);
+}
+
+/*
+ * si476x_vidioc_querycap - query device capabilities
+ */
+static int si476x_radio_querycap(struct file *file, void *priv,
+				 struct v4l2_capability *capability)
+{
+	struct si476x_radio *radio = video_drvdata(file);
+
+	strlcpy(capability->driver, radio->v4l2dev.name,
+		sizeof(capability->driver));
+	strlcpy(capability->card,   DRIVER_CARD, sizeof(capability->card));
+	snprintf(capability->bus_info, sizeof(capability->bus_info),
+		 "platform:%s", radio->v4l2dev.name);
+
+	capability->device_caps = V4L2_CAP_TUNER
+		| V4L2_CAP_RADIO
+		| V4L2_CAP_HW_FREQ_SEEK;
+
+	si476x_core_lock(radio->core);
+	if (!si476x_core_is_a_secondary_tuner(radio->core))
+		capability->device_caps |= V4L2_CAP_RDS_CAPTURE
+			| V4L2_CAP_READWRITE;
+	si476x_core_unlock(radio->core);
+
+	capability->capabilities = capability->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+static int si476x_radio_enum_freq_bands(struct file *file, void *priv,
+					struct v4l2_frequency_band *band)
+{
+	int err;
+	struct si476x_radio *radio = video_drvdata(file);
+
+	if (band->tuner != 0)
+		return -EINVAL;
+
+	switch (radio->core->chip_id) {
+		/* AM/FM tuners -- all bands are supported */
+	case SI476X_CHIP_SI4761:
+	case SI476X_CHIP_SI4764:
+		if (band->index < ARRAY_SIZE(si476x_bands)) {
+			*band = si476x_bands[band->index];
+			err = 0;
+		} else {
+			err = -EINVAL;
+		}
+		break;
+		/* FM companion tuner chips -- only FM bands are
+		 * supported */
+	case SI476X_CHIP_SI4768:
+		if (band->index == SI476X_BAND_FM) {
+			*band = si476x_bands[band->index];
+			err = 0;
+		} else {
+			err = -EINVAL;
+		}
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+static int si476x_radio_g_tuner(struct file *file, void *priv,
+				struct v4l2_tuner *tuner)
+{
+	int err;
+	struct si476x_rsq_status_report report;
+	struct si476x_radio *radio = video_drvdata(file);
+
+	struct si476x_rsq_status_args args = {
+		.primary	= false,
+		.rsqack		= false,
+		.attune		= false,
+		.cancel		= false,
+		.stcack		= false,
+	};
+
+	if (tuner->index != 0)
+		return -EINVAL;
+
+	tuner->type       = V4L2_TUNER_RADIO;
+	tuner->capability = V4L2_TUNER_CAP_LOW /* Measure frequencies
+						 * in multiples of
+						 * 62.5 Hz */
+		| V4L2_TUNER_CAP_STEREO
+		| V4L2_TUNER_CAP_HWSEEK_BOUNDED
+		| V4L2_TUNER_CAP_HWSEEK_WRAP
+		| V4L2_TUNER_CAP_HWSEEK_PROG_LIM;
+
+	si476x_core_lock(radio->core);
+
+	if (si476x_core_is_a_secondary_tuner(radio->core)) {
+		strlcpy(tuner->name, "FM (secondary)", sizeof(tuner->name));
+		tuner->rxsubchans = 0;
+		tuner->rangelow = si476x_bands[SI476X_BAND_FM].rangelow;
+	} else if (si476x_core_has_am(radio->core)) {
+		if (si476x_core_is_a_primary_tuner(radio->core))
+			strlcpy(tuner->name, "AM/FM (primary)", sizeof(tuner->name));
+		else
+			strlcpy(tuner->name, "AM/FM", sizeof(tuner->name));
+
+		tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO
+			| V4L2_TUNER_SUB_RDS;
+		tuner->capability |= V4L2_TUNER_CAP_RDS
+			| V4L2_TUNER_CAP_RDS_BLOCK_IO
+			| V4L2_TUNER_CAP_FREQ_BANDS;
+
+		tuner->rangelow = si476x_bands[SI476X_BAND_AM].rangelow;
+	} else {
+		strlcpy(tuner->name, "FM", sizeof(tuner->name));
+		tuner->rxsubchans = V4L2_TUNER_SUB_RDS;
+		tuner->capability |= V4L2_TUNER_CAP_RDS
+			| V4L2_TUNER_CAP_RDS_BLOCK_IO
+			| V4L2_TUNER_CAP_FREQ_BANDS;
+		tuner->rangelow = si476x_bands[SI476X_BAND_FM].rangelow;
+	}
+
+	tuner->audmode = radio->audmode;
+
+	tuner->afc = 1;
+	tuner->rangehigh = si476x_bands[SI476X_BAND_FM].rangehigh;
+
+	err = radio->ops->rsq_status(radio->core,
+				     &args, &report);
+	if (err < 0) {
+		tuner->signal = 0;
+	} else {
+		/*
+		 * tuner->signal value range: 0x0000 .. 0xFFFF,
+		 * report.rssi: -128 .. 127
+		 */
+		tuner->signal = (report.rssi + 128) * 257;
+	}
+	si476x_core_unlock(radio->core);
+
+	return err;
+}
+
+static int si476x_radio_s_tuner(struct file *file, void *priv,
+				struct v4l2_tuner *tuner)
+{
+	struct si476x_radio *radio = video_drvdata(file);
+
+	if (tuner->index != 0)
+		return -EINVAL;
+
+	if (tuner->audmode == V4L2_TUNER_MODE_MONO ||
+	    tuner->audmode == V4L2_TUNER_MODE_STEREO)
+		radio->audmode = tuner->audmode;
+	else
+		radio->audmode = V4L2_TUNER_MODE_STEREO;
+
+	return 0;
+}
+
+static int si476x_radio_init_vtable(struct si476x_radio *radio, enum si476x_func func)
+{
+	static const struct si476x_radio_ops fm_ops = {
+		.tune_freq		= si476x_core_cmd_fm_tune_freq,
+		.seek_start		= si476x_core_cmd_fm_seek_start,
+		.rsq_status		= si476x_core_cmd_fm_rsq_status,
+		.rds_blckcnt		= si476x_core_cmd_fm_rds_blockcount,
+		.phase_diversity	= si476x_core_cmd_fm_phase_diversity,
+		.phase_div_status	= si476x_core_cmd_fm_phase_div_status,
+		.acf_status		= si476x_core_cmd_fm_acf_status,
+		.agc_status		= si476x_core_cmd_agc_status,
+	};
+
+	static const struct si476x_radio_ops am_ops = {
+		.tune_freq		= si476x_core_cmd_am_tune_freq,
+		.seek_start		= si476x_core_cmd_am_seek_start,
+		.rsq_status		= si476x_core_cmd_am_rsq_status,
+		.rds_blckcnt		= NULL,
+		.phase_diversity	= NULL,
+		.phase_div_status	= NULL,
+		.acf_status		= si476x_core_cmd_am_acf_status,
+		.agc_status		= NULL,
+	};
+
+	switch (func) {
+	case SI476X_FUNC_FM_RECEIVER:
+		radio->ops = &fm_ops;
+		return 0;
+
+	case SI476X_FUNC_AM_RECEIVER:
+		radio->ops = &am_ops;
+		return 0;
+	default:
+		WARN(1, "Unexpected tuner function value\n");
+		return -EINVAL;
+	}
+}
+
+static int si476x_radio_pretune(struct si476x_radio *radio, enum si476x_func func)
+{
+	int retval;
+
+	struct si476x_tune_freq_args args = {
+		.zifsr		= false,
+		.hd		= false,
+		.injside	= SI476X_INJSIDE_AUTO,
+		.tunemode	= SI476X_TM_VALIDATED_NORMAL_TUNE,
+		.smoothmetrics	= SI476X_SM_INITIALIZE_AUDIO,
+		.antcap		= 0,
+	};
+
+	switch (func) {
+	case SI476X_FUNC_FM_RECEIVER:
+		args.freq = v4l2_to_si476x(radio->core,
+					   92 * FREQ_MUL);
+		retval = radio->ops->tune_freq(radio->core, &args);
+		break;
+	case SI476X_FUNC_AM_RECEIVER:
+		args.freq = v4l2_to_si476x(radio->core,
+					   0.6 * FREQ_MUL);
+		retval = radio->ops->tune_freq(radio->core, &args);
+		break;
+	default:
+		WARN(1, "Unexpected tuner function value\n");
+		retval = -EINVAL;
+	}
+
+	return retval;
+}
+static int si476x_radio_do_post_powerup_init(struct si476x_radio *radio, enum si476x_func func)
+{
+	int err;
+
+	/* regcache_mark_dirty(radio->core->regmap); */
+	err = regcache_sync_region(radio->core->regmap,
+				   SI476X_PROP_DIGITAL_IO_INPUT_SAMPLE_RATE,
+				   SI476X_PROP_DIGITAL_IO_OUTPUT_FORMAT);
+		if (err < 0)
+			return err;
+
+	err = regcache_sync_region(radio->core->regmap,
+				   SI476X_PROP_AUDIO_DEEMPHASIS,
+				   SI476X_PROP_AUDIO_PWR_LINE_FILTER);
+	if (err < 0)
+		return err;
+
+	err = regcache_sync_region(radio->core->regmap,
+				   SI476X_PROP_INT_CTL_ENABLE,
+				   SI476X_PROP_INT_CTL_ENABLE);
+	if (err < 0)
+		return err;
+
+	/*
+	 * Is there any point in restoring SNR and the like
+	 * when switching between AM/FM?
+	 */
+	err = regcache_sync_region(radio->core->regmap,
+				   SI476X_PROP_VALID_MAX_TUNE_ERROR,
+				   SI476X_PROP_VALID_MAX_TUNE_ERROR);
+	if (err < 0)
+		return err;
+
+	err = regcache_sync_region(radio->core->regmap,
+				   SI476X_PROP_VALID_SNR_THRESHOLD,
+				   SI476X_PROP_VALID_RSSI_THRESHOLD);
+	if (err < 0)
+		return err;
+
+	if (func == SI476X_FUNC_FM_RECEIVER) {
+		if (si476x_core_has_diversity(radio->core)) {
+			err = si476x_core_cmd_fm_phase_diversity(radio->core,
+								 radio->core->diversity_mode);
+			if (err < 0)
+				return err;
+		}
+
+		err = regcache_sync_region(radio->core->regmap,
+					   SI476X_PROP_FM_RDS_INTERRUPT_SOURCE,
+					   SI476X_PROP_FM_RDS_CONFIG);
+		if (err < 0)
+			return err;
+	}
+
+	return si476x_radio_init_vtable(radio, func);
+
+}
+
+static int si476x_radio_change_func(struct si476x_radio *radio, enum si476x_func func)
+{
+	int err;
+	bool soft;
+	/*
+	 * Since power/up down is a very time consuming operation,
+	 * try to avoid doing it if the requested mode matches the one
+	 * the tuner is in
+	 */
+	if (func == radio->core->power_up_parameters.func)
+		return 0;
+
+	soft = true;
+	err = si476x_core_stop(radio->core, soft);
+	if (err < 0) {
+		/*
+		 * OK, if the chip does not want to play nice let's
+		 * try to reset it in more brutal way
+		 */
+		soft = false;
+		err = si476x_core_stop(radio->core, soft);
+		if (err < 0)
+			return err;
+	}
+	/*
+	  Set the desired radio tuner function
+	 */
+	radio->core->power_up_parameters.func = func;
+
+	err = si476x_core_start(radio->core, soft);
+	if (err < 0)
+		return err;
+
+	/*
+	 * No need to do the rest of manipulations for the bootlader
+	 * mode
+	 */
+	if (func != SI476X_FUNC_FM_RECEIVER &&
+	    func != SI476X_FUNC_AM_RECEIVER)
+		return err;
+
+	return si476x_radio_do_post_powerup_init(radio, func);
+}
+
+static int si476x_radio_g_frequency(struct file *file, void *priv,
+			      struct v4l2_frequency *f)
+{
+	int err;
+	struct si476x_radio *radio = video_drvdata(file);
+
+	if (f->tuner != 0 ||
+	    f->type  != V4L2_TUNER_RADIO)
+		return -EINVAL;
+
+	si476x_core_lock(radio->core);
+
+	if (radio->ops->rsq_status) {
+		struct si476x_rsq_status_report report;
+		struct si476x_rsq_status_args   args = {
+			.primary	= false,
+			.rsqack		= false,
+			.attune		= true,
+			.cancel		= false,
+			.stcack		= false,
+		};
+
+		err = radio->ops->rsq_status(radio->core, &args, &report);
+		if (!err)
+			f->frequency = si476x_to_v4l2(radio->core,
+						      report.readfreq);
+	} else {
+		err = -EINVAL;
+	}
+
+	si476x_core_unlock(radio->core);
+
+	return err;
+}
+
+static int si476x_radio_s_frequency(struct file *file, void *priv,
+				    struct v4l2_frequency *f)
+{
+	int err;
+	struct si476x_tune_freq_args args;
+	struct si476x_radio *radio = video_drvdata(file);
+
+	const u32 midrange = (si476x_bands[SI476X_BAND_AM].rangehigh +
+			      si476x_bands[SI476X_BAND_FM].rangelow) / 2;
+	const int band = (f->frequency > midrange) ? SI476X_BAND_FM : SI476X_BAND_AM;
+	const enum si476x_func func = (band == SI476X_BAND_AM) ?
+		SI476X_FUNC_AM_RECEIVER : SI476X_FUNC_FM_RECEIVER;
+
+	if (f->tuner != 0 ||
+	    f->type  != V4L2_TUNER_RADIO)
+		return -EINVAL;
+
+	si476x_core_lock(radio->core);
+
+	f->frequency = clamp(f->frequency,
+			     si476x_bands[band].rangelow,
+			     si476x_bands[band].rangehigh);
+
+	if (si476x_radio_freq_is_inside_of_the_band(f->frequency, SI476X_BAND_AM) &&
+	    (!si476x_core_has_am(radio->core) || si476x_core_is_a_secondary_tuner(radio->core))) {
+		err = -EINVAL;
+		goto unlock;
+	}
+
+	err = si476x_radio_change_func(radio, func);
+	if (err < 0)
+		goto unlock;
+
+	args.zifsr		= false;
+	args.hd			= false;
+	args.injside		= SI476X_INJSIDE_AUTO;
+	args.freq		= v4l2_to_si476x(radio->core,
+						 f->frequency);
+	args.tunemode		= SI476X_TM_VALIDATED_NORMAL_TUNE;
+	args.smoothmetrics	= SI476X_SM_INITIALIZE_AUDIO;
+	args.antcap		= 0;
+
+	err = radio->ops->tune_freq(radio->core, &args);
+
+unlock:
+	si476x_core_unlock(radio->core);
+	return err;
+}
+
+static int si476x_radio_s_hw_freq_seek(struct file *file, void *priv,
+				       const struct v4l2_hw_freq_seek *seek)
+{
+	int err;
+	enum si476x_func func;
+	u32 rangelow, rangehigh;
+	struct si476x_radio *radio = video_drvdata(file);
+
+	if (file->f_flags & O_NONBLOCK)
+		return -EAGAIN;
+
+	if (seek->tuner != 0 ||
+	    seek->type  != V4L2_TUNER_RADIO)
+		return -EINVAL;
+
+	si476x_core_lock(radio->core);
+
+	if(!seek->rangelow) {
+		err = regmap_read(radio->core->regmap,
+				  SI476X_PROP_SEEK_BAND_BOTTOM,
+				  &rangelow);
+		if (!err)
+			rangelow = si476x_to_v4l2(radio->core, rangelow);
+		else
+			goto unlock;
+	}
+	if(!seek->rangehigh) {
+		err = regmap_read(radio->core->regmap,
+				  SI476X_PROP_SEEK_BAND_TOP,
+				  &rangehigh);
+		if (!err)
+			rangehigh = si476x_to_v4l2(radio->core, rangehigh);
+		else
+			goto unlock;
+	}
+
+	if (rangelow > rangehigh) {
+		err = -EINVAL;
+		goto unlock;
+	}
+
+	if (si476x_radio_range_is_inside_of_the_band(rangelow, rangehigh,
+						     SI476X_BAND_FM)) {
+		func = SI476X_FUNC_FM_RECEIVER;
+
+	} else if (si476x_core_has_am(radio->core) &&
+		   si476x_radio_range_is_inside_of_the_band(rangelow, rangehigh,
+							    SI476X_BAND_AM)) {
+		func = SI476X_FUNC_AM_RECEIVER;
+	} else {
+		err = -EINVAL;
+		goto unlock;
+	}
+
+	err = si476x_radio_change_func(radio, func);
+	if (err < 0) {
+		goto unlock;
+	}
+
+	if (seek->rangehigh) {
+		err = regmap_write(radio->core->regmap,
+				   SI476X_PROP_SEEK_BAND_TOP,
+				   v4l2_to_si476x(radio->core,
+						  seek->rangehigh));
+		if (err)
+			goto unlock;
+	}
+	if (seek->rangelow) {
+		err = regmap_write(radio->core->regmap,
+				   SI476X_PROP_SEEK_BAND_BOTTOM,
+				   v4l2_to_si476x(radio->core,
+						  seek->rangelow));
+		if (err)
+			goto unlock;
+	}
+	if (seek->spacing) {
+		err = regmap_write(radio->core->regmap,
+				     SI476X_PROP_SEEK_FREQUENCY_SPACING,
+				     v4l2_to_si476x(radio->core,
+						    seek->spacing));
+		if (err)
+			goto unlock;
+	}
+
+	err = radio->ops->seek_start(radio->core,
+				     seek->seek_upward,
+				     seek->wrap_around);
+unlock:
+	si476x_core_unlock(radio->core);
+
+
+
+	return err;
+}
+
+static int si476x_radio_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	int retval;
+	struct si476x_radio *radio = v4l2_ctrl_handler_to_radio(ctrl->handler);
+
+	si476x_core_lock(radio->core);
+
+	switch (ctrl->id) {
+	case SI476X_CID_INTERCHIP_LINK:
+		if (si476x_core_has_diversity(radio->core)) {
+			if (radio->ops->phase_diversity) {
+				retval = radio->ops->phase_div_status(radio->core);
+				if (retval < 0)
+					break;
+
+				ctrl->val = !!SI476X_PHDIV_STATUS_LINK_LOCKED(retval);
+				retval = 0;
+				break;
+			} else {
+				retval = -ENOTTY;
+				break;
+			}
+		}
+		retval = -EINVAL;
+		break;
+	default:
+		retval = -EINVAL;
+		break;
+	}
+	si476x_core_unlock(radio->core);
+	return retval;
+
+}
+
+static int si476x_radio_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	int retval;
+	enum si476x_phase_diversity_mode mode;
+	struct si476x_radio *radio = v4l2_ctrl_handler_to_radio(ctrl->handler);
+
+	si476x_core_lock(radio->core);
+
+	switch (ctrl->id) {
+	case SI476X_CID_HARMONICS_COUNT:
+		retval = regmap_update_bits(radio->core->regmap,
+					    SI476X_PROP_AUDIO_PWR_LINE_FILTER,
+					    SI476X_PROP_PWR_HARMONICS_MASK,
+					    ctrl->val);
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		switch (ctrl->val) {
+		case V4L2_CID_POWER_LINE_FREQUENCY_DISABLED:
+			retval = regmap_update_bits(radio->core->regmap,
+						    SI476X_PROP_AUDIO_PWR_LINE_FILTER,
+						    SI476X_PROP_PWR_ENABLE_MASK,
+						    0);
+			break;
+		case V4L2_CID_POWER_LINE_FREQUENCY_50HZ:
+			retval = regmap_update_bits(radio->core->regmap,
+						    SI476X_PROP_AUDIO_PWR_LINE_FILTER,
+						    SI476X_PROP_PWR_GRID_MASK,
+						    SI476X_PROP_PWR_GRID_50HZ);
+			break;
+		case V4L2_CID_POWER_LINE_FREQUENCY_60HZ:
+			retval = regmap_update_bits(radio->core->regmap,
+						    SI476X_PROP_AUDIO_PWR_LINE_FILTER,
+						    SI476X_PROP_PWR_GRID_MASK,
+						    SI476X_PROP_PWR_GRID_60HZ);
+			break;
+		default:
+			retval = -EINVAL;
+			break;
+		}
+		break;
+	case SI476X_CID_RSSI_THRESHOLD:
+		retval = regmap_write(radio->core->regmap,
+				      SI476X_PROP_VALID_RSSI_THRESHOLD,
+				      ctrl->val);
+		break;
+	case SI476X_CID_SNR_THRESHOLD:
+		retval = regmap_write(radio->core->regmap,
+				      SI476X_PROP_VALID_SNR_THRESHOLD,
+				      ctrl->val);
+		break;
+	case SI476X_CID_MAX_TUNE_ERROR:
+		retval = regmap_write(radio->core->regmap,
+				      SI476X_PROP_VALID_MAX_TUNE_ERROR,
+				      ctrl->val);
+		break;
+	case SI476X_CID_RDS_RECEPTION:
+		/*
+		 * It looks like RDS related properties are
+		 * inaccesable when tuner is in AM mode, so cache the
+		 * changes
+		 */
+		if(si476x_core_is_in_am_receiver_mode(radio->core))
+			regcache_cache_only(radio->core->regmap, true);
+
+		if (ctrl->val) {
+			retval = regmap_write(radio->core->regmap,
+					      SI476X_PROP_FM_RDS_INTERRUPT_FIFO_COUNT,
+					      radio->core->rds_fifo_depth);
+			if (retval < 0)
+				break;
+
+			if (radio->core->client->irq) {
+				retval = regmap_write(radio->core->regmap,
+						      SI476X_PROP_FM_RDS_INTERRUPT_SOURCE,
+						      SI476X_RDSRECV);
+				if (retval < 0)
+					break;
+			}
+
+			/* Drain RDS FIFO before enabling RDS processing */
+			retval = si476x_core_cmd_fm_rds_status(radio->core, false,
+							       true, true, NULL);
+			if (retval < 0)
+				break;
+
+			retval = regmap_update_bits(radio->core->regmap,
+						    SI476X_PROP_FM_RDS_CONFIG,
+						    SI476X_PROP_RDSEN_MASK,
+						    SI476X_PROP_RDSEN);
+		} else {
+			retval = regmap_update_bits(radio->core->regmap,
+						    SI476X_PROP_FM_RDS_CONFIG,
+						    SI476X_PROP_RDSEN_MASK,
+						    !SI476X_PROP_RDSEN);
+		}
+
+		if(si476x_core_is_in_am_receiver_mode(radio->core))
+			regcache_cache_only(radio->core->regmap, false);
+		break;
+	case SI476X_CID_DEEMPHASIS:
+		retval = regmap_write(radio->core->regmap,
+				      SI476X_PROP_AUDIO_DEEMPHASIS,
+				      ctrl->val);
+		break;
+
+	case SI476X_CID_DIVERSITY_MODE:
+		mode = si476x_phase_diversity_idx_to_mode(ctrl->val);
+
+		if (mode == radio->core->diversity_mode) {
+			retval = 0;
+			break;
+		}
+
+		if(si476x_core_is_in_am_receiver_mode(radio->core)) {
+			/*
+			 * Diversity cannot be configured while tuner
+			 * is in AM mode so save the changes and carry on.
+			 */
+			radio->core->diversity_mode = mode;
+			retval = 0;
+		} else {
+			retval = radio->ops->phase_diversity(radio->core, mode);
+			if (!retval)
+				radio->core->diversity_mode = mode;
+		}
+		break;
+
+	default:
+		retval = -EINVAL;
+		break;
+	}
+
+	si476x_core_unlock(radio->core);
+
+	return retval;
+}
+
+static int si476x_radio_g_chip_ident(struct file *file, void *fh,
+				     struct v4l2_dbg_chip_ident *chip)
+{
+	if (chip->match.type == V4L2_CHIP_MATCH_HOST &&
+	    v4l2_chip_match_host(&chip->match))
+		return 0;
+	return -EINVAL;
+}
+
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int si476x_radio_g_register(struct file *file, void *fh,
+				   struct v4l2_dbg_register *reg)
+{
+	int err;
+	unsigned int value;
+	struct si476x_radio *radio = video_drvdata(file);
+
+	si476x_core_lock(radio->core);
+	reg->size = 2;
+	err = regmap_read(radio->core->regmap,
+			  (unsigned int)reg->reg, &value);
+	reg->val = value;
+	si476x_core_unlock(radio->core);
+
+	return err;
+}
+static int si476x_radio_s_register(struct file *file, void *fh,
+				   struct v4l2_dbg_register *reg)
+{
+
+	int err;
+	struct si476x_radio *radio = video_drvdata(file);
+
+	si476x_core_lock(radio->core);
+	err = regmap_write(radio->core->regmap,
+			   (unsigned int)reg->reg,
+			   (unsigned int)reg->val);
+	si476x_core_unlock(radio->core);
+
+	return err;
+}
+#endif
+
+static int si476x_radio_fops_open(struct file *file)
+{
+	struct si476x_radio *radio = video_drvdata(file);
+	int err;
+
+	err = v4l2_fh_open(file);
+	if (err)
+		return err;
+
+	if (v4l2_fh_is_singular_file(file)) {
+		si476x_core_lock(radio->core);
+		err = si476x_core_set_power_state(radio->core,
+						  SI476X_POWER_UP_FULL);
+		if (err < 0)
+			goto done;
+
+		err = si476x_radio_do_post_powerup_init(radio,
+							radio->core->power_up_parameters.func);
+		if (err < 0)
+			goto power_down;
+
+		err = si476x_radio_pretune(radio,
+					   radio->core->power_up_parameters.func);
+		if (err < 0)
+			goto power_down;
+
+		si476x_core_unlock(radio->core);
+		/* Must be done after si476x_core_unlock to prevent a deadlock */
+		v4l2_ctrl_handler_setup(&radio->ctrl_handler);
+	}
+
+	return err;
+
+power_down:
+	si476x_core_set_power_state(radio->core,
+				    SI476X_POWER_DOWN);
+done:
+	si476x_core_unlock(radio->core);
+	v4l2_fh_release(file);
+
+	return err;
+}
+
+static int si476x_radio_fops_release(struct file *file)
+{
+	int err;
+	struct si476x_radio *radio = video_drvdata(file);
+
+	if (v4l2_fh_is_singular_file(file) &&
+	    atomic_read(&radio->core->is_alive))
+		si476x_core_set_power_state(radio->core,
+					    SI476X_POWER_DOWN);
+
+	err = v4l2_fh_release(file);
+
+	return err;
+}
+
+static ssize_t si476x_radio_fops_read(struct file *file, char __user *buf,
+				      size_t count, loff_t *ppos)
+{
+	ssize_t      rval;
+	size_t       fifo_len;
+	unsigned int copied;
+
+	struct si476x_radio *radio = video_drvdata(file);
+
+	/* block if no new data available */
+	if (kfifo_is_empty(&radio->core->rds_fifo)) {
+		if (file->f_flags & O_NONBLOCK)
+			return -EWOULDBLOCK;
+
+		rval = wait_event_interruptible(radio->core->rds_read_queue,
+						(!kfifo_is_empty(&radio->core->rds_fifo) ||
+						 !atomic_read(&radio->core->is_alive)));
+		if (rval < 0)
+			return -EINTR;
+
+		if (!atomic_read(&radio->core->is_alive))
+			return -ENODEV;
+	}
+
+	fifo_len = kfifo_len(&radio->core->rds_fifo);
+
+	if (kfifo_to_user(&radio->core->rds_fifo, buf,
+			  min(fifo_len, count),
+			  &copied) != 0) {
+		dev_warn(&radio->videodev.dev,
+			 "Error during FIFO to userspace copy\n");
+		rval = -EIO;
+	} else {
+		rval = (ssize_t)copied;
+	}
+
+	return rval;
+}
+
+static unsigned int si476x_radio_fops_poll(struct file *file,
+				struct poll_table_struct *pts)
+{
+	struct si476x_radio *radio = video_drvdata(file);
+	unsigned long req_events = poll_requested_events(pts);
+	unsigned int err = v4l2_ctrl_poll(file, pts);
+
+	if (req_events & (POLLIN | POLLRDNORM)) {
+		if (atomic_read(&radio->core->is_alive))
+			poll_wait(file, &radio->core->rds_read_queue, pts);
+
+		if (!atomic_read(&radio->core->is_alive))
+			err = POLLHUP;
+
+		if (!kfifo_is_empty(&radio->core->rds_fifo))
+			err = POLLIN | POLLRDNORM;
+	}
+
+	return err;
+}
+
+static const struct v4l2_file_operations si476x_fops = {
+	.owner			= THIS_MODULE,
+	.read			= si476x_radio_fops_read,
+	.poll			= si476x_radio_fops_poll,
+	.unlocked_ioctl		= video_ioctl2,
+	.open			= si476x_radio_fops_open,
+	.release		= si476x_radio_fops_release,
+};
+
+
+static const struct v4l2_ioctl_ops si4761_ioctl_ops = {
+	.vidioc_querycap		= si476x_radio_querycap,
+	.vidioc_g_tuner			= si476x_radio_g_tuner,
+	.vidioc_s_tuner			= si476x_radio_s_tuner,
+
+	.vidioc_g_frequency		= si476x_radio_g_frequency,
+	.vidioc_s_frequency		= si476x_radio_s_frequency,
+	.vidioc_s_hw_freq_seek		= si476x_radio_s_hw_freq_seek,
+	.vidioc_enum_freq_bands		= si476x_radio_enum_freq_bands,
+
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+
+	.vidioc_g_chip_ident		= si476x_radio_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register		= si476x_radio_g_register,
+	.vidioc_s_register		= si476x_radio_s_register,
+#endif
+};
+
+
+static const struct video_device si476x_viddev_template = {
+	.fops			= &si476x_fops,
+	.name			= DRIVER_NAME,
+	.release		= video_device_release_empty,
+};
+
+
+
+static ssize_t si476x_radio_read_acf_blob(struct file *file, char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	int err;
+	struct si476x_radio *radio = file->private_data;
+	struct si476x_acf_status_report report;
+
+	si476x_core_lock(radio->core);
+	if (radio->ops->acf_status)
+		err = radio->ops->acf_status(radio->core, &report);
+	else
+		err = -ENOENT;
+	si476x_core_unlock(radio->core);
+
+	if (err < 0)
+		return err;
+
+	return simple_read_from_buffer(user_buf, count, ppos, &report,
+				       sizeof(report));
+}
+
+static const struct file_operations radio_acf_fops = {
+	.open	= simple_open,
+	.llseek = default_llseek,
+	.read	= si476x_radio_read_acf_blob,
+};
+
+static ssize_t si476x_radio_read_rds_blckcnt_blob(struct file *file, char __user *user_buf,
+						  size_t count, loff_t *ppos)
+{
+	int err;
+	struct si476x_radio *radio = file->private_data;
+	struct si476x_rds_blockcount_report report;
+
+	si476x_core_lock(radio->core);
+	if (radio->ops->rds_blckcnt)
+		err = radio->ops->rds_blckcnt(radio->core, true,
+					       &report);
+	else
+		err = -ENOENT;
+	si476x_core_unlock(radio->core);
+
+	if (err < 0)
+		return err;
+
+	return simple_read_from_buffer(user_buf, count, ppos, &report,
+				       sizeof(report));
+}
+
+static const struct file_operations radio_rds_blckcnt_fops = {
+	.open	= simple_open,
+	.llseek = default_llseek,
+	.read	= si476x_radio_read_rds_blckcnt_blob,
+};
+
+static ssize_t si476x_radio_read_agc_blob(struct file *file, char __user *user_buf,
+						  size_t count, loff_t *ppos)
+{
+	int err;
+	struct si476x_radio *radio = file->private_data;
+	struct si476x_agc_status_report report;
+
+	si476x_core_lock(radio->core);
+	if (radio->ops->rds_blckcnt)
+		err = radio->ops->agc_status(radio->core, &report);
+	else
+		err = -ENOENT;
+	si476x_core_unlock(radio->core);
+
+	if (err < 0)
+		return err;
+
+	return simple_read_from_buffer(user_buf, count, ppos, &report,
+				       sizeof(report));
+}
+
+static const struct file_operations radio_agc_fops = {
+	.open	= simple_open,
+	.llseek = default_llseek,
+	.read	= si476x_radio_read_agc_blob,
+};
+
+static ssize_t si476x_radio_read_rsq_blob(struct file *file, char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	int err;
+	struct si476x_radio *radio = file->private_data;
+	struct si476x_rsq_status_report report;
+	struct si476x_rsq_status_args args = {
+		.primary	= false,
+		.rsqack		= false,
+		.attune		= false,
+		.cancel		= false,
+		.stcack		= false,
+	};
+
+	si476x_core_lock(radio->core);
+	if (radio->ops->rds_blckcnt)
+		err = radio->ops->rsq_status(radio->core, &args, &report);
+	else
+		err = -ENOENT;
+	si476x_core_unlock(radio->core);
+
+	if (err < 0)
+		return err;
+
+	return simple_read_from_buffer(user_buf, count, ppos, &report,
+				       sizeof(report));
+}
+
+static const struct file_operations radio_rsq_fops = {
+	.open	= simple_open,
+	.llseek = default_llseek,
+	.read	= si476x_radio_read_rsq_blob,
+};
+
+static ssize_t si476x_radio_read_rsq_primary_blob(struct file *file,
+						  char __user *user_buf,
+						  size_t count, loff_t *ppos)
+{
+	int err;
+	struct si476x_radio *radio = file->private_data;
+	struct si476x_rsq_status_report report;
+	struct si476x_rsq_status_args args = {
+		.primary	= true,
+		.rsqack		= false,
+		.attune		= false,
+		.cancel		= false,
+		.stcack		= false,
+	};
+
+	si476x_core_lock(radio->core);
+	if (radio->ops->rds_blckcnt)
+		err = radio->ops->rsq_status(radio->core, &args, &report);
+	else
+		err = -ENOENT;
+	si476x_core_unlock(radio->core);
+
+	if (err < 0)
+		return err;
+
+	return simple_read_from_buffer(user_buf, count, ppos, &report,
+				       sizeof(report));
+}
+
+static const struct file_operations radio_rsq_primary_fops = {
+	.open	= simple_open,
+	.llseek = default_llseek,
+	.read	= si476x_radio_read_rsq_primary_blob,
+};
+
+
+static int si476x_radio_init_debugfs(struct si476x_radio *radio)
+{
+	struct dentry	*dentry;
+	int		ret;
+
+	dentry = debugfs_create_dir(dev_name(radio->v4l2dev.dev), NULL);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
+		goto exit;
+	}
+	radio->debugfs = dentry;
+
+	dentry = debugfs_create_file("acf", S_IRUGO,
+				     radio->debugfs, radio, &radio_acf_fops);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
+		goto cleanup;
+	}
+
+	dentry = debugfs_create_file("rds_blckcnt", S_IRUGO,
+				     radio->debugfs, radio, &radio_rds_blckcnt_fops);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
+		goto cleanup;
+	}
+
+	dentry = debugfs_create_file("agc", S_IRUGO,
+				     radio->debugfs, radio, &radio_agc_fops);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
+		goto cleanup;
+	}
+
+	dentry = debugfs_create_file("rsq", S_IRUGO,
+				     radio->debugfs, radio, &radio_rsq_fops);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
+		goto cleanup;
+	}
+
+	dentry = debugfs_create_file("rsq_primary", S_IRUGO,
+				     radio->debugfs, radio, &radio_rsq_primary_fops);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
+		goto cleanup;
+	}
+
+	return 0;
+cleanup:
+	debugfs_remove_recursive(radio->debugfs);
+exit:
+	return ret;
+}
+
+
+static int si476x_radio_add_new_custom(struct si476x_radio *radio,
+							enum si476x_ctrl_idx idx)
+{
+	int rval;
+	struct v4l2_ctrl *ctrl;
+
+	ctrl = v4l2_ctrl_new_custom(&radio->ctrl_handler,
+				    &si476x_ctrls[idx],
+				    NULL);
+	rval = radio->ctrl_handler.error;
+	if (ctrl == NULL && rval)
+		dev_err(radio->v4l2dev.dev, "Could not initialize '%s' control %d\n",
+			si476x_ctrls[idx].name, rval);
+
+	return rval;
+}
+
+static int si476x_radio_probe(struct platform_device *pdev)
+{
+	int rval;
+	struct si476x_radio *radio;
+
+	static atomic_t instance = ATOMIC_INIT(0);
+
+	radio = devm_kzalloc(&pdev->dev, sizeof(*radio), GFP_KERNEL);
+	if (!radio)
+		return -ENOMEM;
+
+	radio->core = i2c_mfd_cell_to_core(&pdev->dev);
+
+	v4l2_device_set_name(&radio->v4l2dev, DRIVER_NAME, &instance);
+
+	rval = v4l2_device_register(&pdev->dev, &radio->v4l2dev);
+	if (rval) {
+		dev_err(&pdev->dev, "Cannot register v4l2_device.\n");
+		return rval;
+	}
+
+	memcpy(&radio->videodev, &si476x_viddev_template,
+	       sizeof(struct video_device));
+
+	radio->videodev.v4l2_dev  = &radio->v4l2dev;
+	radio->videodev.ioctl_ops = &si4761_ioctl_ops;
+
+	video_set_drvdata(&radio->videodev, radio);
+	platform_set_drvdata(pdev, radio);
+
+	set_bit(V4L2_FL_USE_FH_PRIO, &radio->videodev.flags);
+
+	radio->v4l2dev.ctrl_handler = &radio->ctrl_handler;
+	v4l2_ctrl_handler_init(&radio->ctrl_handler, 1 + ARRAY_SIZE(si476x_ctrls));
+
+	if (si476x_core_has_am(radio->core)) {
+		struct v4l2_ctrl *ctrl;
+
+		ctrl = v4l2_ctrl_new_std_menu(&radio->ctrl_handler,
+					      &si476x_ctrl_ops,
+					      V4L2_CID_POWER_LINE_FREQUENCY,
+					      V4L2_CID_POWER_LINE_FREQUENCY_60HZ, 0, 0);
+		rval = radio->ctrl_handler.error;
+		if (ctrl == NULL && rval) {
+			dev_err(&pdev->dev, "Could not initialize V4L2_CID_POWER_LINE_FREQUENCY control %d\n",
+				rval);
+			goto exit;
+		}
+
+		rval = si476x_radio_add_new_custom(radio, SI476X_IDX_HARMONICS_COUNT);
+		if (rval < 0)
+			goto exit;
+	}
+
+	rval = si476x_radio_add_new_custom(radio, SI476X_IDX_RSSI_THRESHOLD);
+	if (rval < 0)
+		goto exit;
+
+	rval = si476x_radio_add_new_custom(radio, SI476X_IDX_SNR_THRESHOLD);
+	if (rval < 0)
+		goto exit;
+
+	rval = si476x_radio_add_new_custom(radio, SI476X_IDX_MAX_TUNE_ERROR);
+	if (rval < 0)
+		goto exit;
+
+	rval = si476x_radio_add_new_custom(radio, SI476X_IDX_DEEMPHASIS);
+	if (rval < 0)
+		goto exit;
+
+	rval = si476x_radio_add_new_custom(radio, SI476X_IDX_RDS_RECEPTION);
+	if (rval < 0)
+		goto exit;
+
+	if (si476x_core_has_diversity(radio->core)) {
+		si476x_ctrls[SI476X_IDX_DIVERSITY_MODE].def =
+			si476x_phase_diversity_mode_to_idx(radio->core->diversity_mode);
+		si476x_radio_add_new_custom(radio, SI476X_IDX_DIVERSITY_MODE);
+		if (rval < 0)
+			goto exit;
+
+		si476x_radio_add_new_custom(radio, SI476X_IDX_INTERCHIP_LINK);
+		if (rval < 0)
+			goto exit;
+	}
+
+	/* register video device */
+	rval = video_register_device(&radio->videodev, VFL_TYPE_RADIO, -1);
+	if (rval < 0) {
+		dev_err(&pdev->dev, "Could not register video device\n");
+		goto exit;
+	}
+
+	rval = si476x_radio_init_debugfs(radio);
+	if (rval < 0) {
+		dev_err(&pdev->dev, "Could not creat debugfs interface\n");
+		goto exit;
+	}
+
+	return 0;
+exit:
+	v4l2_ctrl_handler_free(radio->videodev.ctrl_handler);
+	return rval;
+}
+
+static int si476x_radio_remove(struct platform_device *pdev)
+{
+	struct si476x_radio *radio = platform_get_drvdata(pdev);
+
+	v4l2_ctrl_handler_free(radio->videodev.ctrl_handler);
+	video_unregister_device(&radio->videodev);
+	v4l2_device_unregister(&radio->v4l2dev);
+	debugfs_remove_recursive(radio->debugfs);
+
+	return 0;
+}
+
+MODULE_ALIAS("platform:si476x-radio");
+
+static struct platform_driver si476x_radio_driver = {
+	.driver		= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= si476x_radio_probe,
+	.remove		= si476x_radio_remove,
+};
+module_platform_driver(si476x_radio_driver);
+
+MODULE_AUTHOR("Andrey Smirnov <andrew.smirnov@gmail.com>");
+MODULE_DESCRIPTION("Driver for Si4761/64/68 AM/FM Radio MFD Cell");
+MODULE_LICENSE("GPL");
diff --git a/include/media/si476x.h b/include/media/si476x.h
new file mode 100644
index 0000000..517ecda
--- /dev/null
+++ b/include/media/si476x.h
@@ -0,0 +1,428 @@
+/*
+ * include/media/si476x.h -- Common definitions for si476x driver
+ *
+ * Copyright (C) 2012 Innovative Converged Devices(ICD)
+ * Copyright (C) 2013 Andrey Smirnov
+ *
+ * Author: Andrey Smirnov <andrew.smirnov@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#ifndef SI476X_H
+#define SI476X_H
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+struct si476x_device;
+
+/* It is possible to select one of the four adresses using pins A0
+ * and A1 on SI476x */
+#define SI476X_I2C_ADDR_1	0x60
+#define SI476X_I2C_ADDR_2	0x61
+#define SI476X_I2C_ADDR_3	0x62
+#define SI476X_I2C_ADDR_4	0x63
+
+enum si476x_iqclk_config {
+	SI476X_IQCLK_NOOP = 0,
+	SI476X_IQCLK_TRISTATE = 1,
+	SI476X_IQCLK_IQ = 21,
+};
+enum si476x_iqfs_config {
+	SI476X_IQFS_NOOP = 0,
+	SI476X_IQFS_TRISTATE = 1,
+	SI476X_IQFS_IQ = 21,
+};
+enum si476x_iout_config {
+	SI476X_IOUT_NOOP = 0,
+	SI476X_IOUT_TRISTATE = 1,
+	SI476X_IOUT_OUTPUT = 22,
+};
+enum si476x_qout_config {
+	SI476X_QOUT_NOOP = 0,
+	SI476X_QOUT_TRISTATE = 1,
+	SI476X_QOUT_OUTPUT = 22,
+};
+
+enum si476x_dclk_config {
+	SI476X_DCLK_NOOP      = 0,
+	SI476X_DCLK_TRISTATE  = 1,
+	SI476X_DCLK_DAUDIO    = 10,
+};
+
+enum si476x_dfs_config {
+	SI476X_DFS_NOOP      = 0,
+	SI476X_DFS_TRISTATE  = 1,
+	SI476X_DFS_DAUDIO    = 10,
+};
+
+enum si476x_dout_config {
+	SI476X_DOUT_NOOP       = 0,
+	SI476X_DOUT_TRISTATE   = 1,
+	SI476X_DOUT_I2S_OUTPUT = 12,
+	SI476X_DOUT_I2S_INPUT  = 13,
+};
+
+enum si476x_xout_config {
+	SI476X_XOUT_NOOP        = 0,
+	SI476X_XOUT_TRISTATE    = 1,
+	SI476X_XOUT_I2S_INPUT   = 13,
+	SI476X_XOUT_MODE_SELECT = 23,
+};
+
+
+enum si476x_icin_config {
+	SI476X_ICIN_NOOP	= 0,
+	SI476X_ICIN_TRISTATE	= 1,
+	SI476X_ICIN_GPO1_HIGH	= 2,
+	SI476X_ICIN_GPO1_LOW	= 3,
+	SI476X_ICIN_IC_LINK	= 30,
+};
+
+enum si476x_icip_config {
+	SI476X_ICIP_NOOP	= 0,
+	SI476X_ICIP_TRISTATE	= 1,
+	SI476X_ICIP_GPO2_HIGH	= 2,
+	SI476X_ICIP_GPO2_LOW	= 3,
+	SI476X_ICIP_IC_LINK	= 30,
+};
+
+enum si476x_icon_config {
+	SI476X_ICON_NOOP	= 0,
+	SI476X_ICON_TRISTATE	= 1,
+	SI476X_ICON_I2S		= 10,
+	SI476X_ICON_IC_LINK	= 30,
+};
+
+enum si476x_icop_config {
+	SI476X_ICOP_NOOP	= 0,
+	SI476X_ICOP_TRISTATE	= 1,
+	SI476X_ICOP_I2S		= 10,
+	SI476X_ICOP_IC_LINK	= 30,
+};
+
+
+enum si476x_lrout_config {
+	SI476X_LROUT_NOOP	= 0,
+	SI476X_LROUT_TRISTATE	= 1,
+	SI476X_LROUT_AUDIO	= 2,
+	SI476X_LROUT_MPX	= 3,
+};
+
+
+enum si476x_intb_config {
+	SI476X_INTB_NOOP     = 0,
+	SI476X_INTB_TRISTATE = 1,
+	SI476X_INTB_DAUDIO   = 10,
+	SI476X_INTB_IRQ      = 40,
+};
+
+enum si476x_a1_config {
+	SI476X_A1_NOOP     = 0,
+	SI476X_A1_TRISTATE = 1,
+	SI476X_A1_IRQ      = 40,
+};
+
+enum si476x_part_revisions {
+	SI476X_REVISION_A10 = 0,
+	SI476X_REVISION_A20 = 1,
+	SI476X_REVISION_A30 = 2,
+};
+
+struct si476x_pinmux {
+	enum si476x_dclk_config  dclk;
+	enum si476x_dfs_config   dfs;
+	enum si476x_dout_config  dout;
+	enum si476x_xout_config  xout;
+
+	enum si476x_iqclk_config iqclk;
+	enum si476x_iqfs_config  iqfs;
+	enum si476x_iout_config  iout;
+	enum si476x_qout_config  qout;
+
+	enum si476x_icin_config  icin;
+	enum si476x_icip_config  icip;
+	enum si476x_icon_config  icon;
+	enum si476x_icop_config  icop;
+
+	enum si476x_lrout_config lrout;
+
+	enum si476x_intb_config  intb;
+	enum si476x_a1_config    a1;
+};
+
+/**
+ * enum si476x_phase_diversity_mode - possbile phase diversity modes
+ * for SI4764/5/6/7 chips.
+ *
+ * @SI476X_PHDIV_DISABLED:		Phase diversity feature is
+ *					disabled.
+ * @SI476X_PHDIV_PRIMARY_COMBINING:	Tuner works as a primary tuner
+ *					in combination with a
+ *					secondary one.
+ * @SI476X_PHDIV_PRIMARY_ANTENNA:	Tuner works as a primary tuner
+ *					using only its own antenna.
+ * @SI476X_PHDIV_SECONDARY_ANTENNA:	Tuner works as a primary tuner
+ *					usning seconary tuner's antenna.
+ * @SI476X_PHDIV_SECONDARY_COMBINING:	Tuner works as a secondary
+ *					tuner in combination with the
+ *					primary one.
+ */
+enum si476x_phase_diversity_mode {
+	SI476X_PHDIV_DISABLED			= 0,
+	SI476X_PHDIV_PRIMARY_COMBINING		= 1,
+	SI476X_PHDIV_PRIMARY_ANTENNA		= 2,
+	SI476X_PHDIV_SECONDARY_ANTENNA		= 3,
+	SI476X_PHDIV_SECONDARY_COMBINING	= 5,
+};
+
+enum si476x_ibias6x {
+	SI476X_IBIAS6X_OTHER			= 0,
+	SI476X_IBIAS6X_RCVR1_NON_4MHZ_CLK	= 1,
+};
+
+enum si476x_xstart {
+	SI476X_XSTART_MULTIPLE_TUNER	= 0x11,
+	SI476X_XSTART_NORMAL		= 0x77,
+};
+
+enum si476x_freq {
+	SI476X_FREQ_4_MHZ		= 0,
+	SI476X_FREQ_37P209375_MHZ	= 1,
+	SI476X_FREQ_36P4_MHZ		= 2,
+	SI476X_FREQ_37P8_MHZ		=  3,
+};
+
+enum si476x_xmode {
+	SI476X_XMODE_CRYSTAL_RCVR1	= 1,
+	SI476X_XMODE_EXT_CLOCK		= 2,
+	SI476X_XMODE_CRYSTAL_RCVR2_3	= 3,
+};
+
+enum si476x_xbiashc {
+	SI476X_XBIASHC_SINGLE_RECEIVER = 0,
+	SI476X_XBIASHC_MULTIPLE_RECEIVER = 1,
+};
+
+enum si476x_xbias {
+	SI476X_XBIAS_RCVR2_3	= 0,
+	SI476X_XBIAS_4MHZ_RCVR1 = 3,
+	SI476X_XBIAS_RCVR1	= 7,
+};
+
+enum si476x_func {
+	SI476X_FUNC_BOOTLOADER	= 0,
+	SI476X_FUNC_FM_RECEIVER = 1,
+	SI476X_FUNC_AM_RECEIVER = 2,
+	SI476X_FUNC_WB_RECEIVER = 3,
+};
+
+
+/**
+ * @xcload: Selects the amount of additional on-chip capacitance to
+ *          be connected between XTAL1 and gnd and between XTAL2 and
+ *          GND. One half of the capacitance value shown here is the
+ *          additional load capacitance presented to the xtal. The
+ *          minimum step size is 0.277 pF. Recommended value is 0x28
+ *          but it will be layout dependent. Range is 0–0x3F i.e.
+ *          (0–16.33 pF)
+ * @ctsien: enable CTSINT(interrupt request when CTS condition
+ *          arises) when set
+ * @intsel: when set A1 pin becomes the interrupt pin; otherwise,
+ *          INTB is the interrupt pin
+ * @func:   selects the boot function of the device. I.e.
+ *          SI476X_BOOTLOADER  - Boot loader
+ *          SI476X_FM_RECEIVER - FM receiver
+ *          SI476X_AM_RECEIVER - AM receiver
+ *          SI476X_WB_RECEIVER - Weatherband receiver
+ * @freq:   oscillator's crystal frequency:
+ *          SI476X_XTAL_37P209375_MHZ - 37.209375 Mhz
+ *          SI476X_XTAL_36P4_MHZ      - 36.4 Mhz
+ *          SI476X_XTAL_37P8_MHZ      - 37.8 Mhz
+ */
+struct si476x_power_up_args {
+	enum si476x_ibias6x ibias6x;
+	enum si476x_xstart  xstart;
+	u8   xcload;
+	bool fastboot;
+	enum si476x_xbiashc xbiashc;
+	enum si476x_xbias   xbias;
+	enum si476x_func    func;
+	enum si476x_freq    freq;
+	enum si476x_xmode   xmode;
+};
+
+
+enum si476x_ctrl_id {
+	SI476X_CID_RSSI_THRESHOLD	= (V4L2_CID_USER_BASE | 0x1001),
+	SI476X_CID_SNR_THRESHOLD	= (V4L2_CID_USER_BASE | 0x1002),
+	SI476X_CID_MAX_TUNE_ERROR	= (V4L2_CID_USER_BASE | 0x1003),
+	SI476X_CID_RDS_RECEPTION	= (V4L2_CID_USER_BASE | 0x1004),
+	SI476X_CID_DEEMPHASIS		= (V4L2_CID_USER_BASE | 0x1005),
+	SI476X_CID_HARMONICS_COUNT	= (V4L2_CID_USER_BASE | 0x1006),
+	SI476X_CID_DIVERSITY_MODE	= (V4L2_CID_USER_BASE | 0x1007),
+	SI476X_CID_INTERCHIP_LINK	= (V4L2_CID_USER_BASE | 0x1008),
+};
+
+/*
+ * Platform dependent definition
+ */
+struct si476x_platform_data {
+	int gpio_reset; /* < 0 if not used */
+
+	struct si476x_power_up_args power_up_parameters;
+	enum si476x_phase_diversity_mode diversity_mode;
+
+	struct si476x_pinmux pinmux;
+};
+
+/**
+ * struct si476x_rsq_status - structure containing received signal
+ * quality
+ * @multhint:   Multipath Detect High.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_MULTIPATH_HIGH_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_MULTIPATH_HIGH_THRESHOLD
+ * @multlint:   Multipath Detect Low.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_MULTIPATH_LOW_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_MULTIPATH_LOW_THRESHOLD
+ * @snrhint:    SNR Detect High.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_SNR_HIGH_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_SNR_HIGH_THRESHOLD
+ * @snrlint:    SNR Detect Low.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_SNR_LOW_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_SNR_LOW_THRESHOLD
+ * @rssihint:   RSSI Detect High.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_RSSI_HIGH_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_RSSI_HIGH_THRESHOLD
+ * @rssilint:   RSSI Detect Low.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_RSSI_LOW_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_RSSI_LOW_THRESHOLD
+ * @bltf:       Band Limit.
+ *              Set if seek command hits the band limit or wrapped to
+ *              the original frequency.
+ * @snr_ready:  SNR measurement in progress.
+ * @rssiready:  RSSI measurement in progress.
+ * @afcrl:      Set if FREQOFF >= MAX_TUNE_ERROR
+ * @valid:      Set if the channel is valid
+ *               rssi < FM_VALID_RSSI_THRESHOLD
+ *               snr  < FM_VALID_SNR_THRESHOLD
+ *               tune_error < FM_VALID_MAX_TUNE_ERROR
+ * @readfreq:   Current tuned frequency.
+ * @freqoff:    Signed frequency offset.
+ * @rssi:       Received Signal Strength Indicator(dBuV).
+ * @snr:        RF SNR Indicator(dB).
+ * @lassi:
+ * @hassi:      Low/High side Adjacent(100 kHz) Channel Strength Indicator
+ * @mult:       Multipath indicator
+ * @dev:        Who knows? But values may vary.
+ * @readantcap: Antenna tuning capacity value.
+ * @assi:       Adjacent Channel(+/- 200kHz) Strength Indicator
+ * @usn:        Ultrasonic Noise Inticator in -DBFS
+ */
+struct si476x_rsq_status_report {
+	__u8 multhint, multlint;
+	__u8 snrhint,  snrlint;
+	__u8 rssihint, rssilint;
+	__u8 bltf;
+	__u8 snr_ready;
+	__u8 rssiready;
+	__u8 injside;
+	__u8 afcrl;
+	__u8 valid;
+
+	__u16 readfreq;
+	__s8  freqoff;
+	__s8  rssi;
+	__s8  snr;
+	__s8  issi;
+	__s8  lassi, hassi;
+	__s8  mult;
+	__u8  dev;
+	__u16 readantcap;
+	__s8  assi;
+	__s8  usn;
+
+	__u8 pilotdev;
+	__u8 rdsdev;
+	__u8 assidev;
+	__u8 strongdev;
+	__u16 rdspi;
+} __attribute__((packed));
+
+/**
+ * si476x_acf_status_report - ACF report results
+ *
+ * @blend_int: If set, indicates that stereo separation has crossed
+ * below the blend threshold as set by FM_ACF_BLEND_THRESHOLD
+ * @hblend_int: If set, indicates that HiBlend cutoff frequency is
+ * lower than threshold as set by FM_ACF_HBLEND_THRESHOLD
+ * @hicut_int:  If set, indicates that HiCut cutoff frequency is lower
+ * than the threshold set by ACF_
+
+ */
+struct si476x_acf_status_report {
+	__u8 blend_int;
+	__u8 hblend_int;
+	__u8 hicut_int;
+	__u8 chbw_int;
+	__u8 softmute_int;
+	__u8 smute;
+	__u8 smattn;
+	__u8 chbw;
+	__u8 hicut;
+	__u8 hiblend;
+	__u8 pilot;
+	__u8 stblend;
+} __attribute__((packed));
+
+enum si476x_fmagc {
+	SI476X_FMAGC_10K_OHM	= 0,
+	SI476X_FMAGC_800_OHM	= 1,
+	SI476X_FMAGC_400_OHM	= 2,
+	SI476X_FMAGC_200_OHM	= 4,
+	SI476X_FMAGC_100_OHM	= 8,
+	SI476X_FMAGC_50_OHM	= 16,
+	SI476X_FMAGC_25_OHM	= 32,
+	SI476X_FMAGC_12P5_OHM	= 64,
+	SI476X_FMAGC_6P25_OHM	= 128,
+};
+
+struct si476x_agc_status_report {
+	__u8 mxhi;
+	__u8 mxlo;
+	__u8 lnahi;
+	__u8 lnalo;
+	__u8 fmagc1;
+	__u8 fmagc2;
+	__u8 pgagain;
+	__u8 fmwblang;
+} __attribute__((packed));
+
+struct si476x_rds_blockcount_report {
+	__u16 expected;
+	__u16 received;
+	__u16 uncorrectable;
+} __attribute__((packed));
+
+#endif /* SI476X_H*/
-- 
1.7.10.4

