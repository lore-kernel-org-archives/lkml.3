Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab3E1D47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52463 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758787Ab3E1DyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nithin Sujir" <nsujir@broadcom.com>,
        "Michael Chan" <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.265443227@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [36/94] tg3: Skip powering down function 0 on certain serdes devices
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

commit 44f3b503c16425c8e9db4bbaa2fc9cd0c9d0ba91 upstream.

On the 5718, 5719 and 5720 serdes devices, powering down function 0
results in all the other ports being powered down. Add code to skip
function 0 power down.

v2:
 - Modify tg3_phy_power_bug() function to use a switch instead of a
   complicated if statement. Suggested by Joe Perches.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2:
 s/tg3_asic_rev\(tp\)/GET_ASIC_REV(tp->pci_chip_rev_id)/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/tg3.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -2752,6 +2752,31 @@ static int tg3_5700_link_polarity(struct
 static int tg3_setup_phy(struct tg3 *, int);
 static int tg3_halt_cpu(struct tg3 *, u32);
 
+static bool tg3_phy_power_bug(struct tg3 *tp)
+{
+	switch (GET_ASIC_REV(tp->pci_chip_rev_id)) {
+	case ASIC_REV_5700:
+	case ASIC_REV_5704:
+		return true;
+	case ASIC_REV_5780:
+		if (tp->phy_flags & TG3_PHYFLG_MII_SERDES)
+			return true;
+		return false;
+	case ASIC_REV_5717:
+		if (!tp->pci_fn)
+			return true;
+		return false;
+	case ASIC_REV_5719:
+	case ASIC_REV_5720:
+		if ((tp->phy_flags & TG3_PHYFLG_PHY_SERDES) &&
+		    !tp->pci_fn)
+			return true;
+		return false;
+	}
+
+	return false;
+}
+
 static void tg3_power_down_phy(struct tg3 *tp, bool do_low_power)
 {
 	u32 val;
@@ -2808,12 +2833,7 @@ static void tg3_power_down_phy(struct tg
 	/* The PHY should not be powered down on some chips because
 	 * of bugs.
 	 */
-	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5700 ||
-	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5704 ||
-	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5780 &&
-	     (tp->phy_flags & TG3_PHYFLG_MII_SERDES)) ||
-	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5717 &&
-	     !tp->pci_fn))
+	if (tg3_phy_power_bug(tp))
 		return;
 
 	if (GET_CHIP_REV(tp->pci_chip_rev_id) == CHIPREV_5784_AX ||

