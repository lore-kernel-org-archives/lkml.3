Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbbAIKxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:53:16 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44532 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757406AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 09/78] net: sctp: use MAX_HEADER for headroom reserve in output path
Date: Fri,  9 Jan 2015 11:31:18 +0100
Message-Id: <72237d47c78ab849c55c6cc0211315db1f1f324b.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 9772b54c55266ce80c639a80aa68eeb908f8ecf5 ]

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/sctp/output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 2a41465729ab..69faf79a48c6 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -403,12 +403,12 @@ int sctp_packet_transmit(struct sctp_packet *packet)
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
-- 
2.2.1

