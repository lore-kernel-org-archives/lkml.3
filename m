Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161051Ab3JKU1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:27:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759047Ab3JKTk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Khromov <icechrome@gmail.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 080/110] mwifiex: fix NULL pointer dereference in usb suspend handler
Date: Fri, 11 Oct 2013 12:39:00 -0700
Message-Id: <20131011193816.542926019@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit 346ece0b7ba2730b4d633b9e371fe55488803102 upstream.

Bug 60815 - Interface hangs in mwifiex_usb
https://bugzilla.kernel.org/show_bug.cgi?id=60815

[ 2.883807] BUG: unable to handle kernel NULL pointer dereference
            at 0000000000000048
[ 2.883813] IP: [<ffffffff815a65e0>] pfifo_fast_enqueue+0x90/0x90

[ 2.883834] CPU: 1 PID: 3220 Comm: kworker/u8:90 Not tainted
            3.11.1-monotone-l0 #6
[ 2.883834] Hardware name: Microsoft Corporation Surface with
            Windows 8 Pro/Surface with Windows 8 Pro,
            BIOS 1.03.0450 03/29/2013

On Surface Pro, suspend to ram gives a NULL pointer dereference in
pfifo_fast_enqueue(). The stack trace reveals that the offending
call is clearing carrier in mwifiex_usb suspend handler.

Since commit 1499d9f "mwifiex: don't drop carrier flag over suspend"
has removed the carrier flag handling over suspend/resume in SDIO
and PCIe drivers, I'm removing it in USB driver too. This also fixes
the bug for Surface Pro.

Tested-by: Dmitry Khromov <icechrome@gmail.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/usb.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -446,9 +446,6 @@ static int mwifiex_usb_suspend(struct us
 	 */
 	adapter->is_suspended = true;
 
-	for (i = 0; i < adapter->priv_num; i++)
-		netif_carrier_off(adapter->priv[i]->netdev);
-
 	if (atomic_read(&card->rx_cmd_urb_pending) && card->rx_cmd.urb)
 		usb_kill_urb(card->rx_cmd.urb);
 
@@ -508,10 +505,6 @@ static int mwifiex_usb_resume(struct usb
 						  MWIFIEX_RX_CMD_BUF_SIZE);
 	}
 
-	for (i = 0; i < adapter->priv_num; i++)
-		if (adapter->priv[i]->media_connected)
-			netif_carrier_on(adapter->priv[i]->netdev);
-
 	/* Disable Host Sleep */
 	if (adapter->hs_activated)
 		mwifiex_cancel_hs(mwifiex_get_priv(adapter,


