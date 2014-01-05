Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081AbaAEDmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 22:42:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaAEDmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 22:42:17 -0500
Date: Sat, 4 Jan 2014 19:42:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jeff Mahoney <jeffm@suse.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH] kobject: provide kobject_put_wait to fix module unload
 race
Message-ID: <20140105034228.GC22595@kroah.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
 <20140104181620.GA2087@kroah.com>
 <alpine.LRH.2.02.1401041456070.21108@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1401041456070.21108@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 04, 2014 at 03:35:39PM -0500, Mikulas Patocka wrote:
> 
> 
> On Sat, 4 Jan 2014, Greg Kroah-Hartman wrote:
> 
> > On Sat, Jan 04, 2014 at 01:06:01PM -0500, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > I noticed that Jeff Mahoney added a new structure kobj_completion, defined 
> > > in include/linux/kobj_completion.h to the kernel 3.13-rc1 in the patch 
> > > eee031649707db3c9920d9498f8d03819b74fc23. In the current upstream kernel, 
> > > this interface is still unused.
> > 
> > There are pending btrfs patches to use this interface.
> > 
> > > However, converting the drivers to use kobj_completion is not trivial 
> > > (note that all users of the original kobject interface are buggy - so all 
> > > of them need to be converted).
> > 
> > Wait, what?  How are "all users" buggy?  Please explain this in detail.
> 
> 1) some code takes a reference to a kobject
> 2) the user unloads the device
> 3) the device driver unload routine calls kobject_put (but there is still 
>    reference, so the kobject is not destroyed)

A driver should never be messing around with "raw" kobjects, they should
be using a 'struct device' which is created/managed by the subsystem
they belong to.  See Dmitry's example of input and serio as ways to do
this, also USB and PCI do this properly.

Perhaps your sybsystem isn't doing this properly?  What code do you have
that creates raw kobjects and has this problem?

thanks,

greg k-h
