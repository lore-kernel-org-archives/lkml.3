Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162128Ab3LFWUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:20:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759247Ab3LFVxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>, Dan Williams <dcbw@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 08/58] usbnet: fix status interrupt urb handling
Date: Fri,  6 Dec 2013 13:51:39 -0800
Message-Id: <20131206214845.677694986@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

[ Upstream commit 52f48d0d9aaa621ffa5e08d79da99a3f8c93b848 ]

Since commit 7b0c5f21f348a66de495868b8df0284e8dfd6bbf
"sierra_net: keep status interrupt URB active", sierra_net triggers
status interrupt polling before the net_device is opened (in order to
properly receive the sync message response).

To be able to receive further interrupts, the interrupt urb needs to be
re-submitted, so this patch removes the bogus check for netif_running().

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Tested-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -206,9 +206,6 @@ static void intr_complete (struct urb *u
 		break;
 	}
 
-	if (!netif_running (dev->net))
-		return;
-
 	status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status != 0)
 		netif_err(dev, timer, dev->net,


