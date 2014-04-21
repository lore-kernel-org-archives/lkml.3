Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaDUEei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:34:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaDUEeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:34:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 01/32] user namespace: fix incorrect memory barriers
Date: Sun, 20 Apr 2014 19:13:18 -0700
Message-Id: <20140421021134.078323515@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/user_namespace.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
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
 


