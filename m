Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaLEGRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:17:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbaLEGRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:17:00 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH] xen: fix sparse warning in page.h
Date: Fri,  5 Dec 2014 07:16:57 +0100
Message-Id: <1417760217-16977-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inline function mfn_to_pfn_no_overrides() uses __get_user() to
access the machine_to_phys_mapping array to avoid crashes when
using out of bounds indices e.g. for I/O addresses.

Avoid sparse warnings by attributing the accessed address with __user.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/xen/page.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index f5d5de4..6deff84 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -113,6 +113,7 @@ static inline unsigned long mfn_to_pfn_no_overrides(unsigned long mfn)
 {
 	unsigned long pfn;
 	int ret;
+	unsigned long __user *addr;
 
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return mfn;
@@ -125,7 +126,8 @@ static inline unsigned long mfn_to_pfn_no_overrides(unsigned long mfn)
 	 * In such cases it doesn't matter what we return (we return garbage),
 	 * but we must handle the fault without crashing!
 	 */
-	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
+	addr = (unsigned long __user *)(&machine_to_phys_mapping[mfn]);
+	ret = __get_user(pfn, addr);
 	if (ret < 0)
 		return ~0;
 
-- 
2.1.2

