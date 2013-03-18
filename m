Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab3CREm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:42:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33569 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893Ab3CREaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:39 -0400
Message-Id: <20130318042148.723270831@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:30 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 46/82] xen/pciback: Dont disable a PCI device that is already disabled.
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/xen/xen-pciback/pciback_ops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -114,7 +114,8 @@ void xen_pcibk_reset_device(struct pci_d
 		if (dev->msi_enabled)
 			pci_disable_msi(dev);
 #endif
-		pci_disable_device(dev);
+		if (pci_is_enabled(dev))
+			pci_disable_device(dev);
 
 		pci_write_config_word(dev, PCI_COMMAND, 0);
 


