Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747AbaEEMuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:50:37 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41030 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932319AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 26/50] user namespace: fix incorrect memory barriers
Date: Mon,  5 May 2014 14:43:08 +0200
Message-Id: <4eaff7d2f4cc1768e5b336128d1653522c8fcf82.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e79323bd87808fdfbc68ce6c5371bd224d9672ee upstream.

smp_read_barrier_depends() can be used if there is data dependency between
the readers - i.e. if the read operation after the barrier uses address
that was obtained from the read operation before the barrier.

In this file, there is only control dependency, no data dependecy, so the
use of smp_read_barrier_depends() is incorrect. The code could fail in the
following way:
* the cpu predicts that idx < entries is true and starts executing the
  body of the for loop
* the cpu fetches map->extent[0].first and map->extent[0].count
* the cpu fetches map->nr_extents
* the cpu verifies that idx < extents is true, so it commits the
  instructions in the body of the for loop

The problem is that in this scenario, the cpu read map->extent[0].first
and map->nr_extents in the wrong order. We need a full read memory barrier
to prevent it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/user_namespace.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 13fb1134ba58..6991139e3303 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -146,7 +146,7 @@ static u32 map_id_range_down(struct uid_gid_map *map, u32 id, u32 count)
 
 	/* Find the matching extent */
 	extents = map->nr_extents;
-	smp_read_barrier_depends();
+	smp_rmb();
 	for (idx = 0; idx < extents; idx++) {
 		first = map->extent[idx].first;
 		last = first + map->extent[idx].count - 1;
@@ -170,7 +170,7 @@ static u32 map_id_down(struct uid_gid_map *map, u32 id)
 
 	/* Find the matching extent */
 	extents = map->nr_extents;
-	smp_read_barrier_depends();
+	smp_rmb();
 	for (idx = 0; idx < extents; idx++) {
 		first = map->extent[idx].first;
 		last = first + map->extent[idx].count - 1;
@@ -193,7 +193,7 @@ static u32 map_id_up(struct uid_gid_map *map, u32 id)
 
 	/* Find the matching extent */
 	extents = map->nr_extents;
-	smp_read_barrier_depends();
+	smp_rmb();
 	for (idx = 0; idx < extents; idx++) {
 		first = map->extent[idx].lower_first;
 		last = first + map->extent[idx].count - 1;
@@ -609,9 +609,8 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	 * were written before the count of the extents.
 	 *
 	 * To achieve this smp_wmb() is used on guarantee the write
-	 * order and smp_read_barrier_depends() is guaranteed that we
-	 * don't have crazy architectures returning stale data.
-	 *
+	 * order and smp_rmb() is guaranteed that we don't have crazy
+	 * architectures returning stale data.
 	 */
 	mutex_lock(&id_map_mutex);
 
-- 
1.9.2

