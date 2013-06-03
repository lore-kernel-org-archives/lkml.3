Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab3FCWON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:14:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13491 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab3FCWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:34 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=8pIs3Js8tOYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Jc7XqB97abgA:10 a=AMTvMMonAAAA:8 a=pGLkceISAAAA:8 a=J1Y8HTJGAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=4DhlTSkJKOQA:10 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221158.846940083@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Matthew Whitehead <tedheadster@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [38/65] 3c59x: fix freeing nonexistent resource on driver unload
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0038-3c59x-fix-freeing-nonexistent-resource-on-driver-unl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/3com/3c59x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index e463d10..ccfc86f 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -951,7 +951,7 @@ static int __devexit vortex_eisa_remove(struct device *device)
 
 	unregister_netdev(dev);
 	iowrite16(TotalReset|0x14, ioaddr + EL3_CMD);
-	release_region(dev->base_addr, VORTEX_TOTAL_SIZE);
+	release_region(edev->base_addr, VORTEX_TOTAL_SIZE);
 
 	free_netdev(dev);
 	return 0;
-- 
1.7.10.4


