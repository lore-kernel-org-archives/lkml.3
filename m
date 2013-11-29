Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab3K2S2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 13:28:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35576 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3K2S2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 13:28:23 -0500
Date: Fri, 29 Nov 2013 19:28:12 +0100
From: Michael Grzeschik <mgr@pengutronix.de>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] usb: chipidea: Fix Internal error: : 808 [#1] ARM
 related to STS flag
Message-ID: <20131129182812.GF3516@pengutronix.de>
References: <1385709585-10459-1-git-send-email-chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385709585-10459-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:25:53 up 70 days,  6:13, 24 users,  load average: 12,00, 12,50,
 12,74
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 03:19:45PM +0800, Chris Ruehl wrote:
> usb: chipidea: Fix Internal error: : 808 [#1] ARM related to STS flag
> 
> * init the sts flag to 0 (missed)
> * set the sts flag only if not 0
> 
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> ---
>  drivers/usb/chipidea/core.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index 5075407..1a6010e 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -245,6 +245,8 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
>  {
>  	u32 portsc, lpm, sts = 0;
>  
>  	switch (ci->platdata->phy_mode) {
>  	case USBPHY_INTERFACE_MODE_UTMI:
>  		portsc = PORTSC_PTS(PTS_UTMI);
> @@ -273,10 +275,12 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
>  
>  	if (ci->hw_bank.lpm) {
>  		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
> -		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
> +		if (sts)
> +			hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
>  	} else {
>  		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
> -		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
> +		if ( sts )
> +			hw_write(ci, OP_PORTSC, PORTSC_STS, sts);

The conditions coding style is broken.

>  	}
>  }

Still don't get why a system with ehci compliant PORTSC register
should not want to have the sts bit _explicitly_ set to 0 if
we don't use serial phy mode. So NACK!

Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
