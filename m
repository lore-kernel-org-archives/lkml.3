Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3JUI00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:26:26 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:55814 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3JUI0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:26:24 -0400
MIME-Version: 1.0
In-Reply-To: <B256D81BAE5131468A838E5D7A24364172E9CFB1@penmbx01>
References: <CACQ1gAhNFTdG_2OCTnsOCaBozHnGb9EwAGHT5+f=cARRpC_WBg@mail.gmail.com>
 <CACQ1gAjT30VLg5u5s6skRw0svMLavM2rZkG879VzmphtoKb=Vg@mail.gmail.com> <B256D81BAE5131468A838E5D7A24364172E9CFB1@penmbx01>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 21 Oct 2013 10:26:03 +0200
Message-ID: <CACQ1gAh-ZmL27q2w-0Aj4Lw6p6Y87cEJL7k_Ai9taDmsH_-qjg@mail.gmail.com>
Subject: Re: [BUG] spi/spi-atmel: DMA rx buffer corruption with SPI_IOC_MESSAGE
To: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
Cc: "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/21 Yang, Wenyou <Wenyou.Yang@atmel.com>:
> Hi Richard,
>
>> -----Original Message-----
>> From: Richard Genoud [mailto:richard.genoud@gmail.com]
>> Sent: 2013年10月17日 19:01
>> To: Yang, Wenyou
>> Cc: linux-spi@vger.kernel.org; linux-kernel@vger.kernel.org; Ferre, Nicolas;
>> Mark Brown
>> Subject: Re: [BUG] spi/spi-atmel: DMA rx buffer corruption with
>> SPI_IOC_MESSAGE
>>
>> 2013/10/8 Richard Genoud <richard.genoud@gmail.com>:
>> > Hi all,
>> >
>> > I finally found the bug I saw months ago, before "[PATCH v8 3/8]
>> > spi/spi-atmel: add dmaengine support" was merged.
>> >
>> > Here it is:
>> >
>> > When the ioctl SPI_IOC_MESSAGE is used with small and big buffers,
>> > the big RX buffer is corrupted with bytes from the big TX buffer.
>> > (Small means size < DMA_MIN_BYTES, Big means size >
>> DMA_MIN_BYTES)
>> >
>> > I'm attaching the test software that I used ( ./spi_test /dev/spidevx.x )
>> >
>> > It fills 3 TX buffers with 0xAA pattern: a small, a big and a small again.
>> > It reads in return 3 RX buffers.
>> > The MISO pin has to be on 3.3v.
>> >
>> > It checks if the received buffers are filled with 0xFF (they should
>> > be, as MISO is high).
>> > And I've got a lot of buffers filled partially with 0xAA bytes.
>> >
>> > BUT, if you apply this patch:
>> > ---8<----
>> > diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
>> > index 83cf609..cde42a4 100644
>> > --- a/drivers/spi/spi-atmel.c
>> > +++ b/drivers/spi/spi-atmel.c
>> > @@ -187,7 +187,7 @@
>> >  /* use PIO for small transfers, avoiding DMA setup/teardown overhead
>> and
>> >   * cache operations; better heuristics consider wordsize and bitrate.
>> >   */
>> > -#define DMA_MIN_BYTES  16
>> > +#define DMA_MIN_BYTES  0
>> >
>> >  struct atmel_spi_dma {
>> >         struct dma_chan                 *chan_rx;
>> > ---8<----
>> > There's no error any more.
>> > So there's something wrong happening when switching from/to pio
>> > transfer to/from DMA.
>> >
>> > We didn't saw that at the time of the merge because we did the test
>> > with a loop on MISO/MOSI,
>> > so the RX buffer was corrupted with identical bytes.
>> >
>> > Best regards,
>> > Richard.
>>
>> Hi Wenyou,
>>
>> Did you have the opportunity to give it a test ?
>>
>> Thread: https://lkml.org/lkml/2013/10/8/329
> I tried to reproduce it with this thread, but I didn't
> Which slave device did you use?

Hi Wenyou,

I'm not using any slave device, I'm just setting the MISO pin to 3.3V,
then I execute the C code ( https://lkml.org/lkml/2013/10/8/329 )
So, we should only receive 0xFF in the buffer.
But i'm getting :
aa aa aa aa aa aa aa aa aa aa aa aa aa aa ff ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff
aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
aa aa aa aa aa aa aa aa aa aa aa aa aa aa ff ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff

Richard.
