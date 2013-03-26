Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824Ab3CZPaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:30:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54160 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965415Ab3CZPYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 137/150] sfc: Only use TX push if a single descriptor is to be written
Date: Tue, 26 Mar 2013 15:20:36 +0000
Message-Id: <1364311249-14454-138-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit fae8563b25f73dc584a07bcda7a82750ff4f7672 upstream.

Using TX push when notifying the NIC of multiple new descriptors in
the ring will very occasionally cause the TX DMA engine to re-use an
old descriptor.  This can result in a duplicated or partly duplicated
packet (new headers with old data), or an IOMMU page fault.  This does
not happen when the pushed descriptor is the only one written.

TX push also provides little latency benefit when a packet requires
more than one descriptor.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/nic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
index 76f16b7..578e52a6 100644
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -379,7 +379,8 @@ efx_may_push_tx_desc(struct efx_tx_queue *tx_queue, unsigned int write_count)
 		return false;
 
 	tx_queue->empty_read_count = 0;
-	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0;
+	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0
+		&& tx_queue->write_count - write_count == 1;
 }
 
 /* For each entry inserted into the software descriptor ring, create a
-- 
1.8.1.2

