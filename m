Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3JJP5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:57:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52962 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3JJPt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 023/104] net: bridge: convert MLDv2 Query MRC into msecs_to_jiffies for max_delay
Date: Thu, 10 Oct 2013 08:41:11 -0700
Message-Id: <1381419752-29733-24-git-send-email-kamal@canonical.com>
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

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 2d98c29b6fb3de44d9eaa73c09f9cf7209346383 ]

While looking into MLDv1/v2 code, I noticed that bridging code does
not convert it's max delay into jiffies for MLDv2 messages as we do
in core IPv6' multicast code.

RFC3810, 5.1.3. Maximum Response Code says:

  The Maximum Response Code field specifies the maximum time allowed
  before sending a responding Report. The actual time allowed, called
  the Maximum Response Delay, is represented in units of milliseconds,
  and is derived from the Maximum Response Code as follows: [...]

As we update timers that work with jiffies, we need to convert it.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Linus Lüssing <linus.luessing@web.de>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_multicast.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index e4b8742..4a51874 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1175,7 +1175,8 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		mld2q = (struct mld2_query *)icmp6_hdr(skb);
 		if (!mld2q->mld2q_nsrcs)
 			group = &mld2q->mld2q_mca;
-		max_delay = mld2q->mld2q_mrc ? MLDV2_MRC(ntohs(mld2q->mld2q_mrc)) : 1;
+
+		max_delay = max(msecs_to_jiffies(MLDV2_MRC(ntohs(mld2q->mld2q_mrc))), 1UL);
 	}
 
 	if (!group)
-- 
1.8.1.2

