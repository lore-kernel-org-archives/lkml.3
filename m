Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab3GaJyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:54:17 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:54120 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3GaJyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:54:15 -0400
Date: Wed, 31 Jul 2013 05:54:11 -0400
From: Tejun Heo <htejun@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@kernel.org>, Peter Chen <peter.chen@freescale.com>,
        Fabio Estevam <festevam@gmail.com>, alexander.shishkin@linux.intel.com,
        kernel@pengutronix.de, linux-usb@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jeff Garzik <jeff@garzik.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] chipidea: Use devm_request_irq()
Message-ID: <20130731095411.GA2810@htj.dyndns.org>
References: <1375232669-27846-1-git-send-email-festevam@gmail.com>
 <1375232669-27846-2-git-send-email-festevam@gmail.com>
 <20130731073306.GZ1754@pengutronix.de>
 <20130731082054.GF8540@nchen-desktop>
 <20130731084645.GB1754@pengutronix.de>
 <20130731090512.GD9858@sirena.org.uk>
 <20130731094434.GC1754@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130731094434.GC1754@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 31, 2013 at 11:44:34AM +0200, Uwe Kleine-König wrote:
> > > OK, so the possible problem is that remove is called while the irq is
> > > still active. That means you have to assert that all resources the irq

If your driver destruction path is running while your irq handler is
still running, it's a crappy / broken driver.  You need a deactivation
step whether you're using devm or not.  IRQs can be shared and the
device should be in a quiesced state before the driver detaches
itself.  Note that you can queue deactivation routine using devm.  For
an example, please take a look at
drivers/ata/libata-core.c::ata_host_start().

> > > handler is using (e.g. ioremap, clk_prepare_enable) are only freed
> > > *after* the irq is done. For ioremap that means it must be done using
> > > devm_ioremap_resource. For a clock it's not that easy because the irq
> > > handler has to assert that a used clk is kept prepared which can only be
> > > done using clk_prepare which in turn is not allowed in an irq handler.
> > 
> > > Hmm. So the only possible fixes are
> > > 	- devm* can be told to also care about clk_disable_unprepare
> > > 	- after disabling irqs in the remove callback wait for all
> > > 	  active irqs to be done. (i.e. call synchronize_irq(irq))
> > > 	- don't use devm_request_irq

Again, the right thing to do is having a proper deactivation step.
This is nothing devm can do automatically.  There's no way for it to
find out that the device is actually quiesced.  Let's say it waits for
the current instance of irq handler to finish.  How would it know that
it won't start again between the flushing of the current instance and
irq deregistration.  Add an explicit deactivation step using
devres_alloc().

> > I'm not sure that devm_ guarantees any ordering in the cleanups it does
> > so I'd not like to rely on the first option either, if there were some
> > guarantee of that it'd help.  The nice thing about explicitly freeing
> > the IRQ is that you can tell that all this stuff is safe by inspection.
> devm_* at least uses list_for_each_entry_reverse
> (drivers/base/devres.c:release_nodes()). Without this guarantee devm_
> would not make much sense IMHO.

devm guarantees that the destruction callbacks are called in the
reverse order of registration.

Thanks.

-- 
tejun
