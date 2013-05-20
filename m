Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab3ETUjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:39:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25218 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010Ab3ETUjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:39:16 -0400
Date: Mon, 20 May 2013 16:38:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yuval Shaia <yuval.shaia@oracle.com>,
        Feng Jin <joe.jin@oracle.com>, Chien Yen <chien.yen@oracle.com>
Subject: Re: [PATCH] xen: reuse the same pirq allocated when driver load
 first time
Message-ID: <20130520203855.GA30616@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1305131540020.4799@kaball.uk.xensource.com>
 <20130513161714.GC10401@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305131753070.4799@kaball.uk.xensource.com>
 <20130513182055.GC14177@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305141440500.4799@kaball.uk.xensource.com>
 <20130514142013.GA10173@konrad-lan.dumpdata.com>
 <alpine.DEB.2.02.1305151037100.4799@kaball.uk.xensource.com>
 <5195944A.3050608@oracle.com>
 <alpine.DEB.2.02.1305201121370.4799@kaball.uk.xensource.com>
 <20130520175706.GA27973@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130520175706.GA27973@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At this point I think that upstream option is to save the PIRQ value and re-use it.
> Will post a patch for it.

Here is the patch. It works for me when passing in a NIC driver.

>From 509499568d1cdf1f2a3fb53773c991f4b063eb56 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 20 May 2013 16:08:16 -0400
Subject: [PATCH] xen/pci: Track PVHVM PIRQs.

The PIRQs that the hypervisor provides for the guest are a limited
resource. They are acquired via PHYSDEVOP_get_free_pirq and in
theory should be returned back to the hypervisor via PHYSDEVOP_unmap_pirq
hypercall. Unfortunatly that is not the case.

This means that if there is a PCI device that has been passed in
the guest and does a loop of 'rmmod <driver>;modprobe <driver>"
we end up exhausting all of the PIRQs that are available.

For example (with kernel built as debug), we get this:
00:05.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
[  152.659396] e1000e 0000:00:05.0: xen: msi bound to pirq=53
[  152.665856] e1000e 0000:00:05.0: xen: msi --> pirq=53 --> irq=73
.. snip
[  188.276835] e1000e 0000:00:05.0: xen: msi bound to pirq=51
[  188.283194] e1000e 0000:00:05.0: xen: msi --> pirq=51 --> irq=73

.. and so on, until the pirq value is zero. This is an acute problem
when many PCI devices with many MSI-X entries are passed in the guest.

There is an alternative solution where we assume that on PCI
initialization (so when user passes in the PCI device) QEMU will init
the MSI and MSI-X entries to zero. Based on that assumptions and
that the Linux MSI API will write the PIRQ value to the MSI/MSI-X
(and used by QEMU through the life-cycle of the PCI device), we can
also depend on that. That means if MSI (or MSI-X entries) are read back
and are not 0, we can re-use that PIRQ value. However this patch
guards against future changes in QEMU in case that assumption
is incorrect.

