Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaEGT55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:57:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47817 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbaEGT5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:57:47 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] CPU hotplug: Slow down hotplug operations
Date: Wed,  7 May 2014 21:57:41 +0200
Message-Id: <1399492661-891-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We have all those eager tester dudes which scratch up a dirty script to
pound on CPU hotplug senselessly and then report bugs they've managed to
trigger.

Well, first of all, most, if not all, bugs they trigger are CPU hotplug
related anyway. But we know hotplug is full of duct tape and brown
paper bags. So we end up clearly wasting too much time dealing with a
mechanism we know it is b0rked in the first place.

Oh, and I would understand if that pounding were close to some real
usage patterns but I've yet to receive a justification for toggling
cores on- and offline senselessly.

In any case, before this gets rewritten properly (I'm being told we
might get lucky after all) let's slow down hotplugging on purpose and
thus make it uninteresting, as a temporary brown paper bag solution
until the real thing gets done.

This way we'll save us a lot of time and efforts in chasing the wrong
bugs.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <mgalbraith@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/base/cpu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 006b1bc5297d..615c7af767ed 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -40,6 +40,11 @@ static void change_cpu_under_node(struct cpu *cpu,
 	cpu->node_id = to_nid;
 }
 
+static void delay_hotplug(void)
+{
+	schedule_timeout_uninterruptible(msecs_to_jiffies(MSEC_PER_SEC));
+}
+
 static int __ref cpu_subsys_online(struct device *dev)
 {
 	struct cpu *cpu = container_of(dev, struct cpu, dev);
@@ -47,6 +52,8 @@ static int __ref cpu_subsys_online(struct device *dev)
 	int from_nid, to_nid;
 	int ret;
 
+	delay_hotplug();
+
 	from_nid = cpu_to_node(cpuid);
 	if (from_nid == NUMA_NO_NODE)
 		return -ENODEV;
@@ -65,6 +72,8 @@ static int __ref cpu_subsys_online(struct device *dev)
 
 static int cpu_subsys_offline(struct device *dev)
 {
+	delay_hotplug();
+
 	return cpu_down(dev->id);
 }
 
-- 
1.9.0

