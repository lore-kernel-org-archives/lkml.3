Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaKSMVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 07:21:17 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:51680 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaKSMVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:21:15 -0500
Date: Wed, 19 Nov 2014 13:21:11 +0100
From: Johan Hovold <johan@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] spi: add support for DLN-2 USB-SPI adapter
Message-ID: <20141119122111.GE7857@localhost>
References: <1416312599-5176-2-git-send-email-laurentiu.palcu@intel.com>
 <1416394031-2663-1-git-send-email-laurentiu.palcu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416394031-2663-1-git-send-email-laurentiu.palcu@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 12:47:11PM +0200, Laurentiu Palcu wrote:

> +	/* no need to protect this buffer because all SPI communication is
> +	 * serialized by the SPI core
> +	 */
> +	void *buf;

Preferred comment style is

	/*
	 * ...
	 */

Capitalisation and punctuation is also nice.

Why not mention where you use it and why (i.e. to avoid having those
large messages on the stack?

> +static int dln2_spi_get_cs_num(struct dln2_spi *dln2, u16 *cs_num)
> +{
> +	int ret;
> +	struct {
> +		u8 port;
> +	} tx;
> +	struct {
> +		__le16 cs_count;
> +	} rx;
> +	unsigned rx_len = sizeof(rx);
> +
> +	if (!cs_num)
> +		return -EINVAL;

Why did you add this check since v1? You only call this function from
probe with a non-null argument.

> +
> +	tx.port = dln2->port;
> +	ret = dln2_transfer(dln2->pdev, DLN2_SPI_GET_SS_COUNT, &tx, sizeof(tx),
> +			    &rx, &rx_len);
> +	if (ret < 0)
> +		return ret;
> +	if (rx_len < sizeof(rx))
> +		return -EPROTO;
> +
> +	*cs_num = le16_to_cpu(rx.cs_count);
> +
> +	dev_dbg(&dln2->pdev->dev, "cs_num = %d\n", *cs_num);
> +
> +	return 0;
> +}
> +
> +static int dln2_spi_get_speed(struct dln2_spi *dln2, u16 cmd, u32 *freq)
> +{
> +	int ret;
> +	struct {
> +		u8 port;
> +	} tx;
> +	struct {
> +		__le32 speed;
> +	} rx;
> +	unsigned rx_len = sizeof(rx);
> +
> +	if (!freq)
> +		return -EINVAL;

Same here. You only call this function indirectly from probe with a
non-null argument.

> +
> +	tx.port = dln2->port;
> +
> +	ret = dln2_transfer(dln2->pdev, cmd, &tx, sizeof(tx), &rx, &rx_len);
> +	if (ret < 0)
> +		return ret;
> +	if (rx_len < sizeof(rx))
> +		return -EPROTO;
> +
> +	*freq = le32_to_cpu(rx.speed);
> +
> +	return 0;
> +}
> +
> +/*
> + * Get bus min/max frequencies.
> + */
> +static int dln2_spi_get_speed_range(struct dln2_spi *dln2, u32 *fmin, u32 *fmax)
> +{
> +	int ret;
> +
> +	if (!fmin || !fmax)
> +		return -EINVAL;

Not needed either.

> +
> +	ret = dln2_spi_get_speed(dln2, DLN2_SPI_GET_MIN_FREQUENCY,
> +				 fmin);

No need to break the line.

> +	if (ret < 0)
> +		return ret;
> +
> +	ret = dln2_spi_get_speed(dln2, DLN2_SPI_GET_MAX_FREQUENCY,
> +				 fmax);

Ditto.

> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(&dln2->pdev->dev, "freq_min = %d, freq_max = %d\n",
> +		*fmin, *fmax);
> +
> +	return 0;
> +}

> +static int dln2_spi_get_supported_frame_sizes(struct dln2_spi *dln2,
> +					      u32 *bpw_mask)
> +{
> +	int ret;
> +	struct {
> +		u8 port;
> +	} tx;
> +	struct {
> +		u8 count;
> +		u8 frame_sizes[36];
> +	} *rx = dln2->buf;
> +	unsigned rx_len = sizeof(*rx);
> +	int i;
> +
> +	if (!bpw_mask)
> +		return -EINVAL;

Will never be NULL either.

> +
> +	tx.port = dln2->port;
> +
> +	ret = dln2_transfer(dln2->pdev, DLN2_SPI_GET_SUPPORTED_FRAME_SIZES,
> +			    &tx, sizeof(tx), rx, &rx_len);
> +	if (ret < 0)
> +		return ret;
> +	if (rx_len != sizeof(*rx))
> +		return -EPROTO;

rx_len will never be larger than the requested transfer size, so stick
to less-than comparison as you do everywhere else.

Johan
