Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbaAGAzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:55:49 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:63670 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540AbaAGAzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:55:44 -0500
Subject: [PATCH v7 04/15] agp: Support 64-bit APBASE
To: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 17:55:40 -0700
Message-ID: <20140107005540.10786.65852.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per the AGP 3.0 spec, APBASE is a standard PCI BAR and may be either 32
bits or 64 bits wide.  Many drivers read APBASE directly, but they only
handled 32-bit BARs.

The PCI core reads APBASE at enumeration-time.  Use pci_bus_address()
instead of reading it again in the driver.  This works correctly for both
32-bit and 64-bit BARs.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/char/agp/agp.h          |    1 +
 drivers/char/agp/ali-agp.c      |    4 ++-
 drivers/char/agp/amd-k7-agp.c   |    6 ++---
 drivers/char/agp/amd64-agp.c    |    5 +---
 drivers/char/agp/ati-agp.c      |    9 +++----
 drivers/char/agp/efficeon-agp.c |    5 ++--
 drivers/char/agp/generic.c      |    4 ++-
 drivers/char/agp/intel-agp.c    |   48 ++++++++++++++++-----------------------
 drivers/char/agp/nvidia-agp.c   |    5 ++--
 drivers/char/agp/sis-agp.c      |    5 ++--
 drivers/char/agp/via-agp.c      |   13 +++++------
 11 files changed, 44 insertions(+), 61 deletions(-)

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index 923f99df4f1c..b709749c8639 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -239,6 +239,7 @@ long compat_agp_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 /* Chipset independent registers (from AGP Spec) */
 #define AGP_APBASE	0x10
+#define AGP_APERTURE_BAR	0
 
 #define AGPSTAT		0x4
 #define AGPCMD		0x8
