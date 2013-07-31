Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab3GaKlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:41:31 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:63321 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab3GaKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:41:29 -0400
Date: Wed, 31 Jul 2013 06:41:25 -0400
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
Message-ID: <20130731104125.GF2810@htj.dyndns.org>
References: <1375232669-27846-1-git-send-email-festevam@gmail.com>
 <1375232669-27846-2-git-send-email-festevam@gmail.com>
 <20130731073306.GZ1754@pengutronix.de>
 <20130731082054.GF8540@nchen-desktop>
 <20130731084645.GB1754@pengutronix.de>
 <20130731090512.GD9858@sirena.org.uk>
 <20130731094434.GC1754@pengutronix.de>
 <20130731095411.GA2810@htj.dyndns.org>
 <20130731102853.GD1754@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130731102853.GD1754@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 12:28:53PM +0200, Uwe Kleine-König wrote:
> Well, you cannot avoid assuming that the irq is still active when your
> driver's remove callback is called. But I agree about crappyness at the
> end of the destruction path. The problem is that crap is as easy as:
> 
> 	probe(..)
> 	{
> 		clk = devm_get_clk(...);
> 		clk_prepare_enable(clk);
> 		writel(1, base + IRQENABLE);
> 		devm_request_irq(...);
> 	}
> 
> 	remove(..)
> 	{
> 		writel(0, base + IRQENABLE);
> 		clk_disable_unprepare(clk);
> 	}
> 
> and I think there are more and more drivers doing that.

Oh, so, the problem is that the driver is mixing devm and non-devm
resource management and ending up messing the order of shutdown?
Well, the obvious solution is using devm for clk too.  devm does
provide constructs to build custom destruction sequence so that such
calls can be mixed but it's a bit of hassle and mostly meant for
driver midlayers (libata, firewire, usb and so on) so that they can
provide nicely wrapped init/exit helpers for low level drivers.

In general, partial devm conversion can easily lead to subtle shutdown
order problems and it's best to go all the way.

Thanks.

-- 
tejun
