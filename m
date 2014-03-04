Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575AbaCDVCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:02:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbaCDUED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Alan Cox <alan@linux.intel.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3.13 115/172] i7core_edac: Fix PCI device reference count
Date: Tue,  4 Mar 2014 12:03:19 -0800
Message-Id: <20140304200303.391482532@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/i7core_edac.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1334,14 +1334,19 @@ static int i7core_get_onedevice(struct p
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


