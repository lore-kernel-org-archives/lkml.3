Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbbAOLKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:10:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbbAOLK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:10:29 -0500
Message-ID: <54B7A021.90101@suse.de>
Date: Thu, 15 Jan 2015 12:10:25 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>,
        alvise rigo <a.rigo@virtualopensystems.com>
Subject: Re: [PATCH] pci: generic host: make it more generic
References: <1415702040-2790-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1415702040-2790-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.11.14 11:33, Ming Lei wrote:
> This patch converts the generic host controller driver
> into a more generic one, and basically don't need
> platform's pcibios support, and use DT based generic
> APIs to parse resource and remap IO port.
> 
> This patch has been tested on both ARMv7 and ARMv8
> VM, and in theroy it should support other ARCHs too.
> 
> With this patch, virtio PCI block, network and scsi devices
> can work well on ARMv7 and ARMv8 VM.
> 
> QEMU needs below patches for runing the test:
> 
> - Rob Herring's "Add generic PCI host device" patches
> 	http://lists.gnu.org/archive/html/qemu-devel/2014-06/msg03482.html
> 	http://lists.gnu.org/archive/html/qemu-devel/2014-06/msg03483.html
> - Alvise Rigo's "Add Generic PCI host device update"
> 	http://marc.info/?l=qemu-devel&m=140506329920172&w=2
> 
> For ARMv8, cpu model of "host" and "cortex-a57" is missed
> in Alvise Rigo's patchset, otherwise ARM64 VM can't boot.
> 
> All these QEMU patches can be found in below tree:
> 
> 	http://kernel.ubuntu.com/git?p=ming/qemu.git;a=shortlog;h=refs/heads/arm64-pci-test
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/pci/host/Kconfig            |    2 +-
>  drivers/pci/host/pci-host-generic.c |  196 +++++++++++------------------------
>  2 files changed, 63 insertions(+), 135 deletions(-)
> 
> diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
> index 3dc25fa..885034d 100644
> --- a/drivers/pci/host/Kconfig
> +++ b/drivers/pci/host/Kconfig
> @@ -50,7 +50,7 @@ config PCI_RCAR_GEN2_PCIE
>  
>  config PCI_HOST_GENERIC
>  	bool "Generic PCI host controller"
> -	depends on ARM && OF
> +	depends on OF
>  	help
>  	  Say Y here if you want to support a simple generic PCI host
>  	  controller, such as the one emulated by kvmtool.
> diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
> index 3d2076f..00d0ca3 100644
> --- a/drivers/pci/host/pci-host-generic.c
> +++ b/drivers/pci/host/pci-host-generic.c
> @@ -44,12 +44,14 @@ struct gen_pci {
>  	struct list_head			resources;
>  };
>  
> +/* fake sysdata for cheating ARCH's pcibios code */
> +static char	gen_sysdata[256];
> +
>  static void __iomem *gen_pci_map_cfg_bus_cam(struct pci_bus *bus,
>  					     unsigned int devfn,
>  					     int where)
>  {
> -	struct pci_sys_data *sys = bus->sysdata;
> -	struct gen_pci *pci = sys->private_data;
> +	struct gen_pci *pci = dev_get_drvdata(bus->dev.parent->parent);

Just as a heads up, this breaks when you have PCI bridges in between. In
that case you need something like the ugly patch below on top.


Alex


diff --git a/drivers/pci/host/pci-host-generic.c
b/drivers/pci/host/pci-host-generic.c
index e580296..730a07b 100644
--- a/drivers/pci/host/pci-host-generic.c
+++ b/drivers/pci/host/pci-host-generic.c
@@ -47,11 +47,26 @@ struct gen_pci {
 /* fake sysdata for cheating ARCH's pcibios code */
 static char	gen_sysdata[256];

+static struct gen_pci *gen_pci_get_drvdata(struct pci_bus *bus)
+{
+	struct device *dev = bus->dev.parent->parent;
+	struct gen_pci *pci;
+
+	while (dev) {
+		pci = dev_get_drvdata(dev);
+		if (pci)
+			return pci;
+		dev = dev->parent;
+	}
+
+	return NULL;
+}
+
 static void __iomem *gen_pci_map_cfg_bus_cam(struct pci_bus *bus,
 					     unsigned int devfn,
 					     int where)
 {
-	struct gen_pci *pci = dev_get_drvdata(bus->dev.parent->parent);
+	struct gen_pci *pci = gen_pci_get_drvdata(bus);
 	resource_size_t idx = bus->number - pci->cfg.bus_range.start;

 	return pci->cfg.win[idx] + ((devfn << 8) | where);
@@ -66,7 +81,7 @@ static void __iomem *gen_pci_map_cfg_bus_ecam(struct
pci_bus *bus,
 					      unsigned int devfn,
 					      int where)
 {
-	struct gen_pci *pci = dev_get_drvdata(bus->dev.parent->parent);
+	struct gen_pci *pci = gen_pci_get_drvdata(bus);
 	resource_size_t idx = bus->number - pci->cfg.bus_range.start;

 	return pci->cfg.win[idx] + ((devfn << 12) | where);
@@ -81,7 +96,11 @@ static int gen_pci_config_read(struct pci_bus *bus,
unsigned int devfn,
 				int where, int size, u32 *val)
 {
 	void __iomem *addr;
-	struct gen_pci *pci = dev_get_drvdata(bus->dev.parent->parent);
+	struct gen_pci *pci = gen_pci_get_drvdata(bus);
+
+	WARN_ON(!pci);
+	if (!pci)
+		return PCIBIOS_DEVICE_NOT_FOUND;

 	addr = pci->cfg.ops->map_bus(bus, devfn, where);

@@ -103,7 +122,11 @@ static int gen_pci_config_write(struct pci_bus
*bus, unsigned int devfn,
 				 int where, int size, u32 val)
 {
 	void __iomem *addr;
-	struct gen_pci *pci = dev_get_drvdata(bus->dev.parent->parent);
+	struct gen_pci *pci = gen_pci_get_drvdata(bus);
+
+	WARN_ON(!pci);
+	if (!pci)
+		return PCIBIOS_DEVICE_NOT_FOUND;

 	addr = pci->cfg.ops->map_bus(bus, devfn, where);

