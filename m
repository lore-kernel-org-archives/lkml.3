Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660Ab3CZMPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:15:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42742 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab3CZMPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:15:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [Update 4][PATCH 2/7] ACPI / scan: Introduce common code for ACPI-based device hotplug
Date: Tue, 26 Mar 2013 13:22:44 +0100
Message-ID: <9614919.jD6oB33NAX@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1364252231.11659.99.camel@misato.fc.hp.com>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan> <2776997.5VXf3okT8O@vostro.rjw.lan> <1364252231.11659.99.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 25, 2013 04:57:11 PM Toshi Kani wrote:
> On Mon, 2013-03-25 at 23:29 +0100, Rafael J. Wysocki wrote:
> > On Monday, March 25, 2013 02:45:36 PM Toshi Kani wrote:
> > > On Fri, 2013-03-15 at 11:47 +0100, Vasilis Liaskovitis wrote:
> > > > Hi,
> > > > 
> > > > On Thu, Mar 14, 2013 at 06:16:30PM +0100, Rafael J. Wysocki wrote:
> > > > > Sorry for the sluggish response, I've been travelling recently. ->
> > > > [...]
> > > > > > > > So, I'd suggest the following changes.
> > > > > > > >  - Remove the "uevents" attribute.  KOBJ_ONLINE/OFFLINE are not used for
> > > > > > > > ACPI device objects.
> > > > > > > >  - Make the !autoeject case as an exception for now, and emit
> > > > > > > > KOBJ_OFFLINE as a way to request off-lining to user.  This uevent is
> > > > > > > > tied with the !autoeject case.  We can then revisit if this use-case
> > > > > > > > needs to be supported going forward.  If so, we may want to consider a
> > > > > > > > different event type.
> > > > > > > 
> > > > > > > Well, what about avoiding to expose uevents and autoeject for now and
> > > > > > > exposing enabled only?  Drivers would still be able to set the other flags on
> > > > > > > init on init to enforce the backwards-compatible behavior.
> > > > > > 
> > > > > > Now that we don't define uevents and autoeject in v2 of this series, could you
> > > > > > explain how we get safe ejection from userspace e.g. for memory hot-remove? What
> > > > > > are the other flags drivers can use (on init?) to avoid autoeject and only issue
> > > > > > KOBJ_OFFLINE?
> > > > > > 
> > > > > > > 
> > > > > > > I agree that it would be sufficient to use one additional flag then, to start
> > > > > > > with, but its meaning would be something like "keep backwards compatibility
> > > > > > > with the old container driver", so perhaps "autoeject" is not a good name.
> > > > > > > 
> > > > > > > What about "user_eject" (that won't be exposed to user space) instead?  Where,
> > > > > > > if set, it would meand "do not autoeject and emit KOBJ_OFFLINE/ONLINE uevents
> > > > > > > like the old container driver did"?
> > > > > > 
> > > > > > I don't see user_eject in v2. Is it unnecessary for userspace ejection control
> > > > > > or planned for later? Also why shouldn't it be exposed to userpace?
> > > > > 
> > > > > -> At this point we are not sure if it is necessary to have an attribute for
> > > > > direct ejection control.  Since the plan is to have a separate offline/online
> > > > > attribute anyway (and a check preventing us from ejecting things that haven't
> > > > > been put offline), it is not clear how useful it is going to be to control
> > > > > ejection directly from user space.
> > > > 
> > > > ok.
> > > > Regarding the offline/online attribute and ejection prevention checking, do you
> > > > mean the offline/online framework from Toshi:
> > > > http://thread.gmane.org/gmane.linux.kernel/1420262
> > > > or something else? I assume this is the long-term plan.
> > > 
> > > Unfortunately, the idea of adding a new set of common hotplug framework
> > > was not well-received.  Since the driver-core does not allow any eject
> > > failure case, integrating into the driver-core framework seems also
> > > impractical.
> > > 
> > > > Is there any other short-term solution planned? If i understand correctly, until
> > > > this framework is accepted, memory hot-remove is broken (=unsafe). 
> > > 
> > > That is correct.  The alternative plan is to go with an ACPI-specific
> > > approach that user has to off-line a target device and its children
> > > beforehand from sysfs before initiating a hot-delete request.  This
> > > hot-delete request will fail if any of the devices are still on-line.
> > > The sysfs online/offline interfaces may fail, and user (or user tool)
> > > has to take care of the rollback as necessary.  It would move all the
> > > error handling & rollback stuff into the user space, and make the kernel
> > > part very simple & straightforward -- just delete target device
> > > objects.  
> > > 
> > > After looking further, however, I think this isn't the case...  In case
> > > of memory hot-delete, for example, off-lining is only a part of the job
> > > done in remove_memory().  So, ACPI-core still needs to call
> > > device-specific handlers to perform device-specific hot-delete
> > > operations, such as calling remove_memory() or its sub-set function,
> > > which can fail when a device is online.  In order to make sure all
> > > devices stay off-line, we need to delete their sysfs interfaces.
> > 
> > No, we don't need to.
> > 
> > > Since we do not have a way to serialize all online/offline & hot-plug
> > > operations (the above patchset had such serialization, but did not get
> > > thru), we cannot change all devices at once but delete sysfs interface
> > > for each device one by one.  If it failed on one of the devices, we need
> > > to rollback to put them back into the original state.  Other implication
> > > is that this approach is not backward compatible.
> > 
> > No.  No rollbacks, please.
> > 
> > There are three things that are needed: (1) online/offline, (2) a flag in
> > struct acpi_device indicating whether or not the "physical" device represented
> > by that struct acpi_device has been offlined, 
> 
> acpi_device and its associated device(s) do not match 1 to 1.  For
> instance, a memory acpi_device usually associates with multiple memblks
> sysfs files, which can be individually on-lined / off-lined.  This
> association can be M:N matching.  I am not sure if the flag can be
> implemented easily.

If there are more "physical devices" associated with a single struct
acpi_device (which is entirely possible), then that needs to be a counter
rather than a flag.

> > and (3) a synchronization
> > mechanism that will make the manipulation of the flag and device eject mutually
> > exclusive (it actually would need to tie the manipulation of the flag to
> > the online/offline).
> 
> This needs to be a global lock that can serialize online/offline
> operations of all system devices.

Yes, it does, but we already have acpi_scan_lock that serializes all hotplug
operations on the ACPI level, so it won't add much overhead.  And as far as
memory is concerned, I really think it would be better not to offline two
things at a time anyway.

> > Then, acpi_scan_hot_remove() will only need to check, before it calls
> > acpi_bus_trim(), if all of the devices that correspond to the struct device
> > objects to be removed have been offlined.  Of course, it will have to ensure
> > that the "online/offline" status of any of those devices won't change while
> > it is running (hence, the synchronization mechanism).
> > 
> > And once everything has been offlined, there's no reason why the removal should
> > fail, right?
> 
> Yes, if we can introduce such global lock, we can prevent rollbacks.  I
> was under an assumption that we cannot make such changes to the common
> code.  

I believe we can add such a lock of online/offline operations.

> > > Given this, I am inclined to other alternative -- rework on my patchset
> > > and make it as ACPI device hotplug framework.
> > 
> > Please don't.
> 
> OK, I will keep it myself for now.  Are you going to make the code
> changes which you summarized?  I am hoping that we can make some
> improvement for 3.10.

Well, for now memory offline/online is missing and that's needed in the first
place regardless.  I'm not sure if I have the time to add it on time for the
v3.10 merge window, however, because I have two conferences to attend in the
meantime (where I'm going to speak) and some power management work to do.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
