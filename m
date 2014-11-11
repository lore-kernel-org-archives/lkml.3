Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaKKFoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:44:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbaKKFoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:44:00 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V3 6/8] xen: Hide get_phys_to_machine() to be able to tune common path
Date: Tue, 11 Nov 2014 06:43:44 +0100
Message-Id: <1415684626-18590-7-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1415684626-18590-1-git-send-email-jgross@suse.com>
References: <1415684626-18590-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today get_phys_to_machine() is always called when the mfn for a pfn
is to be obtained. Add a wrapper __pfn_to_mfn() as inline function
to be able to avoid calling get_phys_to_machine() when possible as
soon as the switch to a linear mapped p2m list has been done.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/xen/page.h | 27 +++++++++++++++++++++------
 arch/x86/xen/mmu.c              |  2 +-
 arch/x86/xen/p2m.c              |  6 +++---
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 28fa795..07d8a7b 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -59,6 +59,22 @@ extern int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
 				     struct page **pages, unsigned int count);
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
 
+/*
+ * When to use pfn_to_mfn(), __pfn_to_mfn() or get_phys_to_machine():
+ * - pfn_to_mfn() returns either INVALID_P2M_ENTRY or the mfn. In case of an
+ *   identity entry the identity indicator will be cleared.
+ * - __pfn_to_mfn() returns the found entry of the p2m table. A possibly set
+ *   identity indicator will be still set. __pfn_to_mfn() is encapsulating
+ *   get_phys_to_machine() and might skip that function if possible to speed
+ *   up the common path.
+ * - get_phys_to_machine() is basically the same as __pfn_to_mfn(), but
+ *   without any short cuts for the common fast path.
+ */
+static inline unsigned long __pfn_to_mfn(unsigned long pfn)
+{
+	return get_phys_to_machine(pfn);
+}
+
 static inline unsigned long pfn_to_mfn(unsigned long pfn)
 {
 	unsigned long mfn;
@@ -66,7 +82,7 @@ static inline unsigned long pfn_to_mfn(unsigned long pfn)
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return pfn;
 
-	mfn = get_phys_to_machine(pfn);
+	mfn = __pfn_to_mfn(pfn);
 
 	if (mfn != INVALID_P2M_ENTRY)
 		mfn &= ~(FOREIGN_FRAME_BIT | IDENTITY_FRAME_BIT);
@@ -79,7 +95,7 @@ static inline int phys_to_machine_mapping_valid(unsigned long pfn)
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return 1;
 
-	return get_phys_to_machine(pfn) != INVALID_P2M_ENTRY;
+	return __pfn_to_mfn(pfn) != INVALID_P2M_ENTRY;
 }
 
 static inline unsigned long mfn_to_pfn_no_overrides(unsigned long mfn)
@@ -113,7 +129,7 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 		return mfn;
 
 	pfn = mfn_to_pfn_no_overrides(mfn);
-	if (get_phys_to_machine(pfn) != mfn) {
+	if (__pfn_to_mfn(pfn) != mfn) {
 		/*
 		 * If this appears to be a foreign mfn (because the pfn
 		 * doesn't map back to the mfn), then check the local override
@@ -129,8 +145,7 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 	 * entry doesn't map back to the mfn and m2p_override doesn't have a
 	 * valid entry for it.
 	 */
-	if (pfn == ~0 &&
-			get_phys_to_machine(mfn) == IDENTITY_FRAME(mfn))
+	if (pfn == ~0 && __pfn_to_mfn(mfn) == IDENTITY_FRAME(mfn))
 		pfn = mfn;
 
 	return pfn;
@@ -176,7 +191,7 @@ static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
 		return mfn;
 
 	pfn = mfn_to_pfn(mfn);
-	if (get_phys_to_machine(pfn) != mfn)
+	if (__pfn_to_mfn(pfn) != mfn)
 		return -1; /* force !pfn_valid() */
 	return pfn;
 }
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index d3e492b..31ca515 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -387,7 +387,7 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
 		unsigned long mfn;
 
 		if (!xen_feature(XENFEAT_auto_translated_physmap))
-			mfn = get_phys_to_machine(pfn);
+			mfn = __pfn_to_mfn(pfn);
 		else
 			mfn = pfn;
 		/*
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 6a9dfa6..328875a 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -785,7 +785,7 @@ static int m2p_add_override(unsigned long mfn, struct page *page,
 	 * because mfn_to_pfn (that ends up being called by GUPF) will
 	 * return the backend pfn rather than the frontend pfn. */
 	pfn = mfn_to_pfn_no_overrides(mfn);
-	if (get_phys_to_machine(pfn) == mfn)
+	if (__pfn_to_mfn(pfn) == mfn)
 		set_phys_to_machine(pfn, FOREIGN_FRAME(mfn));
 
 	return 0;
@@ -965,7 +965,7 @@ static int m2p_remove_override(struct page *page,
 	 * pfn again. */
 	mfn &= ~FOREIGN_FRAME_BIT;
 	pfn = mfn_to_pfn_no_overrides(mfn);
-	if (get_phys_to_machine(pfn) == FOREIGN_FRAME(mfn) &&
+	if (__pfn_to_mfn(pfn) == FOREIGN_FRAME(mfn) &&
 			m2p_find_override(mfn) == NULL)
 		set_phys_to_machine(pfn, mfn);
 
@@ -990,7 +990,7 @@ int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
 	}
 
 	for (i = 0; i < count; i++) {
-		unsigned long mfn = get_phys_to_machine(page_to_pfn(pages[i]));
+		unsigned long mfn = __pfn_to_mfn(page_to_pfn(pages[i]));
 		unsigned long pfn = page_to_pfn(pages[i]);
 
 		if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT)) {
-- 
2.1.2

