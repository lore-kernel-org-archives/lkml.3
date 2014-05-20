Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaETIpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:45:54 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:55075 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaETIpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:45:51 -0400
Date: Tue, 20 May 2014 09:45:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: swarren@nvidia.com, wsa@the-dreams.de, abrestic@chromium.org,
        dgreid@chromium.org, olof@lixom.net, sjg@chromium.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] mfd: cros_ec: spi: Increase cros_ec_spi deadline
 from 5ms to 100ms
Message-ID: <20140520084545.GE24991@lee--X1>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
 <1398879850-9111-5-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398879850-9111-5-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014, Doug Anderson wrote:

> We're adding i2c tunneling to the list of things that goes over
> cros_ec.  i2c tunneling can be slooooooow, so increase our deadline to
> 100ms to account for that.
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
>  drivers/mfd/cros_ec_spi.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
> index 4f863c3..0b8d328 100644
> --- a/drivers/mfd/cros_ec_spi.c
> +++ b/drivers/mfd/cros_ec_spi.c
> @@ -39,14 +39,22 @@
>  #define EC_MSG_PREAMBLE_COUNT		32
>  
>  /*
> -  * We must get a response from the EC in 5ms. This is a very long
> -  * time, but the flash write command can take 2-3ms. The EC command
> -  * processing is currently not very fast (about 500us). We could
> -  * look at speeding this up and making the flash write command a
> -  * 'slow' command, requiring a GET_STATUS wait loop, like flash
> -  * erase.
> -  */
> -#define EC_MSG_DEADLINE_MS		5
> + * Allow for a long time for the EC to respond.  We support i2c
> + * tunneling and support fairly long messages for the tunnel (249
> + * bytes long at the moment).  If we're talking to a 100 kHz device
> + * on the other end and need to transfer ~256 bytes, then we need:
> + *  10 us/bit * ~10 bits/byte * ~256 bytes = ~25ms
> + *
> + * We'll wait 4 times that to handle clock stretching and other
> + * paranoia.
> + *
> + * It's pretty unlikely that we'll really see a 249 byte tunnel in
> + * anything other than testing.  If this was more common we might
> + * consider having slow commands like this require a GET_STATUS
> + * wait loop.  The 'flash write' command would be another candidate
> + * for this, clocking in at 2-3ms.
> + */
> +#define EC_MSG_DEADLINE_MS		100
>  
>  /*
>    * Time between raising the SPI chip select (for the end of a

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
