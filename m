Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935008AbaFJAYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:24:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934670AbaFJAWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3.4 78/88] xen/p2m: Move code around to allow for better re-usage.
Date: Mon,  9 Jun 2014 17:25:28 -0700
Message-Id: <20140610002427.061204528@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 3f3aaea29ff7ee2d43b430338427f30ba7f60ff9 upstream.

We are going to be using the early_alloc_p2m (and
early_alloc_p2m_middle) code in follow up patches which
are not related to setting identity pages.

Hence lets move the code out in its own function and
rename them as appropiate.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/p2m.c |   62 +++++++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 28 deletions(-)

--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -499,7 +499,7 @@ static bool alloc_p2m(unsigned long pfn)
 	return true;
 }
 
-static bool __init __early_alloc_p2m(unsigned long pfn)
+static bool __init early_alloc_p2m_middle(unsigned long pfn)
 {
 	unsigned topidx, mididx, idx;
 
@@ -541,6 +541,36 @@ static bool __init __early_alloc_p2m(uns
 	}
 	return idx != 0;
 }
+
+static bool __init early_alloc_p2m(unsigned long pfn)
+{
+	unsigned topidx = p2m_top_index(pfn);
+	unsigned long *mid_mfn_p;
+	unsigned long **mid;
+
+	mid = p2m_top[topidx];
+	mid_mfn_p = p2m_top_mfn_p[topidx];
+	if (mid == p2m_mid_missing) {
+		mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
+
+		p2m_mid_init(mid);
+
+		p2m_top[topidx] = mid;
+
+		BUG_ON(mid_mfn_p != p2m_mid_missing_mfn);
+	}
+	/* And the save/restore P2M tables.. */
+	if (mid_mfn_p == p2m_mid_missing_mfn) {
+		mid_mfn_p = extend_brk(PAGE_SIZE, PAGE_SIZE);
+		p2m_mid_mfn_init(mid_mfn_p);
+
+		p2m_top_mfn_p[topidx] = mid_mfn_p;
+		p2m_top_mfn[topidx] = virt_to_mfn(mid_mfn_p);
+		/* Note: we don't set mid_mfn_p[midix] here,
+		 * look in early_alloc_p2m_middle */
+	}
+	return true;
+}
 unsigned long __init set_phys_range_identity(unsigned long pfn_s,
 				      unsigned long pfn_e)
 {
@@ -559,35 +589,11 @@ unsigned long __init set_phys_range_iden
 		pfn < ALIGN(pfn_e, (P2M_MID_PER_PAGE * P2M_PER_PAGE));
 		pfn += P2M_MID_PER_PAGE * P2M_PER_PAGE)
 	{
-		unsigned topidx = p2m_top_index(pfn);
-		unsigned long *mid_mfn_p;
-		unsigned long **mid;
-
-		mid = p2m_top[topidx];
-		mid_mfn_p = p2m_top_mfn_p[topidx];
-		if (mid == p2m_mid_missing) {
-			mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
-
-			p2m_mid_init(mid);
-
-			p2m_top[topidx] = mid;
-
-			BUG_ON(mid_mfn_p != p2m_mid_missing_mfn);
-		}
-		/* And the save/restore P2M tables.. */
-		if (mid_mfn_p == p2m_mid_missing_mfn) {
-			mid_mfn_p = extend_brk(PAGE_SIZE, PAGE_SIZE);
-			p2m_mid_mfn_init(mid_mfn_p);
-
-			p2m_top_mfn_p[topidx] = mid_mfn_p;
-			p2m_top_mfn[topidx] = virt_to_mfn(mid_mfn_p);
-			/* Note: we don't set mid_mfn_p[midix] here,
-		 	 * look in __early_alloc_p2m */
-		}
+		WARN_ON(!early_alloc_p2m(pfn));
 	}
 
-	__early_alloc_p2m(pfn_s);
-	__early_alloc_p2m(pfn_e);
+	early_alloc_p2m_middle(pfn_s);
+	early_alloc_p2m_middle(pfn_e);
 
 	for (pfn = pfn_s; pfn < pfn_e; pfn++)
 		if (!__set_phys_to_machine(pfn, IDENTITY_FRAME(pfn)))


