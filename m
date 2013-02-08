Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946109Ab3BHIdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:33:12 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:51262 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946065Ab3BHIdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:33:10 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Girish KS <girishks2000@gmail.com>, Tomasz Figa <t.figa@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] spi: s3c64xx: modified error interrupt handling and init
Date: Fri, 08 Feb 2013 09:33:08 +0100
Message-ID: <2723874.KAatFKgahz@flatron>
User-Agent: KMail/4.9.5 (Linux/3.7.4-gentoo; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKrE-KfyGCi_+FozSpGTy0A0VJP=Jq-1SHmvKJU02iJKWHcvLQ@mail.gmail.com>
References: <1360105784-12282-1-git-send-email-ks.giri@samsung.com> <1585017.derjdP1mHL@amdc1227> <CAKrE-KfyGCi_+FozSpGTy0A0VJP=Jq-1SHmvKJU02iJKWHcvLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 of February 2013 09:46:58 Girish KS wrote:
> On Thu, Feb 7, 2013 at 3:09 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> > Hi Girish,
> > 
> > On Wednesday 06 of February 2013 12:12:29 Girish KS wrote:
> >> On Wed, Feb 6, 2013 at 2:26 AM, Grant Likely
> >> <grant.likely@secretlab.ca>> 
> > wrote:
> >> > On Tue,  5 Feb 2013 15:09:41 -0800, Girish K S
> > 
> > <girishks2000@gmail.com> wrote:
> >> >> The status of the interrupt is available in the status register,
> >> >> so reading the clear pending register and writing back the same
> >> >> value will not actually clear the pending interrupts. This patch
> >> >> modifies the interrupt handler to read the status register and
> >> >> clear the corresponding pending bit in the clear pending register.
> >> >> 
> >> >> Modified the hwInit function to clear all the pending interrupts.
> >> >> 
> >> >> Signed-off-by: Girish K S <ks.giri@samsung.com>
> >> >> ---
> >> >> 
> >> >>  drivers/spi/spi-s3c64xx.c |   41
> >> >>  +++++++++++++++++++++++++---------------- 1 file changed, 25
> >> >>  insertions(+), 16 deletions(-)
> >> >> 
> >> >> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
> >> >> index ad93231..b770f88 100644
> >> >> --- a/drivers/spi/spi-s3c64xx.c
> >> >> +++ b/drivers/spi/spi-s3c64xx.c
> >> >> @@ -997,25 +997,30 @@ static irqreturn_t s3c64xx_spi_irq(int irq,
> >> >> void *data)>>
> >> >> 
> >> >>  {
> >> >>  
> >> >>       struct s3c64xx_spi_driver_data *sdd = data;
> >> >>       struct spi_master *spi = sdd->master;
> >> >> 
> >> >> -     unsigned int val;
> >> >> +     unsigned int val, clr = 0;
> >> >> 
> >> >> -     val = readl(sdd->regs + S3C64XX_SPI_PENDING_CLR);
> >> >> +     val = readl(sdd->regs + S3C64XX_SPI_STATUS);
> >> >> 
> >> >> -     val &= S3C64XX_SPI_PND_RX_OVERRUN_CLR |
> >> >> -             S3C64XX_SPI_PND_RX_UNDERRUN_CLR |
> >> >> -             S3C64XX_SPI_PND_TX_OVERRUN_CLR |
> >> >> -             S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
> >> >> -
> >> >> -     writel(val, sdd->regs + S3C64XX_SPI_PENDING_CLR);
> >> >> -
> >> >> -     if (val & S3C64XX_SPI_PND_RX_OVERRUN_CLR)
> >> >> +     if (val & S3C64XX_SPI_ST_RX_OVERRUN_ERR) {
> >> >> +             clr = S3C64XX_SPI_PND_RX_OVERRUN_CLR;
> >> >> 
> >> >>               dev_err(&spi->dev, "RX overrun\n");
> >> >> 
> >> >> -     if (val & S3C64XX_SPI_PND_RX_UNDERRUN_CLR)
> >> >> +     }
> >> >> +     if (val & S3C64XX_SPI_ST_RX_UNDERRUN_ERR) {
> >> >> +             clr |= S3C64XX_SPI_PND_RX_UNDERRUN_CLR;
> >> >> 
> >> >>               dev_err(&spi->dev, "RX underrun\n");
> >> >> 
> >> >> -     if (val & S3C64XX_SPI_PND_TX_OVERRUN_CLR)
> >> >> +     }
> >> >> +     if (val & S3C64XX_SPI_ST_TX_OVERRUN_ERR) {
> >> >> +             clr |= S3C64XX_SPI_PND_TX_OVERRUN_CLR;
> >> >> 
> >> >>               dev_err(&spi->dev, "TX overrun\n");
> >> >> 
> >> >> -     if (val & S3C64XX_SPI_PND_TX_UNDERRUN_CLR)
> >> >> +     }
> >> >> +     if (val & S3C64XX_SPI_ST_TX_UNDERRUN_ERR) {
> >> >> +             clr |= S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
> >> >> 
> >> >>               dev_err(&spi->dev, "TX underrun\n");
> >> >> 
> >> >> +     }
> >> >> +
> >> >> +     /* Clear the pending irq by setting and then clearing it */
> >> >> +     writel(clr, sdd->regs + S3C64XX_SPI_PENDING_CLR);
> >> >> +     writel(clr & ~clr, sdd->regs + S3C64XX_SPI_PENDING_CLR);
> >> > 
> >> > Wait, what?  clr & ~clr == 0   Always.  What are you actually
> >> > trying
> >> > to do here?
> >> 
> >> The user manual says, wirting 1 to the pending clear register clears
> >> the interrupt (its not auto clear to 0). so i need to explicitly
> >> reset
> >> those bits thats what the 2nd write does
> > 
> > I have looked through user's manuals of different Samsung SoCs. All of
> > them said that writing 1 to a bit clears the corresponding interrupt,
> > but none of them contain any note that it must be manually cleared to
> > 0.
> What i meant was the clear pending bit will not clear automatically.
> When I set the
> clear pending bit, it remains set. This is a problem for the next
> interrupt cycle.

How did you check that it does not clear automatically?

> > In addition the expression
> > 
> > clr & ~clr
> > 
> > makes no sense, because it is equal to 0.
> 
> It makes sense, because we are not disturbing the interrupt pending
> bit at position 0, which is a trailing clr bit.

You either seem to misunderstand the problem I'm mentioning or not 
understanding it at all.

If you take a variable named clr, no matter what value it is set to, and 
you AND it with bitwise negation of the same variable, you will get 0.

See on this example:

Bits:     7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
         -------------------------------
Values:   1 | 1 | 0 | 0 | 1 | 0 | 0 | 1
         -------------------------------
Negation: 0 | 0 | 1 | 1 | 0 | 1 | 1 | 0
         -------------------------------
AND:      0 | 0 | 0 | 0 | 0 | 0 | 0 | 0

Now, can you see that (clr & ~clr) is the same as (0)?

Best regards,
Tomasz

