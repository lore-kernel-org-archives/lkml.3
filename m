Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaJ2GTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:19:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:52330 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaJ2GTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:19:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,808,1406617200"; 
   d="scan'208";a="627435368"
Date: Wed, 29 Oct 2014 11:08:42 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [alsa-devel] [PATCH 07/11] drivers: char: axd: add cmd
 interfce helper functions
Message-ID: <20141029053842.GV28745@intel.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
 <1414495589-8579-8-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414495589-8579-8-git-send-email-qais.yousef@imgtec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 11:26:25AM +0000, Qais Yousef wrote:
> AXD has a lot of registers. These files contain helper functions to
> access these registers in a readable way.
> 
> Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <alsa-devel@alsa-project.org>
> ---
>  drivers/char/axd/axd_cmds_codec_internal.c |   58 +
>  drivers/char/axd/axd_cmds_codec_internal.h |   28 +
>  drivers/char/axd/axd_cmds_config.c         | 1194 ++++++++++
>  drivers/char/axd/axd_cmds_decoder_config.c | 1806 ++++++++++++++++
>  drivers/char/axd/axd_cmds_encoder_config.c |  519 +++++
>  drivers/char/axd/axd_cmds_info.c           | 1409 ++++++++++++
>  drivers/char/axd/axd_cmds_internal.c       | 3237 ++++++++++++++++++++++++++++
>  drivers/char/axd/axd_cmds_internal.h       |  306 +++
>  8 files changed, 8557 insertions(+)
>  create mode 100644 drivers/char/axd/axd_cmds_codec_internal.c
>  create mode 100644 drivers/char/axd/axd_cmds_codec_internal.h
>  create mode 100644 drivers/char/axd/axd_cmds_config.c
>  create mode 100644 drivers/char/axd/axd_cmds_decoder_config.c
>  create mode 100644 drivers/char/axd/axd_cmds_encoder_config.c
>  create mode 100644 drivers/char/axd/axd_cmds_info.c
>  create mode 100644 drivers/char/axd/axd_cmds_internal.c
>  create mode 100644 drivers/char/axd/axd_cmds_internal.h
Such a huge amount of code, which by a quick glance of this file should
really by ASoC controls and this whole code will vanish. Ah yes some code
for decder will remain but then most should still go away if you use the
framework

-- 
~Vinod

