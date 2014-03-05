Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbaCEOeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:34:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41263 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687AbaCEO1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:27:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jean Delvare <jdelvare@suse.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 111/131] i7core_edac: Fix PCI device reference count
Date: Wed,  5 Mar 2014 14:23:55 +0000
Message-Id: <1394029455-23128-112-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/edac/i7core_edac.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 80a963d..c67fb4d 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1334,14 +1334,19 @@ static int i7core_get_onedevice(struct pci_dev **prev,
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
-- 
1.9.0

