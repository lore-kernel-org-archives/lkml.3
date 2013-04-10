Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111Ab3DJVPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:15:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:63368 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab3DJVPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:15:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="317390195"
Date: Wed, 10 Apr 2013 23:15:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 1/3] mei: nfc: Initial nfc implementation
Message-ID: <20130410211513.GJ4874@zurbaran>
References: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
 <1365464495-17642-2-git-send-email-tomas.winkler@intel.com>
 <20130410172551.GA1881@kroah.com>
 <20130410191945.GH4874@zurbaran>
 <20130410200312.GC5681@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410200312.GC5681@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 01:03:12PM -0700, Greg KH wrote:
> On Wed, Apr 10, 2013 at 09:19:45PM +0200, Samuel Ortiz wrote:
> > On Wed, Apr 10, 2013 at 10:25:51AM -0700, Greg KH wrote:
> > > On Tue, Apr 09, 2013 at 02:41:33AM +0300, Tomas Winkler wrote:
> > > > From: Samuel Ortiz <sameo@linux.intel.com>
> > > > 
> > > > NFC ME device is exported through the MEI bus to be consumed by the
> > > > NFC subsystem.
> > > > 
> > > > NFC is represented by two mei clients: An info one and the actual
> > > > NFC one. In order to properly build the ME id we first need to retrieve
> > > > the firmware information from the info client and then disconnect from it.
> > > 
> > > I still don't understand why you aren't tieing this into the existing
> > > nfc kernel api.  What am I missing?
> > We can't tie this into the existing NFC kernel API because mei/nfc.c is not an
> > NFC driver, it's an ME specific shim layer that does not do anything NFC (as
> > in NFC Forum specified) related.
> 
> Then why call it "NFC" if you don't want to confuse everyone :)
I couldn't come up with a better name for code that handles the NFC quirks for
the MEI driver...

 
> > At that point in the code the only thing we know is that there is an NFC
> > device behind the ME. As I said, it can be any NFC device, but it's not an
> > Intel specific or ME specific NFC hardware, it's just a regular NFC one
> > (pn544, microread, etc...) that is only accessible through the ME. The typical
> > setup is where you access the NFC hardware through i2c, SPI or USB, but here
> > it's "hidden" behind the ME.
> 
> Ok, but once you "unhide" it, it needs to talk through the in-kernel NFC
> api, 
I think there's still some misunderstanding here, so let's take an analogy:
Imagine that we could have a 802.11 chipset behind the ME, and that it
could be an Intel iwlwifi one, or an Atheros ath9k one, depending on the reply
to a specific ME command that we send at init time. Would you then be
suggesting that I'd have to implement the 802.11 drivers in mei/mei_wifi.c,
while all the logic for those drivers are already implemented under
drivers/net/wireless ? If I use the in-kernel NFC APIs, this is exactly what I
would have to do.


> not some other random interface.
Which random interface ? This code adds a device on the MEI bus and the
corresponding NFC driver (drivers/nfc) will be using the MEI bus API to send
the NFC frames it gets from the in-kernel NFC stack.



> > The patch below sends the needed commands to the ME in order to fetch some
> > information (vendor ID, radio ID) and understand which exact chipset
> > is physically hooked to the ME (0x0, 0x0 -> microread, 0x1, 0x1 -> pn544).
> > Once that's done, we can add the right device on the ME bus (This is done on
> > patch #2), the same way you would add an NFC device to the USB bus when your
> > USB host controller tells you about the vendor and product IDs.
> > So after patch #1 and #2, we have an NFC device on the ME and this could be
> > e.g. a pn544. We do have a driver for pn544 under drivers/nfc/ which will hook
> > into the NFC kernel APIs once probed (The pn544 is missing an mei.c file that
> > will register itself as an mei_cl driver for "pn544", as described in
> > Documentation/misc-devices/mei/mei-client-bus.txt). So the NFC kernel APIs are
> > called from the actual NFC driver, because mei/nfc.c is not an NFC driver,
> > it's a NFC specific ME layer that is needed to register the right device (as
> > in the kernel device/driver model) on the MEI bus.
> 
> So when will you send the patch for the pn544 driver?
I did for the microread one, check drivers/nfc/microread/mei.c. Actually, this
could help clearing some of the confusion.


> > > >  include/uapi/linux/mei/nfc.h  | 135 +++++++++++++++++++++++
> > > 
> > > Based on our previous off-list emails, you said that this .h file is
> > > needed for the userspace api.  But the nfc userspace api is through the
> > > nfc API, which doesn't use any of the structures defined here.  So who
> > > exactly uses this file?
> > You're right, an NFC application that would use the kernel NFC APIs (AF_NFC
> > and the NFC generic netlink one) will not need this header.
> > But the Android stack does not use any of the NFC kernel APIs, it implements
> > the whole NFC stack in userspace and typically sends raw HCI frames to a dumb
> > kernel driver (not upstreamed) through /dev/pn544 for example.
> 
> That's horrible, 
You're preaching to the choir here. I did start the whole NFC kernel
subsystem precisely because I found the whole Android NFC architecture
horrible.

> use the in-kernel apis, don't create your own, 
I am _not_ using my own APIs, I maintain the NFC daemon (neard) that precisely
uses those APIs.


> and
> Android should be using the correct apis as well.
Yes, but that's not happening. The Android folks even moved away from the
kernel Bluetooth APIs by switching to bluedroid.


> If it isn't, we don't
> have to support it here, in fact, I would strongly suggest that we not,
> so as it gets properly changed.
This was our initial intention when putting all those structures and commands
under drivers/misc/mei/nfc.h but you were against it for technical reasons.
Once I explained to you that:

"Because the Android NFC stacks running on platforms where the NFC chip is
sitting behind the ME will send data buffer containing those specific
structures to /dev/mei directly. So those will cross the user/kernel
boundary."

You agreed that this should be placed under uapi. I'm fine moving it back to
mei/nfc.h, but not under a GPL licensed mei/nfc.c.

> In fact, why don't you change it?
Why don't I change the Android NFC architecture ? Not being a Google employee
would be a good reason I guess. And Google choosing to externalize all of
their NFC development to an NFC manufacturer (That obviously has business
reasons to lock Android OEMs into its own stack) would second that...

FWIW, I did replace the initial drivers/nfc/pn544.c code that was pushed for
supporting the Android stack with a proper driver that's entirely based on the
kernel NFC APIs.

> > That works fine with the typical case where your pn544 is directly accessible
> > through i2c. But if it's sitting behind the ME, you will need to send
> > commands exported through this file to fetch the vendor and radio IDs, but
> > also to send those HCI frames that the vanilla Android stack builds after
> > encapsulating them into a struct mei_nfc_cmd. And this is all done through the
> > /dev/mei interface.
> 
> No NFC data should be going through /dev/mei, use the proper kernel apis
> please.
Not my choice, I'm sorry. And I'm not the one who's going to implement the
adaptation layer for the Android stack to properly work over /dev/mei, other
folks at Intel will.
If an Android OEM decides he wants a pn544 NFC chipset behind an x86 ME, then
NFC data will go through /dev/mei. I don't like it, but this is a business
decision I have no control over.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
