Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab3JJP65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:58:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52951 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab3JJPtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Andrey Vagin <avagin@openvz.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 019/104] tcp: initialize rcv_tstamp for restored sockets
Date: Thu, 10 Oct 2013 08:41:07 -0700
Message-Id: <1381419752-29733-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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

Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/tcp_output.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 18b6e16..0bdd879 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2884,6 +2884,8 @@ void tcp_connect_init(struct sock *sk)
 
 	if (likely(!tp->repair))
 		tp->rcv_nxt = 0;
+	else
+		tp->rcv_tstamp = tcp_time_stamp;
 	tp->rcv_wup = tp->rcv_nxt;
 	tp->copied_seq = tp->rcv_nxt;
 
-- 
1.8.1.2

