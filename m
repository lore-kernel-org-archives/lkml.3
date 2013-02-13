Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298Ab3BMXgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:36:01 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38024 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab3BMXf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:35:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Myron Stowe <mstowe@redhat.com>, linux-pci@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: Re: [Update][PATCH] ACPI / hotplug: Fix concurrency issues and memory leaks
Date: Thu, 14 Feb 2013 00:42:25 +0100
Message-ID: <5284026.QPQbFciqVT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1360796969.3869.146.camel@misato.fc.hp.com>
References: <1837481.7dT8hTZ4MT@vostro.rjw.lan> <4594350.VXNmDOeCvt@vostro.rjw.lan> <1360796969.3869.146.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 13, 2013 04:09:29 PM Toshi Kani wrote:
> On Wed, 2013-02-13 at 21:52 +0100, Rafael J. Wysocki wrote:
> > On Wednesday, February 13, 2013 10:43:58 AM Toshi Kani wrote:
> > > On Wed, 2013-02-13 at 14:16 +0100, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > This changeset is aimed at fixing a few different but related
> > > > problems in the ACPI hotplug infrastructure.
> > > > 
> > > > First of all, since notify handlers may be run in parallel with
> > > > acpi_bus_scan(), acpi_bus_trim() and acpi_bus_hot_remove_device()
> > > > and some of them are installed for ACPI handles that have no struct
> > > > acpi_device objects attached (i.e. before those objects are created),
> > > > those notify handlers have to take acpi_scan_lock to prevent races
> > > > from taking place (e.g. a struct acpi_device is found to be present
> > > > for the given ACPI handle, but right after that it is removed by
> > > > acpi_bus_trim() running in parallel to the given notify handler).
> > > > Moreover, since some of them call acpi_bus_scan() and
> > > > acpi_bus_trim(), this leads to the conclusion that acpi_scan_lock
> > > > should be acquired by the callers of these two funtions rather by
> > > > these functions themselves.
> > > > 
> > > > For these reasons, make all notify handlers that can handle device
> > > > addition and eject events take acpi_scan_lock and remove the
> > > > acpi_scan_lock locking from acpi_bus_scan() and acpi_bus_trim().
> > > > Accordingly, update all of their users to make sure that they
> > > > are always called under acpi_scan_lock.
> > > > 
> > > > Furthermore, since eject operations are carried out asynchronously
> > > > with respect to the notify events that trigger them, with the help
> > > > of acpi_bus_hot_remove_device(), even if notify handlers take the
> > > > ACPI scan lock, it still is possible that, for example,
> > > > acpi_bus_trim() will run between acpi_bus_hot_remove_device() and
> > > > the notify handler that scheduled its execution and that
> > > > acpi_bus_trim() will remove the device node passed to
> > > > acpi_bus_hot_remove_device() for ejection.  In that case, the struct
> > > > acpi_device object obtained by acpi_bus_hot_remove_device() will be
> > > > invalid and not-so-funny things will ensue.  To protect agaist that,
> > > > make the users of acpi_bus_hot_remove_device() run get_device() on
> > > > ACPI device node objects that are about to be passed to it and make
> > > > acpi_bus_hot_remove_device() run put_device() on them and check if
> > > > their ACPI handles are not NULL (make acpi_device_unregister() clear
> > > > the device nodes' ACPI handles for that check to work).
> > > > 
> > > > Finally, observe that acpi_os_hotplug_execute() actually can fail,
> > > > in which case its caller ought to free memory allocated for the
> > > > context object to prevent leaks from happening.  It also needs to
> > > > run put_device() on the device node that it ran get_device() on
> > > > previously in that case.  Modify the code accordingly.
> > > 
> > > I am concerned with this approach.  ACPICA calls notify handlers through
> > > kacpi_notify_wq, which has the max active set to 1.  We then use
> > > kacpi_hotplug_wq (which also has the max active set to 1) so that a
> > > hotplug procedure does not block the notify handlers since they can be
> > > used for non-hotplug events as well.
> > 
> > In fact we use kacpi_hotplug_wq for a different reason.  Please read the
> > comment in __acpi_os_execute() for more details.
> 
> Yes, I am aware of the issue as well.
> 
> > > Acquiring the scan lock in a notify handler means that a hotplug procedure
> > > can block any notify events.
> > 
> > Yes, it can.
> > 
> > > So, I'd prefer the following approach.
> > > 
> > >  - Change all hot-plug procedures (i.e. both add and delete) to proceed
> > > under kacpi_hotplug_wq by calling acpi_os_hotplug_execute(). This
> > > serializes all hotplug procedures, and prevents blocking other notify
> > > events.
> > 
> > Yes, we can do that.  I was thinking about doing that change, but not in v3.9.
> > There are simply too many notify handlers already there to do that so late in
> > the cycle.  And doing that for acpiphp, for example, won't be straightforward
> > at all.
> 
> Right.  I was not suggesting this approach for v3.9.

OK

> > Please think about the $subject patch as a temporary measure until we can do
> > something better (which we need to do anyway to reduce code duplication among
> > other things).
> 
> I am fine with the scan lock as long as it is internal.  This patch
> publishes the locking interfaces to other modules, which made me worried
> that this might become a long term solution.  If we need to fix this
> issue for v3.9, I am OK with it as you clarified this as a temporary
> solution.

Yes, I'm not going to allow anyone to use acpi_scan_lock anywhere else. :-)
I'm also going to make it internal again in v3.10 if possible.

> > > (Ideally, we should also run all online/offline procedures
> > > under a same work-queue, just like my RFC patchset did, but this is a
> > > different topic for now.)
> > 
> > No, I don't think it is appropriate to run online/offline from _any_
> > workqueue.  In my opinion they should be run from user space.
> 
> I think there are pros and cons for this.  If we use a user thread to
> run online/offline procedure, we can return a result directly.  However,
> if an operation takes a long time, it will block the user thread until
> it is done.  In addition, we have race conditions between hotplug and
> online/offline operations.  So, we may need to come up with other type
> of locking if we do not use a workqueue to address it.  Having both the
> scan lock and other lock in the callers would not be good.

Well, we definitely need to make offline/online and hotplug mutually exclusive,
this way or another.  I'm hoping that the scan lock will be sufficient for
that, but I may be wrong.

> > >  - Revert 5993c4670 unless this change is absolutely necessary.  From
> > > the change log, it is not clear to me why this change was needed.  It
> > > changed acpi_bus_hot_remove_device() to take an acpi_device, instead of
> > > an acpi_handle, which introduced a race condition with acpi_device.
> > > acpi_bus_hot_remove_device() should take an acpi_handle, and then obtain
> > > its acpi_device from the acpi_handle since this function is serialized.
> > 
> > I thought about that, but actually there's no guarantee that the handle
> > will be valid after _EJ0 as far as I can say.  So the race condition is
> > going to be there anyway and using struct acpi_device just makes it easier
> > to avoid it.
> 
> In theory, yes, a stale handle could be a problem, if _EJ0 performs
> unload table and if ACPICA frees up its internal data structure pointed
> by the handle as a result.  But we should not see such issue now since
> we do not support dynamic ACPI namespace yet.

I'm waiting for information from Bob about that.  If we can assume ACPI handles
to be always valid, that will simplify things quite a bit.

> > >  - Remove sanity checks with an acpi_device in the notify handlers,
> > > which have a race condition with acpi_device.  These type-specific
> > > checks will need to be removed when we have a common notify handler
> > > anyway.  The notify handler can continue to check the status of ACPI
> > > device object with an acpi_handle.  Type-specific sanity checks /
> > > validations can be performed within a hotplug procedure, instead.
> > 
> > Well, the sanest approach here would be to queue up a work item on
> > kacpi_hotplug_wq if the event is of a "hotplug" type and let that work
> > item do all checks, run acpi_bus_scan() etc.  But not in v3.9.
> 
> Agreed, and that's what I meant.
> 
> > For v3.9, the most straightforward and least intrusive change we can do
> > is the $subject patch as far as I can say.  If you can suggest something
> > less intrusive and more straightforward, please do.
> 
> My suggestion is to keep the scan lock internal for v3.9 and implement a
> new hotplug framework (i.e. the one with user space approach) for v3.10
> with a proper locking mechanism.  But, since you clarified this as a
> temporary solution, I am OK with it if we need to fix it now.

Well, honestly, I wouldn't have posted this patch if I hadn't thought that we
needed a fix for v3.9. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
