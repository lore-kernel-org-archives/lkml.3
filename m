Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3GKIkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:40:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39159 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab3GKIkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:40:07 -0400
Message-ID: <51DE6F19.6050606@ti.com>
Date: Thu, 11 Jul 2013 14:08:49 +0530
From: Archit Taneja <archit@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] omapfb: In omapfb_probe return -EPROBE_DEFER when display
 driver is not loaded yet
References: <1373461739-10168-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1373461739-10168-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.24.145.166]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 10 July 2013 06:38 PM, Pali Rohár wrote:
> * On RX-51 probing for acx565akm driver is later then for omapfb which cause that omapfb probe fail and framebuffer is not working
> * EPROBE_DEFER causing that kernel try to probe for omapfb later again which fixing this problem
>
> * Without this patch display on Nokia RX-51 (N900) phone not working
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>   drivers/video/omap2/omapfb/omapfb-main.c |    9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/drivers/video/omap2/omapfb/omapfb-main.c b/drivers/video/omap2/omapfb/omapfb-main.c
> index 856917b..93e7c84 100644
> --- a/drivers/video/omap2/omapfb/omapfb-main.c
> +++ b/drivers/video/omap2/omapfb/omapfb-main.c
> @@ -2419,6 +2419,15 @@ static int omapfb_probe(struct platform_device *pdev)
>   	if (omapdss_is_initialized() == false)
>   		return -EPROBE_DEFER;
>
> +	dssdev = NULL;
> +	for_each_dss_dev(dssdev) {
> +		if (!dssdev->driver) {
> +			dev_warn(&pdev->dev, "no driver for display: %s\n",
> +				dssdev->name);
> +			return -EPROBE_DEFER;

This will make omapfb probe defer till the time every panel has a 
driver. It's possible that all the panel driver modules are never 
interested by userspace. This will lead to the panels having drivers 
also not work.

I think Tomi was working on this, it was something like making omapfb 
defer only if the default display doesn't have a driver. We can wait for 
his comment.

Archit

> +		}
> +	}
> +
>   	if (pdev->num_resources != 0) {
>   		dev_err(&pdev->dev, "probed for an unknown device\n");
>   		r = -ENODEV;
>

