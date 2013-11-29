Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3K2Kui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:50:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51900 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3K2Kug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:50:36 -0500
Date: Fri, 29 Nov 2013 11:50:24 +0100
From: Michael Grzeschik <mgr@pengutronix.de>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] usb: chipidea: Fix Internal error: : 808 [#1] ARM
 related to STS flag
Message-ID: <20131129105024.GC28906@pengutronix.de>
References: <1385690869-32266-1-git-send-email-chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385690869-32266-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:45:45 up 96 days, 20:16, 55 users,  load average: 0,47, 0,30,
 0,20
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 10:07:49AM +0800, Chris Ruehl wrote:
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
>  	u32 portsc, lpm, sts;
>  
> +	sts = 0;
> +

This makes sense, but should be moved up to the
variable declartion:

-  	u32 portsc, lpm, sts;
+  	u32 portsc, lpm, sts = 0;

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

What is wrong with explicit setting DEVLC_STS to 0 if we
know that we don't use serial phy mode?

>  	} else {
>  		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
> -		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
> +		if ( sts )
> +			hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
>  	}
>  }

ditto

Regards,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
