Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaDRLqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 07:46:25 -0400
Received: from www.meduna.org ([92.240.244.38]:35286 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbaDRLqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 07:46:17 -0400
Message-ID: <53511079.2020206@meduna.org>
Date: Fri, 18 Apr 2014 13:46:01 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: fabio.estevam@freescale.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, jim_baxter@mentor.com,
        B38611@freescale.com, Frank.Li@freescale.com, netdev@vger.kernel.org
Subject: Freescale FEC i.MX28 restart problem
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-04-18 13:46:07
X-Connected-IP: 95.105.163.217:44640
X-Message-Linecount: 136
X-Body-Linecount: 122
X-Message-Size: 5216
X-Body-Size: 4608
X-Received-Count: 1
X-Recipient-Count: 7
X-Local-Recipient-Count: 7
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am experiencing a problem with the ethernet controller on an
i.MX28 SoC. When doing
  /etc/init.d/networking restart
sometimes I get "MDIO read timeout" and the controller does not
recover. The problem is more prominent if the interface is communicating
when the restart is performed.

I have found that the reason is the EBERR bit being set somewher.
The reference manual states:

  Ethernet bus error. This bit indicates a system bus error occurs when a DMA
  transaction is underway (Signal dma_eberr_int asserted). When the EBERR bit
  is set, ETHER_EN is cleared, halting frame processing by the MAC. When this
  occurs, software needs to insure proper actions (possibly resetting the
  system) to resume normal operation.

Clearing the ETHER_EN also disables the MII interrupts, so this
explains why the controller does not recover.

I assume the EBERR comes because of resetting the FEC at various
places - the fec_restart is called from 7 and fec_stop from 5 places.
It looks something here does not pay attention whether everything
is idle. In addition to EBERR also the BABR and MII are set
(MII because there was a MII transaction attempt, for babbling
receiver I have no idea). In case it matters the PHY connected
is the virtual port of the LAN9303 switch.

Trying to put a graceful stop before the reset in fec_restart
did not help. The controller is enabled when coming out of both
paths involving the reset, it is after this it falls into the
error state.

My platform is 3.12.15-rt, but I assume the problem is not rt-related.

The following patch remedies the situation, but this is just
a demonstration and not a solution. The warning is sometimes
output up to 3 times.

Please Cc: me when replying.


diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 1ec398b..cebb912 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -194,7 +194,7 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 #define FEC_ENET_MII   ((uint)0x00800000)      /* MII interrupt */
 #define FEC_ENET_EBERR ((uint)0x00400000)      /* SDMA bus error */

-#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF | FEC_ENET_MII)
+#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF | FEC_ENET_MII | FEC_ENET_EBERR)
 #define FEC_RX_DISABLED_IMASK (FEC_DEFAULT_IMASK & (~FEC_ENET_RXF))

 /* The FEC stores dest/src/type/vlan, data, and checksum for receive packets.
@@ -303,6 +303,31 @@ static void *swap_buffer(void *bufaddr, int len)
        return bufaddr;
 }

+/* Re-enable the controller after an ethernet bus error.
+ *
+ * Reference manual: This bit indicates a system bus
+ * error occurs when a DMA transaction is underway
+ * (Signal dma_eberr_int asserted). When the EBERR bit
+ * is set, ETHER_EN is cleared, halting frame processing
+ * by the MAC. When this occurs, software needs to insure
+ * proper actions (possibly resetting the system) to resume
+ * normal operation.
+ *
+ * This seems to happen when we restart the controller.
+ */
+static inline void fec_enet_clear_eberr_if_needed(struct net_device *ndev)
+{
+       struct fec_enet_private *fep = netdev_priv(ndev);
+       u32 ctl = readl(fep->hwp + FEC_ECNTRL);
+
+       if (!(ctl & 2)) {
+               ctl |= 2;
+               writel(FEC_ENET_EBERR, fep->hwp + FEC_IEVENT);
+               writel(ctl, fep->hwp + FEC_ECNTRL);
+               netdev_warn(ndev, "Re-enabled after EBERR\n");
+       }
+}
+
 static int
 fec_enet_clear_csum(struct sk_buff *skb, struct net_device *ndev)
 {
@@ -1059,6 +1084,10 @@ fec_enet_interrupt(int irq, void *dev_id)
                        ret = IRQ_HANDLED;
                        complete(&fep->mdio_done);
                }
+
+               if (int_events & FEC_ENET_EBERR)
+                       fec_enet_clear_eberr_if_needed(ndev);
+
        } while (int_events);

        return ret;
@@ -1200,6 +1229,8 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
        struct fec_enet_private *fep = bus->priv;
        unsigned long time_left;

+       fec_enet_clear_eberr_if_needed(fep->netdev);
+
        fep->mii_timeout = 0;
        init_completion(&fep->mdio_done);

@@ -1227,6 +1258,8 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
        struct fec_enet_private *fep = bus->priv;
        unsigned long time_left;

+       fec_enet_clear_eberr_if_needed(fep->netdev);
+
        fep->mii_timeout = 0;
        init_completion(&fep->mdio_done);



Regards
-- 
                                                Stano
