Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab3BKPsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:48:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:57321 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab3BKPsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:48:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,643,1355126400"; 
   d="scan'208";a="261095629"
Date: Mon, 11 Feb 2013 16:48:12 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 03/11] mei: bus: Initial implementation for I/O
 routines
Message-ID: <20130211154812.GU20996@sortiz-mobl>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
 <201302111152.42483.arnd@arndb.de>
 <20130211125836.GN20996@sortiz-mobl>
 <201302111508.24317.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302111508.24317.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, Feb 11, 2013 at 03:08:24PM +0000, Arnd Bergmann wrote:
> On Monday 11 February 2013, Samuel Ortiz wrote:
> > On Mon, Feb 11, 2013 at 11:52:42AM +0000, Arnd Bergmann wrote:
> > > On Thursday 07 February 2013, Samuel Ortiz wrote:
> > > > On Thu, Feb 07, 2013 at 10:34:44PM +0000, Arnd Bergmann wrote:
> > > > > On Thursday 07 February 2013, Tomas Winkler wrote:
> > > > > > +
> > > > > > +struct mei_bus_ops {
> > > > > > +       int (*send)(struct mei_bus_client *client, u8 *buf, size_t length);
> > > > > > +       int (*recv)(struct mei_bus_client *client, u8 *buf, size_t length);
> > > > > > +};
> > > > > > +
> > > > > 
> > > > > Can you have more than one set of mei_bus_ops in a driver? 
> > > > You can have at most one mei_bus_ops per mei_bus_client.
> > > > 
> > > > > If not, how about adding the callbacks to the mei_bus_driver structure
> > > > > directly as a simplification? 
> > > > I can add the ops directly to the mei_bus_client structure, yes.
> > > 
> > > I looked at the new version, and it's not what I assumed it would be.
> > > I thought the operations were specific to a client driver and should
> > > be part of the /mei_bus_driver/ structure, not the /mei_bus_client/.
> > The ops should be part of mei_bus_client as they're specific to the MEI
> > protocol for a given IP block on the ME. You need to have MEI and HECI
> > knowledge to implement those ops and drivers (defining their mei_bus_driver
> > structure) should not have that kind of knowledge but rather focus on the
> > technology they're driving.
> > If we take the NFC example again, the drivers/nfc/ code will send NFC payloads
> > to the bus I/O routines and this is where the mei_bus_client ops will add the
> > ME specific protocol (command and request id for the NFC block) on top of it.
> > In practice, this is an additional header which handles a transport layer that's
> > specific not only to the ME but to the NFC block of it. So each ME block can
> > have its own protocol to send and receive technology specific payloads, that's
> > what those ops implement.
> > That's why I think that those ops should not be defined by the drivers/nfc/ code
> > and in fact should be opaque to it.
> 
> I think I'm still confused. 
It is confusing, and my explanations are probably not as good as they should 
be.

> What I read in your description is that unlike
> other subsystems that have a common bus implementation that is hooked into
> by two kinds of drivers (bus drivers that provide devices like a USB host
> controller, and device drivers that use those devices), you have three
> components that can be mixed independently: the bus (based on which
> PCI device you have), the transport and the endpoint device. Is that
> correct?
That's quite accurate, yes.


> If so, how do you know which transport to use?
Through the mei_bus_client ops. Device drivers get a mei_bus_client pointer
from their probe routine and the ops pointers there (If any) are set by
whoever creates the device. In the NFC case mei/nfc.c does that and implements
the NFC specific transport code for this technology. mei/nfc.c is also the
part of the code that actually adds the device to the bus.

So when a device driver wants e.g. to send its payload through the MEI bus, it
calls mei_bus_send() which takes the device driver mei_bus client pointer as
its first argument.
Then the payload may go through mei_bus_client->send() first which will eventually
physically sent the newly built frame through mei_send(). Some ME blocks don't require any
additional transport layer and in that case the device driver payload will go
straight to mei_send() since the mei_bus_client ops will be NULL.

Does that make more sense now ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
