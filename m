Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaGHWbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:31:34 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:60725 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaGHWbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:31:32 -0400
Date: Wed, 9 Jul 2014 04:01:26 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Andreas Noever <andreas.noever@gmail.com>, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH v3] thunderbolt: Use kcalloc and correct the argument to
 sizeof
Message-ID: <20140708223126.GA12035@himangi-Dell>
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
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
v2: Use kcalloc
v3: Add maintainer in To
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
	
