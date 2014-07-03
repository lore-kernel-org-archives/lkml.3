Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbaGCHbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:31:38 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:44421 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbaGCHbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:31:36 -0400
Date: Thu, 3 Jul 2014 08:31:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/10] mfd: cros_ec: Check result code from EC messages
Message-ID: <20140703073129.GF30534@lee--X1>
References: <1403115247-8853-1-git-send-email-dianders@chromium.org>
 <1403115247-8853-9-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403115247-8853-9-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Doug Anderson wrote:

> From: Bill Richardson <wfrichar@chromium.org>
> 
> Just because the host was able to talk to the EC doesn't mean that the EC
> was happy with what it was told. Errors in communincation are not the same
> as error messages from the EC itself.
> 
> This change lets the EC report its errors separately.
> 
> [dianders: Added common function to cros_ec.c]
> 
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v2:
> - Added common function to cros_ec.c
> - Changed to dev_dbg() as per http://crosreview.com/66726
> 
>  drivers/mfd/cros_ec.c       | 18 ++++++++++++++++++
>  drivers/mfd/cros_ec_i2c.c   |  8 +++-----
>  drivers/mfd/cros_ec_spi.c   | 19 ++++++-------------
>  include/linux/mfd/cros_ec.h | 12 ++++++++++++
>  4 files changed, 39 insertions(+), 18 deletions(-)

Patch applied with Simon's Reviewed-by.

Clause: There is a chance that this patch might not be seen in -next
for ~24-48hrs.  If it's not there by 72hrs, feel free to poke.

> diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
> index 4851ed2..83e30c6 100644
> --- a/drivers/mfd/cros_ec.c
> +++ b/drivers/mfd/cros_ec.c
> @@ -44,6 +44,24 @@ int cros_ec_prepare_tx(struct cros_ec_device *ec_dev,
>  }
>  EXPORT_SYMBOL(cros_ec_prepare_tx);
>  
> +int cros_ec_check_result(struct cros_ec_device *ec_dev,
> +			 struct cros_ec_command *msg)
> +{
> +	switch (msg->result) {
> +	case EC_RES_SUCCESS:
> +		return 0;
> +	case EC_RES_IN_PROGRESS:
> +		dev_dbg(ec_dev->dev, "command 0x%02x in progress\n",
> +			msg->command);
> +		return -EAGAIN;
> +	default:
> +		dev_dbg(ec_dev->dev, "command 0x%02x returned %d\n",
> +			msg->command, msg->result);
> +		return 0;
> +	}
> +}
> +EXPORT_SYMBOL(cros_ec_check_result);
> +
>  static irqreturn_t ec_irq_thread(int irq, void *data)
>  {
>  	struct cros_ec_device *ec_dev = data;
> diff --git a/drivers/mfd/cros_ec_i2c.c b/drivers/mfd/cros_ec_i2c.c
> index 5bb32f5..189e7d1 100644
> --- a/drivers/mfd/cros_ec_i2c.c
> +++ b/drivers/mfd/cros_ec_i2c.c
> @@ -92,12 +92,10 @@ static int cros_ec_cmd_xfer_i2c(struct cros_ec_device *ec_dev,
>  	}
>  
>  	/* check response error code */
> -	if (i2c_msg[1].buf[0]) {
> -		dev_warn(ec_dev->dev, "command 0x%02x returned an error %d\n",
> -			 msg->command, i2c_msg[1].buf[0]);
> -		ret = -EINVAL;
> +	msg->result = i2c_msg[1].buf[0];
> +	ret = cros_ec_check_result(ec_dev, msg);
> +	if (ret)
>  		goto done;
> -	}
>  
>  	/* copy response packet payload and compute checksum */
>  	sum = in_buf[0] + in_buf[1];
> diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
> index 09ca789..c975087 100644
> --- a/drivers/mfd/cros_ec_spi.c
> +++ b/drivers/mfd/cros_ec_spi.c
> @@ -289,21 +289,14 @@ static int cros_ec_cmd_xfer_spi(struct cros_ec_device *ec_dev,
>  		goto exit;
>  	}
>  
> -	/* check response error code */
>  	ptr = ec_dev->din;
> -	if (ptr[0]) {
> -		if (ptr[0] == EC_RES_IN_PROGRESS) {
> -			dev_dbg(ec_dev->dev, "command 0x%02x in progress\n",
> -				ec_msg->command);
> -			ret = -EAGAIN;
> -			goto exit;
> -		}
> -		dev_warn(ec_dev->dev, "command 0x%02x returned an error %d\n",
> -			 ec_msg->command, ptr[0]);
> -		debug_packet(ec_dev->dev, "in_err", ptr, len);
> -		ret = -EINVAL;
> +
> +	/* check response error code */
> +	ec_msg->result = ptr[0];
> +	ret = cros_ec_check_result(ec_dev, ec_msg);
> +	if (ret)
>  		goto exit;
> -	}
> +
>  	len = ptr[1];
>  	sum = ptr[0] + ptr[1];
>  	if (len > ec_msg->insize) {
> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index 60c0880..1f79f16 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -143,6 +143,18 @@ int cros_ec_prepare_tx(struct cros_ec_device *ec_dev,
>  		       struct cros_ec_command *msg);
>  
>  /**
> + * cros_ec_check_result - Check ec_msg->result
> + *
> + * This is used by ChromeOS EC drivers to check the ec_msg->result for
> + * errors and to warn about them.
> + *
> + * @ec_dev: EC device
> + * @msg: Message to check
> + */
> +int cros_ec_check_result(struct cros_ec_device *ec_dev,
> +			 struct cros_ec_command *msg);
> +
> +/**
>   * cros_ec_remove - Remove a ChromeOS EC
>   *
>   * Call this to deregister a ChromeOS EC, then clean up any private data.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
