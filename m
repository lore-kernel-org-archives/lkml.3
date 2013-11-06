Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab3KFOTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:19:38 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53012 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756443Ab3KFOTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:19:36 -0500
Date: Wed, 6 Nov 2013 16:19:01 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Frank =?iso-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        "open list:MT9M032 APTINA SE..." <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] videodev2: Set vb2_rect's width and height as unsigned
Message-ID: <20131106141901.GD24988@valkosipuli.retiisi.org.uk>
References: <1383742165-17634-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383742165-17634-1-git-send-email-ricardo.ribalda@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ricardo,

Thanks for the patch.

On Wed, Nov 06, 2013 at 01:49:25PM +0100, Ricardo Ribalda Delgado wrote:
...
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index ae66d91..9036e64 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2028,8 +2028,8 @@ static int smiapp_set_crop(struct v4l2_subdev *subdev,
>  	sel->r.width = min(sel->r.width, src_size->width);
>  	sel->r.height = min(sel->r.height, src_size->height);
>  
> -	sel->r.left = min(sel->r.left, src_size->width - sel->r.width);
> -	sel->r.top = min(sel->r.top, src_size->height - sel->r.height);
> +	sel->r.left = min(sel->r.left, (int) (src_size->width - sel->r.width));
> +	sel->r.top = min(sel->r.top, (int) (src_size->height - sel->r.height));

How about min_t(int, ... instead?

>  	*crops[sel->pad] = sel->r;
>  
> @@ -2121,8 +2121,10 @@ static int smiapp_set_selection(struct v4l2_subdev *subdev,
>  
>  	sel->r.left = max(0, sel->r.left & ~1);
>  	sel->r.top = max(0, sel->r.top & ~1);
> -	sel->r.width = max(0, SMIAPP_ALIGN_DIM(sel->r.width, sel->flags));
> -	sel->r.height = max(0, SMIAPP_ALIGN_DIM(sel->r.height, sel->flags));
> +	sel->r.width = max_t(unsigned int, 0,
> +			SMIAPP_ALIGN_DIM(sel->r.width, sel->flags));
> +	sel->r.height = max_t(unsigned int, 0,
> +			SMIAPP_ALIGN_DIM(sel->r.height, sel->flags));

The purpose of this check is to ensure the number is at least zero, and as
width and height are now unsigned, max_t() won't be needed anymore. Only
SMIAPP_ALIGN_DIM() is.

I can't see any harm from that, though --- there could be redundant checks
in other drivers, too.

>  	sel->r.width = max_t(unsigned int,
>  			     sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE],

Do you think it'd be worth adding a note on this change to the list of V4L2
in each kernel version in Documentation/DocBook/media/v4l/compat.xml?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
