Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934660AbaEFK3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 06:29:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55391 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934549AbaEFK3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 06:29:30 -0400
Date: Tue, 6 May 2014 12:29:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: lkml <linux-kernel@vger.kernel.org>
Cc: x86-ml <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <mgalbraith@suse.de>
Subject: Slow down stupid pounders
Message-ID: <20140506102924.GA25013@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so I'm getting sick'n'tired of all those bug reports of people pounding
cpu hotplug with stupid scripts.

* We know cpu hotplug is fragile/buggy/crap/needs proper rewrite.

* Stupid hotplugging script doesn't resemble any real use case - go use
a real benchmark/stress test to trigger bugs.

So if we can't make pounders stop jerking off, let's make it
uninterestingly slow. Stupid patch below, it might be completely idiotic
to do it this way but at least starts the discussion about this being a
really annoying issue which needs some sort of dealing with.

I dunno, we can make it configurable (which will probably defeat its
purpose partially), we can do some more fancy ratelimiting, per cpu,
whatever... we'll see.

Opinions, flames?

---
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
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
