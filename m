Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab3BGLJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:09:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45583 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab3BGLJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:09:17 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-f8-51138b5c952d
From: Tomasz Figa <t.figa@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Girish KS <girishks2000@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] spi: s3c64xx: modified error interrupt handling and
 init
Date: Thu, 07 Feb 2013 12:09:11 +0100
Message-id: <1585017.derjdP1mHL@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.9.5 (Linux/3.7.4-gentoo; KDE/4.9.5; x86_64; ; )
In-reply-to: <CAKrE-KdX+Nxk0X4xdz6Dx3WVtOpV+ms+gPB-Dq-MwZwetyZ5Nw@mail.gmail.com>
References: <1360105784-12282-1-git-send-email-ks.giri@samsung.com>
 <20130206102628.5E7413E1510@localhost>
 <CAKrE-KdX+Nxk0X4xdz6Dx3WVtOpV+ms+gPB-Dq-MwZwetyZ5Nw@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jQd2YbuFAg38v+S0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldGz9b77AUT5Somb9ZpYDws1sXIySEhYCJx48pRFghbTOLCvfVs
	ILaQwHRGibtzzbsYuYDspUwSb2bvBUuwCahJfG54BGaLCGhITOl6zA5SxCwwm1Hi3tm/7CAJ
	YYFgie2/ZjOD2CwCqhJT95wFi/MKaEpM+3yZFcTmF1CXeLftKROILSrgLLGw9zXYUE6g3oPv
	W1khNm9mlNj64gMrRLOgxI/J98BOZRaQl9i3fyorhK0lsX7ncaYJjIKzkJTNQlI2C0nZAkbm
	VYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBoflMagfjygaLQ4wCHIxKPLw3lgoFCrEmlhVX
	5h5ilOBgVhLhPVkjHCjEm5JYWZValB9fVJqTWnyIUZqDRUmcl/HUkwAhgfTEktTs1NSC1CKY
	LBMHp1QD4+wb+z+IHM3Uf9k464W20szkL38Ek3dyn4x8etW5WmQp+xIliUyzFnWnJ6UXVxsZ
	ca7d0XTvw6P4CqOGSh/vVReTXsyszm3bMG3SGYk5euXq50/3G8ueXnnN7ciKEzW19ZpXLl/6
	o3o8+pZy0m+/96F5PknmLv9Dzb71u2R6/joe3BexKdezUYmlOCPRUIu5qDgRAPhzfH5JAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Girish,

On Wednesday 06 of February 2013 12:12:29 Girish KS wrote:
> On Wed, Feb 6, 2013 at 2:26 AM, Grant Likely <grant.likely@secretlab.ca> 
wrote:
> > On Tue,  5 Feb 2013 15:09:41 -0800, Girish K S 
<girishks2000@gmail.com> wrote:
> >> The status of the interrupt is available in the status register,
> >> so reading the clear pending register and writing back the same
> >> value will not actually clear the pending interrupts. This patch
> >> modifies the interrupt handler to read the status register and
> >> clear the corresponding pending bit in the clear pending register.
> >> 
> >> Modified the hwInit function to clear all the pending interrupts.
> >> 
> >> Signed-off-by: Girish K S <ks.giri@samsung.com>
> >> ---
> >> 
> >>  drivers/spi/spi-s3c64xx.c |   41
> >>  +++++++++++++++++++++++++---------------- 1 file changed, 25
> >>  insertions(+), 16 deletions(-)
> >> 
> >> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
> >> index ad93231..b770f88 100644
> >> --- a/drivers/spi/spi-s3c64xx.c
> >> +++ b/drivers/spi/spi-s3c64xx.c
> >> @@ -997,25 +997,30 @@ static irqreturn_t s3c64xx_spi_irq(int irq,
> >> void *data)>> 
> >>  {
> >>  
> >>       struct s3c64xx_spi_driver_data *sdd = data;
> >>       struct spi_master *spi = sdd->master;
> >> 
> >> -     unsigned int val;
> >> +     unsigned int val, clr = 0;
> >> 
> >> -     val = readl(sdd->regs + S3C64XX_SPI_PENDING_CLR);
> >> +     val = readl(sdd->regs + S3C64XX_SPI_STATUS);
> >> 
> >> -     val &= S3C64XX_SPI_PND_RX_OVERRUN_CLR |
> >> -             S3C64XX_SPI_PND_RX_UNDERRUN_CLR |
> >> -             S3C64XX_SPI_PND_TX_OVERRUN_CLR |
> >> -             S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
> >> -
> >> -     writel(val, sdd->regs + S3C64XX_SPI_PENDING_CLR);
> >> -
> >> -     if (val & S3C64XX_SPI_PND_RX_OVERRUN_CLR)
> >> +     if (val & S3C64XX_SPI_ST_RX_OVERRUN_ERR) {
> >> +             clr = S3C64XX_SPI_PND_RX_OVERRUN_CLR;
> >> 
> >>               dev_err(&spi->dev, "RX overrun\n");
> >> 
> >> -     if (val & S3C64XX_SPI_PND_RX_UNDERRUN_CLR)
> >> +     }
> >> +     if (val & S3C64XX_SPI_ST_RX_UNDERRUN_ERR) {
> >> +             clr |= S3C64XX_SPI_PND_RX_UNDERRUN_CLR;
> >> 
> >>               dev_err(&spi->dev, "RX underrun\n");
> >> 
> >> -     if (val & S3C64XX_SPI_PND_TX_OVERRUN_CLR)
> >> +     }
> >> +     if (val & S3C64XX_SPI_ST_TX_OVERRUN_ERR) {
> >> +             clr |= S3C64XX_SPI_PND_TX_OVERRUN_CLR;
> >> 
> >>               dev_err(&spi->dev, "TX overrun\n");
> >> 
> >> -     if (val & S3C64XX_SPI_PND_TX_UNDERRUN_CLR)
> >> +     }
> >> +     if (val & S3C64XX_SPI_ST_TX_UNDERRUN_ERR) {
> >> +             clr |= S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
> >> 
> >>               dev_err(&spi->dev, "TX underrun\n");
> >> 
> >> +     }
> >> +
> >> +     /* Clear the pending irq by setting and then clearing it */
> >> +     writel(clr, sdd->regs + S3C64XX_SPI_PENDING_CLR);
> >> +     writel(clr & ~clr, sdd->regs + S3C64XX_SPI_PENDING_CLR);
> > 
> > Wait, what?  clr & ~clr == 0   Always.  What are you actually trying
> > to do here?
> The user manual says, wirting 1 to the pending clear register clears
> the interrupt (its not auto clear to 0). so i need to explicitly reset
> those bits thats what the 2nd write does

I have looked through user's manuals of different Samsung SoCs. All of 
them said that writing 1 to a bit clears the corresponding interrupt, but 
none of them contain any note that it must be manually cleared to 0.

In addition the expression

clr & ~clr

makes no sense, because it is equal to 0.

If you really need to clear those bits manually (and I don't think so), 
you should replace this expression with 0.

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Linux Platform

