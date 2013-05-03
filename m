Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934447Ab3ECVjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:39:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219Ab3ECViU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:38:20 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=E8D8DvpgkSYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bNx0k-PIzlQA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=49v6Z1639WieMjv4iLAA:9 a=UTB_XpHje0EA:10 a=9J5VuaLb3qoA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130503213817.778015700@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 03 May 2013 17:37:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>,
        Mike Galbraith <bitbucket@online.de>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH RT 1/5] tcp: force a dst refcount when prequeue packet
References: <20130503213703.521223574@goodmis.org>
Content-Disposition: inline; filename=0001-tcp-force-a-dst-refcount-when-prequeue-packet.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Before escaping RCU protected section and adding packet into
prequeue, make sure the dst is refcounted.

Cc: stable-rt@vger.kernel.org
Reported-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/net/tcp.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1f000ff..9297897 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1015,6 +1015,7 @@ static inline bool tcp_prequeue(struct sock *sk, struct sk_buff *skb)
 	if (sysctl_tcp_low_latency || !tp->ucopy.task)
 		return false;
 
+	skb_dst_force(skb);
 	__skb_queue_tail(&tp->ucopy.prequeue, skb);
 	tp->ucopy.memory += skb->truesize;
 	if (tp->ucopy.memory > sk->sk_rcvbuf) {
-- 
1.7.10.4


