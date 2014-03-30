Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbaC3Xni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:43:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644AbaC3Xne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:34 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        "Doug Thompson" <dougthompson@xmission.com>,
        "Jean Delvare" <jdelvare@suse.de>, "Alan Cox" <alan@linux.intel.com>,
        "Borislav Petkov" <bp@suse.de>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.848478542@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 139/200] i7core_edac: Fix PCI device reference count
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

commit c0f5eeed0f4cef4f05b74883a7160e7edde58b6a upstream.

The reference count changes done by pci_get_device can be a little
misleading when the usage diverges from the most common scheme. The
reference count of the device passed as the last parameter is always
decreased, even if the function returns no new device. So if we are
going to try alternative device IDs, we must manually increment the
device reference count before each retry. If we don't, we end up
decreasing the reference count, and after a few modprobe/rmmod cycles
the PCI devices will vanish.

In other words and as Alan put it: without this fix the EDAC code
corrupts the PCI device list.

This fixes kernel bug #50491:
https://bugzilla.kernel.org/show_bug.cgi?id=50491

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Link: http://lkml.kernel.org/r/20140224093927.7659dd9d@endymion.delvare
Reviewed-by: Alan Cox <alan@linux.intel.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/edac/i7core_edac.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1365,14 +1365,19 @@ static int i7core_get_onedevice(struct p
 	 * is at addr 8086:2c40, instead of 8086:2c41. So, we need
 	 * to probe for the alternate address in case of failure
 	 */
-	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_I7_NONCORE && !pdev)
+	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_I7_NONCORE && !pdev) {
+		pci_dev_get(*prev);	/* pci_get_device will put it */
 		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
 				      PCI_DEVICE_ID_INTEL_I7_NONCORE_ALT, *prev);
+	}
 
-	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE && !pdev)
+	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE &&
+	    !pdev) {
+		pci_dev_get(*prev);	/* pci_get_device will put it */
 		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
 				      PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE_ALT,
 				      *prev);
+	}
 
 	if (!pdev) {
 		if (*prev) {

