Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3EHISt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 04:18:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19316 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3EHISr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 04:18:47 -0400
Message-ID: <518A0A50.1020705@oracle.com>
Date: Wed, 08 May 2013 16:18:24 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: xen-devel@lists.xensource.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yuval Shaia <yuval.shaia@oracle.com>,
        Feng Jin <joe.jin@oracle.com>, Chien Yen <chien.yen@oracle.com>
Subject: [PATCH] xen: reuse the same pirq allocated when driver load first
 time
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When driver load and unload in a loop, pirq will exhaust finally.
Try to use the same pirq which was already mapped and binded at first time
when driver loaded.

Read pirq from msix entry and test if data is XEN_PIRQ_MSI_DATA
xen_irq_from_pirq(pirq) < 0 checking is wrong as irq will be freed
when driver unload, it's always true in second load.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Tested-by: Yuval Shaia <yuval.shaia@oracle.com>
---
 arch/x86/pci/xen.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 94e7662..4289eef 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -230,8 +230,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		__read_msi_msg(msidesc, &msg);
 		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
 			((msg.address_lo >> MSI_ADDR_DEST_ID_SHIFT) & 0xff);
-		if (msg.data != XEN_PIRQ_MSI_DATA ||
-		    xen_irq_from_pirq(pirq) < 0) {
+		if (msg.data != XEN_PIRQ_MSI_DATA) {
 			pirq = xen_allocate_pirq_msi(dev, msidesc);
 			if (pirq < 0) {
 				irq = -ENODEV;
-- 
1.7.3

