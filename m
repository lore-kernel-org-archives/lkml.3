Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab3BEVtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:49:25 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:42808 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab3BEVtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:49:21 -0500
Subject: [PATCH 1/4] Alter the amount of steal time reported by the guest.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, glommer@parallels.com,
        mingo@redhat.com, anthony@codemonkey.ws
Date: Tue, 05 Feb 2013 15:49:10 -0600
Message-ID: <20130205214910.4615.2411.stgit@lambeau>
In-Reply-To: <20130205214818.4615.12937.stgit@lambeau>
References: <20130205214818.4615.12937.stgit@lambeau>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020521-2674-0000-0000-000007BBA5C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the amount of stealtime that the kernel reports via the /proc interface.
Steal time will now be broken down into steal_time and consigned_time.
Consigned_time will represent the amount of time that is expected to be lost
due to overcommitment of the physical cpu or by using cpu hard capping.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 fs/proc/stat.c              |    9 +++++++--
 include/linux/kernel_stat.h |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index e296572..cb7fe80 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -82,7 +82,7 @@ static int show_stat(struct seq_file *p, void *v)
 	int i, j;
 	unsigned long jif;
 	u64 user, nice, system, idle, iowait, irq, softirq, steal;
-	u64 guest, guest_nice;
+	u64 guest, guest_nice, consign;
 	u64 sum = 0;
 	u64 sum_softirq = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
@@ -90,10 +90,11 @@ static int show_stat(struct seq_file *p, void *v)
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = 0;
-	guest = guest_nice = 0;
+	guest = guest_nice = consign = 0;
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
 
+
 	for_each_possible_cpu(i) {
 		user += kcpustat_cpu(i).cpustat[CPUTIME_USER];
 		nice += kcpustat_cpu(i).cpustat[CPUTIME_NICE];
@@ -105,6 +106,7 @@ static int show_stat(struct seq_file *p, void *v)
 		steal += kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
 		guest += kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice += kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
+		consign += kcpustat_cpu(i).cpustat[CPUTIME_CONSIGN];
 		sum += kstat_cpu_irqs_sum(i);
 		sum += arch_irq_stat_cpu(i);
 
@@ -128,6 +130,7 @@ static int show_stat(struct seq_file *p, void *v)
 	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
 	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
 	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(consign));
 	seq_putc(p, '\n');
 
 	for_each_online_cpu(i) {
@@ -142,6 +145,7 @@ static int show_stat(struct seq_file *p, void *v)
 		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
 		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
+		consign = kcpustat_cpu(i).cpustat[CPUTIME_CONSIGN];
 		seq_printf(p, "cpu%d", i);
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
@@ -153,6 +157,7 @@ static int show_stat(struct seq_file *p, void *v)
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(consign));
 		seq_putc(p, '\n');
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 66b7078..e352052 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -28,6 +28,7 @@ enum cpu_usage_stat {
 	CPUTIME_STEAL,
 	CPUTIME_GUEST,
 	CPUTIME_GUEST_NICE,
+	CPUTIME_CONSIGN,
 	NR_STATS,
 };
 

