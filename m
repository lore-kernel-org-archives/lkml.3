Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaGZTNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:13:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaGZTNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 40/87] net: fix sparse warning in sk_dst_set()
Date: Sat, 26 Jul 2014 12:02:14 -0700
Message-Id: <20140726190215.825454962@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5925a0555bdaf0b396a84318cbc21ba085f6c0d3 ]

sk_dst_cache has __rcu annotation, so we need a cast to avoid
following sparse error :

include/net/sock.h:1774:19: warning: incorrect type in initializer (different address spaces)
include/net/sock.h:1774:19:    expected struct dst_entry [noderef] <asn:4>*__ret
include/net/sock.h:1774:19:    got struct dst_entry *dst

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Fixes: 7f502361531e ("ipv4: irq safe sk_dst_[re]set() and ipv4_sk_update_pmtu() fix")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1796,7 +1796,7 @@ sk_dst_set(struct sock *sk, struct dst_e
 	struct dst_entry *old_dst;
 
 	sk_tx_queue_clear(sk);
-	old_dst = xchg(&sk->sk_dst_cache, dst);
+	old_dst = xchg((__force struct dst_entry **)&sk->sk_dst_cache, dst);
 	dst_release(old_dst);
 }
 


