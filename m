Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab3CTT73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 15:59:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55226 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754361Ab3CTT7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 15:59:24 -0400
Message-ID: <1363809549.31336.74.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 3.2.41
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 20 Mar 2013 19:59:09 +0000
In-Reply-To: <1363809494.31336.73.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KNIAM2L7ogjOP1DcqMQi"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 82.69.69.95
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KNIAM2L7ogjOP1DcqMQi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/devicetree/bindings/tty/serial/of-serial.txt b/D=
ocumentation/devicetree/bindings/tty/serial/of-serial.txt
index b8b27b0..3f89cbd 100644
--- a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
+++ b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
@@ -10,6 +10,9 @@ Required properties:
 	- "ns16850"
 	- "nvidia,tegra20-uart"
 	- "ibm,qpace-nwp-serial"
+	- "altr,16550-FIFO32"
+	- "altr,16550-FIFO64"
+	- "altr,16550-FIFO128"
 	- "serial" if the port type is unknown.
 - reg : offset and length of the register set for the device.
 - interrupts : should contain uart interrupt.
diff --git a/Makefile b/Makefile
index 47af1e9..95e6220 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 40
+SUBLEVEL =3D 41
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v=
7.c
index 1049319..510456d 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -720,7 +720,7 @@ static const unsigned armv7_a15_perf_cache_map[PERF_COU=
NT_HW_CACHE_MAX]
 /*
  * PMXEVTYPER: Event selection reg
  */
-#define	ARMV7_EVTYPE_MASK	0xc00000ff	/* Mask for writable bits */
+#define	ARMV7_EVTYPE_MASK	0xc80000ff	/* Mask for writable bits */
 #define	ARMV7_EVTYPE_EVENT	0xff		/* Mask for EVENT bits */
=20
 /*
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index c335c76..a125c4b 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -749,7 +749,6 @@ do_alignment(unsigned long addr, unsigned int fsr, stru=
ct pt_regs *regs)
 	unsigned long instr =3D 0, instrptr;
 	int (*handler)(unsigned long addr, unsigned long instr, struct pt_regs *r=
egs);
 	unsigned int type;
-	mm_segment_t fs;
 	unsigned int fault;
 	u16 tinstr =3D 0;
 	int isize =3D 4;
@@ -760,16 +759,15 @@ do_alignment(unsigned long addr, unsigned int fsr, st=
ruct pt_regs *regs)
=20
 	instrptr =3D instruction_pointer(regs);
=20
-	fs =3D get_fs();
-	set_fs(KERNEL_DS);
 	if (thumb_mode(regs)) {
-		fault =3D __get_user(tinstr, (u16 *)(instrptr & ~1));
+		u16 *ptr =3D (u16 *)(instrptr & ~1);
+		fault =3D probe_kernel_address(ptr, tinstr);
 		if (!fault) {
 			if (cpu_architecture() >=3D CPU_ARCH_ARMv7 &&
 			    IS_T32(tinstr)) {
 				/* Thumb-2 32-bit */
 				u16 tinst2 =3D 0;
-				fault =3D __get_user(tinst2, (u16 *)(instrptr+2));
+				fault =3D probe_kernel_address(ptr + 1, tinst2);
 				instr =3D (tinstr << 16) | tinst2;
 				thumb2_32b =3D 1;
 			} else {
@@ -778,8 +776,7 @@ do_alignment(unsigned long addr, unsigned int fsr, stru=
ct pt_regs *regs)
 			}
 		}
 	} else
-		fault =3D __get_user(instr, (u32 *)instrptr);
-	set_fs(fs);
+		fault =3D probe_kernel_address(instrptr, instr);
=20
 	if (fault) {
 		type =3D TYPE_FAULT;
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 7c815b2..111691c 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -409,7 +409,7 @@ void VFP_bounce(u32 trigger, u32 fpexc, struct pt_regs =
*regs)
 	 * If there isn't a second FP instruction, exit now. Note that
 	 * the FPEXC.FP2V bit is valid only if FPEXC.EX is 1.
 	 */
-	if (fpexc ^ (FPEXC_EX | FPEXC_FP2V))
+	if ((fpexc & (FPEXC_EX | FPEXC_FP2V)) !=3D (FPEXC_EX | FPEXC_FP2V))
 		goto exit;
=20
 	/*
diff --git a/arch/powerpc/include/asm/eeh.h b/arch/powerpc/include/asm/eeh.=
h
index 21165a4..66ea9b8 100644
--- a/arch/powerpc/include/asm/eeh.h
+++ b/arch/powerpc/include/asm/eeh.h
@@ -61,7 +61,6 @@ void __init pci_addr_cache_build(void);
  */
 void eeh_add_device_tree_early(struct device_node *);
 void eeh_add_device_tree_late(struct pci_bus *);
-void eeh_add_sysfs_files(struct pci_bus *);
=20
 /**
  * eeh_remove_device_recursive - undo EEH for device & children.
@@ -106,8 +105,6 @@ static inline void eeh_add_device_tree_early(struct dev=
ice_node *dn) { }
=20
 static inline void eeh_add_device_tree_late(struct pci_bus *bus) { }
=20
-static inline void eeh_add_sysfs_files(struct pci_bus *bus) { }
-
 static inline void eeh_remove_bus_device(struct pci_dev *dev) { }
 #define EEH_POSSIBLE_ERROR(val, type) (0)
 #define EEH_IO_ERROR_VALUE(size) (-1UL)
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_pla=
tform.c
index b10beef..e1612df 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -91,9 +91,6 @@ static int __devinit of_pci_phb_probe(struct platform_dev=
ice *dev)
 	/* Add probed PCI devices to the device model */
 	pci_bus_add_devices(phb->bus);
=20
-	/* sysfs files should only be added after devices are added */
-	eeh_add_sysfs_files(phb->bus);
-
 	return 0;
 }
=20
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-com=
mon.c
index a3cd949..458ed3b 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1536,14 +1536,11 @@ void pcibios_finish_adding_to_bus(struct pci_bus *b=
us)
 	pcibios_allocate_bus_resources(bus);
 	pcibios_claim_one_bus(bus);
=20
-	/* Fixup EEH */
-	eeh_add_device_tree_late(bus);
-
 	/* Add new devices to global lists.  Register in proc, sysfs. */
 	pci_bus_add_devices(bus);
=20
-	/* sysfs files should only be added after devices are added */
-	eeh_add_sysfs_files(bus);
+	/* Fixup EEH */
+	eeh_add_device_tree_late(bus);
 }
 EXPORT_SYMBOL_GPL(pcibios_finish_adding_to_bus);
=20
diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/=
pseries/eeh.c
index 389e06b..5658690 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -1238,6 +1238,7 @@ static void eeh_add_device_late(struct pci_dev *dev)
 	pdn->pcidev =3D dev;
=20
 	pci_addr_cache_insert_device(dev);
+	eeh_sysfs_add_device(dev);
 }
=20
 void eeh_add_device_tree_late(struct pci_bus *bus)
@@ -1256,29 +1257,6 @@ void eeh_add_device_tree_late(struct pci_bus *bus)
 EXPORT_SYMBOL_GPL(eeh_add_device_tree_late);
=20
 /**
- * eeh_add_sysfs_files - Add EEH sysfs files for the indicated PCI bus
- * @bus: PCI bus
- *
- * This routine must be used to add EEH sysfs files for PCI
- * devices which are attached to the indicated PCI bus. The PCI bus
- * is added after system boot through hotplug or dlpar.
- */
-void eeh_add_sysfs_files(struct pci_bus *bus)
-{
-	struct pci_dev *dev;
-
-	list_for_each_entry(dev, &bus->devices, bus_list) {
-		eeh_sysfs_add_device(dev);
-		if (dev->hdr_type =3D=3D PCI_HEADER_TYPE_BRIDGE) {
-			struct pci_bus *subbus =3D dev->subordinate;
-			if (subbus)
-				eeh_add_sysfs_files(subbus);
-		}
-	}
-}
-EXPORT_SYMBOL_GPL(eeh_add_sysfs_files);
-
-/**
  * eeh_remove_device - undo EEH setup for the indicated pci device
  * @dev: pci device to be removed
  *
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 4c262f6..1e1caf56 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -162,6 +162,9 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int =
nvec, int type)
 	struct msi_desc *msidesc;
 	int *v;
=20
+	if (type =3D=3D PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
+
 	v =3D kzalloc(sizeof(int) * max(1, nvec), GFP_KERNEL);
 	if (!v)
 		return -ENOMEM;
@@ -220,6 +223,9 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, =
int nvec, int type)
 	struct msi_desc *msidesc;
 	struct msi_msg msg;
=20
+	if (type =3D=3D PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
+
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		__read_msi_msg(msidesc, &msg);
 		pirq =3D MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
@@ -263,6 +269,9 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *d=
ev, int nvec, int type)
 	int ret =3D 0;
 	struct msi_desc *msidesc;
=20
+	if (type =3D=3D PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
+
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		struct physdev_map_pirq map_irq;
 		domid_t domid;
diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index a0f768c..9f73037 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -388,9 +388,9 @@ static int crypto_ablkcipher_report(struct sk_buff *skb=
, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
=20
-	snprintf(rblkcipher.type, CRYPTO_MAX_ALG_NAME, "%s", "ablkcipher");
-	snprintf(rblkcipher.geniv, CRYPTO_MAX_ALG_NAME, "%s",
-		 alg->cra_ablkcipher.geniv ?: "<default>");
+	strncpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
+	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
+		sizeof(rblkcipher.geniv));
=20
 	rblkcipher.blocksize =3D alg->cra_blocksize;
 	rblkcipher.min_keysize =3D alg->cra_ablkcipher.min_keysize;
@@ -469,9 +469,9 @@ static int crypto_givcipher_report(struct sk_buff *skb,=
 struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
=20
-	snprintf(rblkcipher.type, CRYPTO_MAX_ALG_NAME, "%s", "givcipher");
-	snprintf(rblkcipher.geniv, CRYPTO_MAX_ALG_NAME, "%s",
-		 alg->cra_ablkcipher.geniv ?: "<built-in>");
+	strncpy(rblkcipher.type, "givcipher", sizeof(rblkcipher.type));
+	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<built-in>",
+		sizeof(rblkcipher.geniv));
=20
 	rblkcipher.blocksize =3D alg->cra_blocksize;
 	rblkcipher.min_keysize =3D alg->cra_ablkcipher.min_keysize;
diff --git a/crypto/aead.c b/crypto/aead.c
index 04add3dc..479b7d1 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -117,9 +117,8 @@ static int crypto_aead_report(struct sk_buff *skb, stru=
ct crypto_alg *alg)
 	struct crypto_report_aead raead;
 	struct aead_alg *aead =3D &alg->cra_aead;
=20
-	snprintf(raead.type, CRYPTO_MAX_ALG_NAME, "%s", "aead");
-	snprintf(raead.geniv, CRYPTO_MAX_ALG_NAME, "%s",
-		 aead->geniv ?: "<built-in>");
+	strncpy(raead.type, "aead", sizeof(raead.type));
+	strncpy(raead.geniv, aead->geniv ?: "<built-in>", sizeof(raead.geniv));
=20
 	raead.blocksize =3D alg->cra_blocksize;
 	raead.maxauthsize =3D aead->maxauthsize;
@@ -203,8 +202,8 @@ static int crypto_nivaead_report(struct sk_buff *skb, s=
truct crypto_alg *alg)
 	struct crypto_report_aead raead;
 	struct aead_alg *aead =3D &alg->cra_aead;
=20
-	snprintf(raead.type, CRYPTO_MAX_ALG_NAME, "%s", "nivaead");
-	snprintf(raead.geniv, CRYPTO_MAX_ALG_NAME, "%s", aead->geniv);
+	strncpy(raead.type, "nivaead", sizeof(raead.type));
+	strncpy(raead.geniv, aead->geniv, sizeof(raead.geniv));
=20
 	raead.blocksize =3D alg->cra_blocksize;
 	raead.maxauthsize =3D aead->maxauthsize;
diff --git a/crypto/ahash.c b/crypto/ahash.c
index ac93c99..7fe1752 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -404,7 +404,7 @@ static int crypto_ahash_report(struct sk_buff *skb, str=
uct crypto_alg *alg)
 {
 	struct crypto_report_hash rhash;
=20
-	snprintf(rhash.type, CRYPTO_MAX_ALG_NAME, "%s", "ahash");
+	strncpy(rhash.type, "ahash", sizeof(rhash.type));
=20
 	rhash.blocksize =3D alg->cra_blocksize;
 	rhash.digestsize =3D __crypto_hash_alg_common(alg)->digestsize;
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 1e61d1a..04f0f38 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -499,9 +499,9 @@ static int crypto_blkcipher_report(struct sk_buff *skb,=
 struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
=20
-	snprintf(rblkcipher.type, CRYPTO_MAX_ALG_NAME, "%s", "blkcipher");
-	snprintf(rblkcipher.geniv, CRYPTO_MAX_ALG_NAME, "%s",
-		 alg->cra_blkcipher.geniv ?: "<default>");
+	strncpy(rblkcipher.type, "blkcipher", sizeof(rblkcipher.type));
+	strncpy(rblkcipher.geniv, alg->cra_blkcipher.geniv ?: "<default>",
+		sizeof(rblkcipher.geniv));
=20
 	rblkcipher.blocksize =3D alg->cra_blocksize;
 	rblkcipher.min_keysize =3D alg->cra_blkcipher.min_keysize;
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 0605a2b..5b63b8d 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -71,7 +71,7 @@ static int crypto_report_cipher(struct sk_buff *skb, stru=
ct crypto_alg *alg)
 {
 	struct crypto_report_cipher rcipher;
=20
-	snprintf(rcipher.type, CRYPTO_MAX_ALG_NAME, "%s", "cipher");
+	strncpy(rcipher.type, "cipher", sizeof(rcipher.type));
=20
 	rcipher.blocksize =3D alg->cra_blocksize;
 	rcipher.min_keysize =3D alg->cra_cipher.cia_min_keysize;
@@ -90,8 +90,7 @@ static int crypto_report_comp(struct sk_buff *skb, struct=
 crypto_alg *alg)
 {
 	struct crypto_report_comp rcomp;
=20
-	snprintf(rcomp.type, CRYPTO_MAX_ALG_NAME, "%s", "compression");
-
+	strncpy(rcomp.type, "compression", sizeof(rcomp.type));
 	NLA_PUT(skb, CRYPTOCFGA_REPORT_COMPRESS,
 		sizeof(struct crypto_report_comp), &rcomp);
=20
@@ -104,12 +103,14 @@ nla_put_failure:
 static int crypto_report_one(struct crypto_alg *alg,
 			     struct crypto_user_alg *ualg, struct sk_buff *skb)
 {
-	memcpy(&ualg->cru_name, &alg->cra_name, sizeof(ualg->cru_name));
-	memcpy(&ualg->cru_driver_name, &alg->cra_driver_name,
-	       sizeof(ualg->cru_driver_name));
-	memcpy(&ualg->cru_module_name, module_name(alg->cra_module),
-	       CRYPTO_MAX_ALG_NAME);
-
+	strncpy(ualg->cru_name, alg->cra_name, sizeof(ualg->cru_name));
+	strncpy(ualg->cru_driver_name, alg->cra_driver_name,
+		sizeof(ualg->cru_driver_name));
+	strncpy(ualg->cru_module_name, module_name(alg->cra_module),
+		sizeof(ualg->cru_module_name));
+
+	ualg->cru_type =3D 0;
+	ualg->cru_mask =3D 0;
 	ualg->cru_flags =3D alg->cra_flags;
 	ualg->cru_refcnt =3D atomic_read(&alg->cra_refcnt);
=20
@@ -118,8 +119,7 @@ static int crypto_report_one(struct crypto_alg *alg,
 	if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
 		struct crypto_report_larval rl;
=20
-		snprintf(rl.type, CRYPTO_MAX_ALG_NAME, "%s", "larval");
-
+		strncpy(rl.type, "larval", sizeof(rl.type));
 		NLA_PUT(skb, CRYPTOCFGA_REPORT_LARVAL,
 			sizeof(struct crypto_report_larval), &rl);
=20
diff --git a/crypto/pcompress.c b/crypto/pcompress.c
index 2e458e5..6f2a361 100644
--- a/crypto/pcompress.c
+++ b/crypto/pcompress.c
@@ -53,8 +53,7 @@ static int crypto_pcomp_report(struct sk_buff *skb, struc=
t crypto_alg *alg)
 {
 	struct crypto_report_comp rpcomp;
=20
-	snprintf(rpcomp.type, CRYPTO_MAX_ALG_NAME, "%s", "pcomp");
-
+	strncpy(rpcomp.type, "pcomp", sizeof(rpcomp.type));
 	NLA_PUT(skb, CRYPTOCFGA_REPORT_COMPRESS,
 		sizeof(struct crypto_report_comp), &rpcomp);
=20
diff --git a/crypto/rng.c b/crypto/rng.c
index 64f864f..1966c1d 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -65,7 +65,7 @@ static int crypto_rng_report(struct sk_buff *skb, struct =
crypto_alg *alg)
 {
 	struct crypto_report_rng rrng;
=20
-	snprintf(rrng.type, CRYPTO_MAX_ALG_NAME, "%s", "rng");
+	strncpy(rrng.type, "rng", sizeof(rrng.type));
=20
 	rrng.seedsize =3D alg->cra_rng.seedsize;
=20
diff --git a/crypto/shash.c b/crypto/shash.c
index 9100912..f507294 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -530,7 +530,8 @@ static int crypto_shash_report(struct sk_buff *skb, str=
uct crypto_alg *alg)
 	struct crypto_report_hash rhash;
 	struct shash_alg *salg =3D __crypto_shash_alg(alg);
=20
-	snprintf(rhash.type, CRYPTO_MAX_ALG_NAME, "%s", "shash");
+	strncpy(rhash.type, "shash", sizeof(rhash.type));
+
 	rhash.blocksize =3D alg->cra_blocksize;
 	rhash.digestsize =3D salg->digestsize;
=20
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 62c1325..87acc23 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -262,6 +262,46 @@ static const struct pci_device_id ahci_pci_tbl[] =3D {
 	{ PCI_VDEVICE(INTEL, 0x1e06), board_ahci }, /* Panther Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x1e07), board_ahci }, /* Panther Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x1e0e), board_ahci }, /* Panther Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c02), board_ahci }, /* Lynx Point AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8c03), board_ahci }, /* Lynx Point AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8c04), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c05), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c06), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c07), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c0e), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c0f), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c02), board_ahci }, /* Lynx Point-LP AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9c03), board_ahci }, /* Lynx Point-LP AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9c04), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c05), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c06), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c07), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c0e), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c0f), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f22), board_ahci }, /* Avoton AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1f23), board_ahci }, /* Avoton AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1f24), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f25), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f26), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f27), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f2e), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f2f), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f32), board_ahci }, /* Avoton AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1f33), board_ahci }, /* Avoton AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1f34), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f35), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f36), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f37), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f3e), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f3f), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d02), board_ahci }, /* Wellsburg AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8d04), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d06), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d0e), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d62), board_ahci }, /* Wellsburg AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8d64), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d66), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d6e), board_ahci }, /* Wellsburg RAID */
