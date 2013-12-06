Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083Ab3LFXzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:55:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48335 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758973Ab3LFXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:33 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 003/152] cxgb3: Fix length calculation in write_ofld_wr() on 32-bit architectures
Date: Fri,  6 Dec 2013 15:08:47 -0800
Message-Id: <1386371476-2477-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/chelsio/cxgb3/sge.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index dd901c5..ecae9bc 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -1600,7 +1600,8 @@ static void write_ofld_wr(struct adapter *adap, struct sk_buff *skb,
 	flits = skb_transport_offset(skb) / 8;
 	sgp = ndesc == 1 ? (struct sg_ent *)&d->flit[flits] : sgl;
 	sgl_flits = make_sgl(skb, sgp, skb_transport_header(skb),
-			     skb->tail - skb->transport_header,
+			     skb_tail_pointer(skb) -
+			     skb_transport_header(skb),
 			     adap->pdev);
 	if (need_skb_unmap()) {
 		setup_deferred_unmapping(skb, adap->pdev, sgp, sgl_flits);
-- 
1.8.3.2

