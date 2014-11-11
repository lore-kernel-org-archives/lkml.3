Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaKKTyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:54:53 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39750 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaKKTyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:54:49 -0500
Date: Tue, 11 Nov 2014 20:52:34 +0100
From: Beniamino Galvani <b.galvani@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH 2/3] spi: meson: Add support for Amlogic Meson SPIFC
Message-ID: <20141111195234.GA15145@gmail.com>
References: <1415525113-25598-1-git-send-email-b.galvani@gmail.com>
 <1415525113-25598-3-git-send-email-b.galvani@gmail.com>
 <20141109101712.GM2722@sirena.org.uk>
 <20141109225650.GA27950@gmail.com>
 <20141110151140.GA3815@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110151140.GA3815@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 03:11:40PM +0000, Mark Brown wrote:
> On Sun, Nov 09, 2014 at 11:56:50PM +0100, Beniamino Galvani wrote:
> > On Sun, Nov 09, 2014 at 10:17:12AM +0000, Mark Brown wrote:
>
> > > I noticed that the handling of /CS was done in the spifc_txrx() function
> > > - will this do the right thing if the transfer needs to be split for the
> > > buffer size?
> 
> > It should. When the transfer gets split, CS is kept active for all the
> > chunks and the value of CS after that depends on the value of
> > cs_change.
> 
> Can you be more specific about how that works?  I'm just not seeing the
> code that handles this.

It's this:

static int meson_spifc_txrx(struct meson_spifc *spifc,
                            struct spi_transfer *xfer,
                            int offset, int len, bool last_xfer,
                            bool last_chunk)
{
	bool keep_cs = true;

	[...]

        if (last_chunk) {
                if (last_xfer)
                        keep_cs = xfer->cs_change;
                else
                        keep_cs = !xfer->cs_change;
        }

        regmap_update_bits(spifc->regmap, REG_USER4, USER4_CS_ACT,
                           keep_cs ? USER4_CS_ACT : 0);

	/* start transfer */
	[...]
}

The USER4_CS_ACT bit specifies if CS must be kept active after the
transfer.

> > > > +	if (!ret && xfer->delay_usecs)
> > > > +		udelay(xfer->delay_usecs);
> 
> > > The core will do this for you if you implement this as transfer_one().
> 
> > Please correct me if I'm wrong, but I think that transfer_one() can't
> > be used in this case. The hardware doesn't support direct manipulation
> > of CS and allows only to specify if CS must be kept active after the
> > current transfer. So I need to know for each transfer if it's the last
> > and this can be achieved only implementing transfer_one_message().
> 
> This is already in a function that's operating at the transfer_one()
> level, the function is even called transfer_one() and besides it's
> clearly not something specific to this hardware so should be factored
> out into the core instead of open coded.

A way to simplify this at core level could be to add a 'last' flag to
the spi_transfer structure and populate it before calling
transfer_one_message(); in this way, drivers that need to know the
position of the transfer in the message in order to properly handle CS
can use the generic version of transfer_one_message() instead of
reimplementing it. It seems that other existing drivers probably can
benefit from this.

Beniamino
