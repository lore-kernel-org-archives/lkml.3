Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab3GaK3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:29:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53007 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab3GaK3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:29:15 -0400
Date: Wed, 31 Jul 2013 12:28:53 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Peter Chen <peter.chen@freescale.com>,
        Fabio Estevam <festevam@gmail.com>, alexander.shishkin@linux.intel.com,
        kernel@pengutronix.de, linux-usb@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jeff Garzik <jeff@garzik.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] chipidea: Use devm_request_irq()
Message-ID: <20130731102853.GD1754@pengutronix.de>
References: <1375232669-27846-1-git-send-email-festevam@gmail.com>
 <1375232669-27846-2-git-send-email-festevam@gmail.com>
 <20130731073306.GZ1754@pengutronix.de>
 <20130731082054.GF8540@nchen-desktop>
 <20130731084645.GB1754@pengutronix.de>
 <20130731090512.GD9858@sirena.org.uk>
 <20130731094434.GC1754@pengutronix.de>
 <20130731095411.GA2810@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130731095411.GA2810@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 05:54:11AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jul 31, 2013 at 11:44:34AM +0200, Uwe Kleine-König wrote:
> > > > OK, so the possible problem is that remove is called while the irq is
> > > > still active. That means you have to assert that all resources the irq
> 
> If your driver destruction path is running while your irq handler is
> still running, it's a crappy / broken driver.  You need a deactivation
Well, you cannot avoid assuming that the irq is still active when your
driver's remove callback is called. But I agree about crappyness at the
end of the destruction path. The problem is that crap is as easy as:

	probe(..)
	{
		clk = devm_get_clk(...);
		clk_prepare_enable(clk);
		writel(1, base + IRQENABLE);
		devm_request_irq(...);
	}

	remove(..)
	{
		writel(0, base + IRQENABLE);
		clk_disable_unprepare(clk);
	}

and I think there are more and more drivers doing that.

> step whether you're using devm or not.  IRQs can be shared and the
> device should be in a quiesced state before the driver detaches
> itself.  Note that you can queue deactivation routine using devm.  For
> an example, please take a look at
> drivers/ata/libata-core.c::ata_host_start().
> 
> > > > handler is using (e.g. ioremap, clk_prepare_enable) are only freed
> > > > *after* the irq is done. For ioremap that means it must be done using
> > > > devm_ioremap_resource. For a clock it's not that easy because the irq
> > > > handler has to assert that a used clk is kept prepared which can only be
> > > > done using clk_prepare which in turn is not allowed in an irq handler.
> > > 
> > > > Hmm. So the only possible fixes are
> > > > 	- devm* can be told to also care about clk_disable_unprepare
> > > > 	- after disabling irqs in the remove callback wait for all
> > > > 	  active irqs to be done. (i.e. call synchronize_irq(irq))
> > > > 	- don't use devm_request_irq
> 
> Again, the right thing to do is having a proper deactivation step.
> This is nothing devm can do automatically.  There's no way for it to
> find out that the device is actually quiesced.  Let's say it waits for
> the current instance of irq handler to finish.  How would it know that
> it won't start again between the flushing of the current instance and
> irq deregistration.  Add an explicit deactivation step using
> devres_alloc().
> 
> > > I'm not sure that devm_ guarantees any ordering in the cleanups it does
> > > so I'd not like to rely on the first option either, if there were some
> > > guarantee of that it'd help.  The nice thing about explicitly freeing
> > > the IRQ is that you can tell that all this stuff is safe by inspection.
> > devm_* at least uses list_for_each_entry_reverse
> > (drivers/base/devres.c:release_nodes()). Without this guarantee devm_
> > would not make much sense IMHO.
> 
> devm guarantees that the destruction callbacks are called in the
> reverse order of registration.
That's fine.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
