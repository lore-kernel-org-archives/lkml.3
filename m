Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab3ILR70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:59:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab3ILR7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Andrey Vagin <avagin@openvz.org>
Subject: [ 29/46] tcp: initialize rcv_tstamp for restored sockets
Date: Thu, 12 Sep 2013 10:58:40 -0700
Message-Id: <20130912175724.164293343@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Vagin <avagin@openvz.org>

[ Upstream commit c7781a6e3c4a9a17e144ec2db00ebfea327bd627 ]

u32 rcv_tstamp;     /* timestamp of last received ACK */

Its value used in tcp_retransmit_timer, which closes socket
if the last ack was received more then TCP_RTO_MAX ago.

Currently rcv_tstamp is initialized to zero and if tcp_retransmit_timer
is called before receiving a first ack, the connection is closed.

This patch initializes rcv_tstamp to a timestamp, when a socket was
restored.

Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2808,6 +2808,8 @@ void tcp_connect_init(struct sock *sk)
 
 	if (likely(!tp->repair))
 		tp->rcv_nxt = 0;
+	else
+		tp->rcv_tstamp = tcp_time_stamp;
 	tp->rcv_wup = tp->rcv_nxt;
 	tp->copied_seq = tp->rcv_nxt;
 


