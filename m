Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbaLJWaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:30:30 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:55772 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782AbaLJWa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:30:28 -0500
Date: Thu, 11 Dec 2014 09:30:12 +1100
From: Gavin Shan <gwshan@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Marek =?iso-8859-1?Q?Kord=EDk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Clear all bridge res MEM_64 if host bridge has non
 mem64
Message-ID: <20141210223012.GA11234@shangw>
Reply-To: Gavin Shan <gwshan@linux.vnet.ibm.com>
References: <1418160871-5605-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418160871-5605-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121022-0029-0000-0000-00000367F50A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 01:34:31PM -0800, Yinghai Lu wrote:
>So we could use bridge 64bit mem pref for children mem pref instead of
>forcing them into bridge mem.
>
>Could help Marek's system as his system is using _CRS, and all mem res is under
>4G.
>
>Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
>Reported-by: Marek Kordik <kordikmarek@gmail.com>
>Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
>Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
>---
> drivers/pci/host-bridge.c |    7 +++++++
> drivers/pci/pci.h         |    1 +
> drivers/pci/probe.c       |    9 +++++++++
> drivers/pci/setup-bus.c   |    3 +++
> include/linux/pci.h       |    1 +
> 5 files changed, 21 insertions(+)
>
>Index: linux-2.6/drivers/pci/host-bridge.c
>===================================================================
>--- linux-2.6.orig/drivers/pci/host-bridge.c
>+++ linux-2.6/drivers/pci/host-bridge.c
>@@ -31,6 +31,13 @@ void pci_set_host_bridge_release(struct
> 	bridge->release_data = release_data;
> }
>
>+bool pcibios_host_bridge_has_mem64_res(struct pci_bus *bus)
>+{
>+	struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
>+
>+	return bridge->has_mem64_res;
>+}
>+
> void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
> 			     struct resource *res)
> {
>Index: linux-2.6/drivers/pci/pci.h
>===================================================================
>--- linux-2.6.orig/drivers/pci/pci.h
>+++ linux-2.6/drivers/pci/pci.h
>@@ -196,6 +196,7 @@ enum pci_bar_type {
> 	pci_bar_mem64,		/* A 64-bit memory BAR */
> };
>
>+bool pcibios_host_bridge_has_mem64_res(struct pci_bus *bus);
> bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *pl,
> 				int crs_timeout);
> int pci_setup_device(struct pci_dev *dev);
>Index: linux-2.6/drivers/pci/probe.c
>===================================================================
>--- linux-2.6.orig/drivers/pci/probe.c
>+++ linux-2.6/drivers/pci/probe.c
>@@ -1980,6 +1980,15 @@ struct pci_bus *pci_create_root_bus(stru
> 		dev_info(&b->dev, "root bus resource %pR%s\n", res, bus_addr);
> 	}
>
>+	list_for_each_entry(window, &bridge->windows, list) {
>+		res = window->res;
>+		if (resource_type(res) == IORESOURCE_MEM ||
>+		    res->end > 0xffffffff) {

Should we replace "||" with "&&" ?

Thanks,
Gavin

>+			bridge->has_mem64_res = true;
>+			break;
>+		}
>+	}
>+
> 	down_write(&pci_bus_sem);
> 	list_add_tail(&b->node, &pci_root_buses);
> 	up_write(&pci_bus_sem);
>Index: linux-2.6/include/linux/pci.h
>===================================================================
>--- linux-2.6.orig/include/linux/pci.h
>+++ linux-2.6/include/linux/pci.h
>@@ -407,6 +407,7 @@ struct pci_host_bridge {
> 	struct list_head windows;	/* pci_host_bridge_windows */
> 	void (*release_fn)(struct pci_host_bridge *);
> 	void *release_data;
>+	bool has_mem64_res;
> };
>
> #define	to_pci_host_bridge(n) container_of(n, struct pci_host_bridge, dev)
>Index: linux-2.6/drivers/pci/setup-bus.c
>===================================================================
>--- linux-2.6.orig/drivers/pci/setup-bus.c
>+++ linux-2.6/drivers/pci/setup-bus.c
>@@ -693,6 +693,9 @@ static void pci_bridge_check_ranges(stru
> 		}
> 	}
>
>+        if (!pcibios_host_bridge_has_mem64_res(bus))
>+                b_res[2].flags &= ~IORESOURCE_MEM_64;
>+
> 	/* double check if bridge does support 64 bit pref */
> 	if (b_res[2].flags & IORESOURCE_MEM_64) {
> 		u32 mem_base_hi, tmp;
>

