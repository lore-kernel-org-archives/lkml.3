Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3KAWE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:04:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab3KAWE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sathya Perla <sathya.perla@emulex.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 32/54] be2net: pass if_id for v1 and V2 versions of TX_CREATE cmd
Date: Fri,  1 Nov 2013 15:04:00 -0700
Message-Id: <20131101220214.915743478@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasundhara Volam <vasundhara.volam@emulex.com>

[ Upstream commit 0fb88d61bc60779dde88b0fc268da17eb81d0412 ]

It is a required field for all TX_CREATE cmd versions > 0.
This fixes a driver initialization failure, caused by recent SH-R Firmwares
(versions > 10.0.639.0) failing the TX_CREATE cmd when if_id field is
not passed.

Signed-off-by: Sathya Perla <sathya.perla@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -1150,7 +1150,6 @@ int be_cmd_txq_create(struct be_adapter
 
 	if (lancer_chip(adapter)) {
 		req->hdr.version = 1;
-		req->if_id = cpu_to_le16(adapter->if_handle);
 	} else if (BEx_chip(adapter)) {
 		if (adapter->function_caps & BE_FUNCTION_CAPS_SUPER_NIC)
 			req->hdr.version = 2;
@@ -1158,6 +1157,8 @@ int be_cmd_txq_create(struct be_adapter
 		req->hdr.version = 2;
 	}
 
+	if (req->hdr.version > 0)
+		req->if_id = cpu_to_le16(adapter->if_handle);
 	req->num_pages = PAGES_4K_SPANNED(q_mem->va, q_mem->size);
 	req->ulp_num = BE_ULP1_NUM;
 	req->type = BE_ETH_TX_RING_TYPE_STANDARD;


