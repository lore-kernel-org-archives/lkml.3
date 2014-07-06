Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaGFQNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 12:13:50 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37027 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaGFQNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 12:13:49 -0400
Date: Sun, 6 Jul 2014 21:43:42 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] thunderbolt: Correct the size argument to devm_kzalloc
Message-ID: <20140706161342.GA6267@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nhi->rx_rings does not have type as struct tb_ring *, as it is a
double pointer so the elements of the array should have pointer type,
not structure type.

The Coccinelle semantic patch that makes this change is as follows:

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
 drivers/thunderbolt/nhi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 2054fbf..ce72f31 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -570,10 +570,10 @@ static int nhi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_WORK(&nhi->interrupt_work, nhi_interrupt_work);
 
 	nhi->tx_rings = devm_kzalloc(&pdev->dev,
-				     nhi->hop_count * sizeof(struct tb_ring),
+				     nhi->hop_count * sizeof(*nhi->tx_rings),
 				     GFP_KERNEL);
 	nhi->rx_rings = devm_kzalloc(&pdev->dev,
-				     nhi->hop_count * sizeof(struct tb_ring),
+				     nhi->hop_count * sizeof(*nhi->rx_rings),
 				     GFP_KERNEL);
 	if (!nhi->tx_rings || !nhi->rx_rings)
 		return -ENOMEM;
-- 
1.9.1

