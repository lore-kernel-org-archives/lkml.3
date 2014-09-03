Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811AbaICNEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:04:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379AbaICNEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:04:32 -0400
Date: Wed, 3 Sep 2014 15:04:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Oleg Nesterov <oleg@redhat.com>, "Srivatsa S. Bhat" <srivatsa@mit.edu>,
        Ingo Molnar <mingo@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH] ACPI / cpuidle: fix deadlock between cpuidle_lock and
 cpu_hotplug.lock
In-Reply-To: <alpine.LNX.2.00.1409031404110.12309@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1409031503140.12309@pobox.suse.cz>
References: <alpine.LNX.2.00.1409031404110.12309@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a following AB-BA dependency between cpu_hotplug.lock and 
cpuidle_lock:

1) cpu_hotplug.lock -> cpuidle_lock
enable_nonboot_cpus()
 _cpu_up()
  cpu_hotplug_being()
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
---
 drivers/acpi/processor_idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 3dca36d..17f9ec5 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1071,9 +1071,9 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 
 	if (pr->id == 0 && cpuidle_get_driver() == &acpi_idle_driver) {
 
-		cpuidle_pause_and_lock();
 		/* Protect against cpu-hotplug */
 		get_online_cpus();
+		cpuidle_pause_and_lock();
 
 		/* Disable all cpuidle devices */
 		for_each_online_cpu(cpu) {
@@ -1100,8 +1100,8 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 				cpuidle_enable_device(dev);
 			}
 		}
-		put_online_cpus();
 		cpuidle_resume_and_unlock();
+		put_online_cpus();
 	}
 
 	return 0;
-- 
Jiri Kosina
SUSE Labs
