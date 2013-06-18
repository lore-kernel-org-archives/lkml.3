Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab3FRACd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 20:02:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:45593 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab3FRACc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 20:02:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,884,1363158000"; 
   d="scan'208";a="355179839"
Date: Tue, 18 Jun 2013 02:02:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tero Kristo <t-kristo@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: twl4030-power: Start transition to DT
Message-ID: <20130618000211.GC7998@zurbaran>
References: <1369921916-7435-1-git-send-email-florian.vaussard@epfl.ch>
 <1369921916-7435-3-git-send-email-florian.vaussard@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369921916-7435-3-git-send-email-florian.vaussard@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On Thu, May 30, 2013 at 03:51:55PM +0200, Florian Vaussard wrote:
>  int twl4030_power_probe(struct platform_device *pdev)
>  {
>  	struct twl4030_power_data *pdata = pdev->dev.platform_data;
> +	struct device_node *node = pdev->dev.of_node;
>  	int err = 0;
> -	int i;
> -	struct twl4030_resconfig *resconfig;
> -	u8 val, address = twl4030_start_script_address;
> +	u8 val;
> +
> +	if (!pdata && !node) {
> +		dev_err(&pdev->dev, "Platform data is missing\n");
> +		return -EINVAL;
> +	}
>  
>  	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, TWL4030_PM_MASTER_KEY_CFG1,
>  			       TWL4030_PM_MASTER_PROTECT_KEY);
> @@ -525,26 +575,17 @@ int twl4030_power_probe(struct platform_device *pdev)
>  	if (err)
>  		goto unlock;
>  
> -	for (i = 0; i < pdata->num; i++) {
> -		err = load_twl4030_script(pdata->scripts[i], address);
> +	if (pdata) {
> +		err = twl4030_power_configure_scripts(pdata);
>  		if (err)
>  			goto load;
> -		address += pdata->scripts[i]->size;
> -	}
> -
> -	resconfig = pdata->resource_config;
> -	if (resconfig) {
> -		while (resconfig->resource) {
> -			err = twl4030_configure_resource(resconfig);
> -			if (err)
> -				goto resource;
> -			resconfig++;
> -
> -		}
> +		err = twl4030_power_configure_resources(pdata);
> +		if (err)
> +			goto resource;
You're simplifying the probe routine here by defining 2
twl4030_power_configure_* functions. That's good, but it should be a
separate patch as it's not related to the DT porting effort.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
