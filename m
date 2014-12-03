Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaLCQUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:20:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55613 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbaLCQUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:20:48 -0500
Message-ID: <1417623615.5124.19.camel@pengutronix.de>
Subject: Re: [PATCH v16 03/12] drm: imx: imx-hdmi: convert imx-hdmi to
 drm_bridge mode
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, airlied@linux.ie,
        heiko@sntech.de, fabio.estevam@freescale.com,
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
Date: Wed, 03 Dec 2014 17:20:15 +0100
In-Reply-To: <547F3495.9070206@rock-chips.com>
References: <1417620408-30354-1-git-send-email-andy.yan@rock-chips.com>
	 <1417620566-30496-1-git-send-email-andy.yan@rock-chips.com>
	 <20141203153847.GC11285@n2100.arm.linux.org.uk>
	 <547F3495.9070206@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Am Donnerstag, den 04.12.2014, 00:04 +0800 schrieb Andy Yan:
> On 2014年12月03日 23:38, Russell King - ARM Linux wrote:
> > On Wed, Dec 03, 2014 at 11:29:26PM +0800, Andy Yan wrote:
> >> +int imx_hdmi_bind(struct device *dev, struct device *master,
> >> +		  void *data, struct drm_encoder *encoder,
> >> +		  const struct imx_hdmi_plat_data *plat_data)
> >>   {
> >>   	struct platform_device *pdev = to_platform_device(dev);
> >> -	const struct of_device_id *of_id =
> >> -				of_match_device(imx_hdmi_dt_ids, dev);
> >>   	struct drm_device *drm = data;
> >>   	struct device_node *np = dev->of_node;
> >>   	struct device_node *ddc_node;
> >> @@ -1594,19 +1566,16 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
> >>   	struct resource *iores;
> >>   	int ret, irq;
> >>   
> >> -	hdmi = devm_kzalloc(dev, sizeof(*hdmi), GFP_KERNEL);
> >> +	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
> >>   	if (!hdmi)
> >>   		return -ENOMEM;
> >>   
> >> -	hdmi->dev = dev;
> >> +	hdmi->plat_data = plat_data;
> >> +	hdmi->dev = &pdev->dev;
> >> +	hdmi->dev_type = plat_data->dev_type;
> >>   	hdmi->sample_rate = 48000;
> >>   	hdmi->ratio = 100;
> >> -
> >> -	if (of_id) {
> >> -		const struct platform_device_id *device_id = of_id->data;
> >> -
> >> -		hdmi->dev_type = device_id->driver_data;
> >> -	}
> >> +	hdmi->encoder = encoder;
> > I'd suggest changing imx_hdmi_bind() to take the struct resource and irq
> > number, and avoiding the platform device stuff altogether in here.
> >
>     Actually this is what the current code do: the resource and irq number
> are all handled in imx_hdmi_bind

It would be better if the bind function would not have to care about
platform resources, that should be handled in the probe function. I had
a patch to move them:

http://lists.freedesktop.org/archives/dri-devel/2014-May/059630.html

Maybe you could incorporate something like this?

regards
Philipp

