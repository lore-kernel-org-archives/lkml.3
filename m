Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3H0IYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:24:04 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:9398 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab3H0IYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:24:02 -0400
From: Andrey Vagin <avagin@openvz.org>
To: netdev@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Andrew Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH] tcp: initialize rcv_tstamp for restored sockets
Date: Tue, 27 Aug 2013 12:20:40 +0400
Message-Id: <1377591640-1660-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vagin <avagin@openvz.org>

u32 rcv_tstamp;     /* timestamp of last received ACK */

Its value used in tcp_retransmit_timer, which closes socket
if the last ack was received more then TCP_RTO_MAX ago.

Currently rcv_tstamp is initialized to zero and if tcp_retransmit_timer
is called before receiving a first ack, the connection is closed.

This patch initializes rcv_tstamp to a timestamp, when a socket was
restored.

Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 net/ipv4/tcp_output.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 92fde8d..e297299 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2814,6 +2814,8 @@ void tcp_connect_init(struct sock *sk)
 
 	if (likely(!tp->repair))
 		tp->rcv_nxt = 0;
+	else
+		tp->rcv_tstamp = tcp_time_stamp;
 	tp->rcv_wup = tp->rcv_nxt;
 	tp->copied_seq = tp->rcv_nxt;
 
-- 
1.8.3.1

