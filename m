Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbaIOUDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:03:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbaIOTrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.10 37/71] ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock
Date: Mon, 15 Sep 2014 12:26:35 -0700
Message-Id: <20140915192639.934310639@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192638.702282534@linuxfoundation.org>
References: <20140915192638.702282534@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 6726655dfdd2dc60c035c690d9f10cb69d7ea075 upstream.

There is a following AB-BA dependency between cpu_hotplug.lock and
cpuidle_lock:

1) cpu_hotplug.lock -> cpuidle_lock
enable_nonboot_cpus()
 _cpu_up()
  cpu_hotplug_begin()
   LOCK(cpu_hotplug.lock)
 cpu_notify()
  ...
  acpi_processor_hotplug()
   cpuidle_pause_and_lock()
    LOCK(cpuidle_lock)

2) cpuidle_lock -> cpu_hotplug.lock
acpi_os_execute_deferred() workqueue
 ...
 acpi_processor_cst_has_changed()
  cpuidle_pause_and_lock()
   LOCK(cpuidle_lock)
  get_online_cpus()
   LOCK(cpu_hotplug.lock)

Fix this by reversing the order acpi_processor_cst_has_changed() does
thigs -- let it first execute the protection against CPU hotplug by
calling get_online_cpus() and obtain the cpuidle lock only after that (and
perform the symmentric change when allowing CPUs hotplug again and
dropping cpuidle lock).

Spotted by lockdep.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/processor_idle.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1101,9 +1101,9 @@ int acpi_processor_cst_has_changed(struc
 
 	if (pr->id == 0 && cpuidle_get_driver() == &acpi_idle_driver) {
 
-		cpuidle_pause_and_lock();
 		/* Protect against cpu-hotplug */
 		get_online_cpus();
+		cpuidle_pause_and_lock();
 
 		/* Disable all cpuidle devices */
 		for_each_online_cpu(cpu) {
@@ -1130,8 +1130,8 @@ int acpi_processor_cst_has_changed(struc
 				cpuidle_enable_device(dev);
 			}
 		}
-		put_online_cpus();
 		cpuidle_resume_and_unlock();
+		put_online_cpus();
 	}
 
 	return 0;


