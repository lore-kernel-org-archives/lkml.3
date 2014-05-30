Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaE3COe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:14:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58320 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932276AbaE3COb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:14:31 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.garrett@nebula.com, mika.westerberg@linux.intel.com
Subject: [PATCH 6/10] ACPI / scan: Change the meaning of missing .attach() in scan handlers
Date: Fri, 30 May 2014 04:27:31 +0200
Message-ID: <15578215.2gMiGqcPEe@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <35042328.kk6ZUUdfyN@vostro.rjw.lan>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com> <35042328.kk6ZUUdfyN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Currently, some scan handlers can be compiled out entirely, which
leaves the device objects they normally attach to without a scan
handler.  This isn't a problem as long as we don't have any default
enumeration mechanism that applies to all devices without a scan
handler.  However, if such a default enumeration is added, it still
should not be applied to devices that are normally attached to by
scan handlers, because that may result in creating "physical" device
objects of a wrong type for them.

Since we are going to create platform device objects for all ACPI
device objects with pnp.type.platform_id set by default, clear
pnp.type.platform_id where there is a matching scan handler without
an .attach() callback and otherwise simply treat that scan handler
as though the .attach() callback was present but always returned 0.

This will allow us to compile out scan handler callbacks and leave
the device ID lists used by them so as to prevent creating platform
device objects for the matching ACPI devices.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -84,7 +84,7 @@ EXPORT_SYMBOL_GPL(acpi_initialize_hp_con
 
 int acpi_scan_add_handler(struct acpi_scan_handler *handler)
 {
-	if (!handler || !handler->attach)
+	if (!handler)
 		return -EINVAL;
 
 	list_add_tail(&handler->list_node, &acpi_scan_handlers_list);
@@ -2081,6 +2081,10 @@ static int acpi_scan_attach_handler(stru
 
 		handler = acpi_scan_match_handler(hwid->id, &devid);
 		if (handler) {
+			if (!handler->attach) {
+				device->pnp.type.platform_id = 0;
+				continue;
+			}
 			device->handler = handler;
 			ret = handler->attach(device, devid);
 			if (ret > 0)

