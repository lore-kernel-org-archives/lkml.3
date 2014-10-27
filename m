Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaJ0TNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:13:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52782 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaJ0TDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 027/105] PCI: mvebu: Fix uninitialized variable in mvebu_get_tgt_attr()
Date: Mon, 27 Oct 2014 11:56:02 -0700
Message-Id: <1414436240-13879-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 56fab6e189441d714a2bfc8a64f3df9c0749dff7 upstream.

Geert Uytterhoeven reported a warning when building pci-mvebu:

  drivers/pci/host/pci-mvebu.c: In function 'mvebu_get_tgt_attr':
  drivers/pci/host/pci-mvebu.c:887:39: warning: 'rtype' may be used uninitialized in this function [-Wmaybe-uninitialized]
     if (slot == PCI_SLOT(devfn) && type == rtype) {
					 ^

And indeed, the code of mvebu_get_tgt_attr() may lead to the usage of rtype
when being uninitialized, even though it would only happen if we had
entries other than I/O space and 32 bits memory space.

This commit fixes that by simply skipping the current DT range being
considered, if it doesn't match the resource type we're looking for.

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pci/host/pci-mvebu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index d55291c..77044b6 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -824,7 +824,7 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
 	rangesz = pna + na + ns;
 	nranges = rlen / sizeof(__be32) / rangesz;
 
-	for (i = 0; i < nranges; i++) {
+	for (i = 0; i < nranges; i++, range += rangesz) {
 		u32 flags = of_read_number(range, 1);
 		u32 slot = of_read_number(range + 1, 1);
 		u64 cpuaddr = of_read_number(range + na, pna);
@@ -834,14 +834,14 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
 			rtype = IORESOURCE_IO;
 		else if (DT_FLAGS_TO_TYPE(flags) == DT_TYPE_MEM32)
 			rtype = IORESOURCE_MEM;
+		else
+			continue;
 
 		if (slot == PCI_SLOT(devfn) && type == rtype) {
 			*tgt = DT_CPUADDR_TO_TARGET(cpuaddr);
 			*attr = DT_CPUADDR_TO_ATTR(cpuaddr);
 			return 0;
 		}
-
-		range += rangesz;
 	}
 
 	return -ENOENT;
-- 
1.9.1

