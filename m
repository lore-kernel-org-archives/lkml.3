Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaIVUSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:18:25 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37094 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaIVUSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:18:24 -0400
Date: Mon, 22 Sep 2014 17:18:17 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: fabf@skynet.be, linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media: tuner xc5000 - release firmwware from
 xc5000_release()
Message-ID: <20140922171817.1854a61c@recife.lan>
In-Reply-To: <ed12c60cb0052853517999841a2c581289c129df.1407977791.git.shuah.kh@samsung.com>
References: <cover.1407977791.git.shuah.kh@samsung.com>
	<ed12c60cb0052853517999841a2c581289c129df.1407977791.git.shuah.kh@samsung.com>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 13 Aug 2014 19:09:23 -0600
Shuah Khan <shuah.kh@samsung.com> escreveu:

> xc5000 releases firmware right after loading it. Change it to
> save the firmware and release it from xc5000_release(). This
> helps avoid fecthing firmware when forced firmware load requests
> come in to change analog tv frequence and when firmware needs to
> be reloaded after suspend and resume.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/media/tuners/xc5000.c |   34 ++++++++++++++++++++--------------
>  1 file changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
> index 512fe50..31b1dec 100644
> --- a/drivers/media/tuners/xc5000.c
> +++ b/drivers/media/tuners/xc5000.c
> @@ -70,6 +70,8 @@ struct xc5000_priv {
>  
>  	struct dvb_frontend *fe;
>  	struct delayed_work timer_sleep;
> +
> +	const struct firmware   *firmware;
>  };
>  
>  /* Misc Defines */
> @@ -1136,20 +1138,23 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe, int force)
>  	if (!force && xc5000_is_firmware_loaded(fe) == 0)
>  		return 0;
>  
> -	ret = request_firmware(&fw, desired_fw->name,
> -			       priv->i2c_props.adap->dev.parent);
> -	if (ret) {
> -		printk(KERN_ERR "xc5000: Upload failed. (file not found?)\n");
> -		return ret;
> -	}
> -
> -	dprintk(1, "firmware read %Zu bytes.\n", fw->size);
> +	if (!priv->firmware) {
> +		ret = request_firmware(&fw, desired_fw->name,
> +					priv->i2c_props.adap->dev.parent);
> +		if (ret) {
> +			pr_err("xc5000: Upload failed. rc %d\n", ret);
> +			return ret;
> +		}
> +		dprintk(1, "firmware read %Zu bytes.\n", fw->size);
>  
> -	if (fw->size != desired_fw->size) {
> -		printk(KERN_ERR "xc5000: Firmware file with incorrect size\n");
> -		ret = -EINVAL;
> -		goto err;
> -	}
> +		if (fw->size != desired_fw->size) {
> +			pr_err("xc5000: Firmware file with incorrect size\n");
> +			ret = -EINVAL;
> +			goto err;

In this case, we should be releasing the firmware too. Btw, this code will
also add a memory leak, as priv->firmware will be null, but the firmware
was loaded.

The rest of the patch looks ok.

Regards,
Mauro
