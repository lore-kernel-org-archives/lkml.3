Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab3KFLUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:20:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47549 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab3KFLUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:20:48 -0500
Date: Wed, 6 Nov 2013 03:20:20 -0800
From: tip-bot for HATAYAMA Daisuke <tipbot@zytor.com>
Message-ID: <tip-a477c8594bee3bff639739c48258a8c737ab721e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        vgoyal@redhat.com, d.hatayama@jp.fujitsu.com,
        akpm@linux-foundation.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        d.hatayama@jp.fujitsu.com, vgoyal@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <5277D644.4090707@jp.fujitsu.com>
References: <5277D644.4090707@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86/cpu: Always print SMP information in /proc/
 cpuinfo
Git-Commit-ID: a477c8594bee3bff639739c48258a8c737ab721e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:20:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a477c8594bee3bff639739c48258a8c737ab721e
Gitweb:     http://git.kernel.org/tip/a477c8594bee3bff639739c48258a8c737ab721e
Author:     HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
AuthorDate: Tue, 5 Nov 2013 02:15:48 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 08:13:56 +0100

x86/cpu: Always print SMP information in /proc/cpuinfo

Currently show_cpuinfo_core() displays cpu core information only if
the number of threads per a whole cores is 2 or larger.

However, this condition doesn't care about the number of
sockets. For example, this condition doesn't hold on systems
with two logical cpus consisting of two sockets and a single
core on each socket - yet the topology information would be
interesting to see in that case as well.

I don't know whether or not there are processors in real world
by which such configurations are possible, but at least on
vitual machine environments, such configuration can occur,
typically when no explicit SMP information is provided in
advance.

For example, on qemu/KVM, SMP information is specified via -smp
command-line option, more specifically, its syntax is:

  -smp n[,cores=cores][,threads=threads][,sockets=sockets][,maxcpus=maxcpus]

If this is not specified, qemu tells configuration with
n-sockets, 1-core and 1-thread to the guest machine, on which
guest, MP information is not displayed in /proc/cpuinfo.

I saw this situation on VMWare guest environment, too.

To fix this issue, this patch simply removes the condition
because this information is useful even if there's only 1
thread.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/5277D644.4090707@jp.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/proc.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index aee6317..06fe3ed 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -11,15 +11,12 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 			      unsigned int cpu)
 {
 #ifdef CONFIG_SMP
-	if (c->x86_max_cores * smp_num_siblings > 1) {
-		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
-		seq_printf(m, "siblings\t: %d\n",
-			   cpumask_weight(cpu_core_mask(cpu)));
-		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
-		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
-		seq_printf(m, "apicid\t\t: %d\n", c->apicid);
-		seq_printf(m, "initial apicid\t: %d\n", c->initial_apicid);
-	}
+	seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
+	seq_printf(m, "siblings\t: %d\n", cpumask_weight(cpu_core_mask(cpu)));
+	seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
+	seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
+	seq_printf(m, "apicid\t\t: %d\n", c->apicid);
+	seq_printf(m, "initial apicid\t: %d\n", c->initial_apicid);
 #endif
 }
 
