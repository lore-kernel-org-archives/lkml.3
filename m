Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaBSBTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:19:03 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59198 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752202AbaBSBSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:18:34 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 2/9] ACPI / hotplug: Add .fixup() callback to struct acpi_hotplug_context
Date: Wed, 19 Feb 2014 02:27:45 +0100
Message-ID: <3202096.sgetyLoJFZ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3011875.q18rCmXyYX@vostro.rjw.lan>
References: <3011875.q18rCmXyYX@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

In order for the ACPI dock station code to be able to use the
callbacks pointed to by the ACPI device objects' hotplug contexts
add a .fixup() callback pointer to struct acpi_hotplug_context.
That callback will be useful to handle PCI devices located in
dock stations.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |    2 +-
 include/acpi/acpi_bus.h            |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -146,6 +146,7 @@ struct acpi_scan_handler {
 struct acpi_hotplug_context {
 	struct acpi_device *self;
 	int (*event)(struct acpi_device *, u32);
+	void (*fixup)(struct acpi_device *);
 };
 
 /*
@@ -368,10 +369,12 @@ static inline void acpi_set_device_statu
 
 static inline void acpi_set_hp_context(struct acpi_device *adev,
 				       struct acpi_hotplug_context *hp,
-				       int (*event)(struct acpi_device *, u32))
+				       int (*event)(struct acpi_device *, u32),
+				       void (*fixup)(struct acpi_device *))
 {
 	hp->self = adev;
 	hp->event = event;
+	hp->fixup = fixup;
 	adev->hp = hp;
 }
 
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -80,7 +80,7 @@ static struct acpiphp_context *acpiphp_i
 		return NULL;
 
 	context->refcount = 1;
-	acpi_set_hp_context(adev, &context->hp, acpiphp_hotplug_event);
+	acpi_set_hp_context(adev, &context->hp, acpiphp_hotplug_event, NULL);
 	return context;
 }
 

