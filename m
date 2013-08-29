Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3H2VIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:08:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42995 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab3H2VIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:08:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, linux-mm@kvack.org
Subject: [PATCH 3/3] PM / hibernate / memory hotplug: Rework mutual exclusion
Date: Thu, 29 Aug 2013 23:18:49 +0200
Message-ID: <1562298.ZjRvhqQzT7@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <9589253.Co8jZpnWdd@vostro.rjw.lan>
References: <9589253.Co8jZpnWdd@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since all of the memory hotplug operations have to be carried out
under device_hotplug_lock, they won't need to acquire pm_mutex if
device_hotplug_lock is held around hibernation.

For this reason, make the hibernation code acquire
device_hotplug_lock after freezing user space processes and
release it before thawing them.  At the same tim drop the
lock_system_sleep() and unlock_system_sleep() calls from
lock_memory_hotplug() and unlock_memory_hotplug(), respectively.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/power/hibernate.c |    4 ++++
 kernel/power/user.c      |    2 ++
 mm/memory_hotplug.c      |    4 ----
 3 files changed, 6 insertions(+), 4 deletions(-)

Index: linux-pm/kernel/power/hibernate.c
===================================================================
--- linux-pm.orig/kernel/power/hibernate.c
+++ linux-pm/kernel/power/hibernate.c
@@ -652,6 +652,7 @@ int hibernate(void)
 	if (error)
 		goto Exit;
 
+	lock_device_hotplug();
 	/* Allocate memory management structures */
 	error = create_basic_memory_bitmaps();
 	if (error)
@@ -685,6 +686,7 @@ int hibernate(void)
  Free_bitmaps:
 	free_basic_memory_bitmaps();
  Thaw:
+	unlock_device_hotplug();
 	thaw_processes();
 
 	/* Don't bother checking whether freezer_test_done is true */
@@ -814,6 +816,7 @@ static int software_resume(void)
 
 	pr_debug("PM: Loading hibernation image.\n");
 
+	lock_device_hotplug();
 	error = create_basic_memory_bitmaps();
 	if (error)
 		goto Thaw;
@@ -827,6 +830,7 @@ static int software_resume(void)
 	swsusp_free();
 	free_basic_memory_bitmaps();
  Thaw:
+	unlock_device_hotplug();
 	thaw_processes();
  Finish:
 	pm_notifier_call_chain(PM_POST_RESTORE);
Index: linux-pm/kernel/power/user.c
===================================================================
--- linux-pm.orig/kernel/power/user.c
+++ linux-pm/kernel/power/user.c
@@ -201,6 +201,7 @@ static long snapshot_ioctl(struct file *
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
+	lock_device_hotplug();
 	data = filp->private_data;
 
 	switch (cmd) {
@@ -373,6 +374,7 @@ static long snapshot_ioctl(struct file *
 
 	}
 
+	unlock_device_hotplug();
 	mutex_unlock(&pm_mutex);
 
 	return error;
Index: linux-pm/mm/memory_hotplug.c
===================================================================
--- linux-pm.orig/mm/memory_hotplug.c
+++ linux-pm/mm/memory_hotplug.c
@@ -51,14 +51,10 @@ DEFINE_MUTEX(mem_hotplug_mutex);
 void lock_memory_hotplug(void)
 {
 	mutex_lock(&mem_hotplug_mutex);
-
-	/* for exclusive hibernation if CONFIG_HIBERNATION=y */
-	lock_system_sleep();
 }
 
 void unlock_memory_hotplug(void)
 {
-	unlock_system_sleep();
 	mutex_unlock(&mem_hotplug_mutex);
 }
 

