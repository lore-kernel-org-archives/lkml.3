Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab3BGAds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:33:48 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46747 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773Ab3BGAdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:33:43 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6uOaoRbtuovEsA87d-MtCbGNd3KZCeHXbBQaEpp6NZ7fA@mail.gmail.com>
References: <1360105784-12282-1-git-send-email-ks.giri@samsung.com>
	<1360105784-12282-2-git-send-email-ks.giri@samsung.com>
	<20130206102628.5E7413E1510@localhost>
	<CAKrE-KdX+Nxk0X4xdz6Dx3WVtOpV+ms+gPB-Dq-MwZwetyZ5Nw@mail.gmail.com>
	<CACxGe6uOaoRbtuovEsA87d-MtCbGNd3KZCeHXbBQaEpp6NZ7fA@mail.gmail.com>
Date: Wed, 6 Feb 2013 16:33:42 -0800
Message-ID: <CAKrE-Keyxqr_q=a-1pHjSVfeAte08JOdjwaT-0PbmZjgZWysNw@mail.gmail.com>
Subject: Re: [PATCH 1/4] spi: s3c64xx: modified error interrupt handling and init
From: Girish KS <girishks2000@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 3:48 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, Feb 6, 2013 at 8:12 PM, Girish KS <girishks2000@gmail.com> wrote:
>> On Wed, Feb 6, 2013 at 2:26 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>> On Tue,  5 Feb 2013 15:09:41 -0800, Girish K S <girishks2000@gmail.com> wrote:
>>>> The status of the interrupt is available in the status register,
>>>> so reading the clear pending register and writing back the same
>>>> value will not actually clear the pending interrupts. This patch
>>>> modifies the interrupt handler to read the status register and
>>>> clear the corresponding pending bit in the clear pending register.
>>>>
>>>> Modified the hwInit function to clear all the pending interrupts.
>>>>
>>>> Signed-off-by: Girish K S <ks.giri@samsung.com>
>>>> ---
>>>>  drivers/spi/spi-s3c64xx.c |   41 +++++++++++++++++++++++++----------------
>>>>  1 file changed, 25 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
>>>> index ad93231..b770f88 100644
>>>> --- a/drivers/spi/spi-s3c64xx.c
>>>> +++ b/drivers/spi/spi-s3c64xx.c
>>>> @@ -997,25 +997,30 @@ static irqreturn_t s3c64xx_spi_irq(int irq, void *data)
>>>>  {
>>>>       struct s3c64xx_spi_driver_data *sdd = data;
>>>>       struct spi_master *spi = sdd->master;
>>>> -     unsigned int val;
>>>> +     unsigned int val, clr = 0;
>>>>
>>>> -     val = readl(sdd->regs + S3C64XX_SPI_PENDING_CLR);
>>>> +     val = readl(sdd->regs + S3C64XX_SPI_STATUS);
>>>>
>>>> -     val &= S3C64XX_SPI_PND_RX_OVERRUN_CLR |
>>>> -             S3C64XX_SPI_PND_RX_UNDERRUN_CLR |
>>>> -             S3C64XX_SPI_PND_TX_OVERRUN_CLR |
>>>> -             S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
>>>> -
>>>> -     writel(val, sdd->regs + S3C64XX_SPI_PENDING_CLR);
>>>> -
>>>> -     if (val & S3C64XX_SPI_PND_RX_OVERRUN_CLR)
>>>> +     if (val & S3C64XX_SPI_ST_RX_OVERRUN_ERR) {
>>>> +             clr = S3C64XX_SPI_PND_RX_OVERRUN_CLR;
>>>>               dev_err(&spi->dev, "RX overrun\n");
>>>> -     if (val & S3C64XX_SPI_PND_RX_UNDERRUN_CLR)
>>>> +     }
>>>> +     if (val & S3C64XX_SPI_ST_RX_UNDERRUN_ERR) {
>>>> +             clr |= S3C64XX_SPI_PND_RX_UNDERRUN_CLR;
>>>>               dev_err(&spi->dev, "RX underrun\n");
>>>> -     if (val & S3C64XX_SPI_PND_TX_OVERRUN_CLR)
>>>> +     }
>>>> +     if (val & S3C64XX_SPI_ST_TX_OVERRUN_ERR) {
>>>> +             clr |= S3C64XX_SPI_PND_TX_OVERRUN_CLR;
>>>>               dev_err(&spi->dev, "TX overrun\n");
>>>> -     if (val & S3C64XX_SPI_PND_TX_UNDERRUN_CLR)
>>>> +     }
>>>> +     if (val & S3C64XX_SPI_ST_TX_UNDERRUN_ERR) {
>>>> +             clr |= S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
>>>>               dev_err(&spi->dev, "TX underrun\n");
>>>> +     }
>>>> +
>>>> +     /* Clear the pending irq by setting and then clearing it */
>>>> +     writel(clr, sdd->regs + S3C64XX_SPI_PENDING_CLR);
>>>> +     writel(clr & ~clr, sdd->regs + S3C64XX_SPI_PENDING_CLR);
>>>
>>> Wait, what?  clr & ~clr == 0   Always.  What are you actually trying to do here?
>> The user manual says, wirting 1 to the pending clear register clears
>> the interrupt (its not auto clear to 0). so i need to explicitly reset
>> those bits thats what the 2nd write does
>
> Then write 0. That's the result of what the code does anyway, but the
> code as-written is nonsensical.
Just writing 0 doest clear the status bit. The status bit in the
status register is cleared only when the corresponding bit in clear
pending register is set.
If not cleared after setting. On the next Interrupt, writing 1 to a
previously set bit will not clear the status bit.
Hope its clear
>
> g.
