Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbaGONlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:41:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbaGONlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:41:00 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: xen-devel@lists.xenproject.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 4/4] xen/pvhvm: Make MSI IRQs work after kexec
Date: Tue, 15 Jul 2014 15:40:40 +0200
Message-Id: <1405431640-649-5-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kexec was peformed MSI IRQs for passthrough-ed devices were already
mapped and we see non-zero pirq extracted from MSI msg. xen_irq_from_pirq()
fails as we have no IRQ mapping information for that. Requesting for new
mapping with __write_msi_msg() does not result in MSI IRQ being remapped so
we don't recieve these IRQs.

RFC: I wasn't able to understand why commit af42b8d1 which introduced
xen_irq_from_pirq() check in xen_hvm_setup_msi_irqs() is checking that instead
of checking pirq > 0 as if the mapping was already done (and we have pirq>0 here)
we don't need to request for a new pirq. We're loosing existing PIRQ and I'm also
not sure when __write_msi_msg() with new PIRQ will result in new mapping.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/pci/xen.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 905956f..685e8f1 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -231,8 +231,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		__read_msi_msg(msidesc, &msg);
 		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
 			((msg.address_lo >> MSI_ADDR_DEST_ID_SHIFT) & 0xff);
-		if (msg.data != XEN_PIRQ_MSI_DATA ||
-		    xen_irq_from_pirq(pirq) < 0) {
+		if (msg.data != XEN_PIRQ_MSI_DATA || pirq <= 0) {
 			pirq = xen_allocate_pirq_msi(dev, msidesc);
 			if (pirq < 0) {
 				irq = -ENODEV;
-- 
1.9.3

