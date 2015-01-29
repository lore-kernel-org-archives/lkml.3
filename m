Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984AbbA2JyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:54:15 -0500
Received: from mout.gmx.net ([212.227.17.22]:50873 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431AbbA2JyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:54:11 -0500
From: Marc Dietrich <marvin24@gmx.de>
To: Andrey Danin <danindrey@mail.ru>
Cc: ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Julian Andres Klode <jak@jak-linux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/3] staging/nvec: reimplement on top of tegra i2c driver
Date: Thu, 29 Jan 2015 10:53:52 +0100
Message-ID: <101631156.mjCdEXJXai@fb07-iapwap2>
User-Agent: KMail/4.14.4 (Linux/3.18.3-1-desktop; KDE/4.14.4; x86_64; ; )
In-Reply-To: <1422516022-27161-3-git-send-email-danindrey@mail.ru>
References: <1422516022-27161-1-git-send-email-danindrey@mail.ru> <1422516022-27161-3-git-send-email-danindrey@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1874457.PxLDI6hS8E"; micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:ByvevTK3Hg6LHUmeLhBBuB+D+VJejbzEgBJ4OplwjrLwOYW2koF
 c/4R6Brfa/+8DcUGABtHKgY6eqMVr3Ftlt5bZISBtWQbnZCXeEKvisHsrpe2BUhc+d0r7lO
 DzOK8CRHK1CHMwjKZor9XrcFCPStkz9AaDPuRcijjzkx1OCD0Dyl+1LP7AAP6TSeCwaS75w
 4YVLbGkKjWublwpviZINg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1874457.PxLDI6hS8E
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Am Donnerstag, 29. Januar 2015, 10:20:21 schrieb Andrey Danin:
> Remove i2c controller related code and use tegra i2c driver in slave mode.

the diff is hard to review. Maybe it would be better to first ifdef 0 the old 
code (isr and init) while adding the new code, and then remove the old code in 
a second patch. Or maybe split it into small chunks.

