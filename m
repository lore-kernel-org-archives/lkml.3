Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3FQSHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:07:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56900 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3FQSHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:07:31 -0400
Message-ID: <51BF5060.8060001@wwwdotorg.org>
Date: Mon, 17 Jun 2013 12:07:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] mfd: tps65910: Fix crash in i2c_driver .probe
References: <1371491257-23791-1-git-send-email-ttynkkynen@nvidia.com> <1371491257-23791-2-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1371491257-23791-2-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 11:47 AM, Tuomas Tynkkynen wrote:
> Commit "i2c: core: make it possible to match a pure device tree driver"
> changed semantics of the i2c probing for device tree devices.
> Device tree probed devices now get a NULL i2c_device_id pointer.
> This caused kernel panics due to NULL dereference.

> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c

>  	pmic_plat_data = dev_get_platdata(&i2c->dev);
>  
> -	if (!pmic_plat_data && i2c->dev.of_node) {
> +	if (id) {
> +		chip_id = id->driver_data;
> +	} else if (i2c->dev.of_node) {
>  		pmic_plat_data = tps65910_parse_dt(i2c, &chip_id);

That over-writes pmic_plat_data even if it was already set above. This
should really only happen if the earlier assignment didn't find any
pdata, i.e. if (!pmic_plat_data) here.

Looking at patch 2/2, the structure in that driver is correct, and
perhaps could be implemented the same or similarly here?

>  		of_pmic_plat_data = pmic_plat_data;

Or just swap those assignments:

of_pmic_plat_data = tps65910_parse_dt(...);
if (!pmic_plat_data)
    pmic_plat_data = of_pmic_plat_data;

(although there's perhaps little point parsing the pdata from DT if it's
already provided through the device object)

>  	}
>  
> -	if (!pmic_plat_data)
> +	if (!pmic_plat_data || chip_id < 0)
>  		return -EINVAL;

