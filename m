Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab3JTUjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 16:39:19 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58856 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3JTUjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 16:39:18 -0400
Message-ID: <52644DAF.30302@kernel.org>
Date: Sun, 20 Oct 2013 22:39:59 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: Re: [PATCH] iio: (max1363) support SMBus for 8-bit devices
References: <1382292177-31413-1-git-send-email-vivien.didelot@savoirfairelinux.com>
In-Reply-To: <1382292177-31413-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/13 19:02, Vivien Didelot wrote:
> The driver currently supports only I2C access. But some devices with an
> accuracy of 8-bit are compatible with the SMBus byte access routines.
> 
> This patch wraps the send and receive routines depending on the chip
> accuracy and fonctionnalities of its adapter.
> 
> For instance, this allows us to use a MAX11603 on a ICH7 controller.
> 
> This patch also simplifies the max1363_write_basic_config() routine to
> use the struct max1363_state fields directly.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Sensible change given I am guessing you have a usecase that needs to
run it as described.  I've slightly changed the description to make it clear that
this is applies for all supported 8 bit devices.

> ---
>  drivers/iio/adc/max1363.c | 76 +++++++++++++++++++++++++++++++++++------------
>  1 file changed, 57 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/iio/adc/max1363.c b/drivers/iio/adc/max1363.c
> index cc07b37..6118dce 100644
> --- a/drivers/iio/adc/max1363.c
> +++ b/drivers/iio/adc/max1363.c
> @@ -165,6 +165,8 @@ struct max1363_chip_info {
>   * @thresh_low:		low threshold values
>   * @vref:		Reference voltage regulator
>   * @vref_uv:		Actual (external or internal) reference voltage
> + * @send:		function used to send data to the chip
> + * @recv:		function used to receive data from the chip
>   */
>  struct max1363_state {
>  	struct i2c_client		*client;
> @@ -186,6 +188,10 @@ struct max1363_state {
>  	s16				thresh_low[8];
>  	struct regulator		*vref;
>  	u32				vref_uv;
> +	int				(*send)(const struct i2c_client *client,
> +						const char *buf, int count);
> +	int				(*recv)(const struct i2c_client *client,
> +						char *buf, int count);
>  };
>  
>  #define MAX1363_MODE_SINGLE(_num, _mask) {				\
> @@ -311,13 +317,37 @@ static const struct max1363_mode
>  	return NULL;
>  }
>  
> -static int max1363_write_basic_config(struct i2c_client *client,
> -				      unsigned char d1,
> -				      unsigned char d2)
> +static int max1363_smbus_send(const struct i2c_client *client, const char *buf,
> +		int count)
>  {
> -	u8 tx_buf[2] = {d1, d2};
> +	int i, err;
>  
> -	return i2c_master_send(client, tx_buf, 2);
> +	for (i = err = 0; err == 0 && i < count; ++i)
> +		err = i2c_smbus_write_byte(client, buf[i]);
> +
> +	return err ? err : count;
> +}
> +
> +static int max1363_smbus_recv(const struct i2c_client *client, char *buf,
> +		int count)
> +{
> +	int i, ret;
> +
> +	for (i = 0; i < count; ++i) {
> +		ret = i2c_smbus_read_byte(client);
> +		if (ret < 0)
> +			return ret;
> +		buf[i] = ret;
> +	}
> +
> +	return count;
> +}
> +
> +static int max1363_write_basic_config(struct max1363_state *st)
> +{
> +	u8 tx_buf[2] = { st->setupbyte, st->configbyte };
> +
> +	return st->send(st->client, tx_buf, 2);
>  }
>  
>  static int max1363_set_scan_mode(struct max1363_state *st)
> @@ -327,9 +357,7 @@ static int max1363_set_scan_mode(struct max1363_state *st)
>  			    | MAX1363_SE_DE_MASK);
>  	st->configbyte |= st->current_mode->conf;
>  
> -	return max1363_write_basic_config(st->client,
> -					  st->setupbyte,
> -					  st->configbyte);
> +	return max1363_write_basic_config(st);
>  }
>  
>  static int max1363_read_single_chan(struct iio_dev *indio_dev,
> @@ -366,7 +394,7 @@ static int max1363_read_single_chan(struct iio_dev *indio_dev,
>  	}
>  	if (st->chip_info->bits != 8) {
>  		/* Get reading */
> -		data = i2c_master_recv(client, rxbuf, 2);
> +		data = st->recv(client, rxbuf, 2);
>  		if (data < 0) {
>  			ret = data;
>  			goto error_ret;
> @@ -375,7 +403,7 @@ static int max1363_read_single_chan(struct iio_dev *indio_dev,
>  		  ((1 << st->chip_info->bits) - 1);
>  	} else {
>  		/* Get reading */
> -		data = i2c_master_recv(client, rxbuf, 1);
> +		data = st->recv(client, rxbuf, 1);
>  		if (data < 0) {
>  			ret = data;
>  			goto error_ret;
> @@ -772,11 +800,11 @@ static irqreturn_t max1363_event_handler(int irq, void *private)
>  	u8 tx[2] = { st->setupbyte,
>  		     MAX1363_MON_INT_ENABLE | (st->monitor_speed << 1) | 0xF0 };
>  
> -	i2c_master_recv(st->client, &rx, 1);
> +	st->recv(st->client, &rx, 1);
>  	mask = rx;
>  	for_each_set_bit(loc, &mask, 8)
>  		iio_push_event(indio_dev, max1363_event_codes[loc], timestamp);
> -	i2c_master_send(st->client, tx, 2);
> +	st->send(st->client, tx, 2);
>  
>  	return IRQ_HANDLED;
>  }
> @@ -812,9 +840,7 @@ static int max1363_monitor_mode_update(struct max1363_state *st, int enabled)
>  		st->setupbyte &= ~MAX1363_SETUP_MONITOR_SETUP;
>  		st->configbyte &= ~MAX1363_SCAN_MASK;
>  		st->monitor_on = false;
> -		return max1363_write_basic_config(st->client,
> -						st->setupbyte,
> -						st->configbyte);
> +		return max1363_write_basic_config(st);
>  	}
>  
>  	/* Ensure we are in the relevant mode */
> @@ -876,7 +902,7 @@ static int max1363_monitor_mode_update(struct max1363_state *st, int enabled)
>  		}
>  
>  
> -	ret = i2c_master_send(st->client, tx_buf, len);
> +	ret = st->send(st->client, tx_buf, len);
>  	if (ret < 0)
>  		goto error_ret;
>  	if (ret != len) {
> @@ -893,7 +919,7 @@ static int max1363_monitor_mode_update(struct max1363_state *st, int enabled)
>  	 */
>  	tx_buf[0] = st->setupbyte;
>  	tx_buf[1] = MAX1363_MON_INT_ENABLE | (st->monitor_speed << 1) | 0xF0;
> -	ret = i2c_master_send(st->client, tx_buf, 2);
> +	ret = st->send(st->client, tx_buf, 2);
>  	if (ret < 0)
>  		goto error_ret;
>  	if (ret != 2) {
> @@ -1481,9 +1507,9 @@ static irqreturn_t max1363_trigger_handler(int irq, void *p)
>  	if (rxbuf == NULL)
>  		goto done;
>  	if (st->chip_info->bits != 8)
> -		b_sent = i2c_master_recv(st->client, rxbuf, numvals*2);
> +		b_sent = st->recv(st->client, rxbuf, numvals * 2);
>  	else
> -		b_sent = i2c_master_recv(st->client, rxbuf, numvals);
> +		b_sent = st->recv(st->client, rxbuf, numvals);
>  	if (b_sent < 0)
>  		goto done_free;
>  
> @@ -1550,6 +1576,18 @@ static int max1363_probe(struct i2c_client *client,
>  		st->vref_uv = vref_uv;
>  	}
>  
> +	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		st->send = i2c_master_send;
> +		st->recv = i2c_master_recv;
> +	} else if (i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE)
> +			&& st->chip_info->bits == 8) {
> +		st->send = max1363_smbus_send;
> +		st->recv = max1363_smbus_recv;
> +	} else {
> +		ret = -EOPNOTSUPP;
> +		goto error_disable_reg;
> +	}
> +
>  	ret = max1363_alloc_scan_masks(indio_dev);
>  	if (ret)
>  		goto error_disable_reg;
> 
