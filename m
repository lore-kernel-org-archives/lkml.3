Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaDOOQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:16:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58075 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaDOOQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:16:07 -0400
X-IronPort-AV: E=Sophos;i="4.97,864,1389744000"; 
   d="scan'208";a="121257950"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xenproject.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 4/9] x86/xen: only warn once if bad MFNs are found during setup
Date: Tue, 15 Apr 2014 15:15:32 +0100
Message-ID: <1397571337-20409-5-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
References: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In xen_add_extra_mem(), if the WARN() checks for bad MFNs trigger it is
likely that they will trigger at lot, spamming the log.

Use WARN_ONCE() instead.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/setup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 0982233..2afe55e 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -89,10 +89,10 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
 	for (pfn = PFN_DOWN(start); pfn < xen_max_p2m_pfn; pfn++) {
 		unsigned long mfn = pfn_to_mfn(pfn);
 
-		if (WARN(mfn == pfn, "Trying to over-write 1-1 mapping (pfn: %lx)\n", pfn))
+		if (WARN_ONCE(mfn == pfn, "Trying to over-write 1-1 mapping (pfn: %lx)\n", pfn))
 			continue;
-		WARN(mfn != INVALID_P2M_ENTRY, "Trying to remove %lx which has %lx mfn!\n",
-			pfn, mfn);
+		WARN_ONCE(mfn != INVALID_P2M_ENTRY, "Trying to remove %lx which has %lx mfn!\n",
+			  pfn, mfn);
 
 		__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
 	}
-- 
1.7.2.5

