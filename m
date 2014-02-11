Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaBKIjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:39:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33694 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaBKIjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:39:17 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-fc-52f9e1b33d34
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andy Whitcroft <apw@canonical.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] x86: dma-mapping: fix GFP_ATOMIC macro usage
Date: Tue, 11 Feb 2014 09:38:59 +0100
Message-id: <1392107939-29850-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgluLIzCtJLcpLzFFi42I5/e+xgO7mhz+DDB52WFh8WKthMW2juMXl
	XXPYLNYeuctucenAAiaLBRsfMVps3jSV2eLHhsesDhwesxp62Tw2repk83h37hy7x/t9V9k8
	+rasYvT4vEnO40TLF9YA9igum5TUnMyy1CJ9uwSujN0XGpgKXnJWvOzqZmxg/MPexcjJISFg
	InF79jJWCFtM4sK99WxdjFwcQgKLGCV+XzvGAuG0MknMO/scrIpNwFCi620XG4gtImAgsfTM
	JCaQImaBm4wSP/f1AxVxcAgLOEj8uGMBUsMioCrx9ukNRhCbV8BD4taVTSwgJRICChJzJtlM
	YORewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4fJ5J72Bc1WBxiFGAg1GJh/fCpx9B
	QqyJZcWVuYcYJTiYlUR4lY7/DBLiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7
	NbUgtQgmy8TBKdXA2La684JtzqqtQcL1j+MfXhVjuatmv5LBTk6zNbv7ksSrqzoTrkn35rlp
	XlEzWHV5s9rPp7f+tvZ7Rv3e65ibqLFj79Ln2jdyGwuedR3Xzdc1i2d/P7O9RHxX/5YVNmc3
	R95dffuhWtoOb8eL6huXT6264/NjK59i1AkW43mdylzXTz/5ZMpgrMRSnJFoqMVcVJwIALjB
	7lcbAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
flags, where meaningful is the LACK of __GFP_WAIT flag. To check if caller
wants to perform an atomic allocation, the code must test for a lack of the
__GFP_WAIT flag. This patch fixes the issue introduced in v3.5-rc1.

CC: stable@vger.kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
Changelog:

v3:
- fixed spelling issues

v2:
- added more comments in the code to explain for _GFP_WAIT test

v1:
- initial version

---
 arch/x86/kernel/pci-dma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 872079a..3519a78 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -100,8 +100,10 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 	flag |= __GFP_ZERO;
 again:
 	page = NULL;
-	if (!(flag & GFP_ATOMIC))
+	/* CMA can be used only in the context which permits sleeping */
+	if (flag & __GFP_WAIT)
 		page = dma_alloc_from_contiguous(dev, count, get_order(size));
+	/* fallback */
 	if (!page)
 		page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
 	if (!page)
-- 
1.7.9.5

