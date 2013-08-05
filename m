Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab3HEWcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:32:21 -0400
Received: from mout.web.de ([212.227.15.4]:64102 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab3HEWcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:32:20 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: bridge@lists.linux-foundation.org
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Cong Wang <amwang@redhat.com>, Adam Baker <linux@baker-net.org.uk>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] bridge: don't try to update timers in case of broken MLD queries
Date: Tue,  6 Aug 2013 00:32:05 +0200
Message-Id: <1375741925-22179-1-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:bCMlSpdMEGrTjwFzSPJKjR3+KkN+8JtfH++9WY+o/z4ADodlNjY
 tUqUCWvgd+yDCb8YrEm8oB/nFJODFgQ5Mi73NRJUUqaoTMedVfbDo7CtWFiFPdnsgG2uf4y
 +UdlYLF9cTZN5UgJpRlwu+iru2Obqbs0kh5TACeP6xFSC40FjR+tiOS29yUJE8ZUOhYFO0R
 mcsxPr3SnK3r1dJmGNxnA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we are reading an uninitialized value for the max_delay
variable when snooping an MLD query message of invalid length and would
update our timers with that.

Fixing this by simply ignoring such broken MLD queries (just like we do
for IGMP already).

This is a regression introduced by:
"bridge: disable snooping if there is no querier" (b00589af3b04)

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 net/bridge/br_multicast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 61c5e81..08e576a 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1195,7 +1195,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		max_delay = msecs_to_jiffies(ntohs(mld->mld_maxdelay));
 		if (max_delay)
 			group = &mld->mld_mca;
-	} else if (skb->len >= sizeof(*mld2q)) {
+	} else {
 		if (!pskb_may_pull(skb, sizeof(*mld2q))) {
 			err = -EINVAL;
 			goto out;
-- 
1.7.10.4

