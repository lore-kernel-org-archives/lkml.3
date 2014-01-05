Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaAEWLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 17:11:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbaAEWLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 17:11:38 -0500
Date: Sun, 5 Jan 2014 17:11:23 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Mahoney <jeffm@suse.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH] kobject: provide kobject_put_wait to fix module unload
 race
In-Reply-To: <20140104224206.GC18213@core.coreip.homeip.net>
Message-ID: <alpine.LRH.2.02.1401051706040.18406@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com> <20140104181620.GA2087@kroah.com> <20140104183403.GG10323@ZenIV.linux.org.uk> <20140104224206.GC18213@core.coreip.homeip.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Jan 2014, Dmitry Torokhov wrote:

> On Sat, Jan 04, 2014 at 06:34:03PM +0000, Al Viro wrote:
> > On Sat, Jan 04, 2014 at 10:16:20AM -0800, Greg Kroah-Hartman wrote:
> > 
> > > > I came up with a simpler patch to achieve the same purpose - this patch 
> > > > makes fixing the drivers easy - the driver is fixed just by replacing 
> > > > "kobject_put" with "kobject_put_wait" in the unload routine.
> > > 
> > > No, that's not ok at all.
> > 
> > Agreed - all it takes is one cargo-culter who religoiusly does such
> > conversion and drops a ref to parent before that to child.
> > 
> > > > However, this pattern is buggy with respect to modules. The release method
> > > > is placed in the driver's module. When the driver exits, the module
> > > > reference count is zero, thus the module may be freed. However, there may
> > > > still be references to the kobject. If the module is unloaded and then the
> > > > release method is called, a crash happens.
> > > 
> > > Yes, module unloading while a kobject is still "active" is not a good
> > > thing, what modules do you have that cause this problem?  Why not just
> > > grab the module reference in your kobject if you need this type of
> > > protection?  It's not the kobject's code fault that this issue is there,
> > > or that we now have a "delayed release" function to expose this type of
> > > thing, it's the user of the kobject.
> > > 
> > > Please fix the broken users of the kobject first.
> > 
> > <snide> Are you saying that there is another kind? </snide>
> > 
> > When would you grab that reference to module?  More to the point, when
> > would you *drop* it?  Doing so from module_exit is not going to work,
> > obviously...
> 
> You normally have subsystem core module that does handle release of its
> objects and users of said objects so it is usually OK for objects to
> outlive the users, you just need to make sure the core stays around.
> 
> In input we grab module reference to input core when we allocate input
> device and drop it when input device is freed. This way we can be sure
> that input core stays around until all input devices are gone. The same
> for serio.
> 
> Thanks. 
> 
> -- 
> Dmitry

But sometimes, the driver itself needs to create nodes in the sysfs 
filesystem (for example drivers/md/dm-sysfs.c). I don't quite see how 
would you push all driver-specific sysfs nodes into the generic non-module 
code.

Mikulas
