Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbaGVHnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:43:12 -0400
Received: from sf1.bxl.stone.is ([87.238.167.36]:36235 "EHLO sf1.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbaGVHnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:43:10 -0400
X-Greylist: delayed 1506 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2014 03:43:09 EDT
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <53CE1019.10708@acm.org>
Date: Tue, 22 Jul 2014 09:17:45 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] spin_lock_*(): Always evaluate second argument
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Filter-ID: XtLePq6GTMn8G68F0EmQvdthj6rk7ohlAkaRQG+cDaLZlN3ufQ0ZRHdy43341LQ0JYRGiu4wDuX/
 sGw1Y7RAsZ3WBw9ZlycipwBG3jGu9D8JBgu10R0foqIRsBJqRnurUO/XCGxJVedBWv8BXp6lSPrf
 oA0XngOaR5RLFk6kKY8+X6tyUZ34Ozy6TOwmaHPzFR2lHDoBQ4zwtMehH4SfWgLcNhHqvET8hkHK
 4DD3CZT4SL0VvzAbTStaxE3e6xctxkHXgTSJC2+q+O2n2sPwh+CpLQk2sgUsKd5RNPNJeN3I5L/U
 AJH41ve/RciJD7RwcMm6IODZgOZ9Y8BEoKFU+dzgzBjgkUsRq+0KizzzZTwccBIk1Sag4dKiqCrF
 8eZZsQYibGPulATAPqOguWXWenmy4p4jVbvkvQrOImHI+zH4ns3e6vWEaK66hz4t87L5hVQSL57W
 w8nd1cTP1twpFFTUuHOuOBA828Pfce2frIKvtUus/ypEW5W6Dw4DmSZF9OoIMWCP9bnVs5BJWbbt
 5dM+m4WpRRDP6YzwkAPgQJaKU5I28BZhNBr6AB2vjBdZoSsPncJzs0ko62F1uyXZZJKltYIghTgz
 J1D65bFKqCOXyheAAoPip2ph7hFC6nuKkWWTCUuF41ARabMkUxuaFe1aAbkd+Drk/wUcdNdYULux
 sP6rNv5WC5d9nIoRsnJAaIfVaCHpEB6cFH6WJxE4Zkxyoe1CuOZusrB8XPhQw0vIqzcwrK9px5rC
 Uj2fwcR2vyzqXRfAF7JmLhOQS414q29fqb7k1HihCn426Rq7Tjg=
X-Report-Abuse-To: spam@sf1.bxl.stone.is
X-Filter-Fingerprint: cPaH8lomer6UwsJ3BnJDyh/24V0ZnPLChpTdx0aQyMi0VFDyP20las9Mq1v6nXmfrqKtWpHLpkE8
 c09GKJn2t/R5csDuTraLxPutQ1X4oTbd1PHxHTVUQ6kKwyUfwBkXbbcemmvc6LV6reHAmFfSz0ej
 vfBM5HDil32B6EA6ECAwtB2mFrRhH9FyTxY8sWyB9L7OhwGv0ZygZg0/dv9SI5jp2wMQvksbXuh+
 Zur/YDgNaJU0bkU579fapNXDRWH7lv8Ffx5tjiiMQ9xvR0covSWj1kd0N16AJIzbHn3urrx4Wbeh
 q/Opdsi7BOVfsfwvSJShWLasdzZUdvGWo1rJHpK6MV7h1ScRaOZDGmDjuwCVHt9iOMjj3H239sxK
 lxS1HercA6QfoF+YUQla4KJc1ketyiyitBf5m6/lgRxOYLNPjW0yR9SLGgzMR5OafAXiuV1fZXBB
 L40T0pJpJ+Ma8A==
X-Originating-IP: 87.238.167.34
X-SpamExperts-Domain: stone.is
X-SpamExperts-Username: 87.238.167.34
Authentication-Results: bxl.stone.is; auth=pass smtp.auth=87.238.167.34
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.02)
X-Recommended-Action: accept
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evaluating a macro argument only if certain configuration options
have been selected is confusing and error-prone. Hence always
evaluate the second argument of spin_lock_nested() and
spin_lock_nest_lock().

An intentional side effect of this patch is that it avoids that
the following warning is reported for netif_addr_lock_nested()
when building with CONFIG_DEBUG_LOCK_ALLOC=n and with W=1:

include/linux/netdevice.h: In function 'netif_addr_lock_nested':
include/linux/netdevice.h:2865:6: warning: variable 'subclass' set but not used [-Wunused-but-set-variable]
  int subclass = SINGLE_DEPTH_NESTING;
      ^

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/spinlock.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 3f2867f..32b16cc 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -197,8 +197,10 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
 	 } while (0)
 #else
-# define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
-# define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
+# define raw_spin_lock_nested(lock, subclass)		\
+	((void)(subclass), _raw_spin_lock(lock))
+# define raw_spin_lock_nest_lock(lock, nest_lock)	\
+	((void)(nest_lock), _raw_spin_lock(lock))
 #endif
 
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-- 
1.8.4.5

