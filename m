Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaHESQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:16:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbaHESQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:16:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Arnaud Ebalard <arno@natisbad.org>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 22/27] net: mvneta: do not schedule in mvneta_tx_timeout
Date: Tue,  5 Aug 2014 11:14:14 -0700
Message-Id: <20140805181344.922064408@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181344.268039690@linuxfoundation.org>
References: <20140805181344.268039690@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: willy tarreau <w@1wt.eu>

commit 290213667ab53a95456397763205e4b1e30f46b5 upstream.

If a queue timeout is reported, we can oops because of some
schedules while the caller is atomic, as shown below :

  mvneta d0070000.ethernet eth0: tx timeout
  BUG: scheduling while atomic: bash/1528/0x00000100
  Modules linked in: slhttp_ethdiv(C) [last unloaded: slhttp_ethdiv]
  CPU: 2 PID: 1528 Comm: bash Tainted: G        WC   3.13.0-rc4-mvebu-nf #180
  [<c0011bd9>] (unwind_backtrace+0x1/0x98) from [<c000f1ab>] (show_stack+0xb/0xc)
  [<c000f1ab>] (show_stack+0xb/0xc) from [<c02ad323>] (dump_stack+0x4f/0x64)
  [<c02ad323>] (dump_stack+0x4f/0x64) from [<c02abe67>] (__schedule_bug+0x37/0x4c)
  [<c02abe67>] (__schedule_bug+0x37/0x4c) from [<c02ae261>] (__schedule+0x325/0x3ec)
  [<c02ae261>] (__schedule+0x325/0x3ec) from [<c02adb97>] (schedule_timeout+0xb7/0x118)
  [<c02adb97>] (schedule_timeout+0xb7/0x118) from [<c0020a67>] (msleep+0xf/0x14)
  [<c0020a67>] (msleep+0xf/0x14) from [<c01dcbe5>] (mvneta_stop_dev+0x21/0x194)
  [<c01dcbe5>] (mvneta_stop_dev+0x21/0x194) from [<c01dcfe9>] (mvneta_tx_timeout+0x19/0x24)
  [<c01dcfe9>] (mvneta_tx_timeout+0x19/0x24) from [<c024afc7>] (dev_watchdog+0x18b/0x1c4)
  [<c024afc7>] (dev_watchdog+0x18b/0x1c4) from [<c0020b53>] (call_timer_fn.isra.27+0x17/0x5c)
  [<c0020b53>] (call_timer_fn.isra.27+0x17/0x5c) from [<c0020cad>] (run_timer_softirq+0x115/0x170)
  [<c0020cad>] (run_timer_softirq+0x115/0x170) from [<c001ccb9>] (__do_softirq+0xbd/0x1a8)
  [<c001ccb9>] (__do_softirq+0xbd/0x1a8) from [<c001cfad>] (irq_exit+0x61/0x98)
  [<c001cfad>] (irq_exit+0x61/0x98) from [<c000d4bf>] (handle_IRQ+0x27/0x60)
  [<c000d4bf>] (handle_IRQ+0x27/0x60) from [<c000843b>] (armada_370_xp_handle_irq+0x33/0xc8)
  [<c000843b>] (armada_370_xp_handle_irq+0x33/0xc8) from [<c000fba9>] (__irq_usr+0x49/0x60)

Ben Hutchings attempted to propose a better fix consisting in using a
scheduled work for this, but while it fixed this panic, it caused other
random freezes and panics proving that the reset sequence in the driver
is unreliable and that additional fixes should be investigated.

When sending multiple streams over a link limited to 100 Mbps, Tx timeouts
happen from time to time, and the driver correctly recovers only when the
function is disabled.

Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Tested-by: Arnaud Ebalard <arno@natisbad.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/marvell/mvneta.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2207,16 +2207,6 @@ static void mvneta_stop_dev(struct mvnet
 	mvneta_rx_reset(pp);
 }
 
-/* tx timeout callback - display a message and stop/start the network device */
-static void mvneta_tx_timeout(struct net_device *dev)
-{
-	struct mvneta_port *pp = netdev_priv(dev);
-
-	netdev_info(dev, "tx timeout\n");
-	mvneta_stop_dev(pp);
-	mvneta_start_dev(pp);
-}
-
 /* Return positive if MTU is valid */
 static int mvneta_check_mtu_valid(struct net_device *dev, int mtu)
 {
@@ -2567,7 +2557,6 @@ static const struct net_device_ops mvnet
 	.ndo_set_rx_mode     = mvneta_set_rx_mode,
 	.ndo_set_mac_address = mvneta_set_mac_addr,
 	.ndo_change_mtu      = mvneta_change_mtu,
-	.ndo_tx_timeout      = mvneta_tx_timeout,
 	.ndo_get_stats64     = mvneta_get_stats64,
 };
 


