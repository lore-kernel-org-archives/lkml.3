Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbaGCP70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:59:26 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.181]:39288 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbaGCP7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:59:25 -0400
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGoheedClaTaNdBkW0QEOcx1Ft+DpaWf0qqN8/jSv6Kcuc3PZrnFbUtY5gcAIXMk1wD4hL5m
X-RZG-CLASS-ID: mo05
Message-ID: <53B57DDE.90603@denx.de>
Date: Thu, 03 Jul 2014 17:59:26 +0200
From: Stefan Roese <sr@denx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Lattice ECP3 FPGA: Correct endianness
References: <CAL8zT=isq_2RT07a6z8imJ4N0w0v-yw6ysv3wf+S7sLsqZBCeg@mail.gmail.com>
In-Reply-To: <CAL8zT=isq_2RT07a6z8imJ4N0w0v-yw6ysv3wf+S7sLsqZBCeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.07.2014 17:54, Jean-Michel Hautbois wrote:
> This patch corrects three big/little endian issues. Tested on i.MX6.
> 
> From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> Date: Thu, 3 Jul 2014 17:49:47 +0200
> Subject: [PATCH] Endianness corrections
> 
> ---
>   drivers/misc/lattice-ecp3-config.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/misc/lattice-ecp3-config.c
> b/drivers/misc/lattice-ecp3-config.c
> index bb26f08..23d5c01 100644
> --- a/drivers/misc/lattice-ecp3-config.c
> +++ b/drivers/misc/lattice-ecp3-config.c
> @@ -93,7 +93,7 @@ static void firmware_load(const struct firmware *fw,
> void *context)
>       txbuf[0] = FPGA_CMD_READ_ID;
>       ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
>       dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", *(u32 *)&rxbuf[4]);
> -    jedec_id = *(u32 *)&rxbuf[4];
> +    jedec_id = be32_to_cpu(*(u32 *)&rxbuf[4]);
> 
>       for (i = 0; i < ARRAY_SIZE(ecp3_dev); i++) {
>           if (jedec_id == ecp3_dev[i].jedec_id)
> @@ -142,7 +142,7 @@ static void firmware_load(const struct firmware
> *fw, void *context)
>       for (i = 0; i < FPGA_CLEAR_LOOP_COUNT; i++) {
>           txbuf[0] = FPGA_CMD_READ_STATUS;
>           ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
> -        status = *(u32 *)&rxbuf[4];
> +        status = be32_to_cpu(*(u32 *)&rxbuf[4]);
>           if (status == FPGA_STATUS_CLEARED)
>               break;
> 
> @@ -165,8 +165,8 @@ static void firmware_load(const struct firmware
> *fw, void *context)
> 
>       txbuf[0] = FPGA_CMD_READ_STATUS;
>       ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
> -    dev_dbg(&spi->dev, "FPGA Status=%08x\n", *(u32 *)&rxbuf[4]);
> -    status = *(u32 *)&rxbuf[4];
> +    dev_dbg(&spi->dev, "FPGA Status=%08x\n", be32_to_cpu(*(u32 *)&rxbuf[4]));
> +    status = be32_to_cpu(*(u32 *)&rxbuf[4]);

I know you didn't introduce this, but this re-ordering does look better:

+    status = be32_to_cpu(*(u32 *)&rxbuf[4]);
+    dev_dbg(&spi->dev, "FPGA Status=%08x\n", status);

Other than that:

Acked-by: Stefan Roese <sr@denx.de>

Thanks,
Stefan

