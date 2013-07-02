Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab3GBKYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:24:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58717 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab3GBKYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:24:02 -0400
Message-ID: <51D2AA35.2070002@ti.com>
Date: Tue, 2 Jul 2013 15:53:49 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] drivers: spi: Add qspi flash controller
References: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com> <20130702092458.GI3352@arwen.pp.htv.fi> <51D2A4CA.5030804@ti.com> <20130702101608.GO3352@arwen.pp.htv.fi>
In-Reply-To: <20130702101608.GO3352@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 July 2013 03:46 PM, Felipe Balbi wrote:
> Hi,
>
> On Tue, Jul 02, 2013 at 03:30:42PM +0530, Sourav Poddar wrote:
>>>> +static int dra7xxx_qspi_setup(struct spi_device *spi)
>>>> +{
>>>> +	struct dra7xxx_qspi	*qspi =
>>>> +			spi_master_get_devdata(spi->master);
>>>> +
>>>> +	int clk_div;
>>>> +
>>>> +	if (!qspi->spi_max_frequency)
>>>> +		clk_div = 0;
>>> won't this generate division by zero ?
>>>
>> Yes, Probably only an error should be thrown here. ?
>> since min clk_div should be kept at 1.
> right, if spi_max_frequency isn't passed, this is a broken DT binding.
> Bail out.
>
>>>> +	pm_runtime_get_sync(qspi->dev);
>>>> +
>>>> +	/* disable SCLK */
>>>> +	dra7xxx_writel(qspi, dra7xxx_readl(qspi, QSPI_SPI_CLOCK_CNTRL_REG)
>>>> +			&   ~QSPI_CLK_EN, QSPI_SPI_CLOCK_CNTRL_REG);
>>>> +
>>>> +	if (clk_div<   0) {
> btw, add a space between clk_div and<
>
>>>> +			dra7xxx_writel(qspi, *txbuf++, QSPI_SPI_DATA_REG);
>>>> +			dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
>>>> +			dra7xxx_writel(qspi, qspi->cmd | QSPI_WR_SNGL,
>>>> +					QSPI_SPI_CMD_REG);
>>>> +			status = dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
>>>> +			timeout = QSPI_TIMEOUT;
>>>> +			while ((status&   QSPI_WC_BUSY) != QSPI_XFER_DONE) {
>>> do you really need to poll ? No IRQ available ?
>>>
>> There is an interrupt available, I will try using that.
> look at how i2c-omap.c synchronizes interrupt with the transfer_msg
> code. It just uses a wait_for_completion().
>
Ok.
>>>> +static int dra7xxx_qspi_start_transfer_one(struct spi_master *master,
>>>> +		struct spi_message *m)
>>>> +{
>>>> +	struct dra7xxx_qspi *qspi = spi_master_get_devdata(master);
>>>> +	struct spi_device *spi = m->spi;
>>>> +	struct spi_transfer *t;
>>>> +	int status = 0;
>>>> +	int flags = 0;
>>>> +
>>>> +	/* setup command reg */
>>>> +	qspi->cmd = 0;
>>>> +	qspi->cmd |= QSPI_WLEN(8);
>>>> +	qspi->cmd |= QSPI_EN_CS(0);
>>>> +	qspi->cmd |= 0xfff;
>> Since, we dont know the number of frame lenght that need to be
>> transferred and it comes from the spi framework, we keep the frame
>> lenght to maximum.
>> Then depending on the count value above in while loop, we terminate
>> our trasnfer.
> what ? seriously didn't get what you meant.
>
I mean, the lower 12 bits of cmd register is meant to be filled with 
frame lenght.

But the frame lenght is parsed when you iterate the list. So, what is 
done here is that
the framelenght is kept to its maximum value.

Then, to signal the the end of the frame, we use

static int qspi_transfer_msg(struct dra7xxx_qspi *qspi, unsigned count,
                         const u8 *txbuf, u8 *rxbuf, bool flags)
{
         uint status;
         int timeout;

         while (count--) {
                 if (txbuf) {
                         pr_debug("tx cmd %08x dc %08x data %02x\n",
                                 qspi->cmd | QSPI_WR_SNGL, qspi->dc, 
*txbuf);
                         dra7xxx_writel(qspi, *txbuf++, QSPI_SPI_DATA_REG);
                         dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
                         dra7xxx_writel(qspi, qspi->cmd | QSPI_WR_SNGL,
                                         QSPI_SPI_CMD_REG);
                         status = dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
                         timeout = QSPI_TIMEOUT;
                         while ((status & QSPI_WC_BUSY) != QSPI_XFER_DONE) {
                                 if (--timeout < 0) {
                                         pr_debug("QSPI tx timed out\n");
                                         return

      .............................

                                    status, *(rxbuf-1));
                 }
         }

         if (flags & XFER_END)
                 dra7xxx_writel(qspi, qspi->cmd | QSPI_INVAL, 
QSPI_SPI_CMD_REG);

}
INVAL will terminate the current frame.
