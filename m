Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681AbaFQQPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:15:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50377 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933627AbaFQQPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:15:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 007/121] user namespace: fix incorrect memory barriers
Date: Tue, 17 Jun 2014 09:13:20 -0700
Message-Id: <1403021714-16320-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021714-16320-1-git-send-email-kamal@canonical.com>
References: <1403021714-16320-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/user_namespace.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index b9b0b51..372211d 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -147,7 +147,7 @@ static u32 map_id_range_down(struct uid_gid_map *map, u32 id, u32 count)
 
 	/* Find the matching extent */
 	extents = map->nr_extents;
-	smp_read_barrier_depends();
+	smp_rmb();
 	for (idx = 0; idx < extents; idx++) {
 		first = map->extent[idx].first;
 		last = first + map->extent[idx].count - 1;
@@ -171,7 +171,7 @@ static u32 map_id_down(struct uid_gid_map *map, u32 id)
 
 	/* Find the matching extent */
 	extents = map->nr_extents;
-	smp_read_barrier_depends();
+	smp_rmb();
 	for (idx = 0; idx < extents; idx++) {
 		first = map->extent[idx].first;
 		last = first + map->extent[idx].count - 1;
@@ -194,7 +194,7 @@ static u32 map_id_up(struct uid_gid_map *map, u32 id)
 
 	/* Find the matching extent */
 	extents = map->nr_extents;
-	smp_read_barrier_depends();
+	smp_rmb();
 	for (idx = 0; idx < extents; idx++) {
 		first = map->extent[idx].lower_first;
 		last = first + map->extent[idx].count - 1;
@@ -574,9 +574,8 @@ static ssize_t map_write(struct file *file, const char __user *buf,
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
1.9.1

