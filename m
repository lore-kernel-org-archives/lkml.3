Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3KRSlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:41:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3KRShc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:37:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 09/19] tcp: only take RTT from timestamps if new data is acked
Date: Mon, 18 Nov 2013 10:37:22 -0800
Message-Id: <20131118183646.672614767@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118183644.030738675@linuxfoundation.org>
References: <20131118183644.030738675@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 2909d874f34eae157aecab0af27c6dc4a1751f8f ]

Patch ed08495c3 "tcp: use RTT from SACK for RTO" has a bug that
it does not check if the ACK acknowledge new data before taking
the RTT sample from TCP timestamps. This patch adds the check
back as required by the RFC.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2856,7 +2856,8 @@ static inline bool tcp_ack_update_rtt(st
 	 * left edge of the send window.
 	 * See draft-ietf-tcplw-high-performance-00, section 3.3.
 	 */
-	if (seq_rtt < 0 && tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr)
+	if (seq_rtt < 0 && tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
+	    flag & FLAG_ACKED)
 		seq_rtt = tcp_time_stamp - tp->rx_opt.rcv_tsecr;
 
 	if (seq_rtt < 0)


