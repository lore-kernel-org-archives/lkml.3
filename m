Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaDDDez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:34:55 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:61584 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaDDDew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:34:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140403212940.GY14763@sirena.org.uk>
References: <1396544587-10876-1-git-send-email-punnaia@xilinx.com>
	<203181a5-626f-437e-8efe-983a9d78ec5d@AM1EHSMHS017.ehs.local>
	<20140403212940.GY14763@sirena.org.uk>
Date: Fri, 4 Apr 2014 08:59:47 +0530
Message-ID: <CAFcVECJiSm8MMJ37c-Qfsu-UE0jgEYRmeGZ8OQG97wyRMaJ1LQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] SPI: Add support for Zynq Quad SPI controller
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Punnaiah Choudary <kpc528@gmail.com>,
        punnaiah choudary kalluri <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Apr 4, 2014 at 2:59 AM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Apr 03, 2014 at 10:33:07PM +0530, Punnaiah Choudary Kalluri wrote:
>
> Overall this looks fairly good, there are a few issues that need to be
> looked at but they're not too invasive.  Please also check for coding
> style issues, quite a few spaces before commas for example.
>

Thanks. I'll check that.

<snip>

>> +/**
>> + * zynq_qspi_copy_read_data - Copy data to RX buffer
>> + * @xqspi:   Pointer to the zynq_qspi structure
>> + * @data:    The 32 bit variable where data is stored
>> + * @size:    Number of bytes to be copied from data to RX buffer
>> + */
>> +static void zynq_qspi_copy_read_data(struct zynq_qspi *xqspi, u32 data, u8 size)
>> +{
>> +     if (xqspi->rxbuf) {
>> +             memcpy(xqspi->rxbuf, ((u8 *) &data) + 4 - size, size);
>> +             xqspi->rxbuf += size;
>> +     }
>> +     xqspi->bytes_to_receive -= size;
>> +}
>
> Does this and the write function really need to be a separate function -
> it's trivial and used once?  It's probably more beneficial to split out
> some of the more complex logic later on that's causing the indentation
> to get too deep.
>

I'm aware it's used in only one place but it does make receive data handling
easier for future. As you may have noticed there are 4 different ways to
write into transmit FIFO and the data read also differs accordingly.
I'll try to reduce the indentation in other places.

<snip>

>> +static int zynq_qspi_setup_transfer(struct spi_device *qspi,
>> +                                 struct spi_transfer *transfer)
>> +{
>> +     struct zynq_qspi *xqspi = spi_master_get_devdata(qspi->master);
>> +     u32 config_reg, req_hz, baud_rate_val = 0;
>> +
>> +     if (transfer)
>> +             req_hz = transfer->speed_hz;
>> +     else
>> +             req_hz = qspi->max_speed_hz;
>
> Why would a transfer be being set up without a transfer being provided?
>

The setup function calls this function before a transfer is initiated.
In this case NULL is passed to setup_transfer (see below) and
SPI is initialized with default clock configuration.
This initialization is necessary because otherwise this clock config
would be done
only after SPI is enabled in prepare_hardware, which is wrong.
(I'm checking for master->busy in setup to address your previous
comment on SPI).

I explained the same in SPI v2 changes and this valid there too.

>> +/**
>> + * zynq_qspi_setup - Configure the QSPI controller
>> + * @qspi:    Pointer to the spi_device structure
>> + *
>> + * Sets the operational mode of QSPI controller for the next QSPI transfer, baud
>> + * rate and divisor value to setup the requested qspi clock.
>> + *
>> + * Return:   0 on success and error value on failure
>> + */
>> +static int zynq_qspi_setup(struct spi_device *qspi)
>> +{
>> +     if (qspi->master->busy)
>> +             return -EBUSY;
>> +
>> +     return zynq_qspi_setup_transfer(qspi, NULL);
>> +}
>
> No, this is broken - you have to support setup() while the hardware is
> active.  Just remove this if there's nothing to do and set up on the
> transfer.

But where do you suggest this clock configuration be done?
I've looked at the option of doing it in prepare_hardware but
spi_device structure is not passed to it.

<snip>

>
>> +                             if (xqspi->rxbuf) {
>> +                                     (*(u32 *)xqspi->rxbuf) =
>> +                                     zynq_qspi_read(xqspi,
>> +                                                    ZYNQ_QSPI_RXD_OFFSET);
>> +                                     xqspi->rxbuf += 4;
>
> This only works in 4 byte words?  That seems a bit limited.
> Alternatively, if it works with smaller sizes (as it appears to) then
> isn't this at risk of overflowing buffers?
>

There is a
if (xqspi->bytes_to_receive < 4) {
above and this statement is in the else loop.
When less than 4 bytes are being read/received, the handling is different.

>> +static int __maybe_unused zynq_qspi_suspend(struct device *_dev)
>> +{
>> +     struct platform_device *pdev = container_of(_dev,
>> +                     struct platform_device, dev);
>> +     struct spi_master *master = platform_get_drvdata(pdev);
>> +
>> +     spi_master_suspend(master);
>> +
>> +     zynq_unprepare_transfer_hardware(master);
>
> Why are you unpreparing the hardware - the framework should be doing
> that for you if the device is active, if it's not you've got an extra
> clock disable here?
>

I called unprepare_hardware  becuase it does the things necessary
after master suspend - disable clock and controller.
(I thought this was your suggestion for SPI?)

>> +static int __maybe_unused zynq_qspi_resume(struct device *dev)
>
> This doesn't appear to be calling init_hw() - is it guaranteed that all
> the register settings written there are OK after power on?
>
>> +     ret = clk_prepare_enable(xqspi->aperclk);
>> +     if (ret) {
>> +             dev_err(&pdev->dev, "Unable to enable APER clock.\n");
>> +             goto remove_master;
>> +     }
>> +
>> +     ret = clk_prepare_enable(xqspi->devclk);
>> +     if (ret) {
>> +             dev_err(&pdev->dev, "Unable to enable device clock.\n");
>> +             goto clk_dis_aper;
>> +     }
>
> The driver isn't using runtime_pm or otherwise disabling the clocks when
> idle so it looks like the clocks will always be enabled and the
> management in prepare and unprepare won't have any practical effect.  I
> can see needing at least one of the clocks for setting up the device but
> probably either the probe should disable them as it finishes or you
> should move the clock enable/disable from prepare/unprepare to runtime
> PM.

OK I understand.

Thanks for the review.

Regards,
Harini
