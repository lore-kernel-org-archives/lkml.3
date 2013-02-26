Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783Ab3BZQDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:03:24 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:52246 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759744Ab3BZQDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:03:22 -0500
MIME-Version: 1.0
In-Reply-To: <201302260925.48450.hverkuil@xs4all.nl>
References: <1361860734-21666-1-git-send-email-andrew.smirnov@gmail.com>
	<1361860734-21666-9-git-send-email-andrew.smirnov@gmail.com>
	<201302260925.48450.hverkuil@xs4all.nl>
Date: Tue, 26 Feb 2013 08:03:20 -0800
Message-ID: <CAHQ1cqGSOHMbgz_n+47wHar0sKOL4iBeEJOR41KqDKZoFXYWfQ@mail.gmail.com>
Subject: Re: [PATCH v5 8/8] v4l2: Add a V4L2 driver for SI476X MFD
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@redhat.com, sameo@linux.intel.com, perex@perex.cz, tiwai@suse.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>

>> +
>> +enum phase_diversity_modes_idx {
>> +     SI476X_IDX_PHDIV_DISABLED,
>> +     SI476X_IDX_PHDIV_PRIMARY_COMBINING,
>> +     SI476X_IDX_PHDIV_PRIMARY_ANTENNA,
>> +     SI476X_IDX_PHDIV_SECONDARY_ANTENNA,
>> +     SI476X_IDX_PHDIV_SECONDARY_COMBINING,
>> +};
>> +
>> +static const char * const phase_diversity_modes[] = {
>> +     [SI476X_IDX_PHDIV_DISABLED]             = "Disabled",
>
> Question: what does it mean if this is disabled? That none of the antennas
> are working? That would imply that you get no reception at all.

I am not an expert on these chips and, unfortunately, never had anyone
from SiLabs  to talk to all the time I worked on this driver. But from
my understanding from working with the chip/reading of the datasheet,
when working in diversity mode two chips are connected to two
different antennas and interconnected between each other so that
secondary tuner can pass semi-processed signal to the primary one. So
to the best of my understanding those sttings cause the following mode
of operation:

* Disabled -- no link is established, tuner acts no differently than
if other tuner didn't exist.
* Primary combinig -- link is established, tuner is configured to be a
primary tuner using signal from both itself and a secondary one
* Primary antenna -- link is established, tuner is configured to be a
primary tuner using signal from its own antenna
* Secondary antenna -- link is established, tuner is configured to be
a primary tuner using signal from secondary tuner's antenna
* Secondary -- link is established, tuner is configured to be a
secondary tuner feeding the signal from its antenna to the primary one

It seems that "Disabled" setting is the setting one would want to use
if the chip is used in a non diversity-mode enabled system.

>
>> +     [SI476X_IDX_PHDIV_PRIMARY_COMBINING]    = "Primary W/Secondary",
>
> Just write in full: "Primary with Secondary"
>
>> +     [SI476X_IDX_PHDIV_PRIMARY_ANTENNA]      = "Primary(Primary Antenna)",
>
> This becomes: "Primary Antenna"
>
>> +     [SI476X_IDX_PHDIV_SECONDARY_ANTENNA]    = "Primary(Seconadary Antenna)",
>
> "Secondary Antenna"
>
>> +     [SI476X_IDX_PHDIV_SECONDARY_COMBINING]  = "Secondary W/Primary",
>
> "Secondary with Primary"
>
>> +};
>> +
>> +static inline enum phase_diversity_modes_idx
>> +si476x_phase_diversity_mode_to_idx(enum si476x_phase_diversity_mode mode)
>> +{
>> +     switch (mode) {
>> +     default:                /* FALLTHROUGH */
>> +     case SI476X_PHDIV_DISABLED:
>> +             return SI476X_IDX_PHDIV_DISABLED;
>> +     case SI476X_PHDIV_PRIMARY_COMBINING:
>> +             return SI476X_IDX_PHDIV_PRIMARY_COMBINING;
>> +     case SI476X_PHDIV_PRIMARY_ANTENNA:
>> +             return SI476X_IDX_PHDIV_PRIMARY_ANTENNA;
>> +     case SI476X_PHDIV_SECONDARY_ANTENNA:
>> +             return SI476X_IDX_PHDIV_SECONDARY_ANTENNA;
>> +     case SI476X_PHDIV_SECONDARY_COMBINING:
>> +             return SI476X_IDX_PHDIV_SECONDARY_COMBINING;
>> +     }
>> +}
>> +
>> +static inline enum si476x_phase_diversity_mode
>> +si476x_phase_diversity_idx_to_mode(enum phase_diversity_modes_idx idx)
>> +{
>> +     static const int idx_to_value[] = {
>> +             [SI476X_IDX_PHDIV_DISABLED]             = SI476X_PHDIV_DISABLED,
>> +             [SI476X_IDX_PHDIV_PRIMARY_COMBINING]    = SI476X_PHDIV_PRIMARY_COMBINING,
>> +             [SI476X_IDX_PHDIV_PRIMARY_ANTENNA]      = SI476X_PHDIV_PRIMARY_ANTENNA,
>> +             [SI476X_IDX_PHDIV_SECONDARY_ANTENNA]    = SI476X_PHDIV_SECONDARY_ANTENNA,
>> +             [SI476X_IDX_PHDIV_SECONDARY_COMBINING]  = SI476X_PHDIV_SECONDARY_COMBINING,
>> +     };
>> +
>> +     return idx_to_value[idx];
>> +}
>> +
>> +static const struct v4l2_ctrl_ops si476x_ctrl_ops = {
>> +     .g_volatile_ctrl        = si476x_radio_g_volatile_ctrl,
>> +     .s_ctrl                 = si476x_radio_s_ctrl,
>> +};
>> +
>> +
>> +enum si476x_ctrl_idx {
>> +     SI476X_IDX_RSSI_THRESHOLD,
>> +     SI476X_IDX_SNR_THRESHOLD,
>> +     SI476X_IDX_MAX_TUNE_ERROR,
>> +     SI476X_IDX_HARMONICS_COUNT,
>> +     SI476X_IDX_DIVERSITY_MODE,
>> +     SI476X_IDX_INTERCHIP_LINK,
>> +};
>> +static struct v4l2_ctrl_config si476x_ctrls[] = {
>> +
>> +     /**
>> +      * SI476X during its station seeking(or tuning) process uses several
>> +      * parameters to detrmine if "the station" is valid:
>> +      *
>> +      *      - Signal's SNR(in dBuV) must be lower than
>> +      *      #V4L2_CID_SI476X_SNR_THRESHOLD
>> +      *      - Signal's RSSI(in dBuV) must be greater than
>> +      *      #V4L2_CID_SI476X_RSSI_THRESHOLD
>> +      *      - Signal's frequency deviation(in units of 2ppm) must not be
>> +      *      more than #V4L2_CID_SI476X_MAX_TUNE_ERROR
>> +      */
>> +     [SI476X_IDX_RSSI_THRESHOLD] = {
>> +             .ops    = &si476x_ctrl_ops,
>> +             .id     = V4L2_CID_SI476X_RSSI_THRESHOLD,
>> +             .name   = "Valid RSSI Threshold",
>> +             .type   = V4L2_CTRL_TYPE_INTEGER,
>> +             .min    = -128,
>> +             .max    = 127,
>> +             .step   = 1,
>> +     },
>> +     [SI476X_IDX_SNR_THRESHOLD] = {
>> +             .ops    = &si476x_ctrl_ops,
>> +             .id     = V4L2_CID_SI476X_SNR_THRESHOLD,
>> +             .type   = V4L2_CTRL_TYPE_INTEGER,
>> +             .name   = "Valid SNR Threshold",
>> +             .min    = -128,
>> +             .max    = 127,
>> +             .step   = 1,
>> +     },
>> +     [SI476X_IDX_MAX_TUNE_ERROR] = {
>> +             .ops    = &si476x_ctrl_ops,
>> +             .id     = V4L2_CID_SI476X_MAX_TUNE_ERROR,
>> +             .type   = V4L2_CTRL_TYPE_INTEGER,
>> +             .name   = "Max Tune Errors",
>> +             .min    = 0,
>> +             .max    = 126 * 2,
>> +             .step   = 2,
>> +     },
>> +
>> +     /**
>> +      * #V4L2_CID_SI476X_HARMONICS_COUNT -- number of harmonics
>> +      * built-in power-line noise supression filter is to reject
>> +      * during AM-mode operation.
>> +      */
>> +     [SI476X_IDX_HARMONICS_COUNT] = {
>> +             .ops    = &si476x_ctrl_ops,
>> +             .id     = V4L2_CID_SI476X_HARMONICS_COUNT,
>> +             .type   = V4L2_CTRL_TYPE_INTEGER,
>> +
>> +             .name   = "Count Of Harmonics To Reject",
>
> Use lower case "of" and "to". Don't blame me, blame the style guides
> w.r.t. titles :-)
>
>> +             .min    = 0,
>> +             .max    = 20,
>> +             .step   = 1,
>> +     },
>> +
>> +     /**
>> +      * #V4L2_CID_SI476X_DIVERSITY_MODE -- configuration which
>> +      * two tuners working in diversity mode are to work in.
>> +      *
>> +      *  - #SI476X_IDX_PHDIV_DISABLED diversity mode disabled
>> +      *  - #SI476X_IDX_PHDIV_PRIMARY_COMBINING diversity mode is
>> +      *  on, primary tuner's antenna is the main one.
>> +      *  - #SI476X_IDX_PHDIV_PRIMARY_ANTENNA diversity mode is
>> +      *  off, primary tuner's antenna is the main one.
>> +      *  - #SI476X_IDX_PHDIV_SECONDARY_ANTENNA diversity mode is
>> +      *  off, secondary tuner's antenna is the main one.
>> +      *  - #SI476X_IDX_PHDIV_SECONDARY_COMBINING diversity mode is
>> +      *  on, secondary tuner's antenna is the main one.
>> +      */
>> +     [SI476X_IDX_DIVERSITY_MODE] = {
>> +             .ops    = &si476x_ctrl_ops,
>> +             .id     = V4L2_CID_SI476X_DIVERSITY_MODE,
>> +             .type   = V4L2_CTRL_TYPE_MENU,
>> +             .name   = "Phase Diversity Mode",
>> +             .qmenu  = phase_diversity_modes,
>> +             .min    = 0,
>> +             .max    = ARRAY_SIZE(phase_diversity_modes) - 1,
>> +     },
>> +
>> +     /**
>> +      * #V4L2_CID_SI476X_INTERCHIP_LINK -- inter-chip link in
>> +      * diversity mode indicator. Allows user to detrmine if two
>
> Typo: 'determine'
>
>> +      * chips working in diversity mode have established a link
>> +      * between each other and if the system as awhole uses
>
> "a whole"
>
>> +      * signals from both antennas to receive FM radio.
>> +      */
>> +     [SI476X_IDX_INTERCHIP_LINK] = {
>> +             .ops    = &si476x_ctrl_ops,
>> +             .id     = V4L2_CID_SI476X_INTERCHIP_LINK,
>> +             .type   = V4L2_CTRL_TYPE_BOOLEAN,
>> +             .flags  = V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_VOLATILE,
>> +             .name   = "Inter-Chip Link",
>> +             .min    = 0,
>> +             .max    = 1,
>> +             .step   = 1,
>> +     },
>> +};
>
> <snip>
>
> Regards,
>
>         Hans
