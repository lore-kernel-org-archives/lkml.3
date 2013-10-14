Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab3JNJgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:36:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55102 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab3JNJgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:36:13 -0400
Subject: [PATCH 1/3] procfs: fix unintended truncation of returned mapped
 address
To: akpm@linux-foundation.org
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, ebiederm@xmission.com, holzheu@linux.vnet.ibm.com,
        adobriyan@gmail.com, vgoyal@redhat.com
Date: Mon, 14 Oct 2013 18:36:12 +0900
Message-ID: <20131014093611.9801.26658.stgit@localhost6.localdomain6>
In-Reply-To: <20131014093606.9801.11175.stgit@localhost6.localdomain6>
References: <20131014093606.9801.11175.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, proc_reg_get_unmapped_area truncates upper 32-bit of the
mapped virtual address returned from get_unmapped_area method in
pde->proc_fops due to the variable rv of signed integer on
x86_64. This is too small to have vitual address of unsigned long on
x86_64 since on x86_64, signed integer is of 4 bytes while unsigned
long is of 8 bytes. To fix this issue, use unsigned long instead.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 fs/proc/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 9f8ef9b..6c501c4 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -288,7 +288,7 @@ static int proc_reg_mmap(struct file *file, struct vm_area_struct *vma)
 static unsigned long proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr, unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	int rv = -EIO;
+	unsigned long rv = -EIO;
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 	if (use_pde(pde)) {
 		get_unmapped_area = pde->proc_fops->get_unmapped_area;

