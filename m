Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbaJaJlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:41:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855AbaJaJlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:41:51 -0400
Date: Fri, 31 Oct 2014 10:41:47 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux@roeck-us.net, lm-sensors@lm-sensors.org,
        <linux-kernel@vger.kernel.org>, neelegup@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] hwmon: (ibmpowernv) Quieten when probing finds no
 device
Message-ID: <20141031104147.0381619a@endymion.delvare>
In-Reply-To: <1414737923-8227-1-git-send-email-mpe@ellerman.id.au>
References: <1414737923-8227-1-git-send-email-mpe@ellerman.id.au>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Fri, 31 Oct 2014 17:45:22 +1100, Michael Ellerman wrote:
> Because we build kernels with drivers built in for many platforms, it's
> normal for the ibmpowernv driver to be loaded on systems that don't have
> the appropriate hardware.
> 
> Currently the driver spams the log with:
> 
>   ibmpowernv ibmpowernv.0: Opal node 'sensors' not found
>   ibmpowernv: Platfrom driver probe failed
> 
> But there is no error, this machine is not a powernv and doesn't have
> the hardware. So change the sensors message to dev_dbg(), and only print
> an error about the probe failing if it's not ENODEV.
> 
> Also fix the spelling of "Platfrom" and print the actual error value.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  drivers/hwmon/ibmpowernv.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/ibmpowernv.c b/drivers/hwmon/ibmpowernv.c
> index d2bf2c97ae70..6a30eeea94be 100644
> --- a/drivers/hwmon/ibmpowernv.c
> +++ b/drivers/hwmon/ibmpowernv.c
> @@ -181,7 +181,7 @@ static int __init populate_attr_groups(struct platform_device *pdev)
>  
>  	opal = of_find_node_by_path("/ibm,opal/sensors");
>  	if (!opal) {
> -		dev_err(&pdev->dev, "Opal node 'sensors' not found\n");
> +		dev_dbg(&pdev->dev, "Opal node 'sensors' not found\n");
>  		return -ENODEV;
>  	}
>  
> @@ -335,7 +335,9 @@ static int __init ibmpowernv_init(void)
>  
>  	err = platform_driver_probe(&ibmpowernv_driver, ibmpowernv_probe);
>  	if (err) {
> -		pr_err("Platfrom driver probe failed\n");
> +		if (err != -ENODEV)
> +			pr_err("Platform driver probe failed (%d)\n", err);
> +
>  		goto exit_device_del;
>  	}
>  

Looks reasonable.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support
