Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab3KYTuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:50:12 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36159 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab3KYTuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:50:08 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/1hjMMimnFcak7ckV7hLdZ
Date: Mon, 25 Nov 2013 11:50:05 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20131125195004.GS10023@atomide.com>
References: <20131123004334.GJ10023@atomide.com>
 <20131124213651.59750C402C3@trevor.secretlab.ca>
 <20131125092549.GD22043@ulmo.nvidia.com>
 <20131125094954.GF22043@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125094954.GF22043@ulmo.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thierry Reding <thierry.reding@gmail.com> [131125 01:51]:
> On Mon, Nov 25, 2013 at 10:25:50AM +0100, Thierry Reding wrote:
> > On Sun, Nov 24, 2013 at 09:36:51PM +0000, Grant Likely wrote:
> > > 
> > > I actually like the idea of completely allocating the resource structure
> > > but leaving some entries empty. However, I agree with rmk that putting
> > > garbage into a resource structure is a bad idea. What about changing the
> > > value of flags to 0 or some other value to be obviously an empty
> > > property and give the follow up parsing some context about which ones it
> > > needs to attempt to recalculate?
> > 
> > When I worked on this a while back I came to the same conclusion. It's
> > nice to allocate all the resources at once, because the number of them
> > doesn't change, only their actually values.
> 
> I should maybe add: one issue that was raised during review of my
> initial patch series was that we'll also need to cope with situations
> like the following:
> 
> 	1) device's interrupt parent is probed (assigned IRQ base X)
> 	2) device is probed (interrupt parent there, therefore gets
> 	   assigned IRQ (X + z)
> 	3) device in removed
> 	4) device's interrupt parent is removed
> 	5) device is probed (deferred because interrupt parent isn't
> 	   there)
> 	6) device's interrupt parent is probed (assigned IRQ base Y)
> 	7) device is probed, gets assigned IRQ (Y + z)
> 
> So not only do we have to track which resources are interrupt resources,
> but we also need to have them reassigned everytime the device is probed,
> therefore interrupt mappings need to be properly disposed and the values
> invalidated when probing is deferred or the device removed.
> 
> Having a dynamic list of properties all of a sudden doesn't sound like
> such a bad idea after all. It makes handling this kind of situation
> rather trivial, especially per-type lists. Those lists will be empty at
> first and populated during the first probe. When probing fails or when a
> device is unloaded, we dispose the mappings and empty the lists, so that
> subsequent probes will start from scratch. It certainly sounds like a
> bit of a waste of CPU cycles, but on the other hand it makes the code
> much simpler.

Looks like we cannot yet use devm_allocate, but that seems like a nice
solution in the long run. I just posted an updated patch to fix the $Subject
bug for the -rc cycle to this thread with more comments regarding dynamically
allocating the resources.

Regards,

Tony
