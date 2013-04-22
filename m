Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3DVKix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:38:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3DVKiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:38:51 -0400
Date: Mon, 22 Apr 2013 12:38:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH RFC v2 1/4] media: i2c: adv7343: add support for asynchronous
 probing
In-Reply-To: <1366625848-743-2-git-send-email-prabhakar.csengg@gmail.com>
Message-ID: <Pine.LNX.4.64.1304221235230.23906@axis700.grange>
References: <1366625848-743-1-git-send-email-prabhakar.csengg@gmail.com>
 <1366625848-743-2-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:xcIbXceHhqySR5ZTCLp6mjIU5aRgP03ajsrM69ikcuE
 POOtZ0OKYqYYYJKttq6P8Rgr+3jFHhYOFBFhGnMyyonE1XnjRY
 RTER74xB5xOcJnlvLPzHjI7F+AT6xtVK+yoIZN7omO+891s3iZ
 /CWArA8DcCj3e6G2IAcgLEdeBYaY8W5p7ApqLr0TOBQOjJgTcd
 M1+2d9ZjhXhUHvvnpThleURQRlt1baI16O5EiR9bhqnwb1biG4
 p39SsQokZ2pQOG3vQDVO3xEUD+3WTJalYo48tbpctR8WZk/GDt
 FFF4PyJ4maB+fwoTh8RwoK0i5kN97TdZmEMBlMYcxx2AwWkEZK
 wRdG9v0weRUAgUA42y07pqmry/LvApUqgAlNVxRGxldbrpwhi0
 XFdF+abWs20OQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar

On Mon, 22 Apr 2013, Prabhakar Lad wrote:

> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> Both synchronous and asynchronous adv7343 subdevice probing is supported by
> this patch.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/i2c/adv7343.c |   17 +++++++++++++----
>  1 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
> index 9fc2b98..5b1417b 100644
> --- a/drivers/media/i2c/adv7343.c
> +++ b/drivers/media/i2c/adv7343.c
> @@ -27,6 +27,7 @@
>  #include <linux/uaccess.h>
>  
>  #include <media/adv7343.h>
> +#include <media/v4l2-async.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-chip-ident.h>
>  #include <media/v4l2-ctrls.h>
> @@ -44,6 +45,7 @@ struct adv7343_state {
>  	struct v4l2_subdev sd;
>  	struct v4l2_ctrl_handler hdl;
>  	const struct adv7343_platform_data *pdata;
> +	struct v4l2_async_subdev_list	asdl;

Do you still need this? Don't think it's needed any more with the latest 
V4L2-async version.

Thanks
Guennadi

>  	u8 reg00;
>  	u8 reg01;
>  	u8 reg02;
> @@ -455,16 +457,22 @@ static int adv7343_probe(struct i2c_client *client,
>  				       ADV7343_GAIN_DEF);
>  	state->sd.ctrl_handler = &state->hdl;
>  	if (state->hdl.error) {
> -		int err = state->hdl.error;
> -
> -		v4l2_ctrl_handler_free(&state->hdl);
> -		return err;
> +		err = state->hdl.error;
> +		goto done;
>  	}
>  	v4l2_ctrl_handler_setup(&state->hdl);
>  
>  	err = adv7343_initialize(&state->sd);
>  	if (err)
> +		goto done;
> +
> +	state->sd.dev = &client->dev;
> +	err = v4l2_async_register_subdev(&state->sd);
> +
> +done:
> +	if (err < 0)
>  		v4l2_ctrl_handler_free(&state->hdl);
> +
>  	return err;
>  }
>  
> @@ -473,6 +481,7 @@ static int adv7343_remove(struct i2c_client *client)
>  	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>  	struct adv7343_state *state = to_state(sd);
>  
> +	v4l2_async_unregister_subdev(&state->sd);
>  	v4l2_device_unregister_subdev(sd);
>  	v4l2_ctrl_handler_free(&state->hdl);
>  
> -- 
> 1.7.4.1
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
