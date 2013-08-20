Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab3HTTuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:50:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46684 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751573Ab3HTTui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:50:38 -0400
Date: Tue, 20 Aug 2013 15:50:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Krzysztof Mazur <krzysiek@podlesie.net>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: Re: [PATCH 2/2] usb: fail on usb_hub_create_port_device() errors
In-Reply-To: <20130820190730.GA13696@shrek.podlesie.net>
Message-ID: <Pine.LNX.4.44L0.1308201544170.892-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Krzysztof Mazur wrote:

> On Tue, Aug 20, 2013 at 02:18:57PM -0400, Alan Stern wrote:
> > On Tue, 20 Aug 2013, Krzysztof Mazur wrote:
> > 
> > > Ignoring usb_hub_create_port_device() errors cause later NULL pointer
> > > deference when uninitialized hub->ports[i] entries are dereferenced
> > > after port memory allocation error.
> > > 
> > > Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
> > > ---
> > > I'm not sure if failing in that case is a good idea, but other solutions
> > > are more complex.
> > > 
> > > I tried also changing hdev->maxchild and skiping initialization
> > > of later ports, but it didn't work because in some cases
> > > hub->descriptor->bNbrPorts is used instead of hdev->maxchild.
> > > With simulated usb_hub_create_port_device() failure I have an Oops
> > > in hub_power_on().
> > 
> > I think this patch is correct.  However, we also should change the 
> > other places that refer to bNbrPorts; make them use maxchild instead.
> 
> Ok, I can try to catch all such cases and fix problems with
> maxchild < bNBrPorts, but I think that changing bNBrPorts to maxchild
> might be not enough. For instance:

We should never have maxchild < bNbrPorts (unless maxchild is 0).  But 
just in case we do, changing the code is a good idea.

Besides, "hub->maxchild" is shorter and easier to read than
"hub->descriptor->bNbrPorts".  :-)

> 	for (port1 = 1; port1 <= hub->descriptor->bNbrPorts; port1++)
> 		if (hub->ports[port1 - 1]->power_is_on)
> 			set_port_feature(hub->hdev, port1, USB_PORT_FEAT_POWER);
> 		else
> 			usb_clear_port_feature(hub->hdev, port1,
> 						USB_PORT_FEAT_POWER);
> 
> in hub_power_on() should be probably changed to something like:
> 	
> 	for (port1 = 1; port1 <= hub->descriptor->bNbrPorts; port1++)
> 		if (hub->ports[port1 - 1] && hub->ports[port1 - 1]->power_is_on)
> 			set_port_feature(hub->hdev, port1, USB_PORT_FEAT_POWER);
> 		else
> 			usb_clear_port_feature(hub->hdev, port1,
> 						USB_PORT_FEAT_POWER);
> 
> to disable uninitialized ports.

No.  The ports above maxchild aren't merely uninitialized; they are 
completely unused.  We should ignore them altogether.  Just replace 
descriptor->bNbrPorts with maxchild.

> > > Another possible solution is allowing for uninitialized ports and
> > > checking for hub->ports[i] == NULL.
> > 
> > No, if we can't allocate memory for all the ports then the whole thing 
> > should fail.
> 
> The usb_hub_create_port_device() might fail also in case of device_add()
> error.

The main reason for errors in device_add() is memory allocation 
failure.  

Regardless, if the port structures can't be initialized then let's 
fail.

Alan Stern