Reported-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |  124 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 122 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 6a6bbe4..8aae21a 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -112,6 +112,27 @@ struct irq_info {
 #define PIRQ_NEEDS_EOI	(1 << 0)
 #define PIRQ_SHAREABLE	(1 << 1)
 
+/*
+ * The PHYSDEVOP_get_free_pirq allocates a set of PIRQs for the guest and
+ * the PHYSDEVOP_unmap_pirq is suppose to return them to the hypervisor.
+ * Unfortunatly that is not the case and we exhaust all of the PIRQs that are
+ * allocated for the domain if a driver is loaded/unloaded in a loop.
+ * The pirq_info serves a cache of the allocated PIRQs so that we can reuse
+ * for drivers. Note, it is only used by the MSI, MSI-X routines.
+ */
+#ifdef CONFIG_PCI_MSI
+static LIST_HEAD(xen_pirq_list_head);
+#endif
+enum xen_pirq_status {
+	PIRQ_FREE = 1,
+	PIRQ_BUSY
+};
+struct pirq_info {
+	struct list_head list;
+	int pirq;
+	enum xen_pirq_status status;
+};
+
 static int *evtchn_to_irq;
 #ifdef CONFIG_X86
 static unsigned long *pirq_eoi_map;
@@ -145,6 +166,86 @@ static struct irq_chip xen_pirq_chip;
 static void enable_dynirq(struct irq_data *data);
 static void disable_dynirq(struct irq_data *data);
 
+#ifdef CONFIG_PCI_MSI
+static void xen_pirq_add(int pirq)
+{
+	struct pirq_info *p_info;
+
+	if (!xen_hvm_domain())
+		return;
+
+	p_info = kzalloc(sizeof(*p_info), GFP_KERNEL);
+	if (!p_info)
+		return;
+
+	p_info->pirq = pirq;
+	p_info->status = PIRQ_FREE;
+
+	mutex_lock(&irq_mapping_update_lock);
+	list_add_tail(&p_info->list, &xen_pirq_list_head);
+	mutex_unlock(&irq_mapping_update_lock);
+}
+static void xen_update_pirq_status(int pirq, enum xen_pirq_status status)
+{
+	struct pirq_info *p_info = NULL;
+	bool found = false;
+
+	if (!xen_hvm_domain())
+		return;
+
+	/*
+	 * The irq_mapping_update_lock is being held while this is called.
+	 */
+	list_for_each_entry(p_info, &xen_pirq_list_head, list) {
+
+		if (p_info->pirq != pirq)
+			continue;
+		found = true;
+		break;
+	}
+	if (found && p_info)
+		p_info->status = status;
+}
+static int xen_pirq_get_free(void)
+{
+	int pirq = -EBUSY;
+	struct pirq_info *p_info = NULL;
+
+	if (!xen_hvm_domain())
+		return -ENODEV;
+
+	mutex_lock(&irq_mapping_update_lock);
+	list_for_each_entry(p_info, &xen_pirq_list_head, list) {
+		if (p_info->status == PIRQ_BUSY)
+			continue;
+		pirq = p_info->pirq;
+		break;
+	}
+	mutex_unlock(&irq_mapping_update_lock);
+	return pirq;
+}
+static void xen_pirq_clear_all(void)
+{
+	struct pirq_info *p_info = NULL, *tmp;
+
+	if (!xen_hvm_domain())
+		return;
+
+	list_for_each_entry_safe(p_info, tmp, &xen_pirq_list_head, list) {
+		/*
+		 * When migrating to a new host, the PT PCI devices _should_
+		 * be unplugged!
+		 */
+		WARN_ON(p_info->status == PIRQ_BUSY);
+		list_del(&p_info->list);
+		kfree(p_info);
+	}
+}
+#else
+static void xen_update_pirq_status(int pirq, enum xen_pirq_status status) { }
+static void xen_pirq_clear_all(void) { }
+#endif
+
 /* Get info for IRQ */
 static struct irq_info *info_for_irq(unsigned irq)
 {
@@ -222,6 +323,8 @@ static void xen_irq_info_pirq_init(unsigned irq,
 	info->u.pirq.gsi = gsi;
 	info->u.pirq.domid = domid;
 	info->u.pirq.flags = flags;
+
+	xen_update_pirq_status(pirq, PIRQ_BUSY);
 }
 
 /*
@@ -520,6 +622,12 @@ static void xen_free_irq(unsigned irq)
 	if (WARN_ON(!info))
 		return;
 
+	/*
+	 * Update the list of PIRQs (for PVHVM guests) that it is free.
+	 */
+	if (info->type == IRQT_PIRQ)
+		xen_update_pirq_status(info->u.pirq.pirq, PIRQ_FREE);
+
 	list_del(&info->list);
 
 	irq_set_handler_data(irq, NULL);
@@ -750,15 +858,22 @@ out:
 #ifdef CONFIG_PCI_MSI
 int xen_allocate_pirq_msi(struct pci_dev *dev, struct msi_desc *msidesc)
 {
-	int rc;
+	int rc, pirq;
 	struct physdev_get_free_pirq op_get_free_pirq;
 
+	pirq = xen_pirq_get_free();
+	if (pirq >= 0)
+		return pirq;
+
 	op_get_free_pirq.type = MAP_PIRQ_TYPE_MSI;
 	rc = HYPERVISOR_physdev_op(PHYSDEVOP_get_free_pirq, &op_get_free_pirq);
 
 	WARN_ONCE(rc == -ENOSYS,
 		  "hypervisor does not support the PHYSDEVOP_get_free_pirq interface\n");
 
+	if (rc == 0)
+		xen_pirq_add(op_get_free_pirq.pirq);
+
 	return rc ? -1 : op_get_free_pirq.pirq;
 }
 
@@ -1631,6 +1746,11 @@ static void restore_pirqs(void)
 
 		__startup_pirq(irq);
 	}
+
+	/* For PVHVM guests with PCI passthrough devices (that got unplugged
+	 * before the migrate) we MUST clear our cache.
+	 */
+	xen_pirq_clear_all();
 }
 
 static void restore_cpu_virqs(unsigned int cpu)
-- 
1.7.7.6

