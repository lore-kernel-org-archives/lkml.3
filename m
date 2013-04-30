Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab3D3HP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:15:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:26116 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab3D3HP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:15:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,579,1363158000"; 
   d="scan'208";a="329962171"
Date: Tue, 30 Apr 2013 00:21:47 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: x86/pci/mrst: force all pci config toward 0:0:0, 0:2:0 and 0:3:0 to
 type 1
Message-ID: <20130430072147.GA37866@bingao-desk1.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86/pci/mrst: force all pci config access toward 0:0:0, 0:2:0 and 0:3:0 to type 1

For real pci devices 0:0:0, 0:2:0 and 0:3:0, there is either no pci shim, or
no guarantee of data correctness of offset 256-4k. So for whatever reason,
Linux kernel should not do MMCFG pci config access to those devices. Instead,
always use type 1 for those devices.

Signed-off-by: Bin Gao <bin.gao@linux.intel.com>
---
 arch/x86/pci/mrst.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 6eb18c4..0e0fabf 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -141,6 +141,11 @@ static int pci_device_update_fixed(struct pci_bus *bus, unsigned int devfn,
  */
 static bool type1_access_ok(unsigned int bus, unsigned int devfn, int reg)
 {
+	if (bus == 0 && (devfn == PCI_DEVFN(2, 0)
+				|| devfn == PCI_DEVFN(0, 0)
+				|| devfn == PCI_DEVFN(3, 0)))
+		return 1;
+
 	/* This is a workaround for A0 LNC bug where PCI status register does
 	 * not have new CAP bit set. can not be written by SW either.
 	 *
@@ -150,10 +155,7 @@ static bool type1_access_ok(unsigned int bus, unsigned int devfn, int reg)
 	 */
 	if (reg >= 0x100 || reg == PCI_STATUS || reg == PCI_HEADER_TYPE)
 		return 0;
-	if (bus == 0 && (devfn == PCI_DEVFN(2, 0)
-				|| devfn == PCI_DEVFN(0, 0)
-				|| devfn == PCI_DEVFN(3, 0)))
-		return 1;
+
 	return 0; /* langwell on others */
 }
 
-- 
1.7.4.4

