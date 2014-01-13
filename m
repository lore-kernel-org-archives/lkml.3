Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaAMOrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:47:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaAMO0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <len.brown@intel.com>, Oleg Nesterov <oleg@redhat.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 51/96] libata, freezer: avoid block device removal while system is frozen
Date: Mon, 13 Jan 2014 14:24:14 +0000
Message-Id: <1389623099-18783-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 85fbd722ad0f5d64d1ad15888cd1eb2188bfb557 upstream.

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
Cc: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/libata-scsi.c | 21 +++++++++++++++++++++
 kernel/freezer.c          |  6 ++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 15863a4..970c6ad 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3636,6 +3636,27 @@ void ata_scsi_hotplug(struct work_struct *work)
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
index 11f82a4..be34be8 100644
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
1.8.3.2

