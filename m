Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112Ab3JPLcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:32:46 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:45509 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab3JPLcp convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 16 Oct 2013 07:32:45 -0400
Message-Id: <525E957802000078000FB6FE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 16 Oct 2013 12:32:40 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <davem@davemloft.net>
Cc: <adobriyan@gmail.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix proc_reg_get_unmapped_area()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c4fe24485729fc2cbff324c111e67a1cc2f9adea ("sparc: fix PCI device
proc file mmap(2)"), while fixing one problem, introduced two new ones:
- the function truncates the return value from ->get_unmapped_area() on
  64-bit architectures,
- _all_ descendants are now required to set .get_unmapped_area to non-
  NULL, which wasn't necessary before (and shouldn't be).

Both - afaict - are a result from a too simplistic copy'n'paste from
proc_reg_mmap() done in that change.

This likely also addresses reports like the one at
http://linux-kernel.2935.n7.nabble.com/mmap-for-proc-vmcore-broken-since-3-12-rc1-td729326.html.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>

---
 fs/proc/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- 3.12-rc5/fs/proc/inode.c
+++ 3.12-rc5-proc-get-unmapped-area/fs/proc/inode.c
@@ -288,12 +288,12 @@ static int proc_reg_mmap(struct file *fi
 static unsigned long proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr, unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	int rv = -EIO;
-	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+	unsigned long rv = -EIO;
+
 	if (use_pde(pde)) {
-		get_unmapped_area = pde->proc_fops->get_unmapped_area;
-		if (get_unmapped_area)
-			rv = get_unmapped_area(file, orig_addr, len, pgoff, flags);
+		rv = (pde->proc_fops->get_unmapped_area
+		      ?: current->mm->get_unmapped_area)(file, orig_addr, len,
+							 pgoff, flags);
 		unuse_pde(pde);
 	}
 	return rv;



