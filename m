Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3KSRxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:53:34 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:45120 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3KSRxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:53:31 -0500
Message-ID: <1384883331.1791.23.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/3] ACPI / hotplug: Fix PCI host bridge hot removal
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Date: Tue, 19 Nov 2013 10:48:51 -0700
In-Reply-To: <1384816407.1791.19.camel@misato.fc.hp.com>
References: <2434673.zhjYZOTQ4A@vostro.rjw.lan>
	 <3206422.AfXMUDqMXZ@vostro.rjw.lan>
	 <1384798205.1791.14.camel@misato.fc.hp.com>
	 <11362197.FWMPl6Gp0A@vostro.rjw.lan>
	 <1384816407.1791.19.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-18 at 16:13 -0700, Toshi Kani wrote:
> On Mon, 2013-11-18 at 22:39 +0100, Rafael J. Wysocki wrote:
> > On Monday, November 18, 2013 11:10:05 AM Toshi Kani wrote:
> > > On Thu, 2013-11-14 at 00:16 +0100, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > Since the PCI host bridge scan handler does not set hotplug.enabled,
> > > > the check of it in acpi_bus_device_eject() effectively prevents the
> > > > root bridge hot removal from working after commit a3b1b1ef78cd
> > > > (ACPI / hotplug: Merge device hot-removal routines).  However, that
> > > > check is not necessary, because the other acpi_bus_device_eject()
> > > > users, acpi_hotplug_notify_cb and acpi_eject_store(), do the same
> > > > check by themselves before executing that function.
> > > > 
> > > > For this reason, remove the scan handler check from
> > > > acpi_bus_device_eject() to make PCI hot bridge hot removal work
> > > > again.
> > > 
> > > I am curious why the PCI host bridge scan handler does not set
> > > hotplug.enabled.  Is this how it disables hotplug via sysfs eject but
> > > enables via ACPI notification? 
> > 
> > It just doesn't register for hotplug at all.  I guess it could set that
> > bit alone, but then it would be quite confusing and the check is not
> > necessary anyway.
> 
> I see.  Given how the PCI host bridge scan handler is integrated today,
> the change looks reasonable to me.

Looking further, I noticed that there is one more issue to address.  The
patch below applies on top of your patchset.

Thanks,
-Toshi

====
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI / hotplug: Fix conflicted PCI bridge notify
handlers

The PCI host bridge scan handler installs its own notify handler,
handle_hotplug_event_root(), by itself.  Nevertheless, the ACPI
hotplug framework also installs the common notify handler,
acpi_hotplug_notify_cb(), for PCI root bridges.  This causes
acpi_hotplug_notify_cb() to call _OST method with unsupported
error as hotplug.enabled is not set.

To address this issue, introduce hotplug.self_install flag, which
indicates that the scan handler installs its own notify handler by
itself.  The ACPI hotplug framework does not install the common
notify handler when this flag is set.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/pci_root.c |    3 +++
 drivers/acpi/scan.c     |    2 +-
 include/acpi/acpi_bus.h |    1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 0703bff..ab52541 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -65,6 +65,9 @@ static struct acpi_scan_handler pci_root_handler = {
 	.ids = root_device_ids,
 	.attach = acpi_pci_root_add,
 	.detach = acpi_pci_root_remove,
+	.hotplug = {
+		.self_install = true,
+	},
 };
 
 static DEFINE_MUTEX(osc_lock);
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 337109d..ec95a19 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1772,7 +1772,7 @@ static void acpi_scan_init_hotplug(acpi_handle
handle, int type)
 	 */
 	list_for_each_entry(hwid, &pnp.ids, list) {
 		handler = acpi_scan_match_handler(hwid->id, NULL);
-		if (handler) {
+		if (handler && !handler->hotplug.self_install) {
 			acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 					acpi_hotplug_notify_cb, handler);
 			break;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 89c60b0..87c918e 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -100,6 +100,7 @@ enum acpi_hotplug_mode {
 struct acpi_hotplug_profile {
 	struct kobject kobj;
 	bool enabled:1;
+	bool self_install:1;
 	enum acpi_hotplug_mode mode;
 };
 


