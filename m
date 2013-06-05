Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab3FEVj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:39:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933066Ab3FEVgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 121/127] xen-netback: dont disconnect frontend when seeing oversize packet
Date: Wed,  5 Jun 2013 14:34:48 -0700
Message-Id: <20130605213231.731991750@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

commit 03393fd5cc2b6cdeec32b704ecba64dbb0feae3c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/xen-netback/netback.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -975,12 +975,22 @@ static int netbk_count_requests(struct x
 
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


