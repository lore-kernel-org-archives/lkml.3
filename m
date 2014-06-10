Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934885AbaFJAXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:23:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934675AbaFJAWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3.4 79/88] xen/p2m: Allow alloc_p2m_middle to call reserve_brk depending on argument
Date: Mon,  9 Jun 2014 17:25:29 -0700
Message-Id: <20140610002427.100584945@linuxfoundation.org>
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

commit cef4cca551d652b7f69c9d76337c5fae24e069dc upstream.

For identity cases we want to call reserve_brk only on the boundary
conditions of the middle P2M (so P2M[x][y][0] = extend_brk). This is
to work around identify regions (PCI spaces, gaps in E820) which are not
aligned on 2MB regions.

However for the case were we want to allocate P2M middle leafs at the
early bootup stage, irregardless of this alignment check we need some
means of doing that.  For that we provide the new argument.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/p2m.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -499,7 +499,7 @@ static bool alloc_p2m(unsigned long pfn)
 	return true;
 }
 
-static bool __init early_alloc_p2m_middle(unsigned long pfn)
+static bool __init early_alloc_p2m_middle(unsigned long pfn, bool check_boundary)
 {
 	unsigned topidx, mididx, idx;
 
@@ -508,7 +508,7 @@ static bool __init early_alloc_p2m_middl
 	idx = p2m_index(pfn);
 
 	/* Pfff.. No boundary cross-over, lets get out. */
-	if (!idx)
+	if (!idx && check_boundary)
 		return false;
 
 	WARN(p2m_top[topidx][mididx] == p2m_identity,
@@ -531,7 +531,7 @@ static bool __init early_alloc_p2m_middl
 		p2m_top[topidx][mididx] = p2m;
 
 		/* For save/restore we need to MFN of the P2M saved */
-		
+
 		mid_mfn_p = p2m_top_mfn_p[topidx];
 		WARN(mid_mfn_p[mididx] != virt_to_mfn(p2m_missing),
 			"P2M_TOP_P[%d][%d] != MFN of p2m_missing!\n",
@@ -592,8 +592,8 @@ unsigned long __init set_phys_range_iden
 		WARN_ON(!early_alloc_p2m(pfn));
 	}
 
-	early_alloc_p2m_middle(pfn_s);
-	early_alloc_p2m_middle(pfn_e);
+	early_alloc_p2m_middle(pfn_s, true);
+	early_alloc_p2m_middle(pfn_e, true);
 
 	for (pfn = pfn_s; pfn < pfn_e; pfn++)
 		if (!__set_phys_to_machine(pfn, IDENTITY_FRAME(pfn)))


