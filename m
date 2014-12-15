Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaLOTc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:32:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40930 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaLOTcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:32:54 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 95/96] net: sctp: use MAX_HEADER for headroom reserve in output path
Date: Mon, 15 Dec 2014 11:26:55 -0800
Message-Id: <1418671616-25482-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sctp/output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index e867326..777dba7 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -402,12 +402,12 @@ int sctp_packet_transmit(struct sctp_packet *packet)
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
1.9.1

