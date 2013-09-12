Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3ILOTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:19:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12744 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3ILOTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:19:47 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-d8-5231cd810369
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 5/6] USB: gadget: s3c-hsotg: fix dedicated fifos handling
Date: Thu, 12 Sep 2013 16:18:51 +0200
Message-id: <1378995532-32142-6-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
References: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jQd2ms4ZBBus3MVtsnLGe1eLg/XqL
	5sXr2SzONr1ht7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGV+77zIVtCtX/Lh/kbmB8bl0FyMnh4SAicThSTcZIWwxiQv31rN1
	MXJxCAlMZ5Tov9HJBOF0MUl8Pb8IrIpNQEdiy/cJYLaIgIDE+heX2EGKmAWeMEpMPfKKHSQh
	LOApce3JJRYQm0VAVeLd7btgNq+Aq8T38/dYIdbJSzy938cGYnMKuEn07QZZzQG0zVVi4taU
	CYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEB9UzqR2MKxssDjEKcDAq8fB2zDII
	EmJNLCuuzD3EKMHBrCTC+3miYZAQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJJanZ
	qakFqUUwWSYOTqkGxvR/EX6XdAzZ99wXfGOhHlIyT56td025lYhXoYqPS1mOdI1anubjhNhW
	gRW3/xckbLL4opwt2v8lcFLYrHbVba/mp5zdL8UqdG52yjbdxztUkxsLJbmbe+YbmEuLzlhd
	M2fHG5YMpWWKThxx146lJ+R9PLdvf+0Kk8ttYZc3f27tClph4hekxFKckWioxVxUnAgAaGeL
	xSYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds few fixes:
- In s3c_hsotg_write_fifo function PTxFEmp/NPTxFEmp interrupts are enabled
  only in shared-fifo mode. In dedicated-fifo mode they should not be used
  (when enabled then cause interrupt storm).
- When s3c_hsotg_trytx is called for ep without enqueued request, interrupts
  for this ep are disabled, to prevent interrupt flooding. Interrupts are
  enabled when new request for this ep is starting.
- In s3c_hsotg_core_init enabled INTknTXFEmpMsk, becouse without this mask
  TxFIFOEmpty interrupt does not occur.
- In OEPInt/IEPInt interrupts handling added bitwise and of DAINT and
  DAINTMSK, because we should handle masked interrupts only.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |   48 ++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index c581cd7..4fb2199 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -553,9 +553,11 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 	if (to_write > hs_ep->ep.maxpacket) {
 		to_write = hs_ep->ep.maxpacket;
 
-		s3c_hsotg_en_gsint(hsotg,
-				   periodic ? GINTSTS_PTxFEmp :
-				   GINTSTS_NPTxFEmp);
+		/* it's needed only when we do not use dedicated fifos */
+		if (!hsotg->dedicated_fifos)
+			s3c_hsotg_en_gsint(hsotg,
+					   periodic ? GINTSTS_PTxFEmp :
+					   GINTSTS_NPTxFEmp);
 	}
 
 	/* see if we can write data */
@@ -580,9 +582,11 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 		 * is more room left.
 		 */
 
-		s3c_hsotg_en_gsint(hsotg,
-				   periodic ? GINTSTS_PTxFEmp :
-				   GINTSTS_NPTxFEmp);
+		/* it's needed only when we do not use dedicated fifos */
+		if (!hsotg->dedicated_fifos)
+			s3c_hsotg_en_gsint(hsotg,
+					   periodic ? GINTSTS_PTxFEmp :
+					   GINTSTS_NPTxFEmp);
 	}
 
 	dev_dbg(hsotg->dev, "write %d/%d, can_write %d, done %d\n",
@@ -819,6 +823,9 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
 
 	dev_dbg(hsotg->dev, "%s: DxEPCTL=0x%08x\n",
 		__func__, readl(hsotg->regs + epctrl_reg));
+
+	/* enable ep interrupts */
+	s3c_hsotg_ctrl_epint(hsotg, hs_ep->index, hs_ep->dir_in, 1);
 }
 
 /**
@@ -1784,8 +1791,15 @@ static int s3c_hsotg_trytx(struct s3c_hsotg *hsotg,
 {
 	struct s3c_hsotg_req *hs_req = hs_ep->req;
 
-	if (!hs_ep->dir_in || !hs_req)
+	if (!hs_ep->dir_in || !hs_req) {
+		/**
+		 * if request is not enqueued, we disable interrupts for endpoints,
+		 * excepting ep0
+		 */
+		if (hs_ep->index != 0)
+			s3c_hsotg_ctrl_epint(hsotg, hs_ep->index, hs_ep->dir_in, 0);
 		return 0;
+	}
 
 	if (hs_req->req.actual < hs_req->req.length) {
 		dev_dbg(hsotg->dev, "trying to write more for ep%d\n",
@@ -2243,15 +2257,17 @@ static void s3c_hsotg_core_init(struct s3c_hsotg *hsotg)
 		       GAHBCFG_HBstLen_Incr4,
 		       hsotg->regs + GAHBCFG);
 	else
-		writel(GAHBCFG_GlblIntrEn, hsotg->regs + GAHBCFG);
+		writel(GAHBCFG_GlblIntrEn | GAHBCFG_NPTxFEmpLvl,
+		       hsotg->regs + GAHBCFG);
 
 	/*
-	 * Enabling INTknTXFEmpMsk here seems to be a big mistake, we end
-	 * up being flooded with interrupts if the host is polling the
-	 * endpoint to try and read data.
+	 * If INTknTXFEmpMsk is enabled, it's important to disable ep interrupts
+	 * when we have no data to transfer. Otherwise we get being flooded by
+	 * interrupts.
 	 */
 
-	writel(((hsotg->dedicated_fifos) ? DIEPMSK_TxFIFOEmpty : 0) |
+	writel(((hsotg->dedicated_fifos) ? DIEPMSK_TxFIFOEmpty |
+	       DIEPMSK_INTknTXFEmpMsk : 0) |
 	       DIEPMSK_EPDisbldMsk | DIEPMSK_XferComplMsk |
 	       DIEPMSK_TimeOUTMsk | DIEPMSK_AHBErrMsk |
 	       DIEPMSK_INTknEPMisMsk,
@@ -2380,10 +2396,14 @@ irq_retry:
 
 	if (gintsts & (GINTSTS_OEPInt | GINTSTS_IEPInt)) {
 		u32 daint = readl(hsotg->regs + DAINT);
-		u32 daint_out = daint >> DAINT_OutEP_SHIFT;
-		u32 daint_in = daint & ~(daint_out << DAINT_OutEP_SHIFT);
+		u32 daintmsk = readl(hsotg->regs + DAINTMSK);
+		u32 daint_out, daint_in;
 		int ep;
 
+		daint &= daintmsk;
+		daint_out = daint >> DAINT_OutEP_SHIFT;
+		daint_in = daint & ~(daint_out << DAINT_OutEP_SHIFT);
+
 		dev_dbg(hsotg->dev, "%s: daint=%08x\n", __func__, daint);
 
 		for (ep = 0; ep < 15 && daint_out; ep++, daint_out >>= 1) {
-- 
1.7.9.5

