Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaETIpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:45:17 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:47938 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaETIpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:45:09 -0400
Date: Tue, 20 May 2014 09:45:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: swarren@nvidia.com, wsa@the-dreams.de, abrestic@chromium.org,
        dgreid@chromium.org, olof@lixom.net, sjg@chromium.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/7] mfd: cros_ec: spi: Make the cros_ec_spi timeout
 more reliable
Message-ID: <20140520084503.GD24991@lee--X1>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
 <1398879850-9111-4-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398879850-9111-4-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014, Doug Anderson wrote:

> The cros_ec_spi transfer had two problems with its timeout code:
> 
> 1. It looked at the timeout even in the case that it found valid data.
> 2. If the cros_ec_spi code got switched out for a while, it's possible
>    it could get a timeout after a single loop.  Let's be paranoid and
>    make sure we do one last transfer after the timeout expires.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Reviewed-by: Simon Glass <sjg@chromium.org>
> Tested-by: Andrew Bresticker <abrestic@chromium.org>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/mfd/cros_ec_spi.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
> index a2a605d..4f863c3 100644
> --- a/drivers/mfd/cros_ec_spi.c
> +++ b/drivers/mfd/cros_ec_spi.c
> @@ -113,7 +113,9 @@ static int cros_ec_spi_receive_response(struct cros_ec_device *ec_dev,
>  
>  	/* Receive data until we see the header byte */
>  	deadline = jiffies + msecs_to_jiffies(EC_MSG_DEADLINE_MS);
> -	do {
> +	while (true) {
> +		unsigned long start_jiffies = jiffies;
> +
>  		memset(&trans, 0, sizeof(trans));
>  		trans.cs_change = 1;
>  		trans.rx_buf = ptr = ec_dev->din;
> @@ -134,12 +136,19 @@ static int cros_ec_spi_receive_response(struct cros_ec_device *ec_dev,
>  				break;
>  			}
>  		}
> +		if (ptr != end)
> +			break;
>  
> -		if (time_after(jiffies, deadline)) {
> +		/*
> +		 * Use the time at the start of the loop as a timeout.  This
> +		 * gives us one last shot at getting the transfer and is useful
> +		 * in case we got context switched out for a while.
> +		 */
> +		if (time_after(start_jiffies, deadline)) {
>  			dev_warn(ec_dev->dev, "EC failed to respond in time\n");
>  			return -ETIMEDOUT;
>  		}
> -	} while (ptr == end);
> +	}
>  
>  	/*
>  	 * ptr now points to the header byte. Copy any valid data to the

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
