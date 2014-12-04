Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaLDIlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:41:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51746 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaLDIlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:41:00 -0500
Message-ID: <1417682410.3744.1.camel@pengutronix.de>
Subject: Re: [PATCH v16 03/12] drm: imx: imx-hdmi: convert imx-hdmi to
 drm_bridge mode
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andy Yan <andy.yan@rock-chips.com>, airlied@linux.ie, heiko@sntech.de,
        fabio.estevam@freescale.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        vladimir_zapolskiy@mentor.com, Kumar Gala <galak@codeaurora.org>
Date: Thu, 04 Dec 2014 09:40:10 +0100
In-Reply-To: <20141203163009.GG11285@n2100.arm.linux.org.uk>
References: <1417620408-30354-1-git-send-email-andy.yan@rock-chips.com>
	 <1417620566-30496-1-git-send-email-andy.yan@rock-chips.com>
	 <20141203153847.GC11285@n2100.arm.linux.org.uk>
	 <547F3495.9070206@rock-chips.com> <1417623615.5124.19.camel@pengutronix.de>
	 <20141203163009.GG11285@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Am Mittwoch, den 03.12.2014, 16:30 +0000 schrieb Russell King - ARM
Linux:
> On Wed, Dec 03, 2014 at 05:20:15PM +0100, Philipp Zabel wrote:
> > Hi Andy,
> > 
> > It would be better if the bind function would not have to care about
> > platform resources, that should be handled in the probe function. I had
> > a patch to move them:
> > 
> > http://lists.freedesktop.org/archives/dri-devel/2014-May/059630.html
> > 
> > Maybe you could incorporate something like this?
> 
> Personally, I hate this idea.  Having a two-layered setup means that
> the when the bind() method is called, the state of struct imx_hdmi is
> indeterminant.
> 
> If it's called immediately from probe, most of the structure will be
> zeroed, and only those members initialised by the probe function will
> be set to non-zero values.
> 
> However, if the HDMI interface has been previously bound, and is
> subsequently re-bound, then the structure will most definitely no
> longer be in a known state on the second bind() call.
> 
> This is fragile.
> 
> Now, people have tried to tell me that this isn't fragile, but, I now
> have proof that it is as fragile as I fear.  The component helper
> doesn't yet have that many users, and already we have one user (okay,
> it's not part of the mainline kernel - it's etnaviv) which contained
> exactly this kind of bug: it expected its private structures to be
> zeroed on the bind() call.
>
> So, I /really/ hate this idea.  If you really want to do this, then
> please ensure that the bind() call explicitly zeros the bits of the
> struct which aren't initialised by the probe() call, so we know that
> the driver will always start off with a known initial state.

You are right, no I don't want this. When I initially wrote this patch I
was under the impression that the memory allocated by devm_kzalloc in
bind() wouldn't be freed on unbind(). I remember I stopped pursuing this
patch when I got aware of the devres_open/close/remove_group dance in
the component framework code, but somehow forgot to drop it altogether
locally.

regards
Philipp

