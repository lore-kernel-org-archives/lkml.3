Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3LCMNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:13:00 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43882 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab3LCMM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:12:58 -0500
Date: Tue, 3 Dec 2013 12:12:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Florian Meier <florian.meier@koalo.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        devicetree <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>
Subject: Re: [PATCHv8] dmaengine: Add support for BCM2835
Message-ID: <20131203121222.GS16735@n2100.arm.linux.org.uk>
References: <529CDBA8.6070107@koalo.de> <1386072258.1871.44.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386072258.1871.44.camel@smile>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 02:04:18PM +0200, Andy Shevchenko wrote:
> On Mon, 2013-12-02 at 20:12 +0100, Florian Meier wrote:
> > +static void bcm2835_dma_free(struct bcm2835_dmadev *od)
> > +{
> > +	while (!list_empty(&od->ddev.channels)) {
> > +		struct bcm2835_chan *c = list_first_entry(&od->ddev.channels,
> > +			struct bcm2835_chan, vc.chan.device_node);
> > +
> 
> list_for_each_entry_safe() suits well here.
> 
> > +		list_del(&c->vc.chan.device_node);
> > +		tasklet_kill(&c->vc.task);
> > +	}

For such a loop, where we're deleting all entries in a list,
list_for_each_entry_safe() is a little heavier than necessary.  This
is how the code would look:

static void bcm2835_dma_free(struct bcm2835_dmadev *od)
{
	struct bcm2835_chan *c, *next;

	list_for_each_entry_safe(c, next, &od->ddev.channels,
				 vc.chan.device_node) {
		list_del(&c->vc.chan.device_node);
		tasklet_kill(&c->vc.task);
	}

I see very little gain in this approach.
