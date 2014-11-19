Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbaKSNv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:51:26 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:44252 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbaKSNvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:51:24 -0500
Date: Wed, 19 Nov 2014 14:51:21 +0100
From: Johan Hovold <johan@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] spi: add support for DLN-2 USB-SPI adapter
Message-ID: <20141119135121.GF7857@localhost>
References: <1416394031-2663-1-git-send-email-laurentiu.palcu@intel.com>
 <1416402467-26999-1-git-send-email-laurentiu.palcu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416402467-26999-1-git-send-email-laurentiu.palcu@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 03:07:47PM +0200, Laurentiu Palcu wrote:

> +/*
> + * Perform one read operation.
> + */
> +static int dln2_spi_read_one(struct dln2_spi *dln2, u8 *data,
> +			     u16 data_len, u8 attr)
> +{
> +	int ret;
> +	struct {
> +		u8 port;
> +		__le16 size;
> +		u8 attr;
> +	} __packed tx;
> +	struct {
> +		__le16 size;
> +		u8 buf[DLN2_SPI_MAX_XFER_SIZE];
> +	} __packed *rx = dln2->buf;

You said you verified that the dln2 protocol headers did not mess up the
alignment, yet they do. Here you have a two byte header.

> +	unsigned rx_len = sizeof(*rx);
> +
> +	BUILD_BUG_ON(sizeof(*rx) > DLN2_SPI_BUF_SIZE);
> +
> +	if (data_len > DLN2_SPI_MAX_XFER_SIZE)
> +		return -EINVAL;
> +
> +	tx.port = dln2->port;
> +	tx.size = cpu_to_le16(data_len);
> +	tx.attr = attr;
> +
> +	ret = dln2_transfer(dln2->pdev, DLN2_SPI_READ, &tx, sizeof(tx),
> +			    rx, &rx_len);
> +	if (ret < 0)
> +		return ret;
> +	if (rx_len < sizeof(rx->size) + data_len)
> +		return -EPROTO;
> +	if (le16_to_cpu(rx->size) != data_len)
> +		return -EPROTO;
> +
> +	dln2_spi_copy_from_buf(data, rx->buf, data_len, dln2->bpw);

So you need to use the unaligned macros in dln2_spi_copy_from_buf for
rx->buf (at least for bpw 32).

Make sure to document why.

> +
> +	return 0;
> +}
> +
> +/*
> + * Perform one write & read operation.
> + */
> +static int dln2_spi_read_write_one(struct dln2_spi *dln2, const u8 *tx_data,
> +				   u8 *rx_data, u16 data_len, u8 attr)
> +{
> +	int ret;
> +	struct {
> +		u8 port;
> +		__le16 size;
> +		u8 attr;
> +		u8 buf[DLN2_SPI_MAX_XFER_SIZE];
> +	} __packed *tx;

tx is ok.

> +	struct {
> +		__le16 size;
> +		u8 buf[DLN2_SPI_MAX_XFER_SIZE];
> +	} __packed *rx;

But here you have the same two-byte header.

Johan
