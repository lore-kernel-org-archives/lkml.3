Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab3CYU47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:56:59 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:15467 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3CYU45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:56:57 -0400
Message-ID: <1364244336.11659.75.camel@misato.fc.hp.com>
Subject: Re: [Update 4][PATCH 2/7] ACPI / scan: Introduce common code for
 ACPI-based device hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Date: Mon, 25 Mar 2013 14:45:36 -0600
In-Reply-To: <20130315104732.GA4401@dhcp-192-168-178-175.profitbricks.localdomain>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan>
	 <18666371.hyHAvqrdQ6@vostro.rjw.lan>
	 <20130304131023.GA4561@dhcp-192-168-178-175.profitbricks.localdomain>
	 <3390139.KZuRkSrE4e@vostro.rjw.lan>
	 <20130315104732.GA4401@dhcp-192-168-178-175.profitbricks.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 11:47 +0100, Vasilis Liaskovitis wrote:
> Hi,
> 
> On Thu, Mar 14, 2013 at 06:16:30PM +0100, Rafael J. Wysocki wrote:
> > Sorry for the sluggish response, I've been travelling recently. ->
> [...]
> > > > > So, I'd suggest the following changes.
> > > > >  - Remove the "uevents" attribute.  KOBJ_ONLINE/OFFLINE are not used for
> > > > > ACPI device objects.
> > > > >  - Make the !autoeject case as an exception for now, and emit
> > > > > KOBJ_OFFLINE as a way to request off-lining to user.  This uevent is
> > > > > tied with the !autoeject case.  We can then revisit if this use-case
> > > > > needs to be supported going forward.  If so, we may want to consider a
> > > > > different event type.
> > > > 
> > > > Well, what about avoiding to expose uevents and autoeject for now and
> > > > exposing enabled only?  Drivers would still be able to set the other flags on
> > > > init on init to enforce the backwards-compatible behavior.
> > > 
> > > Now that we don't define uevents and autoeject in v2 of this series, could you
> > > explain how we get safe ejection from userspace e.g. for memory hot-remove? What
> > > are the other flags drivers can use (on init?) to avoid autoeject and only issue
> > > KOBJ_OFFLINE?
> > > 
> > > > 
> > > > I agree that it would be sufficient to use one additional flag then, to start
> > > > with, but its meaning would be something like "keep backwards compatibility
> > > > with the old container driver", so perhaps "autoeject" is not a good name.
> > > > 
> > > > What about "user_eject" (that won't be exposed to user space) instead?  Where,
> > > > if set, it would meand "do not autoeject and emit KOBJ_OFFLINE/ONLINE uevents
> > > > like the old container driver did"?
> > > 
> > > I don't see user_eject in v2. Is it unnecessary for userspace ejection control
> > > or planned for later? Also why shouldn't it be exposed to userpace?
> > 
> > -> At this point we are not sure if it is necessary to have an attribute for
> > direct ejection control.  Since the plan is to have a separate offline/online
> > attribute anyway (and a check preventing us from ejecting things that haven't
> > been put offline), it is not clear how useful it is going to be to control
> > ejection directly from user space.
> 
> ok.
> Regarding the offline/online attribute and ejection prevention checking, do you
> mean the offline/online framework from Toshi:
> http://thread.gmane.org/gmane.linux.kernel/1420262
> or something else? I assume this is the long-term plan.

Unfortunately, the idea of adding a new set of common hotplug framework
was not well-received.  Since the driver-core does not allow any eject
failure case, integrating into the driver-core framework seems also
impractical.

> Is there any other short-term solution planned? If i understand correctly, until
> this framework is accepted, memory hot-remove is broken (=unsafe). 

That is correct.  The alternative plan is to go with an ACPI-specific
approach that user has to off-line a target device and its children
beforehand from sysfs before initiating a hot-delete request.  This
hot-delete request will fail if any of the devices are still on-line.
The sysfs online/offline interfaces may fail, and user (or user tool)
has to take care of the rollback as necessary.  It would move all the
error handling & rollback stuff into the user space, and make the kernel
part very simple & straightforward -- just delete target device
objects.  

After looking further, however, I think this isn't the case...  In case
of memory hot-delete, for example, off-lining is only a part of the job
done in remove_memory().  So, ACPI-core still needs to call
device-specific handlers to perform device-specific hot-delete
operations, such as calling remove_memory() or its sub-set function,
which can fail when a device is online.  In order to make sure all
devices stay off-line, we need to delete their sysfs interfaces.  Since
we do not have a way to serialize all online/offline & hot-plug
operations (the above patchset had such serialization, but did not get
thru), we cannot change all devices at once but delete sysfs interface
for each device one by one.  If it failed on one of the devices, we need
to rollback to put them back into the original state.  Other implication
is that this approach is not backward compatible.

Given this, I am inclined to other alternative -- rework on my patchset
and make it as ACPI device hotplug framework.  All changes are within
ACPI.  This actually requires less work and provides backward
compatibility as well.  I have finished prototyping and is working well.
I will send it out for review after all testing is done.

Thanks,
-Toshi

