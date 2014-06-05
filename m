Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaFEEtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:49:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFEEVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Grant Grundler <grundler@parisc-linux.org>,
        Nobin Mathew <nobin.mathew@gmail.com>,
        Robert Hancock <hancockr@shaw.ca>, Arnd Bergmann <arnd@arndb.de>,
        David Altobelli <david.altobelli@hp.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 111/214] MISC: hpilo, remove pci_disable_device
Date: Wed,  4 Jun 2014 21:17:54 -0700
Message-Id: <20140605041654.605779691@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit bcdee04ea7ae0406ae69094f6df1aacb66a69a0b upstream.

pci_disable_device(pdev) used to be in pci remove function. But this
PCI device has two functions with interrupt lines connected to a
single pin. The other one is a USB host controller. So when we disable
the PIN there e.g. by rmmod hpilo, the controller stops working. It is
because the interrupt link is disabled in ACPI since it is not
refcounted yet. See acpi_pci_link_free_irq called from
acpi_pci_irq_disable.

It is not the best solution whatsoever, but as a workaround until the
ACPI irq link refcounting is sorted out this should fix the reported
errors.

References: https://lkml.org/lkml/2008/11/4/535

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Nobin Mathew <nobin.mathew@gmail.com>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Altobelli <david.altobelli@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/hpilo.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -735,7 +735,14 @@ static void ilo_remove(struct pci_dev *p
 	free_irq(pdev->irq, ilo_hw);
 	ilo_unmap_device(pdev, ilo_hw);
 	pci_release_regions(pdev);
-	pci_disable_device(pdev);
+	/*
+	 * pci_disable_device(pdev) used to be here. But this PCI device has
+	 * two functions with interrupt lines connected to a single pin. The
+	 * other one is a USB host controller. So when we disable the PIN here
+	 * e.g. by rmmod hpilo, the controller stops working. It is because
+	 * the interrupt link is disabled in ACPI since it is not refcounted
+	 * yet. See acpi_pci_link_free_irq called from acpi_pci_irq_disable.
+	 */
 	kfree(ilo_hw);
 	ilo_hwdev[(minor / MAX_CCB)] = 0;
 }
@@ -820,7 +827,7 @@ unmap:
 free_regions:
 	pci_release_regions(pdev);
 disable:
-	pci_disable_device(pdev);
+/*	pci_disable_device(pdev);  see comment in ilo_remove */
 free:
 	kfree(ilo_hw);
 out:


