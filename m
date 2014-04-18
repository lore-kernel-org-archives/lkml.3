Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbaDRJb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:31:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45976 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 49/72] tcp: syncookies: do not use getnstimeofday()
Date: Fri, 18 Apr 2014 11:22:22 +0200
Message-Id: <dd79f191795df3d8b9a3d139343dc70006c2dc40.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 632623153196bf183a69686ed9c07eee98ff1bf8 ]

While it is true that getnstimeofday() uses about 40 cycles if TSC
is available, it can use 1600 cycles if hpet is the clocksource.

Switch to get_jiffies_64(), as this is more than enough, and
go back to 60 seconds periods.

Fixes: 8c27bd75f04f ("tcp: syncookies: reduce cookie lifetime to 128 seconds")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/net/tcp.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 51dcc6faa561..31c48908ae32 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -484,20 +484,21 @@ extern struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb,
 #ifdef CONFIG_SYN_COOKIES
 #include <linux/ktime.h>
 
-/* Syncookies use a monotonic timer which increments every 64 seconds.
+/* Syncookies use a monotonic timer which increments every 60 seconds.
  * This counter is used both as a hash input and partially encoded into
  * the cookie value.  A cookie is only validated further if the delta
  * between the current counter value and the encoded one is less than this,
- * i.e. a sent cookie is valid only at most for 128 seconds (or less if
+ * i.e. a sent cookie is valid only at most for 2*60 seconds (or less if
  * the counter advances immediately after a cookie is generated).
  */
 #define MAX_SYNCOOKIE_AGE 2
 
 static inline u32 tcp_cookie_time(void)
 {
-	struct timespec now;
-	getnstimeofday(&now);
-	return now.tv_sec >> 6; /* 64 seconds granularity */
+	u64 val = get_jiffies_64();
+
+	do_div(val, 60 * HZ);
+	return val;
 }
 
 extern u32 __cookie_v4_init_sequence(const struct iphdr *iph,
-- 
1.9.2

