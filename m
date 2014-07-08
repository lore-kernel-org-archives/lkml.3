Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaGHR5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:57:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:54846 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbaGHR5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:57:02 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v3 2/7] xen/pciback: Don't deadlock when unbinding.
Date: Tue,  8 Jul 2014 14:58:24 -0400
Message-Id: <1404845909-13563-3-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1404845909-13563-1-git-send-email-konrad@kernel.org>
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

As commit 0a9fd0152929db372ff61b0d6c280fdd34ae8bdb
'xen/pciback: Document the entry points for 'pcistub_put_pci_dev''
explained there are four entry points in this function.
Two of them are when the user fiddles in the SysFS to
unbind a device which might be in use by a guest or not.

Both 'unbind' states will cause a deadlock as the the PCI lock has
already been taken, which then pci_device_reset tries to take.

We can omit this by detecting this and using the  'already
locked' variant of the pci_device_reset - but we don't need to
do either as that is done much later when the PCIback device
structures are destroyed. As such lets use the 'try_reset'
variant. That means we still end up FLR-ing the device in
between swapping it from one guest to another. The FLR when
'unbind' part is still taken care by pci_device_reset.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 8a69a9f..b1fb099 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -277,10 +277,15 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	 * (so it's ready for the next domain)
 	 */
 
-	/* This is OK - we are running from workqueue context
-	 * and want to inhibit the user from fiddling with 'reset'
+	/* We might be holding the PCI lock (see comment at the top of the
+	 * function) - as such try lock and if we can't then don't worry -
+	 * as either:
+	 *  - we are 'unbind' in which case 'pcistub_device_release' gets
+	 *    called which does the locked version of this.
+	 *  - the toolstack has the smarts to do it and has done the
+	 *    reset on SysFS before assigning this device to another guest.
 	 */
-	pci_reset_function(dev);
+	pci_try_reset_function(dev);
 	pci_restore_state(dev);
 
 	/* This disables the device. */
-- 
1.7.7.6

