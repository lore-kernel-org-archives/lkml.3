Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423066AbaDKQPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:15:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbaDKQJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gilles Chanteperdrix <gilles.chanteperdrix@xenomai.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 17/23] net/at91_ether: avoid NULL pointer dereference
Date: Fri, 11 Apr 2014 09:12:06 -0700
Message-Id: <20140411161202.611355470@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411161200.236939691@linuxfoundation.org>
References: <20140411161200.236939691@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gilles Chanteperdrix <gilles.chanteperdrix@xenomai.org>

[ Upstream commit c293fb785bdda64d88f197e6758a3c16ae83e569 ]

The at91_ether driver calls macb_mii_init passing a 'struct macb'
structure whose tx_clk member is initialized to 0. However,
macb_handle_link_change() expects tx_clk to be the result of
a call to clk_get, and so IS_ERR(tx_clk) to be true if the clock
is invalid. This causes an oops when booting Linux 3.14 on the
csb637 board. The following changes avoids this.

Signed-off-by: Gilles Chanteperdrix <gilles.chanteperdrix@xenomai.org>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/at91_ether.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/cadence/at91_ether.c
+++ b/drivers/net/ethernet/cadence/at91_ether.c
@@ -342,6 +342,9 @@ static int __init at91ether_probe(struct
 	}
 	clk_enable(lp->pclk);
 
+	lp->hclk = ERR_PTR(-ENOENT);
+	lp->tx_clk = ERR_PTR(-ENOENT);
+
 	/* Install the interrupt handler */
 	dev->irq = platform_get_irq(pdev, 0);
 	res = devm_request_irq(&pdev->dev, dev->irq, at91ether_interrupt, 0, dev->name, dev);


