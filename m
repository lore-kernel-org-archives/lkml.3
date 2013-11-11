Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3KKMwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:52:01 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:21018 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3KKMvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:51:54 -0500
X-IronPort-AV: E=Sophos;i="4.93,677,1378857600"; 
   d="scan'208";a="70552980"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>, <stefano.stabellini@eu.citrix.com>
Subject: [PATCH] xen/arm: pfn_to_mfn and mfn_to_pfn return the argument if nothing is in the p2m
Date: Mon, 11 Nov 2013 12:50:30 +0000
Message-ID: <1384174231-27176-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some common Xen drivers, like balloon.c, call pfn_to_mfn and mfn_to_pfn
even for autotranslate guests, expecting the argument back.
The following commit broke these drivers by changing the behavior of
pfn_to_mfn and mfn_to_pfn:

commit 4a19138c6505e224d9f4cc2fe9ada9188d7100ea
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Thu Oct 17 16:22:27 2013 +0000

    arm/xen,arm64/xen: introduce p2m

They now return INVALID_P2M_ENTRY if Linux doesn't actually know what is
the mfn backing a pfn or what is the pfn corresponding to an mfn.
Fix the regression by switching to the old behavior.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/xen/page.h |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index 5d0e4c5..f891925 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -46,10 +46,7 @@ static inline unsigned long pfn_to_mfn(unsigned long pfn)
 			return mfn;
 	}
 
-	if (xen_initial_domain())
-		return pfn;
-	else
-		return INVALID_P2M_ENTRY;
+	return pfn;
 }
 
 static inline unsigned long mfn_to_pfn(unsigned long mfn)
@@ -62,10 +59,7 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 			return pfn;
 	}
 
-	if (xen_initial_domain())
-		return mfn;
-	else
-		return INVALID_P2M_ENTRY;
+	return mfn;
 }
 
 #define mfn_to_local_pfn(mfn) mfn_to_pfn(mfn)
-- 
1.7.2.5

