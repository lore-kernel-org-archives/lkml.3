Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaDPKcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:32:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51658 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbaDPKc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 13/46] inet: frag: make sure forced eviction removes all frags
Date: Wed, 16 Apr 2014 11:31:29 +0100
Message-Id: <1397644322-13905-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit e588e2f286ed7da011ed357c24c5b9a554e26595 upstream.

Quoting Alexander Aring:
  While fragmentation and unloading of 6lowpan module I got this kernel Oops
  after few seconds:

  BUG: unable to handle kernel paging request at f88bbc30
  [..]
  Modules linked in: ipv6 [last unloaded: 6lowpan]
  Call Trace:
   [<c012af4c>] ? call_timer_fn+0x54/0xb3
   [<c012aef8>] ? process_timeout+0xa/0xa
   [<c012b66b>] run_timer_softirq+0x140/0x15f

Problem is that incomplete frags are still around after unload; when
their frag expire timer fires, we get crash.

When a netns is removed (also done when unloading module), inet_frag
calls the evictor with 'force' argument to purge remaining frags.

The evictor loop terminates when accounted memory ('work') drops to 0
or the lru-list becomes empty.  However, the mem accounting is done
via percpu counters and may not be accurate, i.e. loop may terminate
prematurely.

Alter evictor to only stop once the lru list is empty when force is
requested.

Reported-by: Phoebe Buckheister <phoebe.buckheister@itwm.fraunhofer.de>
Reported-by: Alexander Aring <alex.aring@gmail.com>
Tested-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/inet_fragment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index e15fb7b..12b80fb 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -211,7 +211,7 @@ int inet_frag_evictor(struct netns_frags *nf, struct inet_frags *f, bool force)
 	}
 
 	work = frag_mem_limit(nf) - nf->low_thresh;
-	while (work > 0) {
+	while (work > 0 || force) {
 		spin_lock(&nf->lru_lock);
 
 		if (list_empty(&nf->lru_list)) {
-- 
1.9.1

