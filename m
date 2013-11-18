Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3KRSwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:52:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3KRSld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:41:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 01/12] cxgb3: Fix length calculation in write_ofld_wr() on 32-bit architectures
Date: Mon, 18 Nov 2013 10:41:34 -0800
Message-Id: <20131118184130.528352245@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184130.257996039@linuxfoundation.org>
References: <20131118184130.257996039@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit 262e827fe745642589450ae241b7afd3912c3f25 ]

The length calculation here is now invalid on 32-bit architectures,
since sk_buff::tail is a pointer and sk_buff::transport_header is
an integer offset:

drivers/net/ethernet/chelsio/cxgb3/sge.c: In function 'write_ofld_wr':
drivers/net/ethernet/chelsio/cxgb3/sge.c:1603:9: warning: passing argument 4 of 'make_sgl' makes integer from pointer without a cast [enabled by default]
         adap->pdev);
         ^
drivers/net/ethernet/chelsio/cxgb3/sge.c:964:28: note: expected 'unsigned int' but argument is of type 'sk_buff_data_t'
 static inline unsigned int make_sgl(const struct sk_buff *skb,
                            ^

Use the appropriate skb accessor functions.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 1a37e412a022 ('net: Use 16bits for *_headers fields of struct skbuff')
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb3/sge.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -1600,7 +1600,8 @@ static void write_ofld_wr(struct adapter
 	flits = skb_transport_offset(skb) / 8;
 	sgp = ndesc == 1 ? (struct sg_ent *)&d->flit[flits] : sgl;
 	sgl_flits = make_sgl(skb, sgp, skb_transport_header(skb),
-			     skb->tail - skb->transport_header,
+			     skb_tail_pointer(skb) -
+			     skb_transport_header(skb),
 			     adap->pdev);
 	if (need_skb_unmap()) {
 		setup_deferred_unmapping(skb, adap->pdev, sgp, sgl_flits);


