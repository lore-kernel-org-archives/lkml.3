Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3FNXDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 19:03:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37812 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab3FNXDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 19:03:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org
Subject: Re: [BUGFIX 2/9] ACPIPHP: fix device destroying order issue when handling dock notification
Date: Sat, 15 Jun 2013 01:12:19 +0200
Message-ID: <1810932.VJ2T588VHL@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51BB3704.2050708@gmail.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com> <9088362.uF3gIllFWp@vostro.rjw.lan> <51BB3704.2050708@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 14, 2013 11:30:12 PM Jiang Liu wrote:
> On 06/14/2013 10:12 PM, Rafael J. Wysocki wrote:
> > On Friday, June 14, 2013 09:57:15 PM Jiang Liu wrote:
> >> On 06/14/2013 08:23 PM, Rafael J. Wysocki wrote:
> >>> On Thursday, June 13, 2013 09:59:44 PM Rafael J. Wysocki wrote:
> >>>> On Friday, June 14, 2013 12:32:25 AM Jiang Liu wrote:
> >>>>> Current ACPI glue logic expects that physical devices are destroyed
> >>>>> before destroying companion ACPI devices, otherwise it will break the
> >>>>> ACPI unbind logic and cause following warning messages:
> >>>>> [  185.026073] usb usb5: Oops, 'acpi_handle' corrupt
> >>>>> [  185.035150] pci 0000:1b:00.0: Oops, 'acpi_handle' corrupt
> >>>>> [  185.035515] pci 0000:18:02.0: Oops, 'acpi_handle' corrupt
> >>>>> [  180.013656]  port1: Oops, 'acpi_handle' corrupt
> >>>>> Please refer to https://bugzilla.kernel.org/attachment.cgi?id=104321
> >>>>> for full log message.
> >>>>
> >>>> So my question is, did we have this problem before commit 3b63aaa70e1?
> >>>>
> >>>> If we did, then when did it start?  Or was it present forever?
> >>>>
> >>>>> Above warning messages are caused by following scenario:
> >>>>> 1) acpi_dock_notifier_call() queues a task (T1) onto kacpi_hotplug_wq
> >>>>> 2) kacpi_hotplug_wq handles T1, which invokes acpi_dock_deferred_cb()
> >>>>>    ->dock_notify()-> handle_eject_request()->hotplug_dock_devices()
> >>>>> 3) hotplug_dock_devices() first invokes registered hotplug callbacks to
> >>>>>    destroy physical devices, then destroys all affected ACPI devices.
> >>>>>    Everything seems perfect until now. But the acpiphp dock notification
> >>>>>    handler will queue another task (T2) onto kacpi_hotplug_wq to really
> >>>>>    destroy affected physical devices.
> >>>>
> >>>> Would not the solution be to modify it so that it didn't spawn the other
> >>>> task (T2), but removed the affected physical devices synchronously?
> >>>>
> >>>>> 4) kacpi_hotplug_wq finishes T1, and all affected ACPI devices have
> >>>>>    been destroyed.
> >>>>> 5) kacpi_hotplug_wq handles T2, which destroys all affected physical
> >>>>>    devices.
> >>>>>
> >>>>> So it breaks ACPI glue logic's expection because ACPI devices are destroyed
> >>>>> in step 3 and physical devices are destroyed in step 5.
> >>>>>
> >>>>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> >>>>> Reported-by: Alexander E. Patrakov <patrakov@gmail.com>
> >>>>> Cc: Bjorn Helgaas <bhelgaas@google.com>
> >>>>> Cc: Yinghai Lu <yinghai@kernel.org>
> >>>>> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> >>>>> Cc: linux-pci@vger.kernel.org
> >>>>> Cc: linux-kernel@vger.kernel.org
> >>>>> Cc: stable@vger.kernel.org
> >>>>> ---
> >>>>> Hi Bjorn and Rafael,
> >>>>>      The recursive lock changes haven't been tested yet, need help
> >>>>> from Alexander for testing.
> >>>>
> >>>> Well, let's just say I'm not a fan of recursive locks.  Is that unavoidable
> >>>> here?
> >>>
> >>> What about the appended patch (on top of [1/9], untested)?
> >>>
> >>> Rafael
> >> It should have similar effect as patch 2/9, and it will encounter the
> >> same deadlock scenario as 2/9 too.
> > 
> > And why exactly?
> > 
> > I'm looking at acpiphp_disable_slot() and I'm not seeing where the
> > problematic lock is taken.  Similarly for power_off_slot().
> > 
> > It should take the ACPI scan lock, but that's a different matter.
> > 
> > Thanks,
> > Rafael
> The deadlock scenario is the same:

Well, you didn't answer my question.

>         hotplug_dock_devices()
>                 mutex_lock(&ds->hp_lock)
>                         dd->ops->handler()
> 				destroy pci bus

And this wasn't particularly helpful.

What about mentioning acpi_pci_remove_bus()?  I don't remember all changes
made recently, sorry.

>                                 	unregister_hotplug_dock_device()
>                                         	mutex_lock(&ds->hp_lock)

I see the problem.

ds->hp_lock is used to make both addition and removal of hotplug devices wait
for us to complete walking ds->hotplug_devices.  However, if we are in the
process of removing hotplug devices, we don't need removals to block on
ds->hp_lock (in fact, we don't even want them to block on it).  Conversely, if
we are in the process of adding hotplug devices, we don't want additions to
block on ds->hp_lock.

So, why don't we do the following:

(1) Introduce a 'hotplug_status' field into struct_dock station with possible
    values representing "removal", "addition" and "no action" and a wait queue
    associated with it.  We can use ds->dd_lock to protect that field.

(2) hotplug_status will be modified by hotplug_dock_devices() depending on the
    event.  For example, on eject it will set hotplug_status to "removal".
    Then, after completing the walk, it will reset hotplug_status to
    "no action" and wake up its wait queue.

(3) dock_del_hotplug_device() will check if hotplug_status is "removal" or
    "no_action" and if so, it will just do the removal under ds->dd_lock.  If
    it is "addition", though, it will go to sleep (in the hotplug_status' wait
    queue) until hotplug_dock_devices() wakes it up.

(4) Analogously for dock_add_hotplug_device().

For this to work the "addition" and "deletion" of hotplug devices should better
be implemented as setting and clearing a 'hotplug' flag in
struct dock_dependent_device (instead of using ds->hotplug_devices).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
