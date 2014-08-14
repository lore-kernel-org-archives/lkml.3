Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaHNUJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 16:09:43 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53795 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaHNUJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 16:09:41 -0400
Date: Thu, 14 Aug 2014 13:09:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: broonie@kernel.org, heiko@sntech.de, dianders@chromium.org,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com
Subject: Re: [PATCH] spi: rockchip: return 0 if tx_buf and rx_buf are NULL
Message-ID: <20140814200936.GA13458@core.coreip.homeip.net>
References: <1407977544-2989-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407977544-2989-1-git-send-email-addy.ke@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Addy,

On Thu, Aug 14, 2014 at 08:52:24AM +0800, Addy Ke wrote:
> To do so, spi communication can use an empty buf to pull up CS.
> 
> This patch merged from ChromiumOS tree.
> Cros_ec use this function to turn off CS and add a delay to ensure
> the rising edge doesn't come too soon after the end of the data.
> 
> Tested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
>  drivers/spi/spi-rockchip.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
> index 72fb287..1e3bcfa 100644
> --- a/drivers/spi/spi-rockchip.c
> +++ b/drivers/spi/spi-rockchip.c
> @@ -511,8 +511,8 @@ static int rockchip_spi_transfer_one(struct spi_master *master,
>  	WARN_ON((readl_relaxed(rs->regs + ROCKCHIP_SPI_SR) & SR_BUSY));
>  
>  	if (!xfer->tx_buf && !xfer->rx_buf) {
> -		dev_err(rs->dev, "No buffer for transfer\n");
> -		return -EINVAL;
> +		dev_dbg(rs->dev, "No buffer for transfer\n");
> +		return 0;
>  	}

Maybe we should only return 0 if xfer->len is also 0, otherwise keep
complaining loudly?

	if (!xfer->tx_buf && !xfer->rx_buf) {
		if (xfer->len == 0)
			return 0;

		dev_err(rs->dev, "Missing transfer buffer\n");
		return -EINVAL;
	}

Thanks.

-- 
Dmitry
