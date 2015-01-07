Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbbAGFmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:42:13 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40327 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbAGFmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:42:08 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ryan Grimm <grimm@linux.vnet.ibm.com>
Subject: [PATCH] CXL: Fix device_node reference counting
Date: Wed,  7 Jan 2015 16:41:18 +1100
Message-Id: <1420609278-15338-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010705-0025-0000-0000-000000E19B78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Grimm <grimm@linux.vnet.ibm.com>

When unbinding and rebinding the driver on a system with a card in PHB0, this
error condition is reached after a few attempts:

ERROR: Bad of_node_put() on /pciex@3fffe40000000
CPU: 0 PID: 3040 Comm: bash Not tainted 3.18.0-rc3-12545-g3627ffe #152
Call Trace:
[c000000721acb5c0] [c00000000086ef94] .dump_stack+0x84/0xb0 (unreliable)
[c000000721acb640] [c00000000073a0a8] .of_node_release+0xd8/0xe0
[c000000721acb6d0] [c00000000044bc44] .kobject_release+0x74/0xe0
[c000000721acb760] [c0000000007394fc] .of_node_put+0x1c/0x30
[c000000721acb7d0] [c000000000545cd8] .cxl_probe+0x1a98/0x1d50
[c000000721acb900] [c0000000004845a0] .local_pci_probe+0x40/0xc0
[c000000721acb980] [c000000000484998] .pci_device_probe+0x128/0x170
[c000000721acba30] [c00000000052400c] .driver_probe_device+0xac/0x2a0
[c000000721acbad0] [c000000000522468] .bind_store+0x108/0x160
[c000000721acbb70] [c000000000521448] .drv_attr_store+0x38/0x60
[c000000721acbbe0] [c000000000293840] .sysfs_kf_write+0x60/0xa0
[c000000721acbc50] [c000000000292500] .kernfs_fop_write+0x140/0x1d0
[c000000721acbcf0] [c000000000208648] .vfs_write+0xd8/0x260
[c000000721acbd90] [c000000000208b18] .SyS_write+0x58/0x100
[c000000721acbe30] [c000000000009258] syscall_exit+0x0/0x98

of_get_next_parent decrements parent's refcount and we need to call of_node_put
after the iteration.  But, if while loop is not entered, of_node_put get called
on np without an of_node_get.  So, call it before the while loop.

Signed-off-by: Ryan Grimm <grimm@linux.vnet.ibm.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 drivers/misc/cxl/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/cxl/pci.c b/drivers/misc/cxl/pci.c
index 2ccd0a9..f801c28 100644
--- a/drivers/misc/cxl/pci.c
+++ b/drivers/misc/cxl/pci.c
@@ -319,6 +319,7 @@ static int init_implementation_adapter_regs(struct cxl *adapter, struct pci_dev
 	if (!(np = pnv_pci_to_phb_node(dev)))
 		return -ENODEV;
 
+	of_node_get(np);
 	while (np && !(prop = of_get_property(np, "ibm,chip-id", NULL)))
 		np = of_get_next_parent(np);
 	if (!np)
-- 
2.1.4

