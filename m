Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3GBLAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:00:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35343 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab3GBLAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:00:01 -0400
Message-ID: <51D2B2A3.3080402@ti.com>
Date: Tue, 2 Jul 2013 16:29:47 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>, <balbi@ti.com>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] drivers: spi: Add qspi flash controller
References: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com> <51D2B220.1010501@ti.com>
In-Reply-To: <51D2B220.1010501@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,
On Tuesday 02 July 2013 04:27 PM, Sekhar Nori wrote:
> On 7/2/2013 2:26 PM, Sourav Poddar wrote:
>> The patch add basic support for the quad spi controller.
>>
>> QSPI is a kind of spi module that allows single,
>> dual and quad read access to external spi devices. The module
>> has a memory mapped interface which provide direct interface
>> for accessing data form external spi devices.
>>
>> The patch will configure controller clocks, device control
>> register and for defining low level transfer apis which
>> will be used by the spi framework to transfer data to
>> the slave spi device(flash in this case).
>>
>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>> ---
>> This patch was sent as a part of a series[1];
>> but this can go in as a standalone patch.
>> [1]: https://lkml.org/lkml/2013/6/26/83
>>
>> v1->v2:
>> 1. Placed pm specific calls in prepare/unprepare apis.
>> 2. Put a mask to support upto 32 bits word length.
>> 3. Used "devm_ioremap_resource" variants.
>> 4. Add dt binding doumentation.
>>   Documentation/devicetree/bindings/spi/ti_qspi.txt |   22 ++
>>   drivers/spi/Kconfig                               |    8 +
>>   drivers/spi/Makefile                              |    1 +
>>   drivers/spi/ti-qspi.c                             |  357 +++++++++++++++++++++
>>   4 files changed, 388 insertions(+), 0 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/spi/ti_qspi.txt
>>   create mode 100644 drivers/spi/ti-qspi.c
> Please cc devicetree-discuss list when adding new bindings.
>
Ok.
>> +static int dra7xxx_qspi_probe(struct platform_device *pdev)
>> +{
>> +	struct  dra7xxx_qspi *qspi;
>> +	struct spi_master *master;
>> +	struct resource         *r;
>> +	struct device_node *np = pdev->dev.of_node;
>> +	u32 max_freq;
>> +	int ret;
>> +
>> +	master = spi_alloc_master(&pdev->dev, sizeof(*qspi));
>> +	if (!master)
>> +		return -ENOMEM;
>> +
>> +	master->mode_bits = SPI_CPOL | SPI_CPHA;
>> +
>> +	master->num_chipselect = 1;
>> +	master->bus_num = -1;
>> +	master->setup = dra7xxx_qspi_setup;
>> +	master->prepare_transfer_hardware = dra7xxx_qspi_prepare_xfer;
>> +	master->transfer_one_message = dra7xxx_qspi_start_transfer_one;
>> +	master->unprepare_transfer_hardware = dra7xxx_qspi_unprepare_xfer;
>> +	master->dev.of_node = pdev->dev.of_node;
>> +	master->bits_per_word_mask = BIT(32 - 1) | BIT(16 - 1) | BIT(8 - 1);
>> +
>> +	dev_set_drvdata(&pdev->dev, master);
>> +
>> +	qspi = spi_master_get_devdata(master);
>> +	qspi->master = master;
>> +	qspi->dev =&pdev->dev;
>> +
>> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (r == NULL) {
>> +		ret = -ENODEV;
>> +		goto free_master;
>> +	}
>> +
>> +	qspi->base = devm_ioremap_resource(&pdev->dev, r);
>> +	if (!qspi->base) {
>> +		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");
>> +		ret = -ENOMEM;
>> +		goto free_master;
>> +	}
> This should be
>
> 	if (IS_ERR(qspi->base)) {
> 		dev_dbg(&pdev->dev, "can't ioremap QSPI\n");
> 		ret = PTR_ERR(qspi->base);
> 		goto free_master;
> 	}
>
Ok. will change it in next version.
> Thanks,
> Sekhar

