Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3FYTIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:08:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3FYSdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [ 34/95] ACPI / dock: Take ACPI scan lock in write_undock()
Date: Tue, 25 Jun 2013 11:32:21 -0700
Message-Id: <20130625182157.479248242@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 8112006f41fd76ddf4988f8ddd904563db85613c upstream.

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
Acked-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/dock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
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


