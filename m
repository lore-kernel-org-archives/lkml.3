Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3GaJpC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:45:02 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37535 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3GaJo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:44:59 -0400
Date: Wed, 31 Jul 2013 11:44:34 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Peter Chen <peter.chen@freescale.com>, Fabio Estevam <festevam@gmail.com>,
        alexander.shishkin@linux.intel.com, kernel@pengutronix.de,
        linux-usb@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] chipidea: Use devm_request_irq()
Message-ID: <20130731094434.GC1754@pengutronix.de>
References: <1375232669-27846-1-git-send-email-festevam@gmail.com>
 <1375232669-27846-2-git-send-email-festevam@gmail.com>
 <20130731073306.GZ1754@pengutronix.de>
 <20130731082054.GF8540@nchen-desktop>
 <20130731084645.GB1754@pengutronix.de>
 <20130731090512.GD9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130731090512.GD9858@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Expanded Cc: a bit]

Hello,

On Wed, Jul 31, 2013 at 10:05:12AM +0100, Mark Brown wrote:
> On Wed, Jul 31, 2013 at 10:46:45AM +0200, Uwe Kleine-König wrote:
We're discussing about devm_request_irq and wonder what happens at
remove time when the irq is still active.

> > OK, so the possible problem is that remove is called while the irq is
> > still active. That means you have to assert that all resources the irq
> > handler is using (e.g. ioremap, clk_prepare_enable) are only freed
> > *after* the irq is done. For ioremap that means it must be done using
> > devm_ioremap_resource. For a clock it's not that easy because the irq
> > handler has to assert that a used clk is kept prepared which can only be
> > done using clk_prepare which in turn is not allowed in an irq handler.
> 
> > Hmm. So the only possible fixes are
> > 	- devm* can be told to also care about clk_disable_unprepare
> > 	- after disabling irqs in the remove callback wait for all
> > 	  active irqs to be done. (i.e. call synchronize_irq(irq))
> > 	- don't use devm_request_irq
> 
> I'm not sure that devm_ guarantees any ordering in the cleanups it does
> so I'd not like to rely on the first option either, if there were some
> guarantee of that it'd help.  The nice thing about explicitly freeing
> the IRQ is that you can tell that all this stuff is safe by inspection.
devm_* at least uses list_for_each_entry_reverse
(drivers/base/devres.c:release_nodes()). Without this guarantee devm_
would not make much sense IMHO.

To also manage clks, we'd need something like:

	devm_clk_prepare(&dev, some_clk);

that makes devm_clk_release also call clk_unprepare the right number of
times. Maybe also the same for devm_clk_enable? Does this make sense?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
