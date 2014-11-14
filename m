Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965400AbaKNK4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:56:50 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:65195 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964781AbaKNK4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:56:48 -0500
Date: Fri, 14 Nov 2014 11:56:45 +0100
From: Johan Havold <johan@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Johan Havold <johan@kernel.org>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] spi: add support for DLN-2 USB-SPI adapter
Message-ID: <20141114105645.GB18285@localhost>
References: <1415799490-27989-1-git-send-email-laurentiu.palcu@intel.com>
 <1415799490-27989-2-git-send-email-laurentiu.palcu@intel.com>
 <20141113122728.GA18285@localhost>
 <20141113151721.GQ5826@lpalcu-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113151721.GQ5826@lpalcu-linux>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 05:17:21PM +0200, Laurentiu Palcu wrote:
> Hi Johan,
> 
> On Thu, Nov 13, 2014 at 01:27:28PM +0100, Johan Havold wrote:
> > On Wed, Nov 12, 2014 at 03:38:09PM +0200, Laurentiu Palcu wrote:

> > > +struct dln2_spi {
> > > +	struct platform_device *pdev;
> > > +	struct spi_master *master;
> > > +	u8 port;
> > > +
> > > +	void *buf;
> > 
> > Add comment on what is protecting this buffer.
>
> No need to protect this buffer. First off, AFAICS, once we register the
> master, a message queue is initialized by the spi core and the entire
> communication with the SPI module goes through this queue. Secondly,
> every TX/RX SPI operation with the Diolan is split in 2 parts: command
> and response. Once we send the command out, the buffer can be safely
> reused for the response.

I didn't as for a lock, but for you to put a comment there explaining
why there's no need for one (e.g. buffer used in what functions that are
serialised by spi core).

> Also, I guess this answers a couple of your comments below too.

Not really. I still think you should use stack allocated buffer for
short control transfer.

> > > +
> > > +	u8 bpw;
> > > +	u32 speed;
> > > +	u16 mode;
> > > +	u8 cs;
>> > +};

> > > +/*
> > > + * Select/unselect multiple CS lines. The selected lines will be automatically
> > > + * toggled LOW/HIGH by the board firmware during transfers, provided they're
> > > + * enabled first.
> > > + *
> > > + * Ex: cs_mask = 0x03 -> CS0 & CS1 will be selected and the next WR/RD operation
> > 
> > Seems you have several comments that wrap at >80 columns (81 above).
>
> According to the kernel coding style, 80 columns is the limit, unless
> readability is affected. The line above does not exceed this limit. Also,
> checkpatch does not complain.

I noticed that checkpatch didn't complain, but 81 chars is still >80,
right? The newline counts as well (at least in vim).

> > > + *                       will toggle the lines LOW/HIGH automatically.
> > > + */
> > > +static int dln2_spi_cs_set(struct dln2_spi *dln2, u8 cs_mask)

[...]

> > > +static int dln2_spi_get_cs_num(struct dln2_spi *dln2, u16 *cs_num)
> > > +{
> > > +	int ret;
> > > +	struct {
> > > +		u8 port;
> > > +	} tx;
> > > +	struct {
> > > +		__le16 cs_count;
> > > +	} *rx = dln2->buf;
> > 
> > I don't think you want to use dln2->buf for all these small transfers.
> > And what would be protecting it from concurrent use?
> > 
> > Check this throughout.
>
> I answered this above.

So did I. Even though the transfer functions are serialised by spi-core
it's not obvious that all your helpers will be.

And since there's no gain from using the global buffer why not simply
use stack allocated ones here as well (e.g. for both tx and rx above)?

> > > +	unsigned rx_len = sizeof(*rx);
> > > +
> > > +	tx.port = dln2->port;
> > > +	ret = dln2_transfer(dln2->pdev, DLN2_SPI_GET_SS_COUNT, &tx, sizeof(tx),
> > > +			    rx, &rx_len);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +	if (rx_len < sizeof(*rx))
> > > +		return -EPROTO;
> > > +
> > > +	*cs_num = le16_to_cpu(rx->cs_count);
> > > +
> > > +	dev_dbg(&dln2->pdev->dev, "cs_num = %d\n", *cs_num);
> > 
> > Use the spi device for device messages throughout.
>
> Apparently, I'm consistent with the other SPI master controller drivers.
> All of them use pdev->dev for printing messages. However, I tried it,
> and the prefix is "spi_master (null):" when master->dev is used,
> compared to "dln2-spi dln2-spi.2.auto:" when pdev->dev is used. It looks
> like master->dev.init_name is not set... :/

Ok.

> > > +
> > > +	return 0;
> > > +}

