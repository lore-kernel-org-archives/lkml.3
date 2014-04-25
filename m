Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaDYN74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:59:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42515 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751184AbaDYN7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:59:54 -0400
Date: Fri, 25 Apr 2014 09:59:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Li Zhong <zhong@linux.vnet.ibm.com>
cc: Johan Hovold <jhovold@gmail.com>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] USB: serial: fix sysfs-attribute removal deadlock
In-Reply-To: <1398392217.2805.150.camel@ThinkPad-T5421.cn.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1404250954360.1140-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014, Li Zhong wrote:

> > No, this isn't self removal. The driver-attribute (not device-attribute)
> > store operation simply grabs a lock that is also held while the driver
> > is being deregistered at module unload. Taking a reference to the module
> > in this case will prevent deregistration while store is running.
> > 
> > But it seems like this can be solved for usb-serial by simply not
> > holding the lock while deregistering.
> 
> I didn't look carefully about this lock. 
> 
> But I'm not sure whether there are such requirements for driver
> attributes:
> 
> some lock needs be grabbed in the driver attributes store callbacks, and
> the same lock also needs to be grabbed during driver unregister. 

In this case, the lock does _not_ need to be grabbed during driver 
unregister.  The driver grabs the lock, but it doesn't need to.

> If we have such requirements currently or in the future, I think they
> could all be solved by breaking active protection after get the module
> reference.

No!  That would be very bad.

Unloading modules is quite different from unbinding drivers.  After the
driver is unbound, its attribute callback routines can continue to run.  
But after a driver module has been unloaded, its attribute callback 
routines _cannot_ run because they aren't present in memory any more.

If we allowed a module to be unloaded while one of its callbacks was 
running (because active protection was broken), imagine what would 
happen...

Alan Stern

