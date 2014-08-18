Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaHRKAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:00:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42637 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaHRJe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Ariel Elior <ariel.elior@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 042/137] bnx2x: fix possible panic under memory stress
Date: Mon, 18 Aug 2014 10:31:43 +0100
Message-Id: <1408354398-10226-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 07b0f00964def8af9321cfd6c4a7e84f6362f728 upstream.

While it is legal to kfree(NULL), it is not wise to use :
put_page(virt_to_head_page(NULL))

 BUG: unable to handle kernel paging request at ffffeba400000000
 IP: [<ffffffffc01f5928>] virt_to_head_page+0x36/0x44 [bnx2x]

Reported-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ariel Elior <ariel.elior@qlogic.com>
Fixes: d46d132cc021 ("bnx2x: use netdev_alloc_frag()")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 6e49403d6ec5..5fedcb6d7ec0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -750,7 +750,8 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 
 		return;
 	}
-	bnx2x_frag_free(fp, new_data);
+	if (new_data)
+		bnx2x_frag_free(fp, new_data);
 drop:
 	/* drop the packet and keep the buffer in the bin */
 	DP(NETIF_MSG_RX_STATUS,
-- 
1.9.1

