Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619AbaFRHeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:34:11 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:62761 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaFRHeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:34:08 -0400
Date: Wed, 18 Jun 2014 08:34:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        sameo@linux.intel.com, vpalatin@chromium.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] mfd: cros_ec: ec_dev->cmd_xfer() returns number of
 bytes received from EC
Message-ID: <20140618073401.GB21030@lee--X1>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
 <1402954800-28215-11-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402954800-28215-11-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Doug Anderson wrote:

> From: Bill Richardson <wfrichar@chromium.org>
> 
> When communicating with the EC, the cmd_xfer() function should return the
> number of bytes it received from the EC, or negative on error.
> 
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/i2c/busses/i2c-cros-ec-tunnel.c | 2 +-
>  drivers/mfd/cros_ec_i2c.c               | 2 +-
>  drivers/mfd/cros_ec_spi.c               | 2 +-
>  include/linux/mfd/cros_ec.h             | 8 ++++----
>  4 files changed, 7 insertions(+), 7 deletions(-)

For the re-spin:
  Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/i2c/busses/i2c-cros-ec-tunnel.c b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> index dd07818..05e033c 100644
> --- a/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> +++ b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> @@ -228,7 +228,7 @@ static int ec_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg i2c_msgs[],
>  	msg.insize = response_len;
>  
>  	result = bus->ec->cmd_xfer(bus->ec, &msg);
> -	if (result)
> +	if (result < 0)
>  		goto exit;
>  
>  	result = ec_i2c_parse_response(response, i2c_msgs, &num);
> diff --git a/drivers/mfd/cros_ec_i2c.c b/drivers/mfd/cros_ec_i2c.c
> index 2276096..dc0ba29 100644
> --- a/drivers/mfd/cros_ec_i2c.c
> +++ b/drivers/mfd/cros_ec_i2c.c
> @@ -120,7 +120,7 @@ static int cros_ec_cmd_xfer_i2c(struct cros_ec_device *ec_dev,
>  		goto done;
>  	}
>  
> -	ret = 0;
> +	ret = i2c_msg[1].buf[1];
>   done:
>  	kfree(in_buf);
>  	kfree(out_buf);
> diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
> index 4d34f1c..beba1bc 100644
> --- a/drivers/mfd/cros_ec_spi.c
> +++ b/drivers/mfd/cros_ec_spi.c
> @@ -333,7 +333,7 @@ static int cros_ec_cmd_xfer_spi(struct cros_ec_device *ec_dev,
>  		goto exit;
>  	}
>  
> -	ret = 0;
> +	ret = len;
>  exit:
>  	mutex_unlock(&ec_spi->lock);
>  	return ret;
> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index 60c0880..7b65a75 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -41,7 +41,7 @@ enum {
>   * @outdata: Outgoing data to EC
>   * @outsize: Outgoing length in bytes
>   * @indata: Where to put the incoming data from EC
> - * @insize: Incoming length in bytes (filled in by EC)
> + * @insize: Max number of bytes to accept from EC
>   * @result: EC's response to the command (separate from communication failure)
>   */
>  struct cros_ec_command {
> @@ -64,9 +64,9 @@ struct cros_ec_command {
>   * sleep at the last suspend
>   * @event_notifier: interrupt event notifier for transport devices
>   * @cmd_xfer: send command to EC and get response
> - *     Returns 0 if the communication succeeded, but that doesn't mean the EC
> - *     was happy with the command it got. Caller should check msg.result for
> - *     the EC's result code.
> + *     Returns the number of bytes received if the communication succeeded, but
> + *     that doesn't mean the EC was happy with the command. The caller
> + *     should check msg.result for the EC's result code.
>   *
>   * @priv: Private data
>   * @irq: Interrupt to use

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
