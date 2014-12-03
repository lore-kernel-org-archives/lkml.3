Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaLCQMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:12:03 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35956 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751897AbaLCQL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:11:59 -0500
Date: Wed, 3 Dec 2014 16:11:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, Philipp Zabel <p.zabel@pengutronix.de>, heiko@sntech.de,
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
Subject: Re: [PATCH v16 03/12] drm: imx: imx-hdmi: convert imx-hdmi to
 drm_bridge mode
Message-ID: <20141203161122.GF11285@n2100.arm.linux.org.uk>
References: <1417620408-30354-1-git-send-email-andy.yan@rock-chips.com>
 <1417620566-30496-1-git-send-email-andy.yan@rock-chips.com>
 <20141203153847.GC11285@n2100.arm.linux.org.uk>
 <547F3495.9070206@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547F3495.9070206@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 12:04:37AM +0800, Andy Yan wrote:
> Hi Russell:
> 
> On 2014年12月03日 23:38, Russell King - ARM Linux wrote:
> >On Wed, Dec 03, 2014 at 11:29:26PM +0800, Andy Yan wrote:
> >>+int imx_hdmi_bind(struct device *dev, struct device *master,
> >>+		  void *data, struct drm_encoder *encoder,
> >>+		  const struct imx_hdmi_plat_data *plat_data)
> >>  {
> >>  	struct platform_device *pdev = to_platform_device(dev);
> >>-	const struct of_device_id *of_id =
> >>-				of_match_device(imx_hdmi_dt_ids, dev);
> >>  	struct drm_device *drm = data;
> >>  	struct device_node *np = dev->of_node;
> >>  	struct device_node *ddc_node;
> >>@@ -1594,19 +1566,16 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
> >>  	struct resource *iores;
> >>  	int ret, irq;
> >>-	hdmi = devm_kzalloc(dev, sizeof(*hdmi), GFP_KERNEL);
> >>+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
> >>  	if (!hdmi)
> >>  		return -ENOMEM;
> >>-	hdmi->dev = dev;
> >>+	hdmi->plat_data = plat_data;
> >>+	hdmi->dev = &pdev->dev;
> >>+	hdmi->dev_type = plat_data->dev_type;
> >>  	hdmi->sample_rate = 48000;
> >>  	hdmi->ratio = 100;
> >>-
> >>-	if (of_id) {
> >>-		const struct platform_device_id *device_id = of_id->data;
> >>-
> >>-		hdmi->dev_type = device_id->driver_data;
> >>-	}
> >>+	hdmi->encoder = encoder;
> >I'd suggest changing imx_hdmi_bind() to take the struct resource and irq
> >number, and avoiding the platform device stuff altogether in here.
> >
>    Actually this is what the current code do: the resource and irq number
> are all handled in imx_hdmi_bind

I meant that imx_hdmi_bind should be passed these, so that it needs to
know nothing about the struct device beyond the generic device structure.
In other words, the dw-hdmi core should not assume that the struct device
is part of a platform device.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
