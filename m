Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab3LMUkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:40:47 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:39325 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3LMUkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:40:45 -0500
Date: Fri, 13 Dec 2013 15:40:34 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: tomaz.solc@tablix.org, aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] libata, freezer: avoid block device removal while system is
 frozen
Message-ID: <20131213204034.GE27070@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131213185237.GD27070@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131213185237.GD27070@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

So, this is the laughable workaround that I came up with.  Seriously,
this is tragic.  :(

Thanks.

------- 8< -------
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

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Tomaž Šolc <tomaz.solc@tablix.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=62801
Link: http://lkml.kernel.org/r/20131213174932.GA27070@htj.dyndns.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/ata/libata-scsi.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ab58556..60a01d3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3872,6 +3872,25 @@ void ata_scsi_hotplug(struct work_struct *work)
 		return;
 	}
 
+	/*
+	 * XXX - UGLY HACK
+	 *
+	 * The core suspend/resume path is fundamentally broken due to
+	 * freezable kthreads and workqueue and may deadlock if a block
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
+	while (pm_freezing)
+		msleep(100);
+
 	DPRINTK("ENTER\n");
 	mutex_lock(&ap->scsi_scan_mutex);
 
