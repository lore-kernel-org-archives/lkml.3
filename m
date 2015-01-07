Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbbAGSYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:24:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41879 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbbAGSYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:24:33 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: david.vrabel@citrix.com, konrad.wilk@oracle.com, jgross@suse.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com
Subject: [PATCH v2] x86/xen: Free bootmem in free_p2m_page() during early boot
Date: Wed,  7 Jan 2015 13:27:43 -0500
Message-Id: <1420655263-17239-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.9.3
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent changes in p2m we now have legitimate cases when
p2m memory needs to be freed during early boot (i.e. before
slab is initialized).

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
---

v2: Add __ref annotation

 arch/x86/xen/p2m.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index edbc7a6..cab221d 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -167,10 +167,13 @@ static void * __ref alloc_p2m_page(void)
 	return (void *)__get_free_page(GFP_KERNEL | __GFP_REPEAT);
 }
 
-/* Only to be called in case of a race for a page just allocated! */
-static void free_p2m_page(void *p)
+static void __ref free_p2m_page(void *p)
 {
-	BUG_ON(!slab_is_available());
+	if (unlikely(!slab_is_available())) {
+		free_bootmem((unsigned long)p, PAGE_SIZE);
+		return;
+	}
+
 	free_page((unsigned long)p);
 }
 
-- 
1.9.3

