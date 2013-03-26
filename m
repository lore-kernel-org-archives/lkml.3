Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab3CZXJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:09:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3CZXCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:02:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 20/49] sfc: Only use TX push if a single descriptor is to be written
Date: Tue, 26 Mar 2013 16:01:17 -0700
Message-Id: <20130326225841.642445977@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326225839.554028294@linuxfoundation.org>
References: <20130326225839.554028294@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/sfc/nic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/sfc/nic.c
+++ b/drivers/net/sfc/nic.c
@@ -370,7 +370,8 @@ efx_may_push_tx_desc(struct efx_tx_queue
 		return false;
 
 	tx_queue->empty_read_count = 0;
-	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0;
+	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0
+		&& tx_queue->write_count - write_count == 1;
 }
 
 /* For each entry inserted into the software descriptor ring, create a


