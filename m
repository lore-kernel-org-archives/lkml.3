Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3JUIuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:50:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39258 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752928Ab3JUIuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Yuchung Cheng" <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Neal Cardwell" <ncardwell@google.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.328121826@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 005/149] tcp: cubic: fix bug in bictcp_acked()
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cd6b423afd3c08b27e1fed52db828ade0addbc6b ]

While investigating about strange increase of retransmit rates
on hosts ~24 days after boot, Van found hystart was disabled
if ca->epoch_start was 0, as following condition is true
when tcp_time_stamp high order bit is set.

(s32)(tcp_time_stamp - ca->epoch_start) < HZ

Quoting Van :

 At initialization & after every loss ca->epoch_start is set to zero so
 I believe that the above line will turn off hystart as soon as the 2^31
 bit is set in tcp_time_stamp & hystart will stay off for 24 days.
 I think we've observed that cubic's restart is too aggressive without
 hystart so this might account for the higher drop rate we observe.

Diagnosed-by: Van Jacobson <vanj@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_cubic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index b9d22e6..b78eac2 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -414,7 +414,7 @@ static void bictcp_acked(struct sock *sk, u32 cnt, s32 rtt_us)
 		return;
 
 	/* Discard delay samples right after fast recovery */
-	if ((s32)(tcp_time_stamp - ca->epoch_start) < HZ)
+	if (ca->epoch_start && (s32)(tcp_time_stamp - ca->epoch_start) < HZ)
 		return;
 
 	delay = (rtt_us << 3) / USEC_PER_MSEC;

