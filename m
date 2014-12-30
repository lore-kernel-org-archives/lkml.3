Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaL3Rjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 12:39:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40319 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaL3Rjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 12:39:47 -0500
Date: Tue, 30 Dec 2014 18:39:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Nishanth Menon <nm@ti.com>, linux-omap <linux-omap@vger.kernel.org>,
        sre@debian.org, Tony Lindgren <tony@atomide.com>, sre@ring0.de,
        ivo.g.dimitrov.75@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: v3.19-rc1 regression(?) on N900
Message-ID: <20141230173800.GA23142@amd>
References: <549B44E2.6080202@ti.com>
 <201412250932.40403@pali>
 <20141225091121.GA20355@amd>
 <20141225222122.GB582@fuloong-minipc.musicnaut.iki.fi>
 <54A10B1E.7030800@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A10B1E.7030800@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon 2014-12-29 10:04:46, Tomi Valkeinen wrote:
> Hi,
> 
> On 26/12/14 00:21, Aaro Koskinen wrote:
> 
> > ...however, I can confirm that framebuffer is broken:
> > 
> > [    8.230743] omapfb omapfb: no displays
> > [    8.255584] omapfb omapfb: failed to setup omapfb
> > [    8.260620] platform omapfb: Driver omapfb requests probe deferral
> > [    8.284118] of_get_named_gpiod_flags: parsed 'reset-gpios' property of node
> > '/ocp/spi@48098000/acx565akm@2[0]' - status (0)
> > [    8.284271] acx565akm spi1.2: failed to find video source
> > [    8.290069] spi spi1.2: Driver acx565akm requests probe deferral
> > 
> > I bisected it to ef691ff48bc8 (OMAPDSS: DT: Get source endpoint
> > by matching reg-id). When I revert that, also FB works with 3.19-rc1.
> 
> I've attached a patch for this. Only hack-tested on OMAP3 beagle, so
> please report if it works.

This fixes the issue for me.

Tested-by: Pavel Machek <pavel@ucw.cz>


> From fe3e8dde8eae80541a3f3b39c421428ebd02955f Mon Sep 17 00:00:00 2001
> From: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Date: Mon, 29 Dec 2014 09:57:11 +0200
> Subject: [PATCH] OMAPDSS: SDI: fix output port_num
> 
> After the commit ef691ff48bc8 (OMAPDSS: DT: Get source endpoint by
> matching reg-id) we look for the SDI output using the port number.
> However, the SDI driver doesn't set the port number, which causes the
> SDI display to not initialize.
> 
> Fix this by setting the SDI port number to 1. We use a hardcoded value,
> as SDI was used only on OMAP3 and it's always port number 1 there.
> 
> Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Reported-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> ---
>  drivers/video/fbdev/omap2/dss/sdi.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/video/fbdev/omap2/dss/sdi.c b/drivers/video/fbdev/omap2/dss/sdi.c
> index d51a983075bc..5c2ccab5a958 100644
> --- a/drivers/video/fbdev/omap2/dss/sdi.c
> +++ b/drivers/video/fbdev/omap2/dss/sdi.c
> @@ -342,6 +342,8 @@ static void sdi_init_output(struct platform_device *pdev)
>  	out->output_type = OMAP_DISPLAY_TYPE_SDI;
>  	out->name = "sdi.0";
>  	out->dispc_channel = OMAP_DSS_CHANNEL_LCD;
> +	/* We have SDI only on OMAP3, where it's on port 1 */
> +	out->port_num = 1;
>  	out->ops.sdi = &sdi_ops;
>  	out->owner = THIS_MODULE;
>  




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
