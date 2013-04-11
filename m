Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814Ab3DKU0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:26:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4200 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab3DKU0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:00 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=iLICccvWyVAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=fSRBuni4p8oA:10 a=1XWaLZrsAAAA:8 a=Q-fNiiVtAAAA:8 a=J1Y8HTJGAAAA:8 a=ayC55rCoAAAA:8 a=RvlEQHu-AAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=E6k37eg1NvgA:10 a=UTB_XpHje0EA:10 a=lcTMV_K9oDIA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202549.225054373@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Mintz Yuval <yuvalmin@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 018/171 ] bnx2x: fix occasional statistics off-by-4GB error
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0018-bnx2x-fix-occasional-statistics-off-by-4GB-error.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>

[ Upstream commit b009aac12cd0fe34293c68af8ac48b85be3bd858 ]

The UPDATE_QSTAT function introduced on February 15, 2012
in commit 1355b704b9ba "bnx2x: consistent statistics after
internal driver reload" incorrectly fails to handle overflow
during addition of the lower 32-bit field of a stat.

This bug is present since 3.4-rc1 and should thus be considered
a candidate for stable 3.4+ releases.

Google-Bug-Id: 8374428
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Cc: Mintz Yuval <yuvalmin@broadcom.com>
Acked-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
index 24b8e50..06bd1c0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
@@ -453,8 +453,9 @@ struct bnx2x_fw_port_stats_old {
 
 #define UPDATE_QSTAT(s, t) \
 	do { \
-		qstats->t##_hi = qstats_old->t##_hi + le32_to_cpu(s.hi); \
 		qstats->t##_lo = qstats_old->t##_lo + le32_to_cpu(s.lo); \
+		qstats->t##_hi = qstats_old->t##_hi + le32_to_cpu(s.hi) \
+			+ ((qstats->t##_lo < qstats_old->t##_lo) ? 1 : 0); \
 	} while (0)
 
 #define UPDATE_QSTAT_OLD(f) \
-- 
1.7.10.4


