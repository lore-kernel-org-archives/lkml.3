Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478AbaKSWeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:34:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaKSUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Eric Dumazet <eric.dumazet@gmail.com>,
        Patrick McLean <chutzpah@gentoo.org>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 003/141] inet: frags: remove the WARN_ON from inet_evict_bucket
Date: Wed, 19 Nov 2014 12:50:26 -0800
Message-Id: <20141119205150.806583338@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@redhat.com>

[ Upstream commit d70127e8a942364de8dd140fe73893efda363293 ]

The WARN_ON in inet_evict_bucket can be triggered by a valid case:
inet_frag_kill and inet_evict_bucket can be running in parallel on the
same queue which means that there has been at least one more ref added
by a previous inet_frag_find call, but inet_frag_kill can delete the
timer before inet_evict_bucket which will cause the WARN_ON() there to
trigger since we'll have refcnt!=1. Now, this case is valid because the
queue is being "killed" for some reason (removed from the chain list and
its timer deleted) so it will get destroyed in the end by one of the
inet_frag_put() calls which reaches 0 i.e. refcnt is still valid.

CC: Florian Westphal <fw@strlen.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Patrick McLean <chutzpah@gentoo.org>

Fixes: b13d3cbfb8e8 ("inet: frag: move eviction of queues to work queue")
Reported-by: Patrick McLean <chutzpah@gentoo.org>
Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_fragment.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -146,7 +146,6 @@ evict_again:
 			atomic_inc(&fq->refcnt);
 			spin_unlock(&hb->chain_lock);
 			del_timer_sync(&fq->timer);
-			WARN_ON(atomic_read(&fq->refcnt) != 1);
 			inet_frag_put(fq, f);
 			goto evict_again;
 		}


