Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbaDKQJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:09:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759306AbaDKQH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:07:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Phoebe Buckheister <phoebe.buckheister@itwm.fraunhofer.de>,
        Alexander Aring <alex.aring@gmail.com>,
        Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 10/41] inet: frag: make sure forced eviction removes all frags
Date: Fri, 11 Apr 2014 09:09:41 -0700
Message-Id: <20140411160933.572114053@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160932.865173041@linuxfoundation.org>
References: <20140411160932.865173041@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_fragment.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -211,7 +211,7 @@ int inet_frag_evictor(struct netns_frags
 	}
 
 	work = frag_mem_limit(nf) - nf->low_thresh;
-	while (work > 0) {
+	while (work > 0 || force) {
 		spin_lock(&nf->lru_lock);
 
 		if (list_empty(&nf->lru_list)) {


