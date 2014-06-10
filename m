Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936038AbaFJAfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:35:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934414AbaFJAWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3.4 80/88] xen/p2m: Collapse early_alloc_p2m_middle redundant checks.
Date: Mon,  9 Jun 2014 17:25:30 -0700
Message-Id: <20140610002427.130321664@linuxfoundation.org>
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

commit d5096850b47424fb0f1c6a75b8f7184f7169319a upstream.

At the start of the function we were checking for idx != 0
and bailing out. And later calling extend_brk if idx != 0.

That is unnecessary so remove that checks.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/p2m.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -502,6 +502,8 @@ static bool alloc_p2m(unsigned long pfn)
 static bool __init early_alloc_p2m_middle(unsigned long pfn, bool check_boundary)
 {
 	unsigned topidx, mididx, idx;
+	unsigned long *p2m;
+	unsigned long *mid_mfn_p;
 
 	topidx = p2m_top_index(pfn);
 	mididx = p2m_mid_index(pfn);
@@ -522,24 +524,21 @@ static bool __init early_alloc_p2m_middl
 		return false;
 
 	/* Boundary cross-over for the edges: */
-	if (idx) {
-		unsigned long *p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
-		unsigned long *mid_mfn_p;
+	p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
 
-		p2m_init(p2m);
+	p2m_init(p2m);
 
-		p2m_top[topidx][mididx] = p2m;
+	p2m_top[topidx][mididx] = p2m;
 
-		/* For save/restore we need to MFN of the P2M saved */
+	/* For save/restore we need to MFN of the P2M saved */
 
-		mid_mfn_p = p2m_top_mfn_p[topidx];
-		WARN(mid_mfn_p[mididx] != virt_to_mfn(p2m_missing),
-			"P2M_TOP_P[%d][%d] != MFN of p2m_missing!\n",
-			topidx, mididx);
-		mid_mfn_p[mididx] = virt_to_mfn(p2m);
+	mid_mfn_p = p2m_top_mfn_p[topidx];
+	WARN(mid_mfn_p[mididx] != virt_to_mfn(p2m_missing),
+		"P2M_TOP_P[%d][%d] != MFN of p2m_missing!\n",
+		topidx, mididx);
+	mid_mfn_p[mididx] = virt_to_mfn(p2m);
 
-	}
-	return idx != 0;
+	return true;
 }
 
 static bool __init early_alloc_p2m(unsigned long pfn)


