Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934808Ab3BNRzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:55:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233Ab3BNRzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:55:35 -0500
Date: Thu, 14 Feb 2013 09:54:04 -0800
From: tip-bot for Mike Galbraith <efault@gmx.de>
Message-ID: <tip-56384eba0f06a834e4c202d0a65e14f55896b67f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, efault@gmx.de, andrew.d.henroid@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, efault@gmx.de, tglx@linutronix.de,
        andrew.d.henroid@intel.com
In-Reply-To: <1323258522.5057.73.camel@marge.simson.net>
References: <1323258522.5057.73.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] intel_idle:
  Convert i7300_idle_lock to raw_spinlock
Git-Commit-ID: 56384eba0f06a834e4c202d0a65e14f55896b67f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 14 Feb 2013 09:54:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56384eba0f06a834e4c202d0a65e14f55896b67f
Gitweb:     http://git.kernel.org/tip/56384eba0f06a834e4c202d0a65e14f55896b67f
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 7 Dec 2011 12:48:42 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 14 Feb 2013 18:39:06 +0100

intel_idle: Convert i7300_idle_lock to raw_spinlock

24 core Intel box's first exposure to 3.0.12-rt30-rc3 didn't go well.

[   27.104159] i7300_idle: loaded v1.55
[   27.104192] BUG: scheduling while atomic: swapper/2/0/0x00000002
[   27.104309] Pid: 0, comm: swapper/2 Tainted: G           N  3.0.12-rt30-rc3-rt #1
[   27.104317] Call Trace:
[   27.104338]  [<ffffffff810046a5>] dump_trace+0x85/0x2e0
[   27.104372]  [<ffffffff8144eb00>] thread_return+0x12b/0x30b
[   27.104381]  [<ffffffff8144f1b9>] schedule+0x29/0xb0
[   27.104389]  [<ffffffff814506e5>] rt_spin_lock_slowlock+0xc5/0x240
[   27.104401]  [<ffffffffa01f818f>] i7300_idle_notifier+0x3f/0x360 [i7300_idle]
[   27.104415]  [<ffffffff814546c7>] notifier_call_chain+0x37/0x70
[   27.104426]  [<ffffffff81454748>] __atomic_notifier_call_chain+0x48/0x70
[   27.104439]  [<ffffffff81001a39>] cpu_idle+0x89/0xb0
[   27.104449] bad: scheduling from the idle thread!

This lock is taken from interrupt disabled context in the guts of
idle. Convert it to a raw_spinlock.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Henroid <andrew.d.henroid@intel.com>
Link: http://lkml.kernel.org/r/1323258522.5057.73.camel@marge.simson.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/idle/i7300_idle.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/idle/i7300_idle.c b/drivers/idle/i7300_idle.c
index fa080eb..ffeebc7 100644
--- a/drivers/idle/i7300_idle.c
+++ b/drivers/idle/i7300_idle.c
@@ -75,7 +75,7 @@ static unsigned long past_skip;
 
 static struct pci_dev *fbd_dev;
 
-static spinlock_t i7300_idle_lock;
+static raw_spinlock_t i7300_idle_lock;
 static int i7300_idle_active;
 
 static u8 i7300_idle_thrtctl_saved;
@@ -457,7 +457,7 @@ static int i7300_idle_notifier(struct notifier_block *nb, unsigned long val,
 		idle_begin_time = ktime_get();
 	}
 
-	spin_lock_irqsave(&i7300_idle_lock, flags);
+	raw_spin_lock_irqsave(&i7300_idle_lock, flags);
 	if (val == IDLE_START) {
 
 		cpumask_set_cpu(smp_processor_id(), idle_cpumask);
@@ -506,7 +506,7 @@ static int i7300_idle_notifier(struct notifier_block *nb, unsigned long val,
 		}
 	}
 end:
-	spin_unlock_irqrestore(&i7300_idle_lock, flags);
+	raw_spin_unlock_irqrestore(&i7300_idle_lock, flags);
 	return 0;
 }
 
@@ -548,7 +548,7 @@ struct debugfs_file_info {
 
 static int __init i7300_idle_init(void)
 {
-	spin_lock_init(&i7300_idle_lock);
+	raw_spin_lock_init(&i7300_idle_lock);
 	total_us = 0;
 
 	if (i7300_idle_platform_probe(&fbd_dev, &ioat_dev, forceload))
