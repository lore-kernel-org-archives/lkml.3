Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3I3K2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:28:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43593 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab3I3KMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 051/104] net: bridge: convert MLDv2 Query MRC into msecs_to_jiffies for max_delay
Date: Mon, 30 Sep 2013 11:10:28 +0100
Message-Id: <1380535881-9239-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit 2d98c29b6fb3de44d9eaa73c09f9cf7209346383 upstream.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/bridge/br_multicast.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 4c1954b..e881f7f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1172,7 +1172,8 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		mld2q = (struct mld2_query *)icmp6_hdr(skb);
 		if (!mld2q->mld2q_nsrcs)
 			group = &mld2q->mld2q_mca;
-		max_delay = mld2q->mld2q_mrc ? MLDV2_MRC(mld2q->mld2q_mrc) : 1;
+
+		max_delay = max(msecs_to_jiffies(MLDV2_MRC(ntohs(mld2q->mld2q_mrc))), 1UL);
 	}
 
 	if (!group)
-- 
1.8.3.2

