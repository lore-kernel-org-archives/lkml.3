Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3COHvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 03:51:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab3COHvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 03:51:02 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mst@redhat.com, Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 1/2] net_sched: don't do precise pkt_len computation for untrusted packets
Date: Fri, 15 Mar 2013 15:41:44 +0800
Message-Id: <1363333305-54398-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1def9238d4aa2 (net_sched: more precise pkt_len computation) tries to do
precise packet len computation for GSO packets, but it does not check whether
the packets were from untrusted source. This is wrong since: we haven't done
header check before so both gso_segs and headers may not be correct. So this
patch just bypass the precise pkt_len computation for packet from untrusted
source (SKB_GSO_DODGY).

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 net/core/dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 90cee5b..480114d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2586,7 +2586,7 @@ static void qdisc_pkt_len_init(struct sk_buff *skb)
 	/* To get more precise estimation of bytes sent on wire,
 	 * we add to pkt_len the headers size of all segments
 	 */
-	if (shinfo->gso_size)  {
+	if (shinfo->gso_size && !(shinfo->gso_type & SKB_GSO_DODGY))  {
 		unsigned int hdr_len;
 
 		/* mac layer + network layer */
-- 
1.7.1

