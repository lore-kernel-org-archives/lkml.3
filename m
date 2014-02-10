Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbaBJUEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:04:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34884 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaBJTpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:45:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 103/124] mm: numa: initialise numa balancing after jump label initialisation
Date: Mon, 10 Feb 2014 11:40:43 -0800
Message-Id: <1392061264-28124-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit c297663c0b3930491a3cb2aba4b6e5a7159c3503 upstream.

The command line parsing takes place before jump labels are initialised
which generates a warning if numa_balancing= is specified and
CONFIG_JUMP_LABEL is set.

On older kernels before commit c4b2c0c5f647 ("static_key: WARN on usage
before jump_label_init was called") the kernel would have crashed.  This
patch enables automatic numa balancing later in the initialisation
process if numa_balancing= is specified.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/mempolicy.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index efabe65..2d49a12 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2519,7 +2519,7 @@ void mpol_free_shared_policy(struct shared_policy *p)
 }
 
 #ifdef CONFIG_NUMA_BALANCING
-static bool __initdata numabalancing_override;
+static int __initdata numabalancing_override;
 
 static void __init check_numabalancing_enable(void)
 {
@@ -2528,9 +2528,15 @@ static void __init check_numabalancing_enable(void)
 	if (IS_ENABLED(CONFIG_NUMA_BALANCING_DEFAULT_ENABLED))
 		numabalancing_default = true;
 
+	/* Parsed by setup_numabalancing. override == 1 enables, -1 disables */
+	if (numabalancing_override)
+		set_numabalancing_state(numabalancing_override == 1);
+
 	if (nr_node_ids > 1 && !numabalancing_override) {
-		printk(KERN_INFO "Enabling automatic NUMA balancing. "
-			"Configure with numa_balancing= or sysctl");
+		printk(KERN_INFO "%s automatic NUMA balancing. "
+			"Configure with numa_balancing= or the "
+			"kernel.numa_balancing sysctl",
+			numabalancing_default ? "Enabling" : "Disabling");
 		set_numabalancing_state(numabalancing_default);
 	}
 }
@@ -2540,13 +2546,12 @@ static int __init setup_numabalancing(char *str)
 	int ret = 0;
 	if (!str)
 		goto out;
-	numabalancing_override = true;
 
 	if (!strcmp(str, "enable")) {
-		set_numabalancing_state(true);
+		numabalancing_override = 1;
 		ret = 1;
 	} else if (!strcmp(str, "disable")) {
-		set_numabalancing_state(false);
+		numabalancing_override = -1;
 		ret = 1;
 	}
 out:
-- 
1.8.3.2

