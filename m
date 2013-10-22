Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3JVPLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:11:16 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:64922 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3JVPLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:11:11 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the ipsec-next tere
Date: Tue, 22 Oct 2013 17:08:36 +0200
Message-Id: <1382454517-4074-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382454517-4074-1-git-send-email-treding@nvidia.com>
References: <1382454517-4074-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the ipsec-next tree got a conflict in

	net/xfrm/xfrm_policy.c

caused by commits e7d8f6c (xfrm: Add refcount handling to queued policies)
and 4d53eff (xfrm: Don't queue retransmitted packets if the original is
still on the host).

I fixed it up (see below). Please verify that the resolution looks good.

Thanks,
Thierry
---
diff --cc net/xfrm/xfrm_policy.c
index 76e1873,e09edfc..9a91f74
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@@ -1842,8 -1831,14 +1842,15 @@@ static int xdst_queue_output(struct sk_
  	unsigned long sched_next;
  	struct dst_entry *dst = skb_dst(skb);
  	struct xfrm_dst *xdst = (struct xfrm_dst *) dst;
 -	struct xfrm_policy_queue *pq = &xdst->pols[0]->polq;
 +	struct xfrm_policy *pol = xdst->pols[0];
 +	struct xfrm_policy_queue *pq = &pol->polq;
+ 	const struct sk_buff *fclone = skb + 1;
+ 
+ 	if (unlikely(skb->fclone == SKB_FCLONE_ORIG &&
+ 		     fclone->fclone == SKB_FCLONE_CLONE)) {
+ 		kfree_skb(skb);
+ 		return 0;
+ 	}
  
  	if (pq->hold_queue.qlen > XFRM_MAX_QUEUE_LEN) {
  		kfree_skb(skb);
