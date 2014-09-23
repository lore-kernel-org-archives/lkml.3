Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbaIWTlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:41:25 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:46990 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaIWTlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:41:24 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, tklauser@distanz.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/4] staging: et131x: zero allocation of fbr to prevent random address access
Date: Tue, 23 Sep 2014 20:41:11 +0100
Message-Id: <1411501274-2970-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140923100106.GE4657@distanz.ch>
References: <20140923100106.GE4657@distanz.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If et131x_rx_dma_memory_alloc() allocates rx_ring->fbr[0] but fails to
allocate rx_ring->fbr[1], this leaves fbr[0]->ring_virtaddr with the
possibility of being accessed in et131x_rx_dma_memory_free() as it
contains a random value, potentially causing an oops.

Fix this by zeroing the fbr memory on allocation. Subsequent frees of
this fbr memory explicitly zeros the ring_virtaddr value.

Reported-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 93afd61..2889f86 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -2003,10 +2003,10 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	struct fbr_lookup *fbr;
 
 	/* Alloc memory for the lookup table */
-	rx_ring->fbr[0] = kmalloc(sizeof(*fbr), GFP_KERNEL);
+	rx_ring->fbr[0] = kzalloc(sizeof(*fbr), GFP_KERNEL);
 	if (rx_ring->fbr[0] == NULL)
 		return -ENOMEM;
-	rx_ring->fbr[1] = kmalloc(sizeof(*fbr), GFP_KERNEL);
+	rx_ring->fbr[1] = kzalloc(sizeof(*fbr), GFP_KERNEL);
 	if (rx_ring->fbr[1] == NULL)
 		return -ENOMEM;
 
-- 
2.1.0

