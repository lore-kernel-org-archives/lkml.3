Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3AZSms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 13:42:48 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:59774 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3AZSmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 13:42:44 -0500
Message-ID: <5104239E.9050406@gmail.com>
Date: Sun, 27 Jan 2013 02:42:38 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] ACPI scan handlers
References: <1873429.MS5RQDxTye@vostro.rjw.lan>
In-Reply-To: <1873429.MS5RQDxTye@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 08:26 AM, Rafael J. Wysocki wrote:
> Hi All,
> 
> There is a considerable amount of confusion in the ACPI subsystem about what
> ACPI drivers are used for.  Namely, some of them are used as "normal" device
> drivers that bind to devices and handle them using ACPI control methods (like
> the fan or battery drivers), but some of them are just used for handling
> namespace events, such as the creation or removal of device nodes (I guess it
> would be fair to call that an abuse of the driver core).  These two roles are
> quite distinct, which is particularly visible from the confusion about the role
> of the .remove() callback.
> 
> For the "normal" drivers this callback is simply used to handle situations in
> which the driver needs to be unbound from the device, because one of them
> (either the device or the driver) is going away.  That operation can't really
> fail, it just needs to do the necessary cleanup.
> 
> However, for the namespace events handling "drivers" .remove() means that not
> only the device node in question, but generally also the whole subtree below it
> needs to be prepared for removal, which may involve deleting multiple device
> objects belonging to different bus types and so on and which very well may fail
> (for example, those devices may be used for such things like swap or they may be
> memory banks used by the kernel and it may not be safe to remove them at the
> moment etc.).  Moreover, for these things the removal of the "driver" doesn't
> really make sense, because it has to be there to handle the namespace events it
> is designed to handle or else things will go remarkably awry in some places.
> 
> To resolve all that mess I'd like to do the following, which in part is inspired
> by the recent Toshi Kani's hotplug framework proposal and in part is based on
> some discussions I had with Bjorn and others (the code references made below are
> based on the current contens of linux-pm.git/linux-next).
Hi Rafael,
	Great to know that you plan to clean up these messes. We are working on
the same topic too.

> 
> 1) Introduce a special data type for "ACPI namespace event handlers" like:
> 
> struct acpi_scan_handler {
> 	const struct acpi_device_id *ids;
> 	struct list_head list_node;
> 	int (*attach)(struct acpi_device *adev);
> 	int (*untie)(struct acpi_device *adev);
> 	int (*reclaim)(struct acpi_device *adev);
> 	void (*detach)(struct acpi_device *adev);
> };
> 
>   an additional ACPI device flag:
> 
> struct acpi_device_flags {
> ...
> 	u32 untied:1;
> ...
> };
> 
>   and an additioanl field in struc acpi_device:
> 
> struct acpi_device {
> ...
> 	struct acpi_scan_handler *scan_handler;
> ...
> };
> 
>   (the roles of these things are described below).
> 
> 2) Introduce a list of struct acpi_scan_handler objects within the ACPI
>    subsystem such that acpi_bus_device_attach() will search that list first and
>    if there's a matching object (one whose ids match the device node), it will
>    run that object's .attach() callback.
> 
>   If that returns 1, it will mean that the handler has claimed the device node
>   and is now responsible for it until its .detach() callback is run.  Thus no
>   driver can be bound to that device node and no other handler can claim it.
>   Then, the device node's scan_handler field will be set to point to the handler
>   that's claimed it and its untied flag will be cleared.
> 
>   If .attach() returns 0, it will mean that the handler has not recognized the
>   device node and some other scan handlers and/or drivers may be tried for it.
This doesn't seem perfect. The device enumeration logic still interferes with
device drivers. Should we totally separate device enumeration logic from device
drivers?

> 
>   If an error code is returned, it will mean a hard error in which case the
>   scanning of the namespace will have to be aborted.
> 
>   This way ACPI drivers will only be bound to device nodes that haven't been
>   claimed by any scan handlers.
> 
> 3) Introduce an additional function following the format of acpi_bus_trim(),
>    say acpi_bus_untie(), that will walk the namespace starting at the given
>    device node and execute the .untie() callbacks from the scan handlers of
>    all devices as post-order callbacks.
> 
>    If the .untie() callback for the given device node returns 0, it will mean
>    that it is now safe to delete that node as long as its scan handler's
>    .detach() callback is executed before the deletion.  In that case, the device
>    node's untied flag will be set.
> 
>    Otherwise (i.e. if an error code is returned), it will mean that the scan
>    handler has vetoed the untying and the whole operation should be reversed.
>    Then, acpi_bus_untie() will walk the namespace again and execute the
>    .reclaim() callbacks from the scan handlers of the device nodes whose untied
>    flags are set as pre-order callbacks.
> 
>    If .reclaim() returns 0, the device node's untied flag will be cleared, and
>    if an error code is returned, it will remain set.
> 
>    This will allow us to prepare the subtree below the given device node for
>    removal in a reversible way, if needed.  Still, though, it will be possible
>    to carry out a forcible removal calling acpi_bus_trim() after
>    acpi_bus_untie() even if that has returned an error code (or even
>    acpi_bus_trim() without acpi_bus_untie()).
> 
> 4) Make acpi_bus_device_detach() execute the .detach() callback from the
>    scan handler of the device node (if the scan handler is present) and clear
>    its scan_handler field along with its untied flag.  However, the untied flags
>    will only be cleared after executing the .detach() callbacks, so that those
>    callbacks can see whether or not the scan handlers have been successfully
>    "untied" from the device nodes.
> 
> 5) Make acpi_bus_hot_remove_device() (and other pieces of code where that is
>    convenient) call acpi_bus_untie() before acpi_bus_trim() and bail out
>    cleanly if the untying fails (i.e. is vetoed by one of the scan handlers).
> 
> That should take care of the removal problem nicely and as far as I can say
> the majority of the ACPI drivers used only for handling namespace events can
> be readily converted to struct acpi_scan_handler objects.
> 
> I wonder if anyone is seeing any major problems with this at the high level.
This design has some conflicts with our ongoing work to provide a system device
hotplug framework. I will send out the draft framework for comments soon.

Thanks!
Gerry

> 
> Thanks,
> Rafael
> 
> 

