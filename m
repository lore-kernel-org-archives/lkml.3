Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873Ab3DJTTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:19:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:44576 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759513Ab3DJTTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:19:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,449,1363158000"; 
   d="scan'208";a="320478091"
Date: Wed, 10 Apr 2013 21:19:45 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 1/3] mei: nfc: Initial nfc implementation
Message-ID: <20130410191945.GH4874@zurbaran>
References: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
 <1365464495-17642-2-git-send-email-tomas.winkler@intel.com>
 <20130410172551.GA1881@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410172551.GA1881@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Apr 10, 2013 at 10:25:51AM -0700, Greg KH wrote:
> On Tue, Apr 09, 2013 at 02:41:33AM +0300, Tomas Winkler wrote:
> > From: Samuel Ortiz <sameo@linux.intel.com>
> > 
> > NFC ME device is exported through the MEI bus to be consumed by the
> > NFC subsystem.
> > 
> > NFC is represented by two mei clients: An info one and the actual
> > NFC one. In order to properly build the ME id we first need to retrieve
> > the firmware information from the info client and then disconnect from it.
> 
> I still don't understand why you aren't tieing this into the existing
> nfc kernel api.  What am I missing?
We can't tie this into the existing NFC kernel API because mei/nfc.c is not an
NFC driver, it's an ME specific shim layer that does not do anything NFC (as
in NFC Forum specified) related.
At that point in the code the only thing we know is that there is an NFC
device behind the ME. As I said, it can be any NFC device, but it's not an
Intel specific or ME specific NFC hardware, it's just a regular NFC one
(pn544, microread, etc...) that is only accessible through the ME. The typical
setup is where you access the NFC hardware through i2c, SPI or USB, but here
it's "hidden" behind the ME.

The patch below sends the needed commands to the ME in order to fetch some
information (vendor ID, radio ID) and understand which exact chipset
is physically hooked to the ME (0x0, 0x0 -> microread, 0x1, 0x1 -> pn544).
Once that's done, we can add the right device on the ME bus (This is done on
patch #2), the same way you would add an NFC device to the USB bus when your
USB host controller tells you about the vendor and product IDs.
So after patch #1 and #2, we have an NFC device on the ME and this could be
e.g. a pn544. We do have a driver for pn544 under drivers/nfc/ which will hook
into the NFC kernel APIs once probed (The pn544 is missing an mei.c file that
will register itself as an mei_cl driver for "pn544", as described in
Documentation/misc-devices/mei/mei-client-bus.txt). So the NFC kernel APIs are
called from the actual NFC driver, because mei/nfc.c is not an NFC driver,
it's a NFC specific ME layer that is needed to register the right device (as
in the kernel device/driver model) on the MEI bus.



> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > ---
> >  drivers/misc/mei/Makefile     |   1 +
> >  drivers/misc/mei/client.c     |   3 +
> >  drivers/misc/mei/init.c       |   2 +
> >  drivers/misc/mei/mei_dev.h    |  10 ++
> >  drivers/misc/mei/nfc.c        | 250 ++++++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/Kbuild     |   1 +
> >  include/uapi/linux/mei/Kbuild |   2 +
> >  include/uapi/linux/mei/nfc.h  | 135 +++++++++++++++++++++++
> 
> Based on our previous off-list emails, you said that this .h file is
> needed for the userspace api.  But the nfc userspace api is through the
> nfc API, which doesn't use any of the structures defined here.  So who
> exactly uses this file?
You're right, an NFC application that would use the kernel NFC APIs (AF_NFC
and the NFC generic netlink one) will not need this header.
But the Android stack does not use any of the NFC kernel APIs, it implements
the whole NFC stack in userspace and typically sends raw HCI frames to a dumb
kernel driver (not upstreamed) through /dev/pn544 for example.
That works fine with the typical case where your pn544 is directly accessible
through i2c. But if it's sitting behind the ME, you will need to send
commands exported through this file to fetch the vendor and radio IDs, but
also to send those HCI frames that the vanilla Android stack builds after
encapsulating them into a struct mei_nfc_cmd. And this is all done through the
/dev/mei interface.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
