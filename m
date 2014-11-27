Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaK0Kak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:30:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:4593 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbaK0Kaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:30:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,468,1413270000"; 
   d="scan'208";a="614921540"
Date: Thu, 27 Nov 2014 12:30:35 +0200
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/2] spi: add support for DLN-2 USB-SPI adapter
Message-ID: <20141127103034.GP2583@lpalcu-linux>
References: <1416312599-5176-2-git-send-email-laurentiu.palcu@intel.com>
 <1416996549-29328-1-git-send-email-laurentiu.palcu@intel.com>
 <20141126182521.GP7712@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126182521.GP7712@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 06:25:21PM +0000, Mark Brown wrote:
> On Wed, Nov 26, 2014 at 12:09:09PM +0200, Laurentiu Palcu wrote:
> 
> > +static int dln2_spi_transfer_one_message(struct spi_master *master,
> > +					 struct spi_message *msg)
> > +{
> > +	struct dln2_spi *dln2 = spi_master_get_devdata(master);
> > +	struct spi_device *spi = msg->spi;
> > +	struct spi_transfer *xfer;
> > +	int status;
> > +
> > +	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
> > +		u8 attr = 0;
> > +
> > +		status = dln2_spi_transfer_setup(dln2, xfer->speed_hz,
> > +						 xfer->bits_per_word,
> > +						 spi->mode);
> > +		if (status < 0) {
> > +			dev_err(&dln2->pdev->dev, "Cannot setup transfer\n");
> > +			break;
> > +		}
> > +
> > +		if (!xfer->cs_change &&
> > +		    !list_is_last(&xfer->transfer_list, &msg->transfers))
> > +			attr = xfer->cs_change ? 0 : DLN2_SPI_ATTR_LEAVE_SS_LOW;
> > +
> > +		status = dln2_spi_rdwr(dln2, xfer->tx_buf, xfer->rx_buf,
> > +				       xfer->len, attr);
> 
> We recently added a spi_transfer_is_last() operation which should allow
> you to move this to using transfer_one() which is a bit nicer.
Ok, sounds good!

> 
> > +	/* enable SPI module, we're good to go */
> > +	ret = dln2_spi_enable(dln2, true);
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev, "Failed to enable SPI module\n");
> > +		goto exit_free_master;
> > +	}
> 
> It would be nice to have runtime PM operations which keep the device
> disabled when idle, presumably that'd save a bit of power and it's
> generally better practice.
I'll add runtime PM and send a v7.

laurentiu
