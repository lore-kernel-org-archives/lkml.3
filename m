Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3J2NYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:24:34 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35669 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3J2NYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:24:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] clocksource: sh_mtu2: Add clk_prepare/unprepare support
Date: Tue, 29 Oct 2013 14:24:57 +0100
Message-ID: <12808622.W4bQC68mNI@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.7-gentoo-r1; KDE/4.10.5; x86_64; ; )
In-Reply-To: <526F98BD.9000904@cogentembedded.com>
References: <1383000569-8916-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1383000569-8916-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <526F98BD.9000904@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Tuesday 29 October 2013 15:15:09 Sergei Shtylyov wrote:
> On 29-10-2013 2:49, Laurent Pinchart wrote:
> > Prepare the clock at probe time, as there is no other appropriate place
> > in the driver where we're allowed to sleep.
> > 
> > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >   drivers/clocksource/sh_mtu2.c | 16 ++++++++++++++--
> >   1 file changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
> > index 4aac9ee..3cf1283 100644
> > --- a/drivers/clocksource/sh_mtu2.c
> > +++ b/drivers/clocksource/sh_mtu2.c
> > @@ -313,8 +313,20 @@ static int sh_mtu2_setup(struct sh_mtu2_priv *p,
> > struct platform_device *pdev)> 
> >   		goto err1;
> >   	}
> > 
> > -	return sh_mtu2_register(p, (char *)dev_name(&p->pdev->dev),
> > -				cfg->clockevent_rating);
> > +	ret = clk_prepare(p->clk);
> > +	if (ret < 0)
> > +		goto err2;
> > +
> > +	ret = sh_mtu2_register(p, (char *)dev_name(&p->pdev->dev),
> > +			       cfg->clockevent_rating);
> > +	if (ret < 0)
> > +		goto err3;
> > +
> > +	return 0;
> > + err3:
> > +	clk_unprepare(p->clk);
> > + err2:
> > +	clk_put(p->clk);
> 
>     This one seems to be a fix and so needs to be in a separate patch...

I'll split the patch and repost (same for 03/12)

-- 
Regards,

Laurent Pinchart

