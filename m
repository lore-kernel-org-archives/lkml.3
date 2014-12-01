Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbaLAMHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:07:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45222 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaLAMHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:07:43 -0500
Message-ID: <1417435456.4624.12.camel@pengutronix.de>
Subject: Re: [PATCH v13 07/12] drm: bridge/dw_hdmi: add support for
 multi-byte register width access
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
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Date: Mon, 01 Dec 2014 13:04:16 +0100
In-Reply-To: <547843B9.6000806@rock-chips.com>
References: <1417008157-31861-1-git-send-email-andy.yan@rock-chips.com>
		 <1417008759-32257-1-git-send-email-andy.yan@rock-chips.com>
	 <1417019657.3177.10.camel@pengutronix.de> <547843B9.6000806@rock-chips.com>
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

Am Freitag, den 28.11.2014, 17:43 +0800 schrieb Andy Yan:
> Hi Zabel:
> On 2014年11月27日 00:34, Philipp Zabel wrote:
> > Am Mittwoch, den 26.11.2014, 21:32 +0800 schrieb Andy Yan:
> >> On rockchip rk3288, only word(32-bit) accesses are
> >> permitted for hdmi registers.  Byte width accesses (writeb,
> >> readb) generate an imprecise external abort.
> >>
> >> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
> >>
> >> ---
> >>
> >> Changes in v13: None
> >> Changes in v12: None
> >> Changes in v11: None
> >> Changes in v10: None
> >> Changes in v9: None
> >> Changes in v8: None
> >> Changes in v7: None
> >> Changes in v6:
> >> - refactor register access without reg_shift
> >>
> >> Changes in v5:
> >> - refactor reg-io-width
> >>
> >> Changes in v4: None
> >> Changes in v3:
> >> - split multi-register access to one indepent patch
> >>
> >>   drivers/gpu/drm/bridge/dw_hdmi.c | 57 +++++++++++++++++++++++++++++++++++-----
> >>   1 file changed, 51 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
> >> index a53bf63..5e88c8d 100644
> >> --- a/drivers/gpu/drm/bridge/dw_hdmi.c
> >> +++ b/drivers/gpu/drm/bridge/dw_hdmi.c
> >> @@ -100,6 +100,11 @@ struct hdmi_data_info {
> >>   	struct hdmi_vmode video_mode;
> >>   };
> >>   
> >> +union dw_reg_ptr {
> >> +	u32 __iomem *p32;
> >> +	u8 __iomem *p8;
> >> +};
> > I see no need to introduce this. Just explicitly multiply the offset in
> > dw_hdmi_writel.
> >
>      Is there any disadvantage to do like this?
>      The compiler can help us do the explicitly multiply by this way.

Four additional lines, a new defined type, a few more changes to struct
dw_hdmi and dw_hdmi_bind necessary.

Technically I see no problem to let the compiler do the multiplication,
my issue is that it ever so slightly obfuscates the code. Instead of
just writing "* 4" in two functions, we get a new union that you need to
know about when looking at struct dw_hdmi and dw_hdmi_bind, regs.p8 is
used but never assigned directly, it's just a tiny bit of additional
effort needed to understand the code. But when the cost to avoid that is
so small...

regards
Philipp

