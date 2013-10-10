Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab3JJQOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:14:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52541 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab3JJPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 008/104] bridge: don't try to update timers in case of broken MLD queries
Date: Thu, 10 Oct 2013 08:40:56 -0700
Message-Id: <1381419752-29733-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>

[ Upstream commit 248ba8ec05a2c3b118c2224e57eb10c128176ab1 ]

Currently we are reading an uninitialized value for the max_delay
variable when snooping an MLD query message of invalid length and would
update our timers with that.

Fixing this by simply ignoring such broken MLD queries (just like we do
for IGMP already).

This is a regression introduced by:
"bridge: disable snooping if there is no querier" (b00589af3b04)

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Linus Lüssing <linus.luessing@web.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_multicast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 155bc05..e4b8742 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1167,7 +1167,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		max_delay = msecs_to_jiffies(ntohs(mld->mld_maxdelay));
 		if (max_delay)
 			group = &mld->mld_mca;
-	} else if (skb->len >= sizeof(*mld2q)) {
+	} else {
 		if (!pskb_may_pull(skb, sizeof(*mld2q))) {
 			err = -EINVAL;
 			goto out;
-- 
1.8.1.2