diff --git a/drivers/char/agp/ali-agp.c b/drivers/char/agp/ali-agp.c
index 443cd6751ca2..19db03667650 100644
--- a/drivers/char/agp/ali-agp.c
+++ b/drivers/char/agp/ali-agp.c
@@ -85,8 +85,8 @@ static int ali_configure(void)
 	pci_write_config_dword(agp_bridge->dev, ALI_TLBCTRL, ((temp & 0xffffff00) | 0x00000010));
 
 	/* address to map to */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 #if 0
 	if (agp_bridge->type == ALI_M1541) {
diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index 779f0ab845a9..9898ed6d5b9a 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -126,7 +126,6 @@ static int amd_create_gatt_table(struct agp_bridge_data *bridge)
 	unsigned long __iomem *cur_gatt;
 	unsigned long addr;
 	int retval;
-	u32 temp;
 	int i;
 
 	value = A_SIZE_LVL2(agp_bridge->current_size);
@@ -149,9 +148,8 @@ static int amd_create_gatt_table(struct agp_bridge_data *bridge)
 	 * used to program the agp master not the cpu
 	 */
 
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
-	agp_bridge->gart_bus_addr = addr;
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 	/* Calculate the agp offset */
 	for (i = 0; i < value->num_entries / 1024; i++, addr += 0x00400000) {
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index d79d692d05b8..95326ac610f6 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -269,7 +269,6 @@ static int agp_aperture_valid(u64 aper, u32 size)
  */
 static int fix_northbridge(struct pci_dev *nb, struct pci_dev *agp, u16 cap)
 {
-	u32 aper_low, aper_hi;
 	u64 aper, nb_aper;
 	int order = 0;
 	u32 nb_order, nb_base;
@@ -295,9 +294,7 @@ static int fix_northbridge(struct pci_dev *nb, struct pci_dev *agp, u16 cap)
 		apsize |= 0xf00;
 	order = 7 - hweight16(apsize);
 
-	pci_read_config_dword(agp, 0x10, &aper_low);
-	pci_read_config_dword(agp, 0x14, &aper_hi);
-	aper = (aper_low & ~((1<<22)-1)) | ((u64)aper_hi << 32);
+	aper = pci_bus_address(agp, AGP_APERTURE_BAR);
 
 	/*
 	 * On some sick chips APSIZE is 0. This means it wants 4G
diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index 03c1dc1ab552..53cb310d433e 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -211,10 +211,10 @@ static int ati_configure(void)
 	else
 		pci_write_config_dword(agp_bridge->dev, ATI_RS300_IG_AGPMODE, 0x20000);
 
-	/* address to map too */
+	/* address to map to */
 	/*
-	pci_read_config_dword(agp_bridge.dev, AGP_APBASE, &temp);
-	agp_bridge.gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	agp_bridge.gart_bus_addr = pci_bus_address(agp_bridge.dev,
+						   AGP_APERTURE_BAR);
 	printk(KERN_INFO PFX "IGP320 gart_bus_addr: %x\n", agp_bridge.gart_bus_addr);
 	*/
 	writel(0x60000, ati_generic_private.registers+ATI_GART_FEATURE_ID);
@@ -385,8 +385,7 @@ static int ati_create_gatt_table(struct agp_bridge_data *bridge)
 	 * This is a bus address even on the alpha, b/c its
 	 * used to program the agp master not the cpu
 	 */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	addr = pci_bus_address(agp_bridge->dev, AGP_APERTURE_BAR);
 	agp_bridge->gart_bus_addr = addr;
 
 	/* Calculate the agp offset */
diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index 6974d5032053..533cb6d229b8 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -128,7 +128,6 @@ static void efficeon_cleanup(void)
 
 static int efficeon_configure(void)
 {
-	u32 temp;
 	u16 temp2;
 	struct aper_size_info_lvl2 *current_size;
 
@@ -141,8 +140,8 @@ static int efficeon_configure(void)
 			      current_size->size_value);
 
 	/* address to map to */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 	/* agpctrl */
 	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x2280);
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index a0df182f6f7d..f39437addb58 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1396,8 +1396,8 @@ int agp3_generic_configure(void)
 
 	current_size = A_SIZE_16(agp_bridge->current_size);
 
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 	/* set aperture size */
 	pci_write_config_word(agp_bridge->dev, agp_bridge->capndx+AGPAPSIZE, current_size->size_value);
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index a426ee1f57a6..a7c276585a9f 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -118,7 +118,6 @@ static void intel_8xx_cleanup(void)
 
 static int intel_configure(void)
 {
-	u32 temp;
 	u16 temp2;
 	struct aper_size_info_16 *current_size;
 
@@ -128,8 +127,8 @@ static int intel_configure(void)
 	pci_write_config_word(agp_bridge->dev, INTEL_APSIZE, current_size->size_value);
 
 	/* address to map to */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 	/* attbase - aperture base */
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, agp_bridge->gatt_bus_addr);
@@ -148,7 +147,7 @@ static int intel_configure(void)
 
 static int intel_815_configure(void)
 {
-	u32 temp, addr;
+	u32 addr;
 	u8 temp2;
 	struct aper_size_info_8 *current_size;
 
@@ -167,8 +166,8 @@ static int intel_815_configure(void)
 			current_size->size_value);
 
 	/* address to map to */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 	pci_read_config_dword(agp_bridge->dev, INTEL_ATTBASE, &addr);
 	addr &= INTEL_815_ATTBASE_MASK;
@@ -208,7 +207,6 @@ static void intel_820_cleanup(void)
 
 static int intel_820_configure(void)
 {
-	u32 temp;
 	u8 temp2;
 	struct aper_size_info_8 *current_size;
 
@@ -218,8 +216,8 @@ static int intel_820_configure(void)
 	pci_write_config_byte(agp_bridge->dev, INTEL_APSIZE, current_size->size_value);
 
 	/* address to map to */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 	/* attbase - aperture base */
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, agp_bridge->gatt_bus_addr);
@@ -239,7 +237,6 @@ static int intel_820_configure(void)
 
 static int intel_840_configure(void)
 {
-	u32 temp;
 	u16 temp2;
 	struct aper_size_info_8 *current_size;
 
@@ -249,8 +246,8 @@ static int intel_840_configure(void)
 	pci_write_config_byte(agp_bridge->dev, INTEL_APSIZE, current_size->size_value);
 
 	/* address to map to */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 	/* attbase - aperture base */
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, agp_bridge->gatt_bus_addr);
@@ -268,7 +265,6 @@ static int intel_840_configure(void)
 
 static int intel_845_configure(void)
 {
-	u32 temp;
 	u8 temp2;
 	struct aper_size_info_8 *current_size;
 
@@ -282,9 +278,9 @@ static int intel_845_configure(void)
 				       agp_bridge->apbase_config);
 	} else {
 		/* address to map to */
-		pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-		agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
-		agp_bridge->apbase_config = temp;
+		agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+							    AGP_APERTURE_BAR);
+		agp_bridge->apbase_config = agp_bridge->gart_bus_addr;
 	}
 
 	/* attbase - aperture base */
