Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3JJUBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:01:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:53620 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab3JJUBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:01:31 -0400
Message-ID: <1381435276.5630.6.camel@pasglop>
Subject: Re: sysfs for my chips
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 11 Oct 2013 07:01:16 +1100
In-Reply-To: <20131010174457.GE13759@kroah.com>
References: <1381378788.4330.30.camel@pasglop>
	 <20131010174457.GE13759@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 10:44 -0700, Greg KH wrote:
> On Thu, Oct 10, 2013 at 03:19:48PM +1100, Benjamin Herrenschmidt wrote:
> > Hi Greg !
> > 
> > (random CC list of clueful people)
> > 
> > On some new powerpc platforms (non-hypervisor or rather linux is the
> > hypervisor), I want to expose a bunch of stuff per "chip", the chips
> > being currently the processor chips and the "centaurs" (think of them as
> > the bottom half of the memory controllers).
> > 
> > Among other, I want a sysfs file in there to access "xscom" on the chip
> > which is a sideband bus used for low level stuff (think jtag on steroid)
> > which we can use, among others, for chip health monitoring, general
> > debugging and diagnostics, etc...
> > 
> > I might add more such as VPD, model information, etc... later or at
> > least a link to corresponding device-tree node.
> 
> So a mixture of things that traditionally have been in /proc/cpuinfo?

Not really no. /proc/cpuinfo is per-thread, and potentially might have a
core number and a few global things. Here I'm talking mostly about

  - A pseudo-file that gives access to a sideband HW bus to perform
read/write of system registers essentially, which is per physical
"chip" (chip in this context is processor chip, which can have lots of
cores/threads, but also can be our memory buffer chips).

  - The other stuff is much more than the kind of one-liner than one
finds in cpuinfo. For now I'm just slapping the usual "devspec" file
that contains the corresponding device-tree path and whatever additional
info can be retrieved from there. Things like VPDs for example can be
pretty big.

> I've always wanted to see the cpuinfo files turn into sysfs files, so
> that tools can parse them "properly" and not have to do different things
> on different arches, like the proc/cpuinfo file is today (a mess).
> 
> > How do you suggest I expose that ? So far I've been thinking about
> > something like
> > 
> > 	/sys/chips/{processor,centaur}/chip#/files
> > 
> > or to avoid namespace clashes
> > 
> > 	/sys/firmware/chips/{processor,centaur}/chip#/files
> > 
> > Or maybe just
> > 
> > 	/sys/firmware/chips/chip#/files
> > 
> > (the chip type can be inferred from the chip#, they use the same space
> > at least as far my firmware exposes them to Linux)
> > 
> > (the actual access to xscom goes via firmware tho it makes *some* sense)
> > 
> > But I could instead create platform devices corresponding to the
> > device-tree representation of each of those chips ... and have the
> > platform devices contain the magic attributes. That's a bit more
> > convoluted though.
> 
> We already create platform devices for the cpus in the system in
> /sys/devices/system/, so can you just hang the attribute files off of
> those platform devices?

This is not CPUs. CPUs are threads really. Even if they were cores, that
still wouldn't cut it. I'm looking at chips here and not all of them
actually processor chips. The SCOM bus address space is global to a
physical chip and allows to access various resources that are only
remotely related to the cores on it.

> And system devices seem like the correct thing for your "chips" that are
> not cpus, right?

Well, I could use system devices for everything I don't see much point,
since those things won't have a "driver" per-se, I don't actually need
any of the other infrastructure provided by a system device here. I've
posted a patch (which I should have labelled RFC) there with my current
experimental code:

http://patchwork.ozlabs.org/patch/282167/

Right now I do /sys/firmware/scom/<chip#>/{devspec,access} but of course
I can easily change that.

Cheers,
Ben.

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


