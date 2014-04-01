Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaDAQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:09:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44348 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaDAQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 15/86] net: use __GFP_NORETRY for high order allocations
Date: Tue,  1 Apr 2014 09:07:28 -0700
Message-Id: <1396368519-12728-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ed98df3361f059db42786c830ea96e2d18b8d4db ]

sock_alloc_send_pskb() & sk_page_frag_refill()
have a loop trying high order allocations to prepare
skb with low number of fragments as this increases performance.

Problem is that under memory pressure/fragmentation, this can
trigger OOM while the intent was only to try the high order
allocations, then fallback to order-0 allocations.

We had various reports from unexpected regressions.

According to David, setting __GFP_NORETRY should be fine,
as the asynchronous compaction is still enabled, and this
will prevent OOM from kicking as in :

CFSClientEventm invoked oom-killer: gfp_mask=0x42d0, order=3, oom_adj=0,
oom_score_adj=0, oom_score_badness=2 (enabled),memcg_scoring=disabled
CFSClientEventm

Call Trace:
 [<ffffffff8043766c>] dump_header+0xe1/0x23e
 [<ffffffff80437a02>] oom_kill_process+0x6a/0x323
 [<ffffffff80438443>] out_of_memory+0x4b3/0x50d
 [<ffffffff8043a4a6>] __alloc_pages_may_oom+0xa2/0xc7
 [<ffffffff80236f42>] __alloc_pages_nodemask+0x1002/0x17f0
 [<ffffffff8024bd23>] alloc_pages_current+0x103/0x2b0
 [<ffffffff8028567f>] sk_page_frag_refill+0x8f/0x160
 [<ffffffff80295fa0>] tcp_sendmsg+0x560/0xee0
 [<ffffffff802a5037>] inet_sendmsg+0x67/0x100
 [<ffffffff80283c9c>] __sock_sendmsg_nosec+0x6c/0x90
 [<ffffffff80283e85>] sock_sendmsg+0xc5/0xf0
 [<ffffffff802847b6>] __sys_sendmsg+0x136/0x430
 [<ffffffff80284ec8>] sys_sendmsg+0x88/0x110
 [<ffffffff80711472>] system_call_fastpath+0x16/0x1b
Out of Memory: Kill process 2856 (bash) score 9999 or sacrifice child

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 7367c05..68aad38 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1801,7 +1801,7 @@ bool sk_page_frag_refill(struct sock *sk, struct page_frag *pfrag)
 		gfp_t gfp = sk->sk_allocation;
 
 		if (order)
-			gfp |= __GFP_COMP | __GFP_NOWARN;
+			gfp |= __GFP_COMP | __GFP_NOWARN | __GFP_NORETRY;
 		pfrag->page = alloc_pages(gfp, order);
 		if (likely(pfrag->page)) {
 			pfrag->offset = 0;
-- 
1.8.3.2

