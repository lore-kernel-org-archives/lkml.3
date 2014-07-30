Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaG3M0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:26:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36768 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbaG3MPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Ariel Elior <ariel.elior@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 40/94] bnx2x: fix possible panic under memory stress
Date: Wed, 30 Jul 2014 14:14:29 +0200
Message-Id: <7ec8d47ae13d5bdb1703767f3c2366efa6e2b6eb.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 07b0f00964def8af9321cfd6c4a7e84f6362f728 ]

While it is legal to kfree(NULL), it is not wise to use :
put_page(virt_to_head_page(NULL))

 BUG: unable to handle kernel paging request at ffffeba400000000
 IP: [<ffffffffc01f5928>] virt_to_head_page+0x36/0x44 [bnx2x]

Reported-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ariel Elior <ariel.elior@qlogic.com>
Fixes: d46d132cc021 ("bnx2x: use netdev_alloc_frag()")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 0399458e6d44..9846d3e712a1 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -755,7 +755,8 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 
 		return;
 	}
-	bnx2x_frag_free(fp, new_data);
+	if (new_data)
+		bnx2x_frag_free(fp, new_data);
 drop:
 	/* drop the packet and keep the buffer in the bin */
 	DP(NETIF_MSG_RX_STATUS,
-- 
2.0.1

