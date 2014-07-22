Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582AbaGVWjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:39:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44742 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933222AbaGVW0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:26:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Roland Dreier <roland@purestorage.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 044/116] RDMA/cxgb4: Add missing padding at end of struct c4iw_create_cq_resp
Date: Tue, 22 Jul 2014 15:20:55 -0700
Message-Id: <1406067727-19683-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yann Droneaud <ydroneaud@opteya.com>

commit b6f04d3d21458818073a2f5af5339f958864bf71 upstream.

The i386 ABI disagrees with most other ABIs regarding alignment of
data types larger than 4 bytes: on most ABIs a padding must be added
at end of the structures, while it is not required on i386.

So for most ABI struct c4iw_create_cq_resp gets implicitly padded
to be aligned on a 8 bytes multiple, while for i386, such padding
is not added.

The tool pahole can be used to find such implicit padding:

  $ pahole --anon_include \
           --nested_anon_include \
           --recursive \
           --class_name c4iw_create_cq_resp \
           drivers/infiniband/hw/cxgb4/iw_cxgb4.o

Then, structure layout can be compared between i386 and x86_64:

  +++ obj-i386/drivers/infiniband/hw/cxgb4/iw_cxgb4.o.pahole.txt   2014-03-28 11:43:05.547432195 +0100
  --- obj-x86_64/drivers/infiniband/hw/cxgb4/iw_cxgb4.o.pahole.txt 2014-03-28 10:55:10.990133017 +0100
  @@ -14,9 +13,8 @@ struct c4iw_create_cq_resp {
          __u32                      size;                 /*    28     4 */
          __u32                      qid_mask;             /*    32     4 */

  -       /* size: 36, cachelines: 1, members: 6 */
  -       /* last cacheline: 36 bytes */
  +       /* size: 40, cachelines: 1, members: 6 */
  +       /* padding: 4 */
  +       /* last cacheline: 40 bytes */
   };

This ABI disagreement will make an x86_64 kernel try to write past the
buffer provided by an i386 binary.

When boundary check will be implemented, the x86_64 kernel will refuse
to write past the i386 userspace provided buffer and the uverbs will
fail.

If the structure is on a page boundary and the next page is not
mapped, ib_copy_to_udata() will fail and the uverb will fail.

This patch adds an explicit padding at end of structure
c4iw_create_cq_resp, and, like 92b0ca7cb149 ("IB/mlx5: Fix stack info
leak in mlx5_ib_alloc_ucontext()"), makes function c4iw_create_cq()
not writting this padding field to userspace. This way, x86_64 kernel
will be able to write struct c4iw_create_cq_resp as expected by
unpatched and patched i386 libcxgb4.

Link: http://marc.info/?i=cover.1399309513.git.ydroneaud@opteya.com
Fixes: cfdda9d764362 ("RDMA/cxgb4: Add driver for Chelsio T4 RNIC")
Fixes: e24a72a3302a6 ("RDMA/cxgb4: Fix four byte info leak in c4iw_create_cq()")
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Acked-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/hw/cxgb4/cq.c   | 3 ++-
 drivers/infiniband/hw/cxgb4/user.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 0f1607c..3bd6b69 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -843,7 +843,8 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 		uresp.gts_key = ucontext->key;
 		ucontext->key += PAGE_SIZE;
 		spin_unlock(&ucontext->mmap_lock);
-		ret = ib_copy_to_udata(udata, &uresp, sizeof uresp);
+		ret = ib_copy_to_udata(udata, &uresp,
+				       sizeof(uresp) - sizeof(uresp.reserved));
 		if (ret)
 			goto err5;
 
diff --git a/drivers/infiniband/hw/cxgb4/user.h b/drivers/infiniband/hw/cxgb4/user.h
index 32b754c..4893599 100644
--- a/drivers/infiniband/hw/cxgb4/user.h
+++ b/drivers/infiniband/hw/cxgb4/user.h
@@ -48,6 +48,7 @@ struct c4iw_create_cq_resp {
 	__u32 cqid;
 	__u32 size;
 	__u32 qid_mask;
+	__u32 reserved; /* explicit padding (optional for i386) */
 };
 
 
-- 
1.9.1

