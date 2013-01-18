Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3ARNhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:37:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40033 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3ARNhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:37:48 -0500
Date: Fri, 18 Jan 2013 16:36:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch v2] b43: N-PHY: fix gain in
 b43_nphy_get_gain_ctl_workaround_ent()
Message-ID: <20130118133658.GA31186@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F84AF3.5070901@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were no break statements in this switch statement so everything
used the default settings.  Per Walter Harms's suggestion, I've replaced
the switch statement and done a little cleanup.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Additional cleanups.

diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 97d4e27..99567db 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -3226,8 +3226,6 @@ struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
 {
 	struct nphy_gain_ctl_workaround_entry *e;
 	u8 phy_idx;
-	u8 tr_iso = ghz5 ? dev->dev->bus_sprom->fem.ghz5.tr_iso :
-			   dev->dev->bus_sprom->fem.ghz2.tr_iso;
 
 	if (!ghz5 && dev->phy.rev >= 6 && dev->phy.radio_rev == 11)
 		return &nphy_gain_ctl_wa_phy6_radio11_ghz2;
@@ -3249,6 +3247,10 @@ struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
 		    !b43_channel_type_is_40mhz(dev->phy.channel_type))
 			e->cliplo_gain = 0x2d;
 	} else if (!ghz5 && dev->phy.rev >= 5) {
+		int gain_data[] = {0x0062, 0x0064, 0x006a, 0x106a, 0x106c,
+				   0x1074, 0x107c, 0x207c};
+		u8 tr_iso = dev->dev->bus_sprom->fem.ghz2.tr_iso;
+
 		if (ext_lna) {
 			e->rfseq_init[0] &= ~0x4000;
 			e->rfseq_init[1] &= ~0x4000;
@@ -3256,26 +3258,10 @@ struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
 			e->rfseq_init[3] &= ~0x4000;
 			e->init_gain &= ~0x4000;
 		}
-		switch (tr_iso) {
-		case 0:
-			e->cliplo_gain = 0x0062;
-		case 1:
-			e->cliplo_gain = 0x0064;
-		case 2:
-			e->cliplo_gain = 0x006a;
-		case 3:
-			e->cliplo_gain = 0x106a;
-		case 4:
-			e->cliplo_gain = 0x106c;
-		case 5:
-			e->cliplo_gain = 0x1074;
-		case 6:
-			e->cliplo_gain = 0x107c;
-		case 7:
-			e->cliplo_gain = 0x207c;
-		default:
-			e->cliplo_gain = 0x106a;
-		}
+		if (tr_iso > 7)
+			tr_iso = 3;
+		e->cliplo_gain = gain_data[tr_iso];
+
 	} else if (ghz5 && dev->phy.rev == 4 && ext_lna) {
 		e->rfseq_init[0] &= ~0x4000;
 		e->rfseq_init[1] &= ~0x4000;
