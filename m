Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaALWES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 17:04:18 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:52774 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaALWEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 17:04:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] power: clock_ops.c: fixup clk prepare/unprepare count
Date: Sun, 12 Jan 2014 23:04:56 +0100
Message-ID: <2133074.4EFCIDJZXE@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.25-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1389445540-21426-1-git-send-email-ben.dooks@codethink.co.uk>
References: <1389445540-21426-1-git-send-email-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Thank you for the patch.

On Saturday 11 January 2014 13:05:38 Ben Dooks wrote:
> The drivers/base/power/clock_ops.c file is causing warnings from
> the clock driver (as shown below) due to failing to do a clk_prepare()
> call before enabling a clock. It also fails to check the balance of
> prepare/unprepare as __pm_clk_remove() do clk_disable_unprepare() call.
> 
> This bug has probably been in since commit b2476490e ("clk: introduce
> the common clock framework") as the warning was part of the original
> commit. It is strange that it has not been noticed (although this has
> also been coupled with a failure for certain SH builds to not build the
> necessary glue to use this method of controlling the clocks).
>
> In summary, this is probably needed in several stable branches but need
> advice on which ones.
> 
> On the Renesas Lager board, this causes numerous warnings of the following
> and even worse the clock system will not enable clocks, causing drivers
> that are in development to fail to work:
> 
> WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:883 __clk_enable+0x2c/0xa0()

I've never noticed this on Lager, probably because Lager multiplatform doesn't 
make use of clock_ops.c as drivers/sh/pm_runtime.c (which you addressed in 
another patch that I've also replied to). I'm thus not sure we need to apply 
this as a fix and backport it to stable branches.

> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
> ---
>  drivers/base/power/clock_ops.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
> index 9d8fde7..b9dd8fa 100644
> --- a/drivers/base/power/clock_ops.c
> +++ b/drivers/base/power/clock_ops.c
> @@ -43,6 +43,7 @@ static void pm_clk_acquire(struct device *dev, struct
> pm_clock_entry *ce) if (IS_ERR(ce->clk)) {
>  		ce->status = PCE_STATUS_ERROR;
>  	} else {
> +		clk_prepare(ce->clk);
>  		ce->status = PCE_STATUS_ACQUIRED;
>  		dev_dbg(dev, "Clock %s managed by runtime PM.\n", ce->con_id);
>  	}
> @@ -99,10 +100,12 @@ static void __pm_clk_remove(struct pm_clock_entry *ce)
> 
>  	if (ce->status < PCE_STATUS_ERROR) {
>  		if (ce->status == PCE_STATUS_ENABLED)
> -			clk_disable_unprepare(ce->clk);
> +			clk_disable(ce->clk);
> 
> -		if (ce->status >= PCE_STATUS_ACQUIRED)
> +		if (ce->status >= PCE_STATUS_ACQUIRED) {
> +			clk_unprepare(ce->clk);
>  			clk_put(ce->clk);
> +		}
>  	}
> 
>  	kfree(ce->con_id);
-- 
Regards,

Laurent Pinchart

