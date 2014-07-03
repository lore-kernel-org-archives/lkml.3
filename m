Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbaGCKKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:10:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51679 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384AbaGCJV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 049/198] IB/mlx5: add missing padding at end of struct mlx5_ib_create_srq
Date: Thu,  3 Jul 2014 10:18:12 +0100
Message-Id: <1404379241-8590-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yann Droneaud <ydroneaud@opteya.com>

commit 43bc889380c2ad9aa230eccc03a15cc52cf710d4 upstream.

The i386 ABI disagrees with most other ABIs regarding alignment of
data type larger than 4 bytes: on most ABIs a padding must be added at
end of the structures, while it is not required on i386.

So for most ABIs struct mlx5_ib_create_srq gets implicitly padded to be
aligned on a 8 bytes multiple, while for i386, such padding is not
added.

Tool pahole could be used to find such implicit padding:

  $ pahole --anon_include \
           --nested_anon_include \
           --recursive \
           --class_name mlx5_ib_create_srq \
           drivers/infiniband/hw/mlx5/mlx5_ib.o

Then, structure layout can be compared between i386 and x86_64:

  +++ obj-i386/drivers/infiniband/hw/mlx5/mlx5_ib.o.pahole.txt    2014-03-28 11:43:07.386413682 +0100
  --- obj-x86_64/drivers/infiniband/hw/mlx5/mlx5_ib.o.pahole.txt  2014-03-27 13:06:17.788472721 +0100
  @@ -69,7 +68,6 @@ struct mlx5_ib_create_srq {
          __u64                      db_addr;              /*     8     8 */
          __u32                      flags;                /*    16     4 */

  -       /* size: 20, cachelines: 1, members: 3 */
  -       /* last cacheline: 20 bytes */
  +       /* size: 24, cachelines: 1, members: 3 */
  +       /* padding: 4 */
  +       /* last cacheline: 24 bytes */
   };

ABI disagreement will make an x86_64 kernel try to read past
the buffer provided by an i386 binary.

When boundary check will be implemented, the x86_64 kernel will
refuse to read past the i386 userspace provided buffer and the
uverb will fail.

Anyway, if the structure lay in memory on a page boundary and
next page is not mapped, ib_copy_from_udata() will fail and the
uverb will fail.

This patch makes create_srq_user() takes care of the input
data size to handle the case where no padding was provided.

This way, x86_64 kernel will be able to handle struct mlx5_ib_create_srq
as sent by unpatched and patched i386 libmlx5.

Link: http://marc.info/?i=cover.1399309513.git.ydroneaud@opteya.com
Fixes: e126ba97dba9e ("mlx5: Add driver for Mellanox Connect-IB adapter")
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/hw/mlx5/srq.c  | 14 +++++++++++++-
 drivers/infiniband/hw/mlx5/user.h |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 84d297afd6a9..77f98f2b4b4f 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -35,6 +35,7 @@
 #include <linux/mlx5/srq.h>
 #include <linux/slab.h>
 #include <rdma/ib_umem.h>
+#include <rdma/ib_user_verbs.h>
 
 #include "mlx5_ib.h"
 #include "user.h"
@@ -78,16 +79,27 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct mlx5_ib_create_srq ucmd;
+	size_t ucmdlen;
 	int err;
 	int npages;
 	int page_shift;
 	int ncont;
 	u32 offset;
 
-	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
+	ucmdlen =
+		(udata->inlen - sizeof(struct ib_uverbs_cmd_hdr) <
+		 sizeof(ucmd)) ? (sizeof(ucmd) -
+				  sizeof(ucmd.reserved)) : sizeof(ucmd);
+
+	if (ib_copy_from_udata(&ucmd, udata, ucmdlen)) {
 		mlx5_ib_dbg(dev, "failed copy udata\n");
 		return -EFAULT;
 	}
+
+	if (ucmdlen == sizeof(ucmd) &&
+	    ucmd.reserved != 0)
+		return -EINVAL;
+
 	srq->wq_sig = !!(ucmd.flags & MLX5_SRQ_FLAG_SIGNATURE);
 
 	srq->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr, buf_size,
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index e7da977e2548..84fea5d00cd2 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -100,6 +100,7 @@ struct mlx5_ib_create_srq {
 	__u64	buf_addr;
 	__u64	db_addr;
 	__u32	flags;
+	__u32	reserved; /* explicit padding (optional on i386) */
 };
 
 struct mlx5_ib_create_srq_resp {
-- 
1.9.1

