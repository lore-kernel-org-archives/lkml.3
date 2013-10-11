Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab3JKUSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:18:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab3JKTkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 006/135] sh_eth: fix napi_{en|dis}able() calls racing against interrupts
Date: Fri, 11 Oct 2013 12:38:07 -0700
Message-Id: <20131011193945.890804488@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[ Upstream commit d2779e99468fd83ef1493c34f3803fec9aad8345 ]

While implementing NAPI for the driver, I overlooked the race conditions where
interrupt  handler might have called napi_schedule_prep() before napi_enable()
was called or after napi_disable() was called. If RX interrupt happens, this
would cause the endless interrupts and messages like:

sh-eth eth0: ignoring interrupt, status 0x00040000, mask 0x01ff009f.

The interrupt wouldn't even be masked by the kernel eventually since the handler
would return IRQ_HANDLED all the time.

As a fix, move napi_enable() call before request_irq() call and napi_disable()
call after free_irq() call.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/sh_eth.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1857,11 +1857,13 @@ static int sh_eth_open(struct net_device
 
 	pm_runtime_get_sync(&mdp->pdev->dev);
 
+	napi_enable(&mdp->napi);
+
 	ret = request_irq(ndev->irq, sh_eth_interrupt,
 			  mdp->cd->irq_flags, ndev->name, ndev);
 	if (ret) {
 		dev_err(&ndev->dev, "Can not assign IRQ number\n");
-		return ret;
+		goto out_napi_off;
 	}
 
 	/* Descriptor set */
@@ -1879,12 +1881,12 @@ static int sh_eth_open(struct net_device
 	if (ret)
 		goto out_free_irq;
 
-	napi_enable(&mdp->napi);
-
 	return ret;
 
 out_free_irq:
 	free_irq(ndev->irq, ndev);
+out_napi_off:
+	napi_disable(&mdp->napi);
 	pm_runtime_put_sync(&mdp->pdev->dev);
 	return ret;
 }
@@ -1976,8 +1978,6 @@ static int sh_eth_close(struct net_devic
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
 
-	napi_disable(&mdp->napi);
-
 	netif_stop_queue(ndev);
 
 	/* Disable interrupts by clearing the interrupt mask. */
@@ -1995,6 +1995,8 @@ static int sh_eth_close(struct net_devic
 
 	free_irq(ndev->irq, ndev);
 
+	napi_disable(&mdp->napi);
+
 	/* Free all the skbuffs in the Rx queue. */
 	sh_eth_ring_free(ndev);
 


