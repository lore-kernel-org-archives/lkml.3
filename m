Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaE1QLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:11:34 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:59950 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaE1QLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:11:32 -0400
Date: Wed, 28 May 2014 09:11:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Tord Andersson <tord.o.andersson@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tord Andersson <tord.andersson@endian.se>
Subject: Re: [PATCH 1/1] watchdog: imx2: Added ioctl options to
 enable/disable watchdog as wanted by systemd.
Message-ID: <20140528161115.GB22194@roeck-us.net>
References: <1401289196-27567-1-git-send-email-tord.andersson@endian.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401289196-27567-1-git-send-email-tord.andersson@endian.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 04:59:56PM +0200, Tord Andersson wrote:
> When the current imx2 watchdog driver is used with the systemd watchdog feature,
> we get "Failed to enable hardware watchdog: Inappropriate ioctl for device".
> This is caused by missing ioctl setoptions to enable the watchdog.
> This patch will add WDIOC_SETOPTIONS for WDIOS_ENABLECARD and WDIOS_DISABLECARD.
> 
> Signed-off-by: Tord Andersson <tord.andersson@endian.se>
> ---

Hi Tord,

This driver is in the process of being concerted to use the watchdog
core API. See 'watchdog: imx2_wdt: convert to watchdog core api' [1]
from Anatolij Gustschin.

With this update, this patch becomes unnecessary.

Guenter

[1] http://patchwork.roeck-us.net/patch/1340/

>  drivers/watchdog/imx2_wdt.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> index dd51d95..180c6a5 100644
> --- a/drivers/watchdog/imx2_wdt.c
> +++ b/drivers/watchdog/imx2_wdt.c
> @@ -196,6 +196,17 @@ static long imx2_wdt_ioctl(struct file *file, unsigned int cmd,
>  		new_value = val & IMX2_WDT_WRSR_TOUT ? WDIOF_CARDRESET : 0;
>  		return put_user(new_value, p);
>  
> +	case WDIOC_SETOPTIONS:
> +		if (get_user(new_value, p))
> +			return -EFAULT;
> +		if (new_value & WDIOS_ENABLECARD)
> +			imx2_wdt_start();
> +		else if (new_value & WDIOS_DISABLECARD)
> +			imx2_wdt_stop();
> +		else
> +			return -EINVAL;
> +		return 0;
> +
>  	case WDIOC_KEEPALIVE:
>  		imx2_wdt_ping();
>  		return 0;
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
