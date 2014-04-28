Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaD1B7G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:59:06 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:43344 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaD1B7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:59:01 -0400
Message-ID: <1398650332.3046.67.camel@ThinkPad-T5421>
Subject: Re: [PATCH] USB: serial: fix sysfs-attribute removal deadlock
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Johan Hovold <jhovold@gmail.com>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com
Date: Mon, 28 Apr 2014 09:58:52 +0800
In-Reply-To: <Pine.LNX.4.44L0.1404250954360.1140-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1404250954360.1140-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042801-2966-0000-0000-00000B1190D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 09:59 -0400, Alan Stern wrote:
> On Fri, 25 Apr 2014, Li Zhong wrote:
> 
> > > No, this isn't self removal. The driver-attribute (not device-attribute)
> > > store operation simply grabs a lock that is also held while the driver
> > > is being deregistered at module unload. Taking a reference to the module
> > > in this case will prevent deregistration while store is running.
> > > 
> > > But it seems like this can be solved for usb-serial by simply not
> > > holding the lock while deregistering.
> > 
> > I didn't look carefully about this lock. 
> > 
> > But I'm not sure whether there are such requirements for driver
> > attributes:
> > 
> > some lock needs be grabbed in the driver attributes store callbacks, and
> > the same lock also needs to be grabbed during driver unregister. 
> 
> In this case, the lock does _not_ need to be grabbed during driver 
> unregister.  The driver grabs the lock, but it doesn't need to.

OK.

> 
> > If we have such requirements currently or in the future, I think they
> > could all be solved by breaking active protection after get the module
> > reference.
> 
> No!  That would be very bad.
> 
> Unloading modules is quite different from unbinding drivers.  After the
> driver is unbound, its attribute callback routines can continue to run.  
> But after a driver module has been unloaded, its attribute callback 
> routines _cannot_ run because they aren't present in memory any more.
> 
> If we allowed a module to be unloaded while one of its callbacks was 
> running (because active protection was broken), imagine what would 
> happen...

I don't think the module could be unloaded after we increased the module
reference counter. 

Thanks, Zhong

> 
> Alan Stern
> 


