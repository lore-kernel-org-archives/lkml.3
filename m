Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbaGCKLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:11:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51672 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758365AbaGCJV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 048/198] IB/mlx5: add missing padding at end of struct mlx5_ib_create_cq
Date: Thu,  3 Jul 2014 10:18:11 +0100
Message-Id: <1404379241-8590-49-git-send-email-luis.henriques@canonical.com>
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

commit a8237b32a3faab155a5dc8f886452147ce73da3e upstream.

The i386 ABI disagrees with most other ABIs regarding alignment of
data type larger than 4 bytes: on most ABIs a padding must be added at
end of the structures, while it is not required on i386.

So for most ABI struct mlx5_ib_create_cq get padded to be aligned on a
8 bytes multiple, while for i386, such padding is not added.

The tool pahole can be used to find such implicit padding:

  $ pahole --anon_include \
  	 --nested_anon_include \
  	 --recursive \
  	 --class_name mlx5_ib_create_cq \
  	 drivers/infiniband/hw/mlx5/mlx5_ib.o

Then, structure layout can be compared between i386 and x86_64:

  +++ obj-i386/drivers/infiniband/hw/mlx5/mlx5_ib.o.pahole.txt    2014-03-28 11:43:07.386413682 +0100
  --- obj-x86_64/drivers/infiniband/hw/mlx5/mlx5_ib.o.pahole.txt  2014-03-27 13:06:17.788472721 +0100
  @@ -34,9 +34,8 @@ struct mlx5_ib_create_cq {
          __u64                      db_addr;              /*     8     8 */
          __u32                      cqe_size;             /*    16     4 */

  -       /* size: 20, cachelines: 1, members: 3 */
  -       /* last cacheline: 20 bytes */
  +       /* size: 24, cachelines: 1, members: 3 */
  +       /* padding: 4 */
  +       /* last cacheline: 24 bytes */
   };

This ABI disagreement will make an x86_64 kernel try to read past the
buffer provided by an i386 binary.

When boundary check will be implemented, a x86_64 kernel will refuse
to read past the i386 userspace provided buffer and the uverb will
fail.

Anyway, if the structure lies in memory on a page boundary and next
page is not mapped, ib_copy_from_udata() will fail when trying to read
the 4 bytes of padding and the uverb will fail.

This patch makes create_cq_user() takes care of the input data size to
handle the case where no padding is provided.

This way, x86_64 kernel will be able to handle struct
mlx5_ib_create_cq as sent by unpatched and patched i386 libmlx5.

Link: http://marc.info/?i=cover.1399309513.git.ydroneaud@opteya.com
Fixes: e126ba97dba9e ("mlx5: Add driver for Mellanox Connect-IB adapter")
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/hw/mlx5/cq.c   | 13 ++++++++++++-
 drivers/infiniband/hw/mlx5/user.h |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 344ab03948a3..706833ab7e7e 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -32,6 +32,7 @@
 
 #include <linux/kref.h>
 #include <rdma/ib_umem.h>
+#include <rdma/ib_user_verbs.h>
 #include "mlx5_ib.h"
 #include "user.h"
 
@@ -518,14 +519,24 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 			  int *cqe_size, int *index, int *inlen)
 {
 	struct mlx5_ib_create_cq ucmd;
+	size_t ucmdlen;
 	int page_shift;
 	int npages;
 	int ncont;
 	int err;
 
-	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
+	ucmdlen =
+		(udata->inlen - sizeof(struct ib_uverbs_cmd_hdr) <
+		 sizeof(ucmd)) ? (sizeof(ucmd) -
+				  sizeof(ucmd.reserved)) : sizeof(ucmd);
+
+	if (ib_copy_from_udata(&ucmd, udata, ucmdlen))
 		return -EFAULT;
 
+	if (ucmdlen == sizeof(ucmd) &&
+	    ucmd.reserved != 0)
+		return -EINVAL;
+
 	if (ucmd.cqe_size != 64 && ucmd.cqe_size != 128)
 		return -EINVAL;
 
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index a886de3e593c..e7da977e2548 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -84,6 +84,7 @@ struct mlx5_ib_create_cq {
 	__u64	buf_addr;
 	__u64	db_addr;
 	__u32	cqe_size;
+	__u32	reserved; /* explicit padding (optional on i386) */
 };
 
 struct mlx5_ib_create_cq_resp {
-- 
1.9.1

