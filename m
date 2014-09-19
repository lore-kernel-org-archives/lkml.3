Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbaISR1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:27:39 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56064 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413AbaISR1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:27:37 -0400
Date: Fri, 19 Sep 2014 10:27:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] watchdog: dw_wdt: restart the counter immediately
 after enabling WDT
Message-ID: <20140919172732.GA716@roeck-us.net>
References: <1411108199-1280-1-git-send-email-jszhang@marvell.com>
 <1411108199-1280-2-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411108199-1280-2-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 02:29:58PM +0800, Jisheng Zhang wrote:
> The TOP_INIT may be zero, so the timeout period may be very short after

What is TOP_INIT ?

> initialization is done, thus the system may be reset soon after enabling.
> We fix this problem by restarting the counter immediately after enabling
> WDT.
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> ---
>  drivers/watchdog/dw_wdt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
> index 9f21029..ad0619d 100644
> --- a/drivers/watchdog/dw_wdt.c
> +++ b/drivers/watchdog/dw_wdt.c
> @@ -146,6 +146,7 @@ static int dw_wdt_open(struct inode *inode, struct file *filp)
>  		dw_wdt_set_top(DW_WDT_MAX_TOP);

This sets the timeout to the maximum, so I guess there must be some other
event/register (TOP_INIT ?) which can be zero.

>  		writel(WDOG_CONTROL_REG_WDT_EN_MASK,
>  		       dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);

What guarantees that the reset didn't already happen by the time
the keepalive call is executed ? Does this change fix the problem,
or does it just make it more unlikely to be seen ?

Thanks,
Guenter

> +		dw_wdt_keepalive();
>  	}
>  
>  	dw_wdt_set_next_heartbeat();
> -- 
> 2.1.0
> 
