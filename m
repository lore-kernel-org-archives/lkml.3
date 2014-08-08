Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbaHHVDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:03:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41357 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbaHHUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 116/259] xen/balloon: set ballooned out pages as invalid in p2m
Date: Fri,  8 Aug 2014 13:38:59 -0700
Message-Id: <1407530482-4483-117-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit fb9a0c443691ceaab3daba966bbbd9f5ff3aa26f upstream.

Since cd9151e26d31048b2b5e00fd02e110e07d2200c9 (xen/balloon: set a
mapping for ballooned out pages), a ballooned out page had its entry
in the p2m set to the MFN of one of the scratch pages.  This means
that the p2m will contain many entries pointing to the same MFN.

During a domain save, these many-to-one entries are not identified as
such and the scratch page is saved multiple times. On restore the
ballooned pages are populated with new frames and the domain may use
up its allocation before all pages can be restored.

Since the original fix only needed to keep a mapping for the ballooned
page it is safe to set ballooned out pages as INVALID_P2M_ENTRY in the
p2m (as they were before). Thus preventing them from being saved and
re-populated on restore.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reported-by: Marek Marczykowski <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski <marmarek@invisiblethingslab.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/xen/balloon.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 2c85267..6b831b1 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -433,20 +433,18 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 		 * p2m are consistent.
 		 */
 		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-			unsigned long p;
-			struct page   *scratch_page = get_balloon_scratch_page();
-
 			if (!PageHighMem(page)) {
+				struct page *scratch_page = get_balloon_scratch_page();
+
 				ret = HYPERVISOR_update_va_mapping(
 						(unsigned long)__va(pfn << PAGE_SHIFT),
 						pfn_pte(page_to_pfn(scratch_page),
 							PAGE_KERNEL_RO), 0);
 				BUG_ON(ret);
-			}
-			p = page_to_pfn(scratch_page);
-			__set_phys_to_machine(pfn, pfn_to_mfn(p));
 
-			put_balloon_scratch_page();
+				put_balloon_scratch_page();
+			}
+			__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
 		}
 #endif
 
-- 
1.9.1

