Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaBSFa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 00:30:57 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11338 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbaBSFam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 00:30:42 -0500
Message-ID: <53044116.9020406@marvell.com>
Date: Wed, 19 Feb 2014 13:28:54 +0800
From: Nenghua Cao <nhcao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nenghua Cao <nhcao@marvell.com>
CC: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] asoc: soc-core: use regmap's parse_val to do endian
 translation
References: <1392787221-29445-1-git-send-email-nhcao@marvell.com>
In-Reply-To: <1392787221-29445-1-git-send-email-nhcao@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-19_01:2014-02-18,2014-02-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402180233
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update Liam and Mark's mail.

On 02/19/2014 01:20 PM, Nenghua Cao wrote:
> From: Nenghua Cao <nhcao@marvell.com>
> 
>     In snd_soc_bytes_put function, it forces cpu to do cpu_to_be translation,
> but for mmio bus which uses REGMAP_ENDIAN_NATIVE, it doesn't need to do
> endian translation. So it is better to use regmap's api which can decide
> if this translation is needed according to bus configuration.
> 
> Signed-off-by: Nenghua Cao <nhcao@marvell.com>
> ---
>  sound/soc/soc-core.c |   34 +++++++++++++++++++++++++++++-----
>  1 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
> index fe1df50..fb598cb 100644
> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -3234,7 +3234,7 @@ int snd_soc_bytes_put(struct snd_kcontrol *kcontrol,
>  	struct soc_bytes *params = (void *)kcontrol->private_value;
>  	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
>  	int ret, len;
> -	unsigned int val;
> +	unsigned int val, mask;
>  	void *data;
>  
>  	if (!codec->using_regmap)
> @@ -3264,12 +3264,36 @@ int snd_soc_bytes_put(struct snd_kcontrol *kcontrol,
>  			((u8 *)data)[0] |= val;
>  			break;
>  		case 2:
> -			((u16 *)data)[0] &= cpu_to_be16(~params->mask);
> -			((u16 *)data)[0] |= cpu_to_be16(val);
> +			mask = ~params->mask;
> +			ret = regmap_parse_val(codec->control_data,
> +							&mask, &mask);
> +			if (ret != 0)
> +				goto out;
> +
> +			((u16 *)data)[0] &= mask;
> +
> +			ret = regmap_parse_val(codec->control_data,
> +							&val, &val);
> +			if (ret != 0)
> +				goto out;
> +
> +			((u16 *)data)[0] |= val;
>  			break;
>  		case 4:
> -			((u32 *)data)[0] &= cpu_to_be32(~params->mask);
> -			((u32 *)data)[0] |= cpu_to_be32(val);
> +			mask = ~params->mask;
> +			ret = regmap_parse_val(codec->control_data,
> +							&mask, &mask);
> +			if (ret != 0)
> +				goto out;
> +
> +			((u32 *)data)[0] &= mask;
> +
> +			ret = regmap_parse_val(codec->control_data,
> +							&val, &val);
> +			if (ret != 0)
> +				goto out;
> +
> +			((u32 *)data)[0] |= val;
>  			break;
>  		default:
>  			ret = -EINVAL;
> 

