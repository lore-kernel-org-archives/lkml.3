Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3KAWEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:04:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3KAWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Sterrett <michael@sterretts.net>,
        Dormando <dormando@rydia.net>, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 05/54] tcp: fix incorrect ca_state in tail loss probe
Date: Fri,  1 Nov 2013 15:03:33 -0700
Message-Id: <20131101220211.925876445@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 031afe4990a7c9dbff41a3a742c44d3e740ea0a1 ]

On receiving an ACK that covers the loss probe sequence, TLP
immediately sets the congestion state to Open, even though some packets
are not recovered and retransmisssion are on the way.  The later ACks
may trigger a WARN_ON check in step D of tcp_fastretrans_alert(), e.g.,
https://bugzilla.redhat.com/show_bug.cgi?id=989251

The fix is to follow the similar procedure in recovery by calling
tcp_try_keep_open(). The sender switches to Open state if no packets
are retransmissted. Otherwise it goes to Disorder and let subsequent
ACKs move the state to Recovery or Open.

Reported-By: Michael Sterrett <michael@sterretts.net>
Tested-By: Dormando <dormando@rydia.net>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3345,7 +3345,7 @@ static void tcp_process_tlp_ack(struct s
 			tcp_init_cwnd_reduction(sk, true);
 			tcp_set_ca_state(sk, TCP_CA_CWR);
 			tcp_end_cwnd_reduction(sk);
-			tcp_set_ca_state(sk, TCP_CA_Open);
+			tcp_try_keep_open(sk);
 			NET_INC_STATS_BH(sock_net(sk),
 					 LINUX_MIB_TCPLOSSPROBERECOVERY);
 		}


