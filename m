Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3JUICV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:02:21 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:26770 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab3JUICR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:02:17 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Richard Genoud <richard.genoud@gmail.com>
CC: "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        Mark Brown <broonie@kernel.org>
Subject: RE: [BUG] spi/spi-atmel: DMA rx buffer corruption with
 SPI_IOC_MESSAGE
Thread-Topic: [BUG] spi/spi-atmel: DMA rx buffer corruption with
 SPI_IOC_MESSAGE
Thread-Index: AQHOxBNtqj14WIxJgkiXUBKLYopIXpn4QhGAgAacvbA=
Date: Mon, 21 Oct 2013 08:02:05 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364172E9CFB1@penmbx01>
References: <CACQ1gAhNFTdG_2OCTnsOCaBozHnGb9EwAGHT5+f=cARRpC_WBg@mail.gmail.com>
 <CACQ1gAjT30VLg5u5s6skRw0svMLavM2rZkG879VzmphtoKb=Vg@mail.gmail.com>
In-Reply-To: <CACQ1gAjT30VLg5u5s6skRw0svMLavM2rZkG879VzmphtoKb=Vg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9L82TXW029688

Hi Richard,

> -----Original Message-----
> From: Richard Genoud [mailto:richard.genoud@gmail.com]
> Sent: 2013å¹´10æœˆ17æ—¥ 19:01
> To: Yang, Wenyou
> Cc: linux-spi@vger.kernel.org; linux-kernel@vger.kernel.org; Ferre, Nicolas;
> Mark Brown
> Subject: Re: [BUG] spi/spi-atmel: DMA rx buffer corruption with
> SPI_IOC_MESSAGE
> 
> 2013/10/8 Richard Genoud <richard.genoud@gmail.com>:
> > Hi all,
> >
> > I finally found the bug I saw months ago, before "[PATCH v8 3/8]
> > spi/spi-atmel: add dmaengine support" was merged.
> >
> > Here it is:
> >
> > When the ioctl SPI_IOC_MESSAGE is used with small and big buffers,
> > the big RX buffer is corrupted with bytes from the big TX buffer.
> > (Small means size < DMA_MIN_BYTES, Big means size >
> DMA_MIN_BYTES)
> >
> > I'm attaching the test software that I used ( ./spi_test /dev/spidevx.x )
> >
> > It fills 3 TX buffers with 0xAA pattern: a small, a big and a small again.
> > It reads in return 3 RX buffers.
> > The MISO pin has to be on 3.3v.
> >
> > It checks if the received buffers are filled with 0xFF (they should
> > be, as MISO is high).
> > And I've got a lot of buffers filled partially with 0xAA bytes.
> >
> > BUT, if you apply this patch:
> > ---8<----
> > diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> > index 83cf609..cde42a4 100644
> > --- a/drivers/spi/spi-atmel.c
> > +++ b/drivers/spi/spi-atmel.c
> > @@ -187,7 +187,7 @@
> >  /* use PIO for small transfers, avoiding DMA setup/teardown overhead
> and
> >   * cache operations; better heuristics consider wordsize and bitrate.
> >   */
> > -#define DMA_MIN_BYTES  16
> > +#define DMA_MIN_BYTES  0
> >
> >  struct atmel_spi_dma {
> >         struct dma_chan                 *chan_rx;
> > ---8<----
> > There's no error any more.
> > So there's something wrong happening when switching from/to pio
> > transfer to/from DMA.
> >
> > We didn't saw that at the time of the merge because we did the test
> > with a loop on MISO/MOSI,
> > so the RX buffer was corrupted with identical bytes.
> >
> > Best regards,
> > Richard.
> 
> Hi Wenyou,
> 
> Did you have the opportunity to give it a test ?
> 
> Thread: https://lkml.org/lkml/2013/10/8/329
I tried to reproduce it with this thread, but I didn't
Which slave device did you use? 

> 
> Richard.

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
