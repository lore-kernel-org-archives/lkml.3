Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaAMTmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:42:10 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65012 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751875AbaAMTmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:42:02 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] power: clock_ops.c: check return of clk_enable() in pm_clk_resume()
Date: Mon, 13 Jan 2014 20:55:58 +0100
Message-ID: <1438385.ppqm7XWTt3@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1389445540-21426-2-git-send-email-ben.dooks@codethink.co.uk>
References: <1389445540-21426-1-git-send-email-ben.dooks@codethink.co.uk> <1389445540-21426-2-git-send-email-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 11, 2014 01:05:39 PM Ben Dooks wrote:
> The clk_enable() call in the pm_clk_resume() call returns an error
> that is not being checked. If clk_enable() fails then we should
> not set the state of the clock to PCE_STATUS_ENABLED.
> 
> Note, the issue of warning the user if this fails has not been
> addressed in this patch as this is not the only place the driver
> calls clk_enable().
> 
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
> ---
>  drivers/base/power/clock_ops.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
> index b9dd8fa..9bb95ab 100644
> --- a/drivers/base/power/clock_ops.c
> +++ b/drivers/base/power/clock_ops.c
> @@ -252,6 +252,7 @@ int pm_clk_resume(struct device *dev)
>  	struct pm_subsys_data *psd = dev_to_psd(dev);
>  	struct pm_clock_entry *ce;
>  	unsigned long flags;
> +	int ret;
>  
>  	dev_dbg(dev, "%s()\n", __func__);
>  
> @@ -262,8 +263,9 @@ int pm_clk_resume(struct device *dev)
>  
>  	list_for_each_entry(ce, &psd->clock_list, node) {
>  		if (ce->status < PCE_STATUS_ERROR) {
> -			clk_enable(ce->clk);
> -			ce->status = PCE_STATUS_ENABLED;
> +			ret = clk_enable(ce->clk);
> +			if (ret == 0)

Can you please use if (!ret) here?

And analogously in patch [3/3]?

> +				ce->status = PCE_STATUS_ENABLED;
>  		}
>  	}
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
