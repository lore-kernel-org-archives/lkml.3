Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaAEWEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 17:04:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaAEWEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 17:04:48 -0500
Date: Sun, 5 Jan 2014 17:04:31 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Jeff Mahoney <jeffm@suse.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH] kobject: provide kobject_put_wait to fix module unload
 race
In-Reply-To: <20140105034228.GC22595@kroah.com>
Message-ID: <alpine.LRH.2.02.1401051655430.18406@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com> <20140104181620.GA2087@kroah.com> <alpine.LRH.2.02.1401041456070.21108@file01.intranet.prod.int.rdu2.redhat.com> <20140105034228.GC22595@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Jan 2014, Greg Kroah-Hartman wrote:

> On Sat, Jan 04, 2014 at 03:35:39PM -0500, Mikulas Patocka wrote:
> > 
> > 
> > On Sat, 4 Jan 2014, Greg Kroah-Hartman wrote:
> > 
> > > On Sat, Jan 04, 2014 at 01:06:01PM -0500, Mikulas Patocka wrote:
> > > > Hi
> > > > 
> > > > I noticed that Jeff Mahoney added a new structure kobj_completion, defined 
> > > > in include/linux/kobj_completion.h to the kernel 3.13-rc1 in the patch 
> > > > eee031649707db3c9920d9498f8d03819b74fc23. In the current upstream kernel, 
> > > > this interface is still unused.
> > > 
> > > There are pending btrfs patches to use this interface.
> > > 
> > > > However, converting the drivers to use kobj_completion is not trivial 
> > > > (note that all users of the original kobject interface are buggy - so all 
> > > > of them need to be converted).
> > > 
> > > Wait, what?  How are "all users" buggy?  Please explain this in detail.
> > 
> > 1) some code takes a reference to a kobject
> > 2) the user unloads the device
> > 3) the device driver unload routine calls kobject_put (but there is still 
> >    reference, so the kobject is not destroyed)
> 
> A driver should never be messing around with "raw" kobjects, they should
> be using a 'struct device' which is created/managed by the subsystem
> they belong to.  See Dmitry's example of input and serio as ways to do
> this, also USB and PCI do this properly.
> 
> Perhaps your sybsystem isn't doing this properly?  What code do you have
> that creates raw kobjects and has this problem?
> 
> thanks,
> 
> greg k-h

So, are you saying that a module shouldn't ever be able to create a 
kobject type?

Do "grep -rw kobj_type drivers/ fs/* net/bridge/" to see how much code 
uses kobjects. There are 77 line. Majority of them may be compiled as 
modules.

What do you want to do with all those kobject users? Hide them behind 
another interface that doesn't exists yet?

Mikulas
