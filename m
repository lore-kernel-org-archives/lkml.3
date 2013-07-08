Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3GHHW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:22:57 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:43252 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3GHHW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:22:56 -0400
Subject: [PATCH] drivers/net: enic: release rtnl_lock on error-path
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Neel Patel <neepatel@cisco.com>, Nishank Trivedi <nistrive@cisco.com>,
        Roopa Prabhu <roprabhu@cisco.com>,
        Christian Benvenuti <benve@cisco.com>
Date: Mon, 08 Jul 2013 11:22:51 +0400
Message-ID: <20130708072251.20540.50413.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enic_change_mtu_work() must call rtnl_unlock() on all exiting paths.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Christian Benvenuti <benve@cisco.com>
Cc: Roopa Prabhu <roprabhu@cisco.com>
Cc: Neel Patel <neepatel@cisco.com>
Cc: Nishank Trivedi <nistrive@cisco.com>
---
 drivers/net/ethernet/cisco/enic/enic_main.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 635f559..992ec2e 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -1761,6 +1761,7 @@ static void enic_change_mtu_work(struct work_struct *work)
 	enic_synchronize_irqs(enic);
 	err = vnic_rq_disable(&enic->rq[0]);
 	if (err) {
+		rtnl_unlock();
 		netdev_err(netdev, "Unable to disable RQ.\n");
 		return;
 	}
@@ -1773,6 +1774,7 @@ static void enic_change_mtu_work(struct work_struct *work)
 	vnic_rq_fill(&enic->rq[0], enic_rq_alloc_buf);
 	/* Need at least one buffer on ring to get going */
 	if (vnic_rq_desc_used(&enic->rq[0]) == 0) {
+		rtnl_unlock();
 		netdev_err(netdev, "Unable to alloc receive buffers.\n");
 		return;
 	}

