Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3JNJgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:36:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33811 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab3JNJgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:36:20 -0400
Subject: [PATCH 2/3] procfs: Call default get_unmapped_area on MMU-present
 architectures
To: akpm@linux-foundation.org
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, ebiederm@xmission.com, holzheu@linux.vnet.ibm.com,
        adobriyan@gmail.com, vgoyal@redhat.com
Date: Mon, 14 Oct 2013 18:36:17 +0900
Message-ID: <20131014093617.9801.68068.stgit@localhost6.localdomain6>
In-Reply-To: <20131014093606.9801.11175.stgit@localhost6.localdomain6>
References: <20131014093606.9801.11175.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c4fe24485729fc2cbff324c111e67a1cc2f9adea added
proc_reg_get_unmapped_area in proc_reg_file_ops and
proc_reg_file_ops_no_compat, by which now mmap always returns EIO if
get_unmapped_area method is not defiend for the target procfs file,
which causes regression of mmap on /proc/vmcore.

To address this issue, like get_unmapped_area(), call default
current->mm->get_unmapped_area on MMU-present architectures if
pde->proc_fops->get_unmapped_area, i.e. the one in actual file
operation in the procfs file, is not defined.

Reported-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/inode.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 6c501c4..8eaa1ba 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -289,9 +289,13 @@ static unsigned long proc_reg_get_unmapped_area(struct file *file, unsigned long
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	unsigned long rv = -EIO;
-	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long) = NULL;
 	if (use_pde(pde)) {
-		get_unmapped_area = pde->proc_fops->get_unmapped_area;
+#ifdef CONFIG_MMU
+		get_unmapped_area = current->mm->get_unmapped_area;
+#endif
+		if (pde->proc_fops->get_unmapped_area)
+			get_unmapped_area = pde->proc_fops->get_unmapped_area;
 		if (get_unmapped_area)
 			rv = get_unmapped_area(file, orig_addr, len, pgoff, flags);
 		unuse_pde(pde);

