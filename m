Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaHLSFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:05:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59858 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbaHLSFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:05:32 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sound@vger.kernel.org" <linux-sound@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH v2] ASoC: tas2552: Add DAPM calls for amp and PLL
Thread-Topic: [PATCH v2] ASoC: tas2552: Add DAPM calls for amp and PLL
Thread-Index: AQHPraE+TQ5VDIBgX0GxXvqFX2zmug==
Date: Tue, 12 Aug 2014 18:05:25 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49DE4E68@DFLE09.ent.ti.com>
References: <1406908624-15290-1-git-send-email-dmurphy@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump for review

On 08/01/2014 10:57 AM, Murphy, Dan wrote:
> Add DAPM calls to enable/disable the Class D amp.
> Also add a DAPM call to turn off the PLL upon
> the stream completing.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
> 
> v2 - Added proper audio routing map for ClassD and PLL enable/disable - https://patchwork.kernel.org/patch/4586831/
> 
>  sound/soc/codecs/tas2552.c |   68 +++++++++++++++++++++++++++++++-------------
>  1 file changed, 48 insertions(+), 20 deletions(-)
> 
> diff --git a/sound/soc/codecs/tas2552.c b/sound/soc/codecs/tas2552.c
> index 23b3296..1ed57a7 100644
> --- a/sound/soc/codecs/tas2552.c
> +++ b/sound/soc/codecs/tas2552.c
> @@ -78,6 +78,43 @@ struct tas2552_data {
>  	unsigned int mclk;
>  };
>  
> +/* Input mux controls */
> +static const char *tas2552_input_texts[] = {
> +	"Digital", "Analog"
> +};
> +
> +static SOC_ENUM_SINGLE_DECL(tas2552_input_mux_enum, TAS2552_CFG_3, 7,
> +			    tas2552_input_texts);
> +
> +static const struct snd_kcontrol_new tas2552_input_mux_control[] = {
> +	SOC_DAPM_ENUM("Input selection", tas2552_input_mux_enum)
> +};
> +
> +static const struct snd_soc_dapm_widget tas2552_dapm_widgets[] =
> +{
> +	SND_SOC_DAPM_INPUT("IN"),
> +
> +	/* MUX Controls */
> +	SND_SOC_DAPM_MUX("Input selection", SND_SOC_NOPM, 0, 0,
> +				tas2552_input_mux_control),
> +
> +	SND_SOC_DAPM_AIF_IN("DAC IN", "DAC Playback", 0, SND_SOC_NOPM, 0, 0),
> +	SND_SOC_DAPM_DAC("DAC", NULL, SND_SOC_NOPM, 0, 0),
> +	SND_SOC_DAPM_OUT_DRV("ClassD", TAS2552_CFG_2, 7, 0, NULL, 0),
> +	SND_SOC_DAPM_SUPPLY("PLL", TAS2552_CFG_2, 3, 0, NULL, 0),
> +
> +	SND_SOC_DAPM_OUTPUT("OUT")
> +};
> +
> +static const struct snd_soc_dapm_route tas2552_audio_map[] = {
> +	{"DAC", NULL, "DAC IN"},
> +	{"Input selection", "Digital", "DAC"},
> +	{"Input selection", "Analog", "IN"},
> +	{"ClassD", NULL, "Input selection"},
> +	{"OUT", NULL, "ClassD"},
> +	{"ClassD", NULL, "PLL"},
> +};
> +
>  static void tas2552_sw_shutdown(struct tas2552_data *tas_data, int sw_shutdown)
>  {
>  	u8 cfg1_reg;
> @@ -101,10 +138,6 @@ static int tas2552_hw_params(struct snd_pcm_substream *substream,
>  	int d;
>  	u8 p, j;
>  
> -	/* Turn on Class D amplifier */
> -	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN_MASK,
> -						TAS2552_CLASSD_EN);
> -
>  	if (!tas2552->mclk)
>  		return -EINVAL;
>  
> @@ -147,9 +180,6 @@ static int tas2552_hw_params(struct snd_pcm_substream *substream,
>  
>  	}
>  
> -	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE,
> -						TAS2552_PLL_ENABLE);
> -
>  	return 0;
>  }
>  
> @@ -269,19 +299,10 @@ static const struct dev_pm_ops tas2552_pm = {
>  			   NULL)
>  };
>  
> -static void tas2552_shutdown(struct snd_pcm_substream *substream,
> -			   struct snd_soc_dai *dai)
> -{
> -	struct snd_soc_codec *codec = dai->codec;
> -
> -	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE, 0);
> -}
> -
>  static struct snd_soc_dai_ops tas2552_speaker_dai_ops = {
>  	.hw_params	= tas2552_hw_params,
>  	.set_sysclk	= tas2552_set_dai_sysclk,
>  	.set_fmt	= tas2552_set_dai_fmt,
> -	.shutdown	= tas2552_shutdown,
>  	.digital_mute = tas2552_mute,
>  };
>  
> @@ -294,7 +315,7 @@ static struct snd_soc_dai_driver tas2552_dai[] = {
>  	{
>  		.name = "tas2552-amplifier",
>  		.playback = {
> -			.stream_name = "Speaker",
> +			.stream_name = "Playback",
>  			.channels_min = 2,
>  			.channels_max = 2,
>  			.rates = SNDRV_PCM_RATE_8000_192000,
> @@ -312,6 +333,7 @@ static DECLARE_TLV_DB_SCALE(dac_tlv, -7, 100, 24);
>  static const struct snd_kcontrol_new tas2552_snd_controls[] = {
>  	SOC_SINGLE_TLV("Speaker Driver Playback Volume",
>  			 TAS2552_PGA_GAIN, 0, 0x1f, 1, dac_tlv),
> +	SOC_DAPM_SINGLE("Playback AMP", SND_SOC_NOPM, 0, 1, 0),
>  };
>  
>  static const struct reg_default tas2552_init_regs[] = {
> @@ -321,6 +343,7 @@ static const struct reg_default tas2552_init_regs[] = {
>  static int tas2552_codec_probe(struct snd_soc_codec *codec)
>  {
>  	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
> +	struct snd_soc_dapm_context *dapm = &codec->dapm;
>  	int ret;
>  
>  	tas2552->codec = codec;
> @@ -362,9 +385,14 @@ static int tas2552_codec_probe(struct snd_soc_codec *codec)
>  		goto patch_fail;
>  	}
>  
> -	snd_soc_write(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN |
> -				  TAS2552_BOOST_EN | TAS2552_APT_EN |
> -				  TAS2552_LIM_EN);
> +	snd_soc_write(codec, TAS2552_CFG_2, TAS2552_BOOST_EN |
> +				  TAS2552_APT_EN | TAS2552_LIM_EN);
> +
> +	snd_soc_dapm_new_controls(dapm, tas2552_dapm_widgets,
> +				ARRAY_SIZE(tas2552_dapm_widgets));
> +	snd_soc_dapm_add_routes(dapm, tas2552_audio_map,
> +				ARRAY_SIZE(tas2552_audio_map));
> +
>  	return 0;
>  
>  patch_fail:
> 


-- 
------------------
Dan Murphy
