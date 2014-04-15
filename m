Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaDOORQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:17:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58085 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaDOOQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:16:09 -0400
X-IronPort-AV: E=Sophos;i="4.97,864,1389744000"; 
   d="scan'208";a="121257948"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xenproject.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/9] x86/xen: fix set_phys_range_identity() if pfn_e > MAX_P2M_PFN
Date: Tue, 15 Apr 2014 15:15:30 +0100
Message-ID: <1397571337-20409-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
References: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow set_phys_range_identity() to work with a range that overlaps
MAX_P2M_PFN by clamping pfn_e to MAX_P2M_PFN.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/p2m.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 4fc71cc..82c8c93 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -774,7 +774,7 @@ unsigned long __init set_phys_range_identity(unsigned long pfn_s,
 {
 	unsigned long pfn;
 
-	if (unlikely(pfn_s >= MAX_P2M_PFN || pfn_e >= MAX_P2M_PFN))
+	if (unlikely(pfn_s >= MAX_P2M_PFN))
 		return 0;
 
 	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap)))
@@ -783,6 +783,9 @@ unsigned long __init set_phys_range_identity(unsigned long pfn_s,
 	if (pfn_s > pfn_e)
 		return 0;
 
+	if (pfn_e > MAX_P2M_PFN)
+		pfn_e = MAX_P2M_PFN;
+
 	for (pfn = (pfn_s & ~(P2M_MID_PER_PAGE * P2M_PER_PAGE - 1));
 		pfn < ALIGN(pfn_e, (P2M_MID_PER_PAGE * P2M_PER_PAGE));
 		pfn += P2M_MID_PER_PAGE * P2M_PER_PAGE)
-- 
1.7.2.5

