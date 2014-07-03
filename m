Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbaGCInw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:43:52 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45952 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbaGCIna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:30 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 22/23] drbd: implicitly truncate cpu-mask
Date: Thu,  3 Jul 2014 10:43:14 +0200
Message-Id: <1404376995-4877-23-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Don't error out with misleading "out of memory"
if the cpu-mask has more bits set than there are CPUs.
Just truncate to nr_cpu_ids implicitly.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9712bcc..9b465bb 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2541,6 +2541,20 @@ int set_resource_options(struct drbd_resource *resource, struct res_opts *res_op
 	if (nr_cpu_ids > 1 && res_opts->cpu_mask[0] != 0) {
 		err = bitmap_parse(res_opts->cpu_mask, DRBD_CPU_MASK_SIZE,
 				   cpumask_bits(new_cpu_mask), nr_cpu_ids);
+		if (err == -EOVERFLOW) {
+			/* So what. mask it out. */
+			cpumask_var_t tmp_cpu_mask;
+			if (zalloc_cpumask_var(&tmp_cpu_mask, GFP_KERNEL)) {
+				cpumask_setall(tmp_cpu_mask);
+				cpumask_and(new_cpu_mask, new_cpu_mask, tmp_cpu_mask);
+				drbd_warn(resource, "Overflow in bitmap_parse(%.12s%s), truncating to %u bits\n",
+					res_opts->cpu_mask,
+					strlen(res_opts->cpu_mask) > 12 ? "..." : "",
+					nr_cpu_ids);
+				free_cpumask_var(tmp_cpu_mask);
+				err = 0;
+			}
+		}
 		if (err) {
 			drbd_warn(resource, "bitmap_parse() failed with %d\n", err);
 			/* retcode = ERR_CPU_MASK_PARSE; */
-- 
1.9.1

