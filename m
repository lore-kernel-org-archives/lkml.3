Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaDYPHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:07:50 -0400
Received: from 4dim-gw.4dim.as ([81.7.137.98]:36091 "EHLO
	SECOEXCHANGE.secomea.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751238AbaDYPHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:07:46 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Apr 2014 11:07:46 EDT
Message-ID: <535A78ED.3020309@secomea.com>
Date: Fri, 25 Apr 2014 17:02:05 +0200
From: =?UTF-8?B?U3Zlbm5pbmcgU8O4cmVuc2Vu?= <sss@secomea.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] net: guard against coalescing packets from buggy network
 drivers
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [178.21.90.126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a guard against coalescing packets received by buggy network
drivers that don't initialize skb->tail properly.

Coalescing such packets will corrupt data in a way that makes it hard to
track down the real cause of the problem. Observed symptoms are a flood of
WARNs by tcp_recvmsg at random times, leaving no clear indication as to why
the packet buffers were corrupted. See for example this thread:
https://groups.google.com/forum/#!topic/linux.kernel/A8ZI9aXooSU

Obviously the correct thing to do is fixing the drivers in question (eg. by
using skb_put() instead of just setting skb->len) - this patch will 
hopefully
help to track them down with less effort than I had to put into it :)

NB: in my case it was an out-of-tree Bluegiga WiFi driver; a quick look 
indicates
that there are in-tree drivers (for hardware that I don't own) with the 
same bug.


Signed-off-by: Svenning Soerensen <sss@secomea.com>

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1b62343..188a60a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3833,6 +3833,19 @@ bool skb_try_coalesce(struct sk_buff *to, struct 
sk_buff *from,
          return false;

      if (len <= skb_tailroom(to)) {
+        /* Guard against buggy network drivers that don't initialize
+         * skb properly: if they manipulate skb->len directly without
+         * setting skb->tail, the skb_put below may return a pointer to
+         * live data (such as TCP headers) that (without this guard)
+         * would get overwritten by coalescing.
+         * The correct thing to do is fixing the network drivers - but
+         * this guard should give us a chance to spot them before they
+         * cause real hard-to-debug problems :)
+         */
+        if (WARN_ONCE(skb_tail_pointer(to) < to->data,
+                  "skb inconsistency: tail below data\n"))
+            return false;
+
          BUG_ON(skb_copy_bits(from, 0, skb_put(to, len), len));
          *delta_truesize = 0;
          return true;

