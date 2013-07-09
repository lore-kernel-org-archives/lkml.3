Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3GIMvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:51:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36299 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab3GIMvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:51:06 -0400
Message-ID: <51DC072F.40704@ti.com>
Date: Tue, 9 Jul 2013 07:50:55 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Sourav Poddar <sourav.poddar@ti.com>, <broonie@kernel.org>,
        <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/3] drivers: spi: Add qspi flash controller
References: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com> <1373290980-17883-3-git-send-email-sourav.poddar@ti.com> <20130708203330.GA28322@kahuna> <20130709065143.GC5552@arwen.pp.htv.fi>
In-Reply-To: <20130709065143.GC5552@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 01:51 AM, Felipe Balbi wrote:
> On Mon, Jul 08, 2013 at 03:33:30PM -0500, Nishanth Menon wrote:

>>> +static int dra7xxx_qspi_start_transfer_one(struct spi_master *master,
>>> +		struct spi_message *m)
>>> +{
>>> +	struct dra7xxx_qspi *qspi = spi_master_get_devdata(master);
>>> +	struct spi_device *spi = m->spi;
>>> +	struct spi_transfer *t;
>>> +	int status = 0;
>>> +	int frame_length;
>>> +
>>> +	/* setup device control reg */
>>> +	qspi->dc = 0;
>>> +
>>> +	if (spi->mode & SPI_CPHA)
>>> +		qspi->dc |= QSPI_CKPHA(spi->chip_select);
>>> +	if (spi->mode & SPI_CPOL)
>>> +		qspi->dc |= QSPI_CKPOL(spi->chip_select);
>>> +	if (spi->mode & SPI_CS_HIGH)
>>> +		qspi->dc |= QSPI_CSPOL(spi->chip_select);
>>> +
>>> +	frame_length = DIV_ROUND_UP(m->frame_length * spi->bits_per_word,
>>> +				spi->bits_per_word);
>>> +
>>> +	frame_length = clamp(frame_length, 0, QSPI_FRAME_MAX);
>>> +
>>> +	/* setup command reg */
>>> +	qspi->cmd = 0;
>>> +	qspi->cmd |= QSPI_EN_CS(spi->chip_select);
>>> +	qspi->cmd |= QSPI_FLEN(frame_length);
>>> +
>> how does one ensure pm runtime has not disabled clocks in
>> background? e.g. long latency between transfers.
>
> because pm_runtime_put*() has not been called ?
>
> There's no way clocks will be gated until we kick the pm autosuspend
> timer, which is only done when the transfer is finished.

with this input and looking closer, I think I see what you are saying now:
dra7xxx_qspi_prepare_xfer -> does a pm_runtime_get_sync
dra7xxx_qspi_unprepare_xfer -> does a pm_runtime_mark_last_busy, 
pm_runtime_put_autosuspend

In between these calls, you have the remaining xfer calls going on.
we are assuming here that autosuspend timeout should be greater than the 
time to complete the worst case transfer.

Is that a valid assumption? would it not be better to mark_busy at other 
points? my thought is that considering a threaded isr, if by any chance 
you have a latency > autosuspend due to premption or some un-forseen 
event, this could crash badly, no? mark_busy will atleast ensure that 
runtime timer is reset. yep, we can also argue to converse, with a 
autosuspend delay set to appropriate value, we should not see this 
issue. pm_runtime_mark_last_busy() may be executed from interrupt 
context as well. At least going with "marks the last time of the 
device's busy state" we dont seem to mark them at all potential points?

ofcourse we can debate about how granular the marking should be, IMHO, 
though, I like autosuspend, however, I like autosuspend as a way to 
reduce transfer-to-transfer latency to re-enable the clocks. I however 
am a bit gittery about autosuspend kicking inside required time 
boundaries (especially considering the delay is upto user of the system).

Just my 2 cents.

[...]

>>> +	qspi->base = devm_ioremap_resource(&pdev->dev, r);
>>> +	if (IS_ERR(qspi->base)) {
>>> +		ret = -ENOMEM;
>>> +		goto free_master;
>>> +	}
>> why not use devm_request_and_ioremap? Lock that region down so that no
>> two drivers can manage the same region?
>
> read devm_ioremap_resource() and look at the git log for all the
> numerous drivers which were converted to devm_ioremap_resource() to find
> the reason.

my bad. fair enough.

-- 
Regards,
Nishanth Menon
