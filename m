Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaCYFwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 01:52:16 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19473 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbaCYFwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 01:52:14 -0400
From: Bin Wang <binw@marvell.com>
To: <hjk@hansjkoch.de>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC: Bin Wang <binw@marvell.com>
Subject: [PATCH] uio: fix vma io range check in mmap
Date: Tue, 25 Mar 2014 13:52:06 +0800
Message-ID: <1395726726-16296-1-git-send-email-binw@marvell.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-25_03:2014-03-24,2014-03-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1403240202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the vma range size is always page size aligned in mmap, while the
real io space range may not be page aligned, thus leading to range
check failure in the uio_mmap_physical().

for example, in a case of io range size "mem->size == 1KB", and we
have (vma->vm_end - vma->vm_start) == 4KB, due to "len" is aligned
to page size in do_mmap_pgoff().

now fix this issue by align mem->size to page size in the check.

Signed-off-by: Bin Wang <binw@marvell.com>
---
 drivers/uio/uio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index a673e5b..e371f5a 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -655,7 +655,7 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 
 	if (mem->addr & ~PAGE_MASK)
 		return -ENODEV;
-	if (vma->vm_end - vma->vm_start > mem->size)
+	if (vma->vm_end - vma->vm_start > PAGE_ALIGN(mem->size))
 		return -EINVAL;
 
 	vma->vm_ops = &uio_physical_vm_ops;
-- 
1.7.0.4

