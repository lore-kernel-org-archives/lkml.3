Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbaKSUx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:53:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711AbaKSUxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Eric Dumazet <eric.dumazet@gmail.com>,
        Patrick McLean <chutzpah@gentoo.org>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 002/141] inet: frags: fix a race between inet_evict_bucket and inet_frag_kill
Date: Wed, 19 Nov 2014 12:50:25 -0800
Message-Id: <20141119205150.777172967@linuxfoundation.org>
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

[ Upstream commit 65ba1f1ec0eff1c25933468e1d238201c0c2cb29 ]

When the evictor is running it adds some chosen frags to a local list to
be evicted once the chain lock has been released but at the same time
the *frag_queue can be running for some of the same queues and it
may call inet_frag_kill which will wait on the chain lock and
will then delete the queue from the wrong list since it was added in the
eviction one. The fix is simple - check if the queue has the evict flag
set under the chain lock before deleting it, this is safe because the
evict flag is set only under that lock and having the flag set also means
that the queue has been detached from the chain list, so no need to delete
it again.
An important note to make is that we're safe w.r.t refcnt because
inet_frag_kill and inet_evict_bucket will sync on the del_timer operation
where only one of the two can succeed (or if the timer is executing -
none of them), the cases are:
1. inet_frag_kill succeeds in del_timer
 - then the timer ref is removed, but inet_evict_bucket will not add
   this queue to its expire list but will restart eviction in that chain
2. inet_evict_bucket succeeds in del_timer
 - then the timer ref is kept until the evictor "expires" the queue, but
   inet_frag_kill will remove the initial ref and will set
   INET_FRAG_COMPLETE which will make the frag_expire fn just to remove
   its ref.
In the end all of the queue users will do an inet_frag_put and the one
that reaches 0 will free it. The refcount balance should be okay.

CC: Florian Westphal <fw@strlen.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Patrick McLean <chutzpah@gentoo.org>

Fixes: b13d3cbfb8e8 ("inet: frag: move eviction of queues to work queue")
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Reported-by: Patrick McLean <chutzpah@gentoo.org>
Tested-by: Patrick McLean <chutzpah@gentoo.org>
Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_fragment.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -285,7 +285,8 @@ static inline void fq_unlink(struct inet
 	struct inet_frag_bucket *hb;
 
 	hb = get_frag_bucket_locked(fq, f);
-	hlist_del(&fq->list);
+	if (!(fq->flags & INET_FRAG_EVICTED))
+		hlist_del(&fq->list);
 	spin_unlock(&hb->chain_lock);
 }
 


