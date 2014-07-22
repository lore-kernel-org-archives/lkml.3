Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbaGVWjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:39:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44745 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252AbaGVW0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:26:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bin Wang <binw@marvell.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 037/116] uio: fix vma io range check in mmap
Date: Tue, 22 Jul 2014 15:20:48 -0700
Message-Id: <1406067727-19683-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bin Wang <binw@marvell.com>

commit ddb09754e6c7239e302c7b675df9bbd415f8de5d upstream.

the vma range size is always page size aligned in mmap, while the
real io space range may not be page aligned, thus leading to range
check failure in the uio_mmap_physical().

for example, in a case of io range size "mem->size == 1KB", and we
have (vma->vm_end - vma->vm_start) == 4KB, due to "len" is aligned
to page size in do_mmap_pgoff().

now fix this issue by align mem->size to page size in the check.

Signed-off-by: Bin Wang <binw@marvell.com>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/uio/uio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 9981b9b..354c095 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -657,7 +657,7 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 
 	if (mem->addr & ~PAGE_MASK)
 		return -ENODEV;
-	if (vma->vm_end - vma->vm_start > mem->size)
+	if (vma->vm_end - vma->vm_start > PAGE_ALIGN(mem->size))
 		return -EINVAL;
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-- 
1.9.1

