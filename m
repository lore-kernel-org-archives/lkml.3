Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028Ab3DPRHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:07:20 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:28323 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964856Ab3DPRHS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:07:18 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzc89bhzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] clk: Always notify whole subtree when reparenting
Date: Tue, 16 Apr 2013 10:06:50 -0700
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-RCIS-Action: ALLOW
Message-ID: <afe397e3-c674-4dc3-9f3e-feea9275bb91@TX2EHSMHS023.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A clock's notifier count only reflects notifiers which are registered
directly for that clock. A reparent operation though affects the whole
subtree because of a potential rate change.
When issuing the pre rate change notifications only the notifier count
for the clock to be changed is considered and notifiers for subclocks
may never be called. Resulting in clocks in the subtree which have
registered notifiers, may receive a POST_- or ABORT_RATE_CHANGE
notification, without a PRE_RATE_CHANGE_NOTIFICATION.
Therefore always traverse the whole subtree when issueing pre rate
change notifications during a reparent operation.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
This should probably be considered an RFC. There may be smarter ways to
resolve this issue. E.g. forward notifier counts upstream the way it is done
with enable counts.

	Sören


 drivers/clk/clk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 20ce67f..1179cb5 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1481,8 +1481,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	}
 
 	/* propagate PRE_RATE_CHANGE notifications */
-	if (clk->notifier_count)
-		ret = __clk_speculate_rates(clk, p_rate);
+	ret = __clk_speculate_rates(clk, p_rate);
 
 	/* abort if a driver objects */
 	if (ret & NOTIFY_STOP_MASK)
-- 
1.8.2.1


