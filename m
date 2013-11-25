Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab3KYQWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:22:37 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:40039 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab3KYQWg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 25 Nov 2013 11:22:36 -0500
Message-Id: <529387570200007800106C9F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 25 Nov 2013 16:22:31 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <akpm@linux-foundation.org>
Cc: <davem@davemloft.net>, <adobriyan@gmail.com>, <d.hatayama@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] procfs: also fix proc_reg_get_unmapped_area() for !MMU
 case
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fad1a86e ("procfs: call default get_unmapped_area on MMU-present
architectures"), as its title says, took care of only the MMU case,
leaving the !MMU side still in the regressed state (returning -EIO in
all cases where pde->proc_fops->get_unmapped_area is NULL).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David S. Miller <davem@davemloft.net> 
---
 fs/proc/inode.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- 3.13-rc1/fs/proc/inode.c
+++ 3.13-rc1-proc-get-unmapped-area/fs/proc/inode.c
@@ -292,16 +292,19 @@ proc_reg_get_unmapped_area(struct file *
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	unsigned long rv = -EIO;
-	unsigned long (*get_area)(struct file *, unsigned long, unsigned long,
-				  unsigned long, unsigned long) = NULL;
+
 	if (use_pde(pde)) {
+		typeof(proc_reg_get_unmapped_area) *get_area
 #ifdef CONFIG_MMU
-		get_area = current->mm->get_unmapped_area;
+			= pde->proc_fops->get_unmapped_area
+			  ?: current->mm->get_unmapped_area;
+#else
+			= pde->proc_fops->get_unmapped_area;
 #endif
-		if (pde->proc_fops->get_unmapped_area)
-			get_area = pde->proc_fops->get_unmapped_area;
-		if (get_area)
-			rv = get_area(file, orig_addr, len, pgoff, flags);
+
+		rv = get_area
+		     ? get_area(file, orig_addr, len, pgoff, flags)
+		     : orig_addr;
 		unuse_pde(pde);
 	}
 	return rv;



