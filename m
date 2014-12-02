Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbaLBNBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:01:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43389 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbaLBNBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:01:36 -0500
Message-ID: <1417525257.3411.12.camel@pengutronix.de>
Subject: Re: [PATCH v15 12/12] drm: bridge/dw_hdmi: add rockchip rk3288
 support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk,
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
        Mark Rutland <mark.rutland@arm.com>, vladimir_zapolskiy@mentor.com,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Date: Tue, 02 Dec 2014 14:00:57 +0100
In-Reply-To: <547DB1ED.7000409@rock-chips.com>
References: <1417505778-18341-1-git-send-email-andy.yan@rock-chips.com>
		 <1417506327-18908-1-git-send-email-andy.yan@rock-chips.com>
	 <1417515882.3411.8.camel@pengutronix.de> <547DB1ED.7000409@rock-chips.com>
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

Am Dienstag, den 02.12.2014, 20:34 +0800 schrieb Andy Yan:
> Hi Philipp:
> On 2014年12月02日 18:24, Philipp Zabel wrote:
> > Hi Andy,
> >
> > Am Dienstag, den 02.12.2014, 15:45 +0800 schrieb Andy Yan:
> > [...]
> >> +static int dw_hdmi_rockchip_bind(struct device *dev, struct device *master,
> >> +				 void *data)
> >> +{
> >> +	struct platform_device *pdev = to_platform_device(dev);
> >> +	const struct dw_hdmi_plat_data *plat_data;
> >> +	const struct of_device_id *match;
> >> +	struct drm_device *drm = data;
> >> +	struct drm_encoder *encoder;
> >> +	struct rockchip_hdmi *hdmi;
> >> +	int ret;
> >> +
> >> +	if (!pdev->dev.of_node)
> >> +		return -ENODEV;
> >> +
> >> +	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
> >> +	if (!hdmi)
> >> +		return -ENOMEM;
> >> +
> >> +	match = of_match_node(dw_hdmi_rockchip_ids, pdev->dev.of_node);
> >> +	plat_data = match->data;
> >> +	hdmi->dev = &pdev->dev;
> >> +	encoder = &hdmi->encoder;
> >> +	platform_set_drvdata(pdev, hdmi);
> >> +
> >> +	ret = rockchip_hdmi_parse_dt(hdmi);
> >> +	if (ret) {
> >> +		dev_err(hdmi->dev, "Unable to parse OF data\n");
> >> +		return ret;
> >> +	}
> >> +
> >> +	ret = clk_prepare_enable(hdmi->clk);
> >> +	if (ret) {
> >> +		dev_err(hdmi->dev, "Cannot enable HDMI clock: %d\n", ret);
> >> +		return ret;
> >> +	}
> >> +
> >> +	ret = clk_prepare_enable(hdmi->hdcp_clk);
> >> +	if (ret) {
> >> +		dev_err(hdmi->dev, "Cannot enable HDMI hdcp clock: %d\n", ret);
> >> +		return ret;
> >> +	}
> > Could we have a look at the clocks again? Basically the Rockchip clock
> > handling is exactly the same, except the clocks are called by other
> > names.
> >
> > On i.MX6, according to the reference manual, the HDMI TX module has four
> > clock inputs: "iahbclk" (bus clock), "icecclk" (32 kHz CEC clock),
> > "ihclk" (module clock), and "isfrclk" (27 MHz internal SFR clock).
> > The "iahbclk" and "ihclk" are both sourced from the SoC AHB root clock,
> > the 32 kHz reference input can't be gated, and the "isfrclk" has its own
> > gate.
> >
> > Does the HDMI TX implementation on Rockchip still have the separate
> > external sfr bus and module clock inputs? I assume that your "clk" input
> > is a single gate bit for bus and module clocks at the same time?
> > If possible, I'd prefer to find a common binding for the clocks with
> > some of the clocks being optional, but for that we need to know the
> > actual clock inputs to the HDMI TX module.
> >
> > regards
> > Philipp
> >
>      There are three  individual clock inputs on Rockchip RK3288 HDMI: 
> "hdmi_ctrl_clk",
>      "hdmi_cec_clk", "hdmi_hdcp_clk", the three clocks are responsible 
> for different
>       functions as their name described, and have their own private gate 
> bit. That is
>       to say, the cec_clk and hdcp_clk can all be disabled if we don't 
> need hdcp and cec
>       function.
>       So I think it's better to make the clk control platform independent.

My question is not about the available gates at the SoC level, but about
the actual clock inputs from point of view of the HDMI TX IP.

It could be that the hdmi_ctrl_clk gates all inputs to the module and
bus clocks together. If so, you could just reuse "isfr" and "iahb" and
set it to the same clock. If not, we'd need to think of something else.
Unfortunately I don't have any Synopsys documentation of the HDMI TX at
that level.

regards
Philipp

