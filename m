Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3KSX4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:56:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60874 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752961Ab3KSX4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:56:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/3] ACPI / hotplug: Fix PCI host bridge hot removal
Date: Wed, 20 Nov 2013 01:08:57 +0100
Message-ID: <2499259.JLRCUgMzrL@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <3445730.IkUyvGUQQp@vostro.rjw.lan>
References: <2434673.zhjYZOTQ4A@vostro.rjw.lan> <1384898320.1791.48.camel@misato.fc.hp.com> <3445730.IkUyvGUQQp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 20, 2013 12:42:28 AM Rafael J. Wysocki wrote:
> On Tuesday, November 19, 2013 02:58:40 PM Toshi Kani wrote:
> > On Tue, 2013-11-19 at 22:10 +0100, Rafael J. Wysocki wrote:
> > > > On Tuesday, November 19, 2013 10:48:51 AM Toshi Kani wrote:
> > > > > On Mon, 2013-11-18 at 22:39 +0100, Rafael J. Wysocki wrote:
> > > > > > On Monday, November 18, 2013 11:10:05 AM Toshi Kani wrote:
> > > > > > > On Thu, 2013-11-14 at 00:16 +0100, Rafael J. Wysocki wrote:
> > > > > > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > > > 
> > > > > > > > Since the PCI host bridge scan handler does not set hotplug.enabled,
> > > > > > > > the check of it in acpi_bus_device_eject() effectively prevents the
> > > > > > > > root bridge hot removal from working after commit a3b1b1ef78cd
> > > > > > > > (ACPI / hotplug: Merge device hot-removal routines).  However, that
> > > > > > > > check is not necessary, because the other acpi_bus_device_eject()
> > > > > > > > users, acpi_hotplug_notify_cb and acpi_eject_store(), do the same
> > > > > > > > check by themselves before executing that function.
> > > > > > > > 
> > > > > > > > For this reason, remove the scan handler check from
> > > > > > > > acpi_bus_device_eject() to make PCI hot bridge hot removal work
> > > > > > > > again.
> > > > > > > 
> > > > > > > I am curious why the PCI host bridge scan handler does not set
> > > > > > > hotplug.enabled.  Is this how it disables hotplug via sysfs eject but
> > > > > > > enables via ACPI notification?
> > > > > > 
> > > > > > It just doesn't register for hotplug at all.  I guess it could set that
> > > > > > bit alone, but then it would be quite confusing and the check is not
> > > > > > necessary anyway.
> > > > > 
> > > > > I see.  Given how the PCI host bridge scan handler is integrated today,
> > > > > the change looks reasonable to me.
> > > > 
> > > > Looking further, I noticed that there is one more issue to address.  The
> > > > patch below applies on top of your patchset.
> > > >
> > > > From: Toshi Kani <toshi.kani@hp.com>
> > > > Subject: [PATCH] ACPI / hotplug: Fix conflicted PCI bridge notify
> > > > handlers
> > > > 
> > > > The PCI host bridge scan handler installs its own notify handler,
> > > > handle_hotplug_event_root(), by itself.  Nevertheless, the ACPI
> > > > hotplug framework also installs the common notify handler,
> > > > acpi_hotplug_notify_cb(), for PCI root bridges.  This causes
> > > > acpi_hotplug_notify_cb() to call _OST method with unsupported
> > > > error as hotplug.enabled is not set.
> > > > 
> > > > To address this issue, introduce hotplug.self_install flag, which
> > > > indicates that the scan handler installs its own notify handler by
> > > > itself.  The ACPI hotplug framework does not install the common
> > > > notify handler when this flag is set.
> > > 
> > > Good catch!
> > > 
> > > Still, I don't think we need a new flag, because we know that that
> > > scan handler doesn't support hotplug, because its hotplug profile
> > > hasn't been registered (that actually applies to all scan handlers
> > > without hotplug support, not only the root host bridge).  
> > 
> > When a scan handler does not support hotplug at all, the common notify
> > handler should be installed so that it can call _OST with an appropriate
> > response.
> 
> That creates an arbitrary difference between devices that have scan handlers
> and devices that don't have them (PCI, USB, SATA etc).  So if we want _OST
> to be called for all devices for which hotplug is not supported, that
> should be implemented in a different way and not necessarily in 3.13.
> 
> > > Moreover,
> > > if it does support hotplug, but the hotplug profile hasn't been
> > > registered due to an error, we still should not install the notify
> > > handler I think.  
> > 
> > This case, I think the common notify handler should be installed so that
> > it can call _OST for error response as well.  The question is what to do
> > when a scan handler has its own notify handler.

Actually, having considered this particular case a bit more I think that it
is useful to install acpi_hotplug_notify_cb() for things whose scan handlers
register hotplug support, but the registration fails (which should be treated
as "permanently disabled").

However, I still think that devices whose scan handlers don't support hotplug
at all should be treated consistently with devices without scan handlers.

So, what about the slightly modified patch below?

Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / hotplug: Ignore notifications for scan handlers without hotplug

If a scan handler's hotplug profile has not been initialized, do not
install acpi_hotplug_notify_cb() as a notify handler for devices
with the given scan handler attached.

This fixes a problem with the PCI host bridge hotplug which installs
its own notify handler, handle_hotplug_event_root(), by itself and
doesn't register its scan handler's hotplug profile.  Toshi says:

"Nevertheless, the ACPI hotplug framework also installs the common
 notify handler, acpi_hotplug_notify_cb(), for PCI root bridges.
 This causes acpi_hotplug_notify_cb() to call _OST method with
 unsupported error as hotplug.enabled is not set."

Moreover, the default behavior for all devices that don't have any
scan handlers attached is not to install notify handlers for them
and there is no difference between this case and the case when
a device's scan handler doesn't support hotplug.

Reported-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 3.9+ <stable@vger.kernel.org> # 3.9+
---
 drivers/acpi/scan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -84,6 +84,11 @@ int acpi_scan_add_handler_with_hotplug(s
 	return 0;
 }
 
+static bool acpi_scan_handler_with_hotplug(struct acpi_scan_handler *handler)
+{
+	return handler && handler->hotplug.kobj.state_initialized;
+}
+
 /*
  * Creates hid/cid(s) string needed for modalias and uevent
  * e.g. on a device with hid:IBM0001 and cid:ACPI0001 you get:
@@ -1841,7 +1846,7 @@ static void acpi_scan_init_hotplug(acpi_
 	 */
 	list_for_each_entry(hwid, &pnp.ids, list) {
 		handler = acpi_scan_match_handler(hwid->id, NULL);
-		if (handler) {
+		if (acpi_scan_handler_with_hotplug(handler)) {
 			acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 					acpi_hotplug_notify_cb, handler);
 			break;