> Signed-off-by: Andrey Danin <danindrey@mail.ru>
> ---
>  drivers/staging/nvec/nvec.c | 379
> ++++++++++++++------------------------------ drivers/staging/nvec/nvec.h | 
> 17 +-
>  2 files changed, 122 insertions(+), 274 deletions(-)
> 
> diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
> index 120b70d..d645c58 100644
> --- a/drivers/staging/nvec/nvec.c
> +++ b/drivers/staging/nvec/nvec.c
> @@ -25,8 +25,8 @@
>  #include <linux/err.h>
>  #include <linux/gpio.h>
>  #include <linux/interrupt.h>
> +#include <linux/i2c.h>
>  #include <linux/io.h>
> -#include <linux/irq.h>
>  #include <linux/of.h>
>  #include <linux/of_gpio.h>
>  #include <linux/list.h>
> @@ -39,25 +39,12 @@
> 
>  #include "nvec.h"
> 
> -#define I2C_CNFG			0x00
> -#define I2C_CNFG_PACKET_MODE_EN		(1<<10)
> -#define I2C_CNFG_NEW_MASTER_SFM		(1<<11)
> -#define I2C_CNFG_DEBOUNCE_CNT_SHIFT	12
> -
> -#define I2C_SL_CNFG		0x20
> -#define I2C_SL_NEWSL		(1<<2)
> -#define I2C_SL_NACK		(1<<1)
> -#define I2C_SL_RESP		(1<<0)
> -#define I2C_SL_IRQ		(1<<3)
> -#define END_TRANS		(1<<4)
> -#define RCVD			(1<<2)
> -#define RNW			(1<<1)
> -
> -#define I2C_SL_RCVD		0x24
> -#define I2C_SL_STATUS		0x28
> -#define I2C_SL_ADDR1		0x2c
> -#define I2C_SL_ADDR2		0x30
> -#define I2C_SL_DELAY_COUNT	0x3c
> +
> +#define I2C_SL_ST_END_TRANS			(1<<4)
> +#define I2C_SL_ST_IRQ				(1<<3)
> +#define I2C_SL_ST_RCVD				(1<<2)
> +#define I2C_SL_ST_RNW				(1<<1)
> +
> 
>  /**
>   * enum nvec_msg_category - Message categories for nvec_msg_alloc()
> @@ -327,6 +314,7 @@ struct nvec_msg *nvec_write_sync(struct nvec_chip *nvec,
> 
>  	mutex_unlock(&nvec->sync_write_mutex);
> 
> +

stray new line.

>  	return msg;
>  }
>  EXPORT_SYMBOL(nvec_write_sync);
> @@ -475,11 +463,13 @@ static void nvec_tx_completed(struct nvec_chip *nvec)
>  {
>  	/* We got an END_TRANS, let's skip this, maybe there's an event */
>  	if (nvec->tx->pos != nvec->tx->size) {
> -		dev_err(nvec->dev, "premature END_TRANS, resending\n");
> +		dev_err(nvec->dev, "premature END_TRANS, resending: pos:%u, size:
%u\n",
> +				nvec->tx->pos, nvec->tx->size);
>  		nvec->tx->pos = 0;
>  		nvec_gpio_set_value(nvec, 0);
>  	} else {
> -		nvec->state = 0;
> +		nvec->state = ST_NONE;
> +		nvec->tx->pos = 0;
>  	}
>  }
> 
> @@ -497,7 +487,7 @@ static void nvec_rx_completed(struct nvec_chip *nvec)
>  			   (uint) nvec->rx->pos);
> 
>  		nvec_msg_free(nvec, nvec->rx);
> -		nvec->state = 0;
> +		nvec->state = ST_NONE;
> 
>  		/* Battery quirk - Often incomplete, and likes to crash */
>  		if (nvec->rx->data[0] == NVEC_BAT)
> @@ -514,7 +504,7 @@ static void nvec_rx_completed(struct nvec_chip *nvec)
> 
>  	spin_unlock(&nvec->rx_lock);
> 
> -	nvec->state = 0;
> +	nvec->state = ST_NONE;
> 
>  	if (!nvec_msg_is_event(nvec->rx))
>  		complete(&nvec->ec_transfer);
> @@ -523,21 +513,6 @@ static void nvec_rx_completed(struct nvec_chip *nvec)
>  }
> 
>  /**
> - * nvec_invalid_flags - Send an error message about invalid flags and jump
> - * @nvec: The nvec device
> - * @status: The status flags
> - * @reset: Whether we shall jump to state 0.
> - */
> -static void nvec_invalid_flags(struct nvec_chip *nvec, unsigned int status,
> -			       bool reset)
> -{
> -	dev_err(nvec->dev, "unexpected status flags 0x%02x during state %i\n",
> -		status, nvec->state);
> -	if (reset)
> -		nvec->state = 0;
> -}
> -
> -/**
>   * nvec_tx_set - Set the message to transfer (nvec->tx)
>   * @nvec: A &struct nvec_chip
>   *
> @@ -566,150 +541,85 @@ static void nvec_tx_set(struct nvec_chip *nvec)
>  		(uint)nvec->tx->size, nvec->tx->data[1]);
>  }
> 
> +
>  /**
> - * nvec_interrupt - Interrupt handler
> - * @irq: The IRQ
> - * @dev: The nvec device
> + * nvec_slave_cb - I2C slave callback
>   *
> - * Interrupt handler that fills our RX buffers and empties our TX
> - * buffers. This uses a finite state machine with ridiculous amounts
> - * of error checking, in order to be fairly reliable.
> + * This callback fills our RX buffers and empties our TX
> + * buffers. This uses a finite state machine.
>   */
> -static irqreturn_t nvec_interrupt(int irq, void *dev)
> +static int nvec_slave_cb(struct i2c_client *client,
> +		enum i2c_slave_event event, u8 *val)
>  {
> -	unsigned long status;
> -	unsigned int received = 0;
> -	unsigned char to_send = 0xff;
> -	const unsigned long irq_mask = I2C_SL_IRQ | END_TRANS | RCVD | RNW;
> -	struct nvec_chip *nvec = dev;
> -	unsigned int state = nvec->state;
> -
> -	status = readl(nvec->base + I2C_SL_STATUS);
> -
> -	/* Filter out some errors */
> -	if ((status & irq_mask) == 0 && (status & ~irq_mask) != 0) {
> -		dev_err(nvec->dev, "unexpected irq mask %lx\n", status);
> -		return IRQ_HANDLED;
> -	}
> -	if ((status & I2C_SL_IRQ) == 0) {
> -		dev_err(nvec->dev, "Spurious IRQ\n");
> -		return IRQ_HANDLED;
> -	}
> -
> -	/* The EC did not request a read, so it send us something, read it */
> -	if ((status & RNW) == 0) {
> -		received = readl(nvec->base + I2C_SL_RCVD);
> -		if (status & RCVD)
> -			writel(0, nvec->base + I2C_SL_RCVD);
> -	}
> +	struct nvec_chip *nvec = i2c_get_clientdata(client);
> 
> -	if (status == (I2C_SL_IRQ | RCVD))
> -		nvec->state = 0;
> -
> -	switch (nvec->state) {
> -	case 0:		/* Verify that its a transfer start, the rest later */
> -		if (status != (I2C_SL_IRQ | RCVD))
> -			nvec_invalid_flags(nvec, status, false);
> -		break;
> -	case 1:		/* command byte */
> -		if (status != I2C_SL_IRQ) {
> -			nvec_invalid_flags(nvec, status, true);
> -		} else {
> +	switch (event) {
> +	case I2C_SLAVE_REQ_WRITE_END:
> +		if (nvec->state == ST_NONE) {
>  			nvec->rx = nvec_msg_alloc(nvec, NVEC_MSG_RX);
>  			/* Should not happen in a normal world */
>  			if (unlikely(nvec->rx == NULL)) {
> -				nvec->state = 0;
> -				break;
> +				nvec->state = ST_NONE;
> +				return -1;
>  			}
> -			nvec->rx->data[0] = received;
> -			nvec->rx->pos = 1;
> -			nvec->state = 2;
> +			nvec->rx->pos = 0;
> +
> +			if (client->addr != ((*val) >> 1)) {
> +				dev_err(&client->dev,
> +				"received address 0x%02x, expected 0x%02x\n",
> +				((*val) >> 1), client->addr);
> +			}
> +			nvec->state = ST_TRANS_START;
> +			nvec->rx->pos = 0;
> +			break;
>  		}
> +
> +		nvec->rx->data[nvec->rx->pos++] = *val;
> +		nvec->state = ST_RX;
>  		break;
> -	case 2:		/* first byte after command */
> -		if (status == (I2C_SL_IRQ | RNW | RCVD)) {
> -			udelay(33);
> -			if (nvec->rx->data[0] != 0x01) {
> -				dev_err(nvec->dev,
> -					"Read without prior read command\n");
> -				nvec->state = 0;
> -				break;
> -			}
> +
> +	case I2C_SLAVE_REQ_READ_START:
> +		if (nvec->state == ST_NONE) {
> +			dev_err(&client->dev,
> +			"unexpected read without transaction start, state %d\n",
> +			nvec->state);
> +			return -1;
> +		}
> +
> +		if (nvec->state == ST_RX) {
>  			nvec_msg_free(nvec, nvec->rx);
> -			nvec->state = 3;
>  			nvec_tx_set(nvec);
> -			BUG_ON(nvec->tx->size < 1);
> -			to_send = nvec->tx->data[0];
> -			nvec->tx->pos = 1;
> -		} else if (status == (I2C_SL_IRQ)) {
> -			BUG_ON(nvec->rx == NULL);
> -			nvec->rx->data[1] = received;
> -			nvec->rx->pos = 2;
> -			nvec->state = 4;
> -		} else {
> -			nvec_invalid_flags(nvec, status, true);
>  		}
> -		break;
> -	case 3:		/* EC does a block read, we transmit data */
> -		if (status & END_TRANS) {
> -			nvec_tx_completed(nvec);
> -		} else if ((status & RNW) == 0 || (status & RCVD)) {
> -			nvec_invalid_flags(nvec, status, true);
> -		} else if (nvec->tx && nvec->tx->pos < nvec->tx->size) {
> -			to_send = nvec->tx->data[nvec->tx->pos++];
> -		} else {
> +
> +		if (!nvec->tx || nvec->tx->pos >= nvec->tx->size) {
>  			dev_err(nvec->dev, "tx buffer underflow on %p (%u > %u)\n",
>  				nvec->tx,
>  				(uint) (nvec->tx ? nvec->tx->pos : 0),
>  				(uint) (nvec->tx ? nvec->tx->size : 0));
> -			nvec->state = 0;
> +			nvec->state = ST_NONE;
> +			break;
>  		}
> -		break;
> -	case 4:		/* EC does some write, we read the data */
> -		if ((status & (END_TRANS | RNW)) == END_TRANS)
> -			nvec_rx_completed(nvec);
> -		else if (status & (RNW | RCVD))
> -			nvec_invalid_flags(nvec, status, true);
> -		else if (nvec->rx && nvec->rx->pos < NVEC_MSG_SIZE)
> -			nvec->rx->data[nvec->rx->pos++] = received;
> -		else
> -			dev_err(nvec->dev,
> -				"RX buffer overflow on %p: Trying to write byte %u of %u\n",
> -				nvec->rx, nvec->rx ? nvec->rx->pos : 0,
> -				NVEC_MSG_SIZE);
> -		break;
> -	default:
> -		nvec->state = 0;
> -	}
> -
> -	/* If we are told that a new transfer starts, verify it */
> -	if ((status & (RCVD | RNW)) == RCVD) {
> -		if (received != nvec->i2c_addr)
> -			dev_err(nvec->dev,
> -			"received address 0x%02x, expected 0x%02x\n",
> -			received, nvec->i2c_addr);
> -		nvec->state = 1;
> -	}
> 
> -	/* Send data if requested, but not on end of transmission */
> -	if ((status & (RNW | END_TRANS)) == RNW)
> -		writel(to_send, nvec->base + I2C_SL_RCVD);
> +		nvec->state = ST_TX;
> +		*val = nvec->tx->data[nvec->tx->pos];
> +		break;
> 
> -	/* If we have send the first byte */
> -	if (status == (I2C_SL_IRQ | RNW | RCVD))
> +	case I2C_SLAVE_REQ_READ_END:
> +		nvec->tx->pos++;
>  		nvec_gpio_set_value(nvec, 1);
> +		break;
> 
> -	dev_dbg(nvec->dev,
> -		"Handled: %s 0x%02x, %s 0x%02x in state %u [%s%s%s]\n",
> -		(status & RNW) == 0 ? "received" : "R=",
> -		received,
> -		(status & (RNW | END_TRANS)) ? "sent" : "S=",
> -		to_send,
> -		state,
> -		status & END_TRANS ? " END_TRANS" : "",
> -		status & RCVD ? " RCVD" : "",
> -		status & RNW ? " RNW" : "");
> +	case I2C_SLAVE_STOP:
> +		if (nvec->state == ST_TX)
> +			nvec_tx_completed(nvec);
> +		else if (nvec->state == ST_RX)
> +			nvec_rx_completed(nvec);
> +		nvec->state = ST_NONE;
> +		break;
> 
> +	default:
> +		return 0;
> +	}
> 
>  	/*
>  	 * TODO: A correct fix needs to be found for this.
> @@ -717,44 +627,18 @@ static irqreturn_t nvec_interrupt(int irq, void *dev)
>  	 * We experience less incomplete messages with this delay than without
>  	 * it, but we don't know why. Help is appreciated.
>  	 */
> -	udelay(100);
> -
> -	return IRQ_HANDLED;
> -}
> -
> -static void tegra_init_i2c_slave(struct nvec_chip *nvec)
> -{
> -	u32 val;
> -
> -	clk_prepare_enable(nvec->i2c_clk);
> -
> -	reset_control_assert(nvec->rst);
> -	udelay(2);
> -	reset_control_deassert(nvec->rst);
> -
> -	val = I2C_CNFG_NEW_MASTER_SFM | I2C_CNFG_PACKET_MODE_EN |
> -	    (0x2 << I2C_CNFG_DEBOUNCE_CNT_SHIFT);
> -	writel(val, nvec->base + I2C_CNFG);
> -
> -	clk_set_rate(nvec->i2c_clk, 8 * 80000);
> -
> -	writel(I2C_SL_NEWSL, nvec->base + I2C_SL_CNFG);
> -	writel(0x1E, nvec->base + I2C_SL_DELAY_COUNT);
> -
> -	writel(nvec->i2c_addr>>1, nvec->base + I2C_SL_ADDR1);
> -	writel(0, nvec->base + I2C_SL_ADDR2);
> -
> -	enable_irq(nvec->irq);
> -}
> +	switch (event) {
> +	case I2C_SLAVE_REQ_WRITE_END:
> +	case I2C_SLAVE_REQ_READ_END:
> +	case I2C_SLAVE_STOP:
> +		udelay(100);

maybe re-add the original comment here. Is this delay still required?


> +		break;
> +	default:
> +		break;
> +	}
> 
> -#ifdef CONFIG_PM_SLEEP
> -static void nvec_disable_i2c_slave(struct nvec_chip *nvec)
> -{
> -	disable_irq(nvec->irq);
> -	writel(I2C_SL_NEWSL | I2C_SL_NACK, nvec->base + I2C_SL_CNFG);
> -	clk_disable_unprepare(nvec->i2c_clk);
> +	return 0;
>  }
> -#endif
> 
>  static void nvec_power_off(void)
>  {
> @@ -767,7 +651,7 @@ static void nvec_power_off(void)
>  /*
>   *  Parse common device tree data
>   */
> -static int nvec_i2c_parse_dt_pdata(struct nvec_chip *nvec)
> +static int nvec_i2c_parse_dt(struct nvec_chip *nvec)
>  {
>  	nvec->gpio = of_get_named_gpio(nvec->dev->of_node, "request-gpios", 0);
> 
> @@ -776,68 +660,39 @@ static int nvec_i2c_parse_dt_pdata(struct nvec_chip
> *nvec) return -ENODEV;
>  	}
> 
> -	if (of_property_read_u32(nvec->dev->of_node, "slave-addr",
> -				&nvec->i2c_addr)) {
> -		dev_err(nvec->dev, "no i2c address specified");
> -		return -ENODEV;
> -	}
> -
>  	return 0;
>  }
> 
> -static int tegra_nvec_probe(struct platform_device *pdev)
> +static int nvec_probe(struct i2c_client *client, const struct i2c_device_id
> *id) {
> -	int err, ret;
> -	struct clk *i2c_clk;
> +	int ret;
>  	struct nvec_chip *nvec;
>  	struct nvec_msg *msg;
> -	struct resource *res;
> -	void __iomem *base;
> -	char	get_firmware_version[] = { NVEC_CNTL, GET_FIRMWARE_VERSION },
> +	char    get_firmware_version[] = { NVEC_CNTL, GET_FIRMWARE_VERSION },
>  		unmute_speakers[] = { NVEC_OEM0, 0x10, 0x59, 0x95 },
>  		enable_event[7] = { NVEC_SYS, CNF_EVENT_REPORTING, true };
> 
> -	if (!pdev->dev.of_node) {
> -		dev_err(&pdev->dev, "must be instantiated using device tree\n");
> +
> +	if (!client->dev.of_node) {
> +		dev_err(&client->dev, "must be instantiated using device tree\n");
>  		return -ENODEV;
>  	}
> 
> -	nvec = devm_kzalloc(&pdev->dev, sizeof(struct nvec_chip), GFP_KERNEL);
> +	nvec = devm_kzalloc(&client->dev, sizeof(struct nvec_chip), GFP_KERNEL);
>  	if (nvec == NULL)
>  		return -ENOMEM;
> 
> -	platform_set_drvdata(pdev, nvec);
> -	nvec->dev = &pdev->dev;
> +	nvec->dev = &client->dev;
> +	ret = nvec_i2c_parse_dt(nvec);
> +	if (ret < 0)
> +		return ret;
> 
> -	err = nvec_i2c_parse_dt_pdata(nvec);
> -	if (err < 0)
> -		return err;
> +	i2c_set_clientdata(client, nvec);
> 
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	base = devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(base))
> -		return PTR_ERR(base);
> -
> -	nvec->irq = platform_get_irq(pdev, 0);
> -	if (nvec->irq < 0) {
> -		dev_err(&pdev->dev, "no irq resource?\n");
> -		return -ENODEV;
> -	}
> -
> -	i2c_clk = devm_clk_get(&pdev->dev, "div-clk");
> -	if (IS_ERR(i2c_clk)) {
> -		dev_err(nvec->dev, "failed to get controller clock\n");
> -		return -ENODEV;
> -	}
> -
> -	nvec->rst = devm_reset_control_get(&pdev->dev, "i2c");
> -	if (IS_ERR(nvec->rst)) {
> -		dev_err(nvec->dev, "failed to get controller reset\n");
> -		return PTR_ERR(nvec->rst);
> -	}
> +	ret = i2c_slave_register(client, nvec_slave_cb);
> +	if (ret < 0)
> +		return ret;
> 
> -	nvec->base = base;
> -	nvec->i2c_clk = i2c_clk;
>  	nvec->rx = &nvec->msg_pool[0];
> 
>  	ATOMIC_INIT_NOTIFIER_HEAD(&nvec->notifier_list);
> @@ -852,23 +707,14 @@ static int tegra_nvec_probe(struct platform_device
> *pdev) INIT_WORK(&nvec->rx_work, nvec_dispatch);
>  	INIT_WORK(&nvec->tx_work, nvec_request_master);
> 
> -	err = devm_gpio_request_one(&pdev->dev, nvec->gpio, GPIOF_OUT_INIT_HIGH,
> -					"nvec gpio");
> -	if (err < 0) {
> +	ret = devm_gpio_request_one(&client->dev, nvec->gpio,
> +			GPIOF_OUT_INIT_HIGH,
> +			"nvec gpio");
> +	if (ret < 0) {
>  		dev_err(nvec->dev, "couldn't request gpio\n");
>  		return -ENODEV;
>  	}
> 
> -	err = devm_request_irq(&pdev->dev, nvec->irq, nvec_interrupt, 0,
> -				"nvec", nvec);
> -	if (err) {
> -		dev_err(nvec->dev, "couldn't request irq\n");
> -		return -ENODEV;
> -	}
> -	disable_irq(nvec->irq);
> -
> -	tegra_init_i2c_slave(nvec);
> -
>  	/* enable event reporting */
>  	nvec_toggle_global_events(nvec, true);
> 
> @@ -907,12 +753,13 @@ static int tegra_nvec_probe(struct platform_device
> *pdev) return 0;
>  }
> 
> -static int tegra_nvec_remove(struct platform_device *pdev)
> +
> +static int nvec_remove(struct i2c_client *client)
>  {
> -	struct nvec_chip *nvec = platform_get_drvdata(pdev);
> +	struct nvec_chip *nvec = i2c_get_clientdata(client);
> 
>  	nvec_toggle_global_events(nvec, false);
> -	mfd_remove_devices(nvec->dev);
> +	/* TODO: mfd_remove_devices(nvec->dev); ??? */

why did you removed this?

>  	nvec_unregister_notifier(nvec, &nvec->nvec_status_notifier);
>  	cancel_work_sync(&nvec->rx_work);
>  	cancel_work_sync(&nvec->tx_work);
> @@ -938,8 +785,6 @@ static int nvec_suspend(struct device *dev)
>  	msg = nvec_write_sync(nvec, ap_suspend, sizeof(ap_suspend));
>  	nvec_msg_free(nvec, msg);
> 
> -	nvec_disable_i2c_slave(nvec);
> -
>  	return 0;
>  }
> 
> @@ -949,7 +794,6 @@ static int nvec_resume(struct device *dev)
>  	struct nvec_chip *nvec = platform_get_drvdata(pdev);
> 
>  	dev_dbg(nvec->dev, "resuming\n");
> -	tegra_init_i2c_slave(nvec);
>  	nvec_toggle_global_events(nvec, true);
> 
>  	return 0;
> @@ -965,9 +809,16 @@ static const struct of_device_id nvidia_nvec_of_match[]
> = { };
>  MODULE_DEVICE_TABLE(of, nvidia_nvec_of_match);
> 
> -static struct platform_driver nvec_device_driver = {
> -	.probe   = tegra_nvec_probe,
> -	.remove  = tegra_nvec_remove,
> +static const struct i2c_device_id nvidia_nvec_i2c_table[] = {
> +	{ "nvec", 0 },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(i2c, nvidia_nvec_i2c_table);
> +
> +static struct i2c_driver i2c_nvec_device_driver = {
> +	.probe   = nvec_probe,
> +	.remove  = nvec_remove,
> +	.id_table = nvidia_nvec_i2c_table,
>  	.driver  = {
>  		.name = "nvec",
>  		.pm = &nvec_pm_ops,
> @@ -975,9 +826,9 @@ static struct platform_driver nvec_device_driver = {
>  	}
>  };
> 
> -module_platform_driver(nvec_device_driver);
> +module_i2c_driver(i2c_nvec_device_driver);
> 
> -MODULE_ALIAS("platform:nvec");
> +MODULE_ALIAS("i2c:nvec");
>  MODULE_DESCRIPTION("NVIDIA compliant embedded controller interface");
>  MODULE_AUTHOR("Marc Dietrich <marvin24@gmx.de>");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/staging/nvec/nvec.h b/drivers/staging/nvec/nvec.h
> index e271375..5e7e17c 100644
> --- a/drivers/staging/nvec/nvec.h
> +++ b/drivers/staging/nvec/nvec.h
> @@ -56,6 +56,13 @@ enum nvec_event_size {
>  	NVEC_VAR_SIZE,
>  };
> 
> +enum nvec_state {
> +	ST_NONE,
> +	ST_RX,
> +	ST_TX,
> +	ST_TRANS_START,
> +};
> +
>  /**
>   * enum nvec_msg_type - The type of a message
>   * @NVEC_SYS: A system request/response
> @@ -107,11 +114,6 @@ struct nvec_msg {
>   * struct nvec_chip - A single connection to an NVIDIA Embedded controller
>   * @dev: The device
>   * @gpio: The same as for &struct nvec_platform_data
> - * @irq: The IRQ of the I2C device
> - * @i2c_addr: The address of the I2C slave
> - * @base: The base of the memory mapped region of the I2C device
> - * @i2c_clk: The clock of the I2C device
> - * @rst: The reset of the I2C device
>   * @notifier_list: Notifiers to be called on received messages, see
>   *                 nvec_register_notifier()
>   * @rx_data: Received messages that have to be processed
> @@ -137,11 +139,6 @@ struct nvec_msg {
>  struct nvec_chip {
>  	struct device *dev;
>  	int gpio;
> -	int irq;
> -	int i2c_addr;
> -	void __iomem *base;
> -	struct clk *i2c_clk;
> -	struct reset_control *rst;
>  	struct atomic_notifier_head notifier_list;
>  	struct list_head rx_data, tx_data;
>  	struct notifier_block nvec_status_notifier;

--nextPart1874457.PxLDI6hS8E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJUygMwAAoJEKyeR39HFBtopyQIAJfgCoO2CQuhRIKdVQWhXT/4
6kQeWOfFUSB2I1VwLsHRNOY3UTqkiEeGF3FTOARsnll/1JU+I3NQC75YaMc2JCCj
UejThY3Ki2tF9a4BQSYpFRYq3AnM5+W9olcnMuUEo7jNqA+4bq6L3Pfmlsa0QtDe
sZdx4CWGzIkPHRHnF9HfU8BRj5Hl9k9EiJDox5X4xv09WMrD2r79K2ZFdtGsGEQm
Un7O9Nm5NhIvtLTRTreSPtN8ARJv+JqmLyD8SOm4mL8YJIbAamy4GRacipZ0uvuc
dsPyeYrUCTMTK9kJLP31D4DLlgn3tsjw+bTrS6p94E9/NCziviJV7V9Tl2bX7do=
=uW0Q
-----END PGP SIGNATURE-----

--nextPart1874457.PxLDI6hS8E--

