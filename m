Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3IERwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:52:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41494 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab3IERww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:52:52 -0400
Date: Thu, 5 Sep 2013 10:52:15 -0700
From: tip-bot for Libin <tipbot@zytor.com>
Message-ID: <tip-52239484bf8aec031afa84ae08aa88224d819b93@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        huawei.libin@huawei.com, wangyijing@huawei.com, fenghua.yu@intel.com,
        tglx@linutronix.de, guohanjun@huawei.com, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        huawei.libin@huawei.com, wangyijing@huawei.com, fenghua.yu@intel.com,
        tglx@linutronix.de, guohanjun@huawei.com, paul.gortmaker@windriver.com
In-Reply-To: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
References: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/smpboot: Fix announce_cpu() to printk()
  the last "OK" properly
Git-Commit-ID: 52239484bf8aec031afa84ae08aa88224d819b93
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 05 Sep 2013 10:52:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52239484bf8aec031afa84ae08aa88224d819b93
Gitweb:     http://git.kernel.org/tip/52239484bf8aec031afa84ae08aa88224d819b93
Author:     Libin <huawei.libin@huawei.com>
AuthorDate: Thu, 5 Sep 2013 18:57:56 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Sep 2013 15:05:37 +0200

x86/smpboot: Fix announce_cpu() to printk() the last "OK" properly

When booting secondary CPUs, announce_cpu() is called to show which cpu has
been brought up. For example:

[    0.402751] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 OK
[    0.525667] smpboot: Booting Node   1, Processors  #6 #7 #8 #9 #10 #11 OK
[    0.755592] smpboot: Booting Node   0, Processors  #12 #13 #14 #15 #16 #17 OK
[    0.890495] smpboot: Booting Node   1, Processors  #18 #19 #20 #21 #22 #23

But the last "OK" is lost, because 'nr_cpu_ids-1' represents the maximum
possible cpu id. It should use the maximum present cpu id in case not all
CPUs booted up.

Signed-off-by: Libin <huawei.libin@huawei.com>
Cc: <guohanjun@huawei.com>
Cc: <wangyijing@huawei.com>
Cc: <fenghua.yu@intel.com>
Cc: <paul.gortmaker@windriver.com>
Link: http://lkml.kernel.org/r/1378378676-18276-1-git-send-email-huawei.libin@huawei.com
[ tweaked the changelog, removed unnecessary line break, tweaked the format to align the fields vertically. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index aecc98a..6cacab6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -653,6 +653,7 @@ static void announce_cpu(int cpu, int apicid)
 {
 	static int current_node = -1;
 	int node = early_cpu_to_node(cpu);
+	int max_cpu_present = find_last_bit(cpumask_bits(cpu_present_mask), NR_CPUS);
 
 	if (system_state == SYSTEM_BOOTING) {
 		if (node != current_node) {
@@ -661,7 +662,7 @@ static void announce_cpu(int cpu, int apicid)
 			current_node = node;
 			pr_info("Booting Node %3d, Processors ", node);
 		}
-		pr_cont(" #%d%s", cpu, cpu == (nr_cpu_ids - 1) ? " OK\n" : "");
+		pr_cont(" #%4d%s", cpu, cpu == max_cpu_present ? " OK\n" : "");
 		return;
 	} else
 		pr_info("Booting Node %d Processor %d APIC 0x%x\n",
