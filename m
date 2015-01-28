Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbbA2JI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:08:57 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44938 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932843AbbA2JIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:08:50 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Konstantin Khlebnikov <koct9i@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 069/176] ACPI / osl: speedup grace period in acpi_os_map_cleanup
Date: Wed, 28 Jan 2015 15:28:19 +0100
Message-Id: <b3959c772ebaf1efedb44085c5bc43129704274b.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <koct9i@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 74b51ee152b6d99e61ba329799a039453fb9438f upstream.

ACPI maintains cache of ioremap regions to speed up operations and
access to them from irq context where ioremap() calls aren't allowed.
This code abuses synchronize_rcu() on unmap path for synchronization
with fast-path in acpi_os_read/write_memory which uses this cache.

Since v3.10 CPUs are allowed to enter idle state even if they have RCU
callbacks queued, see commit c0f4dfd4f90f1667d234d21f15153ea09a2eaa66
("rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks").
That change caused problems with nvidia proprietary driver which calls
acpi_os_map/unmap_generic_address several times during initialization.
Each unmap calls synchronize_rcu and adds significant delay. Totally
initialization is slowed for a couple of seconds and that is enough to
trigger timeout in hardware, gpu decides to "fell off the bus". Widely
spread workaround is reducing "rcu_idle_gp_delay" from 4 to 1 jiffy.

This patch replaces synchronize_rcu() with synchronize_rcu_expedited()
which is much faster.

Link: https://devtalk.nvidia.com/default/topic/567297/linux/linux-3-10-driver-crash/
Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reported-and-tested-by: Alexander Monakov <amonakov@gmail.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/osl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index e5f416c7f66e..d73f85247272 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -421,7 +421,7 @@ static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
 static void acpi_os_map_cleanup(struct acpi_ioremap *map)
 {
 	if (!map->refcount) {
-		synchronize_rcu();
+		synchronize_rcu_expedited();
 		acpi_unmap(map->phys, map->virt);
 		kfree(map);
 	}
-- 
2.2.2

