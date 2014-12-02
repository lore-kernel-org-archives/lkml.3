Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbaLBPFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:05:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48105 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbaLBPFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:05:39 -0500
Date: Tue, 2 Dec 2014 10:05:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: linux@eikelenboom.it, bhelgaas@google.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v4] Fixes for PCI backend for 3.19
Message-ID: <20141202150514.GC27869@laptop.dumpdata.com>
References: <1416608271-18931-1-git-send-email-konrad.wilk@oracle.com>
 <547D9E13020000780004C0B3@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547D9E13020000780004C0B3@mail.emea.novell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 10:10:11AM +0000, Jan Beulich wrote:
> >>> On 21.11.14 at 23:17, <konrad.wilk@oracle.com> wrote:
> > Konrad Rzeszutek Wilk (7):
> >       xen/pciback: Don't deadlock when unbinding.
> >       driver core: Provide an wrapper around the mutex to do lockdep warnings
> >       xen/pciback: Include the domain id if removing the device whilst still in use
> >       xen/pciback: Print out the domain owning the device.
> >       xen/pciback: Remove tons of dereferences
> >       PCI: Expose pci_load_saved_state for public consumption.
> >       xen/pciback: Restore configuration space when detaching from a guest.
> 
> So my "xen-pciback: drop SR-IOV VFs when PF driver unloads" isn't
> among them, nor is there any alternative. What's the status of that
> patch (or the problem that prompted its creation)?

Oh, I've it in my queue. Um, here is what I did to it - I hadn't
yet tested it - hence the reason it is not on that list.


>From 82ad7b4cc73f2f9a9cfd6805cff996fd5009a31f Mon Sep 17 00:00:00 2001
From: Jan Beulich <JBeulich@suse.com>
Date: Thu, 6 Nov 2014 15:05:51 +0000
Subject: [PATCH 1/2] xen-pciback: drop SR-IOV VFs when PF driver unloads

When a PF driver unloads, it may find it necessary to leave the VFs
around simply because of pciback having marked them as assigned to a
guest. Utilize a suitable notification to let go of the VFs, thus
allowing the PF to go back into the state it was before its driver
loaded (which in particular allows the driver to be loaded again with
it being able to create the VFs anew, but which also allows to then
pass through the PF instead of the VFs).

Don't do this however for any VFs currently in active use by a guest.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
[v2: Removed the switch statement, moved it about]
[v3: Redid it a bit differently]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 54 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index eb8b58e..ff27efa 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -1518,6 +1518,53 @@ parse_error:
 fs_initcall(pcistub_init);
 #endif
 
+#ifdef CONFIG_PCI_IOV
+static struct pcistub_device *find_vfs(const struct pci_dev *pdev)
+{
+	struct pcistub_device *psdev = NULL;
+	unsigned long flags;
+	bool found = false;
+
+	spin_lock_irqsave(&pcistub_devices_lock, flags);
+	list_for_each_entry(psdev, &pcistub_devices, dev_list) {
+		if (!psdev->pdev && psdev->dev != pdev
+		    && pci_physfn(psdev->dev) == pdev) {
+			found = true;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+	if (found)
+		return psdev;
+	return NULL;
+}
+
+static int pci_stub_notifier(struct notifier_block *nb,
+			     unsigned long action, void *data)
+{
+	struct device *dev = data;
+	const struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (action != BUS_NOTIFY_UNBIND_DRIVER)
+		return NOTIFY_DONE;
+
+	if (!pdev->is_physfn)
+		return NOTIFY_DONE;
+
+	for (;;) {
+		struct pcistub_device *psdev = find_vfs(pdev);
+		if (!psdev)
+			break;
+		device_release_driver(&psdev->dev->dev);
+	}
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
@@ -1539,12 +1586,19 @@ static int __init xen_pcibk_init(void)
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
-- 
1.9.3

> 
> Jan
> 
