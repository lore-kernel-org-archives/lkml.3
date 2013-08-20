Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab3HTTHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:07:34 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:55203 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3HTTHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:07:32 -0400
Date: Tue, 20 Aug 2013 21:07:30 +0200
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: Re: [PATCH 2/2] usb: fail on usb_hub_create_port_device() errors
Message-ID: <20130820190730.GA13696@shrek.podlesie.net>
References: <1377019476-7701-3-git-send-email-krzysiek@podlesie.net>
 <Pine.LNX.4.44L0.1308201415020.1591-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308201415020.1591-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 02:18:57PM -0400, Alan Stern wrote:
> On Tue, 20 Aug 2013, Krzysztof Mazur wrote:
> 
> > Ignoring usb_hub_create_port_device() errors cause later NULL pointer
> > deference when uninitialized hub->ports[i] entries are dereferenced
> > after port memory allocation error.
> > 
> > Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
> > ---
> > I'm not sure if failing in that case is a good idea, but other solutions
> > are more complex.
> > 
> > I tried also changing hdev->maxchild and skiping initialization
> > of later ports, but it didn't work because in some cases
> > hub->descriptor->bNbrPorts is used instead of hdev->maxchild.
> > With simulated usb_hub_create_port_device() failure I have an Oops
> > in hub_power_on().
> 
> I think this patch is correct.  However, we also should change the 
> other places that refer to bNbrPorts; make them use maxchild instead.

Ok, I can try to catch all such cases and fix problems with
maxchild < bNBrPorts, but I think that changing bNBrPorts to maxchild
might be not enough. For instance:

	for (port1 = 1; port1 <= hub->descriptor->bNbrPorts; port1++)
		if (hub->ports[port1 - 1]->power_is_on)
			set_port_feature(hub->hdev, port1, USB_PORT_FEAT_POWER);
		else
			usb_clear_port_feature(hub->hdev, port1,
						USB_PORT_FEAT_POWER);

in hub_power_on() should be probably changed to something like:
	
	for (port1 = 1; port1 <= hub->descriptor->bNbrPorts; port1++)
		if (hub->ports[port1 - 1] && hub->ports[port1 - 1]->power_is_on)
			set_port_feature(hub->hdev, port1, USB_PORT_FEAT_POWER);
		else
			usb_clear_port_feature(hub->hdev, port1,
						USB_PORT_FEAT_POWER);

to disable uninitialized ports.

> 
> > Another possible solution is allowing for uninitialized ports and
> > checking for hub->ports[i] == NULL.
> 
> No, if we can't allocate memory for all the ports then the whole thing 
> should fail.

The usb_hub_create_port_device() might fail also in case of device_add()
error.

> 
> Alan Stern

Thanks,
Krzysiek
