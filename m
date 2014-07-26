Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbaGZUHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:07:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaGZTC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:02:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Ariel Elior <ariel.elior@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 23/56] bnx2x: fix possible panic under memory stress
Date: Sat, 26 Jul 2014 12:02:16 -0700
Message-Id: <20140726190200.795896964@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190200.061512159@linuxfoundation.org>
References: <20140726190200.061512159@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -745,7 +745,8 @@ static void bnx2x_tpa_stop(struct bnx2x
 
 		return;
 	}
-	bnx2x_frag_free(fp, new_data);
+	if (new_data)
+		bnx2x_frag_free(fp, new_data);
 drop:
 	/* drop the packet and keep the buffer in the bin */
 	DP(NETIF_MSG_RX_STATUS,


