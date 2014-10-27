Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaJ0FZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:25:28 -0400
Received: from smtprelay0252.hostedemail.com ([216.40.44.252]:44391 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752778AbaJ0FZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:25:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3871:4250:4605:5007:6117:6261:10004:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357:13523:13524:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pets80_4c7f8e722f819
X-Filterd-Recvd-Size: 1884
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org
Subject: [PATCH 04/11] dvb-net: Fix probable mask then right shift defects
Date: Sun, 26 Oct 2014 22:25:00 -0700
Message-Id: <dd93cdd7254bc6405709e1e53b07e8555647a372.1414387334.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1414387334.git.joe@perches.com>
References: <cover.1414387334.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Precedence of & and >> is not the same and is not left to right.
shift has higher precedence and should be done after the mask.

Add parentheses around the mask.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb-core/dvb_net.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index 059e611..441814b 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -379,7 +379,9 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 			/* Check TS error conditions: sync_byte, transport_error_indicator, scrambling_control . */
 			if ((ts[0] != TS_SYNC) || (ts[1] & TS_TEI) || ((ts[3] & TS_SC) != 0)) {
 				printk(KERN_WARNING "%lu: Invalid TS cell: SYNC %#x, TEI %u, SC %#x.\n",
-				       priv->ts_count, ts[0], ts[1] & TS_TEI >> 7, ts[3] & 0xC0 >> 6);
+				       priv->ts_count, ts[0],
+				       (ts[1] & TS_TEI) >> 7,
+				       (ts[3] & 0xC0) >> 6);
 
 				/* Drop partly decoded SNDU, reset state, resync on PUSI. */
 				if (priv->ule_skb) {
-- 
2.1.2

