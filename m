Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaDOOQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:16:52 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58095 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaDOOQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:16:09 -0400
X-IronPort-AV: E=Sophos;i="4.97,864,1389744000"; 
   d="scan'208";a="121257949"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xenproject.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 5/9] x86/xen: set regions above the end of RAM as 1:1
Date: Tue, 15 Apr 2014 15:15:33 +0100
Message-ID: <1397571337-20409-6-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
References: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI devices may have BARs located above the end of RAM so mark such
frames as identity frames in the p2m (instead of the default of
missing).

PFNs outside the p2m (above MAX_P2M_PFN) are also considered to be
identity frames for the same reason.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/p2m.c   |    2 +-
 arch/x86/xen/setup.c |    9 +++++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 5d716f7..416c356 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -507,7 +507,7 @@ unsigned long get_phys_to_machine(unsigned long pfn)
 	unsigned topidx, mididx, idx;
 
 	if (unlikely(pfn >= MAX_P2M_PFN))
-		return INVALID_P2M_ENTRY;
+		return IDENTITY_FRAME(pfn);
 
 	topidx = p2m_top_index(pfn);
 	mididx = p2m_mid_index(pfn);
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 2afe55e..210426a 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -469,6 +469,15 @@ char * __init xen_memory_setup(void)
 	}
 
 	/*
+	 * Set the rest as identity mapped, in case PCI BARs are
+	 * located here.
+	 *
+	 * PFNs above MAX_P2M_PFN are considered identity mapped as
+	 * well.
+	 */
+	set_phys_range_identity(map[i-1].addr / PAGE_SIZE, ~0ul);
+
+	/*
 	 * In domU, the ISA region is normal, usable memory, but we
 	 * reserve ISA memory anyway because too many things poke
 	 * about in there.
-- 
1.7.2.5

