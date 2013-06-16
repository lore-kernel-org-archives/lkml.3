Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab3FPW2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:28:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46334 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708Ab3FPWIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wei Liu" <wei.liu2@citrix.com>,
        "Ian Campbell" <ian.campbell@citrix.com>,
        "David Vrabel" <david.vrabel@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.715409923@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [19/83] xen-netback: don't disconnect frontend when seeing
 oversize packet
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/xen-netback/netback.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -947,12 +947,22 @@ static int netbk_count_requests(struct x
 
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

