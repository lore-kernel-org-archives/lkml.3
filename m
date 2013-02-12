Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab3BLU5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:57:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab3BLUgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 52/61] tcp: detect SYN/data drop when F-RTO is disabled
Date: Tue, 12 Feb 2013 12:35:12 -0800
Message-Id: <20130212203424.908443393@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 66555e92fb7a619188c02cceae4bbc414f15f96d ]

On receiving the SYN-ACK, Fast Open checks icsk_retransmit for SYN
retransmission to detect SYN/data drops. But if F-RTO is disabled,
icsk_retransmit is reset at step D of tcp_fastretrans_alert() (
under tcp_ack()) before tcp_rcv_fastopen_synack(). The fix is to use
total_retrans instead which accounts for SYN retransmission regardless
the use of F-RTO.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5639,8 +5639,7 @@ static bool tcp_rcv_fastopen_synack(stru
 	 * the remote receives only the retransmitted (regular) SYNs: either
 	 * the original SYN-data or the corresponding SYN-ACK is lost.
 	 */
-	syn_drop = (cookie->len <= 0 && data &&
-		    inet_csk(sk)->icsk_retransmits);
+	syn_drop = (cookie->len <= 0 && data && tp->total_retrans);
 
 	tcp_fastopen_cache_set(sk, mss, cookie, syn_drop);
 


