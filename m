Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbaBUNhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:37:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47073 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbaBUMuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 070/121] nl80211: Reset split_start when netlink skb is exhausted
Date: Fri, 21 Feb 2014 12:48:14 +0000
Message-Id: <1392986945-9693-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pontus Fuchs <pontus.fuchs@gmail.com>

commit f12cb2893069495726c21a4b0178705dacfecfe0 upstream.

When the netlink skb is exhausted split_start is left set. In the
subsequent retry, with a larger buffer, the dump is continued from the
failing point instead of from the beginning.

This was causing my rt28xx based USB dongle to now show up when
running "iw list" with an old iw version without split dump support.

Fixes: 3713b4e364ef ("nl80211: allow splitting wiphy information in dumps")
Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
[avoid the entire workaround when state->split is set]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7956f41..95b8565 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1613,9 +1613,10 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 				 * We can then retry with the larger buffer.
 				 */
 				if ((ret == -ENOBUFS || ret == -EMSGSIZE) &&
-				    !skb->len &&
+				    !skb->len && !state->split &&
 				    cb->min_dump_alloc < 4096) {
 					cb->min_dump_alloc = 4096;
+					state->split_start = 0;
 					rtnl_unlock();
 					return 1;
 				}
-- 
1.9.0

