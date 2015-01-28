Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018AbbA1Fc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:32:58 -0500
Received: from mail.kernel.org ([198.145.29.136]:36758 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760436AbbA1ENv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:13:51 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 07/91] ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock
Date: Wed, 28 Jan 2015 12:06:20 +0800
Message-Id: <1422418236-12852-13-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/acpi/processor_idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 6cba428..e1180ce 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1195,9 +1195,9 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 
 	if (pr->id == 0 && cpuidle_get_driver() == &acpi_idle_driver) {
 
-		cpuidle_pause_and_lock();
 		/* Protect against cpu-hotplug */
 		get_online_cpus();
+		cpuidle_pause_and_lock();
 
 		/* Disable all cpuidle devices */
 		for_each_online_cpu(cpu) {
@@ -1222,8 +1222,8 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 				cpuidle_enable_device(&_pr->power.dev);
 			}
 		}
-		put_online_cpus();
 		cpuidle_resume_and_unlock();
+		put_online_cpus();
 	}
 
 	return 0;
-- 
1.9.1

