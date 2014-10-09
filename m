Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaJIIkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:40:23 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:55694 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaJIIkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:40:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Wen Xiong <wenxiong@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] vfio/pci: make MSI handling optional
Date: Thu, 09 Oct 2014 10:40:07 +0200
Message-ID: <6188781.C8VgeYvZpD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Mt2cTlD7JyalATexpoeQzFb6CXrvMfgCMx9C+aqIF6E
 XVmlfbsVs6UMa6YAOIYDWBDdj98klxoy7s16zA4VaX5A0mJFxm
 Rnx98LTIeDzjFzRRkHqEgx2YEdSGTZkrw0BD+gGSLJwN8t0dcf
 mIp2noHLoUCM1ihECK40Mmvey0IyVYYMa/1fYunHdEjuZsHhxw
 hCuGCVIaz/3Jn/5/jU1ZpkDRNU1gbLpmonZWmAHPXEwjoog48v
 +9Kid7aQBwU16XfFCuyghfYo647rx4TzYFWdVhQkgnzgwP8c4W
 fHxoOJ6Hx1tvGItTgPLeIdJJHCxS2AUZuS6ABr5YB2U2sPW7T9
 8hqoMF8QZyKHv9FH6ljQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent bug fix to the MSIx handling in vfio added references
to functions that may not be defined if MSI is disabled in the kernel,
resulting in this link error:

drivers/built-in.o: In function `vfio_msi_set_vector_signal':
:(.text+0x450808): undefined reference to `get_cached_msi_msg'
:(.text+0x45080c): undefined reference to `write_msi_msg'

>From what I can tell, all the MSI specific ioctl handling can
be made optional in this case, which also reduces the code size
for the vfo driver. This patches does so using a build-time
IS_ENABLED() check, which leaves all the build coverage testing
present but avoids the link error.

A side-effect of this is that the driver now returns -ENOTTY instead
of -EINVAL if user space calls VFIO_PCI_MSI_IRQ_INDEX on a kernel
without MSI support, which seems to be the best behavior, but
the approach could easily be changed if we want to preserve the
existing behavior for compatibility reasons.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: b8f02af096b1 ("vfio/pci: Restore MSIx message prior to enabling")
---
Found using randconfig build testing on ARM.

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 553212f037c3..1117f96b8556 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -827,6 +827,9 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
 		break;
 	case VFIO_PCI_MSI_IRQ_INDEX:
 	case VFIO_PCI_MSIX_IRQ_INDEX:
+		if (!IS_ENABLED(CONFIG_PCI_MSI))
+			break;
+
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_MASK:
 		case VFIO_IRQ_SET_ACTION_UNMASK:

