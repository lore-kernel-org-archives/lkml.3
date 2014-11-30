Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaK3MjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:39:17 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45906 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751943AbaK3MjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:39:16 -0500
Date: Sun, 30 Nov 2014 13:39:11 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/3] drm: add bus_formats and nbus_formats fields to
 drm_display_info
Message-ID: <20141130133911.2daef8f4@bbrezillon>
In-Reply-To: <56712774.y8GaD3rGMh@avalon>
References: <1416318380-20122-1-git-send-email-boris.brezillon@free-electrons.com>
	<1416318380-20122-2-git-send-email-boris.brezillon@free-electrons.com>
	<56712774.y8GaD3rGMh@avalon>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Sat, 29 Nov 2014 00:13:47 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> Hi Boris,
> 
> Thank you for the patch. I just have two small comments.
> 
> On Tuesday 18 November 2014 14:46:18 Boris Brezillon wrote:
> > Add bus_formats and nbus_formats fields and
> > drm_display_info_set_bus_formats helper function to specify the bus
> > formats supported by a given display.
> > 
> > This information can be used by display controller drivers to configure
> > the output interface appropriately (i.e. RGB565, RGB666 or RGB888 on raw
> > RGB or LVDS busses).
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  drivers/gpu/drm/drm_crtc.c | 30 ++++++++++++++++++++++++++++++
> >  include/drm/drm_crtc.h     |  7 +++++++
> >  2 files changed, 37 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> > index e79c8d3..17e3acf 100644
> > --- a/drivers/gpu/drm/drm_crtc.c
> > +++ b/drivers/gpu/drm/drm_crtc.c
> > @@ -763,6 +763,36 @@ static void drm_mode_remove(struct drm_connector
> > *connector, drm_mode_destroy(connector->dev, mode);
> >  }
> > 
> > +/*
> > + * drm_display_info_set_bus_formats - set the supported bus formats
> > + * @info: display info to store bus formats in
> > + * @fmts: array containing the supported bus formats
> > + * @nfmts: the number of entries in the fmts array
> > + *
> > + * Store the suppported bus formats in display info structure.
> 
> Could you document that the formats are specified as MEDIA_BUS_FMT_* values ?

Sure, I'll clearly state that.

> 
> > + */
> > +int drm_display_info_set_bus_formats(struct drm_display_info *info, const
> > u32 *fmts, +				     unsigned int num_fmts)
> > +{
> > +	u32 *formats = NULL;
> > +
> > +	if (!fmts && num_fmts)
> > +		return -EINVAL;
> > +
> > +	if (fmts && num_fmts) {
> > +		formats = kmemdup(fmts, sizeof(*fmts) * num_fmts, GFP_KERNEL);
> > +		if (!formats)
> > +			return -ENOMEM;
> > +	}
> > +
> > +	kfree(info->bus_formats);
> > +	info->bus_formats = formats;
> > +	info->num_bus_formats = num_fmts;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(drm_display_info_set_bus_formats);
> > +
> >  /**
> >   * drm_connector_get_cmdline_mode - reads the user's cmdline mode
> >   * @connector: connector to quwery
> > diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
> > index c40070a..2e0a3e8 100644
> > --- a/include/drm/drm_crtc.h
> > +++ b/include/drm/drm_crtc.h
> > @@ -31,6 +31,7 @@
> >  #include <linux/idr.h>
> >  #include <linux/fb.h>
> >  #include <linux/hdmi.h>
> > +#include <linux/media-bus-format.h>
> >  #include <uapi/drm/drm_mode.h>
> >  #include <uapi/drm/drm_fourcc.h>
> >  #include <drm/drm_modeset_lock.h>
> > @@ -130,6 +131,9 @@ struct drm_display_info {
> >  	enum subpixel_order subpixel_order;
> >  	u32 color_formats;
> > 
> > +	const u32 *bus_formats;
> > +	int num_bus_formats;
> 
> As the number of formats is never negative, I would make it an unsigned int.

Okay, I'll make it an unsigned int.

Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
