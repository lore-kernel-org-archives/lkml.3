Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaIZKSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:18:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbaIZJqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 086/142] ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock
Date: Fri, 26 Sep 2014 11:44:57 +0200
Message-Id: <4cdd9a72256c461874df095fde4a6b96bd7f426d.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/processor_idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index c7414a545a4f..2a4ae32c4b97 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1099,9 +1099,9 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 
 	if (pr->id == 0 && cpuidle_get_driver() == &acpi_idle_driver) {
 
-		cpuidle_pause_and_lock();
 		/* Protect against cpu-hotplug */
 		get_online_cpus();
+		cpuidle_pause_and_lock();
 
 		/* Disable all cpuidle devices */
 		for_each_online_cpu(cpu) {
@@ -1128,8 +1128,8 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 				cpuidle_enable_device(dev);
 			}
 		}
-		put_online_cpus();
 		cpuidle_resume_and_unlock();
+		put_online_cpus();
 	}
 
 	return 0;
-- 
2.1.0

