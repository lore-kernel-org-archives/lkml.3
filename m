Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaBKUxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:53:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaBKTF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 063/120] mm: numa: initialise numa balancing after jump label initialisation
Date: Tue, 11 Feb 2014 11:05:04 -0800
Message-Id: <20140211184825.416454243@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mempolicy.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2657,7 +2657,7 @@ void mpol_free_shared_policy(struct shar
 }
 
 #ifdef CONFIG_NUMA_BALANCING
-static bool __initdata numabalancing_override;
+static int __initdata numabalancing_override;
 
 static void __init check_numabalancing_enable(void)
 {
@@ -2666,9 +2666,15 @@ static void __init check_numabalancing_e
 	if (IS_ENABLED(CONFIG_NUMA_BALANCING_DEFAULT_ENABLED))
 		numabalancing_default = true;
 
+	/* Parsed by setup_numabalancing. override == 1 enables, -1 disables */
+	if (numabalancing_override)
+		set_numabalancing_state(numabalancing_override == 1);
+
 	if (nr_node_ids > 1 && !numabalancing_override) {
-		printk(KERN_INFO "Enabling automatic NUMA balancing. "
-			"Configure with numa_balancing= or the kernel.numa_balancing sysctl");
+		printk(KERN_INFO "%s automatic NUMA balancing. "
+			"Configure with numa_balancing= or the "
+			"kernel.numa_balancing sysctl",
+			numabalancing_default ? "Enabling" : "Disabling");
 		set_numabalancing_state(numabalancing_default);
 	}
 }
@@ -2678,13 +2684,12 @@ static int __init setup_numabalancing(ch
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


