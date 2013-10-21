Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab3JUJdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:33:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39297 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230Ab3JUIuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Borkmann" <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "=?UTF-8?Q?Linus=20L=C3=BCssing?=" <linus.luessing@web.de>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.842275523@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 012/149] net: bridge: convert MLDv2 Query MRC into 
 msecs_to_jiffies for max_delay
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bridge/br_multicast.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b81500c..a06deca 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1155,7 +1155,8 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		mld2q = (struct mld2_query *)icmp6_hdr(skb);
 		if (!mld2q->mld2q_nsrcs)
 			group = &mld2q->mld2q_mca;
-		max_delay = mld2q->mld2q_mrc ? MLDV2_MRC(mld2q->mld2q_mrc) : 1;
+
+		max_delay = max(msecs_to_jiffies(MLDV2_MRC(ntohs(mld2q->mld2q_mrc))), 1UL);
 	}
 
 	if (!group)

