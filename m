Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaDYCRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 22:17:09 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:53454 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaDYCRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 22:17:05 -0400
Message-ID: <1398392217.2805.150.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [PATCH] USB: serial: fix sysfs-attribute removal deadlock
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com
Date: Fri, 25 Apr 2014 10:16:57 +0800
In-Reply-To: <20140424145206.GB2206@localhost>
References: <1398245539-1618-1-git-send-email-jhovold@gmail.com>
	 <20140423141908.GA4781@htj.dyndns.org>
	 <1398328155.2805.100.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140424143517.GC14460@htj.dyndns.org> <20140424145206.GB2206@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042502-2966-0000-0000-00000B0B96D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 16:52 +0200, Johan Hovold wrote:
> On Thu, Apr 24, 2014 at 10:35:17AM -0400, Tejun Heo wrote:
> > On Thu, Apr 24, 2014 at 04:29:15PM +0800, Li Zhong wrote:
> > > On Wed, 2014-04-23 at 10:19 -0400, Tejun Heo wrote:
> > > > cc'ing Li Zhong who's working on a simliar issue in the following
> > > > thread and quoting whole body.
> > > > 
> > > >   http://thread.gmane.org/gmane.linux.kernel/1680706
> > > > 
> > > > Li, this is another variation of the same problem.  Maybe this can be
> > > > covered by your work too?
> > > 
> > > It seems to me that it is about write something to driver attribute, and
> > > driver unloading. If so, maybe it's not easy to reuse the help functions
> > > created for device attribute, and device removing.
> > > 
> > > But I guess the idea to break the active protection could still be
> > > applied here:
> > > 
> > > Maybe we could try_module_get() here (like the other option suggested by
> > > Johan?), and break active protection if we could get the module,
> > > something like below? 
> > 
> > I don't get why try_module_get() matters here.  We can't call into
> > ->store if the object at hand is already destroyed and the underlying
> > module can't go away if the target device is still alive.
> > try_module_get() doesn't actually protect the object.  Why does that
> > matter?  This is self removal, right?  Can you please take a look at
> > kernfs_remove_self()?
> 
> No, this isn't self removal. The driver-attribute (not device-attribute)
> store operation simply grabs a lock that is also held while the driver
> is being deregistered at module unload. Taking a reference to the module
> in this case will prevent deregistration while store is running.
> 
> But it seems like this can be solved for usb-serial by simply not
> holding the lock while deregistering.

I didn't look carefully about this lock. 

But I'm not sure whether there are such requirements for driver
attributes:

some lock needs be grabbed in the driver attributes store callbacks, and
the same lock also needs to be grabbed during driver unregister. 

If we have such requirements currently or in the future, I think they
could all be solved by breaking active protection after get the module
reference.

Thanks, Zhong

> 
> Johan
> 


