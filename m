Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3JBOeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:34:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab3JBO26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:58 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
        Timur Tabi <timur@freescale.com>
Subject: [PATCH 13/26] fsl_hypervisor: Convert ioctl_memcpy() to use get_user_pages_fast()
Date: Wed,  2 Oct 2013 16:27:54 +0200
Message-Id: <1380724087-13927-14-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Timur Tabi <timur@freescale.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/virt/fsl_hypervisor.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
index d294f67d6f84..791a46a5dd2a 100644
--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -242,13 +242,8 @@ static long ioctl_memcpy(struct fsl_hv_ioctl_memcpy __user *p)
 	sg_list = PTR_ALIGN(sg_list_unaligned, sizeof(struct fh_sg_list));
 
 	/* Get the physical addresses of the source buffer */
-	down_read(&current->mm->mmap_sem);
-	num_pinned = get_user_pages(current, current->mm,
-		param.local_vaddr - lb_offset, num_pages,
-		(param.source == -1) ? READ : WRITE,
-		0, pages, NULL);
-	up_read(&current->mm->mmap_sem);
-
+	num_pinned = get_user_pages_fast(param.local_vaddr - lb_offset,
+		num_pages, (param.source == -1) ? READ : WRITE, pages);
 	if (num_pinned != num_pages) {
 		/* get_user_pages() failed */
 		pr_debug("fsl-hv: could not lock source buffer\n");
-- 
1.8.1.4