@@ -303,7 +299,6 @@ static int intel_845_configure(void)
 
 static int intel_850_configure(void)
 {
-	u32 temp;
 	u16 temp2;
 	struct aper_size_info_8 *current_size;
 
@@ -313,8 +308,8 @@ static int intel_850_configure(void)
 	pci_write_config_byte(agp_bridge->dev, INTEL_APSIZE, current_size->size_value);
 
 	/* address to map to */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 	/* attbase - aperture base */
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, agp_bridge->gatt_bus_addr);
@@ -332,7 +327,6 @@ static int intel_850_configure(void)
 
 static int intel_860_configure(void)
 {
-	u32 temp;
 	u16 temp2;
 	struct aper_size_info_8 *current_size;
 
@@ -342,8 +336,8 @@ static int intel_860_configure(void)
 	pci_write_config_byte(agp_bridge->dev, INTEL_APSIZE, current_size->size_value);
 
 	/* address to map to */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 	/* attbase - aperture base */
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, agp_bridge->gatt_bus_addr);
@@ -361,7 +355,6 @@ static int intel_860_configure(void)
 
 static int intel_830mp_configure(void)
 {
-	u32 temp;
 	u16 temp2;
 	struct aper_size_info_8 *current_size;
 
@@ -371,8 +364,8 @@ static int intel_830mp_configure(void)
 	pci_write_config_byte(agp_bridge->dev, INTEL_APSIZE, current_size->size_value);
 
 	/* address to map to */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 	/* attbase - aperture base */
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, agp_bridge->gatt_bus_addr);
@@ -390,7 +383,6 @@ static int intel_830mp_configure(void)
 
 static int intel_7505_configure(void)
 {
-	u32 temp;
 	u16 temp2;
 	struct aper_size_info_8 *current_size;
 
@@ -400,8 +392,8 @@ static int intel_7505_configure(void)
 	pci_write_config_byte(agp_bridge->dev, INTEL_APSIZE, current_size->size_value);
 
 	/* address to map to */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 	/* attbase - aperture base */
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, agp_bridge->gatt_bus_addr);
diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
index be42a2312dc9..ab65d55272c4 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -115,9 +115,8 @@ static int nvidia_configure(void)
 	pci_write_config_byte(agp_bridge->dev, NVIDIA_0_APSIZE,
 		current_size->size_value);
 
-    /* address to map to */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &apbase);
-	apbase &= PCI_BASE_ADDRESS_MEM_MASK;
+	/* address to map to */
+	apbase = pci_bus_address(agp_bridge->dev, AGP_APERTURE_BAR);
 	agp_bridge->gart_bus_addr = apbase;
 	aplimit = apbase + (current_size->size * 1024 * 1024) - 1;
 	pci_write_config_dword(nvidia_private.dev_2, NVIDIA_2_APBASE, apbase);
diff --git a/drivers/char/agp/sis-agp.c b/drivers/char/agp/sis-agp.c
index 79c838c434bc..2c74038da459 100644
--- a/drivers/char/agp/sis-agp.c
+++ b/drivers/char/agp/sis-agp.c
@@ -50,13 +50,12 @@ static void sis_tlbflush(struct agp_memory *mem)
 
 static int sis_configure(void)
 {
-	u32 temp;
 	struct aper_size_info_8 *current_size;
 
 	current_size = A_SIZE_8(agp_bridge->current_size);
 	pci_write_config_byte(agp_bridge->dev, SIS_TLBCNTRL, 0x05);
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 	pci_write_config_dword(agp_bridge->dev, SIS_ATTBASE,
 			       agp_bridge->gatt_bus_addr);
 	pci_write_config_byte(agp_bridge->dev, SIS_APSIZE,
diff --git a/drivers/char/agp/via-agp.c b/drivers/char/agp/via-agp.c
index 74d3aa3773bf..228f20cddc05 100644
--- a/drivers/char/agp/via-agp.c
+++ b/drivers/char/agp/via-agp.c
@@ -43,16 +43,15 @@ static int via_fetch_size(void)
 
 static int via_configure(void)
 {
-	u32 temp;
 	struct aper_size_info_8 *current_size;
 
 	current_size = A_SIZE_8(agp_bridge->current_size);
 	/* aperture size */
 	pci_write_config_byte(agp_bridge->dev, VIA_APSIZE,
 			      current_size->size_value);
-	/* address to map too */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	/* address to map to */
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 	/* GART control register */
 	pci_write_config_dword(agp_bridge->dev, VIA_GARTCTRL, 0x0000000f);
@@ -132,9 +131,9 @@ static int via_configure_agp3(void)
 
 	current_size = A_SIZE_16(agp_bridge->current_size);
 
-	/* address to map too */
-	pci_read_config_dword(agp_bridge->dev, AGP_APBASE, &temp);
-	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
+	/* address to map to */
+	agp_bridge->gart_bus_addr = pci_bus_address(agp_bridge->dev,
+						    AGP_APERTURE_BAR);
 
 	/* attbase - aperture GATT base */
 	pci_write_config_dword(agp_bridge->dev, VIA_AGP3_ATTBASE,

