Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935774Ab3DHJwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:52:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42856 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935689Ab3DHJwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 057/102] net: remove a WARN_ON() in net_enable_timestamp()
Date: Mon,  8 Apr 2013 10:50:12 +0100
Message-Id: <1365414657-29191-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 9979a55a833883242e3a29f3596676edd7199c46 upstream.

The WARN_ON(in_interrupt()) in net_enable_timestamp() can get false
positive, in socket clone path, run from softirq context :

[ 3641.624425] WARNING: at net/core/dev.c:1532 net_enable_timestamp+0x7b/0x80()
[ 3641.668811] Call Trace:
[ 3641.671254]  <IRQ>  [<ffffffff80286817>] warn_slowpath_common+0x87/0xc0
[ 3641.677871]  [<ffffffff8028686a>] warn_slowpath_null+0x1a/0x20
[ 3641.683683]  [<ffffffff80742f8b>] net_enable_timestamp+0x7b/0x80
[ 3641.689668]  [<ffffffff80732ce5>] sk_clone_lock+0x425/0x450
[ 3641.695222]  [<ffffffff8078db36>] inet_csk_clone_lock+0x16/0x170
[ 3641.701213]  [<ffffffff807ae449>] tcp_create_openreq_child+0x29/0x820
[ 3641.707663]  [<ffffffff807d62e2>] ? ipt_do_table+0x222/0x670
[ 3641.713354]  [<ffffffff807aaf5b>] tcp_v4_syn_recv_sock+0xab/0x3d0
[ 3641.719425]  [<ffffffff807af63a>] tcp_check_req+0x3da/0x530
[ 3641.724979]  [<ffffffff8078b400>] ? inet_hashinfo_init+0x60/0x80
[ 3641.730964]  [<ffffffff807ade6f>] ? tcp_v4_rcv+0x79f/0xbe0
[ 3641.736430]  [<ffffffff807ab9bd>] tcp_v4_do_rcv+0x38d/0x4f0
[ 3641.741985]  [<ffffffff807ae14a>] tcp_v4_rcv+0xa7a/0xbe0

Its safe at this point because the parent socket owns a reference
on the netstamp_needed, so we cant have a 0 -> 1 transition, which
requires to lock a mutex.

Instead of refining the check, lets remove it, as all known callers
are safe. If it ever changes in the future, static_key_slow_inc()
will complain anyway.

Reported-by: Laurent Chavey <chavey@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/dev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 097dd07..39aa9e6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1481,7 +1481,6 @@ void net_enable_timestamp(void)
 		return;
 	}
 #endif
-	WARN_ON(in_interrupt());
 	static_key_slow_inc(&netstamp_needed);
 }
 EXPORT_SYMBOL(net_enable_timestamp);
-- 
1.8.1.2

