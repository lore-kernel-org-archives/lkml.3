Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbaGYHP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:15:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbaGYHP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:15:27 -0400
Date: Fri, 25 Jul 2014 09:15:19 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: <wsa@the-dreams.de>, <laurent.pinchart@ideasonboard.com>,
        <paul.gortmaker@windriver.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] i2c: pca954x: put the mux to disconnected state after
 resume
Message-ID: <20140725091519.4e780494@endymion.delvare>
In-Reply-To: <1406254559-5615-1-git-send-email-jszhang@marvell.com>
References: <1406254559-5615-1-git-send-email-jszhang@marvell.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jisheng Zhang,

On Fri, 25 Jul 2014 10:15:59 +0800, Jisheng Zhang wrote:
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
> ---
>  drivers/i2c/muxes/i2c-mux-pca954x.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
> index 9bd4212..c8c3d58 100644
> --- a/drivers/i2c/muxes/i2c-mux-pca954x.c
> +++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
> @@ -273,9 +273,23 @@ static int pca954x_remove(struct i2c_client *client)
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

I think you must include <linux/pm.h> for this.

Other than this, the change looks reasonable, you can add:

Reviewed-by: Jean Delvare <jdelvare@suse.de>

(Please note my new e-mail address.)

> +
>  static struct i2c_driver pca954x_driver = {
>  	.driver		= {
>  		.name	= "pca954x",
> +		.pm	= &pca954x_pm,
>  		.owner	= THIS_MODULE,
>  	},
>  	.probe		= pca954x_probe,


-- 
Jean Delvare
SUSE L3 Support
