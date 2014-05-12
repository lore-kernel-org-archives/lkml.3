Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbaELB60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:58:26 -0400
Received: from 1wt.eu ([62.212.114.60]:34660 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbaELBm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:58 -0400
Message-Id: <20140512003200.886376213@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jitendra Bhivare <jitendra.bhivare@gmail.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 006/143] intel-iommu: Flush unmaps at domain_exit
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jitendra Bhivare <jitendra.bhivare@gmail.com>

Backported Alex Williamson's commit to 2.6.32.y
http://git.kernel.org/linus/7b668357810ecb5fdda4418689d50f5d95aea6a8

It resolves the following assert when module is immediately reloaded.

kernel BUG at drivers/pci/iova.c:155!
<snip>
Call Trace:
[<ffffffff812645c5>] intel_alloc_iova+0xb5/0xe0
[<ffffffff8126725e>] __intel_map_single+0xbe/0x210
[<ffffffff812674ae>] intel_alloc_coherent+0xae/0x120
[<ffffffffa035f909>] be_queue_alloc+0xb9/0x140 [be2net]
[<ffffffffa035fa5a>] be_rx_qs_create+0xca/0x370 [be2net]
<snip>

The issue is reproducible in 2.6.32.60 and also gets resolved
by passing intel-iommu=strict to kernel.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@gmail.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/pci/intel-iommu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 5b680df..c1a7b01 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1434,6 +1434,10 @@ static void domain_exit(struct dmar_domain *domain)
 	if (!domain)
 		return;
 
+	/* Flush any lazy unmaps that may reference this domain */
+	if (!intel_iommu_strict)
+		flush_unmaps_timeout(0);
+
 	domain_remove_dev_info(domain);
 	/* destroy iovas */
 	put_iova_domain(&domain->iovad);
-- 
1.7.12.2.21.g234cd45.dirty



