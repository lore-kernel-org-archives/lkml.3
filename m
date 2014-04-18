Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaDRJm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:42:56 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45933 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 32/72] inet: frag: make sure forced eviction removes all frags
Date: Fri, 18 Apr 2014 11:22:05 +0200
Message-Id: <d291aa322b32aa808e914996c7f234024e53432d.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit e588e2f286ed7da011ed357c24c5b9a554e26595 ]

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/inet_fragment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index e15fb7b2db59..12b80fbfe767 100644
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
1.9.2

