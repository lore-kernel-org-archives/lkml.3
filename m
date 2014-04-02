Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbaDBUWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:22:42 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42840 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758904AbaDBUN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wei Liu <wei.liu2@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 31/40] xen/balloon: flush persistent kmaps in correct position
Date: Wed,  2 Apr 2014 22:13:17 +0200
Message-Id: <b1e0936fd614d0b3f88ce54e5a59e0dd9590b0b2.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Liu <wei.liu2@citrix.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 09ed3d5ba06137913960f9c9385f71fc384193ab upstream.

Xen balloon driver will update ballooned out pages' P2M entries to point
to scratch page for PV guests. In 24f69373e2 ("xen/balloon: don't alloc
page while non-preemptible", kmap_flush_unused was moved after updating
P2M table. In that case for 32 bit PV guest we might end up with

  P2M    X -----> S  (S is mfn of balloon scratch page)
  M2P    Y -----> X  (Y is mfn in persistent kmap entry)

kmap_flush_unused() iterates through all the PTEs in the kmap address
space, using pte_to_page() to obtain the page. If the p2m and the m2p
are inconsistent the incorrect page is returned.  This will clear
page->address on the wrong page which may cause subsequent oopses if
that page is currently kmap'ed.

Move the flush back between get_page and __set_phys_to_machine to fix
this.

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/xen/balloon.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index b232908a6192..4c437efa9d91 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -405,11 +405,25 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 			state = BP_EAGAIN;
 			break;
 		}
+		scrub_page(page);
 
-		pfn = page_to_pfn(page);
-		frame_list[i] = pfn_to_mfn(pfn);
+		frame_list[i] = page_to_pfn(page);
+	}
 
-		scrub_page(page);
+	/*
+	 * Ensure that ballooned highmem pages don't have kmaps.
+	 *
+	 * Do this before changing the p2m as kmap_flush_unused()
+	 * reads PTEs to obtain pages (and hence needs the original
+	 * p2m entry).
+	 */
+	kmap_flush_unused();
+
+	/* Update direct mapping, invalidate P2M, and add to balloon. */
+	for (i = 0; i < nr_pages; i++) {
+		pfn = frame_list[i];
+		frame_list[i] = pfn_to_mfn(pfn);
+		page = pfn_to_page(pfn);
 
 		/*
 		 * Ballooned out frames are effectively replaced with
@@ -433,11 +447,9 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 		}
 		put_balloon_scratch_page();
 
-		balloon_append(pfn_to_page(pfn));
+		balloon_append(page);
 	}
 
-	/* Ensure that ballooned highmem pages don't have kmaps. */
-	kmap_flush_unused();
 	flush_tlb_all();
 
 	set_xen_guest_handle(reservation.extent_start, frame_list);
-- 
1.9.1

