Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbaBSFaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 00:30:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18543 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbaBSFaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 00:30:11 -0500
Message-ID: <5304410B.9010207@marvell.com>
Date: Wed, 19 Feb 2014 13:28:43 +0800
From: Nenghua Cao <nhcao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nenghua Cao <nhcao@marvell.com>
CC: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] driver: regmap: add regmap_parse_val api
References: <1392787197-29411-1-git-send-email-nhcao@marvell.com>
In-Reply-To: <1392787197-29411-1-git-send-email-nhcao@marvell.com>
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

On 02/19/2014 01:19 PM, Nenghua Cao wrote:
> From: Nenghua Cao <nhcao@marvell.com>
> 
>     In some cases, we need regmap's format parse_val function
> to do be/le translation according to the bus configuration.
> For example, snd_soc_bytes_put() uses regmap to write/read values,
> and use cpu_to_be() directly to covert MASK into big endian. This
> is a defect, and should use regmap's format function to do it according
> to bus configuration.
> 
> Signed-off-by: Nenghua Cao <nhcao@marvell.com>
> ---
>  drivers/base/regmap/regmap.c |   12 ++++++++++++
>  include/linux/regmap.h       |    9 +++++++++
>  2 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 6a19515..4b2ed0c 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -2240,6 +2240,18 @@ int regmap_get_val_bytes(struct regmap *map)
>  }
>  EXPORT_SYMBOL_GPL(regmap_get_val_bytes);
>  
> +int regmap_parse_val(struct regmap *map, const void *buf,
> +			unsigned int *val)
> +{
> +	if (!map->format.parse_val)
> +		return -EINVAL;
> +
> +	*val = map->format.parse_val(buf);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(regmap_parse_val);
> +
>  static int __init regmap_initcall(void)
>  {
>  	regmap_debugfs_initcall();
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index 4149f1a..3e1a2e4 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -423,6 +423,8 @@ bool regmap_check_range_table(struct regmap *map, unsigned int reg,
>  
>  int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
>  			  int num_regs);
> +int regmap_parse_val(struct regmap *map, const void *buf,
> +				unsigned int *val);
>  
>  static inline bool regmap_reg_in_range(unsigned int reg,
>  				       const struct regmap_range *range)
> @@ -695,6 +697,13 @@ static inline int regmap_register_patch(struct regmap *map,
>  	return -EINVAL;
>  }
>  
> +static inline int regmap_parse_val(struct regmap *map, const void *buf,
> +				unsigned int *val)
> +{
> +	WARN_ONCE(1, "regmap API is disabled");
> +	return -EINVAL;
> +}
> +
>  static inline struct regmap *dev_get_regmap(struct device *dev,
>  					    const char *name)
>  {
> 

