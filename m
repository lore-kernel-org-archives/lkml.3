Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaKKOY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:24:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50824 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaKKOY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:24:26 -0500
Message-ID: <1415715820.2815.9.camel@pengutronix.de>
Subject: Re: [PATCH v7 5/7] drm: bridge/dw-hdmi: add support for multi byte
 register width access
From: Lucas Stach <l.stach@pengutronix.de>
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Cc: Andy Yan <andy.yan@rock-chips.com>, airlied@linux.ie, heiko@sntech.de,
        fabio.estevam@freescale.com, rmk+kernel@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        djkurtz@google.com, ykk@rock-chips.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org,
        jay.xu@rock-chips.com
Date: Tue, 11 Nov 2014 15:23:40 +0100
In-Reply-To: <54621B23.1020602@imgtec.com>
References: <1415710229-11935-1-git-send-email-andy.yan@rock-chips.com>
	 <1415710432-12167-1-git-send-email-andy.yan@rock-chips.com>
	 <54621B23.1020602@imgtec.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 11.11.2014, 14:20 +0000 schrieb Zubair Lutfullah
Kakakhel:
> Hi Andy,
> 
> This patch adds the reg-io-width binding.
> 
> Hence the binding patch should come before it.
> 
> 
> On 11/11/14 12:53, Andy Yan wrote:
> > On rockchip rk3288, only word(32-bit) accesses are
> > permitted for hdmi registers.  Byte width accesses (writeb,
> > readb) generate an imprecise external abort.
> > 
> > Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
> > 
> > ---
> > 
> >  }
> >  
> >  static void hdmi_modb(struct dw_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
> > @@ -1499,6 +1527,23 @@ static int dw_hdmi_bind(struct device *dev, struct device *master, void *data)
> >  	struct device_node *ddc_node;
> >  	struct resource *iores;
> >  	int ret, irq;
> > +	u32 val = 1;
> > +
> > +	of_property_read_u32(np, "reg-io-width", &val);
> > +
> > +	switch (val) {
> > +	case 4:
> > +		hdmi->write = dw_hdmi_writel;
> > +		hdmi->read = dw_hdmi_readl;
> > +		break;
> > +	case 1:
> > +		hdmi->write = dw_hdmi_writeb;
> > +		hdmi->read = dw_hdmi_readb;
> > +		break;
> > +	default:
> > +		dev_err(dev, "reg-io-width must be 1 or 4\n");
> > +		return -EINVAL;
> > +	}
> 
> The binding patch says this is an optional property.
> But here if undefined it returns -EINVAL.
> 
> I would keep it optional and default it to byte access.

That's exactly what the patch does. val is initialized to 1, which is
not changed if the property could not be found in the DT. The default
case will only be taken if the property is present in DT but has any
other value than 1 or 4, which is an error.

Regards,
Lucas

-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

