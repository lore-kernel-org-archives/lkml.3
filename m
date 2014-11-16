Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbaKPKzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:55:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34823 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaKPKzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:55:35 -0500
Date: Sun, 16 Nov 2014 02:55:22 -0800
From: tip-bot for Juergen Gross <tipbot@zytor.com>
Message-ID: <tip-5006e45a6bc293b490638210d1a88ac391d2eb92@git.kernel.org>
Cc: stefan.bader@canonical.com, tglx@linutronix.de, mingo@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, jgross@suse.com
Reply-To: mingo@kernel.org, stefan.bader@canonical.com, tglx@linutronix.de,
        jgross@suse.com, linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <1415019724-4317-5-git-send-email-jgross@suse.com>
References: <1415019724-4317-5-git-send-email-jgross@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Use new cache mode type in drivers/video/fbdev/
 vermilion
Git-Commit-ID: 5006e45a6bc293b490638210d1a88ac391d2eb92
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5006e45a6bc293b490638210d1a88ac391d2eb92
Gitweb:     http://git.kernel.org/tip/5006e45a6bc293b490638210d1a88ac391d2eb92
Author:     Juergen Gross <jgross@suse.com>
AuthorDate: Mon, 3 Nov 2014 14:01:50 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 16 Nov 2014 11:04:25 +0100

x86: Use new cache mode type in drivers/video/fbdev/vermilion

Instead of directly using the cache mode bits in the pte switch to
using the cache mode type.

Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stefan.bader@canonical.com
Cc: xen-devel@lists.xensource.com
Cc: konrad.wilk@oracle.com
Cc: ville.syrjala@linux.intel.com
Cc: david.vrabel@citrix.com
Cc: jbeulich@suse.com
Cc: toshi.kani@hp.com
Cc: plagnioj@jcrosoft.com
Cc: tomi.valkeinen@ti.com
Cc: bhelgaas@google.com
Link: http://lkml.kernel.org/r/1415019724-4317-5-git-send-email-jgross@suse.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/video/fbdev/vermilion/vermilion.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/vermilion/vermilion.c b/drivers/video/fbdev/vermilion/vermilion.c
index 5f930ae..6b70d7f 100644
--- a/drivers/video/fbdev/vermilion/vermilion.c
+++ b/drivers/video/fbdev/vermilion/vermilion.c
@@ -1003,13 +1003,15 @@ static int vmlfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 	struct vml_info *vinfo = container_of(info, struct vml_info, info);
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
 	int ret;
+	unsigned long prot;
 
 	ret = vmlfb_vram_offset(vinfo, offset);
 	if (ret)
 		return -EINVAL;
 
-	pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
-	pgprot_val(vma->vm_page_prot) &= ~_PAGE_PWT;
+	prot = pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK;
+	pgprot_val(vma->vm_page_prot) =
+		prot | cachemode2protval(_PAGE_CACHE_MODE_UC_MINUS);
 
 	return vm_iomap_memory(vma, vinfo->vram_start,
 			vinfo->vram_contig_size);
