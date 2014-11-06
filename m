Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaKFPFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:05:55 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:60693 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaKFPFy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 6 Nov 2014 10:05:54 -0500
Message-Id: <545B9C5F020000780004561B@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Thu, 06 Nov 2014 15:05:51 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen-pciback: drop SR-IOV VFs when PF driver unloads
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a PF driver unloads, it may find it necessary to leave the VFs
around simply because of pciback having marked them as assigned to a
guest. Utilize a suitable notification to let go of the VFs, thus
allowing the PF to go back into the state it was before its driver
loaded (which in particular allows the driver to be loaded again with
it being able to create the VFs anew, but which also allows to then
pass through the PF instead of the VFs).

Don't do this however for any VFs currently in active use by a guest.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 drivers/xen/xen-pciback/pci_stub.c |   46 +++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- 3.18-rc3/drivers/xen/xen-pciback/pci_stub.c
+++ 3.18-rc3-pciback-release-VFs/drivers/xen/xen-pciback/pci_stub.c
@@ -1502,6 +1502,45 @@ parse_error:
 fs_initcall(pcistub_init);
 #endif
 
+#ifdef CONFIG_PCI_IOV
+static int pci_stub_notifier(struct notifier_block *nb,
+			     unsigned long action, void *data)
+{
+	struct device *dev = data;
+	const struct pci_dev *pdev = to_pci_dev(dev);
+
+	switch (action) {
+	case BUS_NOTIFY_UNBIND_DRIVER:
+		if (!pdev->is_physfn)
+			break;
+		for (;;) {
+			struct pcistub_device *psdev;
+			unsigned long flags;
+			bool found = false;
+
+			spin_lock_irqsave(&pcistub_devices_lock, flags);
+			list_for_each_entry(psdev, &pcistub_devices, dev_list)
+				if (!psdev->pdev && psdev->dev != pdev
+				    && pci_physfn(psdev->dev) == pdev) {
+					found = true;
+					break;
+				}
+			spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+			if (!found)
+				break;
+			device_release_driver(&psdev->dev->dev);
+		}
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block pci_stub_nb = {
+	.notifier_call = pci_stub_notifier,
+};
+#endif
+
 static int __init xen_pcibk_init(void)
 {
 	int err;
@@ -1523,12 +1562,19 @@ static int __init xen_pcibk_init(void)
 	err = xen_pcibk_xenbus_register();
 	if (err)
 		pcistub_exit();
+#ifdef CONFIG_PCI_IOV
+	else
+		bus_register_notifier(&pci_bus_type, &pci_stub_nb);
+#endif
 
 	return err;
 }
 
 static void __exit xen_pcibk_cleanup(void)
 {
+#ifdef CONFIG_PCI_IOV
+	bus_unregister_notifier(&pci_bus_type, &pci_stub_nb);
+#endif
 	xen_pcibk_xenbus_unregister();
 	pcistub_exit();
 }



