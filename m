Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaGCHbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:31:06 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:45514 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbaGCHbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:31:03 -0400
Date: Thu, 3 Jul 2014 08:30:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        dmitry.torokhov@gmail.com, sameo@linux.intel.com, geert@linux-m68k.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 07/10] mfd: cros_ec: cleanup: Remove EC wrapper
 functions
Message-ID: <20140703073056.GE30534@lee--X1>
References: <1403115247-8853-1-git-send-email-dianders@chromium.org>
 <1403115247-8853-8-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403115247-8853-8-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Doug Anderson wrote:

> From: Bill Richardson <wfrichar@chromium.org>
> 
> Remove the three wrapper functions that talk to the EC without passing all
> the desired arguments and just use the underlying communication function
> that passes everything in a struct intead.
> 
> This is internal code refactoring only. Nothing should change.
> 
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Reviewed-by: Simon Glass <sjg@chromium.org>
> ---
> Changes in v2:
> - Removed unneeded "ret" variable.
> 
>  drivers/i2c/busses/i2c-cros-ec-tunnel.c | 15 +++++++++++----
>  drivers/input/keyboard/cros_ec_keyb.c   | 12 ++++++++++--
>  drivers/mfd/cros_ec.c                   | 32 --------------------------------
>  include/linux/mfd/cros_ec.h             | 19 ++++++-------------
>  4 files changed, 27 insertions(+), 51 deletions(-)

Patch applied with Wolfram and Dmitry's Acks.

Clause: There is a chance that this patch might not be seen in -next
for ~24-48hrs.  If it's not there by 72hrs, feel free to poke.

