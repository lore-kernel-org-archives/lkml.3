Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaKDKl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:41:26 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42486 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaKDKlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:41:22 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-96-5458ad4e55c3
Message-id: <1415097677.7941.8.camel@AMDC1943>
Subject: Re: [PATCH v4 10/14] regulator: of: Add support for parsing initial
 and suspend modes
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Tue, 04 Nov 2014 11:41:17 +0100
In-reply-to: <1415025649-8119-11-git-send-email-javier.martinez@collabora.co.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415025649-8119-11-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xy7p+ayNCDE7MN7GY+vAJm8X1L89Z
	LeYfOcdqcfR3gcWav0oWvQuusllc3jWHzWLG+X1MFqeuf2azmP9gB7MDl8ff59dZPHbOusvu
	sWlVJ5vHlRNNrB5/Z+1n8ejbsorR4/MmuQD2KC6blNSczLLUIn27BK6MnbeusxesE61YOOcM
	awPjOsEuRk4OCQETiV37L7JC2GISF+6tZ+ti5OIQEljKKLF8x0Io5zOjxJUlP9lAqngF9CS2
	bZrHBGILCyRItN+7xwhiswkYS2xevgSsRkTATuLG6ofMIM3MAseYJGauWscCkmARUJU4MvkD
	M4jNKRAgcfLwA0aIDVMYJVbc2A12B7OAusSkeYuAijiAblKWaOx3g1gsKPFj8j0WiBJ5ic1r
	3jJPYBSYhaRjFpKyWUjKFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQIiYuvOxiXHrM6
	xCjAwajEw7siPiJEiDWxrLgy9xCjBAezkgjv6iqgEG9KYmVValF+fFFpTmrxIUYmDk6pBsYL
	xipVP5axz5137+Szt02yhg/sqo7yfK84FPJwoekO3RnnzBY0G8922XOt2Pdo1eH1Iq6hwvP3
	urGmvmyNXfrkZrag4vSkf+kGH9dYuy++VZ7K80DCe+tWBllDE61rt1zm+nP1H+ba/afoXWli
	OxNTGDOXveWKXJP1Bm1/Zzldznn4Yf6Nty+VWIozEg21mIuKEwHJPUtYaQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-11-03 at 15:40 +0100, Javier Martinez Canillas wrote:
> Some regulators support their operating mode to be changed on startup
> or by consumers when the system is running while others only support
> their operating mode to be changed while the system has entered in a
> suspend state.
> 
> The regulator Device Tree binding documents a set of properties to
> configure the regulators operating modes from a FDT. This patch builds
> on (40e20d6 regulator: of: Add support for parsing regulator_state for
> suspend state) and adds support to parse those properties and fill the
> regulator constraints so the regulator core can call the right suspend
> handlers when the system enters into sleep.
> 
> The modes are defined in the Device Tree using the hardware specific
> modes supported by the regulators. Regulator drivers have to define a
> translation function that is used to map the hardware specific modes
> to the standard ones.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
> 
> Changes in v4:
>  - Parse the properties in the core and map using driver provided functions.
>    Suggested by Mark Brown
> 
> Changes in v3:
>  - Use the standard suspend states binding instead of custom properties.
>    Suggested by Mark Brown
> 
>  drivers/regulator/of_regulator.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
> index cbc1d71..cd65885 100644
> --- a/drivers/regulator/of_regulator.c
> +++ b/drivers/regulator/of_regulator.c
> @@ -25,7 +25,8 @@ static const char *const regulator_states[PM_SUSPEND_MAX + 1] = {
>  };
>  
>  static void of_get_regulation_constraints(struct device_node *np,
> -					struct regulator_init_data **init_data)
> +					struct regulator_init_data **init_data,
> +					const struct regulator_desc *desc)
>  {
>  	const __be32 *min_uV, *max_uV;
>  	struct regulation_constraints *constraints = &(*init_data)->constraints;
> @@ -81,6 +82,14 @@ static void of_get_regulation_constraints(struct device_node *np,
>  	if (!ret)
>  		constraints->enable_time = pval;
>  
> +	if (!of_property_read_u32(np, "regulator-initial-mode", &pval)) {
> +		if (desc && desc->map_modes)
> +			constraints->initial_mode = desc->map_modes(pval);
> +		else
> +			pr_warn("%s: failed to parse regulator-initial-mode\n",
> +				np->name);
> +	}
> +

Here's a hidden assumption that if driver does not provide map_modes
then any "regulator-initial-mode" property is not valid. Shouldn't this
be mentioned somewhere? Maybe in description of map_modes callback?

Best regards,
Krzysztof