> 
> diff --git a/drivers/char/axd/axd_cmds_codec_internal.c b/drivers/char/axd/axd_cmds_codec_internal.c
> new file mode 100644
> index 000000000000..ba3ed9453faa
> --- /dev/null
> +++ b/drivers/char/axd/axd_cmds_codec_internal.c
> @@ -0,0 +1,58 @@
> +/*
> + * Copyright (C) 2011-2014 Imagination Technologies Ltd.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * Common functionality required by the codec config files.
> + */
> +#include "axd_cmds.h"
> +#include "axd_cmds_codec_internal.h"
> +
> +void str_append(char *dest, const char *src)
> +{
> +	int len = strlen(dest);
> +
> +	dest += len;
> +	strcpy(dest, src);
> +}
> +
> +void print_timeout_msg(char *config)
> +{
> +	strcpy(config, "Read Timeout\n\0");
> +}
> +
> +/* Common decoder/encoder option parse functions */
> +
> +void parse_pcm_samplerate(unsigned int samplerate, char *config)
> +{
> +	sprintf(config, "samplerate = %u\n", samplerate);
> +}
> +void parse_pcm_channels(unsigned int channels, char *config)
> +{
> +	sprintf(config, "channels = %u\n", channels);
> +}
> +void parse_pcm_bitspersample(unsigned int bitspersample, char *config)
> +{
> +	sprintf(config, "bitspersample = %u\n", bitspersample);
> +}
> +void parse_pcm_justification(unsigned int justification, char *config)
> +{
> +#define PCM_JUSTIFICATION_LEFT_STR	"Left"
> +#define PCM_JUSTIFICATION_RIGHT_STR	"Right"
> +	const char *str;
> +
> +	switch (justification) {
> +	case 0:
> +		str = PCM_JUSTIFICATION_LEFT_STR;
> +		break;
> +	case 1:
> +		str = PCM_JUSTIFICATION_RIGHT_STR;
> +		break;
> +	default:
> +		return;
> +	}
> +	sprintf(config, "justification = %s\n", str);
> +}
> diff --git a/drivers/char/axd/axd_cmds_codec_internal.h b/drivers/char/axd/axd_cmds_codec_internal.h
> new file mode 100644
> index 000000000000..4ade17c210de
> --- /dev/null
> +++ b/drivers/char/axd/axd_cmds_codec_internal.h
> @@ -0,0 +1,28 @@
> +/*
> + * Copyright (C) 2011-2014 Imagination Technologies Ltd.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * Common functionality required by the codec config files.
> + */
> +#ifndef AXD_CMDS_CODEC_INTERNAL_H_
> +#define AXD_CMDS_CODEC_INTERNAL_H_
> +
> +void str_append(char *dest, const char *src);
> +
> +void print_timeout_msg(char *config);
> +
> +/* Common option parse functions */
> +#define PCM_SAMPLERATE_PARAM		"samplerate"
> +#define PCM_CHANNELS_PARAM		"channels"
> +#define PCM_BITSPERSAMPLE_PARAM		"bitspersample"
> +#define PCM_JUSTIFICATION_PARAM		"justification"
> +void parse_pcm_samplerate(unsigned int samplerate, char *config);
> +void parse_pcm_channels(unsigned int channels, char *config);
> +void parse_pcm_bitspersample(unsigned int bitspersample, char *config);
> +void parse_pcm_justification(unsigned int justification, char *config);
> +
> +#endif
> diff --git a/drivers/char/axd/axd_cmds_config.c b/drivers/char/axd/axd_cmds_config.c
> new file mode 100644
> index 000000000000..2d9e470e225f
> --- /dev/null
> +++ b/drivers/char/axd/axd_cmds_config.c
> @@ -0,0 +1,1194 @@
> +/*
> + * Copyright (C) 2011-2014 Imagination Technologies Ltd.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * AXD Commands API - Configuration functions.
> + */
> +#include "axd_cmds.h"
> +#include "axd_cmds_internal.h"
> +
> +
> +/*
> + * Enable/Disable Mixer EQ.
> + * @pipe: pipe number.
> + * @enable:
> + *	Enable	= !0
> + *	Disable	= 0
> + */
> +void axd_cmd_mixer_set_eqenabled(struct axd_cmd *cmd, unsigned int pipe,
> +								int enable)
> +{
> +	unsigned int reg = AXD_REG_EQ_CTRL_GAIN;
> +	unsigned int control;
> +
> +	if (axd_read_reg(cmd, reg, &control))
> +		return;
> +
> +	if (enable)
> +		control |= AXD_EQCTRL_ENABLE_BITS;
> +	else
> +		control &= ~AXD_EQCTRL_ENABLE_BITS;
> +	axd_write_reg(cmd, reg, control);
> +}
> +
> +/*
> + * Set the Master gain of the EQ of the Mixer
> + * @pipe: pipe number.
> + * @gain: 0-99 gain value
> + */
> +void axd_cmd_mixer_set_eqmastergain(struct axd_cmd *cmd, unsigned int pipe,
> +								int gain)
> +{
> +	unsigned int reg = AXD_REG_EQ_CTRL_GAIN;
> +	unsigned int control;
> +
> +	if (unlikely(gain > 99 || gain < 0))
> +		return;
> +
> +	if (axd_read_reg(cmd, reg, &control))
> +		return;
> +
> +	gain = (gain << AXD_EQCTRL_GAIN_SHIFT) & AXD_EQCTRL_GAIN_BITS;
> +	control &= ~AXD_EQCTRL_GAIN_BITS;
> +	control |= gain;
> +	axd_write_reg(cmd, reg, control);
> +}
> +
> +/*
> + * Set the gain of the EQ Band0 of the Mixer
> + * @pipe: pipe number.
> + * @gain: Signed 8 bit 2'compliment gain value.
> + */
> +void axd_cmd_mixer_set_eqband0gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int gain)
> +{
> +	gain = (gain << AXD_EQBANDX_GAIN_SHIFT) & AXD_EQBANDX_GAIN_BITS;
> +	axd_write_reg(cmd, AXD_REG_EQ_BAND0, gain);
> +}
> +
> +/*
> + * Set the gain of the EQ Band1 of the Mixer
> + * @pipe: pipe number.
> + * @gain: Signed 8 bit 2'compliment gain value.
> + */
> +void axd_cmd_mixer_set_eqband1gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int gain)
> +{
> +	gain = (gain << AXD_EQBANDX_GAIN_SHIFT) & AXD_EQBANDX_GAIN_BITS;
> +	axd_write_reg(cmd, AXD_REG_EQ_BAND1, gain);
> +}
> +
> +/*
> + * Set the gain of the EQ Band2 of Mixer
> + * @pipe: pipe number.
> + * @gain: Signed 8 bit 2'compliment gain value.
> + */
> +void axd_cmd_mixer_set_eqband2gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int gain)
> +{
> +	gain = (gain << AXD_EQBANDX_GAIN_SHIFT) & AXD_EQBANDX_GAIN_BITS;
> +	axd_write_reg(cmd, AXD_REG_EQ_BAND2, gain);
> +}
> +
> +/*
> + * Set the gain of the EQ Band3 of the Mixer
> + * @pipe: pipe number.
> + * @gain: Signed 8 bit 2'compliment gain value.
> + */
> +void axd_cmd_mixer_set_eqband3gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int gain)
> +{
> +	gain = (gain << AXD_EQBANDX_GAIN_SHIFT) & AXD_EQBANDX_GAIN_BITS;
> +	axd_write_reg(cmd, AXD_REG_EQ_BAND3, gain);
> +}
> +
> +/*
> + * Set the gain of the EQ Band4 of the Mixer
> + * @pipe: pipe number.
> + * @gain: Signed 8 bit 2'compliment gain value.
> + */
> +void axd_cmd_mixer_set_eqband4gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int gain)
> +{
> +	gain = (gain << AXD_EQBANDX_GAIN_SHIFT) & AXD_EQBANDX_GAIN_BITS;
> +	axd_write_reg(cmd, AXD_REG_EQ_BAND4, gain);
> +}
> +
> +/*
> + * Select Mixer's Mux output
> + * @pipe: pipe number.
> + * @mux:
> + *	Mix	= 0
> + *	Input 0	= 1
> + *	Input 1	= 2
> + *	Input 2	= 3
> + *	Input 3	= 4
> + */
> +void axd_cmd_mixer_set_mux(struct axd_cmd *cmd, unsigned int pipe,
> +								int mux)
> +{
> +	unsigned int reg = axd_get_mixer_mux_reg(cmd, pipe);
> +
> +	if (unlikely(mux > 4 || mux < 0))
> +		return;
> +	axd_write_reg(cmd, reg, mux);
> +}
> +
> +/*
> + * Enable/Disable input.
> + * @pipe: pipe number.
> + * @enable:
> + *	Enable	= !0
> + *	Disable	= 0
> + */
> +int axd_cmd_input_set_enabled(struct axd_cmd *cmd, unsigned int pipe,
> +								int enable)
> +{
> +	unsigned int reg = axd_get_input_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	if (axd_read_reg(cmd, reg, &control))
> +		return -1;
> +
> +	if (enable)
> +		control |= AXD_INCTRL_ENABLE_BITS;
> +	else
> +		control &= ~AXD_INCTRL_ENABLE_BITS;
> +	if (axd_write_reg(cmd, reg, control))
> +		return -1;
> +	return 0;
> +}
> +
> +/*
> + * Set the source of the input pipe.
> + * @pipe: pipe number.
> + * @source:
> + *	Pipe	= 0
> + *	Aux	= 1
> + */
> +void axd_cmd_input_set_source(struct axd_cmd *cmd, unsigned int pipe,
> +								int source)
> +{
> +	unsigned int reg = axd_get_input_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg || source > 1 || source < 0))
> +		return;
> +	if (axd_read_reg(cmd, reg, &control))
> +		return;
> +	source = (source << AXD_INCTRL_SOURCE_SHIFT) & AXD_INCTRL_SOURCE_BITS;
> +	control &= ~AXD_INCTRL_SOURCE_BITS;
> +	control |= source;
> +	axd_write_reg(cmd, reg, control);
> +}
> +
> +/*
> + * Set the codec of the input pipe.
> + * @pipe: pipe number.
> + * @codec:
> + *	PCM Pass Through	= 0
> + *	MPEG (2/3)		= 1
> + *	Dolby AC3		= 2
> + *	AAC			= 3
> + *	Ogg Vorbis		= 4
> + *	FLAC			= 5
> + *	Cook			= 6
> + *	WMA			= 7
> + *	DDPlus			= 8
> + *	DTS			= 9   Unsupported
> + *	DTS-HD			= 10  Unsupported
> + *	ALAC			= 11
> + *	SBC			= 13
> + */
> +void axd_cmd_input_set_codec(struct axd_cmd *cmd, unsigned int pipe,
> +								int codec)
> +{
> +	unsigned int reg = axd_get_input_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg || codec > 13 || codec < 0 ||
> +						codec == 9 || codec == 10))
> +		return;
> +	if (axd_read_reg(cmd, reg, &control))
> +		return;
> +	codec = (codec << AXD_INCTRL_CODEC_SHIFT) & AXD_INCTRL_CODEC_BITS;
> +	control &= ~AXD_INCTRL_CODEC_BITS;
> +	control |= codec;
> +	axd_write_reg(cmd, reg, control);
> +}
> +
> +/*
> + * Set the gain of the input pipe.
> + * @pipe: pipe number.
> + * @gain: Signed 32 bit 2'compliment gain value.
> + *	Gain Cut or Boost in 0.25dB increment. ie: 4 = 1dB.
> + */
> +void axd_cmd_input_set_gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int gain)
> +{
> +	unsigned int reg = axd_get_input_gain_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return;
> +	axd_write_reg(cmd, reg, gain);
> +}
> +
> +/*
> + * Mute/Unmute the input pipe.
> + * @pipe: pipe number.
> + * @mute:  0	= OFF
> + *	  !0	= ON
> + */
> +void axd_cmd_input_set_mute(struct axd_cmd *cmd, unsigned int pipe,
> +								int mute)
> +{
> +	unsigned int reg = axd_get_input_mute_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return;
> +	axd_write_reg(cmd, reg, mute);
> +}
> +
> +/*
> + * Set the upmix of the input pipe.
> + * @pipe: pipe number.
> + * @upmix:
> + *	Pass through		= 0
> + *	Simple 5.1		= 1
> + *	Dolby Pro Logic 2	= 2
> + */
> +void axd_cmd_input_set_upmix(struct axd_cmd *cmd, unsigned int pipe,
> +								int upmix)
> +{
> +	unsigned int reg = axd_get_input_upmix_reg(cmd, pipe);
> +
> +	if (unlikely(!reg || upmix > 2 || upmix < 0))
> +		return;
> +	axd_write_reg(cmd, reg, upmix);
> +}
> +
> +/* Set the buffer occupancy value of @pipe. */
> +void axd_cmd_input_set_buffer_occupancy(struct axd_cmd *cmd, unsigned int pipe,
> +								unsigned int bo)
> +{
> +	unsigned int reg = axd_get_input_buffer_occupancy_reg(cmd, pipe);
> +
> +	axd_write_reg(cmd, reg, bo);
> +}
> +
> +/*
> + * Enable/Disable output.
> + * @pipe: pipe number.
> + * @enable:
> + *	Enable	= !0
> + *	Disable	= 0
> + */
> +int axd_cmd_output_set_enabled(struct axd_cmd *cmd, unsigned int pipe,
> +								int enable)
> +{
> +	unsigned int reg = axd_get_output_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return -1;
> +	if (axd_read_reg(cmd, reg, &control))
> +		return -1;
> +	if (enable)
> +		control |= AXD_OUTCTRL_ENABLE_BITS;
> +	else
> +		control &= ~AXD_OUTCTRL_ENABLE_BITS;
> +	if (axd_write_reg(cmd, reg, control))
> +		return -1;
> +	return 0;
> +}
> +
> +/*
> + * Set the codec of the output pipe.
> + * @pipe: pipe number.
> + * @codec:
> + *	PCM Pass Through	=  0
> + *	MPEG (2/3)		=  1 Unsupported
> + *	Dolby AC3		=  2 Unsupported
> + *	AAC			=  3 Unsupported
> + *	Ogg Vorbis		=  4 Unsupported
> + *	FLAC			=  5
> + *	Cook			=  6 Unsupported
> + *	WMA			=  7 Unsupported
> + *	DDPlus			=  8 Unsupported
> + *	DTS			=  9 Unsupported
> + *	DTS-HD			= 10 Unsupported
> + *	ALAC			= 11
> + *	SBC			= 13 Unsupported
> + */
> +void axd_cmd_output_set_codec(struct axd_cmd *cmd, unsigned int pipe,
> +								int codec)
> +{
> +	unsigned int reg = axd_get_output_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg || !(codec == 0 || codec == 5 || codec == 11)))
> +		return;
> +	if (axd_read_reg(cmd, reg, &control))
> +		return;
> +	codec = (codec << AXD_OUTCTRL_CODEC_SHIFT) & AXD_OUTCTRL_CODEC_BITS;
> +	control &= ~AXD_OUTCTRL_CODEC_BITS;
> +	control |= codec;
> +	axd_write_reg(cmd, reg, control);
> +}
> +
> +/*
> + * Set the sink of the output pipe.
> + * @pipe: pipe number.
> + * @source:
> + *	Pipe	= 0
> + */
> +void axd_cmd_output_set_sink(struct axd_cmd *cmd, unsigned int pipe,
> +								int sink)
> +{
> +	unsigned int reg = axd_get_output_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg || (sink < 0 && sink > 3)))
> +		return;
> +	if (axd_read_reg(cmd, reg, &control))
> +		return;
> +	sink = (sink << AXD_OUTCTRL_SINK_SHIFT) & AXD_OUTCTRL_SINK_BITS;
> +	control &= ~AXD_OUTCTRL_SINK_BITS;
> +	control |= sink;
> +	axd_write_reg(cmd, reg, control);
> +}
> +
> +/*
> + * Set the downmix of the output pipe.
> + * @pipe: pipe number.
> + * @downmix:
> + *	Pass through	= 0
> + *	5.1		= 1
> + *	2.0		= 2
> + */
> +void axd_cmd_output_set_downmix(struct axd_cmd *cmd, unsigned int pipe,
> +								int downmix)
> +{
> +	unsigned int reg = axd_get_output_downmix_reg(cmd, pipe);
> +
> +	if (unlikely(!reg || downmix > 2 || downmix < 0))
> +		return;
> +	axd_write_reg(cmd, reg, downmix);
> +}
> +
> +/*
> + * Enable/Disable output EQ.
> + * @pipe: pipe number.
> + * @enable:
> + *	Enable	= !0
> + *	Disable	= 0
> + */
> +void axd_cmd_output_set_eqenabled(struct axd_cmd *cmd, unsigned int pipe,
> +								int enable)
> +{
> +	unsigned int reg = axd_get_output_eqcontrol_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return;
> +	if (axd_read_reg(cmd, reg, &control))
> +		return;
> +
> +	if (enable)
> +		control |= AXD_EQCTRL_ENABLE_BITS;
> +	else
> +		control &= ~AXD_EQCTRL_ENABLE_BITS;
> +	axd_write_reg(cmd, reg, control);
> +}
> +
> +/*
> + * Set the Master gain of the EQ of output pipe.
> + * @pipe: pipe number.
> + * @gain: 0-99 gain value
> + */
> +void axd_cmd_output_set_eqmastergain(struct axd_cmd *cmd, unsigned int pipe,
> +								int gain)
> +{
> +	unsigned int reg = axd_get_output_eqcontrol_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg || gain > 99 || gain < 0))
> +		return;
> +	if (axd_read_reg(cmd, reg, &control))
> +		return;
> +
> +	gain = (gain << AXD_EQCTRL_GAIN_SHIFT) & AXD_EQCTRL_GAIN_BITS;
> +	control &= ~AXD_EQCTRL_GAIN_BITS;
> +	control |= gain;
> +	axd_write_reg(cmd, reg, control);
> +}
> +
> +/*
> + * Set the gain of the EQ Band0 of output pipe.
> + * @pipe: pipe number.
> + * @gain: Signed 8 bit 2'compliment gain value.
> + */
> +void axd_cmd_output_set_eqband0gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int gain)
> +{
> +	unsigned int reg = axd_get_output_eqband0_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return;
> +	gain = (gain << AXD_EQBANDX_GAIN_SHIFT) & AXD_EQBANDX_GAIN_BITS;
> +	axd_write_reg(cmd, reg, gain);
> +}
> +
> +/*
> + * Set the gain of the EQ Band1 of output pipe.
> + * @pipe: pipe number.
> + * @gain: Signed 8 bit 2'compliment gain value.
> + */
> +void axd_cmd_output_set_eqband1gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int gain)
> +{
> +	unsigned int reg = axd_get_output_eqband1_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return;
> +	gain = (gain << AXD_EQBANDX_GAIN_SHIFT) & AXD_EQBANDX_GAIN_BITS;
> +	axd_write_reg(cmd, reg, gain);
> +}
> +
> +/*
> + * Set the gain of the EQ Band2 of output pipe.
> + * @pipe: pipe number.
> + * @gain: Signed 8 bit 2'compliment gain value.
> + */
> +void axd_cmd_output_set_eqband2gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int gain)
> +{
> +	unsigned int reg = axd_get_output_eqband2_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return;
> +	gain = (gain << AXD_EQBANDX_GAIN_SHIFT) & AXD_EQBANDX_GAIN_BITS;
> +	axd_write_reg(cmd, reg, gain);
> +}
> +
> +/*
> + * Set the gain of the EQ Band3 of output pipe.
> + * @pipe: pipe number.
> + * @gain: Signed 8 bit 2'compliment gain value.
> + */
> +void axd_cmd_output_set_eqband3gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int gain)
> +{
> +	unsigned int reg = axd_get_output_eqband3_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return;
> +	gain = (gain << AXD_EQBANDX_GAIN_SHIFT) & AXD_EQBANDX_GAIN_BITS;
> +	axd_write_reg(cmd, reg, gain);
> +}
> +
> +/*
> + * Set the gain of the EQ Band4 of output pipe.
> + * @pipe: pipe number.
> + * @gain: Signed 8 bit 2'compliment gain value.
> + */
> +void axd_cmd_output_set_eqband4gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int gain)
> +{
> +	unsigned int reg = axd_get_output_eqband4_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return;
> +	gain = (gain << AXD_EQBANDX_GAIN_SHIFT) & AXD_EQBANDX_GAIN_BITS;
> +	axd_write_reg(cmd, reg, gain);
> +}
> +
> +/* DCPP */
> +
> +int axd_cmd_output_set_dcpp_enabled(struct axd_cmd *cmd, unsigned int pipe,
> +								int enable)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	reg = axd_get_output_dcpp_control_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +	if (axd_read_reg(cmd, reg, &control))
> +		return -1;
> +
> +	if (enable)
> +		control |= AXD_DCPP_CTRL_ENABLE_BITS;
> +	else
> +		control &= ~AXD_DCPP_CTRL_ENABLE_BITS;
> +
> +	return axd_write_reg_buf(cmd, reg, control);
> +}
> +
> +int axd_cmd_output_set_dcpp_mode(struct axd_cmd *cmd, unsigned int pipe,
> +							unsigned int mode)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	reg = axd_get_output_dcpp_control_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +	if (axd_read_reg(cmd, reg, &control))
> +		return -1;
> +
> +	/* Conditionally mask in mode bit */
> +	control ^= ((control ^ (mode << AXD_DCPP_CTRL_MODE_SHIFT))
> +						& AXD_DCPP_CTRL_MODE_BITS);
> +
> +	return axd_write_reg_buf(cmd, reg, control);
> +}
> +
> +int axd_cmd_output_set_dcpp_eq_mode(struct axd_cmd *cmd, unsigned int pipe,
> +							unsigned int mode)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	reg = axd_get_output_dcpp_control_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +	if (axd_read_reg(cmd, reg, &control))
> +		return -1;
> +
> +	/* Conditionally mask in mode bit */
> +	control ^= ((control ^ (mode << AXD_DCPP_CTRL_EQ_MODE_SHIFT))
> +						& AXD_DCPP_CTRL_EQ_MODE_BITS);
> +
> +	return axd_write_reg_buf(cmd, reg, control);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_delay_samples(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_delay_samples_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_eq_output_volume(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_eq_output_volume_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_eq_passthrough_gain(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_eq_passthrough_gain_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_eq_inverse_passthrough_gain(
> +					struct axd_cmd *cmd, unsigned int pipe,
> +					unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_eq_inverse_passthrough_gain_reg(cmd,
> +									pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_bass_shelf_shift(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_bass_shelf_shift_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_bass_shelf_a0(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_bass_shelf_a0_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_bass_shelf_a1(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_bass_shelf_a1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_bass_shelf_a2(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_bass_shelf_a2_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_bass_shelf_b0(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_bass_shelf_b0_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_bass_shelf_b1(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_bass_shelf_b1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_treble_shelf_shift(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_treble_shelf_shift_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_treble_shelf_a0(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_treble_shelf_a0_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_treble_shelf_a1(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_treble_shelf_a1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_treble_shelf_a2(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_treble_shelf_a2_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_treble_shelf_b0(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_treble_shelf_b0_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_treble_shelf_b1(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_treble_shelf_b1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_eq_gain(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int channel,
> +					unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_gain_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_eq_a0(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int channel,
> +					unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_a0_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_eq_a1(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int channel,
> +					unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_a1_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_eq_a2(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int channel,
> +					unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_a2_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_eq_b0(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int channel,
> +					unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_b0_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_eq_b1(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int channel,
> +					unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_b1_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_channel_eq_shift(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int channel,
> +					unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_shift_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_enabled(struct axd_cmd *cmd,
> +						unsigned int pipe, int enable)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	reg = axd_get_output_dcpp_control_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +	if (axd_read_reg(cmd, reg, &control))
> +		return -1;
> +
> +	if (enable)
> +		control |= AXD_DCPP_CTRL_SUBBAND_ENABLE_BITS;
> +	else
> +		control &= ~AXD_DCPP_CTRL_SUBBAND_ENABLE_BITS;
> +
> +	return axd_write_reg_buf(cmd, reg, enable);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_delay_samples(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +
> +	reg = axd_get_output_dcpp_channel_delay_samples_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_input_channel_mask(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int data)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	reg = axd_get_output_dcpp_control_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +	if (axd_read_reg(cmd, reg, &control))
> +		return -1;
> +
> +	control &= ~AXD_DCPP_CTRL_SUBBAND_CHANNEL_MASK_BITS;
> +	control |= data << AXD_DCPP_CTRL_SUBBAND_CHANNEL_MASK_SHIFT;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_eq_output_volume(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +
> +	reg = axd_get_output_dcpp_channel_eq_output_volume_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_eq_passthrough_gain(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +
> +	reg = axd_get_output_dcpp_channel_eq_passthrough_gain_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_eq_inverse_passthrough_gain(
> +		struct axd_cmd *cmd, unsigned int pipe, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +
> +	reg = axd_get_output_dcpp_channel_eq_inverse_passthrough_gain_reg(cmd,
> +									pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_low_pass_filter_a0(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	reg = axd_get_output_dcpp_subband_low_pass_filter_a0_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_low_pass_filter_a1(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	reg = axd_get_output_dcpp_subband_low_pass_filter_a1_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_low_pass_filter_a2(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	reg = axd_get_output_dcpp_subband_low_pass_filter_a2_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_low_pass_filter_b0(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	reg = axd_get_output_dcpp_subband_low_pass_filter_b0_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_low_pass_filter_b1(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	reg = axd_get_output_dcpp_subband_low_pass_filter_b1_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_eq_gain(struct axd_cmd *cmd,
> +			unsigned int pipe, unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_gain_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_eq_a0(struct axd_cmd *cmd,
> +			unsigned int pipe, unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_a0_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_eq_a1(struct axd_cmd *cmd,
> +			unsigned int pipe, unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_a1_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_eq_a2(struct axd_cmd *cmd,
> +			unsigned int pipe, unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_a2_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_eq_b0(struct axd_cmd *cmd,
> +			unsigned int pipe, unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_b0_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_eq_b1(struct axd_cmd *cmd,
> +			unsigned int pipe, unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_b1_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> +
> +int axd_cmd_output_set_dcpp_subband_eq_shift(struct axd_cmd *cmd,
> +			unsigned int pipe, unsigned int band, unsigned int data)
> +{
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_shift_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	return axd_write_reg_buf(cmd, reg, data);
> +}
> diff --git a/drivers/char/axd/axd_cmds_decoder_config.c b/drivers/char/axd/axd_cmds_decoder_config.c
> new file mode 100644
> index 000000000000..4609b11bfcef
> --- /dev/null
> +++ b/drivers/char/axd/axd_cmds_decoder_config.c
> @@ -0,0 +1,1806 @@
> +/*
> + * Copyright (C) 2011-2014 Imagination Technologies Ltd.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * AXD Commands API - Decoder Configuration functions
> + */
> +#include "axd_cmds.h"
> +#include "axd_cmds_codec_internal.h"
> +#include "axd_cmds_internal.h"
> +#include "axd_sysfs.h"
> +
> +/** PCM PASSTHROUGH (input) Config **/
> +static void get_pcm_config(struct axd_cmd *cmd, unsigned int pipe,
> +								char *config)
> +{
> +	unsigned int reg;
> +	unsigned int data;
> +	char str[32];
> +
> +	reg = axd_get_decoder_pcm_samplerate_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +
> +	parse_pcm_samplerate(data, config);
> +
> +	reg = axd_get_decoder_pcm_channels_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_pcm_channels(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_pcm_bitspersample_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_pcm_bitspersample(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_pcm_justification_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_pcm_justification(data, str);
> +	str_append(config, str);
> +}
> +
> +static void set_pcm_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +	unsigned int reg;
> +	int data;
> +
> +	if (CMP_PARAM(config, PCM_SAMPLERATE_PARAM)) {
> +		data = PARAM_VALUE(config, PCM_SAMPLERATE_PARAM);
> +		switch (data) {
> +		case 16000:
> +		case 32000:
> +		case 44100:
> +		case 48000:
> +		case 64000:
> +		case 96000:
> +			break;
> +		default:
> +			return;
> +		}
> +		reg = axd_get_decoder_pcm_samplerate_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, PCM_CHANNELS_PARAM)) {
> +		data = PARAM_VALUE(config, PCM_CHANNELS_PARAM);
> +		if (unlikely(data > 8 || data < 0))
> +			return;
> +		reg = axd_get_decoder_pcm_channels_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, PCM_BITSPERSAMPLE_PARAM)) {
> +		data = PARAM_VALUE(config, PCM_BITSPERSAMPLE_PARAM);
> +		switch (data) {
> +		case 8:
> +		case 16:
> +		case 24:
> +		case 32:
> +			break;
> +		default:
> +			return;
> +		}
> +		reg = axd_get_decoder_pcm_bitspersample_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, PCM_JUSTIFICATION_PARAM)) {
> +		data = PARAM_VALUE(config, PCM_JUSTIFICATION_PARAM);
> +		if (unlikely(data > 1 || data < 0))
> +			return;
> +		reg = axd_get_decoder_pcm_justification_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	}
> +}
> +
> +/** MPEG (2/3) Config **/
> +static void parse_mpeg_numchannels(unsigned int numchannels, char *config)
> +{
> +	sprintf(config, "numchannels = %u\n", numchannels);
> +}
> +static void parse_mpeg_mlchannel(unsigned int mlchannel, char *config)
> +{
> +	sprintf(config, "mlchannel = %u\n", mlchannel);
> +}
> +static void get_mpeg_config(struct axd_cmd *cmd, unsigned int pipe,
> +								char *config)
> +{
> +	unsigned int reg;
> +	unsigned int data;
> +	char str[32];
> +
> +	reg = axd_get_decoder_mpeg_numchannels_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_mpeg_numchannels(data, config);
> +
> +	reg = axd_get_decoder_mpeg_mlchannel_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_mpeg_mlchannel(data, str);
> +	str_append(config, str);
> +}
> +
> +static void set_mpeg_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +#define MPEG_NUMCHANNELS_PARAM		"numchannels"
> +#define MPEG_MLCHANNEL_PARAM		"mlchannel"
> +	unsigned int reg;
> +	int data;
> +
> +	if (CMP_PARAM(config, MPEG_NUMCHANNELS_PARAM)) {
> +		data = PARAM_VALUE(config, MPEG_NUMCHANNELS_PARAM);
> +		if (unlikely(data > 0xFF || data < 0))
> +			return;
> +		reg = axd_get_decoder_mpeg_numchannels_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, MPEG_MLCHANNEL_PARAM)) {
> +		data = PARAM_VALUE(config, MPEG_MLCHANNEL_PARAM);
> +		if (unlikely(data > 0xFF || data < 0))
> +			return;
> +		reg = axd_get_decoder_mpeg_mlchannel_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	}
> +}
> +
> +/** Dolby AC3 Config **/
> +static void parse_ac3_channels(unsigned int channels, char *config)
> +{
> +	sprintf(config, "channels = %u\n", channels);
> +}
> +
> +static void
> +parse_ac3_channel_order(unsigned int channels, char *config, size_t sz)
> +{
> +	static const char * const channel[] = {
> +		"Left           (0)",
> +		"Right          (1)",
> +		"Centre         (2)",
> +		"Left Surround  (3)",
> +		"Right Surround (4)",
> +		"L.F.E.         (5)"
> +	};
> +
> +	snprintf(config, sz, "channel-order:\n"
> +			"%s = %s\n"
> +			"%s = %s\n"
> +			"%s = %s\n"
> +			"%s = %s\n"
> +			"%s = %s\n"
> +			"%s = %s\n",
> +			channel[0],
> +			channel[channels & 0xF],
> +			channel[1],
> +			channel[(channels >> 4) & 0xF],
> +			channel[2],
> +			channel[(channels >> 8) & 0xF],
> +			channel[3],
> +			channel[(channels >> 12) & 0xF],
> +			channel[4],
> +			channel[(channels >> 16) & 0xF],
> +			channel[5],
> +			channel[(channels >> 20) & 0xF]
> +	);
> +
> +}
> +
> +static void parse_ac3_mode(unsigned int mode, char *config)
> +{
> +	static const char * const modestr[] = {
> +		"0 = Dual Mono Mode",
> +		"1 = C (1/0)",
> +		"2 = L,R (2/0)",
> +		"3 = L,C,R (3/0)",
> +		"4 = L,R,S (2/1)",
> +		"5 = L,C,R,S (3/1)",
> +		"6 = L,R,SL,SR,(2/2)",
> +		"7 = L,C,R,SL,SR,(3/2)"
> +	};
> +	static const char * const compmodestr[] = { "Line", "RF"};
> +
> +	sprintf(config, "mode = %s\n"
> +			"compmode = %s\n",
> +			modestr[mode&0xf],
> +			compmodestr[mode >> 31]);
> +}
> +
> +static void get_ac3_config(struct axd_cmd *cmd, unsigned int pipe,
> +								char *config)
> +{
> +#undef BUFF_SIZE
> +#define BUFF_SIZE 64
> +
> +	unsigned int reg;
> +	unsigned int data;
> +	char str[BUFF_SIZE];
> +
> +	reg = axd_get_decoder_ac3_channels_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_ac3_channels(data, config);
> +
> +	reg = axd_get_decoder_ac3_channel_order_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_ac3_channel_order(data, str, BUFF_SIZE);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_ac3_mode_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_ac3_mode(data, str);
> +	str_append(config, str);
> +}
> +
> +static void set_ac3_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +#define AC3_CHANNELS_PARAM		"channels"
> +#define AC3_CHANNEL_ORDER_PARAM		"channel-order"
> +#define AC3_MODE_PARAM			"mode"
> +#define AC3_COMPMODE_PARAM		"compmode"
> +	unsigned int reg;
> +	int data, temp[6];
> +
> +	if (CMP_PARAM(config, AC3_CHANNELS_PARAM)) {
> +		data = PARAM_VALUE(config, AC3_CHANNELS_PARAM);
> +		if (unlikely(data > 6 || data < 0))
> +			return;
> +		reg = axd_get_decoder_ac3_channels_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, AC3_CHANNEL_ORDER_PARAM)) {
> +		sscanf(config, "channel-order=%d,%d,%d,%d,%d,%d",
> +				&temp[0], &temp[1], &temp[2],
> +				&temp[3], &temp[4], &temp[5]);
> +		data =  ((temp[0] & 0xF) <<  0)	|
> +			((temp[1] & 0xF) <<  4)	|
> +			((temp[2] & 0xF) <<  8) |
> +			((temp[3] & 0xF) << 12) |
> +			((temp[4] & 0xF) << 16) |
> +			((temp[5] & 0xF) << 20);
> +		reg = axd_get_decoder_ac3_channel_order_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, AC3_MODE_PARAM)) {
> +		temp[0] = PARAM_VALUE(config, AC3_MODE_PARAM);
> +		if (unlikely(temp[0] > 7 || temp[0] < 0))
> +			return;
> +		reg = axd_get_decoder_ac3_mode_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &data))
> +			return;
> +		data &= ~0xF;
> +		data |= temp[0] & 0xF;
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, AC3_COMPMODE_PARAM)) {
> +		temp[0] = PARAM_VALUE(config, AC3_COMPMODE_PARAM);
> +		if (unlikely(temp[0] > 1 || temp[0] < 0))
> +			return;
> +		reg = axd_get_decoder_ac3_mode_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &data))
> +			return;
> +		data &= ~0x80000000;
> +		data |= (temp[0] & 0x1) << 31;
> +		axd_write_reg(cmd, reg, data);
> +	} }
> +
> +/** AAC Config **/
> +static void parse_aac_version(unsigned int version, char *config)
> +{
> +#define AAC_VERSION_0_STR		"AAC Low Complexity"
> +#define AAC_VERSION_1_STR		"MPEG4 LC"
> +#define AAC_VERSION_2_STR		"MPEG4 HE"
> +#define AAC_VERSION_3_STR		"MPEG4 DABPLUS"
> +	const char *str;
> +
> +	switch (version) {
> +	case 0:
> +		str = AAC_VERSION_0_STR;
> +		break;
> +	case 1:
> +		str = AAC_VERSION_1_STR;
> +		break;
> +	case 2:
> +		str = AAC_VERSION_2_STR;
> +		break;
> +	case 3:
> +		str = AAC_VERSION_3_STR;
> +		break;
> +	default:
> +		return;
> +	}
> +	sprintf(config, "version = %s\n", str);
> +}
> +static void parse_aac_channels(unsigned int channels, char *config)
> +{
> +	sprintf(config, "channels = %u\n", channels);
> +}
> +static void parse_aac_profile(unsigned int profile, char *config)
> +{
> +#define AAC_PROFILE_0_STR		"Main Profile (MP)"
> +#define AAC_PROFILE_1_STR		"Low Complexity (LC)"
> +#define AAC_PROFILE_2_STR		"Scalable Sample Rate (SSR)"
> +	const char *str;
> +
> +	switch (profile) {
> +	case 0:
> +		str = AAC_PROFILE_0_STR;
> +		break;
> +	case 1:
> +		str = AAC_PROFILE_1_STR;
> +		break;
> +	case 2:
> +		str = AAC_PROFILE_2_STR;
> +		break;
> +	default:
> +		str = "Unknown";
> +	}
> +	sprintf(config, "profile = %s\n", str);
> +}
> +static void parse_aac_streamtype(unsigned int streamtype, char *config)
> +{
> +#define AAC_STREAMTYPE_0_STR		"Auto Detect"
> +#define AAC_STREAMTYPE_1_STR		"ADTS"
> +#define AAC_STREAMTYPE_2_STR		"ADIF"
> +#define AAC_STREAMTYPE_3_STR		"RAW"
> +	const char *str;
> +
> +	switch (streamtype) {
> +	case 0:
> +		str = AAC_STREAMTYPE_0_STR;
> +		break;
> +	case 1:
> +		str = AAC_STREAMTYPE_1_STR;
> +		break;
> +	case 2:
> +		str = AAC_STREAMTYPE_2_STR;
> +		break;
> +	case 3:
> +		str = AAC_STREAMTYPE_3_STR;
> +		break;
> +	default:
> +		str = "Unknown";
> +	}
> +	sprintf(config, "streamtype = %s\n", str);
> +}
> +
> +static void parse_aac_samplerate(unsigned int samplerate, char *config)
> +{
> +	sprintf(config, "samplerate = %u\n", samplerate);
> +}
> +
> +static void get_aac_config(struct axd_cmd *cmd, unsigned int pipe,
> +								char *config)
> +{
> +	unsigned int reg;
> +	unsigned int data;
> +	char str[32];
> +
> +	reg = axd_get_decoder_aac_version_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_aac_version(data, config);
> +
> +	reg = axd_get_decoder_aac_channels_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_aac_channels(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_aac_profile_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_aac_profile(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_aac_streamtype_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_aac_streamtype(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_aac_samplerate_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_aac_samplerate(data, str);
> +	str_append(config, str);
> +}
> +
> +static void set_aac_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +#define AAC_VERSION_PARAM		"version"
> +#define AAC_CHANNELS_PARAM		"channels"
> +#define AAC_PROFILE_PARAM		"profile"
> +#define AAC_STREAMTYPE_PARAM		"streamtype"
> +#define AAC_SAMPLERATE_PARAM		"samplerate"
> +	unsigned int reg;
> +	int data;
> +
> +	if (CMP_PARAM(config, AAC_VERSION_PARAM)) {
> +		data = PARAM_VALUE(config, AAC_VERSION_PARAM);
> +		if (unlikely(data > 3 || data < 0))
> +			return;
> +		reg = axd_get_decoder_aac_version_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, AAC_CHANNELS_PARAM)) {
> +		data = PARAM_VALUE(config, AAC_CHANNELS_PARAM);
> +		reg = axd_get_decoder_aac_channels_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, AAC_PROFILE_PARAM)) {
> +		data = PARAM_VALUE(config, AAC_PROFILE_PARAM);
> +		if (unlikely(data > 2 || data < 0))
> +			return;
> +		reg = axd_get_decoder_aac_profile_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, AAC_STREAMTYPE_PARAM)) {
> +		data = PARAM_VALUE(config, AAC_STREAMTYPE_PARAM);
> +		if (unlikely(data > 3 || data < 0))
> +			return;
> +		reg = axd_get_decoder_aac_streamtype_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, AAC_SAMPLERATE_PARAM)) {
> +		data = PARAM_VALUE(config, AAC_SAMPLERATE_PARAM);
> +		if (unlikely(data <= 0))
> +			return;
> +		reg = axd_get_decoder_aac_samplerate_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	}
> +}
> +
> +/** Ogg Vorbis Config **/
> +static void get_ogg_config(struct axd_cmd *cmd, unsigned int pipe,
> +								char *config)
> +{
> +	strcpy(config, "Ogg Vorbis Config not supported\n");
> +}
> +
> +static void set_ogg_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +}
> +
> +/** FLAC Config **/
> +static void parse_flac_channels(unsigned int channels, char *config)
> +{
> +	sprintf(config, "channels = %u\n", channels);
> +}
> +static void parse_flac_samplerate(unsigned int samplerate, char *config)
> +{
> +	sprintf(config, "samplerate = %u\n", samplerate);
> +}
> +static void parse_flac_bitspersample(unsigned int bitspersample, char *config)
> +{
> +	sprintf(config, "bitspersample = %u\n", bitspersample);
> +}
> +static void parse_flac_md5checking(unsigned int md5checking, char *config)
> +{
> +	sprintf(config, "md5checking = %u\n", md5checking);
> +}
> +static void get_flac_config(struct axd_cmd *cmd, unsigned int pipe,
> +								char *config)
> +{
> +	unsigned int reg;
> +	unsigned int data;
> +	char str[32];
> +
> +	reg = axd_get_decoder_flac_channels_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_channels(data, config);
> +
> +	reg = axd_get_decoder_flac_samplerate_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_samplerate(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_flac_bitspersample_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_bitspersample(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_flac_md5checking_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_md5checking(data, str);
> +	str_append(config, str);
> +}
> +
> +static void set_flac_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +#define FLAC_CHANNELS_PARAM		"channels"
> +#define FLAC_SAMPLERATE_PARAM		"samplerate"
> +#define FLAC_BITSPERSAMPLE_PARAM	"bitspersample"
> +#define FLAC_MD5CHECKING_PARAM		"md5checking"
> +	unsigned int reg;
> +	int data;
> +
> +	if (CMP_PARAM(config, FLAC_CHANNELS_PARAM)) {
> +		data = PARAM_VALUE(config, FLAC_CHANNELS_PARAM);
> +		if (unlikely(data > 0x7 || data < 0))
> +			return;
> +		reg = axd_get_decoder_flac_channels_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, FLAC_SAMPLERATE_PARAM)) {
> +		data = PARAM_VALUE(config, FLAC_SAMPLERATE_PARAM);
> +		if (unlikely(data > 0xFFFFF || data < 0))
> +			return;
> +		reg = axd_get_decoder_flac_samplerate_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, FLAC_BITSPERSAMPLE_PARAM)) {
> +		data = PARAM_VALUE(config, FLAC_BITSPERSAMPLE_PARAM);
> +		if (unlikely(data > 0x3F || data < 0))
> +			return;
> +		reg = axd_get_decoder_flac_bitspersample_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, FLAC_MD5CHECKING_PARAM)) {
> +		data = PARAM_VALUE(config, FLAC_MD5CHECKING_PARAM);
> +		if (unlikely(data > 1 || data < 0))
> +			return;
> +		reg = axd_get_decoder_flac_md5checking_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	}
> +}
> +
> +/** Cook Config **/
> +static void parse_cook_flavour(unsigned int flavour, char *config)
> +{
> +	sprintf(config, "flavour = %d\n", flavour);
> +}
> +static void get_cook_config(struct axd_cmd *cmd, unsigned int pipe,
> +								char *config)
> +{
> +	unsigned int reg;
> +	unsigned int data;
> +
> +	reg = axd_get_decoder_cook_flavour_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_cook_flavour(data, config);
> +}
> +
> +static void set_cook_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +#define COOK_FLAVOUR_PARAM		"flavour"
> +	unsigned int reg;
> +	int data;
> +
> +	if (CMP_PARAM(config, COOK_FLAVOUR_PARAM)) {
> +		data = PARAM_VALUE(config, COOK_FLAVOUR_PARAM);
> +		if (unlikely(data > 29 || data < 0))
> +			return;
> +		reg = axd_get_decoder_cook_flavour_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	}
> +}
> +
> +/** WMA Config **/
> +static void parse_wma_playeropt(unsigned int playeropt, char *config)
> +{
> +	sprintf(config, "playeropt = 0x%04X\n", playeropt);
> +}
> +static void parse_wma_drcsetting(unsigned int drcsetting, char *config)
> +{
> +	sprintf(config, "drcsetting = %u\n", drcsetting);
> +}
> +static void parse_wma_peakampref(unsigned int peakampref, char *config)
> +{
> +	sprintf(config, "peakampref = %u\n", peakampref);
> +}
> +static void parse_wma_rmsampref(unsigned int rmsampref, char *config)
> +{
> +	sprintf(config, "rmsampref = %u\n", rmsampref);
> +}
> +static void parse_wma_peakamptarget(unsigned int peakamptarget, char *config)
> +{
> +	sprintf(config, "peakamptarget = %u\n", peakamptarget);
> +}
> +static void parse_wma_rmsamptarget(unsigned int rmsamptarget, char *config)
> +{
> +	sprintf(config, "rmsamptarget = %u\n", rmsamptarget);
> +}
> +static void parse_wma_pcmvalidbitspersample(unsigned int pcmvalidbitspersample,
> +								char *config)
> +{
> +	sprintf(config, "pcmvalidbitspersample = %u\n", pcmvalidbitspersample);
> +}
> +static void parse_wma_pcmcontainersize(unsigned int pcmcontainersize,
> +								char *config)
> +{
> +	sprintf(config, "pcmcontainersize = %u\n", pcmcontainersize);
> +}
> +static void parse_wma_wmaformattag(unsigned int wmaformattag, char *config)
> +{
> +#define WMAFORMATTAG_0x160_STR		"std V1"
> +#define WMAFORMATTAG_0x161_STR		"std V2"
> +#define WMAFORMATTAG_0x162_STR		"Pro"
> +#define WMAFORMATTAG_0x163_STR		"Lossless"
> +	char *str;
> +
> +	switch (wmaformattag) {
> +	case 0x160:
> +		str = WMAFORMATTAG_0x160_STR;
> +		break;
> +	case 0x161:
> +		str = WMAFORMATTAG_0x161_STR;
> +		break;
> +	case 0x162:
> +		str = WMAFORMATTAG_0x162_STR;
> +		break;
> +	case 0x163:
> +		str = WMAFORMATTAG_0x163_STR;
> +		break;
> +	default:
> +		return;
> +
> +	}
> +	sprintf(config, "wmaformattag = %s\n", str);
> +}
> +static void parse_wma_wmanumchannels(unsigned int wmanumchannels, char *config)
> +{
> +	sprintf(config, "wmanumchannels = %u\n", wmanumchannels);
> +}
> +static void parse_wma_wmasamplespersec(unsigned int wmasamplespersec,
> +								char *config)
> +{
> +	sprintf(config, "wmasamplespersec = %u\n", wmasamplespersec);
> +}
> +static void parse_wma_wmaaveragebytespersec(unsigned int wmaaveragebytespersec,
> +								char *config)
> +{
> +	sprintf(config, "wmaaveragebytespersec = %u\n", wmaaveragebytespersec);
> +}
> +static void parse_wma_wmablockalign(unsigned int wmablockalign, char *config)
> +{
> +	sprintf(config, "wmablockalign = %u\n", wmablockalign);
> +}
> +static void parse_wma_wmavalidbitspersample(unsigned int wmavalidbitspersample,
> +								char *config)
> +{
> +	sprintf(config, "wmavalidbitspersample = %u\n", wmavalidbitspersample);
> +}
> +static void parse_wma_wmachannelmask(unsigned int wmachannelmask, char *config)
> +{
> +	sprintf(config, "wmachannelmask = %u\n", wmachannelmask);
> +}
> +static void parse_wma_wmaencodeoptions(unsigned int wmaencodeoptions,
> +								char *config)
> +{
> +	sprintf(config, "wmaencodeoptions = 0x%04X\n", wmaencodeoptions);
> +}
> +static void get_wma_config(struct axd_cmd *cmd, unsigned int pipe,
> +								char *config)
> +{
> +	unsigned int reg;
> +	unsigned int data;
> +	char str[32];
> +
> +	reg = axd_get_decoder_wma_playeropt_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_playeropt(data, config);
> +
> +	reg = axd_get_decoder_wma_drcsetting_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_drcsetting(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_peakampref_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_peakampref(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_rmsampref_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_rmsampref(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_peakamptarget_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_peakamptarget(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_rmsamptarget_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_rmsamptarget(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_pcmvalidbitspersample_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_pcmvalidbitspersample(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_pcmcontainersize_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_pcmcontainersize(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_wmaformattag_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_wmaformattag(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_wmanumchannels_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_wmanumchannels(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_wmasamplespersec_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_wmasamplespersec(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_wmaaveragebytespersec_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_wmaaveragebytespersec(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_wmablockalign_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_wmablockalign(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_wmavalidbitspersample_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_wmavalidbitspersample(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_wmachannelmask_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_wmachannelmask(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_wma_wmaencodeoptions_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_wma_wmaencodeoptions(data, str);
> +	str_append(config, str);
> +}
> +
> +static void set_wma_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +#define WMA_PLAYEROPT_PARAM		"playeropt"
> +#define WMA_DRCSETTING_PARAM		"drcsetting"
> +#define WMA_PEAKAMPREF_PARAM		"peakampref"
> +#define WMA_RMSAMPREF_PARAM		"rmsampref"
> +#define WMA_PEAKAMPTARGET_PARAM		"peakamptarget"
> +#define WMA_RMSAMPTARGET_PARAM		"rmsamptarget"
> +#define WMA_PCMVALIDBITSPERSAMPLE_PARAM	"pcmvalidbitspersample"
> +#define WMA_PCMCONTAINERSIZE_PARAM	"pcmcontainersize"
> +#define WMA_WMAFORMATTAG_PARAM		"wmaformattag"
> +#define WMA_WMANUMCHANNELS_PARAM	"wmanumchannels"
> +#define WMA_WMASAMPLESPERSEC_PARAM	"wmasamplespersec"
> +#define WMA_WMAAVERAGEBYTESPERSEC_PARAM	"wmaaveragebytespersec"
> +#define WMA_WMABLOCKALIGN_PARAM		"wmablockalign"
> +#define WMA_WMAVALIDBITSPERSAMPLE_PARAM	"wmavalidbitspersample"
> +#define WMA_WMACHANNELMASK_PARAM	"wmachannelmask"
> +#define WMA_WMAENCODEOPTIONS_PARAM	"wmaencodeoptions"
> +	unsigned int reg;
> +	int data;
> +
> +	if (CMP_PARAM(config, WMA_PLAYEROPT_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_PLAYEROPT_PARAM);
> +		if (unlikely(data > 0xFFFF || data < 0))
> +			return;
> +		reg = axd_get_decoder_wma_playeropt_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_DRCSETTING_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_DRCSETTING_PARAM);
> +		if (unlikely(data > 0xFFFFF || data < 0))
> +			return;
> +		reg = axd_get_decoder_wma_drcsetting_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_PEAKAMPREF_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_PEAKAMPREF_PARAM);
> +		reg = axd_get_decoder_wma_peakampref_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_RMSAMPREF_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_RMSAMPREF_PARAM);
> +		reg = axd_get_decoder_wma_rmsampref_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_PEAKAMPTARGET_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_PEAKAMPTARGET_PARAM);
> +		reg = axd_get_decoder_wma_peakamptarget_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_RMSAMPTARGET_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_RMSAMPTARGET_PARAM);
> +		reg = axd_get_decoder_wma_rmsamptarget_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_PCMVALIDBITSPERSAMPLE_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_PCMVALIDBITSPERSAMPLE_PARAM);
> +		reg = axd_get_decoder_wma_pcmvalidbitspersample_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_PCMCONTAINERSIZE_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_PCMCONTAINERSIZE_PARAM);
> +		reg = axd_get_decoder_wma_pcmcontainersize_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_WMAFORMATTAG_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_WMAFORMATTAG_PARAM);
> +		if (unlikely(data > 0xFFFFF || data < 0))
> +			return;
> +		reg = axd_get_decoder_wma_wmaformattag_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_WMANUMCHANNELS_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_WMANUMCHANNELS_PARAM);
> +		if (unlikely(data > 0xFFFFF || data < 0))
> +			return;
> +		reg = axd_get_decoder_wma_wmanumchannels_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_WMASAMPLESPERSEC_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_WMASAMPLESPERSEC_PARAM);
> +		reg = axd_get_decoder_wma_wmasamplespersec_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_WMAAVERAGEBYTESPERSEC_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_WMAAVERAGEBYTESPERSEC_PARAM);
> +		reg = axd_get_decoder_wma_wmaaveragebytespersec_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_WMABLOCKALIGN_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_WMABLOCKALIGN_PARAM);
> +		if (unlikely(data > 0xFFFFF || data < 0))
> +			return;
> +		reg = axd_get_decoder_wma_wmablockalign_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_WMAVALIDBITSPERSAMPLE_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_WMAVALIDBITSPERSAMPLE_PARAM);
> +		if (unlikely(data > 0xFFFFF || data < 0))
> +			return;
> +		reg = axd_get_decoder_wma_wmavalidbitspersample_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_WMACHANNELMASK_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_WMACHANNELMASK_PARAM);
> +		reg = axd_get_decoder_wma_wmachannelmask_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, WMA_WMAENCODEOPTIONS_PARAM)) {
> +		data = PARAM_VALUE(config, WMA_WMAENCODEOPTIONS_PARAM);
> +		if (unlikely(data > 0xFFFFF || data < 0))
> +			return;
> +		reg = axd_get_decoder_wma_wmaencodeoptions_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	}
> +}
> +
> +
> +
> +/** DDplus Config **/
> +
> +static void parse_ddplus_config(unsigned int configreg, char *config)
> +{
> +	static const char * const dectype[] = {
> +		"0 = Reserved",
> +		"1 = DCV(5.1)",
> +		"2 = DEC7.1"
> +	};
> +	static const char * const output[] = {"0 = PCM", "1 = AC3"};
> +
> +	sprintf(config,	"DecoderType = %s\n"
> +			"Output = %s\n"
> +			"OutNChans = %d\n",
> +			dectype[configreg & 0x3],
> +			output[(configreg & 0x10) >> 4],
> +			(configreg >> 8) & 0xFF
> +	);
> +}
> +
> +static void
> +parse_ddplus_channel_order(unsigned int channels, char *config, size_t sz)
> +{
> +	static const char * const channel[] = {
> +		"Front Left      (0)",
> +		"Centre          (1)",
> +		"Front Right     (2)",
> +		"Left Surround   (3)",
> +		"Right Surround  (4)",
> +		"L.F.E.          (5)",
> +		"Surround Back L (6)",
> +		"Surround Back R (7)"
> +	};
> +
> +	snprintf(config, sz, "channel-order:\n"
> +			"%s = %s\n"
> +			"%s = %s\n"
> +			"%s = %s\n"
> +			"%s = %s\n"
> +			"%s = %s\n"
> +			"%s = %s\n"
> +			"%s = %s\n"
> +			"%s = %s\n",
> +			channel[0],
> +			channel[channels & 0xF],
> +			channel[1],
> +			channel[(channels >> 4) & 0xF],
> +			channel[2],
> +			channel[(channels >> 8) & 0xF],
> +			channel[3],
> +			channel[(channels >> 12) & 0xF],
> +			channel[4],
> +			channel[(channels >> 16) & 0xF],
> +			channel[5],
> +			channel[(channels >> 20) & 0xF],
> +			channel[6],
> +			channel[(channels >> 24) & 0xF],
> +			channel[7],
> +			channel[(channels >> 28) & 0xF]
> +	);
> +}
> +
> +static void get_ddplus_config(struct axd_cmd *cmd, unsigned int pipe,
> +								char *config)
> +{
> +#undef BUFF_SIZE
> +#define BUFF_SIZE 512
> +	unsigned int reg;
> +	unsigned int data;
> +	char str[BUFF_SIZE];
> +
> +	reg = axd_get_decoder_ddplus_config_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_ddplus_config(data, config);
> +
> +	reg = axd_get_decoder_ddplus_channel_order_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_ddplus_channel_order(data, str, BUFF_SIZE);
> +	str_append(config, str);
> +
> +}
> +
> +static void set_ddplus_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +#define DDP_DECTYPE_PARAM		"DecoderType"
> +#define DDP_OUTPUT_PARAM		"Output"
> +#define DDP_CHANNEL_ORDER_PARAM		"channel-order"
> +#define DDP_OUTNCHANS_PARAM		"OutNChans"
> +
> +	unsigned int reg;
> +	int data, temp[8];
> +
> +	if (CMP_PARAM(config, DDP_DECTYPE_PARAM)) {
> +		temp[0] = PARAM_VALUE(config, DDP_DECTYPE_PARAM);
> +		if (unlikely(temp[0] > 2 || temp[0] < 0))
> +			return;
> +		reg = axd_get_decoder_ddplus_config_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &data))
> +			return;
> +		data &= ~0x3;
> +		data |= temp[0] & 0x3;
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, DDP_OUTPUT_PARAM)) {
> +		temp[0] = PARAM_VALUE(config, DDP_OUTPUT_PARAM);
> +		if (unlikely(temp[0] > 1 || temp[0] < 0))
> +			return;
> +		reg = axd_get_decoder_ddplus_config_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &data))
> +			return;
> +
> +		data &= ~0x10;
> +		data |= (temp[0] << 4) & 0x10;
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, DDP_CHANNEL_ORDER_PARAM)) {
> +		sscanf(config, "channel-order=%d,%d,%d,%d,%d,%d,%d,%d",
> +				&temp[0], &temp[1], &temp[2], &temp[3],
> +				&temp[4], &temp[5], &temp[6], &temp[7]);
> +		data =  ((temp[0] & 0xF) <<  0)	|
> +			((temp[1] & 0xF) <<  4) |
> +			((temp[2] & 0xF) <<  8) |
> +			((temp[3] & 0xF) << 12) |
> +			((temp[4] & 0xF) << 16) |
> +			((temp[5] & 0xF) << 20) |
> +			((temp[6] & 0xF) << 24) |
> +			((temp[7] & 0xF) << 28);
> +		reg = axd_get_decoder_ddplus_channel_order_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, DDP_OUTNCHANS_PARAM)) {
> +		temp[0] = PARAM_VALUE(config, DDP_OUTNCHANS_PARAM);
> +		if (unlikely(temp[0] > 8 || temp[0] < 0))
> +			return;
> +		reg = axd_get_decoder_ddplus_config_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &data))
> +			return;
> +		data &= ~0xFF00;
> +		data |= (temp[0] << 8);
> +		axd_write_reg(cmd, reg, data);
> +	}
> +}
> +
> +/** ALAC Config **/
> +static void parse_alac_channels(uint8_t numchannels, char *config)
> +{
> +	sprintf(config, "channels = %u\n", numchannels);
> +}
> +static void parse_alac_depth(uint8_t bitdepth, char *config)
> +{
> +	sprintf(config, "depth = %u\n", bitdepth);
> +}
> +static void parse_alac_samplerate(uint32_t samplerate, char *config)
> +{
> +	sprintf(config, "samplerate = %u\n", samplerate);
> +}
> +static void parse_alac_framelength(uint32_t framelength, char *config)
> +{
> +	sprintf(config, "framelength = %u\n", framelength);
> +}
> +static void parse_alac_maxframebytes(uint32_t maxframebytes, char *config)
> +{
> +	sprintf(config, "maxframebytes = %u\n", maxframebytes);
> +}
> +static void parse_alac_avgbitrate(uint32_t avgbitrate, char *config)
> +{
> +	sprintf(config, "avgbitrate = %u\n", avgbitrate);
> +}
> +static void get_alac_config(struct axd_cmd *cmd,
> +					unsigned int pipe, char *config)
> +{
> +	unsigned int reg;
> +	unsigned int data;
> +	char str[32];
> +
> +	reg = axd_get_decoder_alac_channels_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_alac_channels(data, config);
> +
> +	reg = axd_get_decoder_alac_depth_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_alac_depth(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_alac_samplerate_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_alac_samplerate(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_alac_framelength_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_alac_framelength(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_alac_maxframebytes_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_alac_maxframebytes(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_alac_avgbitrate_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_alac_avgbitrate(data, str);
> +	str_append(config, str);
> +}
> +static void set_alac_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +#define ALAC_CHANNELS_PARAM		"channels"
> +#define ALAC_DEPTH_PARAM		"depth"
> +#define ALAC_SAMPLERATE_PARAM		"samplerate"
> +#define ALAC_FRAMELENGTH_PARAM		"framelength"
> +#define ALAC_MAXFRAMEBYTES_PARAM	"maxframebytes"
> +#define ALAC_AVGBITRATE_PARAM		"avgbitrate"
> +
> +	unsigned int reg;
> +	int data;
> +
> +	if (CMP_PARAM(config, ALAC_CHANNELS_PARAM)) {
> +		data = PARAM_VALUE(config, ALAC_CHANNELS_PARAM);
> +		switch (data) {
> +		case 1:
> +		case 2:
> +			/* TSTODO Add multichannel support if we can. */
> +			break;
> +		default:
> +			return;
> +		}
> +		reg = axd_get_decoder_alac_channels_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, ALAC_DEPTH_PARAM)) {
> +		data = PARAM_VALUE(config, ALAC_DEPTH_PARAM);
> +		switch (data) {
> +		case 16:
> +		case 20: /* TSTODO test vectors for this */
> +		case 24:
> +		case 32:
> +			break;
> +		default:
> +			return;
> +		}
> +		reg = axd_get_decoder_alac_depth_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, ALAC_SAMPLERATE_PARAM)) {
> +		data = PARAM_VALUE(config, ALAC_SAMPLERATE_PARAM);
> +		reg = axd_get_decoder_alac_samplerate_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, ALAC_FRAMELENGTH_PARAM)) {
> +		data = PARAM_VALUE(config, ALAC_FRAMELENGTH_PARAM);
> +		/* TSTODO sanitize */
> +		reg = axd_get_decoder_alac_framelength_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, ALAC_MAXFRAMEBYTES_PARAM)) {
> +		data = PARAM_VALUE(config, ALAC_MAXFRAMEBYTES_PARAM);
> +		/* TSTODO sanitize */
> +		reg = axd_get_decoder_alac_maxframebytes_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, ALAC_AVGBITRATE_PARAM)) {
> +		data = PARAM_VALUE(config, ALAC_AVGBITRATE_PARAM);
> +		/* TSTODO sanitize */
> +		reg = axd_get_decoder_alac_avgbitrate_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	}
> +}
> +
> +/** SBC Config **/
> +static void parse_sbc_samplerate(uint8_t samplerate, char *config)
> +{
> +	sprintf(config, "samplerate = %u\n", samplerate);
> +}
> +static void parse_sbc_audiomode(uint8_t audiomode, char *config)
> +{
> +	sprintf(config, "audiomode = %u\n", audiomode);
> +}
> +static void parse_sbc_blocks(uint8_t blocks, char *config)
> +{
> +	sprintf(config, "blocks = %u\n", blocks);
> +}
> +static void parse_sbc_subbands(uint8_t subbands, char *config)
> +{
> +	sprintf(config, "subbands = %u\n", subbands);
> +}
> +static void parse_sbc_bitpool(uint8_t bitpool, char *config)
> +{
> +	sprintf(config, "bitpool = %u\n", bitpool);
> +}
> +static void parse_sbc_allocationmode(uint8_t allocationmode, char *config)
> +{
> +	sprintf(config, "allocationmode = %u\n", allocationmode);
> +}
> +static void get_sbc_config(struct axd_cmd *cmd, unsigned int pipe, char *config)
> +{
> +	unsigned int reg;
> +	unsigned int data;
> +	char str[32];
> +
> +	reg = axd_get_decoder_sbc_samplerate_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_sbc_samplerate(data, config);
> +
> +	reg = axd_get_decoder_sbc_audiomode_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_sbc_audiomode(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_sbc_blocks_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_sbc_blocks(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_sbc_subbands_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_sbc_subbands(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_sbc_bitpool_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_sbc_bitpool(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_sbc_allocationmode_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_sbc_allocationmode(data, str);
> +	str_append(config, str);
> +}
> +
> +/** MS11 Config **/
> +static void parse_ms11_mode(uint32_t mode, char *config)
> +{
> +	static const char * const typestr[] = {
> +		"DDC",
> +		"DDT",
> +		"External PCM"
> +	};
> +	int input_type = (mode >> 0) & 0x3;
> +	int dual_input = (mode >> 2) & 0x1;
> +	int dolby_volume_258 = (mode >> 3) & 0x1;
> +	int ms10_mode = (mode >> 4) & 0x1;
> +	int main_only = (mode >> 5) & 0x1;
> +
> +	sprintf(config, "input_type = %s\n"
> +			"dual_input = %d\n"
> +			"dolby_volume_258 = %d\n"
> +			"ms10_mode = %d\n"
> +			"main_only = %d\n",
> +		typestr[input_type], dual_input, dolby_volume_258,
> +		ms10_mode, main_only);
> +}
> +static void parse_ms11_common_config0(uint32_t common_config0, char *config)
> +{
> +	int drc_cut_fac_6ch = (common_config0 >> 0) & 0xFF;
> +	int drc_boost_fac_6ch = (common_config0 >> 8) & 0xFF;
> +	int drc_cut_fac_2ch = (common_config0 >> 16) & 0xFF;
> +	int drc_boost_fac_2ch = (common_config0 >> 24) & 0xFF;
> +
> +	sprintf(config, "drc_cut_fac_6ch = %d\n"
> +			"drc_boost_fac_6ch = %d\n"
> +			"drc_cut_fac_2ch = %d\n"
> +			"drc_boost_fac_2ch = %d\n",
> +		drc_cut_fac_6ch, drc_boost_fac_6ch,
> +		drc_cut_fac_2ch, drc_boost_fac_2ch);
> +}
> +static void parse_ms11_common_config1(uint32_t common_config1, char *config)
> +{
> +	int downmix_type = (common_config1 >> 0) & 0x3;
> +	char *drc_mode = (common_config1 & 0x4) ? "RF mode" : "Line mode";
> +	int dual_mono = (common_config1 >> 3) & 0x3;
> +	int output_multichannel_enable = (common_config1 >> 5) & 0x1;
> +	int associated_audio_mixing = (common_config1 >> 6) & 0x1;
> +	int16_t user_balance_adjustment = (common_config1 >> 16) & 0xFFFF;
> +
> +	sprintf(config, "downmixtype = %d\n"
> +			"drc_mode = %s\n"
> +			"dual_mono = %d\n"
> +			"output_multichannel_enable = %d\n"
> +			"associated_audio_mixing = %d\n"
> +			"user_balance_adjustment = %d\n",
> +		downmix_type, drc_mode, dual_mono, output_multichannel_enable,
> +		associated_audio_mixing, user_balance_adjustment);
> +}
> +static void parse_ms11_ddt_config0(uint32_t ddt_config0, char *config)
> +{
> +	int ddt_default_dialnorm = (ddt_config0 >> 0) & 0xFF;
> +	int ddt_transport_format = (ddt_config0 >> 8) & 0xFF;
> +	int ddt_mixing_mode = (ddt_config0 >> 16) & 0x1;
> +
> +	sprintf(config, "ddt_default_dialnorm = %d\n"
> +			"ddt_transport_format = %d\n"
> +			"ddt_mixing_mode = %d\n",
> +		ddt_default_dialnorm, ddt_transport_format, ddt_mixing_mode);
> +}
> +static void parse_ms11_ddc_config0(uint32_t ddc_config0, char *config)
> +{
> +	int ddc_associated_substream = (ddc_config0 >> 0) & 0xFF;
> +	int ddc_out_mode = (ddc_config0 >> 8) & 0xFF;
> +	int ddc_out_lfe = (ddc_config0 >> 16) & 0x1;
> +
> +	sprintf(config, "ddc_associated_substream = %d\n"
> +			"ddc_out_mode = %d\n"
> +			"ddc_out_lfe = %d\n",
> +		ddc_associated_substream, ddc_out_mode, ddc_out_lfe);
> +}
> +static void parse_ms11_ext_pcm_config0(uint32_t ext_pcm_config0, char *config)
> +{
> +	int ext_pcm_number_in_samples = (ext_pcm_config0 >> 0) & 0xFFFF;
> +	int ext_pcm_audio_coding_mode = (ext_pcm_config0 >> 16) & 0x3;
> +	int ext_pcm_lfe_present = (ext_pcm_config0 >> 18) & 0x1;
> +	int ext_pcm_dsur_mode = (ext_pcm_config0 >> 19) & 0x1;
> +
> +	sprintf(config, "ext_pcm_number_in_samples = %d\n"
> +			"ext_pcm_audio_coding_mode = %d\n"
> +			"ext_pcm_lfe_present = %d\n"
> +			"ext_pcm_dsur_mode = %d\n",
> +		ext_pcm_number_in_samples, ext_pcm_audio_coding_mode,
> +		ext_pcm_lfe_present, ext_pcm_dsur_mode);
> +}
> +static void get_ms11_config(struct axd_cmd *cmd,
> +					unsigned int pipe, char *config)
> +{
> +	unsigned int reg;
> +	unsigned int data;
> +	unsigned int input_type;
> +	char str[164];
> +
> +	reg = axd_get_decoder_ms11_mode_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_ms11_mode(data, config);
> +
> +	input_type = data & 0x3;
> +
> +	reg = axd_get_decoder_ms11_common_config0_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_ms11_common_config0(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_decoder_ms11_common_config1_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_ms11_common_config1(data, str);
> +	str_append(config, str);
> +
> +	switch (input_type) {
> +	case 0: /* DDC */
> +		reg = axd_get_decoder_ms11_ddc_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &data)) {
> +			print_timeout_msg(config);
> +			return;
> +		}
> +		parse_ms11_ddc_config0(data, str);
> +		str_append(config, str);
> +		break;
> +	case 1: /* DDT */
> +		reg = axd_get_decoder_ms11_ddt_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &data)) {
> +			print_timeout_msg(config);
> +			return;
> +		}
> +		parse_ms11_ddt_config0(data, str);
> +		str_append(config, str);
> +		break;
> +	case 2: /* EXTERNAL PCM */
> +		reg = axd_get_decoder_ms11_ext_pcm_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &data)) {
> +			print_timeout_msg(config);
> +			return;
> +		}
> +		parse_ms11_ext_pcm_config0(data, str);
> +		str_append(config, str);
> +		break;
> +	default:
> +		return;
> +	}
> +}
> +static void set_ms11_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +#define MS11_INPUT_TYPE_PARAM			"input_type"
> +#define MS11_DUAL_INPUT_PARAM			"dual_input"
> +#define MS11_DOLBY_VOLUME_258_PARAM		"dolby_volume_258"
> +#define MS11_MS10_MODE_PARAM			"ms10_mode"
> +#define MS11_MAIN_ONLY_PARAM			"main_only"
> +#define MS11_DRC_CUT_FAC_6CH_PARAM		"drc_cut_fac_6ch"
> +#define MS11_DRC_BOOST_FAC_6CH_PARAM		"drc_boost_fac_6ch"
> +#define MS11_DRC_CUT_FAC_2CH_PARAM		"drc_cut_fac_2ch"
> +#define MS11_DRC_BOOST_FAC_2CH_PARAM		"drc_boost_fac_2ch"
> +#define MS11_DOWNMIX_TYPE_PARAM			"downmix_type"
> +#define MS11_DRC_MODE_PARAM			"drc_mode"
> +#define MS11_DUAL_MONO_PARAM			"dual_mono"
> +#define MS11_OUTPUT_MULTICHANNEL_ENABLE_PARAM	"output_multichannel_enable"
> +#define MS11_ASSOCIATED_AUDIO_MIXING_PARAM	"associated_audio_mixing"
> +#define MS11_USER_BALANCE_ADJUSTMENT_PARAM	"user_balance_adjustment"
> +#define MS11_DDT_DEFAULT_DIALNORM_PARAM		"ddt_default_dialnorm"
> +#define MS11_DDT_TRANSPORT_FORMAT_PARAM		"ddt_transport_format"
> +#define MS11_DDT_MIXING_MODE_PARAM		"ddt_mixing_mode"
> +#define MS11_DDC_ASSOCIATED_SUBSTREAM_PARAM	"ddc_associated_substream"
> +#define MS11_DDC_OUT_MODE_PARAM			"ddc_out_mode"
> +#define MS11_DDC_OUT_LFE_PARAM			"ddc_out_lfe"
> +#define MS11_EXT_PCM_NUMBER_IN_SAMPLES_PARAM	"ext_pcm_number_in_samples"
> +#define MS11_EXT_PCM_AUDIO_CODING_MODE_PARAM	"ext_pcm_audio_coding_mode"
> +#define MS11_EXT_PCM_LFE_PRESENT_PARAM		"ext_pcm_lfe_present"
> +#define MS11_EXT_PCM_DOLBY_SURROUND_MODE_PARAM	"ext_pcm_dsur_mode"
> +
> +	unsigned int reg;
> +	int data;
> +	int temp = 0;
> +
> +	if (CMP_PARAM(config, MS11_INPUT_TYPE_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_INPUT_TYPE_PARAM);
> +		reg = axd_get_decoder_ms11_mode_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x3 << 0);
> +		temp |= (data & 0x3) << 0;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DUAL_INPUT_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DUAL_INPUT_PARAM);
> +		reg = axd_get_decoder_ms11_mode_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x1 << 2);
> +		temp |= (!!data) << 2;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DOLBY_VOLUME_258_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DOLBY_VOLUME_258_PARAM);
> +		reg = axd_get_decoder_ms11_mode_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x1 << 3);
> +		temp |= (!!data) << 3;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_MS10_MODE_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_MS10_MODE_PARAM);
> +		reg = axd_get_decoder_ms11_mode_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x1 << 4);
> +		temp |= (!!data) << 4;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_MAIN_ONLY_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_MAIN_ONLY_PARAM);
> +		reg = axd_get_decoder_ms11_mode_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x1 << 5);
> +		temp |= (!!data) << 5;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DRC_CUT_FAC_6CH_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DRC_CUT_FAC_6CH_PARAM);
> +		reg = axd_get_decoder_ms11_common_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0xFF << 0);
> +		temp |= (data & 0xFF) << 0;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DRC_BOOST_FAC_6CH_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DRC_BOOST_FAC_6CH_PARAM);
> +		reg = axd_get_decoder_ms11_common_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0xFF << 8);
> +		temp |= (data & 0xFF) << 8;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DRC_CUT_FAC_2CH_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DRC_CUT_FAC_2CH_PARAM);
> +		reg = axd_get_decoder_ms11_common_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0xFF << 16);
> +		temp |= (data & 0xFF) << 16;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DRC_BOOST_FAC_2CH_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DRC_BOOST_FAC_2CH_PARAM);
> +		reg = axd_get_decoder_ms11_common_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0xFF << 24);
> +		temp |= (data & 0xFF) << 24;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DOWNMIX_TYPE_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DOWNMIX_TYPE_PARAM);
> +		reg = axd_get_decoder_ms11_common_config1_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x3 << 0);
> +		temp |= (data & 0x3) << 0;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DRC_MODE_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DRC_MODE_PARAM);
> +		reg = axd_get_decoder_ms11_common_config1_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x1 << 2);
> +		temp |= (!!data) << 2;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DUAL_MONO_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DUAL_MONO_PARAM);
> +		reg = axd_get_decoder_ms11_common_config1_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x3 << 3);
> +		temp |= (data & 0x3) << 3;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_OUTPUT_MULTICHANNEL_ENABLE_PARAM)) {
> +		data = PARAM_VALUE(config,
> +					MS11_OUTPUT_MULTICHANNEL_ENABLE_PARAM);
> +		reg = axd_get_decoder_ms11_common_config1_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x1 << 5);
> +		temp |= (!!data) << 5;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_ASSOCIATED_AUDIO_MIXING_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_ASSOCIATED_AUDIO_MIXING_PARAM);
> +		reg = axd_get_decoder_ms11_common_config1_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x1 << 6);
> +		temp |= (!!data) << 6;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_USER_BALANCE_ADJUSTMENT_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_USER_BALANCE_ADJUSTMENT_PARAM);
> +		reg = axd_get_decoder_ms11_common_config1_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0xFFFF << 16);
> +		temp |= (data & 0xFFFF) << 16;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DDT_DEFAULT_DIALNORM_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DDT_DEFAULT_DIALNORM_PARAM);
> +		reg = axd_get_decoder_ms11_ddt_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0xFF << 0);
> +		temp |= (data & 0xFF) << 0;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DDT_TRANSPORT_FORMAT_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DDT_TRANSPORT_FORMAT_PARAM);
> +		reg = axd_get_decoder_ms11_ddt_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0xFF << 8);
> +		temp |= (data & 0xFF) << 8;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DDT_MIXING_MODE_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DDT_MIXING_MODE_PARAM);
> +		reg = axd_get_decoder_ms11_ddt_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x1 << 16);
> +		temp |= (!!data) << 16;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DDC_ASSOCIATED_SUBSTREAM_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DDC_ASSOCIATED_SUBSTREAM_PARAM);
> +		reg = axd_get_decoder_ms11_ddc_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0xFF << 0);
> +		temp |= (data & 0xFF) << 0;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DDC_OUT_MODE_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DDC_OUT_MODE_PARAM);
> +		reg = axd_get_decoder_ms11_ddc_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0xFF << 8);
> +		temp |= (data & 0xFF) << 8;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_DDC_OUT_LFE_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_DDC_OUT_LFE_PARAM);
> +		reg = axd_get_decoder_ms11_ddc_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x1 << 16);
> +		temp |= (!!data) << 16;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_EXT_PCM_NUMBER_IN_SAMPLES_PARAM)) {
> +		data = PARAM_VALUE(config,
> +					MS11_EXT_PCM_NUMBER_IN_SAMPLES_PARAM);
> +		reg = axd_get_decoder_ms11_ext_pcm_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0xFFFF << 0);
> +		temp |= (data & 0xFFFF) << 0;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_EXT_PCM_AUDIO_CODING_MODE_PARAM)) {
> +		data = PARAM_VALUE(config,
> +					MS11_EXT_PCM_AUDIO_CODING_MODE_PARAM);
> +		reg = axd_get_decoder_ms11_ext_pcm_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x3 << 16);
> +		temp |= (data & 0x3) << 16;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_EXT_PCM_LFE_PRESENT_PARAM)) {
> +		data = PARAM_VALUE(config, MS11_EXT_PCM_LFE_PRESENT_PARAM);
> +		reg = axd_get_decoder_ms11_ext_pcm_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x1 << 18);
> +		temp |= (!!data) << 18;
> +		axd_write_reg(cmd, reg, temp);
> +	} else if (CMP_PARAM(config, MS11_EXT_PCM_DOLBY_SURROUND_MODE_PARAM)) {
> +		data = PARAM_VALUE(config,
> +					MS11_EXT_PCM_DOLBY_SURROUND_MODE_PARAM);
> +		reg = axd_get_decoder_ms11_ext_pcm_config0_reg(cmd, pipe);
> +		if (axd_read_reg(cmd, reg, &temp))
> +			return;
> +		temp &= ~(0x1 << 19);
> +		temp |= (!!data) << 19;
> +		axd_write_reg(cmd, reg, temp);
> +	}
> +}
> +
> +void axd_cmd_input_get_decoder_config(struct axd_cmd *cmd, unsigned int pipe,
> +								char *config)
> +{
> +	unsigned int codec = axd_get_input_codec_number(cmd, pipe);
> +
> +	switch (codec) {
> +	case 0:
> +		get_pcm_config(cmd, pipe, config);
> +		return;
> +	case 1:
> +		get_mpeg_config(cmd, pipe, config);
> +		return;
> +	case 2:
> +		get_ac3_config(cmd, pipe, config);
> +		return;
> +	case 3:
> +		get_aac_config(cmd, pipe, config);
> +		return;
> +	case 4:
> +		get_ogg_config(cmd, pipe, config);
> +		return;
> +	case 5:
> +		get_flac_config(cmd, pipe, config);
> +		return;
> +	case 6:
> +		get_cook_config(cmd, pipe, config);
> +		return;
> +	case 7:
> +		get_wma_config(cmd, pipe, config);
> +		return;
> +	case 8:
> +		get_ddplus_config(cmd, pipe, config);
> +		return;
> +	case 11:
> +		get_alac_config(cmd, pipe, config);
> +		return;
> +	case 12:
> +		get_ms11_config(cmd, pipe, config);
> +		return;
> +	case 13:
> +		get_sbc_config(cmd, pipe, config);
> +		return;
> +	default:
> +		*config = '\0';
> +		return;
> +	}
> +}
> +
> +void axd_cmd_input_set_decoder_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +	unsigned int codec = axd_get_input_codec_number(cmd, pipe);
> +
> +	switch (codec) {
> +	default:
> +	case 0:
> +		set_pcm_config(cmd, pipe, config);
> +		return;
> +	case 1:
> +		set_mpeg_config(cmd, pipe, config);
> +		return;
> +	case 2:
> +		set_ac3_config(cmd, pipe, config);
> +		return;
> +	case 3:
> +		set_aac_config(cmd, pipe, config);
> +		return;
> +	case 4:
> +		set_ogg_config(cmd, pipe, config);
> +		return;
> +	case 5:
> +		set_flac_config(cmd, pipe, config);
> +		return;
> +	case 6:
> +		set_cook_config(cmd, pipe, config);
> +		return;
> +	case 7:
> +		set_wma_config(cmd, pipe, config);
> +		return;
> +	case 8:
> +		set_ddplus_config(cmd, pipe, config);
> +		return;
> +	case 11:
> +		set_alac_config(cmd, pipe, config);
> +		return;
> +	case 12:
> +		set_ms11_config(cmd, pipe, config);
> +		return;
> +	case 13:
> +		/* No configuration needed; autoconfigured by stream */
> +		return;
> +	}
> +}
> diff --git a/drivers/char/axd/axd_cmds_encoder_config.c b/drivers/char/axd/axd_cmds_encoder_config.c
> new file mode 100644
> index 000000000000..04f8ca258f2f
> --- /dev/null
> +++ b/drivers/char/axd/axd_cmds_encoder_config.c
> @@ -0,0 +1,519 @@
> +/*
> + * Copyright (C) 2011-2014 Imagination Technologies Ltd.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * AXD Commands API - Encoder Configuration functions
> + */
> +#include "axd_cmds.h"
> +#include "axd_cmds_internal.h"
> +#include "axd_cmds_codec_internal.h"
> +#include "axd_sysfs.h"
> +
> +static void set_pcm_config(struct axd_cmd *cmd,
> +					unsigned int pipe, const char *config)
> +{
> +	unsigned int reg;
> +	int data;
> +
> +	if (CMP_PARAM(config, PCM_BITSPERSAMPLE_PARAM)) {
> +		data = PARAM_VALUE(config, PCM_BITSPERSAMPLE_PARAM);
> +		switch (data) {
> +		case 8:
> +		case 16:
> +		case 24:
> +		case 32:
> +			break;
> +		default:
> +			return;
> +		}
> +		reg = axd_get_encoder_pcm_bitspersample_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	}
> +}
> +
> +static void get_pcm_config(struct axd_cmd *cmd, unsigned int pipe, char *config)
> +{
> +	unsigned int reg;
> +	unsigned int data;
> +
> +	reg = axd_get_encoder_pcm_bitspersample_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_pcm_bitspersample(data, config);
> +}
> +
> +/** FLAC Config **/
> +static void parse_flac_channels(unsigned int channels, char *config)
> +{
> +	sprintf(config, "channels = %u\n", channels);
> +}
> +static void parse_flac_samplerate(unsigned int samplerate, char *config)
> +{
> +	sprintf(config, "samplerate = %u\n", samplerate);
> +}
> +static void parse_flac_bitspersample(unsigned int bitspersample, char *config)
> +{
> +	sprintf(config, "bitspersample = %u\n", bitspersample);
> +}
> +static void parse_flac_totalsamples(unsigned int totalsamples, char *config)
> +{
> +	sprintf(config, "totalsamples = %u\n", totalsamples);
> +}
> +static void parse_flac_blocksize(unsigned int blocksize, char *config)
> +{
> +	sprintf(config, "blocksize = %u\n", blocksize);
> +}
> +static void parse_flac_domidsidestereo(unsigned int domidsidestereo,
> +								char *config)
> +{
> +	sprintf(config, "domidsidestereo = %u\n", domidsidestereo);
> +}
> +static void parse_flac_loosemidsidestereo(unsigned int loosemidsidestereo,
> +								char *config)
> +{
> +	sprintf(config, "loosemidsidestereo = %u\n", loosemidsidestereo);
> +}
> +static void parse_flac_doexhaustivemodelsearch(
> +			unsigned int doexhaustivemodelsearch, char *config)
> +{
> +	sprintf(config, "doexhaustivemodelsearch = %u\n",
> +						doexhaustivemodelsearch);
> +}
> +static void parse_flac_minresidualpartitionorder(
> +			unsigned int minresidualpartitionorder, char *config)
> +{
> +	sprintf(config, "minresidualpartitionorder = %u\n",
> +						minresidualpartitionorder);
> +}
> +static void parse_flac_maxresidualpartitionorder(
> +			unsigned int maxresidualpartitionorder, char *config)
> +{
> +	sprintf(config, "maxresidualpartitionorder = %u\n",
> +						maxresidualpartitionorder);
> +}
> +static void parse_flac_framebytes(unsigned int framebytes, char *config)
> +{
> +	sprintf(config, "framebytes = %u\n", framebytes);
> +}
> +static void parse_flac_framecount(unsigned int framecount, char *config)
> +{
> +	sprintf(config, "framecount = %u\n", framecount);
> +}
> +static void parse_flac_samplecount(unsigned int samplecount, char *config)
> +{
> +	sprintf(config, "samplecount = %u\n", samplecount);
> +}
> +static void parse_flac_bytecount(unsigned int bytecount, char *config)
> +{
> +	sprintf(config, "bytecount = %u\n", bytecount);
> +}
> +static void get_flac_config(struct axd_cmd *cmd,
> +					unsigned int pipe, char *config)
> +{
> +	unsigned int reg;
> +	unsigned int data;
> +	char str[32];
> +
> +	reg = axd_get_encoder_flac_channels_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_channels(data, config);
> +
> +	reg = axd_get_encoder_flac_samplerate_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_samplerate(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_flac_bitspersample_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_bitspersample(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_flac_totalsamples_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_totalsamples(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_flac_blocksize_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_blocksize(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_flac_domidsidestereo_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_domidsidestereo(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_flac_loosemidsidestereo_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_loosemidsidestereo(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_flac_doexhaustivemodelsearch_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_doexhaustivemodelsearch(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_flac_minresidualpartitionorder_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_minresidualpartitionorder(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_flac_maxresidualpartitionorder_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_maxresidualpartitionorder(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_flac_framebytes_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_framebytes(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_flac_framecount_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_framecount(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_flac_samplecount_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_samplecount(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_flac_bytecount_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_flac_bytecount(data, str);
> +	str_append(config, str);
> +}
> +
> +static void set_flac_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +#define FLAC_CHANNELS_PARAM			"channels"
> +#define FLAC_SAMPLERATE_PARAM			"samplerate"
> +#define FLAC_BITSPERSAMPLE_PARAM		"bitspersample"
> +#define FLAC_TOTALSAMPLES_PARAM			"totalsamples"
> +#define FLAC_BLOCKSIZE_PARAM			"blocksize"
> +#define FLAC_DOMIDSIDESTEREO_PARAM		"domidsidestereo"
> +#define FLAC_LOOSEMIDSIDESTEREO_PARAM		"loosemidsidestereo"
> +#define FLAC_DOEXHAUSTIVEMODELSEARCH_PARAM	"doexhaustivemodelsearch"
> +#define FLAC_MINRESIDUALPARTITIONORDER_PARAM	"minresidualpartitionorder"
> +#define FLAC_MAXRESIDUALPARTITIONORDER_PARAM	"maxresidualpartitionorder"
> +#define FLAC_FRAMEBYTES_PARAM			"frameBytes"
> +#define FLAC_FRAMECOUNT_PARAM			"frameCount"
> +#define FLAC_SAMPLECOUNT_PARAM			"sampleCount"
> +#define FLAC_BYTECOUNT_PARAM			"byteCount"
> +	unsigned int reg;
> +	int data;
> +
> +	if (CMP_PARAM(config, FLAC_CHANNELS_PARAM)) {
> +		data = PARAM_VALUE(config, FLAC_CHANNELS_PARAM);
> +		if (unlikely(data < 1 || data > 8))
> +			return;
> +		reg = axd_get_encoder_flac_channels_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, FLAC_SAMPLERATE_PARAM)) {
> +		data = PARAM_VALUE(config, FLAC_SAMPLERATE_PARAM);
> +		if (unlikely(data < 1 || data > 655350))
> +			return;
> +		reg = axd_get_encoder_flac_samplerate_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, FLAC_BITSPERSAMPLE_PARAM)) {
> +		data = PARAM_VALUE(config, FLAC_BITSPERSAMPLE_PARAM);
> +		if (unlikely(data < 8 || data > 24))
> +			return;
> +		reg = axd_get_encoder_flac_bitspersample_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, FLAC_TOTALSAMPLES_PARAM)) {
> +		data = PARAM_VALUE(config, FLAC_TOTALSAMPLES_PARAM);
> +		reg = axd_get_encoder_flac_totalsamples_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, FLAC_BLOCKSIZE_PARAM)) {
> +		data = PARAM_VALUE(config, FLAC_BLOCKSIZE_PARAM);
> +		if (unlikely(data != 4096))
> +			return;
> +		reg = axd_get_encoder_flac_blocksize_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, FLAC_DOMIDSIDESTEREO_PARAM)) {
> +		data = PARAM_VALUE(config, FLAC_DOMIDSIDESTEREO_PARAM);
> +		if (unlikely(data < 0 || data > 1))
> +			return;
> +		reg = axd_get_encoder_flac_domidsidestereo_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, FLAC_LOOSEMIDSIDESTEREO_PARAM)) {
> +		data = PARAM_VALUE(config, FLAC_LOOSEMIDSIDESTEREO_PARAM);
> +		if (unlikely(data < 0 || data > 1))
> +			return;
> +		reg = axd_get_encoder_flac_loosemidsidestereo_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, FLAC_DOEXHAUSTIVEMODELSEARCH_PARAM)) {
> +		data = PARAM_VALUE(config, FLAC_DOEXHAUSTIVEMODELSEARCH_PARAM);
> +		if (unlikely(data < 0 || data > 1))
> +			return;
> +		reg = axd_get_encoder_flac_doexhaustivemodelsearch_reg(cmd,
> +									pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, FLAC_MINRESIDUALPARTITIONORDER_PARAM)) {
> +		data = PARAM_VALUE(config,
> +					FLAC_MINRESIDUALPARTITIONORDER_PARAM);
> +		if (unlikely(data < 0 || data > 6)) /* Actual upper limit: 16 */
> +			return;
> +		reg = axd_get_encoder_flac_minresidualpartitionorder_reg(cmd,
> +									pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, FLAC_MAXRESIDUALPARTITIONORDER_PARAM)) {
> +		data = PARAM_VALUE(config,
> +					FLAC_MAXRESIDUALPARTITIONORDER_PARAM);
> +		if (unlikely(data < 0 || data > 6)) /* Actual upper limit: 16 */
> +			return;
> +		reg = axd_get_encoder_flac_maxresidualpartitionorder_reg(cmd,
> +									pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, FLAC_FRAMEBYTES_PARAM)) {
> +		/* Read-only */
> +		return;
> +	} else if (CMP_PARAM(config, FLAC_FRAMECOUNT_PARAM)) {
> +		/* Read-only */
> +		return;
> +	} else if (CMP_PARAM(config, FLAC_SAMPLECOUNT_PARAM)) {
> +		/* Read-only */
> +		return;
> +	} else if (CMP_PARAM(config, FLAC_BYTECOUNT_PARAM)) {
> +		/* Read-only */
> +		return;
> +	}
> +
> +}
> +
> +/** ALAC Config **/
> +static void parse_alac_channels(unsigned int channels, char *config)
> +{
> +	sprintf(config, "channels = %u\n", channels);
> +}
> +static void parse_alac_depth(unsigned int depth, char *config)
> +{
> +	sprintf(config, "depth = %u\n", depth);
> +}
> +static void parse_alac_samplerate(unsigned int samplerate, char *config)
> +{
> +	sprintf(config, "samplerate = %u\n", samplerate);
> +}
> +static void parse_alac_framelength(unsigned int framelength, char *config)
> +{
> +	sprintf(config, "framelength = %u\n", framelength);
> +}
> +static void parse_alac_maxframebytes(unsigned int maxframebytes, char *config)
> +{
> +	sprintf(config, "maxframebytes = %u\n", maxframebytes);
> +}
> +static void parse_alac_avgbitrate(unsigned int avgbitrate, char *config)
> +{
> +	sprintf(config, "avgbitrate = %u\n", avgbitrate);
> +}
> +static void parse_alac_fastmode(unsigned int fastmode, char *config)
> +{
> +	sprintf(config, "fastmode = %u\n", fastmode);
> +}
> +
> +static void get_alac_config(struct axd_cmd *cmd,
> +					unsigned int pipe, char *config)
> +{
> +	unsigned int reg;
> +	unsigned int data;
> +	char str[32];
> +
> +	reg = axd_get_encoder_alac_channels_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_alac_channels(data, config);
> +
> +	reg = axd_get_encoder_alac_depth_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_alac_depth(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_alac_samplerate_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_alac_samplerate(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_alac_framelength_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_alac_framelength(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_alac_maxframebytes_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_alac_maxframebytes(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_alac_avgbitrate_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_alac_avgbitrate(data, str);
> +	str_append(config, str);
> +
> +	reg = axd_get_encoder_alac_fastmode_reg(cmd, pipe);
> +	if (axd_read_reg(cmd, reg, &data)) {
> +		print_timeout_msg(config);
> +		return;
> +	}
> +	parse_alac_fastmode(data, str);
> +	str_append(config, str);
> +}
> +
> +static void set_alac_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +#define ALAC_CHANNELS_PARAM			"channels"
> +#define ALAC_DEPTH_PARAM			"depth"
> +#define ALAC_SAMPLERATE_PARAM			"samplerate"
> +#define ALAC_FRAMELENGTH_PARAM			"framelength"
> +#define ALAC_MAXFRAMEBYTES_PARAM		"maxframebytes"
> +#define ALAC_AVGBITRATE_PARAM			"avgbitrate"
> +#define ALAC_FASTMODE_PARAM			"fastmode"
> +	unsigned int reg;
> +	int data;
> +
> +	if (CMP_PARAM(config, ALAC_CHANNELS_PARAM)) {
> +		data = PARAM_VALUE(config, ALAC_CHANNELS_PARAM);
> +		if (unlikely(data < 1 || data > 8))
> +			return;
> +		reg = axd_get_encoder_alac_channels_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, ALAC_DEPTH_PARAM)) {
> +		data = PARAM_VALUE(config, ALAC_DEPTH_PARAM);
> +		if (unlikely(data < 8 || data > 32))
> +			return;
> +		reg = axd_get_encoder_alac_depth_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, ALAC_SAMPLERATE_PARAM)) {
> +		data = PARAM_VALUE(config, ALAC_SAMPLERATE_PARAM);
> +		/* TSTODO validate */
> +		reg = axd_get_encoder_alac_samplerate_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, ALAC_FRAMELENGTH_PARAM)) {
> +		data = PARAM_VALUE(config, ALAC_FRAMELENGTH_PARAM);
> +		/* TSTODO validate */
> +		reg = axd_get_encoder_alac_framelength_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, ALAC_MAXFRAMEBYTES_PARAM)) {
> +		data = PARAM_VALUE(config, ALAC_MAXFRAMEBYTES_PARAM);
> +		/* TSTODO validate */
> +		reg = axd_get_encoder_alac_maxframebytes_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, ALAC_AVGBITRATE_PARAM)) {
> +		data = PARAM_VALUE(config, ALAC_AVGBITRATE_PARAM);
> +		/* TSTODO validate */
> +		reg = axd_get_encoder_alac_avgbitrate_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	} else if (CMP_PARAM(config, ALAC_FASTMODE_PARAM)) {
> +		data = PARAM_VALUE(config, ALAC_FASTMODE_PARAM);
> +		if (unlikely(data < 0 || data > 1))
> +			return;
> +		reg = axd_get_encoder_alac_fastmode_reg(cmd, pipe);
> +		axd_write_reg(cmd, reg, data);
> +	}
> +}
> +
> +void axd_cmd_output_get_encoder_config(struct axd_cmd *cmd, unsigned int pipe,
> +								char *config)
> +{
> +	unsigned int codec = axd_get_output_codec_number(cmd, pipe);
> +
> +	switch (codec) {
> +	case 0:
> +		get_pcm_config(cmd, pipe, config);
> +		return;
> +	case 5:
> +		get_flac_config(cmd, pipe, config);
> +		return;
> +	case 11:
> +		get_alac_config(cmd, pipe, config);
> +		return;
> +	default:
> +		*config = '\0';
> +		return;
> +	}
> +}
> +
> +void axd_cmd_output_set_encoder_config(struct axd_cmd *cmd, unsigned int pipe,
> +							const char *config)
> +{
> +	unsigned int codec = axd_get_output_codec_number(cmd, pipe);
> +
> +	switch (codec) {
> +	default:
> +	case 0:
> +		set_pcm_config(cmd, pipe, config);
> +		return;
> +	case 5:
> +		set_flac_config(cmd, pipe, config);
> +		return;
> +	case 11:
> +		set_alac_config(cmd, pipe, config);
> +		return;
> +	}
> +}
> diff --git a/drivers/char/axd/axd_cmds_info.c b/drivers/char/axd/axd_cmds_info.c
> new file mode 100644
> index 000000000000..befb3b5e2534
> --- /dev/null
> +++ b/drivers/char/axd/axd_cmds_info.c
> @@ -0,0 +1,1409 @@
> +/*
> + * Copyright (C) 2011-2014 Imagination Technologies Ltd.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * AXD Commands API - Info functions.
> + */
> +#include "axd_cmds.h"
> +#include "axd_cmds_internal.h"
> +
> +/* static functions */
> +/* Fills @source with the source as set in the bit map @bits */
> +static void parse_source(unsigned int bits, char *source)
> +{
> +#define SOURCE_PIPE_STR		"pipe\n"
> +#define SOURCE_AUX_STR		"aux\n"
> +
> +	switch (bits) {
> +	case 0:
> +		strcpy(source, SOURCE_PIPE_STR);
> +		source += sizeof(SOURCE_PIPE_STR);
> +		source--; /* terminating null */
> +		break;
> +	case 1:
> +		strcpy(source, SOURCE_AUX_STR);
> +		source += sizeof(SOURCE_AUX_STR);
> +		source--; /* terminating null */
> +		break;
> +	default:
> +		break;
> +	}
> +	*source = '\0';
> +}
> +
> +/* Fills @sink with the sink as set in the bit map @bits */
> +static void parse_sink(unsigned int bits, char *sink)
> +{
> +#define SINK_PIPE_STR		"pipe\n"
> +#define SINK_I2S_STR		"i2s\n"
> +
> +	switch (bits) {
> +	case 0:
> +		strcpy(sink, SINK_PIPE_STR);
> +		sink += sizeof(SINK_PIPE_STR);
> +		sink--; /* terminating null */
> +		break;
> +	case 1:
> +		strcpy(sink, SINK_I2S_STR);
> +		sink += sizeof(SINK_I2S_STR);
> +		sink--; /* terminating null */
> +		break;
> +	default:
> +		break;
> +	}
> +	*sink = '\0';
> +}
> +
> +/* Fills @codec with the list of codecs as set in the bit map @bits */
> +static void parse_codec_by_bit(unsigned int bits, char *codecs)
> +{
> +#define CODEC_BIT0_MASK		(1 << 0)
> +#define CODEC_BIT0_STR		"PCM Pass through\n"
> +#define CODEC_BIT1_MASK		(1 << 1)
> +#define CODEC_BIT1_STR		"MPEG (MP2/3)\n"
> +#define CODEC_BIT2_MASK		(1 << 2)
> +#define CODEC_BIT2_STR		"Dolby AC3\n"
> +#define CODEC_BIT3_MASK		(1 << 3)
> +#define CODEC_BIT3_STR		"AAC\n"
> +#define CODEC_BIT4_MASK		(1 << 4)
> +#define CODEC_BIT4_STR		"Ogg Vorbis\n"
> +#define CODEC_BIT5_MASK		(1 << 5)
> +#define CODEC_BIT5_STR		"FLAC\n"
> +#define CODEC_BIT6_MASK		(1 << 6)
> +#define CODEC_BIT6_STR		"Cook\n"
> +#define CODEC_BIT7_MASK		(1 << 7)
> +#define CODEC_BIT7_STR		"WMA\n"
> +#define CODEC_BIT8_MASK		(1 << 8)
> +#define CODEC_BIT8_STR		"Dolby Digital Plus\n"
> +#define CODEC_BIT11_MASK	(1 << 11)
> +#define CODEC_BIT11_STR		"ALAC\n"
> +#define CODEC_BIT12_MASK	(1 << 12)
> +#define CODEC_BIT12_STR		"MS11\n"
> +#define CODEC_BIT13_MASK	(1 << 13)
> +#define CODEC_BIT13_STR		"SBC\n"
> +
> +	if (bits & CODEC_BIT0_MASK) {
> +		strcpy(codecs, CODEC_BIT0_STR);
> +		codecs += sizeof(CODEC_BIT0_STR);
> +		codecs--; /* terminating null */
> +	}
> +	if (bits & CODEC_BIT1_MASK) {
> +		strcpy(codecs, CODEC_BIT1_STR);
> +		codecs += sizeof(CODEC_BIT1_STR);
> +		codecs--; /* terminating null */
> +	}
> +	if (bits & CODEC_BIT2_MASK) {
> +		strcpy(codecs, CODEC_BIT2_STR);
> +		codecs += sizeof(CODEC_BIT2_STR);
> +		codecs--; /* terminating null */
> +	}
> +	if (bits & CODEC_BIT3_MASK) {
> +		strcpy(codecs, CODEC_BIT3_STR);
> +		codecs += sizeof(CODEC_BIT3_STR);
> +		codecs--; /* terminating null */
> +	}
> +	if (bits & CODEC_BIT4_MASK) {
> +		strcpy(codecs, CODEC_BIT4_STR);
> +		codecs += sizeof(CODEC_BIT4_STR);
> +		codecs--; /* terminating null */
> +	}
> +	if (bits & CODEC_BIT5_MASK) {
> +		strcpy(codecs, CODEC_BIT5_STR);
> +		codecs += sizeof(CODEC_BIT5_STR);
> +		codecs--; /* terminating null */
> +	}
> +	if (bits & CODEC_BIT6_MASK) {
> +		strcpy(codecs, CODEC_BIT6_STR);
> +		codecs += sizeof(CODEC_BIT6_STR);
> +		codecs--; /* terminating null */
> +	}
> +	if (bits & CODEC_BIT7_MASK) {
> +		strcpy(codecs, CODEC_BIT7_STR);
> +		codecs += sizeof(CODEC_BIT7_STR);
> +		codecs--; /* terminating null */
> +	}
> +	if (bits & CODEC_BIT8_MASK) {
> +		strcpy(codecs, CODEC_BIT8_STR);
> +		codecs += sizeof(CODEC_BIT8_STR);
> +		codecs--; /* terminating null */
> +	}
> +	if (bits & CODEC_BIT11_MASK) {
> +		strcpy(codecs, CODEC_BIT11_STR);
> +		codecs += sizeof(CODEC_BIT11_STR);
> +		codecs--; /* terminating null */
> +	}
> +	if (bits & CODEC_BIT12_MASK) {
> +		strcpy(codecs, CODEC_BIT12_STR);
> +		codecs += sizeof(CODEC_BIT12_STR);
> +		codecs--; /* terminating null */
> +	}
> +	if (bits & CODEC_BIT13_MASK) {
> +		strcpy(codecs, CODEC_BIT13_STR);
> +		codecs += sizeof(CODEC_BIT13_STR);
> +		codecs--; /* terminating null */
> +	}
> +	*codecs = '\0';
> +}
> +
> +/* Fills @codec with the codec corresponding to @codec_num */
> +static void parse_codec_by_number(unsigned int codec_num, char *codecs)
> +{
> +	parse_codec_by_bit(1 << codec_num, codecs);
> +}
> +
> +/* Fills @upmix by the current upmix setting */
> +static void parse_upmix(unsigned int setting, char *upmix)
> +{
> +#define UPMIX_0_STR		"Pass through\n"
> +#define UPMIX_1_STR		"Simple 5.1\n"
> +#define UPMIX_2_STR		"Dolby Pro Logic 2\n"
> +
> +	switch (setting) {
> +	case 0:
> +		strcpy(upmix, UPMIX_0_STR);
> +		upmix += sizeof(UPMIX_0_STR);
> +		upmix--; /* terminating null */
> +		break;
> +	case 1:
> +		strcpy(upmix, UPMIX_1_STR);
> +		upmix += sizeof(UPMIX_1_STR);
> +		upmix--; /* terminating null */
> +		break;
> +	case 2:
> +		strcpy(upmix, UPMIX_2_STR);
> +		upmix += sizeof(UPMIX_2_STR);
> +		upmix--; /* terminating null */
> +		break;
> +	default:
> +		break;
> +	}
> +	*upmix = '\0';
> +}
> +
> +/* Fills @downmix by the current downmix setting */
> +static void parse_downmix(unsigned int setting, char *downmix)
> +{
> +#define DOWNMIX_0_STR		"Pass through\n"
> +#define DOWNMIX_1_STR		"5.1\n"
> +#define DOWNMIX_2_STR		"2.0\n"
> +
> +	switch (setting) {
> +	case 0:
> +		strcpy(downmix, DOWNMIX_0_STR);
> +		downmix += sizeof(DOWNMIX_0_STR);
> +		downmix--; /* terminating null */
> +		break;
> +	case 1:
> +		strcpy(downmix, DOWNMIX_1_STR);
> +		downmix += sizeof(DOWNMIX_1_STR);
> +		downmix--; /* terminating null */
> +		break;
> +	case 2:
> +		strcpy(downmix, DOWNMIX_2_STR);
> +		downmix += sizeof(DOWNMIX_2_STR);
> +		downmix--; /* terminating null */
> +		break;
> +	default:
> +		break;
> +	}
> +	*downmix = '\0';
> +}
> +
> +/* Fills @mux by the current setting of mixer's output @pipe mux */
> +static void parse_mux(unsigned int setting, char *mux)
> +{
> +#define MUX_0_STR		"mix\n"
> +#define MUX_1_STR		"input 0\n"
> +#define MUX_2_STR		"input 1\n"
> +#define MUX_3_STR		"input 2\n"
> +#define MUX_4_STR		"input 3\n"
> +
> +	switch (setting) {
> +	case 0:
> +		strcpy(mux, MUX_0_STR);
> +		mux += sizeof(MUX_0_STR);
> +		mux--; /* terminating null */
> +		break;
> +	case 1:
> +		strcpy(mux, MUX_1_STR);
> +		mux += sizeof(MUX_1_STR);
> +		mux--; /* terminating null */
> +		break;
> +	case 2:
> +		strcpy(mux, MUX_2_STR);
> +		mux += sizeof(MUX_2_STR);
> +		mux--; /* terminating null */
> +		break;
> +	case 3:
> +		strcpy(mux, MUX_3_STR);
> +		mux += sizeof(MUX_3_STR);
> +		mux--; /* terminating null */
> +		break;
> +	case 4:
> +		strcpy(mux, MUX_4_STR);
> +		mux += sizeof(MUX_4_STR);
> +		mux--; /* terminating null */
> +		break;
> +	default:
> +		break;
> +	}
> +	*mux = '\0';
> +}
> +
> +/* Info API */
> +/* Sets the major and minor numbers of the currently running AXD firmware */
> +void axd_cmd_get_version(struct axd_cmd *cmd,
> +					int *major, int *minor, int *patch)
> +{
> +	unsigned int version;
> +
> +	axd_read_reg(cmd, AXD_REG_VERSION, &version);
> +	if (unlikely(!major || !minor))
> +		return;
> +	*major = (version >> 22);		/* top 10 bits */
> +	*minor = (version >> 12) & 0x3FF;	/* middle 10 bits */
> +	*patch = version & 0xFFF;		/* bottom 12 bits */
> +}
> +
> +/* Sets the number of supported in/out pipes */
> +int axd_cmd_get_num_pipes(struct axd_cmd *cmd,
> +				unsigned int *inpipes, unsigned int *outpipes)
> +{
> +	unsigned int config0;
> +	int ret;
> +
> +	ret = axd_read_reg(cmd, AXD_REG_CONFIG0, &config0);
> +	if (unlikely(!inpipes || !outpipes))
> +		return -1;
> +	if (ret)
> +		return -1;
> +	*inpipes = config0 >> 16;
> +	*inpipes &= 0xFF;
> +	*outpipes = config0 & 0xFF;
> +	return 0;
> +}
> +
> +/* Fills @codecs with a list of supported codecs */
> +void axd_cmd_get_decoders(struct axd_cmd *cmd, char *codecs)
> +{
> +	unsigned int config1;
> +
> +	axd_read_reg(cmd, AXD_REG_CONFIG1, &config1);
> +	if (unlikely(!codecs))
> +		return;
> +	parse_codec_by_bit(config1, codecs);
> +}
> +
> +/* Fills @codecs with a list of supported codecs */
> +void axd_cmd_get_encoders(struct axd_cmd *cmd, char *codecs)
> +{
> +	unsigned int config2;
> +
> +	axd_read_reg(cmd, AXD_REG_CONFIG2, &config2);
> +	if (unlikely(!codecs))
> +		return;
> +	parse_codec_by_bit(config2, codecs);
> +}
> +
> +/* Returns non-zero if Mix/Xbar is present. Zero otherwise. */
> +int axd_cmd_xbar_present(struct axd_cmd *cmd)
> +{
> +	unsigned int temp;
> +
> +	axd_read_reg(cmd, AXD_REG_CONFIG3, &temp);
> +	return temp & 0x1;
> +}
> +
> +/* Returns non-zero if mixer EQ is enabled. Zero otherwise. */
> +int axd_cmd_mixer_get_eqenabled(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int control;
> +
> +	axd_read_reg(cmd, AXD_REG_EQ_CTRL_GAIN, &control);
> +	return (control & AXD_EQCTRL_ENABLE_BITS) >> AXD_EQCTRL_ENABLE_SHIFT;
> +}
> +
> +/* Sets @gain to the currently set output EQ Master gain value */
> +void axd_cmd_mixer_get_eqmastergain(struct axd_cmd *cmd, unsigned int pipe,
> +								int *gain)
> +{
> +	unsigned int control;
> +
> +	axd_read_reg(cmd, AXD_REG_EQ_CTRL_GAIN, &control);
> +	*gain = (control & AXD_EQCTRL_GAIN_BITS) >> AXD_EQCTRL_GAIN_SHIFT;
> +}
> +
> +/* Sets @gain to the currently set output EQ Band0 gain value */
> +void axd_cmd_mixer_get_eqband0gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int *gain)
> +{
> +	unsigned int temp;
> +
> +	axd_read_reg(cmd, AXD_REG_EQ_BAND0, &temp);
> +	*gain = ((int)temp & AXD_EQBANDX_GAIN_BITS) >> AXD_EQBANDX_GAIN_SHIFT;
> +}
> +
> +/* Sets @gain to the currently set output EQ Band1 gain value */
> +void axd_cmd_mixer_get_eqband1gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int *gain)
> +{
> +	unsigned int  temp;
> +
> +	axd_read_reg(cmd, AXD_REG_EQ_BAND1, &temp);
> +	*gain = ((int)temp & AXD_EQBANDX_GAIN_BITS) >> AXD_EQBANDX_GAIN_SHIFT;
> +}
> +
> +/* Sets @gain to the currently set output EQ Band2 gain value */
> +void axd_cmd_mixer_get_eqband2gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int *gain)
> +{
> +	unsigned int  temp;
> +
> +	axd_read_reg(cmd, AXD_REG_EQ_BAND2, &temp);
> +	*gain = ((int)temp & AXD_EQBANDX_GAIN_BITS) >> AXD_EQBANDX_GAIN_SHIFT;
> +}
> +
> +/* Sets @gain to the currently set output EQ Band3 gain value */
> +void axd_cmd_mixer_get_eqband3gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int *gain)
> +{
> +	unsigned int  temp;
> +
> +	axd_read_reg(cmd, AXD_REG_EQ_BAND3, &temp);
> +	*gain = ((int)temp & AXD_EQBANDX_GAIN_BITS) >> AXD_EQBANDX_GAIN_SHIFT;
> +}
> +
> +/* Sets @gain to the currently set output EQ Band4 gain value */
> +void axd_cmd_mixer_get_eqband4gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int *gain)
> +{
> +	unsigned int  temp;
> +
> +	axd_read_reg(cmd, AXD_REG_EQ_BAND4, &temp);
> +	*gain = ((int)temp & AXD_EQBANDX_GAIN_BITS) >> AXD_EQBANDX_GAIN_SHIFT;
> +}
> +
> +/* Sets @mux to the currently selected mux output @pipe of mixer */
> +void axd_cmd_mixer_get_mux(struct axd_cmd *cmd, unsigned int pipe,
> +								char *mux)
> +{
> +	unsigned int reg = axd_get_mixer_mux_reg(cmd, pipe);
> +	unsigned int setting;
> +
> +	if (unlikely(!reg || !mux))
> +		return;
> +	axd_read_reg(cmd, reg, &setting);
> +	parse_mux(setting, mux);
> +}
> +
> +/* Returns non-zero of input @pipe is enabled. Zero otherwise. */
> +int axd_cmd_input_get_enabled(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_input_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return (control & AXD_INCTRL_ENABLE_BITS) >> AXD_INCTRL_ENABLE_SHIFT;
> +}
> +
> +/* Sets @source to the currently selected source of input @pipe */
> +void axd_cmd_input_get_source(struct axd_cmd *cmd, unsigned int pipe,
> +								char *source)
> +{
> +	unsigned int reg = axd_get_input_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg || !source))
> +		return;
> +	axd_read_reg(cmd, reg, &control);
> +	control = (control & AXD_INCTRL_SOURCE_BITS) >> AXD_INCTRL_SOURCE_SHIFT;
> +	parse_source(control, source);
> +}
> +
> +/* Sets @codec to the currently selected codec of input @pipe */
> +void axd_cmd_input_get_codec(struct axd_cmd *cmd, unsigned int pipe,
> +								char *codec)
> +{
> +	unsigned int codec_num = axd_get_input_codec_number(cmd, pipe);
> +
> +	if (unlikely(!codec))
> +		return;
> +	parse_codec_by_number(codec_num, codec);
> +}
> +
> +/* Sets @gain to the currently set input gain value */
> +void axd_cmd_input_get_gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int *gain)
> +{
> +	unsigned int reg = axd_get_input_gain_reg(cmd, pipe);
> +
> +	if (unlikely(!reg || !gain))
> +		return;
> +	axd_read_reg(cmd, reg, gain);
> +}
> +
> +/* Sets @gain to the currently set input gain value */
> +void axd_cmd_input_get_mute(struct axd_cmd *cmd, unsigned int pipe,
> +								int *muted)
> +{
> +	unsigned int reg = axd_get_input_gain_reg(cmd, pipe);
> +
> +	if (unlikely(!reg || !muted))
> +		return;
> +	axd_read_reg(cmd, reg, muted);
> +}
> +
> +/* Sets @upmix to the currently selected upmix setting of input @pipe */
> +void axd_cmd_input_get_upmix(struct axd_cmd *cmd, unsigned int pipe,
> +								char *upmix)
> +{
> +	unsigned int reg = axd_get_input_upmix_reg(cmd, pipe);
> +	unsigned int setting;
> +
> +	if (unlikely(!reg || !upmix))
> +		return;
> +	axd_read_reg(cmd, reg, &setting);
> +	parse_upmix(setting, upmix);
> +}
> +
> +/* Returns the buffer occupancy value of @pipe. */
> +unsigned int axd_cmd_input_get_buffer_occupancy(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	unsigned int bo;
> +	unsigned int reg = axd_get_input_buffer_occupancy_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &bo);
> +	return bo;
> +}
> +
> +/* Returns non-zero of output @pipe is enabled. Zero otherwise. */
> +int axd_cmd_output_get_enabled(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_output_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return (control & AXD_OUTCTRL_ENABLE_BITS) >> AXD_OUTCTRL_ENABLE_SHIFT;
> +}
> +
> +/* Sets @codec to the currently selected codec of output @pipe */
> +void axd_cmd_output_get_codec(struct axd_cmd *cmd, unsigned int pipe,
> +								char *codec)
> +{
> +	unsigned int codec_num = axd_get_output_codec_number(cmd, pipe);
> +
> +	if (unlikely(!codec))
> +		return;
> +	parse_codec_by_number(codec_num, codec);
> +}
> +
> +/* Sets @sink to the currently selected sink of output @pipe */
> +void axd_cmd_output_get_sink(struct axd_cmd *cmd, unsigned int pipe,
> +								char *sink)
> +{
> +	unsigned int reg = axd_get_output_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg || !sink))
> +		return;
> +	axd_read_reg(cmd, reg, &control);
> +	control = (control & AXD_OUTCTRL_SINK_BITS) >> AXD_OUTCTRL_SINK_SHIFT;
> +	parse_sink(control, sink);
> +}
> +
> +/* Sets @downmix to the currently selected downmix setting of output @pipe */
> +void axd_cmd_output_get_downmix(struct axd_cmd *cmd, unsigned int pipe,
> +								char *downmix)
> +{
> +	unsigned int reg = axd_get_output_downmix_reg(cmd, pipe);
> +	unsigned int setting;
> +
> +	if (unlikely(!reg || !downmix))
> +		return;
> +	axd_read_reg(cmd, reg, &setting);
> +	parse_downmix(setting, downmix);
> +}
> +
> +/* Returns non-zero of output @pipe EQ is enabled. Zero otherwise. */
> +int axd_cmd_output_get_eqenabled(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_output_eqcontrol_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return (control & AXD_EQCTRL_ENABLE_BITS) >> AXD_EQCTRL_ENABLE_SHIFT;
> +}
> +
> +/* Sets @gain to the currently set output EQ Master gain value */
> +void axd_cmd_output_get_eqmastergain(struct axd_cmd *cmd, unsigned int pipe,
> +								int *gain)
> +{
> +	unsigned int reg = axd_get_output_eqcontrol_reg(cmd, pipe);
> +	unsigned int temp;
> +
> +	if (unlikely(!reg || !gain))
> +		return;
> +	axd_read_reg(cmd, reg, &temp);
> +	*gain = ((int)temp & AXD_EQCTRL_GAIN_BITS) >> AXD_EQCTRL_GAIN_SHIFT;
> +}
> +
> +/* Sets @gain to the currently set output EQ Band0 gain value */
> +void axd_cmd_output_get_eqband0gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int *gain)
> +{
> +	unsigned int reg = axd_get_output_eqband0_reg(cmd, pipe);
> +	unsigned int temp;
> +
> +	if (unlikely(!reg || !gain))
> +		return;
> +	axd_read_reg(cmd, reg, &temp);
> +	*gain = ((int)temp & AXD_EQBANDX_GAIN_BITS) >> AXD_EQBANDX_GAIN_SHIFT;
> +}
> +
> +/* Sets @gain to the currently set output EQ Band1 gain value */
> +void axd_cmd_output_get_eqband1gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int *gain)
> +{
> +	unsigned int reg = axd_get_output_eqband1_reg(cmd, pipe);
> +	unsigned int temp;
> +
> +	if (unlikely(!reg || !gain))
> +		return;
> +	axd_read_reg(cmd, reg, &temp);
> +	*gain = ((int)temp & AXD_EQBANDX_GAIN_BITS) >> AXD_EQBANDX_GAIN_SHIFT;
> +}
> +
> +/* Sets @gain to the currently set output EQ Band2 gain value */
> +void axd_cmd_output_get_eqband2gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int *gain)
> +{
> +	unsigned int reg = axd_get_output_eqband2_reg(cmd, pipe);
> +	unsigned int temp;
> +
> +	if (unlikely(!reg || !gain))
> +		return;
> +	axd_read_reg(cmd, reg, &temp);
> +	*gain = ((int)temp & AXD_EQBANDX_GAIN_BITS) >> AXD_EQBANDX_GAIN_SHIFT;
> +}
> +
> +/* Sets @gain to the currently set output EQ Band3 gain value */
> +void axd_cmd_output_get_eqband3gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int *gain)
> +{
> +	unsigned int reg = axd_get_output_eqband3_reg(cmd, pipe);
> +	unsigned int temp;
> +
> +	if (unlikely(!reg || !gain))
> +		return;
> +	axd_read_reg(cmd, reg, &temp);
> +	*gain = ((int)temp & AXD_EQBANDX_GAIN_BITS) >> AXD_EQBANDX_GAIN_SHIFT;
> +}
> +
> +/* Sets @gain to the currently set output EQ Band4 gain value */
> +void axd_cmd_output_get_eqband4gain(struct axd_cmd *cmd, unsigned int pipe,
> +								int *gain)
> +{
> +	unsigned int reg = axd_get_output_eqband4_reg(cmd, pipe);
> +	unsigned int temp;
> +
> +	if (unlikely(!reg || !gain))
> +		return;
> +	axd_read_reg(cmd, reg, &temp);
> +	*gain = ((int)temp & AXD_EQBANDX_GAIN_BITS) >> AXD_EQBANDX_GAIN_SHIFT;
> +}
> +
> +void axd_cmd_output_get_geq_power(struct axd_cmd *cmd, unsigned int pipe,
> +							char *buf, int channel)
> +{
> +	u32 data[5];
> +	int i;
> +
> +	if (channel < 4) {
> +		for (i = 0; i < 5; i++) {
> +			u32 reg = axd_get_output_eq_power_reg_ch0_3(cmd,
> +								pipe, i);
> +
> +			if (unlikely(!reg))
> +				return;
> +
> +			if (axd_read_reg(cmd, reg, &data[i]))
> +				return;
> +		}
> +
> +		sprintf(buf, "%d, %d, %d, %d, %d\n",
> +				(data[0] >> (channel * 8)) & 0xFF,
> +				(data[1] >> (channel * 8)) & 0xFF,
> +				(data[2] >> (channel * 8)) & 0xFF,
> +				(data[3] >> (channel * 8)) & 0xFF,
> +				(data[3] >> (channel * 8)) & 0xFF);
> +
> +	} else {
> +		for (i = 0; i < 5; i++) {
> +			u32 reg = axd_get_output_eq_power_reg_ch4_7(cmd,
> +								pipe, i);
> +
> +			if (unlikely(!reg))
> +				return;
> +
> +			if (axd_read_reg(cmd, reg, &data[i]))
> +				return;
> +		}
> +
> +		sprintf(buf, "%d, %d, %d, %d, %d\n",
> +				(data[0] >> (channel-4 * 8)) & 0xFF,
> +				(data[1] >> (channel-4 * 8)) & 0xFF,
> +				(data[2] >> (channel-4 * 8)) & 0xFF,
> +				(data[3] >> (channel-4 * 8)) & 0xFF,
> +				(data[4] >> (channel-4 * 8)) & 0xFF);
> +	}
> +}
> +
> +unsigned int axd_cmd_info_get_resampler_fin(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	unsigned int temp;
> +	unsigned int reg = axd_get_resample_fin_reg(cmd, pipe);
> +
> +	axd_read_reg(cmd, reg, &temp);
> +
> +	return temp;
> +}
> +
> +unsigned int axd_cmd_info_get_resampler_fout(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	unsigned int temp;
> +	unsigned int reg = axd_get_resample_fout_reg(cmd, pipe);
> +
> +	axd_read_reg(cmd, reg, &temp);
> +
> +	return temp;
> +}
> +
> +void axd_cmd_info_set_resampler_fout(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int fout)
> +{
> +	unsigned int reg = axd_get_resample_fout_reg(cmd, pipe);
> +
> +	axd_write_reg(cmd, reg, fout);
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_enabled(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_output_dcpp_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return (control & AXD_DCPP_CTRL_ENABLE_BITS) >>
> +						AXD_DCPP_CTRL_ENABLE_SHIFT;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_mode(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_output_dcpp_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return (control & AXD_DCPP_CTRL_MODE_BITS) >> AXD_DCPP_CTRL_MODE_SHIFT;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channels(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_output_dcpp_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return (control & AXD_DCPP_CTRL_CHANNELS_BITS) >>
> +						AXD_DCPP_CTRL_CHANNELS_SHIFT;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_eq_mode(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_output_dcpp_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return (control & AXD_DCPP_CTRL_EQ_MODE_BITS) >>
> +						AXD_DCPP_CTRL_EQ_MODE_SHIFT;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_eq_bands(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_output_dcpp_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return (control & AXD_DCPP_CTRL_EQ_BANDS_BITS) >>
> +						AXD_DCPP_CTRL_EQ_BANDS_SHIFT;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_max_delay_samples(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_output_dcpp_max_delay_samples_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_delay_samples(struct axd_cmd *cmd,
> +				unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_delay_samples_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_eq_output_volume(
> +		struct axd_cmd *cmd, unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_eq_output_volume_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_eq_passthrough_gain(
> +		struct axd_cmd *cmd, unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_eq_passthrough_gain_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_eq_inverse_passthrough_gain(
> +		struct axd_cmd *cmd, unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_eq_inverse_passthrough_gain_reg(cmd,
> +									pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_bass_shelf_shift(
> +		struct axd_cmd *cmd, unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_bass_shelf_shift_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_bass_shelf_a0(struct axd_cmd *cmd,
> +				unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_bass_shelf_a0_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_bass_shelf_a1(struct axd_cmd *cmd,
> +				unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_bass_shelf_a1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_bass_shelf_a2(struct axd_cmd *cmd,
> +				unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_bass_shelf_a2_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_bass_shelf_b0(struct axd_cmd *cmd,
> +				unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_bass_shelf_b0_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_bass_shelf_b1(struct axd_cmd *cmd,
> +				unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_bass_shelf_b1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_treble_shelf_shift(
> +		struct axd_cmd *cmd, unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_treble_shelf_shift_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_treble_shelf_a0(
> +		struct axd_cmd *cmd, unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_treble_shelf_a0_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_treble_shelf_a1(
> +		struct axd_cmd *cmd, unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_treble_shelf_a1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_treble_shelf_a2(
> +		struct axd_cmd *cmd, unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_treble_shelf_a2_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_treble_shelf_b0(
> +		struct axd_cmd *cmd, unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_treble_shelf_b0_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_treble_shelf_b1(
> +		struct axd_cmd *cmd, unsigned int pipe, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +
> +	reg = axd_get_output_dcpp_channel_treble_shelf_b1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_eq_gain(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int band)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_gain_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_eq_a0(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int band)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_a0_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_eq_a1(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int band)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_a1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_eq_a2(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int band)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_a2_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_eq_b0(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int band)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_b0_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_eq_b1(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int band)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_b1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_channel_eq_shift(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int channel, unsigned int band)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, false, channel);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_shift_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_eq_bands(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_output_dcpp_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return (control & AXD_DCPP_CTRL_SUBBAND_EQ_BANDS_BITS)
> +				>> AXD_DCPP_CTRL_SUBBAND_EQ_BANDS_SHIFT;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_enabled(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_output_dcpp_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return (control & AXD_DCPP_CTRL_SUBBAND_ENABLE_BITS)
> +				>> AXD_DCPP_CTRL_SUBBAND_ENABLE_SHIFT;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_input_channel_mask(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_output_dcpp_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return (control & AXD_DCPP_CTRL_SUBBAND_CHANNEL_MASK_BITS)
> +				>> AXD_DCPP_CTRL_SUBBAND_CHANNEL_MASK_SHIFT;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_delay_samples(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +
> +	reg = axd_get_output_dcpp_channel_delay_samples_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_eq_output_volume(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +
> +	reg = axd_get_output_dcpp_channel_eq_output_volume_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_eq_passthrough_gain(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +
> +	reg = axd_get_output_dcpp_channel_eq_passthrough_gain_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_eq_inverse_passthrough_gain(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +
> +	reg = axd_get_output_dcpp_channel_eq_inverse_passthrough_gain_reg(cmd,
> +									pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_eq_gain(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int band)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_gain_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_eq_a0(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int band)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_a0_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_eq_a1(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int band)
> +{
> +	unsigned int control;
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_a1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_eq_a2(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int band)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_a2_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_eq_b0(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int band)
> +{
> +	unsigned int control;
> +	unsigned int reg;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_b0_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_eq_b1(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int band)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_b1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_eq_shift(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int band)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	axd_cmd_output_dcpp_select_channel(cmd, pipe, true, 0);
> +	axd_cmd_output_dcpp_select_band(cmd, pipe, band);
> +
> +	reg = axd_get_output_dcpp_channel_eq_shift_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_low_pass_filter_a0(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	reg = axd_get_output_dcpp_subband_low_pass_filter_a0_reg(cmd, pipe);
> +
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_low_pass_filter_a1(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	reg = axd_get_output_dcpp_subband_low_pass_filter_a1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_low_pass_filter_a2(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	reg = axd_get_output_dcpp_subband_low_pass_filter_a2_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_low_pass_filter_b0(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	reg = axd_get_output_dcpp_subband_low_pass_filter_b0_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> +
> +unsigned int axd_cmd_output_get_dcpp_subband_low_pass_filter_b1(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +
> +	reg = axd_get_output_dcpp_subband_low_pass_filter_b1_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return 0;
> +	axd_read_reg(cmd, reg, &control);
> +	return control;
> +}
> diff --git a/drivers/char/axd/axd_cmds_internal.c b/drivers/char/axd/axd_cmds_internal.c
> new file mode 100644
> index 000000000000..1e23d1329193
> --- /dev/null
> +++ b/drivers/char/axd/axd_cmds_internal.c
> @@ -0,0 +1,3237 @@
> +/*
> + * Copyright (C) 2011-2014 Imagination Technologies Ltd.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * Common functionality required by other axd_cmds_*.c files.
> + */
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/sched.h>
> +
> +#include "axd_cmds_internal.h"
> +#include "axd_module.h"
> +#include "axd_platform.h"
> +
> +#define WRONG_PIPE_STR		"Wrong pipe number: %d\n"
> +#define WRONG_BAND_STR		"Wrong band number: %d\n"
> +
> +/*
> + * Send/Clear control kick.
> + *
> + * NOTE:
> + * Must acquire axd_platform_lock() before accessing kick and interrupt status
> + * registers as the AXD firmware might be accessing them at the same time.
> + */
> +inline void axd_ctrl_kick(struct axd_memory_map __iomem *message)
> +{
> +	unsigned long flags;
> +	unsigned int temp;
> +
> +	flags = axd_platform_lock();
> +	temp = ioread32(&message->kick) | AXD_ANY_KICK_BIT | AXD_KICK_CTRL_BIT;
> +	iowrite32(temp, &message->kick);
> +	axd_platform_unlock(flags);
> +	axd_platform_kick();
> +}
> +inline void axd_kick_status_clear(struct axd_memory_map __iomem *message)
> +{
> +	unsigned long flags;
> +	unsigned int temp;
> +
> +	flags = axd_platform_lock();
> +	temp = ioread32(&message->int_status) & ~AXD_INT_KICK_DONE;
> +	iowrite32(temp, &message->int_status);
> +	axd_platform_unlock(flags);
> +}
> +/*
> + * Wait until axd is ready again. Must be called while cm_lock is held.
> + */
> +int axd_wait_ready(struct axd_memory_map __iomem *message)
> +{
> +#define BUSYWAIT_TIME		1
> +#define BUSYWAIT_TIMEOUT	100
> +	unsigned int timeout = 0;
> +
> +	while (ioread32(&message->control_command) != AXD_CTRL_CMD_READY) {
> +		mdelay(BUSYWAIT_TIME);
> +		timeout += BUSYWAIT_TIME;
> +		if (timeout == BUSYWAIT_TIMEOUT)
> +			return -1;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Reads a register from the MemoryMapped register interface.
> + * @cmd: pointer to initialized struct axd_cmd.
> + * @reg: the register address to be accessed.
> + */
> +int axd_read_reg(struct axd_cmd *cmd, unsigned int reg, unsigned int *data)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	struct axd_memory_map __iomem *message = cmd->message;
> +	struct mutex *cm_lock = &cmd->cm_lock;
> +	int ret;
> +
> +	mutex_lock(cm_lock);
> +	if (axd_get_flag(&cmd->fw_stopped_flg)) {
> +		mutex_unlock(cm_lock);
> +		return -1;
> +	}
> +	axd_set_flag(&cmd->response_flg, 0);
> +	iowrite32(AXD_CTRL_CMD_READ_REGISTER | reg, &message->control_command);
> +	axd_ctrl_kick(message);
> +	ret = wait_event_timeout(cmd->wait,
> +			axd_get_flag(&cmd->response_flg) != 0, CMD_TIMEOUT);
> +	*data = ioread32(&message->control_data);
> +	mutex_unlock(cm_lock);
> +	if (!ret) {
> +		dev_warn(axd->dev, "failed to read reg 0x%04X\n", reg);
> +		*data = 0;
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Writes control data to the MemoryMapped control interface.
> + * We assume that cm_lock is held before this function is called.
> + * @cmd: pointer to initialized struct axd_cmd.
> + * @ctrl_command: the control command to write.
> + * @ctrl_data: the control value to write.
> + */
> +int axd_write_ctrl(struct axd_cmd *cmd, unsigned int ctrl_command,
> +						unsigned int ctrl_data)
> +{
> +	struct axd_memory_map __iomem *message = cmd->message;
> +	int ret;
> +
> +	axd_set_flag(&cmd->response_flg, 0);
> +	iowrite32(ctrl_data, &message->control_data);
> +	iowrite32(ctrl_command, &message->control_command);
> +	axd_ctrl_kick(message);
> +	ret = wait_event_timeout(cmd->wait,
> +			axd_get_flag(&cmd->response_flg) != 0, CMD_TIMEOUT);
> +	return ret;
> +}
> +
> +/*
> + * Writes value to a register int the MemoryMapped register interface.
> + * @cmd: pointer to initialized struct axd_cmd.
> + * @reg: the register address to be accessed.
> + * @value: the new value to write.
> + */
> +int axd_write_reg(struct axd_cmd *cmd, unsigned int reg, unsigned int value)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	struct mutex *cm_lock = &cmd->cm_lock;
> +	int ret;
> +
> +	mutex_lock(cm_lock);
> +	if (axd_get_flag(&cmd->fw_stopped_flg)) {
> +		mutex_unlock(cm_lock);
> +		return -1;
> +	}
> +	ret = axd_write_ctrl(cmd, AXD_CTRL_CMD_WRITE_REGISTER | reg, value);
> +	mutex_unlock(cm_lock);
> +	if (!ret) {
> +		dev_warn(axd->dev, "failed to write reg 0x%04X\n", reg);
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +int axd_write_reg_buf(struct axd_cmd *cmd, unsigned int reg, unsigned int value)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	struct mutex *cm_lock = &cmd->cm_lock;
> +	struct axd_ctrlbuf_item __iomem *buf;
> +	unsigned int ctrlbuf_ctrl = ioread32(&cmd->message->ctrlbuf_ctrl);
> +	unsigned int ctrlbuf_size = ioread32(&cmd->message->ctrlbuf_size);
> +	unsigned int temp;
> +
> +	if (!axd_get_flag(&cmd->ctrlbuf_active_flg)) {
> +		/* If the ctrlbuf isn't active, fall back to simple reg write */
> +		return axd_write_reg(cmd, reg, value);
> +	}
> +
> +	mutex_lock(cm_lock);
> +	if (axd_get_flag(&cmd->fw_stopped_flg)) {
> +		mutex_unlock(cm_lock);
> +		return -1;
> +	}
> +
> +	if (ctrlbuf_ctrl >= ctrlbuf_size) {
> +		mutex_unlock(cm_lock);
> +		dev_err(axd->dev, "Could not write to ctrlbuf: full\n");
> +		return -1;
> +	}
> +
> +	buf = &cmd->message->ctrlbuf[ctrlbuf_ctrl];
> +
> +	iowrite32(AXD_CTRL_CMD_WRITE_REGISTER | reg, &buf->reg);
> +	iowrite32(value, &buf->val);
> +
> +	temp = ioread32(&cmd->message->ctrlbuf_ctrl) + 1;
> +	iowrite32(temp, &cmd->message->ctrlbuf_ctrl);
> +
> +	mutex_unlock(cm_lock);
> +
> +	return 0;
> +}
> +
> +int axd_flush_reg_buf(struct axd_cmd *cmd)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	struct mutex *cm_lock = &cmd->cm_lock;
> +	int ret;
> +
> +	mutex_lock(cm_lock);
> +	if (axd_get_flag(&cmd->fw_stopped_flg)) {
> +		mutex_unlock(cm_lock);
> +		return -1;
> +	}
> +
> +	if (ioread32(&cmd->message->ctrlbuf_ctrl) == 0) {
> +		mutex_unlock(cm_lock);
> +		dev_warn(axd->dev, "Tried to flush empty ctrlbuf\n");
> +		return -1;
> +	}
> +
> +	ret = axd_write_ctrl(cmd, AXD_CTRL_CMD_CTRLBUF_FLUSH, 0);
> +	if (!ret) {
> +		/* Drop buffer and ignore any response */
> +		iowrite32(0, &cmd->message->ctrlbuf_ctrl);
> +
> +		mutex_unlock(cm_lock);
> +		dev_err(axd->dev, "Could not write control command to flush buffer");
> +		return -EIO;
> +	}
> +
> +	/* Ignore any response */
> +	iowrite32(0, &cmd->message->ctrlbuf_ctrl);
> +
> +	mutex_unlock(cm_lock);
> +
> +	return 0;
> +}
> +
> +/* Returns the address of the correct mixer mux register for @pipe */
> +unsigned int axd_get_mixer_mux_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_MUX0;
> +		break;
> +	case 1:
> +		reg = AXD_REG_MUX1;
> +		break;
> +	case 2:
> +		reg = AXD_REG_MUX2;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the number of the currently set input codec */
> +unsigned int axd_get_input_codec_number(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_input_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return -1;
> +	axd_read_reg(cmd, reg, &control);
> +	return (control & AXD_INCTRL_CODEC_BITS) >> AXD_INCTRL_CODEC_SHIFT;
> +}
> +
> +/* Returns the address of the correct input control register for @pipe */
> +unsigned int axd_get_input_control_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_INPUT0_CONTROL;
> +		break;
> +	case 1:
> +		reg = AXD_REG_INPUT1_CONTROL;
> +		break;
> +	case 2:
> +		reg = AXD_REG_INPUT2_CONTROL;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the correct input gain register for @pipe */
> +unsigned int axd_get_input_gain_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_INPUT0_GAIN;
> +		break;
> +	case 1:
> +		reg = AXD_REG_INPUT1_GAIN;
> +		break;
> +	case 2:
> +		reg = AXD_REG_INPUT2_GAIN;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the correct input mute register for @pipe */
> +unsigned int axd_get_input_mute_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_INPUT0_MUTE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_INPUT1_MUTE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_INPUT2_MUTE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the correct input UpMix register for @pipe */
> +unsigned int axd_get_input_upmix_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_INPUT0_UPMIX;
> +		break;
> +	case 1:
> +		reg = AXD_REG_INPUT1_UPMIX;
> +		break;
> +	case 2:
> +		reg = AXD_REG_INPUT2_UPMIX;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the correct input bufer occupancy reg for @pipe */
> +unsigned int axd_get_input_buffer_occupancy_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_INPUT0_BUFFER_OCCUPANCY;
> +		break;
> +	case 1:
> +		reg = AXD_REG_INPUT1_BUFFER_OCCUPANCY;
> +		break;
> +	case 2:
> +		reg = AXD_REG_INPUT2_BUFFER_OCCUPANCY;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the number of the currently set output codec */
> +unsigned int axd_get_output_codec_number(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	unsigned int reg = axd_get_output_control_reg(cmd, pipe);
> +	unsigned int control;
> +
> +	if (unlikely(!reg))
> +		return -1;
> +	axd_read_reg(cmd, reg, &control);
> +	return (control & AXD_OUTCTRL_CODEC_BITS) >> AXD_OUTCTRL_CODEC_SHIFT;
> +}
> +
> +/* Returns the address of the correct output control register for @pipe */
> +unsigned int axd_get_output_control_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_CONTROL;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_CONTROL;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_CONTROL;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the correct output DownMix register for @pipe */
> +unsigned int axd_get_output_downmix_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DOWNMIX;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DOWNMIX;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DOWNMIX;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/*
> + * Returns the address of the output EQ Ctrl / Master Gain register for
> + * @pipe
> + */
> +unsigned int axd_get_output_eqcontrol_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_EQCTRL;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_EQCTRL;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_EQCTRL;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the output EQ Band0 register for @pipe*/
> +unsigned int axd_get_output_eqband0_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_EQBAND0;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_EQBAND0;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_EQBAND0;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the output EQ Band1 register for @pipe*/
> +unsigned int axd_get_output_eqband1_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_EQBAND1;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_EQBAND1;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_EQBAND1;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the output EQ Band2 register for @pipe*/
> +unsigned int axd_get_output_eqband2_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_EQBAND2;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_EQBAND2;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_EQBAND2;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the output EQ Band3 register for @pipe*/
> +unsigned int axd_get_output_eqband3_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_EQBAND3;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_EQBAND3;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_EQBAND3;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the output EQ Band4 register for @pipe*/
> +unsigned int axd_get_output_eqband4_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_EQBAND4;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_EQBAND4;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_EQBAND4;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* DCPP */
> +
> +int axd_cmd_output_dcpp_select_channel(struct axd_cmd *cmd, unsigned int pipe,
> +					bool subband, unsigned int channel)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +	int ret;
> +
> +	reg = axd_get_output_dcpp_channel_ctrl_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	/* Generate channel selector */
> +	control = 0;
> +
> +	if (subband)
> +		control = AXD_DCPP_CHANNEL_CTRL_SUBBAND_BITS;
> +	else
> +		control = channel << AXD_DCPP_CHANNEL_CTRL_CHANNEL_SHIFT;
> +
> +	/* Compare with last channel selector */
> +	if (control == cmd->dcpp_channel_ctrl_cache[pipe]) {
> +		ret = 0;
> +	} else {
> +		ret = axd_write_reg_buf(cmd, reg, control);
> +		cmd->dcpp_channel_ctrl_cache[pipe] = control;
> +	}
> +
> +	return ret;
> +}
> +
> +int axd_cmd_output_dcpp_select_band(struct axd_cmd *cmd, unsigned int pipe,
> +							unsigned int band)
> +{
> +	unsigned int reg;
> +	unsigned int control;
> +	int ret;
> +
> +	reg = axd_get_output_dcpp_band_ctrl_reg(cmd, pipe);
> +	if (unlikely(!reg))
> +		return -1;
> +
> +	/* Generate band selector */
> +	control = band;
> +
> +	/* Compare with last band selector */
> +	if (control == cmd->dcpp_band_ctrl_cache[pipe]) {
> +		ret = 0;
> +	} else {
> +		ret = axd_write_reg_buf(cmd, reg, control);
> +		cmd->dcpp_band_ctrl_cache[pipe] = control;
> +	}
> +
> +	return ret;
> +}
> +
> +unsigned int axd_get_output_dcpp_control_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CONTROL;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CONTROL;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CONTROL;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_max_delay_samples_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_MAX_DELAY_SAMPLES;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_MAX_DELAY_SAMPLES;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_MAX_DELAY_SAMPLES;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_ctrl_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg = 0;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_CONTROL;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_CONTROL;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_CONTROL;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_band_ctrl_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg = 0;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_BAND_CONTROL;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_BAND_CONTROL;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_BAND_CONTROL;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_delay_samples_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_DELAY_SAMPLES;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_DELAY_SAMPLES;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_DELAY_SAMPLES;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_eq_output_volume_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_OUTPUT_VOLUME;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_OUTPUT_VOLUME;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_OUTPUT_VOLUME;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_eq_passthrough_gain_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_PASSTHROUGH_GAIN;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_PASSTHROUGH_GAIN;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_PASSTHROUGH_GAIN;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_eq_inverse_passthrough_gain_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_INVERSE_PASSTHROUGH_GAIN;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_INVERSE_PASSTHROUGH_GAIN;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_INVERSE_PASSTHROUGH_GAIN;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_bass_shelf_shift_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_BASS_SHELF_SHIFT;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_BASS_SHELF_SHIFT;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_BASS_SHELF_SHIFT;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_bass_shelf_a0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_BASS_SHELF_A0;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_BASS_SHELF_A0;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_BASS_SHELF_A0;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_bass_shelf_a1_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_BASS_SHELF_A1;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_BASS_SHELF_A1;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_BASS_SHELF_A1;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_bass_shelf_a2_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_BASS_SHELF_A2;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_BASS_SHELF_A2;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_BASS_SHELF_A2;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_bass_shelf_b0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_BASS_SHELF_B0;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_BASS_SHELF_B0;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_BASS_SHELF_B0;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_bass_shelf_b1_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_BASS_SHELF_B1;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_BASS_SHELF_B1;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_BASS_SHELF_B1;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_treble_shelf_shift_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_TREBLE_SHELF_SHIFT;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_TREBLE_SHELF_SHIFT;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_TREBLE_SHELF_SHIFT;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_treble_shelf_a0_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_TREBLE_SHELF_A0;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_TREBLE_SHELF_A0;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_TREBLE_SHELF_A0;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_treble_shelf_a1_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_TREBLE_SHELF_A1;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_TREBLE_SHELF_A1;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_TREBLE_SHELF_A1;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_treble_shelf_a2_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_TREBLE_SHELF_A2;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_TREBLE_SHELF_A2;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_TREBLE_SHELF_A2;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_treble_shelf_b0_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_TREBLE_SHELF_B0;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_TREBLE_SHELF_B0;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_TREBLE_SHELF_B0;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_treble_shelf_b1_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_TREBLE_SHELF_B1;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_TREBLE_SHELF_B1;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_TREBLE_SHELF_B1;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_eq_gain_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_GAIN;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_GAIN;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_GAIN;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_eq_a0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_A0;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_A0;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_A0;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_eq_a1_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_A1;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_A1;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_A1;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_eq_a2_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_A2;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_A2;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_A2;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_eq_b0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_B0;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_B0;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_B0;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_eq_b1_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_B1;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_B1;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_B1;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_channel_eq_shift_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_CHANNEL_EQ_BAND_SHIFT;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_CHANNEL_EQ_BAND_SHIFT;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_CHANNEL_EQ_BAND_SHIFT;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_subband_low_pass_filter_a0_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg = 0;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_SUBBAND_LOW_PASS_FILTER_A0;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_SUBBAND_LOW_PASS_FILTER_A0;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_SUBBAND_LOW_PASS_FILTER_A0;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_subband_low_pass_filter_a1_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg = 0;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_SUBBAND_LOW_PASS_FILTER_A1;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_SUBBAND_LOW_PASS_FILTER_A1;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_SUBBAND_LOW_PASS_FILTER_A1;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_subband_low_pass_filter_a2_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg = 0;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_SUBBAND_LOW_PASS_FILTER_A2;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_SUBBAND_LOW_PASS_FILTER_A2;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_SUBBAND_LOW_PASS_FILTER_A2;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_subband_low_pass_filter_b0_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg = 0;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_SUBBAND_LOW_PASS_FILTER_B0;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_SUBBAND_LOW_PASS_FILTER_B0;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_SUBBAND_LOW_PASS_FILTER_B0;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_dcpp_subband_low_pass_filter_b1_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg = 0;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_OUTPUT0_DCPP_SUBBAND_LOW_PASS_FILTER_B1;
> +		break;
> +	case 1:
> +		reg = AXD_REG_OUTPUT1_DCPP_SUBBAND_LOW_PASS_FILTER_B1;
> +		break;
> +	case 2:
> +		reg = AXD_REG_OUTPUT2_DCPP_SUBBAND_LOW_PASS_FILTER_B1;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the aac version for decoder at @pipe*/
> +unsigned int axd_get_decoder_aac_version_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_AAC_VERSION;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_AAC_VERSION;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_AAC_VERSION;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the aac pipes for decoder at @pipe*/
> +unsigned int axd_get_decoder_aac_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_AAC_CHANNELS;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_AAC_CHANNELS;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_AAC_CHANNELS;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the aac profile for decoder at @pipe*/
> +unsigned int axd_get_decoder_aac_profile_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_AAC_PROFILE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_AAC_PROFILE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_AAC_PROFILE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the aac stream type for decoder at @pipe*/
> +unsigned int axd_get_decoder_aac_streamtype_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_AAC_STREAM_TYPE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_AAC_STREAM_TYPE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_AAC_STREAM_TYPE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the aac stream type for decoder at @pipe*/
> +unsigned int axd_get_decoder_aac_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_AAC_SAMPLERATE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_AAC_SAMPLERATE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_AAC_SAMPLERATE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_decoder_ac3_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_AC3_CHANNELS;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_AC3_CHANNELS;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_AC3_CHANNELS;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_decoder_ac3_channel_order_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_AC3_CHANNEL_ORDER;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_AC3_CHANNEL_ORDER;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_AC3_CHANNEL_ORDER;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_decoder_ac3_mode_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_AC3_MODE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_AC3_MODE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_AC3_MODE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the cook flavour for decoder at @pipe*/
> +unsigned int axd_get_decoder_cook_flavour_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_COOK_FLAVOUR;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_COOK_FLAVOUR;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_COOK_FLAVOUR;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the flac pipes for decoder at @pipe*/
> +unsigned int axd_get_decoder_flac_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_FLAC_CHANNELS;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_FLAC_CHANNELS;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_FLAC_CHANNELS;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the flac sample rate for decoder at @pipe*/
> +unsigned int axd_get_decoder_flac_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_FLAC_SAMPLERATE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_FLAC_SAMPLERATE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_FLAC_SAMPLERATE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the flac bits per sample for decoder at @pipe*/
> +unsigned int axd_get_decoder_flac_bitspersample_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_FLAC_BITS_PER_SAMPLE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_FLAC_BITS_PER_SAMPLE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_FLAC_BITS_PER_SAMPLE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the flac md5 checking for decoder at @pipe*/
> +unsigned int axd_get_decoder_flac_md5checking_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_FLAC_MD5_CHECKING;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_FLAC_MD5_CHECKING;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_FLAC_MD5_CHECKING;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the mpeg num pipes for decoder at @pipe*/
> +unsigned int axd_get_decoder_mpeg_numchannels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_MPEG_CHANNELS;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_MPEG_CHANNELS;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_MPEG_CHANNELS;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the mpeg mlchannel for decoder at @pipe*/
> +unsigned int axd_get_decoder_mpeg_mlchannel_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_MPEG_MLCHANNEL;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_MPEG_MLCHANNEL;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_MPEG_MLCHANNEL;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma player opt for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_playeropt_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_PLAYER_OPT;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_PLAYER_OPT;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_PLAYER_OPT;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma player drc setting for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_drcsetting_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_DRC_SETTING;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_DRC_SETTING;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_DRC_SETTING;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma player peak ref for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_peakampref_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_PEAK_AMP_REF;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_PEAK_AMP_REF;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_PEAK_AMP_REF;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma player rms ref for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_rmsampref_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_RMS_AMP_REF;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_RMS_AMP_REF;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_RMS_AMP_REF;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma player peak target for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_peakamptarget_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_PEAK_AMP_TARGET;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_PEAK_AMP_TARGET;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_PEAK_AMP_TARGET;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma player rms target for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_rmsamptarget_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_RMS_AMP_TARGET;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC2_WMA_RMS_AMP_TARGET;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC1_WMA_RMS_AMP_TARGET;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma pcm valid bits for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_pcmvalidbitspersample_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_PCM_VAL_BITS_PER_SAMPLE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_PCM_VAL_BITS_PER_SAMPLE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_PCM_VAL_BITS_PER_SAMPLE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma pcm container size for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_pcmcontainersize_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_PCM_CONTAINER_SIZE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_PCM_CONTAINER_SIZE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_PCM_CONTAINER_SIZE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma format tag for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_wmaformattag_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_WMA_FORMAT_TAG;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_WMA_FORMAT_TAG;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_WMA_FORMAT_TAG;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma format num pipes for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_wmanumchannels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_WMA_CHANNELS;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_WMA_CHANNELS;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_WMA_CHANNELS;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma format sample/s for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_wmasamplespersec_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_WMA_SAMPLES_PER_SEC;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_WMA_SAMPLES_PER_SEC;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_WMA_SAMPLES_PER_SEC;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/*
> + * Returns the address of the wma format average bytes per sample for decoder
> + * at @pipe
> + */
> +unsigned int axd_get_decoder_wma_wmaaveragebytespersec_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_WMA_AVG_BYTES_PER_SEC;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_WMA_AVG_BYTES_PER_SEC;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_WMA_AVG_BYTES_PER_SEC;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma format block align for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_wmablockalign_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_WMA_BLOCK_ALIGN;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_WMA_BLOCK_ALIGN;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_WMA_BLOCK_ALIGN;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma format valid bits for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_wmavalidbitspersample_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_WMA_VAL_BITS_PER_SAMPLE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_WMA_VAL_BITS_PER_SAMPLE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_WMA_VAL_BITS_PER_SAMPLE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma format pipe mask for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_wmachannelmask_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_WMA_CHANNEL_MASK;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_WMA_CHANNEL_MASK;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_WMA_CHANNEL_MASK;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the wma format encode options for decoder at @pipe*/
> +unsigned int axd_get_decoder_wma_wmaencodeoptions_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_WMA_WMA_ENCODE_OPTS;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_WMA_WMA_ENCODE_OPTS;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_WMA_WMA_ENCODE_OPTS;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the pcm samplerate reg for decoder at @pipe*/
> +unsigned int axd_get_decoder_pcm_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_PCMIN0_SAMPLE_RATE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_PCMIN1_SAMPLE_RATE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_PCMIN2_SAMPLE_RATE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the pcm channels reg for decoder at @pipe*/
> +unsigned int axd_get_decoder_pcm_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_PCMIN0_CHANNELS;
> +		break;
> +	case 1:
> +		reg = AXD_REG_PCMIN1_CHANNELS;
> +		break;
> +	case 2:
> +		reg = AXD_REG_PCMIN2_CHANNELS;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the pcm bitspersample reg for decoder at @pipe*/
> +unsigned int axd_get_decoder_pcm_bitspersample_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_PCMIN0_BITS_PER_SAMPLE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_PCMIN1_BITS_PER_SAMPLE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_PCMIN2_BITS_PER_SAMPLE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +/* Returns the address of the pcm justification reg for decoder at @pipe*/
> +unsigned int axd_get_decoder_pcm_justification_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_PCMIN0_JUSTIFICATION;
> +		break;
> +	case 1:
> +		reg = AXD_REG_PCMIN1_JUSTIFICATION;
> +		break;
> +	case 2:
> +		reg = AXD_REG_PCMIN2_JUSTIFICATION;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_decoder_ddplus_config_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_DDPLUS_CONFIG;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_DDPLUS_CONFIG;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_DDPLUS_CONFIG;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_decoder_ddplus_channel_order_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_DDPLUS_CHANNEL_ORDER;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_DDPLUS_CHANNEL_ORDER;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_DDPLUS_CHANNEL_ORDER;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_decoder_alac_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_ALAC_CHANNELS;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_ALAC_CHANNELS;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_ALAC_CHANNELS;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_decoder_alac_depth_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_ALAC_DEPTH;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_ALAC_DEPTH;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_ALAC_DEPTH;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_decoder_alac_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_ALAC_SAMPLE_RATE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_ALAC_SAMPLE_RATE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_ALAC_SAMPLE_RATE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_decoder_alac_framelength_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_ALAC_FRAME_LENGTH;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_ALAC_FRAME_LENGTH;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_ALAC_FRAME_LENGTH;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_decoder_alac_maxframebytes_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_ALAC_MAX_FRAME_BYTES;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_ALAC_MAX_FRAME_BYTES;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_ALAC_MAX_FRAME_BYTES;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_decoder_alac_avgbitrate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_ALAC_AVG_BIT_RATE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_ALAC_AVG_BIT_RATE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_ALAC_AVG_BIT_RATE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_decoder_sbc_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_SBC_SAMPLE_RATE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_SBC_SAMPLE_RATE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_SBC_SAMPLE_RATE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_decoder_sbc_audiomode_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_SBC_AUDIO_MODE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_SBC_AUDIO_MODE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_SBC_AUDIO_MODE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_decoder_sbc_blocks_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_SBC_BLOCKS;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_SBC_BLOCKS;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_SBC_BLOCKS;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_decoder_sbc_subbands_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_SBC_SUBBANDS;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_SBC_SUBBANDS;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_SBC_SUBBANDS;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_decoder_sbc_bitpool_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_SBC_BITPOOL;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_SBC_BITPOOL;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_SBC_BITPOOL;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_decoder_sbc_allocationmode_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_DEC0_SBC_ALLOCATION_MODE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_DEC1_SBC_ALLOCATION_MODE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_DEC2_SBC_ALLOCATION_MODE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +
> +unsigned int axd_get_decoder_ms11_mode_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	return AXD_REG_MS11_MODE;
> +}
> +
> +unsigned int axd_get_decoder_ms11_common_config0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	return AXD_REG_MS11_COMMON_CONFIG0;
> +}
> +
> +unsigned int axd_get_decoder_ms11_common_config1_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	return AXD_REG_MS11_COMMON_CONFIG1;
> +}
> +
> +unsigned int axd_get_decoder_ms11_ddt_config0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	return AXD_REG_MS11_DDT_CONFIG0;
> +}
> +
> +unsigned int axd_get_decoder_ms11_ddc_config0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	return AXD_REG_MS11_DDC_CONFIG0;
> +}
> +
> +unsigned int axd_get_decoder_ms11_ext_pcm_config0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	return AXD_REG_MS11_EXT_PCM_CONFIG0;
> +}
> +
> +/* Returns the address of the pcm bitspersample reg for output at @pipe*/
> +unsigned int axd_get_encoder_pcm_bitspersample_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_PCMOUT0_BITS_PER_SAMPLE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_PCMOUT1_BITS_PER_SAMPLE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_PCMOUT2_BITS_PER_SAMPLE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_encoder_flac_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_CHANNELS;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_CHANNELS;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_CHANNELS;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_flac_bitspersample_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_BITS_PER_SAMPLE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_BITS_PER_SAMPLE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_BITS_PER_SAMPLE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_flac_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_SAMPLE_RATE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_SAMPLE_RATE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_SAMPLE_RATE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_flac_totalsamples_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_TOTAL_SAMPLES;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_TOTAL_SAMPLES;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_TOTAL_SAMPLES;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_flac_domidsidestereo_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_DO_MID_SIDE_STEREO;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_DO_MID_SIDE_STEREO;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_DO_MID_SIDE_STEREO;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_flac_loosemidsidestereo_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_LOOSE_MID_SIDE_STEREO;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_LOOSE_MID_SIDE_STEREO;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_LOOSE_MID_SIDE_STEREO;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_flac_doexhaustivemodelsearch_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_DO_EXHAUSTIVE_MODEL_SEARCH;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_DO_EXHAUSTIVE_MODEL_SEARCH;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_DO_EXHAUSTIVE_MODEL_SEARCH;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_flac_minresidualpartitionorder_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_MIN_RESIDUAL_PARTITION_ORDER;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_MIN_RESIDUAL_PARTITION_ORDER;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_MIN_RESIDUAL_PARTITION_ORDER;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_flac_maxresidualpartitionorder_reg(
> +					struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_MAX_RESIDUAL_PARTITION_ORDER;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_MAX_RESIDUAL_PARTITION_ORDER;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_MAX_RESIDUAL_PARTITION_ORDER;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_flac_blocksize_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_BLOCK_SIZE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_BLOCK_SIZE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_BLOCK_SIZE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_flac_bytecount_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_BYTE_COUNT;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_BYTE_COUNT;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_BYTE_COUNT;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_flac_samplecount_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_SAMPLE_COUNT;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_SAMPLE_COUNT;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_SAMPLE_COUNT;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_flac_framecount_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_FRAME_COUNT;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_FRAME_COUNT;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_FRAME_COUNT;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_flac_framebytes_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_FLAC_FRAME_BYTES;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_FLAC_FRAME_BYTES;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_FLAC_FRAME_BYTES;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_encoder_alac_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_ALAC_CHANNELS;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_ALAC_CHANNELS;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_ALAC_CHANNELS;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_alac_depth_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_ALAC_DEPTH;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_ALAC_DEPTH;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_ALAC_DEPTH;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_alac_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_ALAC_SAMPLE_RATE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_ALAC_SAMPLE_RATE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_ALAC_SAMPLE_RATE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_alac_framelength_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_ALAC_FRAME_LENGTH;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_ALAC_FRAME_LENGTH;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_ALAC_FRAME_LENGTH;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_alac_maxframebytes_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_ALAC_MAX_FRAME_BYTES;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_ALAC_MAX_FRAME_BYTES;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_ALAC_MAX_FRAME_BYTES;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_alac_avgbitrate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_ALAC_AVG_BIT_RATE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_ALAC_AVG_BIT_RATE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_ALAC_AVG_BIT_RATE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +unsigned int axd_get_encoder_alac_fastmode_reg(struct axd_cmd *cmd,
> +							unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_ENC0_ALAC_FAST_MODE;
> +		break;
> +	case 1:
> +		reg = AXD_REG_ENC1_ALAC_FAST_MODE;
> +		break;
> +	case 2:
> +		reg = AXD_REG_ENC2_ALAC_FAST_MODE;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_eq_power_reg_ch0_3(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int band)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg = 0;
> +
> +	if (pipe == 0) {
> +		switch (band) {
> +		case 0:
> +			reg = AXD_REG_EQ_OUT0_POWER_B0_C0_C3;
> +			break;
> +		case 1:
> +			reg = AXD_REG_EQ_OUT0_POWER_B1_C0_C3;
> +			break;
> +		case 2:
> +			reg = AXD_REG_EQ_OUT0_POWER_B2_C0_C3;
> +			break;
> +		case 3:
> +			reg = AXD_REG_EQ_OUT0_POWER_B3_C0_C3;
> +			break;
> +		case 4:
> +			reg = AXD_REG_EQ_OUT0_POWER_B4_C0_C3;
> +			break;
> +		default:
> +			dev_err(axd->dev, WRONG_BAND_STR, band);
> +			return 0;
> +		}
> +	} else if (pipe == 1) {
> +		switch (band) {
> +		case 0:
> +			reg = AXD_REG_EQ_OUT1_POWER_B0_C0_C3;
> +			break;
> +		case 1:
> +			reg = AXD_REG_EQ_OUT1_POWER_B1_C0_C3;
> +			break;
> +		case 2:
> +			reg = AXD_REG_EQ_OUT1_POWER_B2_C0_C3;
> +			break;
> +		case 3:
> +			reg = AXD_REG_EQ_OUT1_POWER_B3_C0_C3;
> +			break;
> +		case 4:
> +			reg = AXD_REG_EQ_OUT1_POWER_B4_C0_C3;
> +			break;
> +		default:
> +			dev_err(axd->dev, WRONG_BAND_STR, band);
> +			return 0;
> +		}
> +	} else if (pipe == 2) {
> +		switch (band) {
> +		case 0:
> +			reg = AXD_REG_EQ_OUT2_POWER_B0_C0_C3;
> +			break;
> +		case 1:
> +			reg = AXD_REG_EQ_OUT2_POWER_B1_C0_C3;
> +			break;
> +		case 2:
> +			reg = AXD_REG_EQ_OUT2_POWER_B2_C0_C3;
> +			break;
> +		case 3:
> +			reg = AXD_REG_EQ_OUT2_POWER_B3_C0_C3;
> +			break;
> +		case 4:
> +			reg = AXD_REG_EQ_OUT2_POWER_B4_C0_C3;
> +			break;
> +		default:
> +			dev_err(axd->dev, WRONG_BAND_STR, band);
> +			return 0;
> +		}
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_output_eq_power_reg_ch4_7(struct axd_cmd *cmd,
> +		unsigned int pipe, unsigned int band)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg = 0;
> +
> +	if (pipe == 0) {
> +		switch (band) {
> +		case 0:
> +			reg = AXD_REG_EQ_OUT0_POWER_B0_C4_C7;
> +			break;
> +		case 1:
> +			reg = AXD_REG_EQ_OUT0_POWER_B1_C4_C7;
> +			break;
> +		case 2:
> +			reg = AXD_REG_EQ_OUT0_POWER_B2_C4_C7;
> +			break;
> +		case 3:
> +			reg = AXD_REG_EQ_OUT0_POWER_B3_C4_C7;
> +			break;
> +		case 4:
> +			reg = AXD_REG_EQ_OUT0_POWER_B4_C4_C7;
> +			break;
> +		default:
> +			dev_err(axd->dev, WRONG_BAND_STR, band);
> +			return 0;
> +		}
> +	} else if (pipe == 1) {
> +		switch (band) {
> +		case 0:
> +			reg = AXD_REG_EQ_OUT1_POWER_B0_C4_C7;
> +			break;
> +		case 1:
> +			reg = AXD_REG_EQ_OUT1_POWER_B1_C4_C7;
> +			break;
> +		case 2:
> +			reg = AXD_REG_EQ_OUT1_POWER_B2_C4_C7;
> +			break;
> +		case 3:
> +			reg = AXD_REG_EQ_OUT1_POWER_B3_C4_C7;
> +			break;
> +		case 4:
> +			reg = AXD_REG_EQ_OUT1_POWER_B4_C4_C7;
> +			break;
> +		default:
> +			dev_err(axd->dev, WRONG_BAND_STR, band);
> +			return 0;
> +		}
> +	} else if (pipe == 2) {
> +		switch (band) {
> +		case 0:
> +			reg = AXD_REG_EQ_OUT2_POWER_B0_C4_C7;
> +			break;
> +		case 1:
> +			reg = AXD_REG_EQ_OUT2_POWER_B1_C4_C7;
> +			break;
> +		case 2:
> +			reg = AXD_REG_EQ_OUT2_POWER_B2_C4_C7;
> +			break;
> +		case 3:
> +			reg = AXD_REG_EQ_OUT2_POWER_B3_C4_C7;
> +			break;
> +		case 4:
> +			reg = AXD_REG_EQ_OUT2_POWER_B4_C4_C7;
> +			break;
> +		default:
> +			dev_err(axd->dev, WRONG_BAND_STR, band);
> +			return 0;
> +		}
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_resample_fin_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_RESAMPLER0_FIN;
> +		break;
> +	case 1:
> +		reg = AXD_REG_RESAMPLER1_FIN;
> +		break;
> +	case 2:
> +		reg = AXD_REG_RESAMPLER2_FIN;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> +
> +unsigned int axd_get_resample_fout_reg(struct axd_cmd *cmd, unsigned int pipe)
> +{
> +	struct axd_dev *axd = container_of(cmd, struct axd_dev, cmd);
> +	unsigned int reg;
> +
> +	switch (pipe) {
> +	case 0:
> +		reg = AXD_REG_RESAMPLER0_FOUT;
> +		break;
> +	case 1:
> +		reg = AXD_REG_RESAMPLER1_FOUT;
> +		break;
> +	case 2:
> +		reg = AXD_REG_RESAMPLER2_FOUT;
> +		break;
> +	default:
> +		dev_err(axd->dev, WRONG_PIPE_STR, pipe);
> +		return 0;
> +	}
> +	return reg;
> +}
> diff --git a/drivers/char/axd/axd_cmds_internal.h b/drivers/char/axd/axd_cmds_internal.h
> new file mode 100644
> index 000000000000..7fa90d0f44ab
> --- /dev/null
> +++ b/drivers/char/axd/axd_cmds_internal.h
> @@ -0,0 +1,306 @@
> +/*
> + * Copyright (C) 2011-2014 Imagination Technologies Ltd.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * Common functionality required by other axd_cmds_*.c files.
> + */
> +#ifndef AXD_CMDS_INTERNAL_H_
> +#define AXD_CMDS_INTERNAL_H_
> +
> +#include <linux/io.h>
> +
> +#include "axd_cmds.h"
> +
> +#ifdef DEBUG_BUFFERS
> +#define debugbuf		printk
> +#else
> +#define debugbuf(format, ...)
> +#endif
> +
> +void axd_ctrl_kick(struct axd_memory_map __iomem *message);
> +void axd_kick_status_clear(struct axd_memory_map __iomem *message);
> +int axd_wait_ready(struct axd_memory_map __iomem *message);
> +
> +int axd_write_ctrl(struct axd_cmd *cmd, unsigned int ctrl_command,
> +						unsigned int ctrl_data);
> +
> +int axd_read_reg(struct axd_cmd *cmd, unsigned int reg, unsigned int *data);
> +int axd_write_reg(struct axd_cmd *cmd, unsigned int reg, unsigned int value);
> +
> +int axd_write_reg_buf(struct axd_cmd *cmd, unsigned int reg,
> +							unsigned int value);
> +
> +unsigned int axd_get_mixer_mux_reg(struct axd_cmd *cmd, unsigned int pipe);
> +
> +unsigned int axd_get_input_codec_number(struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_input_control_reg(struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_input_gain_reg(struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_input_mute_reg(struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_input_upmix_reg(struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_input_buffer_occupancy_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_output_codec_number(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_control_reg(struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_downmix_reg(struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_eqcontrol_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_eqband0_reg(struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_eqband1_reg(struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_eqband2_reg(struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_eqband3_reg(struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_eqband4_reg(struct axd_cmd *cmd, unsigned int pipe);
> +
> +unsigned int axd_get_output_eq_power_reg_ch0_3(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int band);
> +unsigned int axd_get_output_eq_power_reg_ch4_7(struct axd_cmd *cmd,
> +					unsigned int pipe, unsigned int band);
> +
> +unsigned int axd_get_output_dcpp_control_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_max_delay_samples_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_ctrl_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_band_ctrl_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_delay_samples_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_eq_output_volume_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_eq_passthrough_gain_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_eq_inverse_passthrough_gain_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_bass_shelf_shift_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_bass_shelf_a0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_bass_shelf_a1_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_bass_shelf_a2_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_bass_shelf_b0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_bass_shelf_b1_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_treble_shelf_shift_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_treble_shelf_a0_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_treble_shelf_a1_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_treble_shelf_a2_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_treble_shelf_b0_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_treble_shelf_b1_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_eq_gain_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_eq_a0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_eq_a1_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_eq_a2_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_eq_b0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_eq_b1_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_channel_eq_shift_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_subband_input_select_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_output_dcpp_subband_low_pass_filter_a0_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_subband_low_pass_filter_a1_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_subband_low_pass_filter_a2_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_subband_low_pass_filter_b0_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_output_dcpp_subband_low_pass_filter_b1_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +
> +unsigned int axd_get_decoder_aac_version_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_aac_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_aac_profile_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_aac_streamtype_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_aac_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_decoder_ac3_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_ac3_channel_order_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_ac3_mode_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_decoder_cook_flavour_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_decoder_flac_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_flac_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_flac_bitspersample_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_flac_md5checking_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_decoder_mpeg_numchannels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_mpeg_mlchannel_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_decoder_wma_playeropt_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_wma_drcsetting_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_wma_peakampref_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_wma_rmsampref_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_wma_peakamptarget_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_wma_rmsamptarget_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_decoder_wma_pcmvalidbitspersample_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_wma_pcmcontainersize_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_decoder_wma_wmaformattag_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_wma_wmanumchannels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_wma_wmasamplespersec_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_wma_wmaaveragebytespersec_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_wma_wmablockalign_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_wma_wmavalidbitspersample_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_wma_wmachannelmask_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_wma_wmaencodeoptions_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_pcm_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_pcm_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_pcm_bitspersample_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_pcm_justification_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_decoder_ddplus_config_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_ddplus_channel_order_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_decoder_alac_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_alac_depth_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_alac_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_alac_framelength_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_alac_maxframebytes_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_alac_avgbitrate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_decoder_sbc_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_sbc_audiomode_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_sbc_blocks_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_sbc_subbands_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_sbc_bitpool_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_sbc_allocationmode_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_decoder_ms11_mode_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_ms11_common_config0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_ms11_common_config1_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_ms11_ddt_config0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_ms11_ddc_config0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_decoder_ms11_ext_pcm_config0_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_encoder_pcm_bitspersample_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_encoder_flac_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_flac_bitspersample_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_flac_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_flac_totalsamples_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_flac_domidsidestereo_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_flac_loosemidsidestereo_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_flac_doexhaustivemodelsearch_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_encoder_flac_minresidualpartitionorder_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_encoder_flac_maxresidualpartitionorder_reg(
> +					struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_encoder_flac_blocksize_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_flac_bytecount_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_flac_samplecount_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_flac_framecount_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_flac_framebytes_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_encoder_alac_channels_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_alac_depth_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_alac_samplerate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_alac_framelength_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_alac_maxframebytes_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_alac_avgbitrate_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +unsigned int axd_get_encoder_alac_fastmode_reg(struct axd_cmd *cmd,
> +							unsigned int pipe);
> +
> +unsigned int axd_get_resample_fin_reg(struct axd_cmd *cmd, unsigned int pipe);
> +unsigned int axd_get_resample_fout_reg(struct axd_cmd *cmd, unsigned int pipe);
> +
> +void axd_cmd_inpipe_init(struct axd_cmd *cmd, unsigned int pipe);
> +void axd_cmd_outpipe_init(struct axd_cmd *cmd, unsigned int pipe);
> +
> +#endif /* AXD_CMDS_INTERNAL_H_ */
> -- 
> 2.1.0
> 
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel

-- 
