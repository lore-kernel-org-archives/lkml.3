Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3LQUv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:51:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20049 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3LQUv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:51:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        mukesh.rathor@oracle.com, jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v11 01/12] xen/p2m: Check for auto-xlat when doing mfn_to_local_pfn.
Date: Tue, 17 Dec 2013 15:51:32 -0500
Message-Id: <1387313503-31362-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

Most of the functions in page.h are prefaced with
	if (xen_feature(XENFEAT_auto_translated_physmap))
		return mfn;

Except the mfn_to_local_pfn. At a first sight, the function
should work without this patch - as the 'mfn_to_mfn' has
a similar check. But there are no such check in the
'get_phys_to_machine' function - so we would crash in there.

This fixes it by following the convention of having the
check for auto-xlat in these static functions.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/page.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index b913915..4a092cc 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -167,7 +167,12 @@ static inline xpaddr_t machine_to_phys(xmaddr_t machine)
  */
 static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
 {
-	unsigned long pfn = mfn_to_pfn(mfn);
+	unsigned long pfn;
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return mfn;
+
+	pfn = mfn_to_pfn(mfn);
 	if (get_phys_to_machine(pfn) != mfn)
 		return -1; /* force !pfn_valid() */
 	return pfn;
-- 
1.8.3.1

