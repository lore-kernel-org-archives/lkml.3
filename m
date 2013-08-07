Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab3HGQQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:16:08 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16047 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932145Ab3HGQQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:16:04 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ffYHf2Pib4/wr01BsB+4H
Date: Wed, 7 Aug 2013 09:15:58 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        =?utf-8?Q?Beno=C3=AEt?= Coussno <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] arm: omap: Proper cleanups for omap_device
Message-ID: <20130807161557.GO7656@atomide.com>
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com>
 <1375775624-12250-6-git-send-email-panto@antoniou-consulting.com>
 <20130806093356.GA27889@kroah.com>
 <8C31ED90-E9EF-4264-858A-17CC2536B552@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8C31ED90-E9EF-4264-858A-17CC2536B552@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [130806 02:44]:
> On Aug 6, 2013, at 12:33 PM, Greg Kroah-Hartman wrote:
> > On Tue, Aug 06, 2013 at 10:53:44AM +0300, Pantelis Antoniou wrote:
> >> +
> >> static int _omap_device_notifier_call(struct notifier_block *nb,
> >> 				      unsigned long event, void *dev)
> >> {
> >> @@ -185,9 +211,13 @@ static int _omap_device_notifier_call(struct notifier_block *nb,
> >> 	struct omap_device *od;
> >> 
> >> 	switch (event) {
> >> -	case BUS_NOTIFY_DEL_DEVICE:
> >> +	case BUS_NOTIFY_UNBOUND_DRIVER:
> >> +		/* NOTIFY_DEL_DEVICE is not the right call...
> >> +		 * we use a callback here, to make sure no-one is going to
> >> +		 * try to use the omap_device data after they're deleted
> >> +		 */
> >> 		if (pdev->archdata.od)
> >> -			omap_device_delete(pdev->archdata.od);
> >> +			device_schedule_callback(dev, _omap_device_cleanup);
> > 
> > Really?  This is one sign that you are totally using the driver core
> > incorrectly.  You shouldn't have to rely on notifier callbacks to handle
> > device removals, your bus code should do that for you directly.
> > 
> > I don't like this at all, sorry.
> > 
> 
> Don't shoot the messenger please...

As you're inititalizing capebus with DT, let's figure out what if
anything you actually need from omap_device. I'd much rather remove
dependencies than add more.

If you need omap_device for the clocks, there are patches pending to
make them DT only for omaps. And we already have DT based solution for
pins, regulators and DMA.

So what else remains? The pieces needed for runtime PM?
 
> This is all about fixing a crash without messing too many things.

It seems this fix is only needed for supporting out-of-tree code?
These features with omap_device we may not even want to support in
the mainline tree as is being discussed..

Regards,

Tony