> diff --git a/drivers/i2c/busses/i2c-cros-ec-tunnel.c b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> index 8e7a714..dd07818 100644
> --- a/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> +++ b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> @@ -183,6 +183,7 @@ static int ec_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg i2c_msgs[],
>  	u8 *request = NULL;
>  	u8 *response = NULL;
>  	int result;
> +	struct cros_ec_command msg;
>  
>  	request_len = ec_i2c_count_message(i2c_msgs, num);
>  	if (request_len < 0) {
> @@ -218,9 +219,15 @@ static int ec_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg i2c_msgs[],
>  	}
>  
>  	ec_i2c_construct_message(request, i2c_msgs, num, bus_num);
> -	result = bus->ec->command_sendrecv(bus->ec, EC_CMD_I2C_PASSTHRU,
> -					   request, request_len,
> -					   response, response_len);
> +
> +	msg.version = 0;
> +	msg.command = EC_CMD_I2C_PASSTHRU;
> +	msg.outdata = request;
> +	msg.outsize = request_len;
> +	msg.indata = response;
> +	msg.insize = response_len;
> +
> +	result = bus->ec->cmd_xfer(bus->ec, &msg);
>  	if (result)
>  		goto exit;
>  
> @@ -258,7 +265,7 @@ static int ec_i2c_probe(struct platform_device *pdev)
>  	u32 remote_bus;
>  	int err;
>  
> -	if (!ec->command_sendrecv) {
> +	if (!ec->cmd_xfer) {
>  		dev_err(dev, "Missing sendrecv\n");
>  		return -EINVAL;
>  	}
> diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
> index 4083796..b8341ab 100644
> --- a/drivers/input/keyboard/cros_ec_keyb.c
> +++ b/drivers/input/keyboard/cros_ec_keyb.c
> @@ -191,8 +191,16 @@ static void cros_ec_keyb_close(struct input_dev *dev)
>  
>  static int cros_ec_keyb_get_state(struct cros_ec_keyb *ckdev, uint8_t *kb_state)
>  {
> -	return ckdev->ec->command_recv(ckdev->ec, EC_CMD_MKBP_STATE,
> -					  kb_state, ckdev->cols);
> +	struct cros_ec_command msg = {
> +		.version = 0,
> +		.command = EC_CMD_MKBP_STATE,
> +		.outdata = NULL,
> +		.outsize = 0,
> +		.indata = kb_state,
> +		.insize = ckdev->cols,
> +	};
> +
> +	return ckdev->ec->cmd_xfer(ckdev->ec, &msg);
>  }
>  
>  static int cros_ec_keyb_work(struct notifier_block *nb,
> diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
> index 49ed8c3..4851ed2 100644
> --- a/drivers/mfd/cros_ec.c
> +++ b/drivers/mfd/cros_ec.c
> @@ -44,34 +44,6 @@ int cros_ec_prepare_tx(struct cros_ec_device *ec_dev,
>  }
>  EXPORT_SYMBOL(cros_ec_prepare_tx);
>  
> -static int cros_ec_command_sendrecv(struct cros_ec_device *ec_dev,
> -		uint16_t cmd, void *out_buf, int out_len,
> -		void *in_buf, int in_len)
> -{
> -	struct cros_ec_command msg;
> -
> -	msg.version = cmd >> 8;
> -	msg.command = cmd & 0xff;
> -	msg.outdata = out_buf;
> -	msg.outsize = out_len;
> -	msg.indata = in_buf;
> -	msg.insize = in_len;
> -
> -	return ec_dev->cmd_xfer(ec_dev, &msg);
> -}
> -
> -static int cros_ec_command_recv(struct cros_ec_device *ec_dev,
> -		uint16_t cmd, void *buf, int buf_len)
> -{
> -	return cros_ec_command_sendrecv(ec_dev, cmd, NULL, 0, buf, buf_len);
> -}
> -
> -static int cros_ec_command_send(struct cros_ec_device *ec_dev,
> -		uint16_t cmd, void *buf, int buf_len)
> -{
> -	return cros_ec_command_sendrecv(ec_dev, cmd, buf, buf_len, NULL, 0);
> -}
> -
>  static irqreturn_t ec_irq_thread(int irq, void *data)
>  {
>  	struct cros_ec_device *ec_dev = data;
> @@ -104,10 +76,6 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
>  
>  	BLOCKING_INIT_NOTIFIER_HEAD(&ec_dev->event_notifier);
>  
> -	ec_dev->command_send = cros_ec_command_send;
> -	ec_dev->command_recv = cros_ec_command_recv;
> -	ec_dev->command_sendrecv = cros_ec_command_sendrecv;
> -
>  	if (ec_dev->din_size) {
>  		ec_dev->din = devm_kzalloc(dev, ec_dev->din_size, GFP_KERNEL);
>  		if (!ec_dev->din)
> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index 2b0c598..60c0880 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -63,9 +63,10 @@ struct cros_ec_command {
>   * @was_wake_device: true if this device was set to wake the system from
>   * sleep at the last suspend
>   * @event_notifier: interrupt event notifier for transport devices
> - * @command_send: send a command
> - * @command_recv: receive a response
> - * @command_sendrecv: send a command and receive a response
> + * @cmd_xfer: send command to EC and get response
> + *     Returns 0 if the communication succeeded, but that doesn't mean the EC
> + *     was happy with the command it got. Caller should check msg.result for
> + *     the EC's result code.
>   *
>   * @priv: Private data
>   * @irq: Interrupt to use
> @@ -83,7 +84,6 @@ struct cros_ec_command {
>   * @parent: pointer to parent device (e.g. i2c or spi device)
>   * @wake_enabled: true if this device can wake the system from sleep
>   * @lock: one transaction at a time
> - * @cmd_xfer: low-level channel to the EC
>   */
>  struct cros_ec_device {
>  
> @@ -94,13 +94,8 @@ struct cros_ec_device {
>  	bool was_wake_device;
>  	struct class *cros_class;
>  	struct blocking_notifier_head event_notifier;
> -	int (*command_send)(struct cros_ec_device *ec,
> -			    uint16_t cmd, void *out_buf, int out_len);
> -	int (*command_recv)(struct cros_ec_device *ec,
> -			    uint16_t cmd, void *in_buf, int in_len);
> -	int (*command_sendrecv)(struct cros_ec_device *ec,
> -				uint16_t cmd, void *out_buf, int out_len,
> -				void *in_buf, int in_len);
> +	int (*cmd_xfer)(struct cros_ec_device *ec,
> +			struct cros_ec_command *msg);
>  
>  	/* These are used to implement the platform-specific interface */
>  	void *priv;
> @@ -112,8 +107,6 @@ struct cros_ec_device {
>  	struct device *parent;
>  	bool wake_enabled;
>  	struct mutex lock;
> -	int (*cmd_xfer)(struct cros_ec_device *ec,
> -			struct cros_ec_command *msg);
>  };
>  
>  /**

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
