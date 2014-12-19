Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaLSWRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:17:07 -0500
Received: from mout.gmx.net ([212.227.15.19]:57759 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaLSWRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:17:06 -0500
Message-ID: <5494A3D6.60607@gmx.de>
Date: Fri, 19 Dec 2014 23:16:54 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, jic23@kernel.org
CC: lars@metafoo.de, pmeerw@pmeerw.net, gwendal@chromium.org,
        srinivas.pandruvada@linux.intel.com, beomho.seo@samsung.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        octavian.purdila@intel.com
Subject: Re: [RFC PATCH] iio: ak8975: Make sure chipset is always initialized
References: <1418923002-901-1-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1418923002-901-1-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:qrOjUiGHhJLuRImr6oAqhPtHW8N+uUOUe84aULpsvS9YqqAIUix
 xuoQXonhaQbRe7/LgTELbhfSzdzI2YkuXm6YKER4rnvH7dCZ7B197eOsb9T1lMNk60QbPkI
 CheXTsPt+ffF9xvJZIgXbj8sgngxsXdEoktxa2wIXsOp2JiEjcpziKhYwgBR9NSRrjpGoFO
 okhCUPpO/2mAM1c1XzQdg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Baluta schrieb am 18.12.2014 um 18:16:
> When using ACPI, if acpi_match_device fails then chipset enum will be
> uninitialized and &ak_def_array[chipset] will point to some bad address.
> 
> This fixes the following compilation warning:
> 
> drivers/iio/magnetometer/ak8975.c: In function ‘ak8975_probe’:
> drivers/iio/magnetometer/ak8975.c:788:14: warning: ‘chipset’ may be used
> uninitialized in this function [-Wmaybe-uninitialized]
>   data->def =ak_def_array[chipset];
> 
> Reported-by: Octavian Purdila <octavian.purdila@intel.com>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> ---
> This is a RFC because while I'm pretty sure that chipset should be initialized
> with AK_MAX_TYPE in ak8975_match_acpi_device, I am not sure if we can live with
> a NULL return value of ak8975_match_acpi_device. Current implementation ignores
> return value of ak8975_match_acpi_device.
This seems to be the actual problem: these _match_acpi_device functions return
NULL on failure, and this should be checked for.

> 
> The same situation is for kxcjk-1013, bmc150-accel, bmg160 and possible other
> drivers.
> 
>  drivers/iio/magnetometer/ak8975.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
> index 0d10a4b..cdf9e77 100644
> --- a/drivers/iio/magnetometer/ak8975.c
> +++ b/drivers/iio/magnetometer/ak8975.c
> @@ -716,6 +716,7 @@ static const char *ak8975_match_acpi_device(struct device *dev,
>  {
>  	const struct acpi_device_id *id;
>  
> +	*chipset =K_MAX_TYPE;
>  	id =cpi_match_device(dev->driver->acpi_match_table, dev);
>  	if (!id)
>  		return NULL;
> 

