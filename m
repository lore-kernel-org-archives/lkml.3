Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab3BGRrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:47:00 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:62150 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759194Ab3BGRq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:46:59 -0500
MIME-Version: 1.0
In-Reply-To: <1585017.derjdP1mHL@amdc1227>
References: <1360105784-12282-1-git-send-email-ks.giri@samsung.com>
	<20130206102628.5E7413E1510@localhost>
	<CAKrE-KdX+Nxk0X4xdz6Dx3WVtOpV+ms+gPB-Dq-MwZwetyZ5Nw@mail.gmail.com>
	<1585017.derjdP1mHL@amdc1227>
Date: Thu, 7 Feb 2013 09:46:58 -0800
Message-ID: <CAKrE-KfyGCi_+FozSpGTy0A0VJP=Jq-1SHmvKJU02iJKWHcvLQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] spi: s3c64xx: modified error interrupt handling and init
From: Girish KS <girishks2000@gmail.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 3:09 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Girish,
>
> On Wednesday 06 of February 2013 12:12:29 Girish KS wrote:
>> On Wed, Feb 6, 2013 at 2:26 AM, Grant Likely <grant.likely@secretlab.ca>
> wrote:
>> > On Tue,  5 Feb 2013 15:09:41 -0800, Girish K S
> <girishks2000@gmail.com> wrote:
>> >> The status of the interrupt is available in the status register,
>> >> so reading the clear pending register and writing back the same
>> >> value will not actually clear the pending interrupts. This patch
>> >> modifies the interrupt handler to read the status register and
>> >> clear the corresponding pending bit in the clear pending register.
>> >>
>> >> Modified the hwInit function to clear all the pending interrupts.
>> >>
>> >> Signed-off-by: Girish K S <ks.giri@samsung.com>
>> >> ---
>> >>
>> >>  drivers/spi/spi-s3c64xx.c |   41
>> >>  +++++++++++++++++++++++++---------------- 1 file changed, 25
>> >>  insertions(+), 16 deletions(-)
>> >>
>> >> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
>> >> index ad93231..b770f88 100644
>> >> --- a/drivers/spi/spi-s3c64xx.c
>> >> +++ b/drivers/spi/spi-s3c64xx.c
>> >> @@ -997,25 +997,30 @@ static irqreturn_t s3c64xx_spi_irq(int irq,
>> >> void *data)>>
>> >>  {
>> >>
>> >>       struct s3c64xx_spi_driver_data *sdd = data;
>> >>       struct spi_master *spi = sdd->master;
>> >>
>> >> -     unsigned int val;
>> >> +     unsigned int val, clr = 0;
>> >>
>> >> -     val = readl(sdd->regs + S3C64XX_SPI_PENDING_CLR);
>> >> +     val = readl(sdd->regs + S3C64XX_SPI_STATUS);
>> >>
>> >> -     val &= S3C64XX_SPI_PND_RX_OVERRUN_CLR |
>> >> -             S3C64XX_SPI_PND_RX_UNDERRUN_CLR |
>> >> -             S3C64XX_SPI_PND_TX_OVERRUN_CLR |
>> >> -             S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
>> >> -
>> >> -     writel(val, sdd->regs + S3C64XX_SPI_PENDING_CLR);
>> >> -
>> >> -     if (val & S3C64XX_SPI_PND_RX_OVERRUN_CLR)
>> >> +     if (val & S3C64XX_SPI_ST_RX_OVERRUN_ERR) {
>> >> +             clr = S3C64XX_SPI_PND_RX_OVERRUN_CLR;
>> >>
>> >>               dev_err(&spi->dev, "RX overrun\n");
>> >>
>> >> -     if (val & S3C64XX_SPI_PND_RX_UNDERRUN_CLR)
>> >> +     }
>> >> +     if (val & S3C64XX_SPI_ST_RX_UNDERRUN_ERR) {
>> >> +             clr |= S3C64XX_SPI_PND_RX_UNDERRUN_CLR;
>> >>
>> >>               dev_err(&spi->dev, "RX underrun\n");
>> >>
>> >> -     if (val & S3C64XX_SPI_PND_TX_OVERRUN_CLR)
>> >> +     }
>> >> +     if (val & S3C64XX_SPI_ST_TX_OVERRUN_ERR) {
>> >> +             clr |= S3C64XX_SPI_PND_TX_OVERRUN_CLR;
>> >>
>> >>               dev_err(&spi->dev, "TX overrun\n");
>> >>
>> >> -     if (val & S3C64XX_SPI_PND_TX_UNDERRUN_CLR)
>> >> +     }
>> >> +     if (val & S3C64XX_SPI_ST_TX_UNDERRUN_ERR) {
>> >> +             clr |= S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
>> >>
>> >>               dev_err(&spi->dev, "TX underrun\n");
>> >>
>> >> +     }
>> >> +
>> >> +     /* Clear the pending irq by setting and then clearing it */
>> >> +     writel(clr, sdd->regs + S3C64XX_SPI_PENDING_CLR);
>> >> +     writel(clr & ~clr, sdd->regs + S3C64XX_SPI_PENDING_CLR);
>> >
>> > Wait, what?  clr & ~clr == 0   Always.  What are you actually trying
>> > to do here?
>> The user manual says, wirting 1 to the pending clear register clears
>> the interrupt (its not auto clear to 0). so i need to explicitly reset
>> those bits thats what the 2nd write does
>
> I have looked through user's manuals of different Samsung SoCs. All of
> them said that writing 1 to a bit clears the corresponding interrupt, but
> none of them contain any note that it must be manually cleared to 0.
What i meant was the clear pending bit will not clear automatically.
When I set the
clear pending bit, it remains set. This is a problem for the next
interrupt cycle.
> In addition the expression
>
> clr & ~clr
>
> makes no sense, because it is equal to 0.
It makes sense, because we are not disturbing the interrupt pending
bit at position 0, which is a trailing clr bit.
>
> If you really need to clear those bits manually (and I don't think so),
> you should replace this expression with 0.
since we are not enabling (was not enabled in previous implementation)
trailing byte interrupt, and not handling the same in handler
we cannot write 0.

>
> Best regards,
> --
> Tomasz Figa
> Samsung Poland R&D Center
> SW Solution Development, Linux Platform
>
