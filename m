Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaK2QiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:38:08 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:57273 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaK2QiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:38:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC v8 04/14] v4l2-async: change custom.match callback argument type
Date: Sat, 29 Nov 2014 18:38:31 +0200
Message-ID: <5063831.7WQadZaPHh@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1417166286-27685-5-git-send-email-j.anaszewski@samsung.com>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com> <1417166286-27685-5-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

Thank you for the patch.

On Friday 28 November 2014 10:17:56 Jacek Anaszewski wrote:
> It is useful to have an access to the async sub-device
> being matched, not only to the related struct device.
> Change match callback argument from struct device
> to struct v4l2_subdev. It will allow e.g. for matching
> a sub-device by its "name" property.

In principle I agree. However, we will need to reimplement v4l2-async based on 
the component (drivers/base/component.c) framework at some point. As the 
component framework is based on struct device, will it still be possible to 
match on subdev name in that case ? If not, we might need to try to find 
another approach to the issue.

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-async.c |   16 ++++++++--------
>  include/media/v4l2-async.h           |    2 +-
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c
> b/drivers/media/v4l2-core/v4l2-async.c index 85a6a34..8140992 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -22,10 +22,10 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-subdev.h>
> 
> -static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
> +static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev
> *asd) {
>  #if IS_ENABLED(CONFIG_I2C)
> -	struct i2c_client *client = i2c_verify_client(dev);
> +	struct i2c_client *client = i2c_verify_client(sd->dev);
>  	return client &&
>  		asd->match.i2c.adapter_id == client->adapter->nr &&
>  		asd->match.i2c.address == client->addr;
> @@ -34,14 +34,14 @@ static bool match_i2c(struct device *dev, struct
> v4l2_async_subdev *asd) #endif
>  }
> 
> -static bool match_devname(struct device *dev, struct v4l2_async_subdev
> *asd) +static bool match_devname(struct v4l2_subdev *sd, struct
> v4l2_async_subdev *asd) {
> -	return !strcmp(asd->match.device_name.name, dev_name(dev));
> +	return !strcmp(asd->match.device_name.name, dev_name(sd->dev));
>  }
> 
> -static bool match_of(struct device *dev, struct v4l2_async_subdev *asd)
> +static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
> {
> -	return dev->of_node == asd->match.of.node;
> +	return sd->dev->of_node == asd->match.of.node;
>  }
> 
>  static LIST_HEAD(subdev_list);
> @@ -52,7 +52,7 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct
> v4l2_async_notifier * struct v4l2_subdev *sd)
>  {
>  	struct v4l2_async_subdev *asd;
> -	bool (*match)(struct device *, struct v4l2_async_subdev *);
> +	bool (*match)(struct v4l2_subdev *, struct v4l2_async_subdev *);
> 
>  	list_for_each_entry(asd, &notifier->waiting, list) {
>  		/* bus_type has been verified valid before */
> @@ -79,7 +79,7 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct
> v4l2_async_notifier * }
> 
>  		/* match cannot be NULL here */
> -		if (match(sd->dev, asd))
> +		if (match(sd, asd))
>  			return asd;
>  	}
> 
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 7683569..1c0b586 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -51,7 +51,7 @@ struct v4l2_async_subdev {
>  			unsigned short address;
>  		} i2c;
>  		struct {
> -			bool (*match)(struct device *,
> +			bool (*match)(struct v4l2_subdev *,
>  				      struct v4l2_async_subdev *);
>  			void *priv;
>  		} custom;

-- 
Regards,

Laurent Pinchart

