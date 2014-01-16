Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaAPAyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:54:54 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58062 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752079AbaAPAyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:54:51 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] power: clock_ops.c: fixup clk prepare/unprepare count
Date: Thu, 16 Jan 2014 02:08:51 +0100
Message-ID: <5882532.MC6M7Hz6Wk@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1389702222-17260-2-git-send-email-ben.dooks@codethink.co.uk>
References: <1389702222-17260-1-git-send-email-ben.dooks@codethink.co.uk> <1389702222-17260-2-git-send-email-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 14, 2014 12:23:40 PM Ben Dooks wrote:
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

All three queued up for 3.14, thanks!

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
> @@ -43,6 +43,7 @@ static void pm_clk_acquire(struct device *dev, struct pm_clock_entry *ce)
>  	if (IS_ERR(ce->clk)) {
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
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
