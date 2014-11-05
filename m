Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaKEAjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 19:39:12 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39647 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbaKEAjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 19:39:10 -0500
From: Calvin Owens <calvinowens@fb.com>
To: Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Wensong Zhang <wensong@linux-vs.org>
CC: <lvs-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <agartrell@fb.com>, <kernel-team@fb.com>,
        Calvin Owens <calvinowens@fb.com>
Subject: [PATCH] ipvs: Keep skb->sk when allocating headroom on tunnel xmit
Date: Tue, 4 Nov 2014 16:37:40 -0800
Message-ID: <1415147860-11389-1-git-send-email-calvinowens@fb.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-05_01:2014-11-04,2014-11-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.925924926977281 urlsuspect_oldscore=0.925924926977281
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.925924926977281 spamscore=0
 recipient_to_sender_domain_totalscore=1 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411050005
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ip_vs_prepare_tunneled_skb() ignores ->sk when allocating a new
skb, either unconditionally setting ->sk to NULL or allowing
the uninitialized ->sk from a newly allocated skb to leak through
to the caller.

This patch properly copies ->sk and increments its reference count.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 437a366..bd90bf8 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -846,6 +846,8 @@ ip_vs_prepare_tunneled_skb(struct sk_buff *skb, int skb_af,
 		new_skb = skb_realloc_headroom(skb, max_headroom);
 		if (!new_skb)
 			goto error;
+		if (skb->sk)
+			skb_set_owner_w(new_skb, skb->sk);
 		consume_skb(skb);
 		skb = new_skb;
 	}
-- 
2.1.1

