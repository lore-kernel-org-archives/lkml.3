Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaJWPXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:23:25 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49456 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaJWPXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:23:24 -0400
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: liviu.dudau@arm.com, Suravee.Suthikulpanit@amd.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH RFC 1/2] drivers: pci: fix window allocation order wrt bus_range filtering
Date: Thu, 23 Oct 2014 16:23:06 +0100
Message-Id: <1414077787-20633-1-git-send-email-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 2.1.2
X-OriginalArrivalTime: 23 Oct 2014 15:23:21.0272 (UTC) FILETIME=[478A3B80:01CFEED5]
X-MC-Unique: 114102316232119101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id s9NFNgYK016957

The number of windows allocated for the host bridge depends on the
bus resource. Instead of first allocating the windows and then
limit the bus resource, this patch reshuffles the code so that if any
limitation is applied to the bus resource it is taken into account in
the windows allocation.

Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
---
 drivers/pci/host/pci-host-generic.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
index 3d2076f..1e1a80f 100644
--- a/drivers/pci/host/pci-host-generic.c
+++ b/drivers/pci/host/pci-host-generic.c
@@ -276,17 +276,17 @@ static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
 		return err;
 	}
 
-	pci->cfg.win = devm_kcalloc(dev, resource_size(&pci->cfg.bus_range),
-				    sizeof(*pci->cfg.win), GFP_KERNEL);
-	if (!pci->cfg.win)
-		return -ENOMEM;
-
 	/* Limit the bus-range to fit within reg */
 	bus_max = pci->cfg.bus_range.start +
 		  (resource_size(&pci->cfg.res) >> pci->cfg.ops->bus_shift) - 1;
 	pci->cfg.bus_range.end = min_t(resource_size_t, pci->cfg.bus_range.end,
 				       bus_max);
 
+	pci->cfg.win = devm_kcalloc(dev, resource_size(&pci->cfg.bus_range),
+				    sizeof(*pci->cfg.win), GFP_KERNEL);
+	if (!pci->cfg.win)
+		return -ENOMEM;
+
 	/* Map our Configuration Space windows */
 	if (!devm_request_mem_region(dev, pci->cfg.res.start,
 				     resource_size(&pci->cfg.res),
-- 
2.1.2


