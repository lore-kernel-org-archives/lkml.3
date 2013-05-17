Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab3EQVwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:52:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545Ab3EQVui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:50:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Galbraith <bitbucket@online.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/33] tcp: force a dst refcount when prequeue packet
Date: Fri, 17 May 2013 14:49:59 -0700
Message-Id: <20130517214918.443301013@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517214916.821259930@linuxfoundation.org>
References: <20130517214916.821259930@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 093162553c33e9479283e107b4431378271c735d ]

Before escaping RCU protected section and adding packet into
prequeue, make sure the dst is refcounted.

Reported-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -902,6 +902,7 @@ static inline int tcp_prequeue(struct so
 	if (sysctl_tcp_low_latency || !tp->ucopy.task)
 		return 0;
 
+	skb_dst_force(skb);
 	__skb_queue_tail(&tp->ucopy.prequeue, skb);
 	tp->ucopy.memory += skb->truesize;
 	if (tp->ucopy.memory > sk->sk_rcvbuf) {


