Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaDAENS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:13:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaDAENP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:13:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Liu <wei.liu2@citrix.com>, David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 3.13 07/22] xen/balloon: flush persistent kmaps in correct position
Date: Mon, 31 Mar 2014 21:08:37 -0700
Message-Id: <20140401040704.932839871@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140401040703.045139933@linuxfoundation.org>
References: <20140401040703.045139933@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/balloon.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -406,11 +406,25 @@ static enum bp_state decrease_reservatio
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
 
 #ifdef CONFIG_XEN_HAVE_PVMMU
 		/*
@@ -436,11 +450,9 @@ static enum bp_state decrease_reservatio
 		}
 #endif
 
-		balloon_append(pfn_to_page(pfn));
+		balloon_append(page);
 	}
 
-	/* Ensure that ballooned highmem pages don't have kmaps. */
-	kmap_flush_unused();
 	flush_tlb_all();
 
 	set_xen_guest_handle(reservation.extent_start, frame_list);


