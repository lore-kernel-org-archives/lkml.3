Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaDOOTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:19:42 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58075 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbaDOOQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:16:07 -0400
X-IronPort-AV: E=Sophos;i="4.97,864,1389744000"; 
   d="scan'208";a="121257945"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xenproject.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/9] x86/xen: rename early_p2m_alloc() and early_p2m_alloc_middle()
Date: Tue, 15 Apr 2014 15:15:29 +0100
Message-ID: <1397571337-20409-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
References: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_p2m_alloc_middle() allocates a new leaf page and
early_p2m_alloc() allocates a new middle page.  This is confusing.

Swap the names so they match what the functions actually do.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/p2m.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 85e5d78..4fc71cc 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -596,7 +596,7 @@ static bool alloc_p2m(unsigned long pfn)
 	return true;
 }
 
-static bool __init early_alloc_p2m_middle(unsigned long pfn, bool check_boundary)
+static bool __init early_alloc_p2m(unsigned long pfn, bool check_boundary)
 {
 	unsigned topidx, mididx, idx;
 	unsigned long *p2m;
@@ -638,7 +638,7 @@ static bool __init early_alloc_p2m_middle(unsigned long pfn, bool check_boundary
 	return true;
 }
 
-static bool __init early_alloc_p2m(unsigned long pfn)
+static bool __init early_alloc_p2m_middle(unsigned long pfn)
 {
 	unsigned topidx = p2m_top_index(pfn);
 	unsigned long *mid_mfn_p;
@@ -663,7 +663,7 @@ static bool __init early_alloc_p2m(unsigned long pfn)
 		p2m_top_mfn_p[topidx] = mid_mfn_p;
 		p2m_top_mfn[topidx] = virt_to_mfn(mid_mfn_p);
 		/* Note: we don't set mid_mfn_p[midix] here,
-		 * look in early_alloc_p2m_middle */
+		 * look in early_alloc_p2m() */
 	}
 	return true;
 }
@@ -739,7 +739,7 @@ found:
 
 	/* This shouldn't happen */
 	if (WARN_ON(p2m_top[topidx] == p2m_mid_missing))
-		early_alloc_p2m(set_pfn);
+		early_alloc_p2m_middle(set_pfn);
 
 	if (WARN_ON(p2m_top[topidx][mididx] != p2m_missing))
 		return false;
@@ -754,13 +754,13 @@ found:
 bool __init early_set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
 	if (unlikely(!__set_phys_to_machine(pfn, mfn)))  {
-		if (!early_alloc_p2m(pfn))
+		if (!early_alloc_p2m_middle(pfn))
 			return false;
 
 		if (early_can_reuse_p2m_middle(pfn, mfn))
 			return __set_phys_to_machine(pfn, mfn);
 
-		if (!early_alloc_p2m_middle(pfn, false /* boundary crossover OK!*/))
+		if (!early_alloc_p2m(pfn, false /* boundary crossover OK!*/))
 			return false;
 
 		if (!__set_phys_to_machine(pfn, mfn))
-- 
1.7.2.5

