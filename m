Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3GBMyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:54:11 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:53375 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3GBMyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:54:07 -0400
Subject: [PATCH 4] mce: acpi/apei: Add a sysctl to control page offlining on
 firmware report
To: tony.luck@intel.com, bp@alien8.de
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        ying.huang@intel.com
Date: Tue, 02 Jul 2013 18:24:00 +0530
Message-ID: <20130702125137.7388.97225.stgit@localhost.localdomain>
In-Reply-To: <20130701153728.6197.14022.stgit@localhost.localdomain>
References: <20130701153728.6197.14022.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070212-4790-0000-0000-000009140006
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am adding another patch here to disable page offlining in case the firmware
starts acting up.

Thanks,
Naveen

--

Add a sysctl memory_failure_soft_offline to control what is done on receipt of
firmware ghes notification for a corrected error. By default, kernel tries
to soft-offline the page immediately. If set to 0, no action is taken.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 Documentation/sysctl/vm.txt |   12 ++++++++++++
 include/linux/mm.h          |    1 +
 kernel/sysctl.c             |    9 +++++++++
 mm/memory-failure.c         |   10 +++++++---
 4 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index dcc75a9..6d0fcba 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -375,6 +375,18 @@ Enable memory failure recovery (when supported by the platform)
 
 ==============================================================
 
+memory_failure_soft_offline
+
+Control soft-offlining of pages on receipt of appropriate firmware error
+report through GHES. Note that this does not affect user-space initiated
+soft-offlining.
+
+1: Attempt soft-offlining.
+
+0: No action.
+
+==============================================================
+
 min_free_kbytes:
 
 This is used to force the Linux VM to keep a minimum number
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 958e9efd..2c16ca4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1791,6 +1791,7 @@ extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
 extern int unpoison_memory(unsigned long pfn);
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
+extern int sysctl_memory_failure_soft_offline;
 extern void shake_page(struct page *p, int access);
 extern atomic_long_t num_poisoned_pages;
 extern int soft_offline_page(struct page *page, int flags);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b0a1f99..cc4b794 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1427,6 +1427,15 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+	{
+		.procname	= "memory_failure_soft_offline",
+		.data		= &sysctl_memory_failure_soft_offline,
+		.maxlen		= sizeof(sysctl_memory_failure_soft_offline),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 #endif
 	{
 		.procname	= "user_reserve_kbytes",
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 0d6717e..ec4851c 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -61,6 +61,8 @@ int sysctl_memory_failure_early_kill __read_mostly = 0;
 
 int sysctl_memory_failure_recovery __read_mostly = 1;
 
+int sysctl_memory_failure_soft_offline __read_mostly = 1;
+
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 #if defined(CONFIG_HWPOISON_INJECT) || defined(CONFIG_HWPOISON_INJECT_MODULE)
@@ -1286,9 +1288,11 @@ static void memory_failure_work_func(struct work_struct *work)
 		spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
 		if (!gotten)
 			break;
-		if (entry.flags & MF_SOFT_OFFLINE)
-			soft_offline_page(pfn_to_page(entry.pfn), entry.flags);
-		else
+		if (entry.flags & MF_SOFT_OFFLINE) {
+			if (sysctl_memory_failure_soft_offline)
+				soft_offline_page(pfn_to_page(entry.pfn),
+						entry.flags);
+		} else
 			memory_failure(entry.pfn, entry.trapno, entry.flags);
 	}
 }

