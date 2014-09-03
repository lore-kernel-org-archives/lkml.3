Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597AbaICXCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:02:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933856AbaICWSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: [PATCH 3.16 080/125] x86/xen: use vmap() to map grant table pages in PVH guests
Date: Wed,  3 Sep 2014 15:07:17 -0700
Message-Id: <20140903220626.073768295@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 7d951f3ccb0308c95bf76d5eef9886dea35a7013 upstream.

Commit b7dd0e350e0b (x86/xen: safely map and unmap grant frames when
in atomic context) causes PVH guests to crash in
arch_gnttab_map_shared() when they attempted to map the pages for the
grant table.

This use of a PV-specific function during the PVH grant table setup is
non-obvious and not needed.  The standard vmap() function does the
right thing.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reported-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Tested-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/grant-table.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/xen/grant-table.c
+++ b/arch/x86/xen/grant-table.c
@@ -168,6 +168,7 @@ static int __init xlated_setup_gnttab_pa
 {
 	struct page **pages;
 	xen_pfn_t *pfns;
+	void *vaddr;
 	int rc;
 	unsigned int i;
 	unsigned long nr_grant_frames = gnttab_max_grant_frames();
@@ -193,21 +194,20 @@ static int __init xlated_setup_gnttab_pa
 	for (i = 0; i < nr_grant_frames; i++)
 		pfns[i] = page_to_pfn(pages[i]);
 
-	rc = arch_gnttab_map_shared(pfns, nr_grant_frames, nr_grant_frames,
-				    &xen_auto_xlat_grant_frames.vaddr);
-
-	if (rc) {
+	vaddr = vmap(pages, nr_grant_frames, 0, PAGE_KERNEL);
+	if (!vaddr) {
 		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
 			nr_grant_frames, rc);
 		free_xenballooned_pages(nr_grant_frames, pages);
 		kfree(pages);
 		kfree(pfns);
-		return rc;
+		return -ENOMEM;
 	}
 	kfree(pages);
 
 	xen_auto_xlat_grant_frames.pfn = pfns;
 	xen_auto_xlat_grant_frames.count = nr_grant_frames;
+	xen_auto_xlat_grant_frames.vaddr = vaddr;
 
 	return 0;
 }


