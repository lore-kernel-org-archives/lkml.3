Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbbA0TNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:13:01 -0500
Received: from mail6.webfaction.com ([74.55.86.74]:50997 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbA0TM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:12:59 -0500
X-Greylist: delayed 1357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2015 14:12:59 EST
Message-ID: <54C7DDEB.50406@tastycactus.com>
Date: Tue, 27 Jan 2015 11:50:19 -0700
From: Aaron Brice <aaron@tastycactus.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>, mark.rutland@arm.com
CC: stefan@agner.ch, shawn.guo@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, broonie@kernel.org,
        B44548@freescale.com, Li.Xiubo@freescale.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH 3/7] spi: spi-fsl-dspi: Remove usage of devm_kzalloc
References: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com> <1422356244-15629-4-git-send-email-bhuvanchandra.dv@toradex.com>
In-Reply-To: <1422356244-15629-4-git-send-email-bhuvanchandra.dv@toradex.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 03:57 AM, Bhuvanchandra DV wrote:
> devm_* API was supposed to be used only in probe function call.
> Memory is allocated at 'probe' and free automatically at 'remove'.
> Usage of devm_* functions outside probe sometimes leads to memory leak.
> Avoid using devm_kzalloc in dspi_setup_transfer and use kzalloc instead.
> Also add the dspi_cleanup function to free the controller data upon
> cleanup.
>
> [    1.027945] fsl-dspi 4002d000.dspi1: registered master spi1
> [    1.028664] spi spi1.0: setup mode 0, 8 bits/w, 50000000 Hz max --> 0
> [    1.028877] ------------[ cut here ]------------
> [    1.036953] WARNING: CPU: 0 PID: 1 at drivers/base/dd.c:286 driver_probe_device+0x1d8/0x244()
> [    1.052136] Modules linked in:
> [    1.058525] CPU: 0 PID: 1 Comm: swapper Not tainted 3.19.0-rc1-104479-g702bebc #202
> [    1.072777] Backtrace:
> [    1.078437] [<80011a04>] (dump_backtrace) from [<80011ce0>] (show_stack+0x18/0x1c)
> [    1.092393]  r6:0000011e r5:00000009 r4:00000000 r3:00000000
> [    1.101639] [<80011cc8>] (show_stack) from [<805a2d18>] (dump_stack+0x24/0x28)
> [    1.115701] [<805a2cf4>] (dump_stack) from [<80021564>] (warn_slowpath_common+0x74/0x8c)
> [    1.130905] [<800214f0>] (warn_slowpath_common) from [<80021620>] (warn_slowpath_null+0x24/0x2c)
> [    1.147289]  r8:00000000 r7:807d5dd0 r6:802e2f54 r5:8ea1a200 r4:808444d4
> [    1.158272] [<800215fc>] (warn_slowpath_null) from [<802e2ee8>] (driver_probe_device+0x1d8/0x244)
> [    1.175532] [<802e2d10>] (driver_probe_device) from [<802e2f9c>] (__device_attach+0x48/0x4c)
> [    1.192583]  r8:00000000 r7:8ea40000 r6:802e2f54 r5:8ea1a200 r4:807d5dd0 r3:8035a150
> [    1.209718] [<802e2f54>] (__device_attach) from [<802e14ac>] (bus_for_each_drv+0x60/0x94)
> [    1.227619]  r5:8ea1a200 r4:00000000
> [    1.236097] [<802e144c>] (bus_for_each_drv) from [<802e2cd4>] (device_attach+0x7c/0x90)
> [    1.253809]  r6:807d5cc0 r5:8ea1a234 r4:8ea1a200
> [    1.263442] [<802e2c58>] (device_attach) from [<802e2338>] (bus_probe_device+0x8c/0xb0)
> [    1.281269]  r6:807d5cc0 r5:8ea1a200 r4:8ea1a208 r3:8e881cc0
> [    1.292124] [<802e22ac>] (bus_probe_device) from [<802e06c8>] (device_add+0x448/0x528)
> [    1.309972]  r6:8ea1a200 r5:00000000 r4:8ea1a208 r3:00000001
> [    1.320830] [<802e0280>] (device_add) from [<8035a8c8>] (spi_add_device+0x9c/0x15c)
> [    1.338382]  r9:8e8ab210 r8:00000000 r7:8e8ab210 r6:00000000 r5:8ea40000 r4:8ea1a200
> [    1.356236] [<8035a82c>] (spi_add_device) from [<8035c0a8>] (spi_register_master+0x4d8/0x73c)
> [    1.374695]  r7:8ea1a368 r6:8ea1a200 r5:8fde7f7c r4:8ea40000
> [    1.385537] [<8035bbd0>] (spi_register_master) from [<8035d930>] (spi_bitbang_start+0x9c/0x108)
> [    1.404100]  r10:00008088 r9:8e816f80 r8:8fde7c50 r7:8e8ab210 r6:8e8ab200 r5:8ea40000
> [    1.421967]  r4:8ea40000
> [    1.429305] [<8035d894>] (spi_bitbang_start) from [<8035e334>] (dspi_probe+0x1d4/0x2bc)
> [    1.446821]  r4:8ea40210 r3:80845a10
> [    1.455241] [<8035e160>] (dspi_probe) from [<802e4854>] (platform_drv_probe+0x4c/0xac)
> [    1.472666]  r10:00000000 r9:8ea1c2c0 r8:00000000 r7:807d5e20 r6:807d5e20 r5:fffffdfb
> [    1.490365]  r4:8e8ab210
> [    1.497638] [<802e4808>] (platform_drv_probe) from [<802e2e20>] (driver_probe_device+0x110/0x244)
> [    1.516021]  r7:807d5e20 r6:00000000 r5:8e8ab210 r4:808444d4
> [    1.526612] [<802e2d10>] (driver_probe_device) from [<802e3034>] (__driver_attach+0x94/0x98)
> [    1.544556]  r8:807735e8 r7:00000000 r6:8e8ab244 r5:807d5e20 r4:8e8ab210 r3:00000000
> [    1.562013] [<802e2fa0>] (__driver_attach) from [<802e13f4>] (bus_for_each_dev+0x68/0x9c)
> [    1.579714]  r6:802e2fa0 r5:807d5e20 r4:00000000 r3:8e8ad03c
> [    1.590310] [<802e138c>] (bus_for_each_dev) from [<802e2914>] (driver_attach+0x24/0x28)
> [    1.607804]  r6:807ca840 r5:8ea25700 r4:807d5e20
> [    1.617252] [<802e28f0>] (driver_attach) from [<802e25bc>] (bus_add_driver+0x150/0x1f8)
> [    1.634584] [<802e246c>] (bus_add_driver) from [<802e3670>] (driver_register+0x80/0x100)
> [    1.652292]  r7:8e842038 r6:8078e0f8 r5:807b3460 r4:807d5e20
> [    1.662953] [<802e35f0>] (driver_register) from [<802e4798>] (__platform_driver_register+0x5c/0x64)
> [    1.681772]  r5:807b3460 r4:807b3460
> [    1.690234] [<802e473c>] (__platform_driver_register) from [<8078e114>] (fsl_dspi_driver_init+0x1c/0x20)
> [    1.709306] [<8078e0f8>] (fsl_dspi_driver_init) from [<80008770>] (do_one_initcall+0x94/0x1d4)
> [    1.727791] [<800086dc>] (do_one_initcall) from [<80773e38>] (kernel_init_freeable+0x130/0x1d0)
> [    1.746412]  r10:8079eef0 r9:8079eee4 r8:807735e8 r7:807f1c80 r6:807f1c80 r5:00000006
> [    1.764399]  r4:807a7bc8
> [    1.771813] [<80773d08>] (kernel_init_freeable) from [<8059f864>] (kernel_init+0x10/0xf0)
> [    1.789660]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:8059f854
> [    1.807381]  r4:00000000
> [    1.814668] [<8059f854>] (kernel_init) from [<8000e638>] (ret_from_fork+0x14/0x3c)
> [    1.831772]  r4:00000000 r3:8e842000
> [    1.840212] ---[ end trace f7f1c89f62e53de9 ]---
>
> Acked-by: Stefan Agner <stefan@agner.ch>
> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
> ---
>   drivers/spi/spi-fsl-dspi.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
> index 4cda994..9b80d54 100644
> --- a/drivers/spi/spi-fsl-dspi.c
> +++ b/drivers/spi/spi-fsl-dspi.c
> @@ -342,8 +342,7 @@ static int dspi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
>   	/* Only alloc on first setup */
>   	chip = spi_get_ctldata(spi);
>   	if (chip == NULL) {
> -		chip = devm_kzalloc(&spi->dev, sizeof(struct chip_data),
> -				    GFP_KERNEL);
> +		chip = kzalloc(sizeof(struct chip_data), GFP_KERNEL);
>   		if (!chip)
>   			return -ENOMEM;
>   	}
> @@ -382,6 +381,16 @@ static int dspi_setup(struct spi_device *spi)
>   	return dspi_setup_transfer(spi, NULL);
>   }
>   
> +static void dspi_cleanup(struct spi_device *spi)
> +{
> +	struct chip_data *chip = spi_get_ctldata((struct spi_device *)spi);
> +
> +	dev_dbg(&spi->dev, "spi_device %u.%u cleanup\n",
> +			spi->master->bus_num, spi->chip_select);
> +
> +	kfree(chip);
> +}
> +
Does dspi_cleanup need a spi_set_ctldata((struct spi_device *)spi, NULL) ?
>   static irqreturn_t dspi_interrupt(int irq, void *dev_id)
>   {
>   	struct fsl_dspi *dspi = (struct fsl_dspi *)dev_id;
> @@ -467,6 +476,7 @@ static int dspi_probe(struct platform_device *pdev)
>   	dspi->bitbang.master->setup = dspi_setup;
>   	dspi->bitbang.master->dev.of_node = pdev->dev.of_node;
>   
> +	master->cleanup = dspi_cleanup;
>   	master->mode_bits = SPI_CPOL | SPI_CPHA;
>   	master->bits_per_word_mask = SPI_BPW_MASK(4) | SPI_BPW_MASK(8) |
>   					SPI_BPW_MASK(16);

