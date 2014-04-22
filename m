Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbaDVUVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:21:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36385 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaDVUVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:21:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kjetil Oftedal <oftedal@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 024/133] sparc: PCI: Fix incorrect address calculation of PCI Bridge windows on Simba-bridges
Date: Tue, 22 Apr 2014 13:12:42 -0700
Message-Id: <1398197671-12786-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/kernel/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index baf4366..906cbf0 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -399,8 +399,8 @@ static void apb_fake_ranges(struct pci_dev *dev,
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

