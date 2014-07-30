Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbaG3MlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:41:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36648 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768AbaG3MP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 05/94] ACPI / resources: only reject zero length resources based at address zero
Date: Wed, 30 Jul 2014 14:13:54 +0200
Message-Id: <cff580582497c28eda54c9136b0f24dfcaa54c39.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 867f9d463b82462793ea4610e748be0b04b37fc7 upstream.

The recently merged change (in v3.14-rc6) to ACPI resource detection
(below) causes all zero length ACPI resources to be elided from the
table:

  commit b355cee88e3b1a193f0e9a81db810f6f83ad728b
  Author: Zhang Rui <rui.zhang@intel.com>
  Date:   Thu Feb 27 11:37:15 2014 +0800

    ACPI / resources: ignore invalid ACPI device resources

This change has caused a regression in (at least) serial port detection
for a number of machines (see LP#1313981 [1]).  These seem to represent
their IO regions (presumably incorrectly) as a zero length region.
Reverting the above commit restores these serial devices.

Only elide zero length resources which lie at address 0.

Fixes: b355cee88e3b (ACPI / resources: ignore invalid ACPI device resources)
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: 3.14+ <stable@vger.kernel.org> # 3.14+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/resource.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 0bdacc5e26a3..2ba8f02ced36 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -77,7 +77,7 @@ bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
 	switch (ares->type) {
 	case ACPI_RESOURCE_TYPE_MEMORY24:
 		memory24 = &ares->data.memory24;
-		if (!memory24->address_length)
+		if (!memory24->minimum && !memory24->address_length)
 			return false;
 		acpi_dev_get_memresource(res, memory24->minimum,
 					 memory24->address_length,
@@ -85,7 +85,7 @@ bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
 		break;
 	case ACPI_RESOURCE_TYPE_MEMORY32:
 		memory32 = &ares->data.memory32;
-		if (!memory32->address_length)
+		if (!memory32->minimum && !memory32->address_length)
 			return false;
 		acpi_dev_get_memresource(res, memory32->minimum,
 					 memory32->address_length,
@@ -93,7 +93,7 @@ bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
 		break;
 	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
 		fixed_memory32 = &ares->data.fixed_memory32;
-		if (!fixed_memory32->address_length)
+		if (!fixed_memory32->address && !fixed_memory32->address_length)
 			return false;
 		acpi_dev_get_memresource(res, fixed_memory32->address,
 					 fixed_memory32->address_length,
@@ -150,7 +150,7 @@ bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res)
 	switch (ares->type) {
 	case ACPI_RESOURCE_TYPE_IO:
 		io = &ares->data.io;
-		if (!io->address_length)
+		if (!io->minimum && !io->address_length)
 			return false;
 		acpi_dev_get_ioresource(res, io->minimum,
 					io->address_length,
@@ -158,7 +158,7 @@ bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res)
 		break;
 	case ACPI_RESOURCE_TYPE_FIXED_IO:
 		fixed_io = &ares->data.fixed_io;
-		if (!fixed_io->address_length)
+		if (!fixed_io->address && !fixed_io->address_length)
 			return false;
 		acpi_dev_get_ioresource(res, fixed_io->address,
 					fixed_io->address_length,
-- 
2.0.1

