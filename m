Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbaLAVW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:22:57 -0500
Received: from down.free-electrons.com ([37.187.137.238]:55618 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932080AbaLAVW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:22:56 -0500
Date: Mon, 1 Dec 2014 22:22:38 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Subject: Re: [PATCH v4 1/3] drm: add bus_formats and num_bus_formats fields
 to drm_display_info
Message-ID: <20141201222238.40e9ff86@bbrezillon>
In-Reply-To: <20141201154257.GD11943@ulmo.nvidia.com>
References: <1417422061-10384-1-git-send-email-boris.brezillon@free-electrons.com>
	<1417422061-10384-6-git-send-email-boris.brezillon@free-electrons.com>
	<20141201154257.GD11943@ulmo.nvidia.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Mon, 1 Dec 2014 16:42:58 +0100
Thierry Reding <thierry.reding@gmail.com> wrote:

> On Mon, Dec 01, 2014 at 09:20:59AM +0100, Boris Brezillon wrote:
> > Add bus_formats and num_bus_formats fields and
> > drm_display_info_set_bus_formats helper function to specify the bus
> > formats supported by a given display.
> > 
> > This information can be used by display controller drivers to configure
> > the output interface appropriately (i.e. RGB565, RGB666 or RGB888 on raw
> > RGB or LVDS busses).
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  drivers/gpu/drm/drm_crtc.c | 32 ++++++++++++++++++++++++++++++++
> >  include/drm/drm_crtc.h     |  7 +++++++
> >  2 files changed, 39 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> > index e79c8d3..d3b7ed0 100644
> > --- a/drivers/gpu/drm/drm_crtc.c
> > +++ b/drivers/gpu/drm/drm_crtc.c
> > @@ -763,6 +763,38 @@ static void drm_mode_remove(struct drm_connector *connector,
> >  	drm_mode_destroy(connector->dev, mode);
> >  }
> >  
> > +/*
> 
> This needs a /** marker to make it a valid kerneldoc comment.

Yep, I'll fix that.

> 
> > + * drm_display_info_set_bus_formats - set the supported bus formats
> > + * @info: display info to store bus formats in
> > + * @fmts: array containing the supported bus formats
> > + * @nfmts: the number of entries in the fmts array
> > + *
> > + * Store the suppported bus formats in display info structure.
> > + * See MEDIA_BUS_FMT_* definitions in include/uapi/linux/media-bus-format.h for
> > + * a full list of available formats.
> > + */
> > +int drm_display_info_set_bus_formats(struct drm_display_info *info, const u32 *fmts,
> 
> This one still exceeds 80-characters per line, but perhaps I'm reviewing
> the wrong patch? Also I think fmts should be formats here.
> 
> > +				     unsigned int num_fmts)
> 
> And this should be num_formats, for consistency. Also make sure to keep
> this consistent with the kerneldoc.
> 
> > +{
> > +	u32 *formats = NULL;
> 
> If you name the parameter formats, maybe bus_formats would be a good
> alternative for this local variable. Or fmts here. I think it's most
> important that the public API gets the more idiomatic name.

Okay, I'll rework the argument and variable names.

> 
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
> 
> I think you'll want to call kfree() on the bus_formats array from
> drm_connector_cleanup() as well to make sure you don't leak this on
> driver unload.

Indeed, I'll fix that memory leak.

Thanks,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
