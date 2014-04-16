Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaDPKgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:36:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbaDPKdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:33:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kjetil Oftedal <oftedal@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 39/46] sparc: PCI: Fix incorrect address calculation of PCI Bridge windows on Simba-bridges
Date: Wed, 16 Apr 2014 11:31:55 +0100
Message-Id: <1397644322-13905-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: oftedal <oftedal@gmail.com>

commit 557fc5873ef178c4b3e1e36a42db547ecdc43f9b upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/kernel/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index bc4d3f5..cb02145 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -398,8 +398,8 @@ static void apb_fake_ranges(struct pci_dev *dev,
 	apb_calc_first_last(map, &first, &last);
 	res = bus->resource[1];
 	res->flags = IORESOURCE_MEM;
-	region.start = (first << 21);
-	region.end = (last << 21) + ((1 << 21) - 1);
+	region.start = (first << 29);
+	region.end = (last << 29) + ((1 << 29) - 1);
 	pcibios_bus_to_resource(dev, res, &region);
 }
 
-- 
1.9.1

