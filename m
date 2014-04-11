Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934957AbaDKQoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:44:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759586AbaDKQJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 34/65] tcp: syncookies: do not use getnstimeofday()
Date: Fri, 11 Apr 2014 09:11:06 -0700
Message-Id: <20140411161002.437877741@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -480,20 +480,21 @@ struct sock *cookie_v4_check(struct sock
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
 
 u32 __cookie_v4_init_sequence(const struct iphdr *iph, const struct tcphdr *th,


