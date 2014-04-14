Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbaDNU7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:59:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbaDNU66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:58:58 -0400
Date: Mon, 14 Apr 2014 16:58:55 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] user namespace: fix incorrect memory barriers
Message-ID: <alpine.LRH.2.02.1404141657260.22418@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@vger.kernel.org

---
 kernel/user_namespace.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: linux-3.14-rc5/kernel/user_namespace.c
===================================================================
--- linux-3.14-rc5.orig/kernel/user_namespace.c	2014-03-14 03:28:50.000000000 +0100
+++ linux-3.14-rc5/kernel/user_namespace.c	2014-03-14 03:29:36.000000000 +0100
@@ -152,7 +152,7 @@ static u32 map_id_range_down(struct uid_
 
 	/* Find the matching extent */
 	extents = map->nr_extents;
-	smp_read_barrier_depends();
+	smp_rmb();
 	for (idx = 0; idx < extents; idx++) {
 		first = map->extent[idx].first;
 		last = first + map->extent[idx].count - 1;
@@ -176,7 +176,7 @@ static u32 map_id_down(struct uid_gid_ma
 
 	/* Find the matching extent */
 	extents = map->nr_extents;
-	smp_read_barrier_depends();
+	smp_rmb();
 	for (idx = 0; idx < extents; idx++) {
 		first = map->extent[idx].first;
 		last = first + map->extent[idx].count - 1;
@@ -199,7 +199,7 @@ static u32 map_id_up(struct uid_gid_map 
 
 	/* Find the matching extent */
 	extents = map->nr_extents;
-	smp_read_barrier_depends();
+	smp_rmb();
 	for (idx = 0; idx < extents; idx++) {
 		first = map->extent[idx].lower_first;
 		last = first + map->extent[idx].count - 1;
@@ -615,9 +615,8 @@ static ssize_t map_write(struct file *fi
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
 
