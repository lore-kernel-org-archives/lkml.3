Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbaAAEku (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 23:40:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19635 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaAAEhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 23:37:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v12 01/18] xen/p2m: Check for auto-xlat when doing mfn_to_local_pfn.
Date: Tue, 31 Dec 2013 23:35:28 -0500
Message-Id: <1388550945-25499-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
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

