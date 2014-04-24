Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbaDXWT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:19:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbaDXVqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:46:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kjetil Oftedal <oftedal@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 17/23] sparc: PCI: Fix incorrect address calculation of PCI Bridge windows on Simba-bridges
Date: Thu, 24 Apr 2014 14:48:47 -0700
Message-Id: <20140424214828.112839774@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424214825.933835556@linuxfoundation.org>
References: <20140424214825.933835556@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -399,8 +399,8 @@ static void apb_fake_ranges(struct pci_d
 	apb_calc_first_last(map, &first, &last);
 	res = bus->resource[1];
 	res->flags = IORESOURCE_MEM;
-	region.start = (first << 21);
-	region.end = (last << 21) + ((1 << 21) - 1);
+	region.start = (first << 29);
+	region.end = (last << 29) + ((1 << 29) - 1);
 	pcibios_bus_to_resource(dev, res, &region);
 }
 


