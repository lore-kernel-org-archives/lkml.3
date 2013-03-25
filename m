Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3CYBYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:24:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34057 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756176Ab3CYBQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:12 -0400
Message-Id: <20130325010529.147569023@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:13 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 049/104] sfc: Only use TX push if a single descriptor is to be  written
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit fae8563b25f73dc584a07bcda7a82750ff4f7672 ]

Using TX push when notifying the NIC of multiple new descriptors in
the ring will very occasionally cause the TX DMA engine to re-use an
old descriptor.  This can result in a duplicated or partly duplicated
packet (new headers with old data), or an IOMMU page fault.  This does
not happen when the pushed descriptor is the only one written.

TX push also provides little latency benefit when a packet requires
more than one descriptor.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/sfc/nic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
index 9cca2a6..2e9ca10 100644
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -371,7 +371,8 @@ efx_may_push_tx_desc(struct efx_tx_queue *tx_queue, unsigned int write_count)
 		return false;
 
 	tx_queue->empty_read_count = 0;
-	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0;
+	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0
+		&& tx_queue->write_count - write_count == 1;
 }
 
 /* For each entry inserted into the software descriptor ring, create a


