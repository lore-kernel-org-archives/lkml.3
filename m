Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3FKHYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:24:42 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:37357 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3FKHYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:24:40 -0400
Date: Tue, 11 Jun 2013 09:24:33 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drm: encoder_slave: respect of_node on i2c encoder init
Message-ID: <20130611072433.GP22870@phenom.ffwll.local>
Mail-Followup-To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org
References: <1370899422-1281-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370899422-1281-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Operating-System: Linux phenom 3.9.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 11:23:42PM +0200, Sebastian Hesselbarth wrote:
> Current DRM slave encoder API conflicts with auto-registration of i2c client
> when using DT probed clients. To allow DRM slave encoders passed by DT, this
> patch adds a check to drm_i2c_encoder_init for a non-NULL .of_node on
> i2c_board_info and calls an of_i2c helper to get the i2c client device
> instead of registering a new device.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Hm, I don't have much clue about how dt/of really works, but since of has
this nice probing/auto-instantiation thing I think we could simplify this
some more:
- Create a new drm_i2c_encoder_init_of which only takes a struct
  device_node *of_node argument instead of adap and info.
- I think we could also drop the call to ->set_config since presumably an
  of-enabled driver grabbed any required info already from the dt.

I think this way we could still share encoder slaves across tons of
platforms, only the init sequence (and specifically how they get at their
config data) would be different. That would also be extensible quite
easily (*cough* intel platforms could setup encoder slaves from
information out of the vbt *cough*).

And ofc, a (totally broken) exemplary conversion patch for tilcdc would be
neat ;-)

Cheers, Daniel
> ---
> Cc: David Airlie <airlied@linux.ie>
> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Cc: Darren Etheridge <darren.etheridge@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/gpu/drm/drm_encoder_slave.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_encoder_slave.c b/drivers/gpu/drm/drm_encoder_slave.c
> index 0cfb60f..36c0aa7 100644
> --- a/drivers/gpu/drm/drm_encoder_slave.c
> +++ b/drivers/gpu/drm/drm_encoder_slave.c
> @@ -25,6 +25,7 @@
>   */
>  
>  #include <linux/module.h>
> +#include <linux/of_i2c.h>
>  
>  #include <drm/drm_encoder_slave.h>
>  
> @@ -61,7 +62,10 @@ int drm_i2c_encoder_init(struct drm_device *dev,
>  
>  	request_module("%s%s", I2C_MODULE_PREFIX, info->type);
>  
> -	client = i2c_new_device(adap, info);
> +	if (info->of_node)
> +		client = of_find_i2c_device_by_node(info->of_node);
> +	else
> +		client = i2c_new_device(adap, info);
>  	if (!client) {
>  		err = -ENOMEM;
>  		goto fail;
> -- 
> 1.7.2.5
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
