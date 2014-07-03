Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbaGCH2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:28:34 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:63915 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbaGCH2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:28:31 -0400
Date: Thu, 3 Jul 2014 08:28:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/10] mfd: cros_ec: Tweak struct cros_ec_device for
 clarity
Message-ID: <20140703072824.GA30534@lee--X1>
References: <1403115247-8853-1-git-send-email-dianders@chromium.org>
 <1403115247-8853-4-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403115247-8853-4-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Doug Anderson wrote:

> From: Bill Richardson <wfrichar@chromium.org>
> 
> The members of struct cros_ec_device were improperly commented, and
> intermixed the private and public sections. This is just cleanup to make it
> more obvious what goes with what.
> 
> [dianders: left lock in the structure but gave it the name that will
> eventually be used.]
> 
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
> Changes in v2: None
> 
>  drivers/mfd/cros_ec.c       |  2 +-
>  drivers/mfd/cros_ec_i2c.c   |  4 +--
>  drivers/mfd/cros_ec_spi.c   | 10 +++----
>  include/linux/mfd/cros_ec.h | 65 ++++++++++++++++++++++++---------------------
>  4 files changed, 43 insertions(+), 38 deletions(-)

Patch applied.

Clause: There is a chance that this patch might not be seen in -next
for ~24-48hrs.  If it's not there by 72hrs, feel free to poke.

> diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
> index 38fe9bf..04e053c 100644
> --- a/drivers/mfd/cros_ec.c
> +++ b/drivers/mfd/cros_ec.c
> @@ -57,7 +57,7 @@ static int cros_ec_command_sendrecv(struct cros_ec_device *ec_dev,
>  	msg.in_buf = in_buf;
>  	msg.in_len = in_len;
>  
> -	return ec_dev->command_xfer(ec_dev, &msg);
> +	return ec_dev->cmd_xfer(ec_dev, &msg);
>  }
>  
>  static int cros_ec_command_recv(struct cros_ec_device *ec_dev,
> diff --git a/drivers/mfd/cros_ec_i2c.c b/drivers/mfd/cros_ec_i2c.c
> index 4f71be9..777e529 100644
> --- a/drivers/mfd/cros_ec_i2c.c
> +++ b/drivers/mfd/cros_ec_i2c.c
> @@ -29,7 +29,7 @@ static inline struct cros_ec_device *to_ec_dev(struct device *dev)
>  	return i2c_get_clientdata(client);
>  }
>  
> -static int cros_ec_command_xfer(struct cros_ec_device *ec_dev,
> +static int cros_ec_cmd_xfer_i2c(struct cros_ec_device *ec_dev,
>  				struct cros_ec_msg *msg)
>  {
>  	struct i2c_client *client = ec_dev->priv;
> @@ -136,7 +136,7 @@ static int cros_ec_i2c_probe(struct i2c_client *client,
>  	ec_dev->dev = dev;
>  	ec_dev->priv = client;
>  	ec_dev->irq = client->irq;
> -	ec_dev->command_xfer = cros_ec_command_xfer;
> +	ec_dev->cmd_xfer = cros_ec_cmd_xfer_i2c;
>  	ec_dev->ec_name = client->name;
>  	ec_dev->phys_name = client->adapter->name;
>  	ec_dev->parent = &client->dev;
> diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
> index 0b8d328..52d4d7b 100644
> --- a/drivers/mfd/cros_ec_spi.c
> +++ b/drivers/mfd/cros_ec_spi.c
> @@ -73,7 +73,7 @@
>   *	if no record
>   * @end_of_msg_delay: used to set the delay_usecs on the spi_transfer that
>   *      is sent when we want to turn off CS at the end of a transaction.
> - * @lock: mutex to ensure only one user of cros_ec_command_spi_xfer at a time
> + * @lock: mutex to ensure only one user of cros_ec_cmd_xfer_spi at a time
>   */
>  struct cros_ec_spi {
>  	struct spi_device *spi;
> @@ -210,13 +210,13 @@ static int cros_ec_spi_receive_response(struct cros_ec_device *ec_dev,
>  }
>  
>  /**
> - * cros_ec_command_spi_xfer - Transfer a message over SPI and receive the reply
> + * cros_ec_cmd_xfer_spi - Transfer a message over SPI and receive the reply
>   *
>   * @ec_dev: ChromeOS EC device
>   * @ec_msg: Message to transfer
>   */
> -static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
> -				    struct cros_ec_msg *ec_msg)
> +static int cros_ec_cmd_xfer_spi(struct cros_ec_device *ec_dev,
> +				struct cros_ec_msg *ec_msg)
>  {
>  	struct cros_ec_spi *ec_spi = ec_dev->priv;
>  	struct spi_transfer trans;
> @@ -372,7 +372,7 @@ static int cros_ec_spi_probe(struct spi_device *spi)
>  	ec_dev->dev = dev;
>  	ec_dev->priv = ec_spi;
>  	ec_dev->irq = spi->irq;
> -	ec_dev->command_xfer = cros_ec_command_spi_xfer;
> +	ec_dev->cmd_xfer = cros_ec_cmd_xfer_spi;
>  	ec_dev->ec_name = ec_spi->spi->modalias;
>  	ec_dev->phys_name = dev_name(&ec_spi->spi->dev);
>  	ec_dev->parent = &ec_spi->spi->dev;
> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index 2ee3190..79a3585 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -16,7 +16,9 @@
>  #ifndef __LINUX_MFD_CROS_EC_H
>  #define __LINUX_MFD_CROS_EC_H
>  
> +#include <linux/notifier.h>
>  #include <linux/mfd/cros_ec_commands.h>
> +#include <linux/mutex.h>
>  
>  /*
>   * Command interface between EC and AP, for LPC, I2C and SPI interfaces.
> @@ -55,34 +57,53 @@ struct cros_ec_msg {
>  /**
>   * struct cros_ec_device - Information about a ChromeOS EC device
>   *
> + * @ec_name: name of EC device (e.g. 'chromeos-ec')
> + * @phys_name: name of physical comms layer (e.g. 'i2c-4')
> + * @dev: Device pointer
> + * @was_wake_device: true if this device was set to wake the system from
> + * sleep at the last suspend
> + * @event_notifier: interrupt event notifier for transport devices
> + * @command_send: send a command
> + * @command_recv: receive a response
> + * @command_sendrecv: send a command and receive a response
> + *
>   * @name: Name of this EC interface
>   * @priv: Private data
>   * @irq: Interrupt to use
> - * @din: input buffer (from EC)
> - * @dout: output buffer (to EC)
> + * @din: input buffer (for data from EC)
> + * @dout: output buffer (for data to EC)
>   * \note
>   * These two buffers will always be dword-aligned and include enough
>   * space for up to 7 word-alignment bytes also, so we can ensure that
>   * the body of the message is always dword-aligned (64-bit).
> - *
>   * We use this alignment to keep ARM and x86 happy. Probably word
>   * alignment would be OK, there might be a small performance advantage
>   * to using dword.
>   * @din_size: size of din buffer to allocate (zero to use static din)
>   * @dout_size: size of dout buffer to allocate (zero to use static dout)
> - * @command_send: send a command
> - * @command_recv: receive a command
> - * @ec_name: name of EC device (e.g. 'chromeos-ec')
> - * @phys_name: name of physical comms layer (e.g. 'i2c-4')
>   * @parent: pointer to parent device (e.g. i2c or spi device)
> - * @dev: Device pointer
> - * dev_lock: Lock to prevent concurrent access
>   * @wake_enabled: true if this device can wake the system from sleep
> - * @was_wake_device: true if this device was set to wake the system from
> - * sleep at the last suspend
> - * @event_notifier: interrupt event notifier for transport devices
> + * @lock: one transaction at a time
> + * @cmd_xfer: low-level channel to the EC
>   */
>  struct cros_ec_device {
> +
> +	/* These are used by other drivers that want to talk to the EC */
> +	const char *ec_name;
> +	const char *phys_name;
> +	struct device *dev;
> +	bool was_wake_device;
> +	struct class *cros_class;
> +	struct blocking_notifier_head event_notifier;
> +	int (*command_send)(struct cros_ec_device *ec,
> +			    uint16_t cmd, void *out_buf, int out_len);
> +	int (*command_recv)(struct cros_ec_device *ec,
> +			    uint16_t cmd, void *in_buf, int in_len);
> +	int (*command_sendrecv)(struct cros_ec_device *ec,
> +				uint16_t cmd, void *out_buf, int out_len,
> +				void *in_buf, int in_len);
> +
> +	/* These are used to implement the platform-specific interface */
>  	const char *name;
>  	void *priv;
>  	int irq;
> @@ -90,26 +111,10 @@ struct cros_ec_device {
>  	uint8_t *dout;
>  	int din_size;
>  	int dout_size;
> -	int (*command_send)(struct cros_ec_device *ec,
> -			uint16_t cmd, void *out_buf, int out_len);
> -	int (*command_recv)(struct cros_ec_device *ec,
> -			uint16_t cmd, void *in_buf, int in_len);
> -	int (*command_sendrecv)(struct cros_ec_device *ec,
> -			uint16_t cmd, void *out_buf, int out_len,
> -			void *in_buf, int in_len);
> -	int (*command_xfer)(struct cros_ec_device *ec,
> -			struct cros_ec_msg *msg);
> -
> -	const char *ec_name;
> -	const char *phys_name;
>  	struct device *parent;
> -
> -	/* These are --private-- fields - do not assign */
> -	struct device *dev;
> -	struct mutex dev_lock;
>  	bool wake_enabled;
> -	bool was_wake_device;
> -	struct blocking_notifier_head event_notifier;
> +	struct mutex lock;
> +	int (*cmd_xfer)(struct cros_ec_device *ec, struct cros_ec_msg *msg);
>  };
>  
>  /**

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