> > > +/*
> > > + * Copy the data to DLN2 buffer and change the alignment to LE, requested by
> > > + * DLN2 module. SPI core makes sure that the data length is a multiple of word
> > > + * size.
> > 
> > What about buffer alignment?
>
> Buffer alignment? Why should the buffer be aligned? Now that you
> mentioned it, I realized I should've used "byte order" instead of
> alignment in the comment above...

You can't just simply cast an unaligned buffer to a type that has a
minimum alignment requirement > 1. That's what the get/put_unaligned
helpers are for (see Documentation/unaligned-memory-access.txt).

Perhaps the buffer is properly aligned, just making sure you verified
this (e.g. what's the size of the header?).

And yes, fixing the wording would be nice as well.

> > > + */
> > > +static int dln2_spi_copy_to_buf(u8 *dln2_buf, const u8 *src, u16 len, u8 bpw)
> > > +{
> > > +#ifdef __LITTLE_ENDIAN
> > > +	memcpy(dln2_buf, src, len);
> > > +#else
> > > +	if (bpw <= 8)
> > > +		memcpy(dln2_buf, src, len);
> > 
> > Missing braces.
> ok
> 
> > 
> > > +	else if (bpw <= 16) {
> > > +		__le16 *d = (__le16 *) dln2_buf;
> > 
> > No spaces after casts.
> ok
> 
> > 
> > > +		u16 *s = (u16 *) src;
> > > +
> > > +		len = len / 2;
> > > +		while (len--)
> > > +			*d++ = cpu_to_le16p(s++);
> > > +	} else {
> > > +		__le32 *d = (__le32 *) dln2_buf;
> > > +		u32 *s = (u32 *) src;
> > > +
> > > +		len = len / 4;
> > > +		while (len--)
> > > +			*d++ = cpu_to_le32p(s++);
> > > +	}
> > > +#endif
> > > +
> > > +	return 0;
> > > +}

[...]

> > > +static int dln2_spi_probe(struct platform_device *pdev)
> > > +{
> > > +	struct spi_master *master;
> > > +	struct dln2_spi *dln2;
> > > +	struct dln2_platform_data *pdata = dev_get_platdata(&pdev->dev);
> > > +	int ret;
> > > +
> > > +	master = spi_alloc_master(&pdev->dev, sizeof(*dln2));
> > > +	if (!master)
> > > +		return -ENOMEM;
> > > +
> > > +	platform_set_drvdata(pdev, master);
> > > +
> > > +	dln2 = spi_master_get_devdata(master);
> > > +
> > > +	dln2->buf = devm_kmalloc(&pdev->dev, DLN2_SPI_BUF_SIZE, GFP_KERNEL);
> > > +	if (!dln2->buf) {
> > > +		ret = -ENOMEM;
> > > +		goto exit_free_master;
> > > +	}
> > > +
> > > +	dln2->master = master;
> > > +	dln2->pdev = pdev;
> > > +	dln2->port = pdata->port;
> > > +	/* cs number can never be 0xff, so the first transfer will set the cs */
> > > +	dln2->cs = 0xff;
> > > +
> > > +	/* disable SPI module before continuing with the setup */
> > > +	ret = dln2_spi_enable(dln2, false);
> > > +	if (ret < 0) {
> > > +		dev_err(&pdev->dev, "Failed to disable SPI module\n");
> > > +		goto exit_free_master;
> > > +	}
> > > +
> > > +	ret = dln2_spi_get_cs_num(dln2, &master->num_chipselect);
> > > +	if (ret < 0) {
> > > +		dev_err(&pdev->dev, "Failed to get number of CS pins\n");
> > > +		goto exit_free_master;
> > > +	}
> > > +
> > > +	ret = dln2_spi_get_speed_range(dln2,
> > > +				       &master->min_speed_hz,
> > > +				       &master->max_speed_hz);
> > > +	if (ret < 0) {
> > > +		dev_err(&pdev->dev, "Failed to read bus min/max freqs\n");
> > > +		goto exit_free_master;
> > > +	}
> > > +
> > > +	ret = dln2_spi_get_supported_frame_sizes(dln2,
> > > +						 &master->bits_per_word_mask);
> > > +	if (ret < 0) {
> > > +		dev_err(&pdev->dev, "Failed to read supported frame sizes\n");
> > > +		goto exit_free_master;
> > > +	}
> > > +
> > > +	ret = dln2_spi_cs_enable_all(dln2, true);
> > > +	if (ret < 0) {
> > > +		dev_err(&pdev->dev, "Failed to enable CS pins\n");
> > > +		goto exit_free_master;
> > > +	}
> > > +
> > > +	master->bus_num = -1;
> > > +	master->mode_bits = SPI_CPOL | SPI_CPHA;
> > > +	master->prepare_message = dln2_spi_prepare_message;
> > > +	master->transfer_one_message = dln2_spi_transfer_one_message;
> > > +
> > > +	/* enable SPI module, we're good to go */
> > > +	ret = dln2_spi_enable(dln2, true);
> > > +	if (ret < 0) {
> > > +		dev_err(&pdev->dev, "Failed to enable SPI module\n");
> > > +		goto exit_free_master;
> > > +	}
> > > +
> > > +	ret = devm_spi_register_master(&pdev->dev, master);
> > > +	if (ret < 0) {
> > > +		dev_err(&pdev->dev, "Failed to register master\n");
> > > +		goto exit_register;
> > > +	}
> > > +
> > > +	return ret;
> > > +
> > > +exit_register:
> > > +	if (dln2_spi_enable(dln2, false) < 0)
> > > +		dev_err(&pdev->dev, "Failed to disable SPI module\n");
> > > +exit_free_master:
> > > +	spi_master_put(master);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static int dln2_spi_remove(struct platform_device *pdev)
> > > +{
> > > +	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
> > > +	struct dln2_spi *dln2 = spi_master_get_devdata(master);
> > > +
> > > +	if (dln2_spi_enable(dln2, false) < 0)
> > > +		dev_err(&pdev->dev, "Failed to disable SPI module\n");
> > > +
> > 
> > Memory leak -- spi_master_put missing.
>
> I used devm_spi_register_master(). No need for _put() here.

Ok, and master is freed as part of unregistration.

> > > +	return 0;
> > > +}

Johan
