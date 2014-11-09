Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaKIKxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 05:53:46 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:47602 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaKIKxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 05:53:42 -0500
Subject: [PATCH v2] ACPI/osl: speedup grace period in acpi_os_map_cleanup
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Cc: Tom Boshoven <tomboshoven@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, x86@kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Alexander Monakov <amonakov@gmail.com>
Date: Sun, 09 Nov 2014 13:53:37 +0400
Message-ID: <20141109105337.4952.36899.stgit@zurg>
In-Reply-To: <20141108094717.9388.34638.stgit@zurg>
References: <20141108094717.9388.34638.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reported-and-tested-by: Alexander Monakov <amonakov@gmail.com>
Cc: Tom Boshoven <tomboshoven@gmail.com>
Link: https://devtalk.nvidia.com/default/topic/567297/linux/linux-3-10-driver-crash/
---
 drivers/acpi/osl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 9964f70..217713c 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -436,7 +436,7 @@ static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
 static void acpi_os_map_cleanup(struct acpi_ioremap *map)
 {
 	if (!map->refcount) {
-		synchronize_rcu();
+		synchronize_rcu_expedited();
 		acpi_unmap(map->phys, map->virt);
 		kfree(map);
 	}

