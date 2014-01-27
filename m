Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaA0Pve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:51:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbaA0Pvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:51:31 -0500
Date: Mon, 27 Jan 2014 15:51:27 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: numa: Initialse numa balancing after jump label
 initialisation
Message-ID: <20140127155127.GJ4963@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The command line parsing takes place before jump labels are initialised which
generates a warning if numa_balancing= is specified and CONFIG_JUMP_LABEL
is set. On older kernls before commit c4b2c0c5 (static_key: WARN on
usage before jump_label_init was called) the kernel would have crashed.
This patch enables automatic numa balancing later in the initialisation
process if numa_balancing= is specified.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Stable <stable@vger.kernel.org>
---
 mm/mempolicy.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0cd2c4d..5223684 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2657,7 +2657,7 @@ void mpol_free_shared_policy(struct shared_policy *p)
 }
 
 #ifdef CONFIG_NUMA_BALANCING
-static bool __initdata numabalancing_override;
+static int __initdata numabalancing_override;
 
 static void __init check_numabalancing_enable(void)
 {
@@ -2666,9 +2666,14 @@ static void __init check_numabalancing_enable(void)
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
+			"Configure with numa_balancing= or sysctl",
+			numabalancing_default ? "Enabling" : "Disabling");
 		set_numabalancing_state(numabalancing_default);
 	}
 }
@@ -2678,13 +2683,12 @@ static int __init setup_numabalancing(char *str)
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
