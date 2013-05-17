Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab3EQWL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:11:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166Ab3EQVhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Whitehead <tedheadster@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 068/102] 3c59x: fix freeing nonexistent resource on driver unload
Date: Fri, 17 May 2013 14:36:23 -0700
Message-Id: <20130517213251.514644043@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/3com/3c59x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -951,7 +951,7 @@ static int vortex_eisa_remove(struct dev
 
 	unregister_netdev(dev);
 	iowrite16(TotalReset|0x14, ioaddr + EL3_CMD);
-	release_region(dev->base_addr, VORTEX_TOTAL_SIZE);
+	release_region(edev->base_addr, VORTEX_TOTAL_SIZE);
 
 	free_netdev(dev);
 	return 0;


