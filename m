Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab3E1Dz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52532 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758873Ab3E1DyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:18 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Sergei Shtylyov" <sergei.shtylyov@cogentembedded.com>,
        "Matthew Whitehead" <tedheadster@gmail.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.934315728@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [85/94] 3c59x: fix freeing nonexistent resource on driver  unload
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[ Upstream commit c81400be716aa4c76f6ebf339ba94358dbbf6da6 ]

When unloading the driver that drives an EISA board, a message similar to the
following one is displayed:

Trying to free nonexistent resource <0000000000013000-000000000001301f>

Then an user is unable to reload the driver because the resource it requested in
the previous load hasn't been freed. This happens most probably due to a typo in
vortex_eisa_remove() which calls release_region() with 'dev->base_addr'  instead
of 'edev->base_addr'...

Reported-by: Matthew Whitehead <tedheadster@gmail.com>
Tested-by: Matthew Whitehead <tedheadster@gmail.com>
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/3com/3c59x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index e0c5529..d1a6dbb 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -951,7 +951,7 @@ static int __devexit vortex_eisa_remove(struct device *device)
 
 	unregister_netdev(dev);
 	iowrite16(TotalReset|0x14, ioaddr + EL3_CMD);
-	release_region(dev->base_addr, VORTEX_TOTAL_SIZE);
+	release_region(edev->base_addr, VORTEX_TOTAL_SIZE);
 
 	free_netdev(dev);
 	return 0;

