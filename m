Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaLEGQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:16:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbaLEGQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:16:39 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH] xen: fix sparse warning in p2m.c
Date: Fri,  5 Dec 2014 07:16:35 +0100
Message-Id: <1417760195-16911-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "Speed up set_phys_to_machine() by using read-only mappings"
introduced a sparse warning:

arch/x86/xen/p2m.c:628:13: sparse: incorrect type in argument 1
                           (different address spaces)

Avoid the warning.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/p2m.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 8b5db51..2defca9 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -615,6 +615,7 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
 	pte_t *ptep;
 	unsigned int level;
+	unsigned long __user *addr;
 
 	/* don't track P2M changes in autotranslate guests */
 	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap)))
@@ -625,7 +626,8 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 		return true;
 	}
 
-	if (likely(!__put_user(mfn, xen_p2m_addr + pfn)))
+	addr = (unsigned long __user *)xen_p2m_addr + pfn;
+	if (likely(!__put_user(mfn, addr)))
 		return true;
 
 	ptep = lookup_address((unsigned long)(xen_p2m_addr + pfn), &level);
-- 
2.1.2

