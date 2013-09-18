Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab3IRKWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:22:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16351 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3IRKWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:22:07 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-24-52397ece0960
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 4/6] USB: gadget: s3c-hsotg: add DAINT masking
Date: Wed, 18 Sep 2013 12:21:33 +0200
Message-id: <1379499695-5279-5-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379499695-5279-1-git-send-email-r.baldyga@samsung.com>
References: <1379499695-5279-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jAd1zdZZBBnfPaFpsnLGe1eLg/XqL
	5sXr2SzONr1ht7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGY9nbGMt+MdRce38aZYGxo3sXYycHBICJhLtkyezQNhiEhfurWfr
	YuTiEBJYxCgxq3khI4TTziRxb98BVpAqNgEdiS3fJzCC2CICAhLrX1xiByliFnjCKDH1yCuw
	scICjhKvFs4DG8sioCqxc/FXpi5GDg5eAReJGWvZQUwJAQWJOZNsQCo4BVwldv25AzZeCKhi
	Zv881gmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBIfUM6kdjCsbLA4xCnAwKvHw
	Xii3CBJiTSwrrsw9xCjBwawkwutSZhkkxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6
	YklqdmpqQWoRTJaJg1OqgXH3FbcHb1qKkmtSFnpIzBRPPBZr0z775MWDzkszrbnPFAiyBzJr
	u/2uKnh09ssNJdMthqrtGdvXX2dnl4+7YtsrcF5m8i6O3fanOj79Xrp0R5+G8tIT204cVVxm
	5lr4spNt6+drrz5vtvm8dNZpLpeA49ZaKs61m1wDVnOofvy2ynlm5yvRJbJKLMUZiYZazEXF
	iQDyu188JQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In OEPInt/IEPInt interrupts handling added bitwise and of DAINT and
DAINTMSK, because we should handle masked interrupts only.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 3024685d..e32f868 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2398,10 +2398,14 @@ irq_retry:
 
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

