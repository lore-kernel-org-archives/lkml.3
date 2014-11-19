Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbaKSU4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:56:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724AbaKSUyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 113/141] net: systemport: reset UniMAC coming out of a suspend cycle
Date: Wed, 19 Nov 2014 12:52:16 -0800
Message-Id: <20141119205154.331577617@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <f.fainelli@gmail.com>

commit 704d33e7006f20f9b4fa7d24a0f08c4b5919b131 upstream.

bcm_sysport_resume() was missing an UniMAC reset which can lead to
various receive FIFO corruptions coming out of a suspend cycle. If the
RX FIFO is stuck, it will deliver corrupted/duplicate packets towards
the host CPU interface.

This could be reproduced on crowded network and when Wake-on-LAN is
enabled for this particular interface because the switch still forwards
packets towards the host CPU interface (SYSTEMPORT), and we had to leave
the UniMAC RX enable bit on to allow matching MagicPackets.

Once we re-enter the resume function, there is a small window during
which the UniMAC receive is still enabled, and we start queueing
packets, but the RDMA and RBUF engines are not ready, which leads to
having packets stuck in the UniMAC RX FIFO, ultimately delivered towards
the host CPU as corrupted.

Fixes: 40755a0fce17 ("net: systemport: add suspend and resume support")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/bcmsysport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1845,6 +1845,8 @@ static int bcm_sysport_resume(struct dev
 	if (!netif_running(dev))
 		return 0;
 
+	umac_reset(priv);
+
 	/* We may have been suspended and never received a WOL event that
 	 * would turn off MPD detection, take care of that now
 	 */


