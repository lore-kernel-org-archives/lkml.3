Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3CNKiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:38:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52083 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab3CNKiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 78/88] xen/pciback: Don't disable a PCI device that is already disabled.
Date: Thu, 14 Mar 2013 10:36:11 +0000
Message-Id: <1363257381-15900-79-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit bdc5c1812cea6efe1aaefb3131fcba28cd0b2b68 upstream.

While shuting down a HVM guest with pci devices passed through we
get this:

pciback 0000:04:00.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100002)
------------[ cut here ]------------
WARNING: at drivers/pci/pci.c:1397 pci_disable_device+0x88/0xa0()
Hardware name: MS-7640
Device pciback
disabling already-disabled device
Modules linked in:
Pid: 53, comm: xenwatch Not tainted 3.9.0-rc1-20130304a+ #1
Call Trace:
 [<ffffffff8106994a>] warn_slowpath_common+0x7a/0xc0
 [<ffffffff81069a31>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff813cf288>] pci_disable_device+0x88/0xa0
 [<ffffffff814554a7>] xen_pcibk_reset_device+0x37/0xd0
 [<ffffffff81454b6f>] ? pcistub_put_pci_dev+0x6f/0x120
 [<ffffffff81454b8d>] pcistub_put_pci_dev+0x8d/0x120
 [<ffffffff814582a9>] __xen_pcibk_release_devices+0x59/0xa0

This fixes the bug.

Reported-and-Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/xen/xen-pciback/pciback_ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/xen-pciback/pciback_ops.c b/drivers/xen/xen-pciback/pciback_ops.c
index 37c1f82..b98cf0c 100644
--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -113,7 +113,8 @@ void xen_pcibk_reset_device(struct pci_dev *dev)
 		if (dev->msi_enabled)
 			pci_disable_msi(dev);
 #endif
-		pci_disable_device(dev);
+		if (pci_is_enabled(dev))
+			pci_disable_device(dev);
 
 		pci_write_config_word(dev, PCI_COMMAND, 0);
 
-- 
1.8.1.2

