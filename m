Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3DLSZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:25:41 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:15073 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3DLSZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:25:40 -0400
Message-ID: <1365790396.312.147.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2] ACPI: Add sysfs links from memory device to memblocks
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, vasilis.liaskovitis@profitbricks.com
Date: Fri, 12 Apr 2013 12:13:16 -0600
In-Reply-To: <3284116.8vZqOg98VZ@vostro.rjw.lan>
References: <1361826130-31062-1-git-send-email-toshi.kani@hp.com>
	 <7718937.tEXDldppSg@vostro.rjw.lan>
	 <1364404429.15745.74.camel@misato.fc.hp.com>
	 <3284116.8vZqOg98VZ@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-12 at 00:23 +0200, Rafael J. Wysocki wrote:
> Sorry for the delayed response.

No problem.  I know you are busy.  Thanks for the reply.

> On Wednesday, March 27, 2013 11:13:49 AM Toshi Kani wrote:
> > On Wed, 2013-03-27 at 00:39 +0100, Rafael J. Wysocki wrote:
 :
> > > 
> > > What about having a "physical memory module" device that will be associated
> > > with those memory blocks (and will have links to them from its directory in
> > > sysfs) and that will be pointed to by the "physical_node" pointer from
> > > under PNP0C80:X?  Then, it may have a driver that will do the online/offline
> > > (and export the interface for that to user space through sysfs) and will
> > > interact with the ACPI interface provided by PNP0C80:X.
> > 
> > It sounds interesting idea, but I think it has several issues:
> > 
> >  - Maintenance: It is not clear to me who owns this physical device.
> > From the memory subsystem perspective, a memblk is an object that is
> > managed like a device internally.  So, I do not think the memory
> > subsystem needs this.
> 
> It doesn't, if "offline" is implemented at the memblk level.  

Agreed.

> Which I'm not
> sure is practical, because multiple memblks will be offlined/onlined
> simultaneously in all realistic setups.

Yes, the current memblk size of 128MB on x86 is rather small.  I agree
it is unlikely that regular users use this interface directly.  I think
this interface is intended for developers and tools. 

> > If ACPI owns this, it adds complication to us and
> > we need to keep up with the memory changes.
> 
> Well, "owning" doesn't really apply to any kernel code in any meaningful
> way.  I'm familiar with that corporate jargon in which "to own" means
> "to be responsible for" roughly, but even that is not applicable to kernel
> code, which is not owned by anyone in any form.

Right.  (I think I spent too long in a corporate world...)  

> The maintenance of kernel code is more like taking care of it and there are
> no hard rules about who should or should not be maintaining this or that
> piece of it.
> 
> I could maintain that driver just fine, so that's not really an issue.

Well, I mentioned it because I thought you had concerned about it in
your earlier reply below.  I agree this is a non-issue as you do not see
as an issue. :)
https://lkml.org/lkml/2013/3/26/198

> >  - Rollback: As offline/online proceeds on each memblk, the driver has
> > to support rollback when one of memblks failed to offline.  This seems
> > to against the direction of this approach (no rollback in the kernel).
> 
> Depending on what you mean by "rollback".  Technically, if one memblk
> fails to offline, there's no need to online the other memblks that have
> been offlined already in the same group.  They very well can stay online.
> 
> Yes, it would be convenient to online them back to have a well-defined state
> after a failing attempt to offline stuff, but that's not a correctness issue.

This new device represents a single device to users, but is associated
with a set of memblks internally.  If an end result is some memblks
online and some off-line, I wonder how we represent the state of this
device...

> >  - Ordering issue: Creating symbolic links among 3 types of devices
> > (PNP0C80, memblk, new physical device) further complicates the ordering
> > issue. 
> 
> That's a valid one.  But do we need to link the new device to memblks in
> sysfs?

It depends on how well this new device can abstract internal memblks.
For instance, if a new device may have a mixed state (some memblks
online and some offline), it may need to link to the memblks so that
each memblk state can be managed.  The memblk interface also has other
attribute, such as movable and non-movable.

> >  - Representation: PNP0C80:X represents the state of an ACPI PNP0C80
> > device.  memoryN represents the state of a memblk.  It is not clear what
> > this new physical device really represents when there isn't such device
> > visible to users.  It may be seen as duplication.
> 
> Yes, it may.  That said, I'm not exactly sure why memblks are regarded as
> a good way to represent hot-removable memory.  It looks like they are
> arbitrary stuff without any relationship to real hardware.  And that's where
> the source of the problem is, IMHO.

I think it is designed to keep it platform-neutral.  I do not think it
is regarded as a good way to represent hot-removable memory for regular
users.

> In any case, ACPI PNP0C80:X should not be regarded as a *device*.  It just
> is an interface to a platform mechanism allowing us to do something to a real
> device (e.g. eject it), but it is not that device in general.

I agree.  I do not think PNP0C80:X is good for regular users, either.

> > Frankly, if we are to provide a good sysfs UI for hot-delete, I'd prefer
> > to go with my updated patchset, which keeps user to allow doing "echo 1
> > > PNP0C80:X/eject", and all associated memblks will be offlined
> > together.
> 
> Which isn't correct.  Memory offline shouldn't be associated with an ACPI
> device object, because that operation doesn't belong there (eject should
> live there, not offline).

I actually meant to say ACPI eject notification, not the sysfs eject of
PNP0C80X, as their requests are handled in the same way.

> > I think the user space approach will require good management
> > tools to take care of the UI issue, and the kernel just has to provide
> > the necessary info to the user space, which this patch is intended.
> 
> No doubt about that, but the question is how to provide that information.

There are basically 3 ways for users to manage memory hotplug
operations.  Let's look at them to see what we need.  In comparison, (U)
refers to the user space approach (user has to offline first), and (K)
refers to the kernel approach (the kernel does both offline and eject).

1. Management Console (ACPI notifications)
Platforms that support ACPI memory hotplug will support ACPI
notifications to initiate hot-add and hot-delete operations from the
management console (or doorbells, host CLIs for VMs).  It has the
platform knowledge, and does not depend on the kernel info to operate
(other than _OST).

(U) For hot-delete, users need to offline target memory beforehand by 2
or 3.  The management console is a single point of administration.

(K) Users can operate both hot-add and delete.  The kernel attempts to
offline upon the request.

2. Management Tool
Management tool can provide CLI/GUI to operate memory hot-add and
hot-delete.  The tool may interface to the management console and the
kernel.  The tool needs to have the hardware info in order to guide
users to a right target, which may be obtained from the management
console, predefined DB and sysfs.

(U) Management tool refers to ACPI PNP0C80:X devices to locate a right
target since they have _UID, _SUN and _STR, which identify their
hardware locations.  The tool also needs offline the memory associated
with a target PNP0C80;X, which can be done either by a new associated
device object or symbolic link to memblks in this patch.  In case of
memblks, the tool can perform rollback as necessary.  The tool then
ejects the target with sysfs eject of PNP0C80:X.

(K) Management tool sends a hotplug request through the management
console.  It may also interface with the kernel as necessary.

3. Sysfs
The sysfs interfaces can only support hot-delete & online/offline.
Users need to use 1 or 2 for hot-add.  It does not provide a single
point of administration.

(U) If designed properly, new device objects may help regular users to
find a right target to offline via sysfs.  Users can then eject it with
sysfs eject of PNP0C80 via a symbolic link.

(K) Users can request hot-delete with sysfs eject of PNP0C80:X.
However, it is unlikely that regular users can find a right target
without knowing what ACPI is.  

Thanks,
-Toshi

