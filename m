Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbaJaOAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:00:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759693AbaJaOAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:00:42 -0400
From: Juergen Gross <jgross@suse.com>
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 04/17] x86: Use new cache mode type in drivers/video/fbdev/vermilion
Date: Fri, 31 Oct 2014 15:00:20 +0100
Message-Id: <1414764033-30011-5-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414764033-30011-1-git-send-email-jgross@suse.com>
References: <1414764033-30011-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of directly using the cache mode bits in the pte switch to
using the cache mode type.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
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
-- 
1.8.4.5

