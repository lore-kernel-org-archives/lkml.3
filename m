Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaG1LYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:24:50 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52981 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaG1LYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:24:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: wsa@the-dreams.de, khali@linux-fr.org, paul.gortmaker@windriver.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] i2c: pca954x: put the mux to disconnected state after resume
Date: Mon, 28 Jul 2014 13:25:03 +0200
Message-ID: <24682406.bF7Bs0kNf1@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406289466-936-1-git-send-email-jszhang@marvell.com>
References: <1406289466-936-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jisheng,

Thank you for the patch.

On Friday 25 July 2014 19:57:46 Jisheng Zhang wrote:
> pca954x may be power lost during suspend, so after resume we also suffer
> the issue fixed by commit cd823db8b1161ef0d756514d280715a576d65cc3,
> 
>  "pca954x power-on default is channel 0 connected. If multiple pca954x
>  muxes are connected to the same physical I2C bus, the parent bus will
>  see channel 0 devices behind both muxes by default."
> 
> What's more, when resume bootloader may also operate the mux, so the
> the channel connected after that may not be the one driver thought.
> 
> We fix this problem by putting the mux to disconnected state and
> clearing last_chan in the resume hook.
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/i2c/muxes/i2c-mux-pca954x.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c
> b/drivers/i2c/muxes/i2c-mux-pca954x.c index 9bd4212..ec11b40 100644
> --- a/drivers/i2c/muxes/i2c-mux-pca954x.c
> +++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
> @@ -41,6 +41,7 @@
>  #include <linux/i2c-mux.h>
>  #include <linux/i2c/pca954x.h>
>  #include <linux/module.h>
> +#include <linux/pm.h>
>  #include <linux/slab.h>
> 
>  #define PCA954X_MAX_NCHANS 8
> @@ -273,9 +274,23 @@ static int pca954x_remove(struct i2c_client *client)
>  	return 0;
>  }
> 
> +#ifdef CONFIG_PM_SLEEP
> +static int pca954x_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct pca954x *data = i2c_get_clientdata(client);
> +
> +	data->last_chan = 0;
> +	return i2c_smbus_write_byte(client, 0);
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(pca954x_pm, NULL, pca954x_resume);
> +
>  static struct i2c_driver pca954x_driver = {
>  	.driver		= {
>  		.name	= "pca954x",
> +		.pm	= &pca954x_pm,
>  		.owner	= THIS_MODULE,
>  	},
>  	.probe		= pca954x_probe,

-- 
Regards,

Laurent Pinchart

