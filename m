Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbaFKXkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:40:42 -0400
Received: from mout.web.de ([212.227.17.12]:57977 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbaFKXkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:40:39 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCH 1/2] bridge: fix smatch warning / potential null pointer dereference
Date: Thu, 12 Jun 2014 01:41:23 +0200
Message-Id: <1402530084-15061-2-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402530084-15061-1-git-send-email-linus.luessing@web.de>
References: <1402530084-15061-1-git-send-email-linus.luessing@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:nWa4PpVVut72Z1Isw10GT8GaTm7RXw3/6cskf5CwcCQMBXzhNii
 uBVRCgDSCBXqQilUegHh0MKzRT0F4WI743tuzSrOak0Xgoj41Iljlw/pqlqL4b+8VdVYCG8
 mcjaSknxmknwvLgUpZGtC4YbHSLlFM4dHaawkJz5DFEwW8apfDeWSBvqx6pUfKp5FPqJj4f
 Tf+gK3I5oOooDiD+eM+2A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 "New smatch warnings:
  net/bridge/br_multicast.c:1368 br_ip6_multicast_query() error:
    we previously assumed 'group' could be null (see line 1349)"

In the rare (sort of broken) case of a query having a Maximum
Response Delay of zero, we could create a potential null pointer
dereference.

Fixing this by skipping the multicast specific MLD Query parsing again
if no multicast group address is available.

Introduced by dc4eb53a996a78bfb8ea07b47423ff5a3aadc362
("bridge: adhere to querier election mechanism specified by RFCs")

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 net/bridge/br_multicast.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index cd3cf39..876e5fb 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1373,6 +1373,8 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		br_multicast_query_received(br, port, &br->ip6_other_query,
 					    &saddr, max_delay);
 		goto out;
+	} else if (!group) {
+		goto out;
 	}
 
 	mp = br_mdb_ip6_get(mlock_dereference(br->mdb, br), group, vid);
-- 
1.7.10.4

