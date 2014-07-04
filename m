Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031421AbaGDXCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:02:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760541AbaGDWQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:16:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yann Droneaud <ydroneaud@opteya.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.15 26/66] IB/mlx5: add missing padding at end of struct mlx5_ib_create_cq
Date: Fri,  4 Jul 2014 15:14:25 -0700
Message-Id: <20140704221424.005219735@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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

#  +++ obj-i386/drivers/infiniband/hw/mlx5/mlx5_ib.o.pahole.txt    2014-03-28 11:43:07.386413682 +0100
#  --- obj-x86_64/drivers/infiniband/hw/mlx5/mlx5_ib.o.pahole.txt  2014-03-27 13:06:17.788472721 +0100
#  @@ -34,9 +34,8 @@ struct mlx5_ib_create_cq {
#          __u64                      db_addr;              /*     8     8 */
#          __u32                      cqe_size;             /*    16     4 */
#
#  -       /* size: 20, cachelines: 1, members: 3 */
#  -       /* last cacheline: 20 bytes */
#  +       /* size: 24, cachelines: 1, members: 3 */
#  +       /* padding: 4 */
#  +       /* last cacheline: 24 bytes */
#   };

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/cq.c   |   13 ++++++++++++-
 drivers/infiniband/hw/mlx5/user.h |    1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -32,6 +32,7 @@
 
 #include <linux/kref.h>
 #include <rdma/ib_umem.h>
+#include <rdma/ib_user_verbs.h>
 #include "mlx5_ib.h"
 #include "user.h"
 
@@ -602,14 +603,24 @@ static int create_cq_user(struct mlx5_ib
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
 
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -91,6 +91,7 @@ struct mlx5_ib_create_cq {
 	__u64	buf_addr;
 	__u64	db_addr;
 	__u32	cqe_size;
+	__u32	reserved; /* explicit padding (optional on i386) */
 };
 
 struct mlx5_ib_create_cq_resp {


