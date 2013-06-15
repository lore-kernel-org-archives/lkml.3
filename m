Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3FOWHR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 18:07:17 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38713 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab3FOWHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 18:07:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] ACPI / dock: Take ACPI scan lock in write_undock()
Date: Sun, 16 Jun 2013 00:16:31 +0200
Message-ID: <1886227.aipra45Zvt@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since commit 3757b94 (ACPI / hotplug: Fix concurrency issues and
memory leaks) acpi_bus_scan() and acpi_bus_trim() must always be
called under acpi_scan_lock, but currently the following scenario
violating that requirement is possible:

 write_undock()
  handle_eject_request()
   hotplug_dock_devices()
    dock_remove_acpi_device()
     acpi_bus_trim()

Fix that by making write_undock() acquire acpi_scan_lock before
calling handle_eject_request() as appropriate (begin_undock() is
under the lock too in analogy with acpi_dock_deferred_cb()).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 3.9+ <stable@vger.kernel.org>
---
 drivers/acpi/dock.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -868,8 +868,10 @@ static ssize_t write_undock(struct devic
 	if (!count)
 		return -EINVAL;
 
+	acpi_scan_lock_acquire();
 	begin_undock(dock_station);
 	ret = handle_eject_request(dock_station, ACPI_NOTIFY_EJECT_REQUEST);
+	acpi_scan_lock_release();
 	return ret ? ret: count;
 }
 static DEVICE_ATTR(undock, S_IWUSR, NULL, write_undock);

