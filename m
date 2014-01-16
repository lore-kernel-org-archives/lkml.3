Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaAPCF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:05:57 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:63070 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751669AbaAPCD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:03:26 -0500
Message-Id: <20140116020323.790636396@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 15 Jan 2014 20:58:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Tiejun Chen <tiejun.chen@windriver.com>
Subject: [PATCH RT 1/8] cpu_down: move migrate_enable() back
References: <20140116015824.201732155@goodmis.org>
Content-Disposition: inline; filename=0001-cpu_down-move-migrate_enable-back.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rt76-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Tiejun Chen <tiejun.chen@windriver.com>

Commit 08c1ab68, "hotplug-use-migrate-disable.patch", intends to
use migrate_enable()/migrate_disable() to replace that combination
of preempt_enable() and preempt_disable(), but actually in
!CONFIG_PREEMPT_RT_FULL case, migrate_enable()/migrate_disable()
are still equal to preempt_enable()/preempt_disable(). So that
followed cpu_hotplug_begin()/cpu_unplug_begin(cpu) would go schedule()
to trigger schedule_debug() like this:

_cpu_down()
	|
	+ migrate_disable() = preempt_disable()
	|
	+ cpu_hotplug_begin() or cpu_unplug_begin()
		|
		+ schedule()
			|
			+ __schedule()
				|
				+ preempt_disable();
				|
				+ __schedule_bug() is true!

So we should move migrate_enable() as the original scheme.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 063c2bb..031c644 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -546,6 +546,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		err = -EBUSY;
 		goto restore_cpus;
 	}
+	migrate_enable();
 
 	cpu_hotplug_begin();
 	err = cpu_unplug_begin(cpu);
@@ -598,7 +599,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 out_release:
 	cpu_unplug_done(cpu);
 out_cancel:
-	migrate_enable();
 	cpu_hotplug_done();
 	if (!err)
 		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
-- 
1.8.4.3