=20
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1e888c9..8c6787a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1262,11 +1262,9 @@ static int loop_set_capacity(struct loop_device *lo,=
 struct block_device *bdev)
 	/* the width of sector_t may be narrow for bit-shift */
 	sz =3D sec;
 	sz <<=3D 9;
-	mutex_lock(&bdev->bd_mutex);
 	bd_set_size(bdev, sz);
 	/* let user-space know about the new size */
 	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
-	mutex_unlock(&bdev->bd_mutex);
=20
  out:
 	return err;
@@ -1836,11 +1834,15 @@ static int __init loop_init(void)
 		max_part =3D (1UL << part_shift) - 1;
 	}
=20
-	if ((1UL << part_shift) > DISK_MAX_PARTS)
-		return -EINVAL;
+	if ((1UL << part_shift) > DISK_MAX_PARTS) {
+		err =3D -EINVAL;
+		goto misc_out;
+	}
=20
-	if (max_loop > 1UL << (MINORBITS - part_shift))
-		return -EINVAL;
+	if (max_loop > 1UL << (MINORBITS - part_shift)) {
+		err =3D -EINVAL;
+		goto misc_out;
+	}
=20
 	/*
 	 * If max_loop is specified, create that many devices upfront.
@@ -1858,8 +1860,10 @@ static int __init loop_init(void)
 		range =3D 1UL << MINORBITS;
 	}
=20
-	if (register_blkdev(LOOP_MAJOR, "loop"))
-		return -EIO;
+	if (register_blkdev(LOOP_MAJOR, "loop")) {
+		err =3D -EIO;
+		goto misc_out;
+	}
=20
 	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
 				  THIS_MODULE, loop_probe, NULL, NULL);
@@ -1872,6 +1876,10 @@ static int __init loop_init(void)
=20
 	printk(KERN_INFO "loop: module loaded\n");
 	return 0;
+
+misc_out:
+	misc_deregister(&loop_misc);
+	return err;
 }
=20
 static int loop_exit_cb(int id, void *ptr, void *data)
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 1bafb40..69ae597 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -40,6 +40,7 @@
 #include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
=20

@@ -52,8 +53,12 @@ static struct hwrng *current_rng;
 static LIST_HEAD(rng_list);
 static DEFINE_MUTEX(rng_mutex);
 static int data_avail;
-static u8 rng_buffer[SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES]
-	__cacheline_aligned;
+static u8 *rng_buffer;
+
+static size_t rng_buffer_size(void)
+{
+	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
+}
=20
 static inline int hwrng_init(struct hwrng *rng)
 {
@@ -116,7 +121,7 @@ static ssize_t rng_dev_read(struct file *filp, char __u=
ser *buf,
=20
 		if (!data_avail) {
 			bytes_read =3D rng_get_data(current_rng, rng_buffer,
-				sizeof(rng_buffer),
+				rng_buffer_size(),
 				!(filp->f_flags & O_NONBLOCK));
 			if (bytes_read < 0) {
 				err =3D bytes_read;
@@ -307,6 +312,14 @@ int hwrng_register(struct hwrng *rng)
=20
 	mutex_lock(&rng_mutex);
=20
+	/* kmalloc makes this safe for virt_to_page() in virtio_rng.c */
+	err =3D -ENOMEM;
+	if (!rng_buffer) {
+		rng_buffer =3D kmalloc(rng_buffer_size(), GFP_KERNEL);
+		if (!rng_buffer)
+			goto out_unlock;
+	}
+
 	/* Must not register two RNGs with the same name. */
 	err =3D -EEXIST;
 	list_for_each_entry(tmp, &rng_list, list) {
diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/v=
irtio-rng.c
index fd699cc..86ed591 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -89,14 +89,22 @@ static int virtrng_probe(struct virtio_device *vdev)
 {
 	int err;
=20
+	if (vq) {
+		/* We only support one device for now */
+		return -EBUSY;
+	}
 	/* We expect a single virtqueue. */
 	vq =3D virtio_find_single_vq(vdev, random_recv_done, "input");
-	if (IS_ERR(vq))
-		return PTR_ERR(vq);
+	if (IS_ERR(vq)) {
+		err =3D PTR_ERR(vq);
+		vq =3D NULL;
+		return err;
+	}
=20
 	err =3D hwrng_register(&virtio_hwrng);
 	if (err) {
 		vdev->config->del_vqs(vdev);
+		vq =3D NULL;
 		return err;
 	}
=20
@@ -108,6 +116,7 @@ static void __devexit virtrng_remove(struct virtio_devi=
ce *vdev)
 	vdev->config->reset(vdev);
 	hwrng_unregister(&virtio_hwrng);
 	vdev->config->del_vqs(vdev);
+	vq =3D NULL;
 }
=20
 static struct virtio_device_id id_table[] =3D {
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 77e1e6c..46bbf43 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -303,6 +303,12 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 	if (msg->len !=3D sizeof(*mc_op))
 		return;
=20
+	/* Can only change if privileged. */
+	if (!capable(CAP_NET_ADMIN)) {
+		err =3D EPERM;
+		goto out;
+	}
+
 	mc_op =3D (enum proc_cn_mcast_op*)msg->data;
 	switch (*mc_op) {
 	case PROC_CN_MCAST_LISTEN:
@@ -315,6 +321,8 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 		err =3D EINVAL;
 		break;
 	}
+
+out:
 	cn_proc_ack(err, msg->seq, msg->ack);
 }
=20
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stat=
s.c
index c5072a9..4bf374d 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -330,6 +330,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct n=
otifier_block *nfb,
 		cpufreq_update_policy(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		cpufreq_stats_free_sysfs(cpu);
 		break;
 	case CPU_DEAD:
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 982f1f5..4cd392d 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -442,7 +442,6 @@ static int __init dmi_present(const char __iomem *p)
 static int __init smbios_present(const char __iomem *p)
 {
 	u8 buf[32];
-	int offset =3D 0;
=20
 	memcpy_fromio(buf, p, 32);
 	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
@@ -461,9 +460,9 @@ static int __init smbios_present(const char __iomem *p)
 			dmi_ver =3D 0x0206;
 			break;
 		}
-		offset =3D 16;
+		return memcmp(p + 16, "_DMI_", 5) || dmi_present(p + 16);
 	}
-	return dmi_present(buf + offset);
+	return 1;
 }
