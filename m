Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935376AbaKNWso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:48:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:55819 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934460AbaKNWsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:48:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,387,1413270000"; 
   d="scan'208";a="608123189"
Date: Fri, 14 Nov 2014 14:48:30 -0800
From: "Sean O. Stalley" <sean.stalley@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stephanie Wallick <stephanie.s.wallick@intel.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [V2 PATCH 01/10] added media agnostic (MA) USB HCD driver
Message-ID: <20141114224829.GA2980@sean.stalley.intel.com>
References: <20141112214021.GA3531@sean.stalley.intel.com>
 <Pine.LNX.4.44L0.1411121656000.1676-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1411121656000.1676-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 05:03:18PM -0500, Alan Stern wrote:
> On Wed, 12 Nov 2014, Sean O. Stalley wrote:
> > Our plan to support multiple MA devices is to have them all connected
> > to the same virtual host controller, so only 1 would be needed.
> > 
> > Would you prefer we have 1 host controller instance per MA device?
> > We are definitely open to suggestions on how this should be architected.
> 
> I haven't read the MA USB spec, so I don't know how it's intended to 
> work.  Still, what happens if you create a virtual host controller 
> with, say, 16 ports, and then someone wants to connect a 17th MA 
> device?

To summarize the spec:
MA USB groups a host & connected devices into MA service sets (MSS).
The architectural limit is 254 MA devices per MSS.

If the host needs to connect more devices than that, It can start a
new MSS and connect to 254 more MA devices.



Is supporting up to 254 devices on one machine sufficient?

Would it make sense (and does the usb stack support) having 254 root
ports on one host controller? If so, we could make our host
controller instance have 254 ports. I'm guessing the hub driver may have
a problem with this (especially for superspeed).

If that doesn't make sense (or isn't supported), we can have 1 host
controller instance per MA device. Would that be preferred?

> Also, I noticed that your patch adds a new bus type for these MA host 
> controllers.  It really seems like overkill to have a whole new bus 
> type if there's only going to be one device on it.

The bus was added when we were quickly trying to replace the platform
device code. It's probably not the right thing to do.

I'm still not sure why we can't make our hcd a platform device,
especially since dummy_hcd & the usbip's hcd are both platform devices.

> > If we get rid of these locks, endpoints can't run simultaneously.
> > MA USB IN endpoints have to copy data, which could take a while.
> 
> I don't know what you mean by "run simultaneously".  Certainly multiple 
> network packets can be transmitted and received concurrently even if 
> you use a single spinlock, since your locking won't affect the 
> networking subsystem.

I meant we couldn't have 2 threads in our driver. With one lock,
One thread would always have to wait for the other, even though
they could be working on 2 different endpoints doing completely
independent tasks.

> > Couldn't this cause a bottleneck?
> 
> Probably not enough to matter.  After all, the other host controller
> drivers rely on a single spinlock.  And if it did matter, you could
> drop the spinlock while copying the data.

Good point. We can cut our driver down to using 1 lock. If we find that
only having 1 spinlock does cause a bottleneck, we can deal with it then.


Thanks,
Sean
