Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3EUJSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:18:05 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:57835 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972Ab3EUJSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:18:03 -0400
X-Greylist: delayed 727 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2013 05:18:03 EDT
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <519B38EC.90401@yandex-team.ru>
Date: Tue, 21 May 2013 13:05:48 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: zhmurov@yandex-team.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH] rcu: fix a race in hlist_nulls_for_each_entry_rcu macro
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all!

This is a fix for a problem described here:
https://lkml.org/lkml/2013/4/16/371 .
---

Some network functions (udp4_lib_lookup2(), for instance) use the
hlist_nulls_for_each_entry_rcu macro in a way that assumes restarting
of a loop. In this case, it is strictly necessary to reread the head->first
value from the memory before each scan.
Without additional hints, gcc caches this value in a register. In this case,
if a cached node is moved to another chain during the scan, we can loop
forever getting wrong nulls values and restarting the loop uninterruptedly.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
Reported-by: Boris Zhmurov <zhmurov@yandex-team.ru>
---
  include/linux/rculist_nulls.h | 5 +++--
  1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index 2ae1371..efd51bf 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -37,8 +37,9 @@ static inline void hlist_nulls_del_init_rcu(struct 
hlist_nulls_node *n)
  	}
  }

-#define hlist_nulls_first_rcu(head) \
-	(*((struct hlist_nulls_node __rcu __force **)&(head)->first))
+#define hlist_nulls_first_rcu(head)			\
+	(*((struct hlist_nulls_node __rcu __force **)	\
+	   &((volatile typeof(*head) *)head)->first))

  #define hlist_nulls_next_rcu(node) \
  	(*((struct hlist_nulls_node __rcu __force **)&(node)->next))
-- 
1.8.1.2
