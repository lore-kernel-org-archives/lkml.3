Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3BSEOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:14:22 -0500
Received: from mout.gmx.net ([212.227.15.19]:65366 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab3BSEOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:14:20 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+VRh0tQX6VzgRDEtQGzTySKDklldFtTYDxSXpOol
	MjqVXi2VdxetgB
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>, Peter Huewe <peterhuewe@gmx.de>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Cruz Julian Bishop <cruzjbishop@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] staging/slicoss: Fix operation may be undefined warning
Date: Tue, 19 Feb 2013 05:18:50 +0100
Message-Id: <1361247532-1874-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1361247234-1754-1-git-send-email-peterhuewe@gmx.de>
References: <1361247234-1754-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc complains about an undefined operation:
slicoss.c:1417:19: warning: operation on 'rspq->pageindex' may be
undefined [-Wsequence-point]

The intended operation was (probably) to retrieve the pageindex + 1 and let
it wrap around if it reaches the num_pages.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/slicoss/slicoss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 048a341..fc08585 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1414,7 +1414,7 @@ static struct slic_rspbuf *slic_rspqueue_getnext(struct adapter *adapter)
 		slic_reg64_write(adapter, &adapter->slic_regs->slic_rbar64,
 			(rspq->paddr[rspq->pageindex] | SLIC_RSPQ_BUFSINPAGE),
 			&adapter->slic_regs->slic_addr_upper, 0, DONT_FLUSH);
-		rspq->pageindex = (++rspq->pageindex) % rspq->num_pages;
+		rspq->pageindex = (rspq->pageindex + 1) % rspq->num_pages;
 		rspq->offset = 0;
 		rspq->rspbuf = (struct slic_rspbuf *)
 						rspq->vaddr[rspq->pageindex];
-- 
1.7.8.6

