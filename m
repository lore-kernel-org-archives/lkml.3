Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaGFSXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:23:00 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35332 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaGFSW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:22:59 -0400
Date: Sun, 6 Jul 2014 23:52:53 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH v2] thunderbolt: Use kcalloc and correct the argument to
 sizeof
Message-ID: <20140706182253.GA20419@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nhi->rx_rings does not have type as struct tb_ring *, as it is a double
pointer. So, the elements of the array should have pointer type, not
structure type. The advantage of kcalloc is, that will prevent integer
overflows which could result from the multiplication of number of
elements and size and it is also a bit nicer to read.

The Coccinelle semantic patch that makes the first change is as follows:

// <smpl>
@disable sizeof_type_expr@
type T;
T **x;
@@

  x =
  <+...sizeof(
- T
+ *x
  )...+>
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
v2: Use devm_kcalloc
 drivers/thunderbolt/nhi.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 2054fbf..c68fe12 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -569,12 +569,10 @@ static int nhi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			 nhi->hop_count);
 	INIT_WORK(&nhi->interrupt_work, nhi_interrupt_work);
 
-	nhi->tx_rings = devm_kzalloc(&pdev->dev,
-				     nhi->hop_count * sizeof(struct tb_ring),
-				     GFP_KERNEL);
-	nhi->rx_rings = devm_kzalloc(&pdev->dev,
-				     nhi->hop_count * sizeof(struct tb_ring),
-				     GFP_KERNEL);
+	nhi->tx_rings = devm_kcalloc(&pdev->dev, nhi->hop_count,
+				     sizeof(*nhi->tx_rings), GFP_KERNEL);
+	nhi->rx_rings = devm_kcalloc(&pdev->dev, nhi->hop_count,
+				     sizeof(*nhi->rx_rings), GFP_KERNEL);
 	if (!nhi->tx_rings || !nhi->rx_rings)
 		return -ENOMEM;
 
-- 
1.9.1
	
