Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3JNJg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:36:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33815 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab3JNJgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:36:24 -0400
Subject: [PATCH 3/3] procfs: clean up proc_reg_get_unmapped_area for
 80-column limit
To: akpm@linux-foundation.org
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, ebiederm@xmission.com, holzheu@linux.vnet.ibm.com,
        adobriyan@gmail.com, vgoyal@redhat.com
Date: Mon, 14 Oct 2013 18:36:22 +0900
Message-ID: <20131014093622.9801.75614.stgit@localhost6.localdomain6>
In-Reply-To: <20131014093606.9801.11175.stgit@localhost6.localdomain6>
References: <20131014093606.9801.11175.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up proc_reg_get_unmapped_area due to its 80-column limit
violation.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 fs/proc/inode.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 8eaa1ba..28955d4 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -285,19 +285,23 @@ static int proc_reg_mmap(struct file *file, struct vm_area_struct *vma)
 	return rv;
 }
 
-static unsigned long proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr, unsigned long len, unsigned long pgoff, unsigned long flags)
+static unsigned long
+proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr,
+			   unsigned long len, unsigned long pgoff,
+			   unsigned long flags)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	unsigned long rv = -EIO;
-	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long) = NULL;
+	unsigned long (*get_area)(struct file *, unsigned long, unsigned long,
+				  unsigned long, unsigned long) = NULL;
 	if (use_pde(pde)) {
 #ifdef CONFIG_MMU
-		get_unmapped_area = current->mm->get_unmapped_area;
+		get_area = current->mm->get_unmapped_area;
 #endif
 		if (pde->proc_fops->get_unmapped_area)
-			get_unmapped_area = pde->proc_fops->get_unmapped_area;
-		if (get_unmapped_area)
-			rv = get_unmapped_area(file, orig_addr, len, pgoff, flags);
+			get_area = pde->proc_fops->get_unmapped_area;
+		if (get_area)
+			rv = get_area(file, orig_addr, len, pgoff, flags);
 		unuse_pde(pde);
 	}
 	return rv;

