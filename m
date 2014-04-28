Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbaD1BdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:33:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42816 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "oftedal" <oftedal@gmail.com>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.239748191@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 16/94] sparc: PCI: Fix incorrect address calculation
 of PCI  Bridge windows on Simba-bridges
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: oftedal <oftedal@gmail.com>

[ Upstream commit 557fc5873ef178c4b3e1e36a42db547ecdc43f9b ]

The SIMBA APB Bridges lacks the 'ranges' of-property describing the
PCI I/O and memory areas located beneath the bridge. Faking this
information has been performed by reading range registers in the
APB bridge, and calculating the corresponding areas.

In commit 01f94c4a6ced476ce69b895426fc29bfc48c69bd
("Fix sabre pci controllers with new probing scheme.") a bug was
introduced into this calculation, causing the PCI memory areas
to be calculated incorrectly: The shift size was set to be
identical for I/O and MEM ranges, which is incorrect.

This patch set the shift size of the MEM range back to the
value used before 01f94c4a6ced476ce69b895426fc29bfc48c69bd.

Signed-off-by: Kjetil Oftedal <oftedal@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/kernel/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 31111e3..656b5b6 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -487,8 +487,8 @@ static void __devinit apb_fake_ranges(struct pci_dev *dev,
 	pci_read_config_byte(dev, APB_MEM_ADDRESS_MAP, &map);
 	apb_calc_first_last(map, &first, &last);
 	res = bus->resource[1];
-	res->start = (first << 21);
-	res->end = (last << 21) + ((1 << 21) - 1);
+	res->start = (first << 29);
+	res->end = (last << 29) + ((1 << 29) - 1);
 	res->flags = IORESOURCE_MEM;
 	pci_resource_adjust(res, &pbm->mem_space);
 }

