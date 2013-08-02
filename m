Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3HBMK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 08:10:56 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:55925 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3HBMKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 08:10:01 -0400
From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH v2 1/2] drivers/crypto/nx: fix physical addresses added to sg lists
Date: Fri,  2 Aug 2013 09:09:51 -0300
Message-Id: <1375445392-16237-2-git-send-email-mhcerri@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1375445392-16237-1-git-send-email-mhcerri@linux.vnet.ibm.com>
References: <1375445392-16237-1-git-send-email-mhcerri@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080212-2362-0000-0000-00000B5EFC0B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The co-processor receives data to be hashed through scatter/gather lists
pointing to physical addresses. When a vmalloc'ed data is given, the
driver must calculate the physical address to each page of the data.

However the current version of it just calculates the physical address
once and keeps incrementing it even when a page boundary is crossed.
This patch fixes this behaviour.

Reviewed-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
Reviewed-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index bbdab6e..ad07dc6 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -114,13 +114,29 @@ struct nx_sg *nx_build_sg_list(struct nx_sg *sg_head,
 	 * have been described (or @sgmax elements have been written), the
 	 * loop ends. min_t is used to ensure @end_addr falls on the same page
 	 * as sg_addr, if not, we need to create another nx_sg element for the
-	 * data on the next page */
+	 * data on the next page.
+	 *
+	 * Also when using vmalloc'ed data, every time that a system page
+	 * boundary is crossed the physical address needs to be re-calculated.
+	 */
 	for (sg = sg_head; sg_len < len; sg++) {
+		u64 next_page;
+
 		sg->addr = sg_addr;
-		sg_addr = min_t(u64, NX_PAGE_NUM(sg_addr + NX_PAGE_SIZE), end_addr);
-		sg->len = sg_addr - sg->addr;
+		sg_addr = min_t(u64, NX_PAGE_NUM(sg_addr + NX_PAGE_SIZE),
+				end_addr);
+
+		next_page = (sg->addr & PAGE_MASK) + PAGE_SIZE;
+		sg->len = min_t(u64, sg_addr, next_page) - sg->addr;
 		sg_len += sg->len;
 
+		if (sg_addr >= next_page &&
+				is_vmalloc_addr(start_addr + sg_len)) {
+			sg_addr = page_to_phys(vmalloc_to_page(
+						start_addr + sg_len));
+			end_addr = sg_addr + len - sg_len;
+		}
+
 		if ((sg - sg_head) == sgmax) {
 			pr_err("nx: scatter/gather list overflow, pid: %d\n",
 			       current->pid);
-- 
1.7.12

