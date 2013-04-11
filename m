Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761621Ab3DKU0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:26:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10923 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab3DKU0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:01 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3cNnKvAJEl4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=gprVKArcU_wA:10 a=zRKbQ67AAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=1Dwx9gnmAe4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202550.471143447@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 026/171 ] sfc: Only use TX push if a single descriptor is to be written
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0026-sfc-Only-use-TX-push-if-a-single-descriptor-is-to-be.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/sfc/nic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
index 326d799..a1c3d80 100644
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -377,7 +377,8 @@ efx_may_push_tx_desc(struct efx_tx_queue *tx_queue, unsigned int write_count)
 		return false;
 
 	tx_queue->empty_read_count = 0;
-	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0;
+	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0
+		&& tx_queue->write_count - write_count == 1;
 }
 
 /* For each entry inserted into the software descriptor ring, create a
-- 
1.7.10.4


