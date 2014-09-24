Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaIXLBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:01:05 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:52570 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaIXLBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:01:02 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 24 Sep 2014 12:58:28 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v5 2/4] i2c: add support for Diolan DLN-2 USB-I2C adapter
Message-ID: <20140924105828.GB17019@localhost>
References: <1411158165-25794-1-git-send-email-octavian.purdila@intel.com>
 <1411158165-25794-3-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411158165-25794-3-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 11:22:43PM +0300, Octavian Purdila wrote:

> +struct dln2_i2c {
> +	struct platform_device *pdev;
> +	struct i2c_adapter adapter;
> +	u32 freq;
> +	u32 min_freq;
> +	u32 max_freq;
> +	/*
> +	 * Buffer to hold the packet for read or write transfers. One
> +	 * is enough since we can't have multiple transfers in
> +	 * parallel on the i2c adapter.
> +	 */
> +	union {
> +		struct {
> +			u8 port;
> +			u8 addr;
> +			u8 mem_addr_len;
> +			__le32 mem_addr;
> +			__le16 buf_len;
> +			u8 buf[DLN2_I2C_MAX_XFER_SIZE];
> +		} __packed tx;
> +		struct {
> +			__le16 buf_len;
> +			u8 buf[DLN2_I2C_MAX_XFER_SIZE];
> +		} __packed rx;
> +	} *buf;

Please declare these structs separately from the dln2_i2c struct so you
can use temporary pointers below.

Perhaps just allocate a large enough buffer (or page) here and keep you
transfer-buffer declarations in the two functions where they are used if
you prefer.

> +};
>
> +static int dln2_i2c_enable(struct dln2_i2c *dln2, bool enable)
> +{
> +	struct dln2_platform_data *pdata = dev_get_platdata(&dln2->pdev->dev);
> +	int ret;
> +	u8 port;
> +	u16 cmd;
> +
> +	port = pdata->port;

Store the port number in the dln2_i2c struct rather than access it
through the platform data for every I/O operation.

> +
> +	if (enable)
> +		cmd = DLN2_I2C_ENABLE;
> +	else
> +		cmd = DLN2_I2C_DISABLE;
> +
> +	ret = dln2_transfer(dln2->pdev, cmd, &port, sizeof(port), NULL, NULL);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int dln2_i2c_set_frequency(struct dln2_i2c *dln2, u32 freq)
> +{
> +	int ret;
> +	struct tx_data {
> +		u8 port;
> +		__le32 freq;
> +	} __packed tx;
> +	struct dln2_platform_data *pdata = dev_get_platdata(&dln2->pdev->dev);
> +
> +	tx.port = pdata->port;
> +	tx.freq = cpu_to_le32(freq);
> +
> +	ret = dln2_transfer(dln2->pdev, DLN2_I2C_SET_FREQUENCY, &tx, sizeof(tx),
> +			    NULL, NULL);
> +	if (ret < 0)
> +		return ret;
> +
> +	dln2->freq = freq;
> +
> +	return 0;
> +}
> +
> +static int dln2_i2c_get_freq(struct dln2_i2c *dln2, u16 cmd, u32 *res)
> +{
> +	int ret;
> +	struct dln2_platform_data *pdata = dev_get_platdata(&dln2->pdev->dev);
> +	u8 port = pdata->port;
> +	__le32 freq;
> +	unsigned len = sizeof(freq);
> +
> +	ret = dln2_transfer(dln2->pdev, cmd, &port, sizeof(port),
> +			    &freq, &len);
> +	if (ret < 0)
> +		return ret;
> +	if (len < sizeof(freq))
> +		return -EPROTO;
> +
> +	*res = le32_to_cpu(freq);
> +
> +	return 0;
> +}
> +
> +static int dln2_i2c_setup(struct dln2_i2c *dln2)
> +{
> +	int ret;
> +
> +	ret = dln2_i2c_enable(dln2, false);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = dln2_i2c_get_freq(dln2, DLN2_I2C_GET_MIN_FREQUENCY,
> +				&dln2->min_freq);
> +	if (ret < 0)
> +		return 0;

return ret

> +
> +	ret = dln2_i2c_get_freq(dln2, DLN2_I2C_GET_MAX_FREQUENCY,
> +				&dln2->max_freq);
> +	if (ret < 0)
> +		return 0;

return ret

> +
> +	ret = dln2_i2c_set_frequency(dln2, DLN2_I2C_FREQ_STD);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = dln2_i2c_enable(dln2, true);
> +
> +	return ret;
> +}
> +
> +static int dln2_i2c_write(struct dln2_i2c *dln2, u8 addr,
> +			  u8 *data, u16 data_len)
> +{
> +	struct dln2_platform_data *pdata = dev_get_platdata(&dln2->pdev->dev);
> +	int ret;
> +	unsigned len;
> +
> +	dln2->buf->tx.port = pdata->port;
> +	dln2->buf->tx.addr = addr;
> +	dln2->buf->tx.mem_addr_len = 0;
> +	dln2->buf->tx.mem_addr = 0;
> +	dln2->buf->tx.buf_len = cpu_to_le16(data_len);
> +	memcpy(dln2->buf->tx.buf, data, data_len);
> +
> +	len = sizeof(dln2->buf->tx) + data_len - DLN2_I2C_MAX_XFER_SIZE;
> +	ret = dln2_transfer(dln2->pdev, DLN2_I2C_WRITE, &dln2->buf->tx, len,
> +			    NULL, NULL);

Use a temporary pointer to the tx struct above for readability.

> +	if (ret < 0)
> +		return ret;
> +
> +	return data_len;
> +}
> +
> +static int dln2_i2c_read(struct dln2_i2c *dln2, u16 addr, u8 *data,
> +			 u16 data_len)
> +{
> +	struct dln2_platform_data *pdata = dev_get_platdata(&dln2->pdev->dev);
> +	int ret;
> +	struct {
> +		u8 port;
> +		u8 addr;
> +		u8 mem_addr_len;
> +		__le32 mem_addr;
> +		__le16 buf_len;
> +	} __packed tx;
> +	unsigned rx_len;
> +
> +	tx.port = pdata->port;
> +	tx.addr = addr;
> +	tx.mem_addr_len = 0;
> +	tx.mem_addr = 0;
> +	tx.buf_len = cpu_to_le16(data_len);
> +
> +	rx_len = sizeof(dln2->buf->rx);
> +
> +	ret = dln2_transfer(dln2->pdev, DLN2_I2C_READ, &tx, sizeof(tx),
> +			    &dln2->buf->rx, &rx_len);
> +	if (ret < 0)
> +		return ret;
> +	if (rx_len < sizeof(dln2->buf->rx.buf_len) + data_len)
> +		return -EPROTO;
> +	if (le16_to_cpu(dln2->buf->rx.buf_len) != data_len)
> +		return -EPROTO;
> +
> +	memcpy(data, dln2->buf->rx.buf, data_len);'

Use a temporary pointer to the rx struct above.

> +
> +	return data_len;
> +}

[...]

> +static DEVICE_ATTR_RW(dln2_i2c_freq);

Any new sysfs attribute must to be documented under Documentation/ABI.

[...]

> +static struct platform_driver dln2_i2c_driver = {
> +	.driver.name	= "dln2-i2c",
> +	.driver.owner	= THIS_MODULE,

No need to set the owner field when using the module_platform_driver
macro.

> +	.probe		= dln2_i2c_probe,
> +	.remove		= dln2_i2c_remove,
> +};
> +
> +module_platform_driver(dln2_i2c_driver);
> +
> +MODULE_AUTHOR("Laurentiu Palcu <laurentiu.palcu@intel.com>");
> +MODULE_DESCRIPTION("Driver for the Diolan DLN2 I2C master interface");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:dln2-i2c");

Johan
