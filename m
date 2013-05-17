Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab3EQWFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:05:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab3EQVrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Galbraith <bitbucket@online.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 25/50] tcp: force a dst refcount when prequeue packet
Date: Fri, 17 May 2013 14:47:00 -0700
Message-Id: <20130517213845.356641637@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -948,6 +948,7 @@ static inline int tcp_prequeue(struct so
 	if (sysctl_tcp_low_latency || !tp->ucopy.task)
 		return 0;
 
+	skb_dst_force(skb);
 	__skb_queue_tail(&tp->ucopy.prequeue, skb);
 	tp->ucopy.memory += skb->truesize;
 	if (tp->ucopy.memory > sk->sk_rcvbuf) {


