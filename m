Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaANUeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:34:08 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:40592 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaANUeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:34:06 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Tue, 14 Jan 2014 12:23:09 -0800
Message-ID: <52D4F4C7.8000706@synaptics.com>
Date: Tue, 14 Jan 2014 00:26:47 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andrew Duggan <aduggan@synaptics.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] Input: synaptics-rmi4 - switch to using i2c_transfer()
References: <1389339867-8399-1-git-send-email-dmitry.torokhov@gmail.com> <1389339867-8399-4-git-send-email-dmitry.torokhov@gmail.com>
In-Reply-To: <1389339867-8399-4-git-send-email-dmitry.torokhov@gmail.com>
X-Originating-IP: [10.3.20.103]
X-Brightmail-Tracker: AAAAAQAAAWE=
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 11:44 PM, Dmitry Torokhov wrote:
> Instead of using 2 separate transactions when reading from the device let's
> use i2c_transfer. Because we now have single point of failure I had to
> change how we collect statistics. I elected to drop control data from the
> stats and only track number of bytes read/written for the device data.
>
> Also, since we are not prepared to deal with short reads and writes change
> read_block_data and write_block_data to indicate error if we detect short
> transfers.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>   drivers/input/rmi4/rmi_i2c.c | 71 ++++++++++++++++++++++++--------------------
>   1 file changed, 39 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/input/rmi4/rmi_i2c.c b/drivers/input/rmi4/rmi_i2c.c
> index c176218..51f5bc8 100644
> --- a/drivers/input/rmi4/rmi_i2c.c
> +++ b/drivers/input/rmi4/rmi_i2c.c
> @@ -57,22 +57,17 @@ struct rmi_i2c_xport {
>    */
>   static int rmi_set_page(struct rmi_i2c_xport *rmi_i2c, u8 page)
>   {
> -	struct rmi_transport_dev *xport = &rmi_i2c->xport;
>   	struct i2c_client *client = rmi_i2c->client;
>   	u8 txbuf[2] = {RMI_PAGE_SELECT_REGISTER, page};
>   	int retval;
>
> -	dev_dbg(&client->dev, "writes 3 bytes: %02x %02x\n",
> -			txbuf[0], txbuf[1]);
> -	xport->stats.tx_count++;
> -	xport->stats.tx_bytes += sizeof(txbuf);
>   	retval = i2c_master_send(client, txbuf, sizeof(txbuf));
>   	if (retval != sizeof(txbuf)) {
> -		xport->stats.tx_errs++;
>   		dev_err(&client->dev,
>   			"%s: set page failed: %d.", __func__, retval);
>   		return (retval < 0) ? retval : -EIO;
>   	}
> +
>   	rmi_i2c->page = page;
>   	return 0;
>   }
> @@ -107,22 +102,27 @@ static int rmi_i2c_write_block(struct rmi_transport_dev *xport, u16 addr,
>
>   	if (RMI_I2C_PAGE(addr) != rmi_i2c->page) {
>   		retval = rmi_set_page(rmi_i2c, RMI_I2C_PAGE(addr));
> -		if (retval < 0)
> +		if (retval)
>   			goto exit;
>   	}
>
> +	retval = i2c_master_send(client, rmi_i2c->tx_buf, tx_size);
> +	if (retval == tx_size)
> +		retval = 0;
> +	else if (retval >= 0)
> +		retval = -EIO;
> +
> +exit:
>   	dev_dbg(&client->dev,
> -		"writes %zd bytes at %#06x: %*ph\n", len, addr, (int)len, buf);
> +		"write %zd bytes at %#06x: %d (%*ph)\n",
> +		len, addr, retval, (int)len, buf);
>
>   	xport->stats.tx_count++;
> -	xport->stats.tx_bytes += tx_size;
> -	retval = i2c_master_send(client, rmi_i2c->tx_buf, tx_size);
> -	if (retval < 0)
> +	if (retval)
>   		xport->stats.tx_errs++;
>   	else
> -		retval--; /* don't count the address byte */
> +		xport->stats.tx_bytes += len;
>
> -exit:
>   	mutex_unlock(&rmi_i2c->page_mutex);
>   	return retval;
>   }
> @@ -133,40 +133,47 @@ static int rmi_i2c_read_block(struct rmi_transport_dev *xport, u16 addr,
>   	struct rmi_i2c_xport *rmi_i2c =
>   		container_of(xport, struct rmi_i2c_xport, xport);
>   	struct i2c_client *client = rmi_i2c->client;
> -	u8 txbuf[1] = {addr & 0xff};
> +	u8 addr_offset = addr & 0xff;
>   	int retval;
> +	struct i2c_msg msgs[] = {
> +		{
> +			.addr	= client->addr,
> +			.len	= sizeof(addr_offset),
> +			.buf	= &addr_offset,
> +		},
> +		{
> +			.addr	= client->addr,
> +			.flags	= I2C_M_RD,
> +			.len	= len,
> +			.buf	= buf,
> +		},
> +	};
>
>   	mutex_lock(&rmi_i2c->page_mutex);
>
>   	if (RMI_I2C_PAGE(addr) != rmi_i2c->page) {
>   		retval = rmi_set_page(rmi_i2c, RMI_I2C_PAGE(addr));
> -		if (retval < 0)
> +		if (retval)
>   			goto exit;
>   	}
>
> -	dev_dbg(&client->dev, "writes 1 bytes: %02x\n", txbuf[0]);
> +	retval = i2c_transfer(client->adapter, msgs, sizeof(msgs));
> +	if (retval == sizeof(msgs))

I think this should be:
	retval = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
	if (retval == ARRAY_SIZE(msgs))
At least, that change resolved some random misbehaviors, including 
kernel panics.


> +		retval = 0; /* success */
> +	else if (retval >= 0)
> +		retval = -EIO;
>
> -	xport->stats.tx_count++;
> -	xport->stats.tx_bytes += sizeof(txbuf);
> -	retval = i2c_master_send(client, txbuf, sizeof(txbuf));
> -	if (retval != sizeof(txbuf)) {
> -		xport->stats.tx_errs++;
> -		retval = (retval < 0) ? retval : -EIO;
> -		goto exit;
> -	}
> +exit:
> +	dev_dbg(&client->dev,
> +		"read %zd bytes at %#06x: %d (%*ph)\n",
> +		len, addr, retval, (int)len, buf);
>
>   	xport->stats.rx_count++;
> -	xport->stats.rx_bytes += len;
> -
> -	retval = i2c_master_recv(client, buf, len);
> -	if (retval < 0)
> +	if (retval)
>   		xport->stats.rx_errs++;
>   	else
> -		dev_dbg(&client->dev,
> -			"read %zd bytes at %#06x: %*ph\n",
> -			len, addr, (int)len, buf);
> +		xport->stats.rx_bytes += len;
>
> -exit:
>   	mutex_unlock(&rmi_i2c->page_mutex);
>   	return retval;
>   }
>


-- 

Christopher Heiny
Senior Staff Firmware Engineer
Synaptics Incorporated
