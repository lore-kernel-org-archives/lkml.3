Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaGLUOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 16:14:30 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:48880 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbaGLUO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 16:14:27 -0400
Message-ID: <53C1971E.3020200@iki.fi>
Date: Sat, 12 Jul 2014 23:14:22 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Shuah Khan <shuah.kh@samsung.com>, m.chehab@samsung.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: em28xx-dvb unregister i2c tuner and demod after
 fe detach
References: <1405093525-8745-1-git-send-email-shuah.kh@samsung.com>
In-Reply-To: <1405093525-8745-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 85.23.164.97
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moikka Shuah!
I suspect that patch makes no sense. On DVB there is runtime PM 
controlled by DVB frontend. It wakes up all FE sub-devices when frontend 
device is opened and sleeps when closed.

FE release() is not relevant at all for those sub-devices which are 
implemented as a proper I2C client. I2C client has own remove() for that.

em28xx_dvb_init and em28xx_dvb_fini are counterparts. Those I2C drivers 
are load on em28xx_dvb_init so logical place for unload is em28xx_dvb_fini.

Is there some real use case you need that change?

regards
Antti


On 07/11/2014 06:45 PM, Shuah Khan wrote:
> i2c tuner and demod are unregisetred in .fini before fe detach.
> dvb_unregister_frontend() and dvb_frontend_detach() invoke tuner
> sleep() and release() interfaces. Change to unregister i2c tuner
> and demod from em28xx_unregister_dvb() after unregistering dvb
> and detaching fe.
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>   drivers/media/usb/em28xx/em28xx-dvb.c |   32 +++++++++++++++++---------------
>   1 file changed, 17 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index 8314f51..8d5cb62 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -1030,6 +1030,8 @@ fail_adapter:
>
>   static void em28xx_unregister_dvb(struct em28xx_dvb *dvb)
>   {
> +	struct i2c_client *client;
> +
>   	dvb_net_release(&dvb->net);
>   	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
>   	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
> @@ -1041,6 +1043,21 @@ static void em28xx_unregister_dvb(struct em28xx_dvb *dvb)
>   	if (dvb->fe[1] && !dvb->dont_attach_fe1)
>   		dvb_frontend_detach(dvb->fe[1]);
>   	dvb_frontend_detach(dvb->fe[0]);
> +
> +	/* remove I2C tuner */
> +	client = dvb->i2c_client_tuner;
> +	if (client) {
> +		module_put(client->dev.driver->owner);
> +		i2c_unregister_device(client);
> +	}
> +
> +	/* remove I2C demod */
> +	client = dvb->i2c_client_demod;
> +	if (client) {
> +		module_put(client->dev.driver->owner);
> +		i2c_unregister_device(client);
> +	}
> +
>   	dvb_unregister_adapter(&dvb->adapter);
>   }
>
> @@ -1628,7 +1645,6 @@ static inline void prevent_sleep(struct dvb_frontend_ops *ops)
>   static int em28xx_dvb_fini(struct em28xx *dev)
>   {
>   	struct em28xx_dvb *dvb;
> -	struct i2c_client *client;
>
>   	if (dev->is_audio_only) {
>   		/* Shouldn't initialize IR for this interface */
> @@ -1646,7 +1662,6 @@ static int em28xx_dvb_fini(struct em28xx *dev)
>   	em28xx_info("Closing DVB extension");
>
>   	dvb = dev->dvb;
> -	client = dvb->i2c_client_tuner;
>
>   	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
>
> @@ -1659,19 +1674,6 @@ static int em28xx_dvb_fini(struct em28xx *dev)
>   			prevent_sleep(&dvb->fe[1]->ops);
>   	}
>
> -	/* remove I2C tuner */
> -	if (client) {
> -		module_put(client->dev.driver->owner);
> -		i2c_unregister_device(client);
> -	}
> -
> -	/* remove I2C demod */
> -	client = dvb->i2c_client_demod;
> -	if (client) {
> -		module_put(client->dev.driver->owner);
> -		i2c_unregister_device(client);
> -	}
> -
>   	em28xx_unregister_dvb(dvb);
>   	kfree(dvb);
>   	dev->dvb = NULL;
>

-- 
http://palosaari.fi/
