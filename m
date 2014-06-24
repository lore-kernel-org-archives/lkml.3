Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaFXI7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:59:34 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:38536 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaFXI7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:59:31 -0400
Date: Tue, 24 Jun 2014 09:59:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Dave Jones <davej@redhat.com>,
        rspangler@chromium.org, sjg@chromium.org, sameo@linux.intel.com,
        wfrichar@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: cros_ec: Remove EC_I2C_FLAG_10BIT
Message-ID: <20140624085925.GC13803@lee--X1>
References: <1403558406-14519-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403558406-14519-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014, Doug Anderson wrote:

> In <https://lkml.org/lkml/2014/6/10/265> pointed out that the 10-bit
> flag in the cros_ec_tunnel was useless.  It went into a 16-bit flags
> field but was defined at (1 << 16).
> 
> Since we have no 10-bit i2c devices on the other side of the tunnel on
> any known devices this was never a problem.  Until we do it makes
> sense to remove this code.  On the EC side the code to handle this
> flag was removed in <https://chromium-review.googlesource.com/204162>.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Note that this patch is based atop my current series of posts to
> cleanup cros_ec.  It wouldn't be hard to apply it to the current ToT
> if someone wants to land this before the others.
> 
>  drivers/i2c/busses/i2c-cros-ec-tunnel.c | 6 ++++--
>  include/linux/mfd/cros_ec_commands.h    | 3 ---

For the MFD part:
  Acked-by: Lee Jones <lee.jones@linaro.org>

>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-cros-ec-tunnel.c b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> index 05e033c..6d7d009 100644
> --- a/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> +++ b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> @@ -94,7 +94,7 @@ static int ec_i2c_construct_message(u8 *buf, const struct i2c_msg i2c_msgs[],
>  		msg->addr_flags = i2c_msg->addr;
>  
>  		if (i2c_msg->flags & I2C_M_TEN)
> -			msg->addr_flags |= EC_I2C_FLAG_10BIT;
> +			return -EINVAL;
>  
>  		if (i2c_msg->flags & I2C_M_RD) {
>  			msg->addr_flags |= EC_I2C_FLAG_READ;
> @@ -218,7 +218,9 @@ static int ec_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg i2c_msgs[],
>  		}
>  	}
>  
> -	ec_i2c_construct_message(request, i2c_msgs, num, bus_num);
> +	result = ec_i2c_construct_message(request, i2c_msgs, num, bus_num);
> +	if (result)
> +		goto exit;
>  
>  	msg.version = 0;
>  	msg.command = EC_CMD_I2C_PASSTHRU;
> diff --git a/include/linux/mfd/cros_ec_commands.h b/include/linux/mfd/cros_ec_commands.h
> index 7853a64..a49cd41 100644
> --- a/include/linux/mfd/cros_ec_commands.h
> +++ b/include/linux/mfd/cros_ec_commands.h
> @@ -1928,9 +1928,6 @@ struct ec_response_power_info {
>  
>  #define EC_CMD_I2C_PASSTHRU 0x9e
>  
> -/* Slave address is 10 (not 7) bit */
> -#define EC_I2C_FLAG_10BIT	(1 << 16)
> -
>  /* Read data; if not present, message is a write */
>  #define EC_I2C_FLAG_READ	(1 << 15)
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
