Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaKIW7G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 17:59:06 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:56015 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaKIW7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 17:59:03 -0500
Date: Sun, 9 Nov 2014 23:56:50 +0100
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
Message-ID: <20141109225650.GA27950@gmail.com>
References: <1415525113-25598-1-git-send-email-b.galvani@gmail.com>
 <1415525113-25598-3-git-send-email-b.galvani@gmail.com>
 <20141109101712.GM2722@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141109101712.GM2722@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 10:17:12AM +0000, Mark Brown wrote:
> On Sun, Nov 09, 2014 at 10:25:12AM +0100, Beniamino Galvani wrote:
> 
> > +static int meson_spifc_wait_ready(struct meson_spifc *spifc)
> > +{
> > +	unsigned long deadline = jiffies + msecs_to_jiffies(1000);
> > +	u32 data;
> > +
> > +	do {
> > +		regmap_read(spifc->regmap, REG_SLAVE, &data);
> > +		if (data & SLAVE_TRST_DONE)
> > +			return 0;
> > +		cond_resched();
> > +	} while (time_before(jiffies, deadline));
> 
> This will busy wait for up to a second, that seems like a long time to
> busy wait.  We also appear to be using this for the entire duration of
> the transfer which could be a fairly long time even during normal
> operation if doing a large transfer such as a firmware download, or if
> the bus speed is low.

Yes, probably the timeout value is too long since the maximum length
of a basic transfer is 64 bytes. Can you suggest a reasonable value?

> 
> > +	meson_spifc_setup_speed(spifc, xfer->speed_hz ? xfer->speed_hz :
> > +				spi->max_speed_hz);
> > +
> 
> Please avoid the ternery operator, it does nothing for legibility and in
> this case it's not needed as the core will always ensure that there is a
> per-transfer speed set.

Ok.

> > +	while (done < xfer->len && !ret) {
> > +		len = min_t(int, xfer->len - done, SPIFC_BUFFER_SIZE);
> > +		ret = meson_spifc_txrx(spifc, xfer, done, len,
> > +				       last_xfer, done + len >= xfer->len);
> > +		done += len;
> > +	}
> 
> I noticed that the handling of /CS was done in the spifc_txrx() function
> - will this do the right thing if the transfer needs to be split for the
> buffer size?

It should. When the transfer gets split, CS is kept active for all the
chunks and the value of CS after that depends on the value of
cs_change.

> 
> > +	if (!ret && xfer->delay_usecs)
> > +		udelay(xfer->delay_usecs);
> 
> The core will do this for you if you implement this as transfer_one().

Please correct me if I'm wrong, but I think that transfer_one() can't
be used in this case. The hardware doesn't support direct manipulation
of CS and allows only to specify if CS must be kept active after the
current transfer. So I need to know for each transfer if it's the last
and this can be achieved only implementing transfer_one_message().

> 
> > +static int meson_spifc_transfer_one_message(struct spi_master *master,
> > +					    struct spi_message *msg)
> 
> This appears to do nothing that the core won't do - just implement
> transfer_one() and remove this.
> 
> > +	spifc = spi_master_get_devdata(master);
> > +	memset(spifc, 0, sizeof(struct meson_spifc));
> 
> There should be no need for this memset.
> 
> > +	spifc_regmap_config.max_register = resource_size(res) - 4;
> > +	spifc_regmap_config.name = "amlogic,meson-spifc";
> 
> If you're dynamically initializing the structure you need to work with a
> copy of it rather than directly since there may be multiple instances.
> I'm not seeing a reason to override the regmap name here, this is only
> really intended for devices with multiple register maps.
> 
> > +	ret = clk_prepare_enable(spifc->clk);
> > +	if (ret) {
> > +		dev_err(spifc->dev, "can't prepare clock\n");
> > +		goto out_err;
> > +	}
> 
> You should really implement runtime PM operations to disable this when
> not in use and use auto_runtime_pm to make sure this happens.
> 
> > +	master->bus_num = pdev->id;
> 
> Leave this blank for DT only devices (and for non-DT devices this won't
> work if you get two different buses).

Ok, will do. Thanks for the review.

Beniamino

