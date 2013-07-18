Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858Ab3GRMYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:24:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41451 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757524Ab3GRMYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:24:47 -0400
Message-ID: <51E7DE81.3010609@ti.com>
Date: Thu, 18 Jul 2013 17:54:33 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com> <1374141687-10790-3-git-send-email-sourav.poddar@ti.com> <20130718102404.GH11251@arwen.pp.htv.fi> <51E7CF11.5030301@ti.com> <20130718112458.GJ11251@arwen.pp.htv.fi>
In-Reply-To: <20130718112458.GJ11251@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 July 2013 04:54 PM, Felipe Balbi wrote:
> On Thu, Jul 18, 2013 at 04:48:41PM +0530, Sourav Poddar wrote:
>>>> +static void qspi_write_msg(struct ti_qspi *qspi, struct spi_transfer *t)
>>>> +{
>>>> +	const u8 *txbuf;
>>>> +	int wlen, count;
>>>> +
>>>> +	count = t->len;
>>>> +	txbuf = t->tx_buf;
>>>> +	wlen = t->bits_per_word;
>>>> +
>>>> +	while (count--) {
>>>> +		dev_dbg(qspi->dev, "tx cmd %08x dc %08x data %02x\n",
>>>> +			qspi->cmd | QSPI_WR_SNGL, qspi->dc, *txbuf);
>>>> +		ti_qspi_writel_data(qspi, *txbuf++, QSPI_SPI_DATA_REG, wlen);
>>> you always increment by each byte. Here, if you used writel(), you wrote
>>> 4 bytes and should increment txbuf by 4.
>> hmm..got this point. Yes, my mistake, here I agree if wlen is not 8 bits
>> txbuf++ is not valid.
>>>   Same goes for read_data(),
>>> below. Another thing. Even though your wlen might be 8 bits, if you
>>> write 4 bytes to write, you can save a few CPU cycles by using writel().
>>>
>> Do you mean 4 words of 8 bits?
> yeah. Say you have wlen = 8 but the transfer length is 8 bytes (64
> bits). If you use writeb(), you will do 8 writes, if you use writel()
> you'll do 2 writes.
>
hmm.. I will check this out.
If our wlen is 8, after every 8 bits there will be
an interrupt. Will check that out, how that interrupt
should be tackled if we desired to read 4 bytes in a single writel/readl.
>>>> +static int ti_qspi_start_transfer_one(struct spi_master *master,
>>>> +		struct spi_message *m)
>>>> +{
>>>> +	struct ti_qspi *qspi = spi_master_get_devdata(master);
>>>> +	struct spi_device *spi = m->spi;
>>>> +	struct spi_transfer *t;
>>>> +	int status = 0, ret;
>>>> +	int frame_length;
>>>> +
>>>> +	/* setup device control reg */
>>>> +	qspi->dc = 0;
>>>> +
>>>> +	if (spi->mode&   SPI_CPHA)
>>>> +		qspi->dc |= QSPI_CKPHA(spi->chip_select);
>>>> +	if (spi->mode&   SPI_CPOL)
>>>> +		qspi->dc |= QSPI_CKPOL(spi->chip_select);
>>>> +	if (spi->mode&   SPI_CS_HIGH)
>>>> +		qspi->dc |= QSPI_CSPOL(spi->chip_select);
>>>> +
>>>> +	frame_length = DIV_ROUND_UP(m->frame_length * spi->bits_per_word,
>>>> +				spi->bits_per_word);
>>> this calculation doesn't look correct.
>>>
>>> 	(m->frame_length * spi->bits_per_word) /
>>> 		spi->bits_per_word = m->frame_length
>>>
>>> What are you trying to achieve here ? frame_length should be counted in
>>> words right ? And we get that value in bytes. So what's the best
>>> calculation to convert bytes into words ? If you have 8 bits_per_word
>>> you don't need any calculation, but if you have 32 bits_per_word, you
>>> _do_ need something.
>>>
>> Yes, just derive this formulae with 8 bits per word in mind.
>> Will change.
>> It should be (m->frame_length * 8) / spi->bits_per_word
> right on. To make sure this will execute a little faster (you never know
> what several different versions of GCC will do), instead of multiplying
> by 8, left shift by 3.
>
Ok. Will do.
>>> How will you achieve the number you want ? (hint: 1 byte == 8 bits)
>>>
>>> And btw, all of these mistakes pretty much tell me that this driver
>>> hasn't been tested. How have you tested this driver ?
>> After bootup, I checked for deive detting enumerated as /proc/mtd.
>> After which I am using mtdutils(erase, dump and write utilied to
>> check for the communication with the flash device.)
> alright, make that clear in your commit log.
>
Ok.
