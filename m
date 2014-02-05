Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbaBEVRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:17:09 -0500
Received: from mail.windriver.com ([147.11.1.11]:54166 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaBEUDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:30 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 009/213] bridge: Fix mglist corruption that leads to memory corruption
Date: Wed, 5 Feb 2014 14:59:24 -0500
Message-ID: <1391630568-49251-10-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6b0d6a9b4296fa16a28d10d416db7a770fc03287 upstream.

The list mp->mglist is used to indicate whether a multicast group
is active on the bridge interface itself as opposed to one of the
constituent interfaces in the bridge.

Unfortunately the operation that adds the mp->mglist node to the
list neglected to check whether it has already been added.  This
leads to list corruption in the form of nodes pointing to itself.

Normally this would be quite obvious as it would cause an infinite
loop when walking the list.  However, as this list is never actually
walked (which means that we don't really need it, I'll get rid of
it in a subsequent patch), this instead is hidden until we perform
a delete operation on the affected nodes.

As the same node may now be pointed to by more than one node, the
delete operations can then cause modification of freed memory.

This was observed in practice to cause corruption in 512-byte slabs,
most commonly leading to crashes in jbd2.

Thanks to Josef Bacik for pointing me in the right direction.

Reported-by: Ian Page Hands <ihands@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/bridge/br_multicast.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index eaa0e1bae49b..ea4452f3dacb 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -532,7 +532,8 @@ static int br_multicast_add_group(struct net_bridge *br,
 		goto err;
 
 	if (!port) {
-		hlist_add_head(&mp->mglist, &br->mglist);
+		if (hlist_unhashed(&mp->mglist))
+			hlist_add_head(&mp->mglist, &br->mglist);
 		mod_timer(&mp->timer, now + br->multicast_membership_interval);
 		goto out;
 	}
-- 
1.8.5.2

