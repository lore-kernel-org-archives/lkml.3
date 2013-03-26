Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab3CZRgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:36:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24362 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab3CZRg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:29 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=XBhaZMGibnQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bQCkKF7CcJIA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=M134W-xR1wmq5cjLeTUA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173611.197001366@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yuchung Cheng <ycheng@google.com>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 71/86] tcp: detect SYN/data drop when F-RTO is disabled
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0071-tcp-detect-SYN-data-drop-when-F-RTO-is-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 9d475971466bf0e4c65a88d46031b8127a767897 ]

On receiving the SYN-ACK, Fast Open checks icsk_retransmit for SYN
retransmission to detect SYN/data drops. But if F-RTO is disabled,
icsk_retransmit is reset at step D of tcp_fastretrans_alert() (
under tcp_ack()) before tcp_rcv_fastopen_synack(). The fix is to use
total_retrans instead which accounts for SYN retransmission regardless
the use of F-RTO.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp_input.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 41073d2..396c6ae 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5678,8 +5678,7 @@ static bool tcp_rcv_fastopen_synack(struct sock *sk, struct sk_buff *synack,
 	 * the remote receives only the retransmitted (regular) SYNs: either
 	 * the original SYN-data or the corresponding SYN-ACK is lost.
 	 */
-	syn_drop = (cookie->len <= 0 && data &&
-		    inet_csk(sk)->icsk_retransmits);
+	syn_drop = (cookie->len <= 0 && data && tp->total_retrans);
 
 	tcp_fastopen_cache_set(sk, mss, cookie, syn_drop);
 
-- 
1.7.10.4


