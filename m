Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3EJSyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 14:54:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41437 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3EJSyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 14:54:02 -0400
Date: Fri, 10 May 2013 14:53:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yuval Shaia <yuval.shaia@oracle.com>,
        Feng Jin <joe.jin@oracle.com>, Chien Yen <chien.yen@oracle.com>
Subject: Re: [PATCH] xen: reuse the same pirq allocated when driver load
 first time
Message-ID: <20130510185339.GD2562@phenom.dumpdata.com>
References: <518A0A50.1020705@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <518A0A50.1020705@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 04:18:24PM +0800, Zhenzhong Duan wrote:
> When driver load and unload in a loop, pirq will exhaust finally.
> Try to use the same pirq which was already mapped and binded at first time

So what happens if I unload and reload two drivers in random order?

> when driver loaded.
> 
> Read pirq from msix entry and test if data is XEN_PIRQ_MSI_DATA
> xen_irq_from_pirq(pirq) < 0 checking is wrong as irq will be freed
> when driver unload, it's always true in second load.

If my understanding is right the issue at hand is that the caching
information about the pirq disappears once the driver has been
unloaded b/c the event's irq-info is removed (as the driver is
unloaded and free_irq is called).

Stefano,
Is there a specific write to the MSI structure that would cause the
hypervisor to drop the PIRQ? Or a nice hypercall to "free" an
PIRQ in usage?

I presume that on the first load the msg.data value is
ALWAYS != XEN_PIRQ_MSI_DATA right? Is that somethign we can ALWAYS
depend? Or is there a possibility that it could be that when the
PCI device is unplugged from one guest and plugged in another?

Could we use PHYSDEVOP_irq_status_query to figure out if the PIRQ
has been already allocated? Ah, does not look like it.

I am a bit worried about depending on just msg.data to tells us
whether the device had been initialized before.

Perhaps a different solution could be to utilize the
'xen_device_domain_owner' code. See attached patch (not
compile tested) to retain whether we had initialized this
device in the past and we can skip the hypercall.

On a second thought it could also use some extra checks
to make sure that the pirq that would be used on the second
run is the same as on the first one.

> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Tested-by: Yuval Shaia <yuval.shaia@oracle.com>
> ---
>  arch/x86/pci/xen.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 94e7662..4289eef 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -230,8 +230,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>  		__read_msi_msg(msidesc, &msg);
>  		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
>  			((msg.address_lo >> MSI_ADDR_DEST_ID_SHIFT) & 0xff);
> -		if (msg.data != XEN_PIRQ_MSI_DATA ||
> -		    xen_irq_from_pirq(pirq) < 0) {
> +		if (msg.data != XEN_PIRQ_MSI_DATA) {

>  			if (pirq < 0) {
>  				irq = -ENODEV;
> -- 
> 1.7.3
> 

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="use-xen-device-domain-owner.patch"

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 56ab749..0150bc9 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -225,7 +225,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
 			((msg.address_lo >> MSI_ADDR_DEST_ID_SHIFT) & 0xff);
 		if (msg.data != XEN_PIRQ_MSI_DATA ||
-		    xen_irq_from_pirq(pirq) < 0) {
+		    xen_device_pirq_alloced(dev)) {
 			pirq = xen_allocate_pirq_msi(dev, msidesc);
 			if (pirq < 0) {
 				irq = -ENODEV;
@@ -234,6 +234,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 			xen_msi_compose_msg(dev, pirq, &msg);
 			__write_msi_msg(msidesc, &msg);
 			dev_dbg(&dev->dev, "xen: msi bound to pirq=%d\n", pirq);
+			xen_device_allocated(dev);
 		} else {
 			dev_dbg(&dev->dev,
 				"xen: msi already bound to pirq=%d\n", pirq);
@@ -500,6 +501,7 @@ int __init pci_xen_initial_domain(void)
 
 struct xen_device_domain_owner {
 	domid_t domain;
+	bool used;
 	struct pci_dev *dev;
 	struct list_head list;
 };
@@ -570,4 +572,32 @@ int xen_unregister_device_domain_owner(struct pci_dev *dev)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xen_unregister_device_domain_owner);
+
+int xen_device_allocated(struct pci_dev *dev)
+{
+	struct xen_device_domain_owner *owner;
+
+	int rc = xen_register_device_domain_owner(dev, DOMID_SELF);
+	if (rc)
+		return rc;
+
+	spin_lock(&dev_domain_list_spinlock);
+	owner = find_device(dev);
+	if (owner)
+		owner->used = true;
+	spin_unlock(&dev_domain_list_spinlock);
+	return 0;
+}
+bool xen_device_pirq_alloced(struct pci_dev *dev)
+{
+	struct xen_device_domain_owner *owner;
+	bool rc = false;
+
+	spin_lock(&dev_domain_list_spinlock);
+	owner = find_device(dev);
+	if (owner && owner->used)
+		rc = true;
+	spin_unlock(&dev_domain_list_spinlock);
+	return rc;
+}
 #endif

--VbJkn9YxBvnuCH5J--
