Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3KELYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:24:14 -0500
Received: from smtp.citrix.com ([66.165.176.89]:30221 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab3KELYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:24:12 -0500
X-IronPort-AV: E=Sophos;i="4.93,639,1378857600"; 
   d="scan'208";a="70656675"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>, Matt Wilson <msw@amazon.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH] grant-table: don't set m2p override if kmap_ops is not set
Date: Tue, 5 Nov 2013 12:24:09 +0100
Message-ID: <1383650649-13971-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO there's no reason to set a m2p override if the mapping is done in
kernel space, so only set the m2p override when kmap_ops is set.

When kmap_ops is not set, just set the correct p2m translation, this
avoids touching the m2p lock, reducing contention around it.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reported-by: Matt Wilson <msw@amazon.com>
Cc: Matt Wilson <msw@amazon.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Boris Ostrovsky <david.vrabel@citrix.com>
---
 drivers/xen/grant-table.c |   30 ++++++++++++++++++++++++++----
 1 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 04cdeb8..ebf7126 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -909,8 +909,19 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		} else {
 			mfn = PFN_DOWN(map_ops[i].dev_bus_addr);
 		}
-		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
-				       &kmap_ops[i] : NULL);
+
+		if (kmap_ops) {
+			ret = m2p_add_override(mfn, pages[i], &kmap_ops[i]);
+		} else {
+			/* No need to set the m2p override, just set p2m */
+			WARN_ON(PagePrivate(pages[i]));
+			SetPagePrivate(pages[i]);
+			set_page_private(pages[i], mfn);
+
+			if (unlikely(!set_phys_to_machine(page_to_pfn(pages[i]), FOREIGN_FRAME(mfn))))
+				ret = -ENOMEM;
+		}
+
 		if (ret)
 			return ret;
 	}
@@ -942,8 +953,19 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 	}
 
 	for (i = 0; i < count; i++) {
-		ret = m2p_remove_override(pages[i], kmap_ops ?
-				       &kmap_ops[i] : NULL);
+		if (kmap_ops) {
+			ret = m2p_remove_override(pages[i], &kmap_ops[i]);
+		} else {
+			/* Remove p2m entry */
+			unsigned long mfn;
+
+			WARN_ON(!PagePrivate(pages[i]));
+			mfn = page_private(pages[i]);
+			ClearPagePrivate(pages[i]);
+
+			if (unlikely(!set_phys_to_machine(page_to_pfn(pages[i]), mfn)))
+				ret = -ENOMEM;
+		}
 		if (ret)
 			return ret;
 	}
-- 
1.7.7.5 (Apple Git-26)

