Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3F1TjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:39:16 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54397 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab3F1Tir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:38:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: [PATCH 1/4] ACPI / dock: Drop the hp_lock mutex from struct dock_station
Date: Fri, 28 Jun 2013 21:45:35 +0200
Message-ID: <2188799.lTSykoia4I@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1640211.P0jyS5muX2@vostro.rjw.lan>
References: <1640211.P0jyS5muX2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The only existing user of the hp_lock mutex in struct dock_station,
hotplug_dock_devices(), is always called under acpi_scan_lock and
cannot race with another instance of itself, so drop the mutex
which is not necessary.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -64,7 +64,6 @@ struct dock_station {
 	unsigned long last_dock_time;
 	u32 flags;
 	spinlock_t dd_lock;
-	struct mutex hp_lock;
 	struct list_head dependent_devices;
 
 	struct list_head sibling;
@@ -410,8 +409,6 @@ static void hotplug_dock_devices(struct
 {
 	struct dock_dependent_device *dd;
 
-	mutex_lock(&ds->hp_lock);
-
 	/*
 	 * First call driver specific hotplug functions
 	 */
@@ -430,7 +427,6 @@ static void hotplug_dock_devices(struct
 		else
 			dock_create_acpi_device(dd->handle);
 	}
-	mutex_unlock(&ds->hp_lock);
 }
 
 static void dock_event(struct dock_station *ds, u32 event, int num)
@@ -1004,7 +1000,6 @@ static int __init dock_add(acpi_handle h
 	dock_station->dock_device = dd;
 	dock_station->last_dock_time = jiffies - HZ;
 
-	mutex_init(&dock_station->hp_lock);
 	spin_lock_init(&dock_station->dd_lock);
 	INIT_LIST_HEAD(&dock_station->sibling);
 	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);

