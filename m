Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaKAWlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:41:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60319 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797AbaKAWjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:33 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Jiri Kosina" <jkosina@suse.cz>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.103430756@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 024/102] ACPI / cpuidle: fix deadlock between
 cpuidle_lock and cpu_hotplug.lock
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/processor_idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1165,9 +1165,9 @@ int acpi_processor_cst_has_changed(struc
 	if (smp_processor_id() == 0 &&
 			cpuidle_get_driver() == &acpi_idle_driver) {
 
-		cpuidle_pause_and_lock();
 		/* Protect against cpu-hotplug */
 		get_online_cpus();
+		cpuidle_pause_and_lock();
 
 		/* Disable all cpuidle devices */
 		for_each_online_cpu(cpu) {
@@ -1192,8 +1192,8 @@ int acpi_processor_cst_has_changed(struc
 				cpuidle_enable_device(&_pr->power.dev);
 			}
 		}
-		put_online_cpus();
 		cpuidle_resume_and_unlock();
+		put_online_cpus();
 	}
 
 	return 0;

