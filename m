Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab3BZI0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 03:26:46 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2987 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab3BZI0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 03:26:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: Re: [PATCH v5 8/8] v4l2: Add a V4L2 driver for SI476X MFD
Date: Tue, 26 Feb 2013 09:25:48 +0100
User-Agent: KMail/1.13.7 (Linux/3.8.0-rc3-tschai; KDE/4.8.4; x86_64; ; )
Cc: mchehab@redhat.com, sameo@linux.intel.com, perex@perex.cz, tiwai@suse.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1361860734-21666-1-git-send-email-andrew.smirnov@gmail.com> <1361860734-21666-9-git-send-email-andrew.smirnov@gmail.com>
In-Reply-To: <1361860734-21666-9-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302260925.48450.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue February 26 2013 07:38:54 Andrey Smirnov wrote:
> From: Andrey Smirnov <andreysm@charmander.(none)>
> 
> This commit adds a driver that exposes all the radio related
> functionality of the Si476x series of chips via the V4L2 subsystem.
> 
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> ---
>  Documentation/video4linux/si476x.txt |  187 ++++
>  drivers/media/radio/Kconfig          |   17 +
>  drivers/media/radio/Makefile         |    1 +
>  drivers/media/radio/radio-si476x.c   | 1581 ++++++++++++++++++++++++++++++++++
>  include/media/si476x.h               |  426 +++++++++
>  5 files changed, 2212 insertions(+)
>  create mode 100644 Documentation/video4linux/si476x.txt
>  create mode 100644 drivers/media/radio/radio-si476x.c
>  create mode 100644 include/media/si476x.h
> 

<snip>

> diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
> new file mode 100644
> index 0000000..568cd82
> --- /dev/null
> +++ b/drivers/media/radio/radio-si476x.c
> @@ -0,0 +1,1581 @@
> +/*
> + * drivers/media/radio/radio-si476x.c -- V4L2 driver for SI476X chips
> + *
> + * Copyright (C) 2012 Innovative Converged Devices(ICD)
> + * Copyright (C) 2013 Andrey Smirnov
> + *
> + * Author: Andrey Smirnov <andrew.smirnov@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/slab.h>
> +#include <linux/atomic.h>
> +#include <linux/videodev2.h>
> +#include <linux/mutex.h>
> +#include <linux/debugfs.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-device.h>
> +
> +#include <media/si476x.h>
> +#include <linux/mfd/si476x-core.h>
> +
> +#define FM_FREQ_RANGE_LOW   64000000
> +#define FM_FREQ_RANGE_HIGH 108000000
> +
> +#define AM_FREQ_RANGE_LOW    520000
> +#define AM_FREQ_RANGE_HIGH 30000000
> +
> +#define PWRLINEFLTR (1 << 8)
> +
> +#define FREQ_MUL (10000000 / 625)
> +
> +#define SI476X_PHDIV_STATUS_LINK_LOCKED(status) (0b10000000 & (status))
> +
> +#define DRIVER_NAME "si476x-radio"
> +#define DRIVER_CARD "SI476x AM/FM Receiver"
> +
> +enum si476x_freq_bands {
> +	SI476X_BAND_FM,
> +	SI476X_BAND_AM,
> +};
> +
> +static const struct v4l2_frequency_band si476x_bands[] = {
> +	[SI476X_BAND_FM] = {
> +		.type		= V4L2_TUNER_RADIO,
> +		.index		= SI476X_BAND_FM,
> +		.capability	= V4L2_TUNER_CAP_LOW
> +		| V4L2_TUNER_CAP_STEREO
> +		| V4L2_TUNER_CAP_RDS
> +		| V4L2_TUNER_CAP_RDS_BLOCK_IO
> +		| V4L2_TUNER_CAP_FREQ_BANDS,
> +		.rangelow	=  64 * FREQ_MUL,
> +		.rangehigh	= 108 * FREQ_MUL,
> +		.modulation	= V4L2_BAND_MODULATION_FM,
> +	},
> +	[SI476X_BAND_AM] = {
> +		.type		= V4L2_TUNER_RADIO,
> +		.index		= SI476X_BAND_AM,
> +		.capability	= V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
> +		.rangelow	= 0.52 * FREQ_MUL,
> +		.rangehigh	= 30 * FREQ_MUL,
> +		.modulation	= V4L2_BAND_MODULATION_AM,
> +	},
> +};
> +
> +static inline bool si476x_radio_freq_is_inside_of_the_band(u32 freq, int band)
> +{
> +	return freq >= si476x_bands[band].rangelow &&
> +		freq <= si476x_bands[band].rangehigh;
> +}
> +
> +static inline bool si476x_radio_range_is_inside_of_the_band(u32 low, u32 high, int band)
> +{
> +	return low  >= si476x_bands[band].rangelow &&
> +		high <= si476x_bands[band].rangehigh;
> +}
> +
> +
> +
> +static int si476x_radio_s_ctrl(struct v4l2_ctrl *ctrl);
> +static int si476x_radio_g_volatile_ctrl(struct v4l2_ctrl *ctrl);
> +
> +static const char * const deemphasis[] = {
> +	"75 us",
> +	"50 us",
> +};

Obsolete array, can be removed.

> +
> +enum phase_diversity_modes_idx {
> +	SI476X_IDX_PHDIV_DISABLED,
> +	SI476X_IDX_PHDIV_PRIMARY_COMBINING,
> +	SI476X_IDX_PHDIV_PRIMARY_ANTENNA,
> +	SI476X_IDX_PHDIV_SECONDARY_ANTENNA,
> +	SI476X_IDX_PHDIV_SECONDARY_COMBINING,
> +};
> +
> +static const char * const phase_diversity_modes[] = {
> +	[SI476X_IDX_PHDIV_DISABLED]		= "Disabled",

Question: what does it mean if this is disabled? That none of the antennas
are working? That would imply that you get no reception at all.

> +	[SI476X_IDX_PHDIV_PRIMARY_COMBINING]	= "Primary W/Secondary",

Just write in full: "Primary with Secondary"

> +	[SI476X_IDX_PHDIV_PRIMARY_ANTENNA]	= "Primary(Primary Antenna)",

This becomes: "Primary Antenna"

> +	[SI476X_IDX_PHDIV_SECONDARY_ANTENNA]	= "Primary(Seconadary Antenna)",

"Secondary Antenna"

> +	[SI476X_IDX_PHDIV_SECONDARY_COMBINING]	= "Secondary W/Primary",

"Secondary with Primary"

> +};
> +
> +static inline enum phase_diversity_modes_idx
> +si476x_phase_diversity_mode_to_idx(enum si476x_phase_diversity_mode mode)
> +{
> +	switch (mode) {
> +	default:		/* FALLTHROUGH */
> +	case SI476X_PHDIV_DISABLED:
> +		return SI476X_IDX_PHDIV_DISABLED;
> +	case SI476X_PHDIV_PRIMARY_COMBINING:
> +		return SI476X_IDX_PHDIV_PRIMARY_COMBINING;
> +	case SI476X_PHDIV_PRIMARY_ANTENNA:
> +		return SI476X_IDX_PHDIV_PRIMARY_ANTENNA;
> +	case SI476X_PHDIV_SECONDARY_ANTENNA:
> +		return SI476X_IDX_PHDIV_SECONDARY_ANTENNA;
> +	case SI476X_PHDIV_SECONDARY_COMBINING:
> +		return SI476X_IDX_PHDIV_SECONDARY_COMBINING;
> +	}
> +}
> +
> +static inline enum si476x_phase_diversity_mode
> +si476x_phase_diversity_idx_to_mode(enum phase_diversity_modes_idx idx)
> +{
> +	static const int idx_to_value[] = {
> +		[SI476X_IDX_PHDIV_DISABLED]		= SI476X_PHDIV_DISABLED,
> +		[SI476X_IDX_PHDIV_PRIMARY_COMBINING]	= SI476X_PHDIV_PRIMARY_COMBINING,
> +		[SI476X_IDX_PHDIV_PRIMARY_ANTENNA]	= SI476X_PHDIV_PRIMARY_ANTENNA,
> +		[SI476X_IDX_PHDIV_SECONDARY_ANTENNA]	= SI476X_PHDIV_SECONDARY_ANTENNA,
> +		[SI476X_IDX_PHDIV_SECONDARY_COMBINING]	= SI476X_PHDIV_SECONDARY_COMBINING,
> +	};
> +
> +	return idx_to_value[idx];
> +}
> +
> +static const struct v4l2_ctrl_ops si476x_ctrl_ops = {
> +	.g_volatile_ctrl	= si476x_radio_g_volatile_ctrl,
> +	.s_ctrl			= si476x_radio_s_ctrl,
> +};
> +
> +
> +enum si476x_ctrl_idx {
> +	SI476X_IDX_RSSI_THRESHOLD,
> +	SI476X_IDX_SNR_THRESHOLD,
> +	SI476X_IDX_MAX_TUNE_ERROR,
> +	SI476X_IDX_HARMONICS_COUNT,
> +	SI476X_IDX_DIVERSITY_MODE,
> +	SI476X_IDX_INTERCHIP_LINK,
> +};
> +static struct v4l2_ctrl_config si476x_ctrls[] = {
> +
> +	/**
> +	 * SI476X during its station seeking(or tuning) process uses several
> +	 * parameters to detrmine if "the station" is valid:
> +	 *
> +	 *      - Signal's SNR(in dBuV) must be lower than
> +	 * 	#V4L2_CID_SI476X_SNR_THRESHOLD
> +	 *      - Signal's RSSI(in dBuV) must be greater than
> +	 *	#V4L2_CID_SI476X_RSSI_THRESHOLD
> +	 *	- Signal's frequency deviation(in units of 2ppm) must not be
> +	 *	more than #V4L2_CID_SI476X_MAX_TUNE_ERROR
> +	 */
> +	[SI476X_IDX_RSSI_THRESHOLD] = {
> +		.ops	= &si476x_ctrl_ops,
> +		.id	= V4L2_CID_SI476X_RSSI_THRESHOLD,
> +		.name	= "Valid RSSI Threshold",
> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> +		.min	= -128,
> +		.max	= 127,
> +		.step	= 1,
> +	},
> +	[SI476X_IDX_SNR_THRESHOLD] = {
> +		.ops	= &si476x_ctrl_ops,
> +		.id	= V4L2_CID_SI476X_SNR_THRESHOLD,
> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> +		.name	= "Valid SNR Threshold",
> +		.min	= -128,
> +		.max	= 127,
> +		.step	= 1,
> +	},
> +	[SI476X_IDX_MAX_TUNE_ERROR] = {
> +		.ops	= &si476x_ctrl_ops,
> +		.id	= V4L2_CID_SI476X_MAX_TUNE_ERROR,
> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> +		.name	= "Max Tune Errors",
> +		.min	= 0,
> +		.max	= 126 * 2,
> +		.step	= 2,
> +	},
> +
> +	/**
> +	 * #V4L2_CID_SI476X_HARMONICS_COUNT -- number of harmonics
> +	 * built-in power-line noise supression filter is to reject
> +	 * during AM-mode operation.
> +	 */
> +	[SI476X_IDX_HARMONICS_COUNT] = {
> +		.ops	= &si476x_ctrl_ops,
> +		.id	= V4L2_CID_SI476X_HARMONICS_COUNT,
> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> +
> +		.name	= "Count Of Harmonics To Reject",

Use lower case "of" and "to". Don't blame me, blame the style guides
w.r.t. titles :-)

> +		.min	= 0,
> +		.max	= 20,
> +		.step	= 1,
> +	},
> +
> +	/**
> +	 * #V4L2_CID_SI476X_DIVERSITY_MODE -- configuration which
> +	 * two tuners working in diversity mode are to work in.
> +	 *
> +	 *  - #SI476X_IDX_PHDIV_DISABLED diversity mode disabled 
> +	 *  - #SI476X_IDX_PHDIV_PRIMARY_COMBINING diversity mode is
> +	 *  on, primary tuner's antenna is the main one.
> +	 *  - #SI476X_IDX_PHDIV_PRIMARY_ANTENNA diversity mode is
> +	 *  off, primary tuner's antenna is the main one.
> +	 *  - #SI476X_IDX_PHDIV_SECONDARY_ANTENNA diversity mode is
> +	 *  off, secondary tuner's antenna is the main one.
> +	 *  - #SI476X_IDX_PHDIV_SECONDARY_COMBINING diversity mode is
> +	 *  on, secondary tuner's antenna is the main one.
> +	 */
> +	[SI476X_IDX_DIVERSITY_MODE] = {
> +		.ops	= &si476x_ctrl_ops,
> +		.id	= V4L2_CID_SI476X_DIVERSITY_MODE,
> +		.type	= V4L2_CTRL_TYPE_MENU,
> +		.name	= "Phase Diversity Mode",
> +		.qmenu	= phase_diversity_modes,
> +		.min	= 0,
> +		.max	= ARRAY_SIZE(phase_diversity_modes) - 1,
> +	},
> +
> +	/**
> +	 * #V4L2_CID_SI476X_INTERCHIP_LINK -- inter-chip link in
> +	 * diversity mode indicator. Allows user to detrmine if two

Typo: 'determine'

> +	 * chips working in diversity mode have established a link
> +	 * between each other and if the system as awhole uses

"a whole"

> +	 * signals from both antennas to receive FM radio.
> +	 */
> +	[SI476X_IDX_INTERCHIP_LINK] = {
> +		.ops	= &si476x_ctrl_ops,
> +		.id	= V4L2_CID_SI476X_INTERCHIP_LINK,
> +		.type	= V4L2_CTRL_TYPE_BOOLEAN,
> +		.flags  = V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_VOLATILE,
> +		.name	= "Inter-Chip Link",
> +		.min	= 0,
> +		.max	= 1,
> +		.step	= 1,
> +	},
> +};

<snip>

Regards,

	Hans
