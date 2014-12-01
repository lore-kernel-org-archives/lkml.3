Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaLAPNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:13:50 -0500
Received: from down.free-electrons.com ([37.187.137.238]:53202 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753102AbaLAPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:13:48 -0500
Date: Mon, 1 Dec 2014 16:13:45 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>
Subject: Re: [PATCH v4 1/3] drm: add bus_formats and num_bus_formats fields
 to drm_display_info
Message-ID: <20141201161345.43137393@bbrezillon>
In-Reply-To: <1417446386.4624.17.camel@pengutronix.de>
References: <1417422061-10384-1-git-send-email-boris.brezillon@free-electrons.com>
	<1417422061-10384-2-git-send-email-boris.brezillon@free-electrons.com>
	<1417446386.4624.17.camel@pengutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Mon, 01 Dec 2014 16:06:26 +0100
Philipp Zabel <p.zabel@pengutronix.de> wrote:

> Am Montag, den 01.12.2014, 09:20 +0100 schrieb Boris Brezillon:
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
> > +				     unsigned int num_fmts)
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
> > index c40070a..a35844f 100644
> > --- a/include/drm/drm_crtc.h
> > +++ b/include/drm/drm_crtc.h
> > @@ -31,6 +31,7 @@
> >  #include <linux/idr.h>
> >  #include <linux/fb.h>
> >  #include <linux/hdmi.h>
> > +#include <linux/media-bus-format.h>
> 
> Nothing in drm_crtc.h uses MEDIA_BUS_FMT_*, is media-bus-format.h
> included here for the convenience of the user of
> drm_display_info_set_bus_formats?

Yes it is. Actually in the first versions MEDIA_BUS_FMT_* values were
part of an enum.
Still, I think keeping this include will help people finding where
those MEDIA_BUS_FMT_* macros are defined.

Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
