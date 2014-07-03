Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbaGCH3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:29:33 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36971 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaGCH3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:29:31 -0400
Date: Thu, 3 Jul 2014 08:29:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/10] mfd: cros_ec: Use struct cros_ec_command to
 communicate with the EC
Message-ID: <20140703072924.GC30534@lee--X1>
References: <1403115247-8853-1-git-send-email-dianders@chromium.org>
 <1403115247-8853-6-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403115247-8853-6-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Doug Anderson wrote:

> From: Bill Richardson <wfrichar@chromium.org>
> 
> This is some internal structure reorganization / renaming to prepare
> for future patches that will add a userspace API to cros_ec.  There
> should be no visible changes.
> 
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
> Changes in v2: None
> 
>  drivers/mfd/cros_ec.c       | 28 ++++++++++++++--------------
>  drivers/mfd/cros_ec_i2c.c   | 24 ++++++++++++------------
>  drivers/mfd/cros_ec_spi.c   | 16 ++++++++--------
>  include/linux/mfd/cros_ec.h | 35 ++++++++++++++++++-----------------
>  4 files changed, 52 insertions(+), 51 deletions(-)

Patch applied with Simon's Reviewed-by.

Clause: There is a chance that this patch might not be seen in -next
for ~24-48hrs.  If it's not there by 72hrs, feel free to poke.

> diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
> index 04e053c..2e86c28 100644
> --- a/drivers/mfd/cros_ec.c
> +++ b/drivers/mfd/cros_ec.c
> @@ -25,22 +25,22 @@
>  #include <linux/mfd/cros_ec_commands.h>
>  
>  int cros_ec_prepare_tx(struct cros_ec_device *ec_dev,
> -		       struct cros_ec_msg *msg)
> +		       struct cros_ec_command *msg)
>  {
>  	uint8_t *out;
>  	int csum, i;
>  
> -	BUG_ON(msg->out_len > EC_PROTO2_MAX_PARAM_SIZE);
> +	BUG_ON(msg->outsize > EC_PROTO2_MAX_PARAM_SIZE);
>  	out = ec_dev->dout;
>  	out[0] = EC_CMD_VERSION0 + msg->version;
> -	out[1] = msg->cmd;
> -	out[2] = msg->out_len;
> +	out[1] = msg->command;
> +	out[2] = msg->outsize;
>  	csum = out[0] + out[1] + out[2];
> -	for (i = 0; i < msg->out_len; i++)
> -		csum += out[EC_MSG_TX_HEADER_BYTES + i] = msg->out_buf[i];
> -	out[EC_MSG_TX_HEADER_BYTES + msg->out_len] = (uint8_t)(csum & 0xff);
> +	for (i = 0; i < msg->outsize; i++)
> +		csum += out[EC_MSG_TX_HEADER_BYTES + i] = msg->outdata[i];
> +	out[EC_MSG_TX_HEADER_BYTES + msg->outsize] = (uint8_t)(csum & 0xff);
>  
> -	return EC_MSG_TX_PROTO_BYTES + msg->out_len;
> +	return EC_MSG_TX_PROTO_BYTES + msg->outsize;
>  }
>  EXPORT_SYMBOL(cros_ec_prepare_tx);
>  
> @@ -48,14 +48,14 @@ static int cros_ec_command_sendrecv(struct cros_ec_device *ec_dev,
>  		uint16_t cmd, void *out_buf, int out_len,
>  		void *in_buf, int in_len)
>  {
> -	struct cros_ec_msg msg;
> +	struct cros_ec_command msg;
>  
>  	msg.version = cmd >> 8;
> -	msg.cmd = cmd & 0xff;
> -	msg.out_buf = out_buf;
> -	msg.out_len = out_len;
> -	msg.in_buf = in_buf;
> -	msg.in_len = in_len;
> +	msg.command = cmd & 0xff;
> +	msg.outdata = out_buf;
> +	msg.outsize = out_len;
> +	msg.indata = in_buf;
> +	msg.insize = in_len;
>  
>  	return ec_dev->cmd_xfer(ec_dev, &msg);
>  }
> diff --git a/drivers/mfd/cros_ec_i2c.c b/drivers/mfd/cros_ec_i2c.c
> index 777e529..37ed12f 100644
> --- a/drivers/mfd/cros_ec_i2c.c
> +++ b/drivers/mfd/cros_ec_i2c.c
> @@ -30,7 +30,7 @@ static inline struct cros_ec_device *to_ec_dev(struct device *dev)
>  }
>  
>  static int cros_ec_cmd_xfer_i2c(struct cros_ec_device *ec_dev,
> -				struct cros_ec_msg *msg)
> +				struct cros_ec_command *msg)
>  {
>  	struct i2c_client *client = ec_dev->priv;
>  	int ret = -ENOMEM;
> @@ -50,7 +50,7 @@ static int cros_ec_cmd_xfer_i2c(struct cros_ec_device *ec_dev,
>  	 * allocate larger packet (one byte for checksum, one byte for
>  	 * length, and one for result code)
>  	 */
> -	packet_len = msg->in_len + 3;
> +	packet_len = msg->insize + 3;
>  	in_buf = kzalloc(packet_len, GFP_KERNEL);
>  	if (!in_buf)
>  		goto done;
> @@ -61,7 +61,7 @@ static int cros_ec_cmd_xfer_i2c(struct cros_ec_device *ec_dev,
>  	 * allocate larger packet (one byte for checksum, one for
>  	 * command code, one for length, and one for command version)
>  	 */
> -	packet_len = msg->out_len + 4;
> +	packet_len = msg->outsize + 4;
>  	out_buf = kzalloc(packet_len, GFP_KERNEL);
>  	if (!out_buf)
>  		goto done;
> @@ -69,16 +69,16 @@ static int cros_ec_cmd_xfer_i2c(struct cros_ec_device *ec_dev,
>  	i2c_msg[0].buf = (char *)out_buf;
>  
>  	out_buf[0] = EC_CMD_VERSION0 + msg->version;
> -	out_buf[1] = msg->cmd;
> -	out_buf[2] = msg->out_len;
> +	out_buf[1] = msg->command;
> +	out_buf[2] = msg->outsize;
>  
>  	/* copy message payload and compute checksum */
>  	sum = out_buf[0] + out_buf[1] + out_buf[2];
> -	for (i = 0; i < msg->out_len; i++) {
> -		out_buf[3 + i] = msg->out_buf[i];
> +	for (i = 0; i < msg->outsize; i++) {
> +		out_buf[3 + i] = msg->outdata[i];
>  		sum += out_buf[3 + i];
>  	}
> -	out_buf[3 + msg->out_len] = sum;
> +	out_buf[3 + msg->outsize] = sum;
>  
>  	/* send command to EC and read answer */
>  	ret = i2c_transfer(client->adapter, i2c_msg, 2);
> @@ -94,20 +94,20 @@ static int cros_ec_cmd_xfer_i2c(struct cros_ec_device *ec_dev,
>  	/* check response error code */
>  	if (i2c_msg[1].buf[0]) {
>  		dev_warn(ec_dev->dev, "command 0x%02x returned an error %d\n",
> -			 msg->cmd, i2c_msg[1].buf[0]);
> +			 msg->command, i2c_msg[1].buf[0]);
>  		ret = -EINVAL;
>  		goto done;
>  	}
>  
>  	/* copy response packet payload and compute checksum */
>  	sum = in_buf[0] + in_buf[1];
> -	for (i = 0; i < msg->in_len; i++) {
> -		msg->in_buf[i] = in_buf[2 + i];
> +	for (i = 0; i < msg->insize; i++) {
> +		msg->indata[i] = in_buf[2 + i];
>  		sum += in_buf[2 + i];
>  	}
>  	dev_dbg(ec_dev->dev, "packet: %*ph, sum = %02x\n",
>  		i2c_msg[1].len, in_buf, sum);
> -	if (sum != in_buf[2 + msg->in_len]) {
> +	if (sum != in_buf[2 + msg->insize]) {
>  		dev_err(ec_dev->dev, "bad packet checksum\n");
>  		ret = -EBADMSG;
>  		goto done;
> diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
> index c29a2d7..2d713fe 100644
> --- a/drivers/mfd/cros_ec_spi.c
> +++ b/drivers/mfd/cros_ec_spi.c
> @@ -216,7 +216,7 @@ static int cros_ec_spi_receive_response(struct cros_ec_device *ec_dev,
>   * @ec_msg: Message to transfer
>   */
>  static int cros_ec_cmd_xfer_spi(struct cros_ec_device *ec_dev,
> -				struct cros_ec_msg *ec_msg)
> +				struct cros_ec_command *ec_msg)
>  {
>  	struct cros_ec_spi *ec_spi = ec_dev->priv;
>  	struct spi_transfer trans;
> @@ -261,7 +261,7 @@ static int cros_ec_cmd_xfer_spi(struct cros_ec_device *ec_dev,
>  	/* Get the response */
>  	if (!ret) {
>  		ret = cros_ec_spi_receive_response(ec_dev,
> -				ec_msg->in_len + EC_MSG_TX_PROTO_BYTES);
> +				ec_msg->insize + EC_MSG_TX_PROTO_BYTES);
>  	} else {
>  		dev_err(ec_dev->dev, "spi transfer failed: %d\n", ret);
>  	}
> @@ -294,21 +294,21 @@ static int cros_ec_cmd_xfer_spi(struct cros_ec_device *ec_dev,
>  	if (ptr[0]) {
>  		if (ptr[0] == EC_RES_IN_PROGRESS) {
>  			dev_dbg(ec_dev->dev, "command 0x%02x in progress\n",
> -				ec_msg->cmd);
> +				ec_msg->command);
>  			ret = -EAGAIN;
>  			goto exit;
>  		}
>  		dev_warn(ec_dev->dev, "command 0x%02x returned an error %d\n",
> -			 ec_msg->cmd, ptr[0]);
> +			 ec_msg->command, ptr[0]);
>  		debug_packet(ec_dev->dev, "in_err", ptr, len);
>  		ret = -EINVAL;
>  		goto exit;
>  	}
>  	len = ptr[1];
>  	sum = ptr[0] + ptr[1];
> -	if (len > ec_msg->in_len) {
> +	if (len > ec_msg->insize) {
>  		dev_err(ec_dev->dev, "packet too long (%d bytes, expected %d)",
> -			len, ec_msg->in_len);
> +			len, ec_msg->insize);
>  		ret = -ENOSPC;
>  		goto exit;
>  	}
> @@ -316,8 +316,8 @@ static int cros_ec_cmd_xfer_spi(struct cros_ec_device *ec_dev,
>  	/* copy response packet payload and compute checksum */
>  	for (i = 0; i < len; i++) {
>  		sum += ptr[i + 2];
> -		if (ec_msg->in_len)
> -			ec_msg->in_buf[i] = ptr[i + 2];
> +		if (ec_msg->insize)
> +			ec_msg->indata[i] = ptr[i + 2];
>  	}
>  	sum &= 0xff;
>  
> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index 79a3585..f27c037 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -35,23 +35,23 @@ enum {
>  					EC_MSG_TX_PROTO_BYTES,
>  };
>  
> -/**
> - * struct cros_ec_msg - A message sent to the EC, and its reply
> - *
> +/*
>   * @version: Command version number (often 0)
> - * @cmd: Command to send (EC_CMD_...)
> - * @out_buf: Outgoing payload (to EC)
> - * @outlen: Outgoing length
> - * @in_buf: Incoming payload (from EC)
> - * @in_len: Incoming length
> + * @command: Command to send (EC_CMD_...)
> + * @outdata: Outgoing data to EC
> + * @outsize: Outgoing length in bytes
> + * @indata: Where to put the incoming data from EC
> + * @insize: Incoming length in bytes (filled in by EC)
> + * @result: EC's response to the command (separate from communication failure)
>   */
> -struct cros_ec_msg {
> -	u8 version;
> -	u8 cmd;
> -	uint8_t *out_buf;
> -	int out_len;
> -	uint8_t *in_buf;
> -	int in_len;
> +struct cros_ec_command {
> +	uint32_t version;
> +	uint32_t command;
> +	uint8_t *outdata;
> +	uint32_t outsize;
> +	uint8_t *indata;
> +	uint32_t insize;
> +	uint32_t result;
>  };
>  
>  /**
> @@ -114,7 +114,8 @@ struct cros_ec_device {
>  	struct device *parent;
>  	bool wake_enabled;
>  	struct mutex lock;
> -	int (*cmd_xfer)(struct cros_ec_device *ec, struct cros_ec_msg *msg);
> +	int (*cmd_xfer)(struct cros_ec_device *ec,
> +			struct cros_ec_command *msg);
>  };
>  
>  /**
> @@ -148,7 +149,7 @@ int cros_ec_resume(struct cros_ec_device *ec_dev);
>   * @msg: Message to write
>   */
>  int cros_ec_prepare_tx(struct cros_ec_device *ec_dev,
> -		       struct cros_ec_msg *msg);
> +		       struct cros_ec_command *msg);
>  
>  /**
>   * cros_ec_remove - Remove a ChromeOS EC

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
