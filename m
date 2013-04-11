Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422666Ab3DKUny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:43:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10923 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab3DKUZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:25:55 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=quZHVNJjSYEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6A1tGIHCVbYA:10 a=Q-fNiiVtAAAA:8 a=pGLkceISAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=lcTMV_K9oDIA:10 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202547.745844222@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Marcin Miotk <marcinmiotk81@gmail.com>, Benjamin Li <benli@broadcom.com>,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 009/171 ] tg3: 5715 does not link up when autoneg off
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0009-tg3-5715-does-not-link-up-when-autoneg-off.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

[ Upstream commit 7c6cdead7cc9a99650d15497aae47d7472217eb1 ]

Commit d13ba512cbba7de5d55d7a3b2aae7d83c8921457 ("tg3: Remove
SPEED_UNKNOWN checks") cleaned up the autoneg advertisement by
removing some dead code. One effect of this change was that the
advertisement register would not be updated if autoneg is turned off.

This exposed a bug on the 5715 device w.r.t linking. The 5715 defaults
to advertise only 10Mb Full duplex. But with autoneg disabled, it needs
the configured speed enabled in the advertisement register to link up.

This patch adds the work around to advertise all speeds on the 5715 when
autoneg is disabled.

Reported-by: Marcin Miotk <marcinmiotk81@gmail.com>
Reviewed-by: Benjamin Li <benli@broadcom.com>
Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/broadcom/tg3.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 3756278..fdb4c52 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -4055,6 +4055,14 @@ static void tg3_phy_copper_begin(struct tg3 *tp)
 		tp->link_config.active_speed = tp->link_config.speed;
 		tp->link_config.active_duplex = tp->link_config.duplex;
 
+		if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5714) {
+			/* With autoneg disabled, 5715 only links up when the
+			 * advertisement register has the configured speed
+			 * enabled.
+			 */
+			tg3_writephy(tp, MII_ADVERTISE, ADVERTISE_ALL);
+		}
+
 		bmcr = 0;
 		switch (tp->link_config.speed) {
 		default:
-- 
1.7.10.4


