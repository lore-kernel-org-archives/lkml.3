Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaL2BMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:12:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33199 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915AbaL2BMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:17 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Vlad Yasevich" <vyasevich@gmail.com>,
        "Daniel Borkmann" <dborkman@redhat.com>,
        "Robert =?UTF-8?Q?=C5=9Awi=C4=99cki?=" <robert@swiecki.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Neil Horman" <nhorman@tuxdriver.com>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.535123160@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 26/27] net: sctp: use MAX_HEADER for headroom reserve
 in output path
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit 9772b54c55266ce80c639a80aa68eeb908f8ecf5 upstream.

To accomodate for enough headroom for tunnels, use MAX_HEADER instead
of LL_MAX_HEADER. Robert reported that he has hit after roughly 40hrs
of trinity an skb_under_panic() via SCTP output path (see reference).
I couldn't reproduce it from here, but not using MAX_HEADER as elsewhere
in other protocols might be one possible cause for this.

In any case, it looks like accounting on chunks themself seems to look
good as the skb already passed the SCTP output path and did not hit
any skb_over_panic(). Given tunneling was enabled in his .config, the
headroom would have been expanded by MAX_HEADER in this case.

Reported-by: Robert Święcki <robert@swiecki.net>
Reference: https://lkml.org/lkml/2014/12/1/507
Fixes: 594ccc14dfe4d ("[SCTP] Replace incorrect use of dev_alloc_skb with alloc_skb in sctp_packet_transmit().")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -384,12 +384,12 @@ int sctp_packet_transmit(struct sctp_pac
 	sk = chunk->skb->sk;
 
 	/* Allocate the new skb.  */
-	nskb = alloc_skb(packet->size + LL_MAX_HEADER, GFP_ATOMIC);
+	nskb = alloc_skb(packet->size + MAX_HEADER, GFP_ATOMIC);
 	if (!nskb)
 		goto nomem;
 
 	/* Make sure the outbound skb has enough header room reserved. */
-	skb_reserve(nskb, packet->overhead + LL_MAX_HEADER);
+	skb_reserve(nskb, packet->overhead + MAX_HEADER);
 
 	/* Set the owning socket so that we know where to get the
 	 * destination IP address.

