Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3LSSzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:55:09 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:51532 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab3LSSzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:55:06 -0500
Date: Thu, 19 Dec 2013 13:54:59 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: tomaz.solc@tablix.org, aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH v4] libata, freezer: avoid block device removal while system
 is frozen
Message-ID: <20131219185459.GB22725@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131213185237.GD27070@htj.dyndns.org>
 <20131213204034.GE27070@htj.dyndns.org>
 <20131217125042.GF29989@htj.dyndns.org>
 <20131218120732.GB4324@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131218120732.GB4324@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

Oops, it was missing CONFIG_FREEZER.  Updated version committed.  How
did we even survive before kbuild test robot?  :)

Thanks.

------ 8< ------
>From 85fbd722ad0f5d64d1ad15888cd1eb2188bfb557 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 18 Dec 2013 07:07:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Freezable kthreads and workqueues are fundamentally problematic in
that they effectively introduce a big kernel lock widely used in the
kernel and have already been the culprit of several deadlock
scenarios.  This is the latest occurrence.

During resume, libata rescans all the ports and revalidates all
pre-existing devices.  If it determines that a device has gone
missing, the device is removed from the system which involves
invalidating block device and flushing bdi while holding driver core
layer locks.  Unfortunately, this can race with the rest of device
resume.  Because freezable kthreads and workqueues are thawed after
device resume is complete and block device removal depends on
freezable workqueues and kthreads (e.g. bdi_wq, jbd2) to make
progress, this can lead to deadlock - block device removal can't
proceed because kthreads are frozen and kthreads can't be thawed
because device resume is blocked behind block device removal.

839a8e8660b6 ("writeback: replace custom worker pool implementation
with unbound workqueue") made this particular deadlock scenario more
visible but the underlying problem has always been there - the
original forker task and jbd2 are freezable too.  In fact, this is
highly likely just one of many possible deadlock scenarios given that
freezer behaves as a big kernel lock and we don't have any debug
mechanism around it.

I believe the right thing to do is getting rid of freezable kthreads
and workqueues.  This is something fundamentally broken.  For now,
implement a funny workaround in libata - just avoid doing block device
hot[un]plug while the system is frozen.  Kernel engineering at its
finest.  :(

v2: Add EXPORT_SYMBOL_GPL(pm_freezing) for cases where libata is built
    as a module.

v3: Comment updated and polling interval changed to 10ms as suggested
    by Rafael.

v4: Add #ifdef CONFIG_FREEZER around the hack as pm_freezing is not
    defined when FREEZER is not configured thus breaking build.
    Reported by kbuild test robot.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Tomaž Šolc <tomaz.solc@tablix.org>
Reviewed-by: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=62801
Link: http://lkml.kernel.org/r/20131213174932.GA27070@htj.dyndns.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
Cc: kbuild test robot <fengguang.wu@intel.com>
---
 drivers/ata/libata-scsi.c | 21 +++++++++++++++++++++
 kernel/freezer.c          |  6 ++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index db6dfcf..176f629 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3871,6 +3871,27 @@ void ata_scsi_hotplug(struct work_struct *work)
 		return;
 	}
 
+	/*
+	 * XXX - UGLY HACK
+	 *
+	 * The block layer suspend/resume path is fundamentally broken due
+	 * to freezable kthreads and workqueue and may deadlock if a block
+	 * device gets removed while resume is in progress.  I don't know
+	 * what the solution is short of removing freezable kthreads and
+	 * workqueues altogether.
+	 *
+	 * The following is an ugly hack to avoid kicking off device
+	 * removal while freezer is active.  This is a joke but does avoid
+	 * this particular deadlock scenario.
+	 *
+	 * https://bugzilla.kernel.org/show_bug.cgi?id=62801
+	 * http://marc.info/?l=linux-kernel&m=138695698516487
+	 */
+#ifdef CONFIG_FREEZER
+	while (pm_freezing)
+		msleep(10);
+#endif
+
 	DPRINTK("ENTER\n");
 	mutex_lock(&ap->scsi_scan_mutex);
 
diff --git a/kernel/freezer.c b/kernel/freezer.c
index b462fa1..aa6a8aa 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -19,6 +19,12 @@ EXPORT_SYMBOL(system_freezing_cnt);
 bool pm_freezing;
 bool pm_nosig_freezing;
 
+/*
+ * Temporary export for the deadlock workaround in ata_scsi_hotplug().
+ * Remove once the hack becomes unnecessary.
+ */
+EXPORT_SYMBOL_GPL(pm_freezing);
+
 /* protects freezing and frozen transitions */
 static DEFINE_SPINLOCK(freezer_lock);
 
-- 
1.8.4.2

