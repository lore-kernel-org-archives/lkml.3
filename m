Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbaJWPyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:54:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbaJWPyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:54:09 -0400
Message-ID: <1414079644.27420.28.camel@ul30vt.home>
Subject: Re: [PATCH v4] PCI: add kernel parameter to override devid<->driver
 mapping.
From: Alex Williamson <alex.williamson@redhat.com>
To: Marcel Apfelbaum <marcel.a@redhat.com>
Cc: Stuart Yoder <stuart.yoder@freescale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marcel@redhat.com" <marcel@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
Date: Thu, 23 Oct 2014 09:54:04 -0600
In-Reply-To: <1414076416.2376.90.camel@localhost.localdomain>
References: <1413813882-27047-1-git-send-email-marcel.a@redhat.com>
	 <1414002755.4202.253.camel@ul30vt.home>
	 <d093a0738f61433aafe5ddd36d0393e9@CY1PR0301MB0748.namprd03.prod.outlook.com>
	 <1414072672.27420.12.camel@ul30vt.home>
	 <1414074808.2376.88.camel@localhost.localdomain>
	 <1414075786.27420.19.camel@ul30vt.home>
	 <1414076416.2376.90.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-23 at 18:00 +0300, Marcel Apfelbaum wrote:
> On Thu, 2014-10-23 at 08:49 -0600, Alex Williamson wrote:
> > On Thu, 2014-10-23 at 17:33 +0300, Marcel Apfelbaum wrote:
> > > On Thu, 2014-10-23 at 07:57 -0600, Alex Williamson wrote:
> > > > On Thu, 2014-10-23 at 13:44 +0000, Stuart Yoder wrote:
> > > > > 
> > > > > > -----Original Message-----
> > > > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > > > Sent: Wednesday, October 22, 2014 1:33 PM
> > > > > > To: Marcel Apfelbaum
> > > > > > Cc: linux-pci@vger.kernel.org; bhelgaas@google.com; linux-kernel@vger.kernel.org; marcel@redhat.com;
> > > > > > mst@redhat.com; Yoder Stuart-B08248
> > > > > > Subject: Re: [PATCH v4] PCI: add kernel parameter to override devid<->driver mapping.
> > > > > > 
> > > > > > [cc+ stuart]
> > > > > > 
> > > > > > On Mon, 2014-10-20 at 17:04 +0300, Marcel Apfelbaum wrote:
> > > > > > > Scanning a lot of devices during boot requires a lot of time.
> > > > > > > On other scenarios there is a need to bind a driver to a specific slot.
> > > > > > >
> > > > > > > Binding devices to pci-stub driver does not work,
> > > > > > > as it will not differentiate between devices of the
> > > > > > > same type. Using some start scripts is error prone.
> > > > > > >
> > > > > > > The solution leverages driver_override functionality introduced by
> > > > > > >
> > > > > > > 	commit: 782a985d7af26db39e86070d28f987cad21313c0
> > > > > > > 	Author: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > 	Date:   Tue May 20 08:53:21 2014 -0600
> > > > > > >
> > > > > > >     	PCI: Introduce new device binding path using pci_dev.driver_override
> > > > > > >
> > > > > > > In order to bind PCI slots to specific drivers use:
> > > > > > > 	pci=driver[xxxx:xx:xx.x]=foo,driver[xxxx:xx:xx.x]=bar,...
> > > > > > >
> > > > > > > Signed-off-by: Marcel Apfelbaum <marcel.a@redhat.com>
> > > > > > > ---
> > > > > > > v3 -> v4:
> > > > > > >  - Addressed Alex Williamson's comments:
> > > > > > >    - Modified the type of driver_override_entry's fields
> > > > > > >    - Used PCI_DEVFN when appropriated
> > > > > > >    - Removed redundant checks
> > > > > > >    - Replaced BUG_ON with pr_err messages
> > > > > > >    - Simpler command line parsing
> > > > > > >  - Addressed Michael S. Tsirkin comments
> > > > > > >    - removed DRIVER_OVERRIDE_NAME_LENGTH limitation
> > > > > > > v2 -> v3:
> > > > > > >  - Corrected subject line
> > > > > > > v1 -> v2:
> > > > > > >  - Addressed Michael S. Tsirkin comments
> > > > > > >    - Removed 32 slots limitation
> > > > > > >    - Better handling of memory allocation failures
> > > > > > >      (preferred BUG_ON over error messages)
> > > > > > >  - Addressed Alex Williamson's comments:
> > > > > > >    - Modified commit message to show parameter usage more clear.
> > > > > > >  - I preferred to re-use parse_args instead of manually using
> > > > > > >    strstr in order to better comply with command line parsing
> > > > > > >    rules.
> > > > > > >  - I didn't use any locking when parsing the command line args
> > > > > > >    (see parse_done usage) assuming that first call will be
> > > > > > >    early in system boot and no race can occur. Please correct
> > > > > > >    me if I am wrong.
> > > > > > >
> > > > > > > Notes:
> > > > > > >  - I have further ideas on top of this patch based on your reviews.
> > > > > > >    I thought of:
> > > > > > >    - Use wildcards to specify entire buses/devices, something like:
> > > > > > >      	driver[0001:02:*.*]=pci-stub
> > > > > > >    - Use comma to separate several devices:
> > > > > > >      	driver[0001:02:03.4,0001:02:04.0,...]=pci-stub
> > > > > > >    - Make domain optional:
> > > > > > >    	driver[00:03.0]=pci-stub
> > > > > > >
> > > > > > > Comments will be appreciated,
> > > > > > > Thanks,
> > > > > > > Marcel
> > > > > > >  Documentation/kernel-parameters.txt |   4 ++
> > > > > > >  drivers/pci/bus.c                   | 111 ++++++++++++++++++++++++++++++++++++
> > > > > > >  drivers/pci/pci.c                   |   2 +
> > > > > > >  3 files changed, 117 insertions(+)
> > > > > > 
> > > > > > The driver_override feature that we're making use of here is also going
> > > > > > to be supported by platform devices and potentially more bustypes in the
> > > > > > future, so I'm concerned that making a pci specific kernel parameter is
> > > > > > too shortsighted.  Instead we could hook on to BUS_NOTIFY_ADD_DEVICE for
> > > > > > bustypes that support driver_override so we can have a common interface.
> > > > > > Perhaps:
> > > > > > 
> > > > > > driver_override=pci,0000:02:00.0=pci-stub;platform,fakename=vfio-platform
> > > > > > 
> > > > > > Finding delimiters that don't conflict may be challenging.
> > > > > 
> > > > > I think what you proposed works--  <bus-name>,<bus-dev>=<driver>;
> > > > > 
> > > > > Think that will work for PCI, platform, and the new fsl-mc bus we are working
> > > > > on.
> > > > > 
> > > > > > Also, can we
> > > > > > assume that bus-name:dev-name is unique for every bustype?  It is for
> > > > > > pci, platform?
> > > > > 
> > > > > I think that has to be the case.
> > > > > 
> > > > > > It also seems like there's a question of how long should this override
> > > > > > last and how does the user disable it?
> > > > > 
> > > > > Isn't that a general question for the "driver_overrride" mechanism?
> > > > > I'm forgetting if the mechanism in the kernel now has a way to disable
> > > > > it--  e.g. echo /dev/null > /sys/pci/devices/.../driver_override ??
> > > > > 
> > > > > So, it would last until explicitly disabled through sysfs.
> > > > 
> > > > Yes, when you set a driver_override on a device you cancel it by writing
> > > > a NULL string to the same interface.  The problem is that here we have a
> > > > new entity in the driver scan that keeps re-applying the driver_override
> > > > as devices are scanned with no way to stop it.  So you can certainly
> > > > undo the immediate effect and bind the device to another driver, but if
> > > > the device is removed and re-scanned there's no way to stop if from
> > > > re-applying the override.  Thanks,
> > > Hi Alex,
> > > 
> > > I checked the above scenario and after driver_override is cleared
> > > an we do bind/unbind, the mapping defined in the command line
> > > does not apply anymore.
> > > 
> > > My steps were:
> > > 1. define the override in command-line -> the mapped driver is used instead of the native one
> > > 2. unbind the device from the slot -> no driver for device
> > > 3. remove the driver_override mapping form the slot -> no mapping defined
> > > 3, bind the device again -> native driver in use.
> > 
> > That's not the scenario I'm describing.  Use the remove and rescan sysfs
> > attributes to do a software hotplug and you'll see that the
> > driver_override will always be re-applied to the device.  For example:
> > 
> > # echo "" > /sys/bus/pci/devices/0000:02:00.0/driver_override
> > # echo 1 > /sys/bus/pci/devices/0000:02:00.0/remove
> > # echo 1 > /sys/bus/pci/rescan
> > # cat /sys/bus/pci/devices/0000:02:00.0/driver_override
> > 
> > I expect the last step will show the original override re-applied.
> I can check this, but I am sure you are right.
> We need to think about this, if is acceptable or not.

I think we're going to need a sysfs way to manipulate the set of active
overrides.  I was thinking about whether a one-shot implementation might
be acceptable, ie. discard the override after use, but I think that
would look just as unpredictable to users as the current approach.
Thanks,

Alex

