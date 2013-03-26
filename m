Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3CZXZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:25:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab3CZWwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Mintz Yuval <yuvalmin@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 13/72] bnx2x: fix occasional statistics off-by-4GB error
Date: Tue, 26 Mar 2013 15:50:56 -0700
Message-Id: <20130326224921.099584759@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Maciej Żenczykowski <maze@google.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
@@ -439,8 +439,9 @@ struct bnx2x_fw_port_stats_old {
 
 #define UPDATE_QSTAT(s, t) \
 	do { \
-		qstats->t##_hi = qstats_old->t##_hi + le32_to_cpu(s.hi); \
 		qstats->t##_lo = qstats_old->t##_lo + le32_to_cpu(s.lo); \
+		qstats->t##_hi = qstats_old->t##_hi + le32_to_cpu(s.hi) \
+			+ ((qstats->t##_lo < qstats_old->t##_lo) ? 1 : 0); \
 	} while (0)
 
 #define UPDATE_QSTAT_OLD(f) \


