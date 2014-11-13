Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbaKMPHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:07:52 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:9797 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbaKMPHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:07:48 -0500
From: James Hartley <James.Hartley@imgtec.com>
To: Mark Brown <broonie@kernel.org>, Andrew Bresticker <abrestic@chromium.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        James Hogan <James.Hogan@imgtec.com>
Subject: RE: [PATCH 2/2] spi: Add driver for IMG SPFI controller
Thread-Topic: [PATCH 2/2] spi: Add driver for IMG SPFI controller
Thread-Index: AQHP/sDwFR74YQkS/ku/vxSlX++r9pxdjKQAgAANNoCAAAMzAIABBDqQ
Date: Thu, 13 Nov 2014 15:07:44 +0000
Message-ID: <72BC0C8BD7BB6F45988A99382E5FBAE54433DF40@hhmail02.hh.imgtec.org>
References: <1415828274-24727-1-git-send-email-abrestic@chromium.org>
 <1415828274-24727-3-git-send-email-abrestic@chromium.org>
 <20141112220740.GR3815@sirena.org.uk>
 <CAL1qeaH1rMcy37vcoHZ9xsmYs5iHz3Pp0GrC7agLmQ4Y7==iTw@mail.gmail.com>
 <20141112230624.GA3815@sirena.org.uk>
In-Reply-To: <20141112230624.GA3815@sirena.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.167.65]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: 12 November 2014 23:06
> To: Andrew Bresticker
> Cc: James Hartley; Rob Herring; Pawel Moll; Mark Rutland; Ian Campbell;
> Kumar Gala; Grant Likely; Ezequiel Garcia; devicetree@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-spi@vger.kernel.org
> Subject: Re: [PATCH 2/2] spi: Add driver for IMG SPFI controller
> 
> On Wed, Nov 12, 2014 at 02:54:57PM -0800, Andrew Bresticker wrote:
> > On Wed, Nov 12, 2014 at 2:07 PM, Mark Brown <broonie@kernel.org>
> wrote:
> 
> > >>  drivers/spi/spi-img.c | 703
> > >> ++++++++++++++++++++++++++++++++++++++++++++++++++
> 
> > > How about spi-img-spfi?  That way if someone makes another SPI
> > > controller (say a more generic one, this one seems flash
> > > specialized) there won't be a collision.
> 
> > Despite the name, I believe this controller is used for generic SPI
> > stuff as well.  I'm not sure if there is a separate one which is more
> > generic (James?).

There is another generic img spi hardware block which is not register 
compatible and doesn't have the flash interface which is also in existing 
SoC's.  There is a separate img-spi driver for that which has not yet been 
mainlined. I think spi-img-spfi would be ok for this driver. There is also 
another sfc (Serial Flash Controller), block in the pipeline, so that could
then be called spi-img-sfc.

> 
> It would still be better to use a name less impressively generic - this is an
> entire company, not even a product line.
> 
> > >> +             cpu_relax();
> 
> > > Seems random - we already relax in the data transfer?
> 
> > We don't relax in the transfers - would that be a better place to put
> > it?  I thought it was better here since we reach this point once the
> > TX FIFO has filled or RX FIFO has emptied.
> 
> Oh, that was the FIFO drain I was thinking of.  I guess here is fine.
> 
> > >> +     if (tx_buf)
> > >> +             spfi_flush_tx_fifo(spfi);
> > >> +     spfi_disable(spfi);
> 
> > > What does the enable and disable actually do?  Should this be
> > > runtime PM?
> 
> > It starts/stops the transfer.  The control registers (bit clock,
> > transfer mode, etc.) must be programmed before the enable bit is set
> > and the bit does not clear itself upon completion of the transfer.  I
> > don't think it makes sense to have this be part of runtime PM.
> 
> Perhaps these functions need to be called start() and stop() then - the
> names sound like they gate the IP?
> 
> > > This will unconditionally claim to have handled an interrupt even if
> > > it didn't get any interrupt status it has ever heard of.  At the
> > > very least it should log unknown interrupts, ideally return IRQ_NONE
> > > though since it seems to be a clear on read interrupt that's a bit
> misleading.
> 
> > There's a clear register actually (see the writel() above), but yes,
> > an error and returning IRQ_NONE sound appropriate in the event of an
> > unexpected interrupt.
> 
> Don't add the error print - the interrupt core has diagnostics already and it
> won't be nice if the interrupt ends up shared.  My recommendation was
> intended as an either/or.

James.
