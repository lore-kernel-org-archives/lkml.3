Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaIHIFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:05:40 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:63744 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaIHIFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:05:38 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Yijing Wang <wangyijing@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Rostislav Lisovy <lisovy@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=20RESEND=5D=20ARM=3A=20PCI=3A=20Use=20PCI=5FCLASS=5F*=20defines=20for=20PCI=20class?=
Date: Mon,  8 Sep 2014 10:05:32 +0200
Message-Id: <1410163532-31057-1-git-send-email-lisovy@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
Reviewed-by: Yijing Wang <wangyijing@huawei.com>
---
The header file include/linux/pci_ids.h defines
#define PCI_CLASS_BRIDGE_OTHER          0x0680
#define PCI_CLASS_SYSTEM_DMA            0x0801

((struct pci_dev*)dev)->class
corresponds to the 3 bytes Class code in the PCI Configuration space
header -- 1B Base class, 1B Sub-class, 1B Reg-level interface.

In that case
(PCI_CLASS_BRIDGE_OTHER << 8)
is equivalent to 0x68000 (imagine the leading zero)
and
((PCI_CLASS_SYSTEM_DMA << 8) | 0x03))
is equivalent to 0x80103.


 arch/arm/kernel/bios32.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 17a26c1..e511ad1 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -255,10 +255,9 @@ static void pci_fixup_it8152(struct pci_dev *dev)
 {
 	int i;
 	/* fixup for ITE 8152 devices */
-	/* FIXME: add defines for class 0x68000 and 0x80103 */
 	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_HOST ||
-	    dev->class == 0x68000 ||
-	    dev->class == 0x80103) {
+	    dev->class == (PCI_CLASS_BRIDGE_OTHER << 8) ||
+	    dev->class == ((PCI_CLASS_SYSTEM_DMA << 8) | 0x03)) {
 		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
 			dev->resource[i].start = 0;
 			dev->resource[i].end   = 0;
-- 
1.7.10.4

