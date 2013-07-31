Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734Ab3GaOPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:15:19 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:61951 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3GaOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:15:17 -0400
Date: Wed, 31 Jul 2013 10:15:12 -0400
From: Tejun Heo <htejun@gmail.com>
To: Peter Chen <hzpeterchen@gmail.com>
Cc: Mark Brown <broonie@kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Peter Chen <peter.chen@freescale.com>,
        Fabio Estevam <festevam@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        kernel@pengutronix.de,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jeff Garzik <jeff@garzik.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] chipidea: Use devm_request_irq()
Message-ID: <20130731141512.GU2810@htj.dyndns.org>
References: <20130731084645.GB1754@pengutronix.de>
 <20130731090512.GD9858@sirena.org.uk>
 <20130731094434.GC1754@pengutronix.de>
 <20130731095411.GA2810@htj.dyndns.org>
 <20130731111853.GJ9858@sirena.org.uk>
 <20130731113244.GI2810@htj.dyndns.org>
 <20130731115027.GN9858@sirena.org.uk>
 <20130731115527.GR2810@htj.dyndns.org>
 <20130731132708.GQ9858@sirena.org.uk>
 <CAL411-qQm9vgDHswEM6PEvFKAaqd=e3qm-zViUbNztv0tJYa8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL411-qQm9vgDHswEM6PEvFKAaqd=e3qm-zViUbNztv0tJYa8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

On Wed, Jul 31, 2013 at 09:55:26PM +0800, Peter Chen wrote:
> I think the main point is we should allocate managed resource which is used
> at interrupt handler before devm_request_irq, and all resources used
> at interrupt
> handler should be managed.
> 
> If we use non-managed resource at interrupt handler, but using managed interrupt
> handler, things still will go wrong if there is an odd (unexpected)
> interrupt after
> we finish deactivation at removal.

In general, applying devm partially isn't a good idea.  It's very easy
to get into trouble thanks to release order dependency which isn't
immediately noticeable and there have been actual bugs caused by that.
The strategies which seem to work are either

* Convert everything over to devm by wrapping deactivation in a devres
  callback too.  As long as your init sequence is sane (ie. irq
  shouldn't be request before things used by irq are ready).

* Allocate all resources using devres but shut down the execution
  engine in the remove_one().  Again, as all releases are controlled
  by devres, you won't have to worry about messing up the release
  sequencing.

Thanks.

-- 
tejun
