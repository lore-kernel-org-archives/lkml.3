Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338Ab3GCSni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:43:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19740 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312Ab3GCSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:12 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=-uxZdwyhwGYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=rzdBI_ahBggA:10 a=tHz9FfFoAAAA:8 a=J1Y8HTJGAAAA:8 a=shfSlcufsUQO_5ujM3gA:9 a=6O0IECtVFhoA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=uXlexnhggweefldZ:21 a=Lku378iiqYe7xXGe:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184054.761012395@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Vrabel <david.vrabel@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [061/141] xen-netback: dont disconnect frontend when seeing oversize packet
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0061-xen-netback-don-t-disconnect-frontend-when-seeing-ov.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

[ Upstream commit 03393fd5cc2b6cdeec32b704ecba64dbb0feae3c ]

Some frontend drivers are sending packets > 64 KiB in length. This length
overflows the length field in the first slot making the following slots have
an invalid length.

Turn this error back into a non-fatal error by dropping the packet. To avoid
having the following slots having fatal errors, consume all slots in the
packet.

This does not reopen the security hole in XSA-39 as if the packet as an
invalid number of slots it will still hit fatal error case.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/xen-netback/netback.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index d5a4e74..89dd960 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -946,12 +946,22 @@ static int netbk_count_requests(struct xenvif *vif,
 
 		memcpy(txp, RING_GET_REQUEST(&vif->tx, cons + slots),
 		       sizeof(*txp));
-		if (txp->size > first->size) {
-			netdev_err(vif->dev,
-				   "Invalid tx request, slot size %u > remaining size %u\n",
-				   txp->size, first->size);
-			netbk_fatal_tx_err(vif);
-			return -EIO;
+
+		/* If the guest submitted a frame >= 64 KiB then
+		 * first->size overflowed and following slots will
+		 * appear to be larger than the frame.
+		 *
+		 * This cannot be fatal error as there are buggy
+		 * frontends that do this.
+		 *
+		 * Consume all slots and drop the packet.
+		 */
+		if (!drop_err && txp->size > first->size) {
+			if (net_ratelimit())
+				netdev_dbg(vif->dev,
+					   "Invalid tx request, slot size %u > remaining size %u\n",
+					   txp->size, first->size);
+			drop_err = -EIO;
 		}
 
 		first->size -= txp->size;
-- 
1.7.10.4


