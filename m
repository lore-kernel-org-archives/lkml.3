Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaAOWeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:34:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40850 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaAOV4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:56:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rob Herring <robh@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 123/166] Revert "of/address: Handle #address-cells > 2 specially"
Date: Wed, 15 Jan 2014 13:52:17 -0800
Message-Id: <1389822780-4729-124-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

commit 13fcca8f25f4e9ce7f55da9cd353bb743236e212 upstream.

This reverts commit e38c0a1fbc5803cbacdaac0557c70ac8ca5152e7.

Nikita Yushchenko reports:
While trying to make freescale p2020ds and  mpc8572ds boards working
with mainline kernel, I faced that commit e38c0a1f (Handle

Both these boards have uli1575 chip.
Corresponding part in device tree is something like

                uli1575@0 {
                        reg = <0x0 0x0 0x0 0x0 0x0>;
                        #size-cells = <2>;
                        #address-cells = <3>;
                        ranges = <0x2000000 0x0 0x80000000
                                  0x2000000 0x0 0x80000000
                                  0x0 0x20000000

                                  0x1000000 0x0 0x0
                                  0x1000000 0x0 0x0
                                  0x0 0x10000>;
                        isa@1e {
...

I.e. it has #address-cells = <3>

With commit e38c0a1f reverted, devices under uli1575 are registered
correctly, e.g. for rtc

OF: ** translation for device /pcie@ffe09000/pcie@0/uli1575@0/isa@1e/rtc@70 **
OF: bus is isa (na=2, ns=1) on /pcie@ffe09000/pcie@0/uli1575@0/isa@1e
OF: translating address: 00000001 00000070
OF: parent bus is default (na=3, ns=2) on /pcie@ffe09000/pcie@0/uli1575@0
OF: walking ranges...
OF: ISA map, cp=0, s=1000, da=70
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 70
OF: one level translation: 00000000 00000000 00000070
OF: parent bus is pci (na=3, ns=2) on /pcie@ffe09000/pcie@0
OF: walking ranges...
OF: default map, cp=a0000000, s=20000000, da=70
OF: default map, cp=0, s=10000, da=70
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 70
OF: one level translation: 01000000 00000000 00000070
OF: parent bus is pci (na=3, ns=2) on /pcie@ffe09000
OF: walking ranges...
OF: PCI map, cp=0, s=10000, da=70
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 70
OF: one level translation: 01000000 00000000 00000070
OF: parent bus is default (na=2, ns=2) on /
OF: walking ranges...
OF: PCI map, cp=0, s=10000, da=70
OF: parent translation for: 00000000 ffc10000
OF: with offset: 70
OF: one level translation: 00000000 ffc10070
OF: reached root node

With commit e38c0a1f in place, address translation fails:

OF: ** translation for device /pcie@ffe09000/pcie@0/uli1575@0/isa@1e/rtc@70 **
OF: bus is isa (na=2, ns=1) on /pcie@ffe09000/pcie@0/uli1575@0/isa@1e
OF: translating address: 00000001 00000070
OF: parent bus is default (na=3, ns=2) on /pcie@ffe09000/pcie@0/uli1575@0
OF: walking ranges...
OF: ISA map, cp=0, s=1000, da=70
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 70
OF: one level translation: 00000000 00000000 00000070
OF: parent bus is pci (na=3, ns=2) on /pcie@ffe09000/pcie@0
OF: walking ranges...
OF: default map, cp=a0000000, s=20000000, da=70
OF: default map, cp=0, s=10000, da=70
OF: not found !

Thierry Reding confirmed this commit was not needed after all:
"We ended up merging a different address representation for Tegra PCIe
and I've confirmed that reverting this commit doesn't cause any obvious
regressions. I think all other drivers in drivers/pci/host ended up
copying what we did on Tegra, so I wouldn't expect any other breakage
either."

There doesn't appear to be a simple way to support both behaviours, so
reverting this as nothing should be depending on the new behaviour.

Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/of/address.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 0125524..fb2a4e8 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -69,14 +69,6 @@ static u64 of_bus_default_map(__be32 *addr, const __be32 *range,
 		 (unsigned long long)cp, (unsigned long long)s,
 		 (unsigned long long)da);
 
-	/*
-	 * If the number of address cells is larger than 2 we assume the
-	 * mapping doesn't specify a physical address. Rather, the address
-	 * specifies an identifier that must match exactly.
-	 */
-	if (na > 2 && memcmp(range, addr, na * 4) != 0)
-		return OF_BAD_ADDR;
-
 	if (da < cp || da >= (cp + s))
 		return OF_BAD_ADDR;
 	return da - cp;
-- 
1.8.3.2

