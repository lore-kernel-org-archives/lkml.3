Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaFCD5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 23:57:46 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35178 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaFCD5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 23:57:45 -0400
Date: Mon, 2 Jun 2014 20:57:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Drokin <green@linuxhacker.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Rohit Seth <rohitseth@google.com>
Subject: Re: [PATCH] sysctl: Fix division by zero in percpu_pagelist_fraction
 handler
In-Reply-To: <B549468A-10FC-4897-8720-7C9FEC6FD03A@linuxhacker.ru>
Message-ID: <alpine.DEB.2.02.1406022056300.20536@chino.kir.corp.google.com>
References: <1399166883-514-1-git-send-email-green@linuxhacker.ru> <alpine.DEB.2.02.1406021837490.13072@chino.kir.corp.google.com> <B549468A-10FC-4897-8720-7C9FEC6FD03A@linuxhacker.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014, Oleg Drokin wrote:

> It's needed because at the very beginning of proc_dointvec_minmax it checks if the length is 0 and if it is, immediately returns success because there's nothing to be done
> from it's perspective.
> And since percpu_pagelist_fraction is 0 from the very beginning, next step is division by this value.
> 
> If length is not 0 on the other hand, then there's some value proc_dointvec_minmax can interpret and the min and max checks happen and everything works correctly.
> 
> This is kind of hard to fix in proc_dointvec_minmax because there's no passed in value to check against, I think. Sure, you can also check the passed in pointer to value
> to make sure it's within range, but that goes beyond the scope of the function.
> You might as well just assign a sane value to percpu_pagelist_fraction, which has an added benefit of when you cat that /proc file, you'll get real value of what the kernel uses instead of 0.
> 

I'm pretty sure we want to allow users to restore the kernel default 
behavior if they've already written to this file and now want to change it 
back.

What do you think about doing it like this instead?
---
 Documentation/sysctl/vm.txt |  3 ++-
 kernel/sysctl.c             |  3 +--
 mm/page_alloc.c             | 20 ++++++++++++--------
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -702,7 +702,8 @@ The batch value of each per cpu pagelist is also updated as a result.  It is
 set to pcp->high/4.  The upper limit of batch is (PAGE_SHIFT * 8)
 
 The initial value is zero.  Kernel does not use this value at boot time to set
-the high water marks for each per cpu page list.
+the high water marks for each per cpu page list.  If the user writes '0' to this
+sysctl, it will revert to this default behavior.
 
 ==============================================================
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -136,7 +136,6 @@ static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
 static int minolduid;
-static int min_percpu_pagelist_fract = 8;
 
 static int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
@@ -1305,7 +1304,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(percpu_pagelist_fraction),
 		.mode		= 0644,
 		.proc_handler	= percpu_pagelist_fraction_sysctl_handler,
-		.extra1		= &min_percpu_pagelist_fract,
+		.extra1		= &zero,
 	},
 #ifdef CONFIG_MMU
 	{
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -69,6 +69,7 @@
 
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
+#define MIN_PERCPU_PAGELIST_FRAC	(8)
 
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
@@ -4223,8 +4224,8 @@ static void pageset_set_high(struct per_cpu_pageset *p,
 	pageset_update(&p->pcp, high, batch);
 }
 
-static void __meminit pageset_set_high_and_batch(struct zone *zone,
-		struct per_cpu_pageset *pcp)
+static void pageset_set_high_and_batch(struct zone *zone,
+				       struct per_cpu_pageset *pcp)
 {
 	if (percpu_pagelist_fraction)
 		pageset_set_high(pcp,
@@ -5850,20 +5851,23 @@ int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
-	unsigned int cpu;
 	int ret;
 
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (!write || (ret < 0))
+	if (!write || ret < 0)
 		return ret;
 
+	if (percpu_pagelist_fraction &&
+	    percpu_pagelist_fraction < MIN_PERCPU_PAGELIST_FRAC)
+		percpu_pagelist_fraction = MIN_PERCPU_PAGELIST_FRAC;
+
 	mutex_lock(&pcp_batch_high_lock);
 	for_each_populated_zone(zone) {
-		unsigned long  high;
-		high = zone->managed_pages / percpu_pagelist_fraction;
+		unsigned int cpu;
+
 		for_each_possible_cpu(cpu)
-			pageset_set_high(per_cpu_ptr(zone->pageset, cpu),
-					 high);
+			pageset_set_high_and_batch(zone,
+					per_cpu_ptr(zone->pageset, cpu));
 	}
 	mutex_unlock(&pcp_batch_high_lock);
 	return 0;
