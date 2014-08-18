Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbaHRJea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:34:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42624 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaHRJeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 041/137] net: fix sparse warning in sk_dst_set()
Date: Mon, 18 Aug 2014 10:31:42 +0100
Message-Id: <1408354398-10226-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 5925a0555bdaf0b396a84318cbc21ba085f6c0d3 upstream.

sk_dst_cache has __rcu annotation, so we need a cast to avoid
following sparse error :

include/net/sock.h:1774:19: warning: incorrect type in initializer (different address spaces)
include/net/sock.h:1774:19:    expected struct dst_entry [noderef] <asn:4>*__ret
include/net/sock.h:1774:19:    got struct dst_entry *dst

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Fixes: 7f502361531e ("ipv4: irq safe sk_dst_[re]set() and ipv4_sk_update_pmtu() fix")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 447205545c1c..f4478d696112 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1776,7 +1776,7 @@ sk_dst_set(struct sock *sk, struct dst_entry *dst)
 	struct dst_entry *old_dst;
 
 	sk_tx_queue_clear(sk);
-	old_dst = xchg(&sk->sk_dst_cache, dst);
+	old_dst = xchg((__force struct dst_entry **)&sk->sk_dst_cache, dst);
 	dst_release(old_dst);
 }
 
-- 
1.9.1

