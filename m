Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677Ab3CZPZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:25:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54220 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965477Ab3CZPYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Mintz Yuval <yuvalmin@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 148/150] bnx2x: fix occasional statistics off-by-4GB error
Date: Tue, 26 Mar 2013 15:20:47 +0000
Message-Id: <1364311249-14454-149-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>

commit b009aac12cd0fe34293c68af8ac48b85be3bd858 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
index 93e689fd..c664a61 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
@@ -451,8 +451,9 @@ struct bnx2x_fw_port_stats_old {
 
 #define UPDATE_QSTAT(s, t) \
 	do { \
-		qstats->t##_hi = qstats_old->t##_hi + le32_to_cpu(s.hi); \
 		qstats->t##_lo = qstats_old->t##_lo + le32_to_cpu(s.lo); \
+		qstats->t##_hi = qstats_old->t##_hi + le32_to_cpu(s.hi) \
+			+ ((qstats->t##_lo < qstats_old->t##_lo) ? 1 : 0); \
 	} while (0)
 
 #define UPDATE_QSTAT_OLD(f) \
-- 
1.8.1.2

