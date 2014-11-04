Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaKDPGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:06:20 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:44594 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaKDPGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:06:18 -0500
Message-ID: <5458EB64.3030203@mm-sol.com>
Date: Tue, 04 Nov 2014 17:06:12 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] mfd: qcom-spmi-pmic: Add support for more chips versions
References: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,

Thanks for the patch!

On 11/04/2014 03:33 PM, Ivan T. Ivanov wrote:
> Update compatible string with runtime detected chip revision
> information, for example qcom,pm8941 will become qcom,pm8941-v1.0.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  .../devicetree/bindings/mfd/qcom,spmi-pmic.txt     |  18 ++-
>  drivers/mfd/qcom-spmi-pmic.c                       | 142 +++++++++++++++++++++
>  2 files changed, 156 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt b/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt
> index 7182b88..bbe7db8 100644
> --- a/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt
> +++ b/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt
> @@ -15,10 +15,20 @@ each. A function can consume one or more of these fixed-size register regions.
>  
>  Required properties:
>  - compatible:      Should contain one of:
> -                     "qcom,pm8941"
> -                     "qcom,pm8841"
> -                     "qcom,pma8084"
> -                     or generalized "qcom,spmi-pmic".
> +                   qcom,pm8941,
> +                   qcom,pm8841,
> +                   qcom,pm8019,
> +                   qcom,pm8226,
> +                   qcom,pm8110,
> +                   qcom,pma8084,
> +                   qcom,pmi8962,
> +                   qcom,pmd9635,
> +                   qcom,pm8994,
> +                   qcom,pmi8994,
> +                   qcom,pm8916,
> +                   qcom,pm8004,
> +                   qcom,pm8909,
> +                   or generalized "qcom,spmi-pmic".
>  - reg:             Specifies the SPMI USID slave address for this device.
>                     For more information see:
>                     Documentation/devicetree/bindings/spmi/spmi.txt
> diff --git a/drivers/mfd/qcom-spmi-pmic.c b/drivers/mfd/qcom-spmi-pmic.c
> index 4b8beb2..67446a4 100644
> --- a/drivers/mfd/qcom-spmi-pmic.c
> +++ b/drivers/mfd/qcom-spmi-pmic.c
> @@ -13,10 +13,126 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/slab.h>
>  #include <linux/spmi.h>
>  #include <linux/regmap.h>
> +#include <linux/of.h>
>  #include <linux/of_platform.h>
>  
> +#define PMIC_REV2		0x101
> +#define PMIC_REV3		0x102
> +#define PMIC_REV4		0x103
> +#define PMIC_TYPE		0x104
> +#define PMIC_SUBTYPE		0x105
> +
> +#define PMIC_TYPE_VALUE		0x51
> +
> +#define PM8941_SUBTYPE		0x01
> +#define PM8841_SUBTYPE		0x02
> +#define PM8019_SUBTYPE		0x03
> +#define PM8226_SUBTYPE		0x04
> +#define PM8110_SUBTYPE		0x05
> +#define PMA8084_SUBTYPE		0x06
> +#define PMI8962_SUBTYPE		0x07
> +#define PMD9635_SUBTYPE		0x08
> +#define PM8994_SUBTYPE		0x09
> +#define PMI8994_SUBTYPE		0x0a
> +#define PM8916_SUBTYPE		0x0b
> +#define PM8004_SUBTYPE		0x0c
> +#define PM8909_SUBTYPE		0x0d
> +
> +static int pmic_spmi_read_revid(struct regmap *map, char **name,
> +				int *major, int *minor)
> +{
> +	unsigned int rev2, rev3, rev4, type, subtype;
> +	int ret;
> +
> +	ret = regmap_read(map, PMIC_TYPE, &type);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (type != PMIC_TYPE_VALUE)
> +		return -EINVAL;
> +
> +	ret = regmap_read(map, PMIC_SUBTYPE, &subtype);
> +	if (ret < 0)
> +		return ret;
> +
> +	rev2 = regmap_read(map, PMIC_REV2, &rev2);
> +	if (ret < 0)
> +		return ret;
> +
> +	rev3 = regmap_read(map, PMIC_REV3, &rev3);
> +	if (ret < 0)
> +		return ret;
> +
> +	rev4 = regmap_read(map, PMIC_REV4, &rev4);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * In early versions of PM8941 and PM8226, the major revision number
> +	 * started incrementing from 0 (eg 0 = v1.0, 1 = v2.0).
> +	 * Increment the major revision number here if the chip is an early
> +	 * version of PM8941 or PM8226.
> +	 */
> +	if ((subtype == PM8941_SUBTYPE || subtype == PM8226_SUBTYPE) &&
> +	    rev4 < 0x02)
> +		rev4++;
> +
> +	*major = rev4;
> +	if (subtype == PM8110_SUBTYPE)
> +		*minor = rev2;
> +	else
> +		*minor = rev3;
> +
> +	switch (subtype) {
> +	case PM8941_SUBTYPE:
> +		*name = "pm8941";
> +		break;

The XXX_SUBTYPE seems are continuous why not make it an const array and
get the name by index in this array?

> +	case PM8841_SUBTYPE:
> +		*name = "pm8841";
> +		break;
> +	case PM8019_SUBTYPE:
> +		*name = "pm8019";
> +		break;
> +	case PM8226_SUBTYPE:
> +		*name = "pm8226";
> +		break;
> +	case PM8110_SUBTYPE:
> +		*name = "pm8110";
> +		break;
> +	case PMA8084_SUBTYPE:
> +		*name = "pma8084";
> +		break;
> +	case PMI8962_SUBTYPE:
> +		*name = "pmi8962";
> +		break;
> +	case PMD9635_SUBTYPE:
> +		*name = "pmd8635";
> +		break;
> +	case PM8994_SUBTYPE:
> +		*name = "pm8994";
> +		break;
> +	case PMI8994_SUBTYPE:
> +		*name = "pmi8994";
> +		break;
> +	case PM8916_SUBTYPE:
> +		*name = "pm8916";
> +		break;
> +	case PM8004_SUBTYPE:
> +		*name = "pm8004";
> +		break;
> +	case PM8909_SUBTYPE:
> +		*name = "pm8909";
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static const struct regmap_config spmi_regmap_config = {
>  	.reg_bits	= 16,
>  	.val_bits	= 8,
> @@ -28,11 +144,27 @@ static int pmic_spmi_probe(struct spmi_device *sdev)
>  {
>  	struct device_node *root = sdev->dev.of_node;
>  	struct regmap *regmap;
> +	struct property *prop;
> +	int major, minor, ret;
> +	char *name, compatible[32];
>  
>  	regmap = devm_regmap_init_spmi_ext(sdev, &spmi_regmap_config);
>  	if (IS_ERR(regmap))
>  		return PTR_ERR(regmap);
>  
> +	ret = pmic_spmi_read_revid(regmap, &name, &major, &minor);
> +	if (!ret) {

Are you sure that we want to continue if we can't read the revision id
and therefore will not be able to construct properly the compatible
property?

> +		snprintf(compatible, ARRAY_SIZE(compatible), "qcom,%s-v%d.%d",
> +			 name, major, minor);
> +		prop = kzalloc(sizeof(*prop), GFP_KERNEL);
> +		if (prop) {
> +			prop->name = kstrdup("compatible", GFP_KERNEL);
> +			prop->value = kstrdup(compatible, GFP_KERNEL);
> +			prop->length = strlen(prop->value);
> +			of_update_property(root, prop);

of_update_property can fail, check the returned value.

<snip>

-- 
regards,
Stan
