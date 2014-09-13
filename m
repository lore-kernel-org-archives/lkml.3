Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaIMI1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 04:27:30 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41532 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaIMI12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 04:27:28 -0400
From: Shakil A Khan <shakilk1729@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: edumazet@google.com, davem@davemloft.net,
        Shakil A Khan <shakilk1729@gmail.com>
Subject: [PATCH] Freeing dst when the reference count <0 causes general protection fault, it could be a major security flaw as rogue app can modify dst to crash kernel.
Date: Sat, 13 Sep 2014 01:27:13 -0700
Message-Id: <1410596833-2548-1-git-send-email-shakilk1729@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shakil A Khan <shakilk1729@gmail.com>
---
 net/core/dst.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index a028409..6a848b0 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -284,7 +284,10 @@ void dst_release(struct dst_entry *dst)
 		int newrefcnt;
 
 		newrefcnt = atomic_dec_return(&dst->__refcnt);
-		WARN_ON(newrefcnt < 0);
+
+		if (WARN(newrefcnt < 0, "dst reference count less than zero"))
+			return;
+
 		if (unlikely(dst->flags & DST_NOCACHE) && !newrefcnt)
 			call_rcu(&dst->rcu_head, dst_destroy_rcu);
 	}
-- 
1.9.3