=20
 void __init dmi_scan_machine(void)
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 5d5a868..81346ae 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -393,10 +393,11 @@ static efi_status_t
 get_var_data(struct efivars *efivars, struct efi_variable *var)
 {
 	efi_status_t status;
+	unsigned long flags;
=20
-	spin_lock(&efivars->lock);
+	spin_lock_irqsave(&efivars->lock, flags);
 	status =3D get_var_data_locked(efivars, var);
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
=20
 	if (status !=3D EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: get_variable() failed 0x%lx!\n",
@@ -405,6 +406,30 @@ get_var_data(struct efivars *efivars, struct efi_varia=
ble *var)
 	return status;
 }
=20
+static efi_status_t
+check_var_size_locked(struct efivars *efivars, u32 attributes,
+			unsigned long size)
+{
+	u64 storage_size, remaining_size, max_size;
+	efi_status_t status;
+	const struct efivar_operations *fops =3D efivars->ops;
+
+	if (!efivars->ops->query_variable_info)
+		return EFI_UNSUPPORTED;
+
+	status =3D fops->query_variable_info(attributes, &storage_size,
+					   &remaining_size, &max_size);
+
+	if (status !=3D EFI_SUCCESS)
+		return status;
+
+	if (!storage_size || size > remaining_size || size > max_size ||
+	    (remaining_size - size) < (storage_size / 2))
+		return EFI_OUT_OF_RESOURCES;
+
+	return status;
+}
+
 static ssize_t
 efivar_guid_read(struct efivar_entry *entry, char *buf)
 {
@@ -525,14 +550,19 @@ efivar_store_raw(struct efivar_entry *entry, const ch=
ar *buf, size_t count)
 		return -EINVAL;
 	}
=20
-	spin_lock(&efivars->lock);
-	status =3D efivars->ops->set_variable(new_var->VariableName,
-					    &new_var->VendorGuid,
-					    new_var->Attributes,
-					    new_var->DataSize,
-					    new_var->Data);
+	spin_lock_irq(&efivars->lock);
+
+	status =3D check_var_size_locked(efivars, new_var->Attributes,
+	       new_var->DataSize + utf16_strsize(new_var->VariableName, 1024));
=20
-	spin_unlock(&efivars->lock);
+	if (status =3D=3D EFI_SUCCESS || status =3D=3D EFI_UNSUPPORTED)
+		status =3D efivars->ops->set_variable(new_var->VariableName,
+						    &new_var->VendorGuid,
+						    new_var->Attributes,
+						    new_var->DataSize,
+						    new_var->Data);
+
+	spin_unlock_irq(&efivars->lock);
=20
 	if (status !=3D EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=3D%lx\n",
@@ -637,13 +667,43 @@ efivar_unregister(struct efivar_entry *var)
 	kobject_put(&var->kobj);
 }
=20
+static int efi_status_to_err(efi_status_t status)
+{
+	int err;
+
+	switch (status) {
+	case EFI_INVALID_PARAMETER:
+		err =3D -EINVAL;
+		break;
+	case EFI_OUT_OF_RESOURCES:
+		err =3D -ENOSPC;
+		break;
+	case EFI_DEVICE_ERROR:
+		err =3D -EIO;
+		break;
+	case EFI_WRITE_PROTECTED:
+		err =3D -EROFS;
+		break;
+	case EFI_SECURITY_VIOLATION:
+		err =3D -EACCES;
+		break;
+	case EFI_NOT_FOUND:
+		err =3D -ENOENT;
+		break;
+	default:
+		err =3D -EINVAL;
+	}
+
+	return err;
+}
+
 #ifdef CONFIG_PSTORE
=20
 static int efi_pstore_open(struct pstore_info *psi)
 {
 	struct efivars *efivars =3D psi->data;
=20
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	efivars->walk_entry =3D list_first_entry(&efivars->list,
 					       struct efivar_entry, list);
 	return 0;
@@ -653,7 +713,7 @@ static int efi_pstore_close(struct pstore_info *psi)
 {
 	struct efivars *efivars =3D psi->data;
=20
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 	return 0;
 }
=20
@@ -706,11 +766,28 @@ static int efi_pstore_write(enum pstore_type_id type,=
 u64 *id,
 	struct efivars *efivars =3D psi->data;
 	struct efivar_entry *entry, *found =3D NULL;
 	int i, ret =3D 0;
+	efi_status_t status =3D EFI_NOT_FOUND;
+	unsigned long flags;
=20
 	sprintf(stub_name, "dump-type%u-%u-", type, part);
 	sprintf(name, "%s%lu", stub_name, get_seconds());
=20
-	spin_lock(&efivars->lock);
+	spin_lock_irqsave(&efivars->lock, flags);
+
+	/*
+	 * Check if there is a space enough to log.
+	 * size: a size of logging data
+	 * DUMP_NAME_LEN * 2: a maximum size of variable name
+	 */
+
+	status =3D check_var_size_locked(efivars, PSTORE_EFI_ATTRIBUTES,
+					 size + DUMP_NAME_LEN * 2);
+
+	if (status) {
+		spin_unlock_irqrestore(&efivars->lock, flags);
+		*id =3D part;
+		return -ENOSPC;
+	}
=20
 	for (i =3D 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] =3D stub_name[i];
@@ -748,7 +825,7 @@ static int efi_pstore_write(enum pstore_type_id type, u=
64 *id,
 	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
 				   size, psi->buf);
=20
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
=20
 	if (found)
 		efivar_unregister(found);
@@ -831,7 +908,7 @@ static ssize_t efivar_create(struct file *filp, struct =
kobject *kobj,
 		return -EINVAL;
 	}
=20
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
=20
 	/*
 	 * Does this variable already exist?
@@ -849,10 +926,18 @@ static ssize_t efivar_create(struct file *filp, struc=
t kobject *kobj,
 		}
 	}
 	if (found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EINVAL;
 	}
=20
+	status =3D check_var_size_locked(efivars, new_var->Attributes,
+	       new_var->DataSize + utf16_strsize(new_var->VariableName, 1024));
+
+	if (status && status !=3D EFI_UNSUPPORTED) {
+		spin_unlock_irq(&efivars->lock);
+		return efi_status_to_err(status);
+	}
+
 	/* now *really* create the variable via EFI */
 	status =3D efivars->ops->set_variable(new_var->VariableName,
 					    &new_var->VendorGuid,
@@ -863,10 +948,10 @@ static ssize_t efivar_create(struct file *filp, struc=
t kobject *kobj,
 	if (status !=3D EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=3D%lx\n",
 			status);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EIO;
 	}
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
=20
 	/* Create the entry in sysfs.  Locking is not required here */
 	status =3D efivar_create_sysfs_entry(efivars,
@@ -894,7 +979,7 @@ static ssize_t efivar_delete(struct file *filp, struct =
kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
=20
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
=20
 	/*
 	 * Does this variable already exist?
@@ -912,7 +997,7 @@ static ssize_t efivar_delete(struct file *filp, struct =
kobject *kobj,
 		}
 	}
 	if (!found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EINVAL;
 	}
 	/* force the Attributes/DataSize to 0 to ensure deletion */
@@ -928,12 +1013,12 @@ static ssize_t efivar_delete(struct file *filp, stru=
ct kobject *kobj,
 	if (status !=3D EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=3D%lx\n",
 			status);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EIO;
 	}
 	list_del(&search_efivar->list);
 	/* We need to release this lock before unregistering. */
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 	efivar_unregister(search_efivar);
=20
 	/* It's dead Jim.... */
@@ -1041,9 +1126,9 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	kfree(short_name);
 	short_name =3D NULL;
=20
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	list_add(&new_efivar->list, &efivars->list);
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
=20
 	return 0;
 }
@@ -1112,9 +1197,9 @@ void unregister_efivars(struct efivars *efivars)
 	struct efivar_entry *entry, *n;
=20
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		spin_lock(&efivars->lock);
+		spin_lock_irq(&efivars->lock);
 		list_del(&entry->list);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		efivar_unregister(entry);
 	}
 	if (efivars->new_var)
@@ -1235,6 +1320,7 @@ efivars_init(void)
 	ops.get_variable =3D efi.get_variable;
 	ops.set_variable =3D efi.set_variable;
 	ops.get_next_variable =3D efi.get_next_variable;
+	ops.query_variable_info =3D efi.query_variable_info;
 	error =3D register_efivars(&__efivars, &ops, efi_kobj);
 	if (error)
 		goto err_put;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 2303c2b..4591582 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7280,8 +7280,8 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc=
,
 {
 	struct drm_device *dev =3D crtc->dev;
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
-	struct intel_framebuffer *intel_fb;
-	struct drm_i915_gem_object *obj;
+	struct drm_framebuffer *old_fb =3D crtc->fb;
+	struct drm_i915_gem_object *obj =3D to_intel_framebuffer(fb)->obj;
 	struct intel_crtc *intel_crtc =3D to_intel_crtc(crtc);
 	struct intel_unpin_work *work;
 	unsigned long flags;
@@ -7293,8 +7293,7 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc=
,
=20
 	work->event =3D event;
 	work->dev =3D crtc->dev;
-	intel_fb =3D to_intel_framebuffer(crtc->fb);
-	work->old_fb_obj =3D intel_fb->obj;
+	work->old_fb_obj =3D to_intel_framebuffer(old_fb)->obj;
 	INIT_WORK(&work->work, intel_unpin_work_fn);
=20
 	ret =3D drm_vblank_get(dev, intel_crtc->pipe);
@@ -7314,9 +7313,6 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc=
,
 	intel_crtc->unpin_work =3D work;
 	spin_unlock_irqrestore(&dev->event_lock, flags);
=20
-	intel_fb =3D to_intel_framebuffer(fb);
-	obj =3D intel_fb->obj;
-
 	mutex_lock(&dev->struct_mutex);
=20
 	/* Reference the objects for the scheduled work. */
@@ -7347,6 +7343,7 @@ static int intel_crtc_page_flip(struct drm_crtc *crtc=
,
=20
 cleanup_pending:
 	atomic_sub(1 << intel_crtc->plane, &work->old_fb_obj->pending_flip);
+	crtc->fb =3D old_fb;
 	drm_gem_object_unreference(&work->old_fb_obj->base);
 	drm_gem_object_unreference(&obj->base);
 	mutex_unlock(&dev->struct_mutex);
diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/rade=
on/radeon_combios.c
index ec36dd9..c32fd93 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -958,6 +958,15 @@ struct radeon_encoder_primary_dac *radeon_combios_get_=
primary_dac_info(struct
 			found =3D 1;
 	}
=20
+	/* quirks */
+	/* Radeon 9100 (R200) */
+	if ((dev->pdev->device =3D=3D 0x514D) &&
+	    (dev->pdev->subsystem_vendor =3D=3D 0x174B) &&
+	    (dev->pdev->subsystem_device =3D=3D 0x7149)) {
+		/* vbios value is bad, use the default */
+		found =3D 0;
+	}
+
 	if (!found) /* fallback to defaults */
 		radeon_legacy_get_primary_dac_info_from_table(rdev, p_dac);
=20
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a23b63a..611aafc 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1533,6 +1533,7 @@ static const struct hid_device_id hid_have_special_dr=
iver[] =3D {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_NAVIGATION_CONTRO=
LLER) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROL=
LER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) }=
,
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE) }=
,
 	{ HID_USB_DEVICE(USB_VENDOR_ID_STANTUM, USB_DEVICE_ID_MTP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM, USB_DEVICE_ID_MTP_STM) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_SITRONIX, USB_DEVICE_ID_MTP_SITRON=
IX) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 25f3290..e665bdf 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -644,6 +644,7 @@
=20
 #define USB_VENDOR_ID_SONY			0x054c
 #define USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE	0x024b
+#define USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE	0x0374
 #define USB_DEVICE_ID_SONY_PS3_CONTROLLER	0x0268
 #define USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER	0x042f
=20
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 5cd25bd..4142c21 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -44,9 +44,19 @@ static __u8 *sony_report_fixup(struct hid_device *hdev, =
__u8 *rdesc,
 {
 	struct sony_sc *sc =3D hid_get_drvdata(hdev);
=20
-	if ((sc->quirks & VAIO_RDESC_CONSTANT) &&
-			*rsize >=3D 56 && rdesc[54] =3D=3D 0x81 && rdesc[55] =3D=3D 0x07) {
-		hid_info(hdev, "Fixing up Sony Vaio VGX report descriptor\n");
+	/*
+	 * Some Sony RF receivers wrongly declare the mouse pointer as a
+	 * a constant non-data variable.
+	 */
+	if ((sc->quirks & VAIO_RDESC_CONSTANT) && *rsize >=3D 56 &&
+	    /* usage page: generic desktop controls */
+	    /* rdesc[0] =3D=3D 0x05 && rdesc[1] =3D=3D 0x01 && */
+	    /* usage: mouse */
+	    rdesc[2] =3D=3D 0x09 && rdesc[3] =3D=3D 0x02 &&
+	    /* input (usage page for x,y axes): constant, variable, relative */
+	    rdesc[54] =3D=3D 0x81 && rdesc[55] =3D=3D 0x07) {
+		hid_info(hdev, "Fixing up Sony RF Receiver report descriptor\n");
+		/* input: data, variable, relative */
 		rdesc[55] =3D 0x06;
 	}
=20
@@ -218,6 +228,8 @@ static const struct hid_device_id sony_devices[] =3D {
 		.driver_data =3D SIXAXIS_CONTROLLER_BT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE),
 		.driver_data =3D VAIO_RDESC_CONSTANT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE),
+		.driver_data =3D VAIO_RDESC_CONSTANT },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, sony_devices);
diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 89f5244..0e8343f 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -212,11 +212,13 @@ kvp_respond_to_host(char *key, char *value, int error=
)
 	 * The windows host expects the key/value pair to be encoded
 	 * in utf16.
 	 */
-	keylen =3D utf8s_to_utf16s(key_name, strlen(key_name),
-				(wchar_t *)kvp_data->data.key);
+	keylen =3D utf8s_to_utf16s(key_name, strlen(key_name), UTF16_HOST_ENDIAN,
+				(wchar_t *) kvp_data->data.key,
+				HV_KVP_EXCHANGE_MAX_KEY_SIZE / 2);
 	kvp_data->data.key_size =3D 2*(keylen + 1); /* utf16 encoding */
-	valuelen =3D utf8s_to_utf16s(value, strlen(value),
-				(wchar_t *)kvp_data->data.value);
+	valuelen =3D utf8s_to_utf16s(value, strlen(value), UTF16_HOST_ENDIAN,
+				(wchar_t *) kvp_data->data.value,
+				HV_KVP_EXCHANGE_MAX_VALUE_SIZE / 2);
 	kvp_data->data.value_size =3D 2*(valuelen + 1); /* utf16 encoding */
=20
 	kvp_data->data.value_type =3D REG_SZ; /* all our values are strings */
diff --git a/drivers/hwmon/lineage-pem.c b/drivers/hwmon/lineage-pem.c
index 58eded2..c9910f7 100644
--- a/drivers/hwmon/lineage-pem.c
+++ b/drivers/hwmon/lineage-pem.c
@@ -421,6 +421,7 @@ static struct attribute *pem_input_attributes[] =3D {
 	&sensor_dev_attr_in2_input.dev_attr.attr,
 	&sensor_dev_attr_curr1_input.dev_attr.attr,
 	&sensor_dev_attr_power1_input.dev_attr.attr,
+	NULL
 };
=20
 static const struct attribute_group pem_input_group =3D {
@@ -431,6 +432,7 @@ static struct attribute *pem_fan_attributes[] =3D {
 	&sensor_dev_attr_fan1_input.dev_attr.attr,
 	&sensor_dev_attr_fan2_input.dev_attr.attr,
 	&sensor_dev_attr_fan3_input.dev_attr.attr,
+	NULL
 };
=20
 static const struct attribute_group pem_fan_group =3D {
diff --git a/drivers/hwmon/pmbus/ltc2978.c b/drivers/hwmon/pmbus/ltc2978.c
index 820fff4..43c7414 100644
--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -59,10 +59,10 @@ enum chips { ltc2978, ltc3880 };
 struct ltc2978_data {
 	enum chips id;
 	int vin_min, vin_max;
-	int temp_min, temp_max;
+	int temp_min, temp_max[2];
 	int vout_min[8], vout_max[8];
 	int iout_max[2];
-	int temp2_max[2];
+	int temp2_max;
 	struct pmbus_driver_info info;
 };
=20
@@ -113,9 +113,10 @@ static int ltc2978_read_word_data_common(struct i2c_cl=
ient *client, int page,
 		ret =3D pmbus_read_word_data(client, page,
 					   LTC2978_MFR_TEMPERATURE_PEAK);
 		if (ret >=3D 0) {
-			if (lin11_to_val(ret) > lin11_to_val(data->temp_max))
-				data->temp_max =3D ret;
-			ret =3D data->temp_max;
+			if (lin11_to_val(ret)
+			    > lin11_to_val(data->temp_max[page]))
+				data->temp_max[page] =3D ret;
+			ret =3D data->temp_max[page];
 		}
 		break;
 	case PMBUS_VIRT_RESET_VOUT_HISTORY:
@@ -204,10 +205,9 @@ static int ltc3880_read_word_data(struct i2c_client *c=
lient, int page, int reg)
 		ret =3D pmbus_read_word_data(client, page,
 					   LTC3880_MFR_TEMPERATURE2_PEAK);
 		if (ret >=3D 0) {
-			if (lin11_to_val(ret)
-			    > lin11_to_val(data->temp2_max[page]))
-				data->temp2_max[page] =3D ret;
-			ret =3D data->temp2_max[page];
+			if (lin11_to_val(ret) > lin11_to_val(data->temp2_max))
+				data->temp2_max =3D ret;
+			ret =3D data->temp2_max;
 		}
 		break;
 	case PMBUS_VIRT_READ_VIN_MIN:
@@ -248,11 +248,11 @@ static int ltc2978_write_word_data(struct i2c_client =
*client, int page,
=20
 	switch (reg) {
 	case PMBUS_VIRT_RESET_IOUT_HISTORY:
-		data->iout_max[page] =3D 0x7fff;
+		data->iout_max[page] =3D 0x7c00;
 		ret =3D ltc2978_clear_peaks(client, page, data->id);
 		break;
 	case PMBUS_VIRT_RESET_TEMP2_HISTORY:
-		data->temp2_max[page] =3D 0x7fff;
+		data->temp2_max =3D 0x7c00;
 		ret =3D ltc2978_clear_peaks(client, page, data->id);
 		break;
 	case PMBUS_VIRT_RESET_VOUT_HISTORY:
@@ -262,12 +262,12 @@ static int ltc2978_write_word_data(struct i2c_client =
*client, int page,
 		break;
 	case PMBUS_VIRT_RESET_VIN_HISTORY:
 		data->vin_min =3D 0x7bff;
-		data->vin_max =3D 0;
+		data->vin_max =3D 0x7c00;
 		ret =3D ltc2978_clear_peaks(client, page, data->id);
 		break;
 	case PMBUS_VIRT_RESET_TEMP_HISTORY:
 		data->temp_min =3D 0x7bff;
-		data->temp_max =3D 0x7fff;
+		data->temp_max[page] =3D 0x7c00;
 		ret =3D ltc2978_clear_peaks(client, page, data->id);
 		break;
 	default:
@@ -323,12 +323,14 @@ static int ltc2978_probe(struct i2c_client *client,
 	info =3D &data->info;
 	info->write_word_data =3D ltc2978_write_word_data;
=20
-	data->vout_min[0] =3D 0xffff;
 	data->vin_min =3D 0x7bff;
+	data->vin_max =3D 0x7c00;
 	data->temp_min =3D 0x7bff;
-	data->temp_max =3D 0x7fff;
+	for (i =3D 0; i < ARRAY_SIZE(data->temp_max); i++)
+		data->temp_max[i] =3D 0x7c00;
+	data->temp2_max =3D 0x7c00;
=20
-	switch (id->driver_data) {
+	switch (data->id) {
 	case ltc2978:
 		info->read_word_data =3D ltc2978_read_word_data;
 		info->pages =3D 8;
@@ -338,7 +340,6 @@ static int ltc2978_probe(struct i2c_client *client,
 		for (i =3D 1; i < 8; i++) {
 			info->func[i] =3D PMBUS_HAVE_VOUT
 			  | PMBUS_HAVE_STATUS_VOUT;
-			data->vout_min[i] =3D 0xffff;
 		}
 		break;
 	case ltc3880:
@@ -354,12 +355,15 @@ static int ltc2978_probe(struct i2c_client *client,
 		  | PMBUS_HAVE_IOUT | PMBUS_HAVE_STATUS_IOUT
 		  | PMBUS_HAVE_POUT
 		  | PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP;
-		data->vout_min[1] =3D 0xffff;
+		data->iout_max[0] =3D 0x7c00;
+		data->iout_max[1] =3D 0x7c00;
 		break;
 	default:
 		ret =3D -ENODEV;
 		goto err_mem;
 	}
+	for (i =3D 0; i < info->pages; i++)
+		data->vout_min[i] =3D 0xffff;
=20
 	ret =3D pmbus_do_probe(client, id, info);
 	if (ret)
diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 5357925..3e3153e 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -926,7 +926,13 @@ static int __devinit sht15_probe(struct platform_devic=
e *pdev)
 		if (voltage)
 			data->supply_uV =3D voltage;
=20
-		regulator_enable(data->reg);
+		ret =3D regulator_enable(data->reg);
+		if (ret !=3D 0) {
+			dev_err(&pdev->dev,
+				"failed to enable regulator: %d\n", ret);
+			goto err_free_data;
+		}
+
 		/*
 		 * Setup a notifier block to update this if another device
 		 * causes the voltage to change
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.=
c
index 62a4d5c..b7d1cdd 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1396,6 +1396,7 @@ static struct syscore_ops amd_iommu_syscore_ops =3D {
  */
 static int __init amd_iommu_init(void)
 {
+	struct amd_iommu *iommu;
 	int i, ret =3D 0;
=20
 	/*
@@ -1444,9 +1445,6 @@ static int __init amd_iommu_init(void)
 	if (amd_iommu_pd_alloc_bitmap =3D=3D NULL)
 		goto free;
=20
-	/* init the device table */
-	init_device_table();
-
 	/*
 	 * let all alias entries point to itself
 	 */
@@ -1496,6 +1494,12 @@ static int __init amd_iommu_init(void)
 	if (ret)
 		goto free_disable;
=20
+	/* init the device table */
+	init_device_table();
+
+	for_each_iommu(iommu)
+		iommu_flush_all_caches(iommu);
+
 	amd_iommu_init_api();
=20
 	amd_iommu_init_notifier();
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 58d8c6d..aa142f9 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1262,20 +1262,6 @@ static int crypt_decode_key(u8 *key, char *hex, unsi=
gned int size)
 	return 0;
 }
=20
-/*
- * Encode key into its hex representation
- */
-static void crypt_encode_key(char *hex, u8 *key, unsigned int size)
-{
-	unsigned int i;
-
-	for (i =3D 0; i < size; i++) {
-		sprintf(hex, "%02x", *key);
-		hex +=3D 2;
-		key++;
-	}
-}
-
 static void crypt_free_tfms(struct crypt_config *cc, int cpu)
 {
 	struct crypt_cpu *cpu_cc =3D per_cpu_ptr(cc->cpu, cpu);
@@ -1739,11 +1725,11 @@ static int crypt_map(struct dm_target *ti, struct b=
io *bio,
 	return DM_MAPIO_SUBMITTED;
 }
=20
-static int crypt_status(struct dm_target *ti, status_type_t type,
-			char *result, unsigned int maxlen)
+static void crypt_status(struct dm_target *ti, status_type_t type,
+			 char *result, unsigned maxlen)
 {
 	struct crypt_config *cc =3D ti->private;
-	unsigned int sz =3D 0;
+	unsigned i, sz =3D 0;
=20
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -1753,17 +1739,11 @@ static int crypt_status(struct dm_target *ti, statu=
s_type_t type,
 	case STATUSTYPE_TABLE:
 		DMEMIT("%s ", cc->cipher_string);
=20
-		if (cc->key_size > 0) {
-			if ((maxlen - sz) < ((cc->key_size << 1) + 1))
-				return -ENOMEM;
-
-			crypt_encode_key(result + sz, cc->key, cc->key_size);
-			sz +=3D cc->key_size << 1;
-		} else {
-			if (sz >=3D maxlen)
-				return -ENOMEM;
-			result[sz++] =3D '-';
-		}
+		if (cc->key_size > 0)
+			for (i =3D 0; i < cc->key_size; i++)
+				DMEMIT("%02x", cc->key[i]);
+		else
+			DMEMIT("-");
=20
 		DMEMIT(" %llu %s %llu", (unsigned long long)cc->iv_offset,
 				cc->dev->name, (unsigned long long)cc->start);
@@ -1773,7 +1753,6 @@ static int crypt_status(struct dm_target *ti, status_=
type_t type,
=20
 		break;
 	}
-	return 0;
 }
=20
 static void crypt_postsuspend(struct dm_target *ti)
@@ -1867,7 +1846,7 @@ static int crypt_iterate_devices(struct dm_target *ti=
,
=20
 static struct target_type crypt_target =3D {
 	.name   =3D "crypt",
-	.version =3D {1, 11, 0},
+	.version =3D {1, 11, 1},
 	.module =3D THIS_MODULE,
 	.ctr    =3D crypt_ctr,
 	.dtr    =3D crypt_dtr,
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index f18375d..11431ac 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -293,8 +293,8 @@ static int delay_map(struct dm_target *ti, struct bio *=
bio,
 	return delay_bio(dc, dc->read_delay, bio);
 }
=20
-static int delay_status(struct dm_target *ti, status_type_t type,
-			char *result, unsigned maxlen)
+static void delay_status(struct dm_target *ti, status_type_t type,
+			 char *result, unsigned maxlen)
 {
 	struct delay_c *dc =3D ti->private;
 	int sz =3D 0;
@@ -314,8 +314,6 @@ static int delay_status(struct dm_target *ti, status_ty=
pe_t type,
 			       dc->write_delay);
 		break;
 	}
-
-	return 0;
 }
=20
 static int delay_iterate_devices(struct dm_target *ti,
@@ -337,7 +335,7 @@ out:
=20
 static struct target_type delay_target =3D {
 	.name	     =3D "delay",
-	.version     =3D {1, 1, 0},
+	.version     =3D {1, 1, 1},
 	.module      =3D THIS_MODULE,
 	.ctr	     =3D delay_ctr,
 	.dtr	     =3D delay_dtr,
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b280c43..746b5e8 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -331,8 +331,8 @@ static int flakey_end_io(struct dm_target *ti, struct b=
io *bio,
 	return error;
 }
=20
-static int flakey_status(struct dm_target *ti, status_type_t type,
-			 char *result, unsigned int maxlen)
+static void flakey_status(struct dm_target *ti, status_type_t type,
+			  char *result, unsigned maxlen)
 {
 	unsigned sz =3D 0;
 	struct flakey_c *fc =3D ti->private;
@@ -362,7 +362,6 @@ static int flakey_status(struct dm_target *ti, status_t=
ype_t type,
=20
 		break;
 	}
-	return 0;
 }
=20
 static int flakey_ioctl(struct dm_target *ti, unsigned int cmd, unsigned l=
ong arg)
@@ -405,7 +404,7 @@ static int flakey_iterate_devices(struct dm_target *ti,=
 iterate_devices_callout_
=20
 static struct target_type flakey_target =3D {
 	.name   =3D "flakey",
-	.version =3D {1, 2, 0},
+	.version =3D {1, 2, 1},
 	.module =3D THIS_MODULE,
 	.ctr    =3D flakey_ctr,
 	.dtr    =3D flakey_dtr,
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 42c873f..e6a300c 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1065,6 +1065,7 @@ static void retrieve_status(struct dm_table *table,
 	num_targets =3D dm_table_get_num_targets(table);
 	for (i =3D 0; i < num_targets; i++) {
 		struct dm_target *ti =3D dm_table_get_target(table, i);
+		size_t l;
=20
 		remaining =3D len - (outptr - outbuf);
 		if (remaining <=3D sizeof(struct dm_target_spec)) {
@@ -1089,14 +1090,17 @@ static void retrieve_status(struct dm_table *table,
=20
 		/* Get the status/table string from the target driver */
 		if (ti->type->status) {
-			if (ti->type->status(ti, type, outptr, remaining)) {
-				param->flags |=3D DM_BUFFER_FULL_FLAG;
-				break;
-			}
+			ti->type->status(ti, type, outptr, remaining);
 		} else
 			outptr[0] =3D '\0';
=20
-		outptr +=3D strlen(outptr) + 1;
+		l =3D strlen(outptr) + 1;
+		if (l =3D=3D remaining) {
+			param->flags |=3D DM_BUFFER_FULL_FLAG;
+			break;
+		}
+
+		outptr +=3D l;
 		used =3D param->data_start + (outptr - outbuf);
=20
 		outptr =3D align_ptr(outptr);
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 9728839..c55d8e4 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -94,8 +94,8 @@ static int linear_map(struct dm_target *ti, struct bio *b=
io,
 	return DM_MAPIO_REMAPPED;
 }
=20
-static int linear_status(struct dm_target *ti, status_type_t type,
-			 char *result, unsigned int maxlen)
+static void linear_status(struct dm_target *ti, status_type_t type,
+			  char *result, unsigned maxlen)
 {
 	struct linear_c *lc =3D (struct linear_c *) ti->private;
=20
@@ -109,7 +109,6 @@ static int linear_status(struct dm_target *ti, status_t=
ype_t type,
 				(unsigned long long)lc->start);
 		break;
 	}
-	return 0;
 }
=20
 static int linear_ioctl(struct dm_target *ti, unsigned int cmd,
@@ -154,7 +153,7 @@ static int linear_iterate_devices(struct dm_target *ti,
=20
 static struct target_type linear_target =3D {
 	.name   =3D "linear",
-	.version =3D {1, 1, 0},
+	.version =3D {1, 1, 1},
 	.module =3D THIS_MODULE,
 	.ctr    =3D linear_ctr,
 	.dtr    =3D linear_dtr,
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index a417f94..7e766f9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1323,8 +1323,8 @@ static void multipath_resume(struct dm_target *ti)
  *     [priority selector-name num_ps_args [ps_args]*
  *      num_paths num_selector_args [path_dev [selector_args]* ]+ ]+
  */
-static int multipath_status(struct dm_target *ti, status_type_t type,
-			    char *result, unsigned int maxlen)
+static void multipath_status(struct dm_target *ti, status_type_t type,
+			     char *result, unsigned maxlen)
 {
 	int sz =3D 0;
 	unsigned long flags;
@@ -1427,8 +1427,6 @@ static int multipath_status(struct dm_target *ti, sta=
tus_type_t type,
 	}
=20
 	spin_unlock_irqrestore(&m->lock, flags);
-
-	return 0;
 }
=20
 static int multipath_message(struct dm_target *ti, unsigned argc, char **a=
rgv)
@@ -1623,7 +1621,7 @@ out:
  *---------------------------------------------------------------*/
 static struct target_type multipath_target =3D {
 	.name =3D "multipath",
-	.version =3D {1, 3, 0},
+	.version =3D {1, 3, 1},
 	.module =3D THIS_MODULE,
 	.ctr =3D multipath_ctr,
 	.dtr =3D multipath_dtr,
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index d2a3223..86862ea 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1017,8 +1017,8 @@ static int raid_map(struct dm_target *ti, struct bio =
*bio, union map_info *map_c
 	return DM_MAPIO_SUBMITTED;
 }
=20
-static int raid_status(struct dm_target *ti, status_type_t type,
-		       char *result, unsigned maxlen)
+static void raid_status(struct dm_target *ti, status_type_t type,
+			char *result, unsigned maxlen)
 {
 	struct raid_set *rs =3D ti->private;
 	unsigned raid_param_cnt =3D 1; /* at least 1 for chunksize */
@@ -1153,8 +1153,6 @@ static int raid_status(struct dm_target *ti, status_t=
ype_t type,
 				DMEMIT(" -");
 		}
 	}
-
-	return 0;
 }
=20
 static int raid_iterate_devices(struct dm_target *ti, iterate_devices_call=
out_fn fn, void *data)
@@ -1208,7 +1206,7 @@ static void raid_resume(struct dm_target *ti)
=20
 static struct target_type raid_target =3D {
 	.name =3D "raid",
-	.version =3D {1, 1, 0},
+	.version =3D {1, 1, 1},
 	.module =3D THIS_MODULE,
 	.ctr =3D raid_ctr,
 	.dtr =3D raid_dtr,
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index dae2b7a..b7b649d 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1358,8 +1358,8 @@ static char device_status_char(struct mirror *m)
 }
=20

-static int mirror_status(struct dm_target *ti, status_type_t type,
-			 char *result, unsigned int maxlen)
+static void mirror_status(struct dm_target *ti, status_type_t type,
+			  char *result, unsigned maxlen)
 {
 	unsigned int m, sz =3D 0;
 	struct mirror_set *ms =3D (struct mirror_set *) ti->private;
@@ -1394,8 +1394,6 @@ static int mirror_status(struct dm_target *ti, status=
_type_t type,
 		if (ms->features & DM_RAID1_HANDLE_ERRORS)
 			DMEMIT(" 1 handle_errors");
 	}
-
-	return 0;
 }
=20
 static int mirror_iterate_devices(struct dm_target *ti,
@@ -1414,7 +1412,7 @@ static int mirror_iterate_devices(struct dm_target *t=
i,
=20
 static struct target_type mirror_target =3D {
 	.name	 =3D "mirror",
-	.version =3D {1, 12, 1},
+	.version =3D {1, 12, 2},
 	.module	 =3D THIS_MODULE,
 	.ctr	 =3D mirror_ctr,
 	.dtr	 =3D mirror_dtr,
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 6f75887..34ec2b5 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1845,8 +1845,8 @@ static void snapshot_merge_resume(struct dm_target *t=
i)
 	start_merge(s);
 }
=20
-static int snapshot_status(struct dm_target *ti, status_type_t type,
-			   char *result, unsigned int maxlen)
+static void snapshot_status(struct dm_target *ti, status_type_t type,
+			    char *result, unsigned maxlen)
 {
 	unsigned sz =3D 0;
 	struct dm_snapshot *snap =3D ti->private;
@@ -1892,8 +1892,6 @@ static int snapshot_status(struct dm_target *ti, stat=
us_type_t type,
 					  maxlen - sz);
 		break;
 	}
-
-	return 0;
 }
=20
 static int snapshot_iterate_devices(struct dm_target *ti,
@@ -2148,8 +2146,8 @@ static void origin_resume(struct dm_target *ti)
 	ti->split_io =3D get_origin_minimum_chunksize(dev->bdev);
 }
=20
-static int origin_status(struct dm_target *ti, status_type_t type, char *r=
esult,
-			 unsigned int maxlen)
+static void origin_status(struct dm_target *ti, status_type_t type,
+			  char *result, unsigned maxlen)
 {
 	struct dm_dev *dev =3D ti->private;
=20
@@ -2162,8 +2160,6 @@ static int origin_status(struct dm_target *ti, status=
_type_t type, char *result,
 		snprintf(result, maxlen, "%s", dev->name);
 		break;
 	}
-
-	return 0;
 }
=20
 static int origin_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
@@ -2191,7 +2187,7 @@ static int origin_iterate_devices(struct dm_target *t=
i,
=20
 static struct target_type origin_target =3D {
 	.name    =3D "snapshot-origin",
-	.version =3D {1, 7, 1},
+	.version =3D {1, 7, 2},
 	.module  =3D THIS_MODULE,
 	.ctr     =3D origin_ctr,
 	.dtr     =3D origin_dtr,
@@ -2204,7 +2200,7 @@ static struct target_type origin_target =3D {
=20
 static struct target_type snapshot_target =3D {
 	.name    =3D "snapshot",
-	.version =3D {1, 10, 0},
+	.version =3D {1, 10, 1},
 	.module  =3D THIS_MODULE,
 	.ctr     =3D snapshot_ctr,
 	.dtr     =3D snapshot_dtr,
@@ -2327,3 +2323,5 @@ module_exit(dm_snapshot_exit);
 MODULE_DESCRIPTION(DM_NAME " snapshot target");
 MODULE_AUTHOR("Joe Thornber");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("dm-snapshot-origin");
+MODULE_ALIAS("dm-snapshot-merge");
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 3d80cf0..cbd41d2 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -301,8 +301,8 @@ static int stripe_map(struct dm_target *ti, struct bio =
*bio,
  *
  */
=20
-static int stripe_status(struct dm_target *ti,
-			 status_type_t type, char *result, unsigned int maxlen)
+static void stripe_status(struct dm_target *ti, status_type_t type,
+			  char *result, unsigned maxlen)
 {
 	struct stripe_c *sc =3D (struct stripe_c *) ti->private;
 	char buffer[sc->stripes + 1];
@@ -329,7 +329,6 @@ static int stripe_status(struct dm_target *ti,
 			    (unsigned long long)sc->stripe[i].physical_start);
 		break;
 	}
-	return 0;
 }
=20
 static int stripe_end_io(struct dm_target *ti, struct bio *bio,
@@ -418,7 +417,7 @@ static int stripe_merge(struct dm_target *ti, struct bv=
ec_merge_data *bvm,
=20
 static struct target_type stripe_target =3D {
 	.name   =3D "striped",
-	.version =3D {1, 4, 0},
+	.version =3D {1, 4, 1},
 	.module =3D THIS_MODULE,
 	.ctr    =3D stripe_ctr,
 	.dtr    =3D stripe_dtr,
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index d432032..da4d299 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2090,8 +2090,8 @@ static int pool_message(struct dm_target *ti, unsigne=
d argc, char **argv)
  *    <transaction id> <used metadata sectors>/<total metadata sectors>
  *    <used data sectors>/<total data sectors> <held metadata root>
  */
-static int pool_status(struct dm_target *ti, status_type_t type,
-		       char *result, unsigned maxlen)
+static void pool_status(struct dm_target *ti, status_type_t type,
+			char *result, unsigned maxlen)
 {
 	int r;
 	unsigned sz =3D 0;
@@ -2108,32 +2108,41 @@ static int pool_status(struct dm_target *ti, status=
_type_t type,
=20
 	switch (type) {
 	case STATUSTYPE_INFO:
-		r =3D dm_pool_get_metadata_transaction_id(pool->pmd,
-							&transaction_id);
-		if (r)
-			return r;
+		r =3D dm_pool_get_metadata_transaction_id(pool->pmd, &transaction_id);
+		if (r) {
+			DMERR("dm_pool_get_metadata_transaction_id returned %d", r);
+			goto err;
+		}
=20
-		r =3D dm_pool_get_free_metadata_block_count(pool->pmd,
-							  &nr_free_blocks_metadata);
-		if (r)
-			return r;
+		r =3D dm_pool_get_free_metadata_block_count(pool->pmd, &nr_free_blocks_m=
etadata);
+		if (r) {
+			DMERR("dm_pool_get_free_metadata_block_count returned %d", r);
+			goto err;
+		}
=20
 		r =3D dm_pool_get_metadata_dev_size(pool->pmd, &nr_blocks_metadata);
-		if (r)
-			return r;
+		if (r) {
+			DMERR("dm_pool_get_metadata_dev_size returned %d", r);
+			goto err;
+		}
=20
-		r =3D dm_pool_get_free_block_count(pool->pmd,
-						 &nr_free_blocks_data);
-		if (r)
-			return r;
+		r =3D dm_pool_get_free_block_count(pool->pmd, &nr_free_blocks_data);
+		if (r) {
+			DMERR("dm_pool_get_free_block_count returned %d", r);
+			goto err;
+		}
=20
 		r =3D dm_pool_get_data_dev_size(pool->pmd, &nr_blocks_data);
-		if (r)
-			return r;
+		if (r) {
+			DMERR("dm_pool_get_data_dev_size returned %d", r);
+			goto err;
+		}
=20
 		r =3D dm_pool_get_held_metadata_root(pool->pmd, &held_root);
-		if (r)
-			return r;
+		if (r) {
+			DMERR("dm_pool_get_held_metadata_root returned %d", r);
+			goto err;
+		}
=20
 		DMEMIT("%llu %llu/%llu %llu/%llu ",
 		       (unsigned long long)transaction_id,
@@ -2162,8 +2171,10 @@ static int pool_status(struct dm_target *ti, status_=
type_t type,
 			DMEMIT("skip_block_zeroing ");
 		break;
 	}
+	return;
=20
-	return 0;
+err:
+	DMEMIT("Error");
 }
=20
 static int pool_iterate_devices(struct dm_target *ti,
@@ -2201,7 +2212,7 @@ static struct target_type pool_target =3D {
 	.name =3D "thin-pool",
 	.features =3D DM_TARGET_SINGLETON | DM_TARGET_ALWAYS_WRITEABLE |
 		    DM_TARGET_IMMUTABLE,
-	.version =3D {1, 0, 0},
+	.version =3D {1, 0, 1},
 	.module =3D THIS_MODULE,
 	.ctr =3D pool_ctr,
 	.dtr =3D pool_dtr,
@@ -2339,8 +2350,8 @@ static void thin_postsuspend(struct dm_target *ti)
 /*
  * <nr mapped sectors> <highest mapped sector>
  */
-static int thin_status(struct dm_target *ti, status_type_t type,
-		       char *result, unsigned maxlen)
+static void thin_status(struct dm_target *ti, status_type_t type,
+			char *result, unsigned maxlen)
 {
 	int r;
 	ssize_t sz =3D 0;
@@ -2354,12 +2365,16 @@ static int thin_status(struct dm_target *ti, status=
_type_t type,
 		switch (type) {
 		case STATUSTYPE_INFO:
 			r =3D dm_thin_get_mapped_count(tc->td, &mapped);
-			if (r)
-				return r;
+			if (r) {
+				DMERR("dm_thin_get_mapped_count returned %d", r);
+				goto err;
+			}
=20
 			r =3D dm_thin_get_highest_mapped_block(tc->td, &highest);
-			if (r < 0)
-				return r;
+			if (r < 0) {
+				DMERR("dm_thin_get_highest_mapped_block returned %d", r);
+				goto err;
+			}
=20
 			DMEMIT("%llu ", mapped * tc->pool->sectors_per_block);
 			if (r)
@@ -2377,7 +2392,10 @@ static int thin_status(struct dm_target *ti, status_=
type_t type,
 		}
 	}
=20
-	return 0;
+	return;
+
+err:
+	DMEMIT("Error");
 }
=20
 static int thin_iterate_devices(struct dm_target *ti,
@@ -2410,7 +2428,7 @@ static void thin_io_hints(struct dm_target *ti, struc=
t queue_limits *limits)
=20
 static struct target_type thin_target =3D {
 	.name =3D "thin",
-	.version =3D {1, 0, 0},
+	.version =3D {1, 0, 1},
 	.module	=3D THIS_MODULE,
 	.ctr =3D thin_ctr,
 	.dtr =3D thin_dtr,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 145e378e..1702133 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -345,6 +345,10 @@ static void md_make_request(struct request_queue *q, s=
truct bio *bio)
 		bio_io_error(bio);
 		return;
 	}
+	if (mddev->ro =3D=3D 1 && unlikely(rw =3D=3D WRITE)) {
+		bio_endio(bio, bio_sectors(bio) =3D=3D 0 ? 0 : -EROFS);
+		return;
+	}
 	smp_rmb(); /* Ensure implications of  'active' are visible */
 	rcu_read_lock();
 	if (mddev->suspended) {
@@ -2838,6 +2842,9 @@ rdev_size_store(struct md_rdev *rdev, const char *buf=
, size_t len)
 		} else if (!sectors)
 			sectors =3D (i_size_read(rdev->bdev->bd_inode) >> 9) -
 				rdev->data_offset;
+		if (!my_mddev->pers->resize)
+			/* Cannot change size for RAID0 or Linear etc */
+			return -EINVAL;
 	}
 	if (sectors < my_mddev->dev_sectors)
 		return -EINVAL; /* component must fit device */
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 7294bd1..d3e6f35 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -286,7 +286,7 @@ abort:
 	kfree(conf->strip_zone);
 	kfree(conf->devlist);
 	kfree(conf);
-	*private_conf =3D NULL;
+	*private_conf =3D ERR_PTR(err);
 	return err;
 }
=20
@@ -330,7 +330,8 @@ static sector_t raid0_size(struct mddev *mddev, sector_=
t sectors, int raid_disks
 		  "%s does not support generic reshape\n", __func__);
=20
 	list_for_each_entry(rdev, &mddev->disks, same_set)
-		array_sectors +=3D rdev->sectors;
+		array_sectors +=3D (rdev->sectors &
+				  ~(sector_t)(mddev->chunk_sectors-1));
=20
 	return array_sectors;
 }
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ether=
net/intel/e1000e/netdev.c
index 0182649..a783530 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5402,7 +5402,7 @@ static int __e1000_shutdown(struct pci_dev *pdev, boo=
l *enable_wake,
 	 */
 	e1000e_release_hw_control(adapter);
=20
-	pci_disable_device(pdev);
+	pci_clear_master(pdev);
=20
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless=
/ath/ath9k/common.h
index ad14fec..f1c32a5 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -35,7 +35,7 @@
 #define WME_AC_BK   3
 #define WME_NUM_AC  4
=20
-#define ATH_RSSI_DUMMY_MARKER   0x127
+#define ATH_RSSI_DUMMY_MARKER   127
 #define ATH_RSSI_LPF_LEN 		10
 #define RSSI_LPF_THRESHOLD		-20
 #define ATH_RSSI_EP_MULTIPLIER     (1<<7)
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/at=
h/ath9k/htc.h
index da55967..09be407 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -22,6 +22,7 @@
 #include <linux/firmware.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
 #include <net/mac80211.h>
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wi=
reless/ath/ath9k/htc_drv_txrx.c
index 2d81c70..a48bb83 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1069,15 +1069,19 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv =
*priv,
=20
 	last_rssi =3D priv->rx.last_rssi;
=20
-	if (likely(last_rssi !=3D ATH_RSSI_DUMMY_MARKER))
-		rxbuf->rxstatus.rs_rssi =3D ATH_EP_RND(last_rssi,
-						     ATH_RSSI_EP_MULTIPLIER);
+	if (ieee80211_is_beacon(hdr->frame_control) &&
+	    !is_zero_ether_addr(common->curbssid) &&
+	    compare_ether_addr(hdr->addr3, common->curbssid) =3D=3D 0) {
+		s8 rssi =3D rxbuf->rxstatus.rs_rssi;
=20
-	if (rxbuf->rxstatus.rs_rssi < 0)
-		rxbuf->rxstatus.rs_rssi =3D 0;
+		if (likely(last_rssi !=3D ATH_RSSI_DUMMY_MARKER))
+			rssi =3D ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
=20
-	if (ieee80211_is_beacon(fc))
-		priv->ah->stats.avgbrssi =3D rxbuf->rxstatus.rs_rssi;
+		if (rssi < 0)
+			rssi =3D 0;
+
+		priv->ah->stats.avgbrssi =3D rssi;
+	}
=20
 	rx_status->mactime =3D be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
 	rx_status->band =3D hw->conf.channel->band;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/ne=
t/wireless/iwlwifi/iwl-trans-pcie-int.h
index 8533ba2..f081d53 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -180,6 +180,15 @@ struct iwl_queue {
 #define TFD_TX_CMD_SLOTS 256
 #define TFD_CMD_SLOTS 32
=20
+/*
+ * The FH will write back to the first TB only, so we need
+ * to copy some data into the buffer regardless of whether
+ * it should be mapped or not. This indicates how much to
+ * copy, even for HCMDs it must be big enough to fit the
+ * DRAM scratch from the TX cmd, at least 16 bytes.
+ */
+#define IWL_HCMD_MIN_COPY_SIZE	16
+
 struct iwl_tx_queue {
 	struct iwl_queue q;
 	struct iwl_tfd *tfds;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net=
/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 4a0c953..e6b3853 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -688,11 +688,13 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, =
struct iwl_host_cmd *cmd)
 	dma_addr_t phys_addr;
 	unsigned long flags;
 	u32 idx;
-	u16 copy_size, cmd_size;
+	u16 copy_size, cmd_size, dma_size;
 	bool is_ct_kill =3D false;
 	bool had_nocopy =3D false;
 	int i;
 	u8 *cmd_dest;
+	const u8 *cmddata[IWL_MAX_CMD_TFDS];
+	u16 cmdlen[IWL_MAX_CMD_TFDS];
 #ifdef CONFIG_IWLWIFI_DEVICE_TRACING
 	const void *trace_bufs[IWL_MAX_CMD_TFDS + 1] =3D {};
 	int trace_lens[IWL_MAX_CMD_TFDS + 1] =3D {};
@@ -717,15 +719,30 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, =
struct iwl_host_cmd *cmd)
 	BUILD_BUG_ON(IWL_MAX_CMD_TFDS > IWL_NUM_OF_TBS - 1);
=20
 	for (i =3D 0; i < IWL_MAX_CMD_TFDS; i++) {
+		cmddata[i] =3D cmd->data[i];
+		cmdlen[i] =3D cmd->len[i];
+
 		if (!cmd->len[i])
 			continue;
+
+		/* need at least IWL_HCMD_MIN_COPY_SIZE copied */
+		if (copy_size < IWL_HCMD_MIN_COPY_SIZE) {
+			int copy =3D IWL_HCMD_MIN_COPY_SIZE - copy_size;
+
+			if (copy > cmdlen[i])
+				copy =3D cmdlen[i];
+			cmdlen[i] -=3D copy;
+			cmddata[i] +=3D copy;
+			copy_size +=3D copy;
+		}
+
 		if (cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY) {
 			had_nocopy =3D true;
 		} else {
 			/* NOCOPY must not be followed by normal! */
 			if (WARN_ON(had_nocopy))
 				return -EINVAL;
-			copy_size +=3D cmd->len[i];
+			copy_size +=3D cmdlen[i];
 		}
 		cmd_size +=3D cmd->len[i];
 	}
@@ -778,13 +795,30 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, =
struct iwl_host_cmd *cmd)
 	/* and copy the data that needs to be copied */
=20
 	cmd_dest =3D out_cmd->payload;
+	copy_size =3D sizeof(out_cmd->hdr);
 	for (i =3D 0; i < IWL_MAX_CMD_TFDS; i++) {
-		if (!cmd->len[i])
+		int copy =3D 0;
+
+		if (!cmd->len)
 			continue;
-		if (cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY)
-			break;
-		memcpy(cmd_dest, cmd->data[i], cmd->len[i]);
-		cmd_dest +=3D cmd->len[i];
+
+		/* need at least IWL_HCMD_MIN_COPY_SIZE copied */
+		if (copy_size < IWL_HCMD_MIN_COPY_SIZE) {
+			copy =3D IWL_HCMD_MIN_COPY_SIZE - copy_size;
+
+			if (copy > cmd->len[i])
+				copy =3D cmd->len[i];
+		}
+
+		/* copy everything if not nocopy/dup */
+		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
+			copy =3D cmd->len[i];
+
+		if (copy) {
+			memcpy(cmd_dest, cmd->data[i], copy);
+			cmd_dest +=3D copy;
+			copy_size +=3D copy;
+		}
 	}
=20
 	IWL_DEBUG_HC(trans, "Sending command %s (#%x), seq: 0x%04X, "
@@ -794,7 +828,14 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, s=
truct iwl_host_cmd *cmd)
 			le16_to_cpu(out_cmd->hdr.sequence), cmd_size,
 			q->write_ptr, idx, trans->shrd->cmd_queue);
=20
-	phys_addr =3D dma_map_single(bus(trans)->dev, &out_cmd->hdr, copy_size,
+	/*
+	 * If the entire command is smaller than IWL_HCMD_MIN_COPY_SIZE, we must
+	 * still map at least that many bytes for the hardware to write back to.
+	 * We have enough space, so that's not a problem.
+	 */
+	dma_size =3D max_t(u16, copy_size, IWL_HCMD_MIN_COPY_SIZE);
+
+	phys_addr =3D dma_map_single(bus(trans)->dev, &out_cmd->hdr, dma_size,
 				DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(bus(trans)->dev, phys_addr))) {
 		idx =3D -ENOMEM;
@@ -802,7 +843,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, st=
ruct iwl_host_cmd *cmd)
 	}
=20
 	dma_unmap_addr_set(out_meta, mapping, phys_addr);
-	dma_unmap_len_set(out_meta, len, copy_size);
+	dma_unmap_len_set(out_meta, len, dma_size);
=20
 	iwlagn_txq_attach_buf_to_tfd(trans, txq,
 					phys_addr, copy_size, 1);
@@ -812,14 +853,15 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, =
struct iwl_host_cmd *cmd)
 	trace_idx =3D 1;
 #endif
=20
+	/* map the remaining (adjusted) nocopy/dup fragments */
 	for (i =3D 0; i < IWL_MAX_CMD_TFDS; i++) {
-		if (!cmd->len[i])
+		if (!cmdlen[i])
 			continue;
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
 		phys_addr =3D dma_map_single(bus(trans)->dev,
-					   (void *)cmd->data[i],
-					   cmd->len[i], DMA_BIDIRECTIONAL);
+					   (void *)cmddata[i],
+					   cmdlen[i], DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(bus(trans)->dev, phys_addr)) {
 			iwlagn_unmap_tfd(trans, out_meta,
 					 &txq->tfds[q->write_ptr],
@@ -829,10 +871,10 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, =
struct iwl_host_cmd *cmd)
 		}
=20
 		iwlagn_txq_attach_buf_to_tfd(trans, txq, phys_addr,
-					     cmd->len[i], 0);
+					     cmdlen[i], 0);
 #ifdef CONFIG_IWLWIFI_DEVICE_TRACING
-		trace_bufs[trace_idx] =3D cmd->data[i];
-		trace_lens[trace_idx] =3D cmd->len[i];
+		trace_bufs[trace_idx] =3D cmddata[i];
+		trace_lens[trace_idx] =3D cmdlen[i];
 		trace_idx++;
 #endif
 	}
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwi=
fiex/pcie.c
index de94244..3cf4ecc 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -290,7 +290,7 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapte=
r *adapter)
 		i++;
 		udelay(10);
 		/* 50ms max wait */
-		if (i =3D=3D 50000)
+		if (i =3D=3D 5000)
 			break;
 	}
=20
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index fc35308..9b9843e 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1707,7 +1707,6 @@ static void netback_changed(struct xenbus_device *dev=
,
 	case XenbusStateInitialised:
 	case XenbusStateReconfiguring:
 	case XenbusStateReconfigured:
-	case XenbusStateConnected:
 	case XenbusStateUnknown:
 	case XenbusStateClosed:
 		break;
@@ -1718,6 +1717,9 @@ static void netback_changed(struct xenbus_device *dev=
,
 		if (xennet_connect(netdev) !=3D 0)
 			break;
 		xenbus_switch_state(dev, XenbusStateConnected);
+		break;
+
+	case XenbusStateConnected:
 		netif_notify_peers(netdev);
 		break;
=20
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index f5b718d..aed7756 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3747,13 +3747,13 @@ static struct DeviceCtlBlk *device_alloc(struct Ada=
pterCtlBlk *acb,
 	dcb->max_command =3D 1;
 	dcb->target_id =3D target;
 	dcb->target_lun =3D lun;
+	dcb->dev_mode =3D eeprom->target[target].cfg0;
 #ifndef DC395x_NO_DISCONNECT
 	dcb->identify_msg =3D
 	    IDENTIFY(dcb->dev_mode & NTC_DO_DISCONNECT, lun);
 #else
 	dcb->identify_msg =3D IDENTIFY(0, lun);
 #endif
-	dcb->dev_mode =3D eeprom->target[target].cfg0;
 	dcb->inquiry7 =3D 0;
 	dcb->sync_mode =3D 0;
 	dcb->min_nego_period =3D clock_period[period_index];
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_=
drv.c
index abc5ac5..8960f1a 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -815,6 +815,7 @@ static struct scatterlist *create_bounce_buffer(struct =
scatterlist *sgl,
 	if (!bounce_sgl)
 		return NULL;
=20
+	sg_init_table(bounce_sgl, num_pages);
 	for (i =3D 0; i < num_pages; i++) {
 		page_buf =3D alloc_page(GFP_ATOMIC);
 		if (!page_buf)
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/mai=
n_usb.c
index ae62d57..754d54e 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -718,8 +718,6 @@ static int vt6656_suspend(struct usb_interface *intf, p=
m_message_t message)
 	if (device->flags & DEVICE_FLAGS_OPENED)
 		device_close(device->dev);
=20
-	usb_put_dev(interface_to_usbdev(intf));
-
 	return 0;
 }
=20
@@ -730,8 +728,6 @@ static int vt6656_resume(struct usb_interface *intf)
 	if (!device || !device->dev)
 		return -ENODEV;
=20
-	usb_get_dev(interface_to_usbdev(intf));
-
 	if (!(device->flags & DEVICE_FLAGS_OPENED))
 		device_open(device->dev);
=20
diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 6748568..cff03e5 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -322,6 +322,27 @@ static const struct serial8250_config uart_config[] =
=3D {
 		.tx_loadsz	=3D 1024,
 		.flags		=3D UART_CAP_HFIFO,
 	},
+	[PORT_ALTR_16550_F32] =3D {
+		.name		=3D "Altera 16550 FIFO32",
+		.fifo_size	=3D 32,
+		.tx_loadsz	=3D 32,
+		.fcr		=3D UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		=3D UART_CAP_FIFO | UART_CAP_AFE,
+	},
+	[PORT_ALTR_16550_F64] =3D {
+		.name		=3D "Altera 16550 FIFO64",
+		.fifo_size	=3D 64,
+		.tx_loadsz	=3D 64,
+		.fcr		=3D UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		=3D UART_CAP_FIFO | UART_CAP_AFE,
+	},
+	[PORT_ALTR_16550_F128] =3D {
+		.name		=3D "Altera 16550 FIFO128",
+		.fifo_size	=3D 128,
+		.tx_loadsz	=3D 128,
+		.fcr		=3D UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		=3D UART_CAP_FIFO | UART_CAP_AFE,
+	},
 };
=20
 #if defined(CONFIG_MIPS_ALCHEMY)
diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index a753956..6986256 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -1154,6 +1154,7 @@ pci_xr17c154_setup(struct serial_private *priv,
=20
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
+#define PCI_SUBDEVICE_ID_UNKNOWN_0x1588	0x1588
=20
 /*
  * Master list of serial port init/setup/exit quirks.
@@ -1418,15 +1419,6 @@ static struct pci_serial_quirk pci_serial_quirks[] _=
_refdata =3D {
 	},
 	{
 		.vendor		=3D PCI_VENDOR_ID_PLX,
-		.device		=3D PCI_DEVICE_ID_PLX_9050,
-		.subvendor	=3D PCI_VENDOR_ID_PLX,
-		.subdevice	=3D PCI_SUBDEVICE_ID_UNKNOWN_0x1584,
-		.init		=3D pci_plx9050_init,
-		.setup		=3D pci_default_setup,
-		.exit		=3D __devexit_p(pci_plx9050_exit),
-	},
-	{
-		.vendor		=3D PCI_VENDOR_ID_PLX,
 		.device		=3D PCI_DEVICE_ID_PLX_ROMULUS,
 		.subvendor	=3D PCI_VENDOR_ID_PLX,
 		.subdevice	=3D PCI_DEVICE_ID_PLX_ROMULUS,
@@ -3120,7 +3112,12 @@ static struct pci_device_id serial_pci_tbl[] =3D {
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_VENDOR_ID_PLX,
 		PCI_SUBDEVICE_ID_UNKNOWN_0x1584, 0, 0,
-		pbn_b0_4_115200 },
+		pbn_b2_4_115200 },
+	/* Unknown card - subdevice 0x1588 */
+	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
+		PCI_VENDOR_ID_PLX,
+		PCI_SUBDEVICE_ID_UNKNOWN_0x1588, 0, 0,
+		pbn_b2_8_115200 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_KEYSPAN,
 		PCI_SUBDEVICE_ID_KEYSPAN_SX2, 0, 0,
@@ -4086,6 +4083,10 @@ static struct pci_device_id serial_pci_tbl[] =3D {
 		PCI_VENDOR_ID_IBM, 0x0299,
 		0, 0, pbn_b0_bt_2_115200 },
=20
+	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
+		0x1000, 0x0012,
+		0, 0, pbn_b0_bt_2_115200 },
+
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
 		0xA000, 0x1000,
 		0, 0, pbn_b0_1_115200 },
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 925a1e5..3771277 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -464,7 +464,7 @@ config SERIAL_SAMSUNG_UARTS_4
 config SERIAL_SAMSUNG_UARTS
 	int
 	depends on ARM && PLAT_SAMSUNG
-	default 6 if ARCH_S5P6450
+	default 6 if CPU_S5P6450
 	default 4 if SERIAL_SAMSUNG_UARTS_4
 	default 3
 	help
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.=
c
index e8c9cee..6563cad 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -182,6 +182,12 @@ static struct of_device_id __devinitdata of_platform_s=
erial_table[] =3D {
 	{ .compatible =3D "ns16750",  .data =3D (void *)PORT_16750, },
 	{ .compatible =3D "ns16850",  .data =3D (void *)PORT_16850, },
 	{ .compatible =3D "nvidia,tegra20-uart", .data =3D (void *)PORT_TEGRA, },
+	{ .compatible =3D "altr,16550-FIFO32",
+		.data =3D (void *)PORT_ALTR_16550_F32, },
+	{ .compatible =3D "altr,16550-FIFO64",
+		.data =3D (void *)PORT_ALTR_16550_F64, },
+	{ .compatible =3D "altr,16550-FIFO128",
+		.data =3D (void *)PORT_ALTR_16550_F128, },
 #ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL
 	{ .compatible =3D "ibm,qpace-nwp-serial",
 		.data =3D (void *)PORT_NWPSERIAL, },
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 6c9b7cd..4f02f9c 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -114,11 +114,14 @@ static void __tty_buffer_flush(struct tty_struct *tty=
)
 {
 	struct tty_buffer *thead;
=20
-	while ((thead =3D tty->buf.head) !=3D NULL) {
-		tty->buf.head =3D thead->next;
-		tty_buffer_free(tty, thead);
+	if (tty->buf.head =3D=3D NULL)
+		return;
+	while ((thead =3D tty->buf.head->next) !=3D NULL) {
+		tty_buffer_free(tty, tty->buf.head);
+		tty->buf.head =3D thead;
 	}
-	tty->buf.tail =3D NULL;
+	WARN_ON(tty->buf.head !=3D tty->buf.tail);
+	tty->buf.head->read =3D tty->buf.head->commit;
 }
=20
 /**
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 97b2c55..fe8c04b 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -70,6 +70,7 @@ MODULE_DEVICE_TABLE (usb, wdm_ids);
 #define WDM_POLL_RUNNING	6
 #define WDM_RESPONDING		7
 #define WDM_SUSPENDING		8
+#define WDM_OVERFLOW		10
=20
 #define WDM_MAX			16
=20
@@ -134,6 +135,7 @@ static void wdm_in_callback(struct urb *urb)
 {
 	struct wdm_device *desc =3D urb->context;
 	int status =3D urb->status;
+	int length =3D urb->actual_length;
=20
 	spin_lock(&desc->iuspin);
 	clear_bit(WDM_RESPONDING, &desc->flags);
@@ -164,9 +166,17 @@ static void wdm_in_callback(struct urb *urb)
 	}
=20
 	desc->rerr =3D status;
-	desc->reslength =3D urb->actual_length;
-	memmove(desc->ubuf + desc->length, desc->inbuf, desc->reslength);
-	desc->length +=3D desc->reslength;
+	if (length + desc->length > desc->wMaxCommand) {
+		/* The buffer would overflow */
+		set_bit(WDM_OVERFLOW, &desc->flags);
+	} else {
+		/* we may already be in overflow */
+		if (!test_bit(WDM_OVERFLOW, &desc->flags)) {
+			memmove(desc->ubuf + desc->length, desc->inbuf, length);
+			desc->length +=3D length;
+			desc->reslength =3D length;
+		}
+	}
 skip_error:
 	wake_up(&desc->wait);
=20
@@ -433,6 +443,11 @@ retry:
 			rv =3D -ENODEV;
 			goto err;
 		}
+		if (test_bit(WDM_OVERFLOW, &desc->flags)) {
+			clear_bit(WDM_OVERFLOW, &desc->flags);
+			rv =3D -ENOBUFS;
+			goto err;
+		}
 		i++;
 		if (file->f_flags & O_NONBLOCK) {
 			if (!test_bit(WDM_READ, &desc->flags)) {
@@ -472,6 +487,7 @@ retry:
 			spin_unlock_irq(&desc->iuspin);
 			goto retry;
 		}
+
 		if (!desc->reslength) { /* zero length read */
 			dev_dbg(&desc->intf->dev, "%s: zero length - clearing WDM_READ\n", __fu=
nc__);
 			clear_bit(WDM_READ, &desc->flags);
@@ -926,6 +942,7 @@ static int wdm_post_reset(struct usb_interface *intf)
 	struct wdm_device *desc =3D usb_get_intfdata(intf);
 	int rv;
=20
+	clear_bit(WDM_OVERFLOW, &desc->flags);
 	rv =3D recover_from_urb_loss(desc);
 	mutex_unlock(&desc->wlock);
 	mutex_unlock(&desc->rlock);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 2564d8d..22cbe06 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2148,70 +2148,35 @@ static int hub_port_wait_reset(struct usb_hub *hub,=
 int port1,
 		if ((portstatus & USB_PORT_STAT_RESET))
 			goto delay;
=20
-		/*
-		 * Some buggy devices require a warm reset to be issued even
-		 * when the port appears not to be connected.
+		if (hub_port_warm_reset_required(hub, portstatus))
+			return -ENOTCONN;
+
+		/* Device went away? */
+		if (!(portstatus & USB_PORT_STAT_CONNECTION))
+			return -ENOTCONN;
+
+		/* bomb out completely if the connection bounced.  A USB 3.0
+		 * connection may bounce if multiple warm resets were issued,
+		 * but the device may have successfully re-connected. Ignore it.
 		 */
-		if (!warm) {
-			/*
-			 * Some buggy devices can cause an NEC host controller
-			 * to transition to the "Error" state after a hot port
-			 * reset.  This will show up as the port state in
-			 * "Inactive", and the port may also report a
-			 * disconnect.  Forcing a warm port reset seems to make
-			 * the device work.
-			 *
-			 * See https://bugzilla.kernel.org/show_bug.cgi?id=3D41752
-			 */
-			if (hub_port_warm_reset_required(hub, portstatus)) {
-				int ret;
-
-				if ((portchange & USB_PORT_STAT_C_CONNECTION))
-					clear_port_feature(hub->hdev, port1,
-							USB_PORT_FEAT_C_CONNECTION);
-				if (portchange & USB_PORT_STAT_C_LINK_STATE)
-					clear_port_feature(hub->hdev, port1,
-							USB_PORT_FEAT_C_PORT_LINK_STATE);
-				if (portchange & USB_PORT_STAT_C_RESET)
-					clear_port_feature(hub->hdev, port1,
-							USB_PORT_FEAT_C_RESET);
-				dev_dbg(hub->intfdev, "hot reset failed, warm reset port %d\n",
-						port1);
-				ret =3D hub_port_reset(hub, port1,
-						udev, HUB_BH_RESET_TIME,
-						true);
-				if ((portchange & USB_PORT_STAT_C_CONNECTION))
-					clear_port_feature(hub->hdev, port1,
-							USB_PORT_FEAT_C_CONNECTION);
-				return ret;
-			}
-			/* Device went away? */
-			if (!(portstatus & USB_PORT_STAT_CONNECTION))
-				return -ENOTCONN;
-
-			/* bomb out completely if the connection bounced */
-			if ((portchange & USB_PORT_STAT_C_CONNECTION))
-				return -ENOTCONN;
-
-			if ((portstatus & USB_PORT_STAT_ENABLE)) {
-				if (hub_is_wusb(hub))
-					udev->speed =3D USB_SPEED_WIRELESS;
-				else if (hub_is_superspeed(hub->hdev))
-					udev->speed =3D USB_SPEED_SUPER;
-				else if (portstatus & USB_PORT_STAT_HIGH_SPEED)
-					udev->speed =3D USB_SPEED_HIGH;
-				else if (portstatus & USB_PORT_STAT_LOW_SPEED)
-					udev->speed =3D USB_SPEED_LOW;
-				else
-					udev->speed =3D USB_SPEED_FULL;
+		if (!hub_is_superspeed(hub->hdev) &&
+				(portchange & USB_PORT_STAT_C_CONNECTION))
+			return -ENOTCONN;
+
+		if ((portstatus & USB_PORT_STAT_ENABLE)) {
+			if (!udev)
 				return 0;
-			}
-		} else {
-			if (!(portstatus & USB_PORT_STAT_CONNECTION) ||
-					hub_port_warm_reset_required(hub,
-						portstatus))
-				return -ENOTCONN;
=20
+			if (hub_is_wusb(hub))
+				udev->speed =3D USB_SPEED_WIRELESS;
+			else if (hub_is_superspeed(hub->hdev))
+				udev->speed =3D USB_SPEED_SUPER;
+			else if (portstatus & USB_PORT_STAT_HIGH_SPEED)
+				udev->speed =3D USB_SPEED_HIGH;
+			else if (portstatus & USB_PORT_STAT_LOW_SPEED)
+				udev->speed =3D USB_SPEED_LOW;
+			else
+				udev->speed =3D USB_SPEED_FULL;
 			return 0;
 		}
=20
@@ -2229,16 +2194,16 @@ delay:
 }
=20
 static void hub_port_finish_reset(struct usb_hub *hub, int port1,
-			struct usb_device *udev, int *status, bool warm)
+			struct usb_device *udev, int *status)
 {
 	switch (*status) {
 	case 0:
-		if (!warm) {
-			struct usb_hcd *hcd;
-			/* TRSTRCY =3D 10 ms; plus some extra */
-			msleep(10 + 40);
+		/* TRSTRCY =3D 10 ms; plus some extra */
+		msleep(10 + 40);
+		if (udev) {
+			struct usb_hcd *hcd =3D bus_to_hcd(udev->bus);
+
 			update_devnum(udev, 0);
-			hcd =3D bus_to_hcd(udev->bus);
 			/* The xHC may think the device is already reset,
 			 * so ignore the status.
 			 */
@@ -2250,14 +2215,15 @@ static void hub_port_finish_reset(struct usb_hub *h=
ub, int port1,
 	case -ENODEV:
 		clear_port_feature(hub->hdev,
 				port1, USB_PORT_FEAT_C_RESET);
-		/* FIXME need disconnect() for NOTATTACHED device */
 		if (hub_is_superspeed(hub->hdev)) {
 			clear_port_feature(hub->hdev, port1,
 					USB_PORT_FEAT_C_BH_PORT_RESET);
 			clear_port_feature(hub->hdev, port1,
 					USB_PORT_FEAT_C_PORT_LINK_STATE);
+			clear_port_feature(hub->hdev, port1,
+					USB_PORT_FEAT_C_CONNECTION);
 		}
-		if (!warm)
+		if (udev)
 			usb_set_device_state(udev, *status
 					? USB_STATE_NOTATTACHED
 					: USB_STATE_DEFAULT);
@@ -2270,18 +2236,30 @@ static int hub_port_reset(struct usb_hub *hub, int =
port1,
 			struct usb_device *udev, unsigned int delay, bool warm)
 {
 	int i, status;
+	u16 portchange, portstatus;
=20
-	if (!warm) {
-		/* Block EHCI CF initialization during the port reset.
-		 * Some companion controllers don't like it when they mix.
-		 */
-		down_read(&ehci_cf_port_reset_rwsem);
-	} else {
-		if (!hub_is_superspeed(hub->hdev)) {
+	if (!hub_is_superspeed(hub->hdev)) {
+		if (warm) {
 			dev_err(hub->intfdev, "only USB3 hub support "
 						"warm reset\n");
 			return -EINVAL;
 		}
+		/* Block EHCI CF initialization during the port reset.
+		 * Some companion controllers don't like it when they mix.
+		 */
+		down_read(&ehci_cf_port_reset_rwsem);
+	} else if (!warm) {
+		/*
+		 * If the caller hasn't explicitly requested a warm reset,
+		 * double check and see if one is needed.
+		 */
+		status =3D hub_port_status(hub, port1,
+					&portstatus, &portchange);
+		if (status < 0)
+			goto done;
+
+		if (hub_port_warm_reset_required(hub, portstatus))
+			warm =3D true;
 	}
=20
 	/* Reset the port */
@@ -2302,10 +2280,33 @@ static int hub_port_reset(struct usb_hub *hub, int =
port1,
 						status);
 		}
=20
-		/* return on disconnect or reset */
+		/* Check for disconnect or reset */
 		if (status =3D=3D 0 || status =3D=3D -ENOTCONN || status =3D=3D -ENODEV)=
 {
-			hub_port_finish_reset(hub, port1, udev, &status, warm);
-			goto done;
+			hub_port_finish_reset(hub, port1, udev, &status);
+
+			if (!hub_is_superspeed(hub->hdev))
+				goto done;
+
+			/*
+			 * If a USB 3.0 device migrates from reset to an error
+			 * state, re-issue the warm reset.
+			 */
+			if (hub_port_status(hub, port1,
+					&portstatus, &portchange) < 0)
+				goto done;
+
+			if (!hub_port_warm_reset_required(hub, portstatus))
+				goto done;
+
+			/*
+			 * If the port is in SS.Inactive or Compliance Mode, the
+			 * hot or warm reset failed.  Try another warm reset.
+			 */
+			if (!warm) {
+				dev_dbg(hub->intfdev, "hot reset failed, warm reset port %d\n",
+						port1);
+				warm =3D true;
+			}
 		}
=20
 		dev_dbg (hub->intfdev,
@@ -2319,7 +2320,7 @@ static int hub_port_reset(struct usb_hub *hub, int po=
rt1,
 		port1);
=20
 done:
-	if (!warm)
+	if (!hub_is_superspeed(hub->hdev))
 		up_read(&ehci_cf_port_reset_rwsem);
=20
 	return status;
@@ -3735,12 +3736,21 @@ static void hub_events(void)
 			 */
 			if (hub_port_warm_reset_required(hub, portstatus)) {
 				int status;
+				struct usb_device *udev =3D
+					hub->hdev->children[i - 1];
=20
 				dev_dbg(hub_dev, "warm reset port %d\n", i);
-				status =3D hub_port_reset(hub, i, NULL,
-						HUB_BH_RESET_TIME, true);
-				if (status < 0)
-					hub_port_disable(hub, i, 1);
+				if (!udev) {
+					status =3D hub_port_reset(hub, i,
+							NULL, HUB_BH_RESET_TIME,
+							true);
+					if (status < 0)
+						hub_port_disable(hub, i, 1);
+				} else {
+					usb_lock_device(udev);
+					status =3D usb_reset_device(udev);
+					usb_unlock_device(udev);
+				}
 				connect_change =3D 0;
 			}
=20
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 381d00d..913a178 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -91,6 +91,7 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x10C4, 0x813F) }, /* Tams Master Easy Control */
 	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
+	{ USB_DEVICE(0x2405, 0x0003) }, /* West Mountain Radio RIGblaster Advanta=
ge */
 	{ USB_DEVICE(0x10C4, 0x8156) }, /* B&G H3000 link cable */
 	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
 	{ USB_DEVICE(0x10C4, 0x815F) }, /* Timewave HamLinkUSB */
@@ -156,6 +157,25 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
 	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
 	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
+	{ USB_DEVICE(0x1FB9, 0x0100) }, /* Lake Shore Model 121 Current Source */
+	{ USB_DEVICE(0x1FB9, 0x0200) }, /* Lake Shore Model 218A Temperature Moni=
tor */
+	{ USB_DEVICE(0x1FB9, 0x0201) }, /* Lake Shore Model 219 Temperature Monit=
or */
+	{ USB_DEVICE(0x1FB9, 0x0202) }, /* Lake Shore Model 233 Temperature Trans=
mitter */
+	{ USB_DEVICE(0x1FB9, 0x0203) }, /* Lake Shore Model 235 Temperature Trans=
mitter */
+	{ USB_DEVICE(0x1FB9, 0x0300) }, /* Lake Shore Model 335 Temperature Contr=
oller */
+	{ USB_DEVICE(0x1FB9, 0x0301) }, /* Lake Shore Model 336 Temperature Contr=
oller */
+	{ USB_DEVICE(0x1FB9, 0x0302) }, /* Lake Shore Model 350 Temperature Contr=
oller */
+	{ USB_DEVICE(0x1FB9, 0x0303) }, /* Lake Shore Model 371 AC Bridge */
+	{ USB_DEVICE(0x1FB9, 0x0400) }, /* Lake Shore Model 411 Handheld Gaussmet=
er */
+	{ USB_DEVICE(0x1FB9, 0x0401) }, /* Lake Shore Model 425 Gaussmeter */
+	{ USB_DEVICE(0x1FB9, 0x0402) }, /* Lake Shore Model 455A Gaussmeter */
+	{ USB_DEVICE(0x1FB9, 0x0403) }, /* Lake Shore Model 475A Gaussmeter */
+	{ USB_DEVICE(0x1FB9, 0x0404) }, /* Lake Shore Model 465 Three Axis Gaussm=
eter */
+	{ USB_DEVICE(0x1FB9, 0x0600) }, /* Lake Shore Model 625A Superconducting =
MPS */
+	{ USB_DEVICE(0x1FB9, 0x0601) }, /* Lake Shore Model 642A Magnet Power Sup=
ply */
+	{ USB_DEVICE(0x1FB9, 0x0602) }, /* Lake Shore Model 648 Magnet Power Supp=
ly */
+	{ USB_DEVICE(0x1FB9, 0x0700) }, /* Lake Shore Model 737 VSM Controller */
+	{ USB_DEVICE(0x1FB9, 0x0701) }, /* Lake Shore Model 776 Hall Matrix */
 	{ USB_DEVICE(0x3195, 0xF190) }, /* Link Instruments MSO-19 */
 	{ USB_DEVICE(0x3195, 0xF280) }, /* Link Instruments MSO-28 */
 	{ USB_DEVICE(0x3195, 0xF281) }, /* Link Instruments MSO-28 */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 24a3ea6..4418538 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -341,6 +341,8 @@ static void option_instat_callback(struct urb *urb);
 #define CINTERION_PRODUCT_EU3_E			0x0051
 #define CINTERION_PRODUCT_EU3_P			0x0052
 #define CINTERION_PRODUCT_PH8			0x0053
+#define CINTERION_PRODUCT_AH6			0x0055
+#define CINTERION_PRODUCT_PLS8			0x0060
=20
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -579,6 +581,7 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE(QUANTA_VENDOR_ID, 0xea42),
 		.driver_info =3D (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1c05, USB_CLASS_COMM,=
 0x02, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1c1f, USB_CLASS_COMM,=
 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1c23, USB_CLASS_COMM,=
 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173, 0x=
ff, 0xff, 0xff),
 		.driver_info =3D (kernel_ulong_t) &net_intf1_blacklist },
@@ -1260,6 +1263,8 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_E) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_P) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AH6) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLS8) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDM) },=20
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC25_MDM) },
diff --git a/drivers/usb/serial/qcaux.c b/drivers/usb/serial/qcaux.c
index 87271e3..153d719 100644
--- a/drivers/usb/serial/qcaux.c
+++ b/drivers/usb/serial/qcaux.c
@@ -69,6 +69,7 @@ static struct usb_device_id id_table[] =3D {
 	{ USB_VENDOR_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, 0xff, 0xfd, 0xff) },=
  /* NMEA */
 	{ USB_VENDOR_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, 0xff, 0xfe, 0xff) },=
  /* WMC */
 	{ USB_VENDOR_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, 0xff, 0xff, 0xff) },=
  /* DIAG */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1fac, 0x0151, 0xff, 0xff, 0xff) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initi=
alizers.c
index 7ab9046..105d900 100644
--- a/drivers/usb/storage/initializers.c
+++ b/drivers/usb/storage/initializers.c
@@ -92,8 +92,8 @@ int usb_stor_ucr61s2b_init(struct us_data *us)
 	return 0;
 }
=20
-/* This places the HUAWEI usb dongles in multi-port mode */
-static int usb_stor_huawei_feature_init(struct us_data *us)
+/* This places the HUAWEI E220 devices in multi-port mode */
+int usb_stor_huawei_e220_init(struct us_data *us)
 {
 	int result;
=20
@@ -104,75 +104,3 @@ static int usb_stor_huawei_feature_init(struct us_data=
 *us)
 	US_DEBUGP("Huawei mode set result is %d\n", result);
 	return 0;
 }
-
-/*
- * It will send a scsi switch command called rewind' to huawei dongle.
- * When the dongle receives this command at the first time,
- * it will reboot immediately. After rebooted, it will ignore this command=
.
- * So it is  unnecessary to read its response.
- */
-static int usb_stor_huawei_scsi_init(struct us_data *us)
-{
-	int result =3D 0;
-	int act_len =3D 0;
-	struct bulk_cb_wrap *bcbw =3D (struct bulk_cb_wrap *) us->iobuf;
-	char rewind_cmd[] =3D {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
-			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
-
-	bcbw->Signature =3D cpu_to_le32(US_BULK_CB_SIGN);
-	bcbw->Tag =3D 0;
-	bcbw->DataTransferLength =3D 0;
-	bcbw->Flags =3D bcbw->Lun =3D 0;
-	bcbw->Length =3D sizeof(rewind_cmd);
-	memset(bcbw->CDB, 0, sizeof(bcbw->CDB));
-	memcpy(bcbw->CDB, rewind_cmd, sizeof(rewind_cmd));
-
-	result =3D usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, bcbw,
-					US_BULK_CB_WRAP_LEN, &act_len);
-	US_DEBUGP("transfer actual length=3D%d, result=3D%d\n", act_len, result);
-	return result;
-}
-
-/*
- * It tries to find the supported Huawei USB dongles.
- * In Huawei, they assign the following product IDs
- * for all of their mobile broadband dongles,
- * including the new dongles in the future.
- * So if the product ID is not included in this list,
- * it means it is not Huawei's mobile broadband dongles.
- */
-static int usb_stor_huawei_dongles_pid(struct us_data *us)
-{
-	struct usb_interface_descriptor *idesc;
-	int idProduct;
-
-	idesc =3D &us->pusb_intf->cur_altsetting->desc;
-	idProduct =3D le16_to_cpu(us->pusb_dev->descriptor.idProduct);
-	/* The first port is CDROM,
-	 * means the dongle in the single port mode,
-	 * and a switch command is required to be sent. */
-	if (idesc && idesc->bInterfaceNumber =3D=3D 0) {
-		if ((idProduct =3D=3D 0x1001)
-			|| (idProduct =3D=3D 0x1003)
-			|| (idProduct =3D=3D 0x1004)
-			|| (idProduct >=3D 0x1401 && idProduct <=3D 0x1500)
-			|| (idProduct >=3D 0x1505 && idProduct <=3D 0x1600)
-			|| (idProduct >=3D 0x1c02 && idProduct <=3D 0x2202)) {
-			return 1;
-		}
-	}
-	return 0;
-}
-
-int usb_stor_huawei_init(struct us_data *us)
-{
-	int result =3D 0;
-
-	if (usb_stor_huawei_dongles_pid(us)) {
-		if (le16_to_cpu(us->pusb_dev->descriptor.idProduct) >=3D 0x1446)
-			result =3D usb_stor_huawei_scsi_init(us);
-		else
-			result =3D usb_stor_huawei_feature_init(us);
-	}
-	return result;
-}
diff --git a/drivers/usb/storage/initializers.h b/drivers/usb/storage/initi=
alizers.h
index 5376d4f..529327f 100644
--- a/drivers/usb/storage/initializers.h
+++ b/drivers/usb/storage/initializers.h
@@ -46,5 +46,5 @@ int usb_stor_euscsi_init(struct us_data *us);
  * flash reader */
 int usb_stor_ucr61s2b_init(struct us_data *us);
=20
-/* This places the HUAWEI usb dongles in multi-port mode */
-int usb_stor_huawei_init(struct us_data *us);
+/* This places the HUAWEI E220 devices in multi-port mode */
+int usb_stor_huawei_e220_init(struct us_data *us);
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusu=
al_devs.h
index 12640ef..fa8a1b2 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1515,10 +1515,335 @@ UNUSUAL_DEV(  0x1210, 0x0003, 0x0100, 0x0100,
 /* Reported by fangxiaozhi <huananhu@huawei.com>
  * This brings the HUAWEI data card devices into multi-port mode
  */
-UNUSUAL_VENDOR_INTF(0x12d1, 0x08, 0x06, 0x50,
+UNUSUAL_DEV(  0x12d1, 0x1001, 0x0000, 0x0000,
 		"HUAWEI MOBILE",
 		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_init,
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1003, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1004, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1401, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1402, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1403, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1404, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1405, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1406, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1407, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1408, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1409, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x140A, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x140B, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x140C, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x140D, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x140E, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x140F, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1410, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1411, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1412, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1413, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1414, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1415, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1416, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1417, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1418, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1419, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x141A, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x141B, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x141C, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x141D, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x141E, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x141F, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1420, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1421, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1422, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1423, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1424, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1425, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1426, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1427, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1428, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1429, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x142A, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x142B, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x142C, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x142D, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x142E, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x142F, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1430, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1431, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1432, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1433, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1434, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1435, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1436, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1437, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1438, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x1439, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x143A, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x143B, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x143C, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x143D, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x143E, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		0),
+UNUSUAL_DEV(  0x12d1, 0x143F, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
 		0),
=20
 /* Reported by Vilius Bilinkevicius <vilisas AT xxx DOT lt) */
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index c374978..5149d4e 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -918,7 +918,8 @@ void w1_search(struct w1_master *dev, u8 search_type, w=
1_slave_found_callback cb
 			tmp64 =3D (triplet_ret >> 2);
 			rn |=3D (tmp64 << i);
=20
-			if (kthread_should_stop()) {
+			/* ensure we're called from kthread and not by netlink callback */
+			if (!dev->priv && kthread_should_stop()) {
 				dev_dbg(&dev->dev, "Abort w1_search\n");
 				return;
 			}
diff --git a/drivers/xen/xen-pciback/pciback_ops.c b/drivers/xen/xen-pcibac=
k/pciback_ops.c
index d07c4cd..e947e78 100644
--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -114,7 +114,8 @@ void xen_pcibk_reset_device(struct pci_dev *dev)
 		if (dev->msi_enabled)
 			pci_disable_msi(dev);
 #endif
-		pci_disable_device(dev);
+		if (pci_is_enabled(dev))
+			pci_disable_device(dev);
=20
 		pci_write_config_word(dev, PCI_COMMAND, 0);
=20
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 613edd8..833dddb 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1064,7 +1064,9 @@ void bd_set_size(struct block_device *bdev, loff_t si=
ze)
 {
 	unsigned bsize =3D bdev_logical_block_size(bdev);
=20
-	bdev->bd_inode->i_size =3D size;
+	mutex_lock(&bdev->bd_inode->i_mutex);
+	i_size_write(bdev->bd_inode, size);
+	mutex_unlock(&bdev->bd_inode->i_mutex);
 	while (bsize < PAGE_CACHE_SIZE) {
 		if (size & bsize)
 			break;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f4b839f..9899205 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -543,6 +543,7 @@ static int __btrfs_close_devices(struct btrfs_fs_device=
s *fs_devices)
 		new_device->writeable =3D 0;
 		new_device->in_fs_metadata =3D 0;
 		new_device->can_discard =3D 0;
+		spin_lock_init(&new_device->io_lock);
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
=20
 		call_rcu(&device->rcu, free_device);
@@ -576,6 +577,12 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_de=
vices)
 		__btrfs_close_devices(fs_devices);
 		free_fs_devices(fs_devices);
 	}
+	/*
+	 * Wait for rcu kworkers under __btrfs_close_devices
+	 * to finish all blkdev_puts so device is really
+	 * free when umount is done.
+	 */
+	rcu_barrier();
 	return ret;
 }
=20
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b1451af..b3a2a40 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -561,6 +561,11 @@ cifs_get_root(struct smb_vol *vol, struct super_block =
*sb)
 			dentry =3D ERR_PTR(-ENOENT);
 			break;
 		}
+		if (!S_ISDIR(dir->i_mode)) {
+			dput(dentry);
+			dentry =3D ERR_PTR(-ENOTDIR);
+			break;
+		}
=20
 		/* skip separators */
 		while (*s =3D=3D sep)
diff --git a/fs/compat.c b/fs/compat.c
index e07a3d3..4bf082d 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -572,6 +572,10 @@ ssize_t compat_rw_copy_check_uvector(int type,
 	}
 	*ret_pointer =3D iov;
=20
+	ret =3D -EFAULT;
+	if (!access_ok(VERIFY_READ, uvector, nr_segs*sizeof(*uvector)))
+		goto out;
+
 	/*
 	 * Single unix specification:
 	 * We should -EINVAL if an element length is not >=3D 0 and fitting an
@@ -1103,17 +1107,12 @@ static ssize_t compat_do_readv_writev(int type, str=
uct file *file,
 	if (!file->f_op)
 		goto out;
=20
-	ret =3D -EFAULT;
-	if (!access_ok(VERIFY_READ, uvector, nr_segs*sizeof(*uvector)))
-		goto out;
-
-	tot_len =3D compat_rw_copy_check_uvector(type, uvector, nr_segs,
+	ret =3D compat_rw_copy_check_uvector(type, uvector, nr_segs,
 					       UIO_FASTIOV, iovstack, &iov, 1);
-	if (tot_len =3D=3D 0) {
-		ret =3D 0;
+	if (ret <=3D 0)
 		goto out;
-	}
=20
+	tot_len =3D ret;
 	ret =3D rw_verify_area(type, file, pos, tot_len);
 	if (ret < 0)
 		goto out;
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 922d289..b7f314f 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -374,7 +374,7 @@ static struct block_device *ext3_blkdev_get(dev_t dev, =
struct super_block *sb)
 	return bdev;
=20
 fail:
-	ext3_msg(sb, "error: failed to open journal device %s: %ld",
+	ext3_msg(sb, KERN_ERR, "error: failed to open journal device %s: %ld",
 		__bdevname(dev, b), PTR_ERR(bdev));
=20
 	return NULL;
@@ -902,7 +902,7 @@ static ext3_fsblk_t get_sb_block(void **data, struct su=
per_block *sb)
 	/*todo: use simple_strtoll with >32bit ext3 */
 	sb_block =3D simple_strtoul(options, &options, 0);
 	if (*options && *options !=3D ',') {
-		ext3_msg(sb, "error: invalid sb specification: %s",
+		ext3_msg(sb, KERN_ERR, "error: invalid sb specification: %s",
 		       (char *) *data);
 		return 1;
 	}
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index a87a656..c25cf15 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -512,7 +512,8 @@ xlate_to_uni(const unsigned char *name, int len, unsign=
ed char *outname,
 	int charlen;
=20
 	if (utf8) {
-		*outlen =3D utf8s_to_utf16s(name, len, (wchar_t *)outname);
+		*outlen =3D utf8s_to_utf16s(name, len, UTF16_HOST_ENDIAN,
+				(wchar_t *) outname, FAT_LFN_LEN + 2);
 		if (*outlen < 0)
 			return *outlen;
 		else if (*outlen > FAT_LFN_LEN)
diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index 4f9319a..98f1261 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -366,20 +366,14 @@ static void nfs_async_rename_done(struct rpc_task *ta=
sk, void *calldata)
 	struct inode *old_dir =3D data->old_dir;
 	struct inode *new_dir =3D data->new_dir;
 	struct dentry *old_dentry =3D data->old_dentry;
-	struct dentry *new_dentry =3D data->new_dentry;
=20
 	if (!NFS_PROTO(old_dir)->rename_done(task, old_dir, new_dir)) {
 		rpc_restart_call_prepare(task);
 		return;
 	}
=20
-	if (task->tk_status !=3D 0) {
+	if (task->tk_status !=3D 0)
 		nfs_cancel_async_unlink(old_dentry);
-		return;
-	}
-
-	d_drop(old_dentry);
-	d_drop(new_dentry);
 }
=20
 /**
@@ -589,6 +583,18 @@ nfs_sillyrename(struct inode *dir, struct dentry *dent=
ry)
 	error =3D rpc_wait_for_completion_task(task);
 	if (error =3D=3D 0)
 		error =3D task->tk_status;
+	switch (error) {
+	case 0:
+		/* The rename succeeded */
+		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
+		d_move(dentry, sdentry);
+		break;
+	case -ERESTARTSYS:
+		/* The result of the rename is unknown. Play it safe by
+		 * forcing a new lookup */
+		d_drop(dentry);
+		d_drop(sdentry);
+	}
 	rpc_put_task(task);
 out_dput:
 	dput(sdentry);
diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index 44a88a9..0eb059ec 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -114,34 +114,57 @@ int utf32_to_utf8(unicode_t u, u8 *s, int maxlen)
 }
 EXPORT_SYMBOL(utf32_to_utf8);
=20
-int utf8s_to_utf16s(const u8 *s, int len, wchar_t *pwcs)
+static inline void put_utf16(wchar_t *s, unsigned c, enum utf16_endian end=
ian)
+{
+	switch (endian) {
+	default:
+		*s =3D (wchar_t) c;
+		break;
+	case UTF16_LITTLE_ENDIAN:
+		*s =3D __cpu_to_le16(c);
+		break;
+	case UTF16_BIG_ENDIAN:
+		*s =3D __cpu_to_be16(c);
+		break;
+	}
+}
+
+int utf8s_to_utf16s(const u8 *s, int len, enum utf16_endian endian,
+		wchar_t *pwcs, int maxlen)
 {
 	u16 *op;
 	int size;
 	unicode_t u;
=20
 	op =3D pwcs;
-	while (*s && len > 0) {
+	while (len > 0 && maxlen > 0 && *s) {
 		if (*s & 0x80) {
 			size =3D utf8_to_utf32(s, len, &u);
 			if (size < 0)
 				return -EINVAL;
+			s +=3D size;
+			len -=3D size;
=20
 			if (u >=3D PLANE_SIZE) {
+				if (maxlen < 2)
+					break;
 				u -=3D PLANE_SIZE;
-				*op++ =3D (wchar_t) (SURROGATE_PAIR |
-						((u >> 10) & SURROGATE_BITS));
-				*op++ =3D (wchar_t) (SURROGATE_PAIR |
+				put_utf16(op++, SURROGATE_PAIR |
+						((u >> 10) & SURROGATE_BITS),
+						endian);
+				put_utf16(op++, SURROGATE_PAIR |
 						SURROGATE_LOW |
-						(u & SURROGATE_BITS));
+						(u & SURROGATE_BITS),
+						endian);
+				maxlen -=3D 2;
 			} else {
-				*op++ =3D (wchar_t) u;
+				put_utf16(op++, u, endian);
+				maxlen--;
 			}
-			s +=3D size;
-			len -=3D size;
 		} else {
-			*op++ =3D *s++;
+			put_utf16(op++, *s++, endian);
 			len--;
+			maxlen--;
 		}
 	}
 	return op - pwcs;
diff --git a/fs/pipe.c b/fs/pipe.c
index 05ed5ca..8ca88fc 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -859,6 +859,9 @@ pipe_rdwr_open(struct inode *inode, struct file *filp)
 {
 	int ret =3D -ENOENT;
=20
+	if (!(filp->f_mode & (FMODE_READ|FMODE_WRITE)))
+		return -EINVAL;
+
 	mutex_lock(&inode->i_mutex);
=20
 	if (inode->i_pipe) {
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 98f34b8..6712ab6 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -72,8 +72,8 @@ typedef void (*dm_postsuspend_fn) (struct dm_target *ti);
 typedef int (*dm_preresume_fn) (struct dm_target *ti);
 typedef void (*dm_resume_fn) (struct dm_target *ti);
=20
-typedef int (*dm_status_fn) (struct dm_target *ti, status_type_t status_ty=
pe,
-			     char *result, unsigned int maxlen);
+typedef void (*dm_status_fn) (struct dm_target *ti, status_type_t status_t=
ype,
+			      char *result, unsigned maxlen);
=20
 typedef int (*dm_message_fn) (struct dm_target *ti, unsigned argc, char **=
argv);
=20
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 1721c41..ce95a4b 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -30,7 +30,12 @@
 #define EFI_UNSUPPORTED		( 3 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_BAD_BUFFER_SIZE     ( 4 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_BUFFER_TOO_SMALL	( 5 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_NOT_READY		( 6 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_DEVICE_ERROR	( 7 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_WRITE_PROTECTED	( 8 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_OUT_OF_RESOURCES	( 9 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_NOT_FOUND		(14 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_SECURITY_VIOLATION	(26 | (1UL << (BITS_PER_LONG-1)))
=20
 typedef unsigned long efi_status_t;
 typedef u8 efi_bool_t;
@@ -470,6 +475,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
+	efi_query_variable_info_t *query_variable_info;
 };
=20
 struct efivars {
diff --git a/include/linux/nls.h b/include/linux/nls.h
index d47beef..5dc635f 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -43,7 +43,7 @@ enum utf16_endian {
 	UTF16_BIG_ENDIAN
 };
=20
-/* nls.c */
+/* nls_base.c */
 extern int register_nls(struct nls_table *);
 extern int unregister_nls(struct nls_table *);
 extern struct nls_table *load_nls(char *);
@@ -52,7 +52,8 @@ extern struct nls_table *load_nls_default(void);
=20
 extern int utf8_to_utf32(const u8 *s, int len, unicode_t *pu);
 extern int utf32_to_utf8(unicode_t u, u8 *s, int maxlen);
-extern int utf8s_to_utf16s(const u8 *s, int len, wchar_t *pwcs);
+extern int utf8s_to_utf16s(const u8 *s, int len,
+		enum utf16_endian endian, wchar_t *pwcs, int maxlen);
 extern int utf16s_to_utf8s(const wchar_t *pwcs, int len,
 		enum utf16_endian endian, u8 *s, int maxlen);
=20
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index bae516e..42e35c3 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -48,7 +48,10 @@
 #define PORT_TEGRA	20	/* NVIDIA Tegra internal UART */
 #define PORT_XR17D15X	21	/* Exar XR17D15x UART */
 #define PORT_BRCM_TRUMANAGE	25
-#define PORT_MAX_8250	25	/* max port ID */
+#define PORT_ALTR_16550_F32 26	/* Altera 16550 UART with 32 FIFOs */
+#define PORT_ALTR_16550_F64 27	/* Altera 16550 UART with 64 FIFOs */
+#define PORT_ALTR_16550_F128 28 /* Altera 16550 UART with 128 FIFOs */
+#define PORT_MAX_8250	28	/* max port ID */
=20
 /*
  * ARM specific type numbers.  These are not currently guaranteed
diff --git a/kernel/signal.c b/kernel/signal.c
index d2f55ea..71e1816 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -481,6 +481,9 @@ flush_signal_handlers(struct task_struct *t, int force_=
default)
 		if (force_default || ka->sa.sa_handler !=3D SIG_IGN)
 			ka->sa.sa_handler =3D SIG_DFL;
 		ka->sa.sa_flags =3D 0;
+#ifdef SA_RESTORER
+		ka->sa.sa_restorer =3D NULL;
+#endif
 		sigemptyset(&ka->sa.sa_mask);
 		ka++;
 	}
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index cd31345..762264d 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -386,24 +386,28 @@ config KPROBE_EVENT
 	  If you want to use perf tools, this option is strongly recommended.
=20
 config DYNAMIC_FTRACE
-	bool "enable/disable ftrace tracepoints dynamically"
+	bool "enable/disable function tracing dynamically"
 	depends on FUNCTION_TRACER
 	depends on HAVE_DYNAMIC_FTRACE
 	default y
 	help
-          This option will modify all the calls to ftrace dynamically
-	  (will patch them out of the binary image and replace them
-	  with a No-Op instruction) as they are called. A table is
-	  created to dynamically enable them again.
+	  This option will modify all the calls to function tracing
+	  dynamically (will patch them out of the binary image and
+	  replace them with a No-Op instruction) on boot up. During
+	  compile time, a table is made of all the locations that ftrace
+	  can function trace, and this table is linked into the kernel
+	  image. When this is enabled, functions can be individually
+	  enabled, and the functions not enabled will not affect
+	  performance of the system.
+
+	  See the files in /sys/kernel/debug/tracing:
+	    available_filter_functions
+	    set_ftrace_filter
+	    set_ftrace_notrace
=20
 	  This way a CONFIG_FUNCTION_TRACER kernel is slightly larger, but
 	  otherwise has native performance as long as no tracing is active.
=20
-	  The changes to the code are done by a kernel thread that
-	  wakes up once a second and checks to see if any ftrace calls
-	  were made. If so, it runs stop_machine (stops all CPUS)
-	  and modifies the code to jump over the call to ftrace.
-
 config FUNCTION_PROFILER
 	bool "Kernel function profiler"
 	depends on FUNCTION_TRACER
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 9ad7d1e..09d87b7 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -515,19 +515,20 @@ int __ref online_pages(unsigned long pfn, unsigned lo=
ng nr_pages)
=20
 	zone->present_pages +=3D onlined_pages;
 	zone->zone_pgdat->node_present_pages +=3D onlined_pages;
-	if (need_zonelists_rebuild)
-		build_all_zonelists(zone);
-	else
-		zone_pcp_update(zone);
+	if (onlined_pages) {
+		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
+		if (need_zonelists_rebuild)
+			build_all_zonelists(zone);
+		else
+			zone_pcp_update(zone);
+	}
=20
 	mutex_unlock(&zonelists_mutex);
=20
 	init_per_zone_wmark_min();
=20
-	if (onlined_pages) {
+	if (onlined_pages)
 		kswapd_run(zone_to_nid(zone));
-		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
-	}
=20
 	vm_total_pages =3D nr_free_pagecache_pages();
=20
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index e920aa3..70e814a 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -434,12 +434,6 @@ compat_process_vm_rw(compat_pid_t pid,
 	if (flags !=3D 0)
 		return -EINVAL;
=20
-	if (!access_ok(VERIFY_READ, lvec, liovcnt * sizeof(*lvec)))
-		goto out;
-
-	if (!access_ok(VERIFY_READ, rvec, riovcnt * sizeof(*rvec)))
-		goto out;
-
 	if (vm_write)
 		rc =3D compat_rw_copy_check_uvector(WRITE, lvec, liovcnt,
 						  UIO_FASTIOV, iovstack_l,
@@ -464,8 +458,6 @@ free_iovecs:
 		kfree(iov_r);
 	if (iov_l !=3D iovstack_l)
 		kfree(iov_l);
-
-out:
 	return rc;
 }
=20
diff --git a/net/batman-adv/icmp_socket.c b/net/batman-adv/icmp_socket.c
index ac3520e0..0c82ce3 100644
--- a/net/batman-adv/icmp_socket.c
+++ b/net/batman-adv/icmp_socket.c
@@ -136,10 +136,9 @@ static ssize_t bat_socket_read(struct file *file, char=
 __user *buf,
=20
 	spin_unlock_bh(&socket_client->lock);
=20
-	error =3D __copy_to_user(buf, &socket_packet->icmp_packet,
-			       socket_packet->icmp_len);
+	packet_len =3D min(count, socket_packet->icmp_len);
+	error =3D copy_to_user(buf, &socket_packet->icmp_packet, packet_len);
=20
-	packet_len =3D socket_packet->icmp_len;
 	kfree(socket_packet);
=20
 	if (error)
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 19acd00..16fbf8c 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -2354,6 +2354,8 @@ static const struct proto_ops dn_proto_ops =3D {
 	.sendpage =3D	sock_no_sendpage,
 };
=20
+void dn_register_sysctl_skeleton(void);
+void dn_unregister_sysctl_skeleton(void);
 void dn_register_sysctl(void);
 void dn_unregister_sysctl(void);
=20
@@ -2374,6 +2376,7 @@ static int __init decnet_init(void)
 	if (rc !=3D 0)
 		goto out;
=20
+	dn_register_sysctl_skeleton();
 	dn_neigh_init();
 	dn_dev_init();
 	dn_route_init();
@@ -2413,6 +2416,7 @@ static void __exit decnet_exit(void)
 	dn_fib_cleanup();
=20
 	proc_net_remove(&init_net, "decnet");
+	dn_unregister_sysctl_skeleton();
=20
 	proto_unregister(&dn_proto);
=20
diff --git a/net/decnet/sysctl_net_decnet.c b/net/decnet/sysctl_net_decnet.=
c
index 02e75d1..d50a13c 100644
--- a/net/decnet/sysctl_net_decnet.c
+++ b/net/decnet/sysctl_net_decnet.c
@@ -55,6 +55,7 @@ static int max_decnet_no_fc_max_cwnd[] =3D { NSP_MAX_WIND=
OW };
 static char node_name[7] =3D "???";
=20
 static struct ctl_table_header *dn_table_header =3D NULL;
+static struct ctl_table_header *dn_skeleton_table_header =3D NULL;
=20
 /*
  * ctype.h :-)
@@ -357,6 +358,27 @@ static struct ctl_path dn_path[] =3D {
 	{ }
 };
=20
+static struct ctl_table empty[1];
+
+static struct ctl_table dn_skeleton[] =3D {
+	{
+		.procname =3D "conf",
+		.mode =3D 0555,
+		.child =3D empty,
+	},
+	{ }
+};
+
+void dn_register_sysctl_skeleton(void)
+{
+	dn_skeleton_table_header =3D register_sysctl_paths(dn_path, dn_skeleton);
+}
+
+void dn_unregister_sysctl_skeleton(void)
+{
+	unregister_sysctl_table(dn_skeleton_table_header);
+}
+
 void dn_register_sysctl(void)
 {
 	dn_table_header =3D register_sysctl_paths(dn_path, dn_table);
@@ -368,6 +390,12 @@ void dn_unregister_sysctl(void)
 }
=20
 #else  /* CONFIG_SYSCTL */
+void dn_register_sysctl_skeleton(void)
+{
+}
+void dn_unregister_sysctl_skeleton(void)
+{
+}
 void dn_unregister_sysctl(void)
 {
 }
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 6c91208..3c5d329 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -481,13 +481,17 @@ EXPORT_SYMBOL_GPL(xprt_wake_pending_tasks);
  * xprt_wait_for_buffer_space - wait for transport output buffer to clear
  * @task: task to be put to sleep
  * @action: function pointer to be executed after wait
+ *
+ * Note that we only set the timer for the case of RPC_IS_SOFT(), since
+ * we don't in general want to force a socket disconnection due to
+ * an incomplete RPC call transmission.
  */
 void xprt_wait_for_buffer_space(struct rpc_task *task, rpc_action action)
 {
 	struct rpc_rqst *req =3D task->tk_rqstp;
 	struct rpc_xprt *xprt =3D req->rq_xprt;
=20
-	task->tk_timeout =3D req->rq_timeout;
+	task->tk_timeout =3D RPC_IS_SOFT(task) ? req->rq_timeout : 0;
 	rpc_sleep_on(&xprt->pending, task, action);
 }
 EXPORT_SYMBOL_GPL(xprt_wait_for_buffer_space);
diff --git a/security/keys/compat.c b/security/keys/compat.c
index 4c48e13..1b0b7bf 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -40,12 +40,12 @@ long compat_keyctl_instantiate_key_iov(
 					   ARRAY_SIZE(iovstack),
 					   iovstack, &iov, 1);
 	if (ret < 0)
-		return ret;
+		goto err;
 	if (ret =3D=3D 0)
 		goto no_payload_free;
=20
 	ret =3D keyctl_instantiate_key_common(id, iov, ioc, ret, ringid);
-
+err:
 	if (iov !=3D iovstack)
 		kfree(iov);
 	return ret;
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 1068cb1..60d0df7 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -54,7 +54,7 @@ int install_user_keyrings(void)
=20
 	kenter("%p{%u}", user, user->uid);
=20
-	if (user->uid_keyring) {
+	if (user->uid_keyring && user->session_keyring) {
 		kleave(" =3D 0 [exist]");
 		return 0;
 	}
diff --git a/sound/core/seq/seq_timer.c b/sound/core/seq/seq_timer.c
index 160b1bd..24d44b2 100644
--- a/sound/core/seq/seq_timer.c
+++ b/sound/core/seq/seq_timer.c
@@ -290,10 +290,10 @@ int snd_seq_timer_open(struct snd_seq_queue *q)
 			tid.device =3D SNDRV_TIMER_GLOBAL_SYSTEM;
 			err =3D snd_timer_open(&t, str, &tid, q->queue);
 		}
-		if (err < 0) {
-			snd_printk(KERN_ERR "seq fatal error: cannot create timer (%i)\n", err)=
;
-			return err;
-		}
+	}
+	if (err < 0) {
+		snd_printk(KERN_ERR "seq fatal error: cannot create timer (%i)\n", err);
+		return err;
 	}
 	t->callback =3D snd_seq_timer_interrupt;
 	t->callback_data =3D q;
diff --git a/sound/core/vmaster.c b/sound/core/vmaster.c
index 130cfe6..ac0af03 100644
--- a/sound/core/vmaster.c
+++ b/sound/core/vmaster.c
@@ -209,7 +209,10 @@ static int slave_put(struct snd_kcontrol *kcontrol,
 	}
 	if (!changed)
 		return 0;
-	return slave_put_val(slave, ucontrol);
+	err =3D slave_put_val(slave, ucontrol);
+	if (err < 0)
+		return err;
+	return 1;
 }
=20
 static int slave_tlv_cmd(struct snd_kcontrol *kcontrol,



--=-KNIAM2L7ogjOP1DcqMQi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUoVDee/yOyVhhEJAQpBDhAAkU8aADcVmwMc0hZ8r9UZT8h7cePI6yp7
Hh0qiXYKoVBZMoKPY7JsUHW8DnX6w6o/ptBxDK/O0dCX8xjQQsQYpzCFtUTa7bRE
FnvRWvyFA9db8ouS5SJJLnxd7RrIRRmO1/pOfqS9ieNNHZGy/9X64CoCtSy+9ke5
o6Lh8QdqGojYRRkCE8t9F6dk4qbSrySy7+Qv7mmBhYJ6eWYM8QDoAinZQEECHHny
bgjRpupRM0Qmg4OVFQ/stiW61doHBSBHOen6GaeoKrH9NisVEpVBGuUFiW7kdBRs
lh6o1K4WenWdAdmlkA4G0xojJoc+z6YKgj4jTev0mpACkfjfmyi2RB4Pts/I4v+q
/pn633v2a+8wLHxfnyjIHPwMOVDqvN3tohU2CvJxIE5MOzwR+vmXvBKJDn9T0osB
eElbQrkqoV2eC7cQsBwdMLLrM5fLHcdrFTj+DL16t51XlLyGbSorh0r3UIE1VKDw
ZvaKmKTxZDhwYvBLbQeKRPF/v1k2GHVBYHN1Eey6nzBedwygMc0qMVbv3Duj64fb
o4kcewQUF33KIAsRigcuoNEvw11vAS7R7OEI5qIcmWzrjk+cZUaakGzmIQRkRBdN
VGnbtqqJkHvCJwm6fS3Q4+FSE6vwXqh09qHkMoCc5V2HSVZkKHJLIVuafPwUHRyk
QweCc2o9XS0=
=O1ag
-----END PGP SIGNATURE-----

--=-KNIAM2L7ogjOP1DcqMQi--
