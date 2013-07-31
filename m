Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab3GaLcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:32:50 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:56781 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab3GaLcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:32:48 -0400
Date: Wed, 31 Jul 2013 07:32:44 -0400
From: Tejun Heo <htejun@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Peter Chen <peter.chen@freescale.com>,
        Fabio Estevam <festevam@gmail.com>, alexander.shishkin@linux.intel.com,
        kernel@pengutronix.de, linux-usb@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jeff Garzik <jeff@garzik.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] chipidea: Use devm_request_irq()
Message-ID: <20130731113244.GI2810@htj.dyndns.org>
References: <1375232669-27846-1-git-send-email-festevam@gmail.com>
 <1375232669-27846-2-git-send-email-festevam@gmail.com>
 <20130731073306.GZ1754@pengutronix.de>
 <20130731082054.GF8540@nchen-desktop>
 <20130731084645.GB1754@pengutronix.de>
 <20130731090512.GD9858@sirena.org.uk>
 <20130731094434.GC1754@pengutronix.de>
 <20130731095411.GA2810@htj.dyndns.org>
 <20130731111853.GJ9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731111853.GJ9858@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 31, 2013 at 12:18:53PM +0100, Mark Brown wrote:
> I'm not sure I understand how this relates the problem.  The main issue
> here is that for the shared IRQ case quiescing the device doesn't make
> any difference since one of the other users of the interrupt could cause
> the interrupt handler to be called regardless of what the hardware is
> doing.  This means that we need to guarantee that anything the interrupt
> handler relies on has not been deallocated before the interrupt handler
> is unregistered.

Yeah, if all resources are allocated using devm - note that you can
hook in non-devm resources using devres_alloc() - all resources which
would be necessary for the interrupt handler would have been allocated
before the irq was allocated, right?  And thus they'll of course
released after the IRQ is freed.  The problem arises when devm and
non-devm releases are mixed as non-devm ones would happen before all
devm ones messing up the release sequencing.

> OK, that's helpful.  It'd be good to document this if it's something
> the API is intending to guarantee, though - devres.txt doesn't mention

Oh, it's definitely guaranteed.  Nothing would work otherwise.

> this and it's not something I'd intuitively expect to be the case.

Oops... I guess I forgot to mention that.  Care to submit a patch?

Thanks.

-- 
tejun
