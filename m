Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbaJ2Ise (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:48:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:40874 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbaJ2Isb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:48:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,808,1406617200"; 
   d="scan'208";a="598193618"
Message-ID: <5450A9D8.108@linux.intel.com>
Date: Wed, 29 Oct 2014 16:48:24 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: Re: [Patch Part2 v3 15/24] x86, MSI: Use hierarchy irqdomain to manage
 MSI interrupts
References: <1414484803-10311-1-git-send-email-jiang.liu@linux.intel.com> <1414484803-10311-16-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1410282046120.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410282046120.5308@nanos>
Content-Type: multipart/mixed;
 boundary="------------000402080403060607020904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000402080403060607020904
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 2014/10/29 5:37, Thomas Gleixner wrote:
> On Tue, 28 Oct 2014, Jiang Liu wrote:
>> +static int msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
>> +			    bool force)
>> +{
>> +	struct irq_data *parent = data->parent_data;
>> +	int ret;
>>  
>> -	msg.data &= ~MSI_DATA_VECTOR_MASK;
>> -	msg.data |= MSI_DATA_VECTOR(cfg->vector);
>> -	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
>> -	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
>> +	ret = parent->chip->irq_set_affinity(parent, mask, force);
>> +	/* No need to reprogram MSI registers if interrupt is remapped */
>> +	if (ret >= 0 && !msi_irq_remapped(data)) {
>> +		struct msi_msg msg;
>>  
>> -	__write_msi_msg(data->msi_desc, &msg);
>> +		__get_cached_msi_msg(data->msi_desc, &msg);
>> +		msi_update_msg(&msg, data);
>> +		__write_msi_msg(data->msi_desc, &msg);
>> +	}
> 
> I'm not too happy about the msi_irq_remapped() conditional here. It
> violates the whole concept of domain stacking somewhat.
> 
> A better separation would be to add a callback to the irq chip:
> 
>   	void (*irq_write_msi_msg)(struct irq_data *data, struct msi_desc *msi_desc, bool cached);
> 
> and change this code to:
> 
>     	if (ret >= 0)
> 	   	parent->chip->irq_write_msi_msg(parent, data->msi-desc, true);
>   
Hi Thomas,
	Thanks for your great suggestion and I have worked out a draft
patch to achieve what you want:)
	I have made following changes to irq core to get rid of remapped
irq logic from msi.c:
1) Add IRQ_SET_MASK_OK_DONE in addition to IRQ_SET_MASK_OK and
IRQ_SET_MASK_OK_NOCOPY. IRQ_SET_MASK_OK_DONE is the same as
IRQ_SET_MASK_OK for irq core and indicates to stacked irqchip that
parent irqchips have done all work and skip any handling in descendant
irqchips.
2) Add int (*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg
*msg) into struct irq_chip. I'm still hesitating to return void or int
here. By returning void, irq_chip_compose_msi_msg() will be simpler,
but it loses flexibility.

With above changes to core, we could remove all knowledge of irq
remapping from msi.c and the irq remapping interfaces get simpler too.
Please refer to following patch for details. The patch passes basic
booting tests with irq remapping enabled. If it's OK, I will fold
it into the patch set.

IOAPIC runs into the same situation, but I need some more time
to find a solution:)

Regards!
Gerry


--------------000402080403060607020904
Content-Type: text/plain; charset=gb18030;
 name="tmp2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tmp2.patch"

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 68d6dfcf7d92..97dec9eadef3 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -63,8 +63,6 @@ extern struct irq_domain *irq_remapping_get_irq_domain(
 				struct irq_alloc_info *info);
 extern int irq_remapping_get_ioapic_entry(struct irq_data *irq_data,
 					  struct IR_IO_APIC_route_entry *entry);
-extern int irq_remapping_get_msi_entry(struct irq_data *irq_data,
-				       struct msi_msg *entry);
 extern void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p);
 
 /*
@@ -142,12 +140,6 @@ static inline int irq_remapping_get_ioapic_entry(struct irq_data *irq_data,
 	return -ENOSYS;
 }
 
-static inline int irq_remapping_get_msi_entry(struct irq_data *irq_data,
-					      struct msi_msg *entry)
-{
-	return -ENOSYS;
-}
-
 static inline void irq_remapping_domain_set_remapped(struct irq_domain *domain)
 {
 }
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index bd4275038436..0519ab3e43fb 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -35,8 +35,10 @@ static void msi_reset_irq_data_and_handler(struct irq_domain *domain, int virq)
 	irq_set_handler(virq, NULL);
 }
 
-static void native_compose_msi_msg(struct irq_cfg *cfg, struct msi_msg *msg)
+static int msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
 {
+	struct irq_cfg *cfg = irqd_cfg(data);
+
 	msg->address_hi = MSI_ADDR_BASE_HI;
 
 	if (x2apic_enabled())
@@ -59,6 +61,8 @@ static void native_compose_msi_msg(struct irq_cfg *cfg, struct msi_msg *msg)
 			MSI_DATA_DELIVERY_FIXED :
 			MSI_DATA_DELIVERY_LOWPRI) |
 		MSI_DATA_VECTOR(cfg->vector);
+
+	return 0;
 }
 
 static void msi_update_msg(struct msi_msg *msg, struct irq_data *irq_data)
@@ -74,11 +78,6 @@ static void msi_update_msg(struct msi_msg *msg, struct irq_data *irq_data)
 				  MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid);
 }
 
-static bool msi_irq_remapped(struct irq_data *irq_data)
-{
-	return irq_remapping_domain_is_remapped(irq_data->domain);
-}
-
 static int msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			    bool force)
 {
@@ -86,8 +85,7 @@ static int msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	int ret;
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
-	/* No need to reprogram MSI registers if interrupt is remapped */
-	if (ret >= 0 && !msi_irq_remapped(data)) {
+	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
 		struct msi_msg msg;
 
 		__get_cached_msi_msg(data->msi_desc, &msg);
@@ -110,6 +108,7 @@ static struct irq_chip msi_chip = {
 	.irq_set_affinity	= msi_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_print_chip		= irq_remapping_print_chip,
+	.irq_compose_msi_msg	= msi_compose_msg,
  	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -164,8 +163,8 @@ static void msi_domain_free(struct irq_domain *domain, unsigned int virq,
 static int msi_domain_activate(struct irq_domain *domain,
 			       struct irq_data *irq_data)
 {
+	int ret;
 	struct msi_msg msg;
-	struct irq_cfg *cfg = irqd_cfg(irq_data);
 
 	/*
 	 * irq_data->chip_data is MSI/MSIx offset.
@@ -175,13 +174,11 @@ static int msi_domain_activate(struct irq_domain *domain,
 	if (irq_data->chip_data)
 		return 0;
 
-	if (msi_irq_remapped(irq_data))
-		irq_remapping_get_msi_entry(irq_data->parent_data, &msg);
-	else
-		native_compose_msi_msg(cfg, &msg);
-	write_msi_msg(irq_data->irq, &msg);
+	ret = irq_chip_compose_msi_msg(irq_data, &msg);
+	if (ret == 0)
+		write_msi_msg(irq_data->irq, &msg);
 
-	return 0;
+	return ret;
 }
 
 static int msi_domain_deactivate(struct irq_domain *domain,
@@ -268,17 +265,13 @@ void native_teardown_msi_irq(unsigned int irq)
 	irq_domain_free_irqs(irq, 1);
 }
 
-static struct irq_domain *msi_create_domain(struct irq_domain *parent,
-					    bool remapped)
+static struct irq_domain *msi_create_domain(struct irq_domain *parent)
 {
 	struct irq_domain *domain;
 
 	domain = irq_domain_add_tree(NULL, &msi_domain_ops, NULL);
-	if (domain) {
+	if (domain)
 		domain->parent = parent;
-		if (remapped)
-			irq_remapping_domain_set_remapped(domain);
-	}
 
 	return domain;
 }
@@ -288,7 +281,7 @@ void arch_init_msi_domain(struct irq_domain *parent)
 	if (disable_apic)
 		return;
 
-	msi_default_domain = msi_create_domain(parent, false);
+	msi_default_domain = msi_create_domain(parent);
 	if (!msi_default_domain)
 		pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
 }
@@ -296,7 +289,7 @@ void arch_init_msi_domain(struct irq_domain *parent)
 #ifdef CONFIG_IRQ_REMAP
 struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent)
 {
-	return msi_create_domain(parent, true);
+	return msi_create_domain(parent);
 }
 #endif
 
@@ -326,6 +319,7 @@ static struct irq_chip dmar_msi_type = {
 	.irq_ack		= irq_chip_ack_parent,
 	.irq_set_affinity	= dmar_msi_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_compose_msi_msg	= msi_compose_msg,
  	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -364,12 +358,14 @@ static void dmar_domain_free(struct irq_domain *domain, unsigned int virq,
 static int dmar_domain_activate(struct irq_domain *domain,
 				struct irq_data *irq_data)
 {
+	int ret;
 	struct msi_msg msg;
 
-	native_compose_msi_msg(irqd_cfg(irq_data), &msg);
-	dmar_msi_write(irq_data->irq, &msg);
+	ret = irq_chip_compose_msi_msg(irq_data, &msg);
+	if (ret == 0)
+		dmar_msi_write(irq_data->irq, &msg);
 
-	return 0;
+	return ret;
 }
 
 static int dmar_domain_deactivate(struct irq_domain *domain,
@@ -445,8 +441,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 	int ret;
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
-	/* No need to rewrite HPET registers if interrupt is remapped */
-	if (ret >= 0 && !msi_irq_remapped(data)) {
+	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
 		hpet_msi_read(data->handler_data, &msg);
 		msi_update_msg(&msg, data);
 		hpet_msi_write(data->handler_data, &msg);
@@ -463,6 +458,7 @@ static struct irq_chip hpet_msi_type = {
 	.irq_set_affinity = hpet_msi_set_affinity,
 	.irq_retrigger = irq_chip_retrigger_hierarchy,
 	.irq_print_chip = irq_remapping_print_chip,
+	.irq_compose_msi_msg = msi_compose_msg,
  	.flags = IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -503,16 +499,14 @@ static void hpet_domain_free(struct irq_domain *domain, unsigned int virq,
 static int hpet_domain_activate(struct irq_domain *domain,
 				struct irq_data *irq_data)
 {
+	int ret;
 	struct msi_msg msg;
-	struct irq_cfg *cfg = irqd_cfg(irq_data);
 
-	if (msi_irq_remapped(irq_data))
-		irq_remapping_get_msi_entry(irq_data->parent_data, &msg);
-	else
-		native_compose_msi_msg(cfg, &msg);
-	hpet_msi_write(irq_get_handler_data(irq_data->irq), &msg);
+	ret = irq_chip_compose_msi_msg(irq_data, &msg);
+	if (ret == 0)
+		hpet_msi_write(irq_get_handler_data(irq_data->irq), &msg);
 
-	return 0;
+	return ret;
 }
 
 static int hpet_domain_deactivate(struct irq_domain *domain,
@@ -535,27 +529,22 @@ static struct irq_domain_ops hpet_domain_ops = {
 
 struct irq_domain *hpet_create_irq_domain(int hpet_id)
 {
-	struct irq_domain *parent, *domain;
+	struct irq_domain *domain;
 	struct irq_alloc_info info;
-	bool remapped = false;
+
+	if (x86_vector_domain == NULL)
+		return NULL;
 
 	init_irq_alloc_info(&info, NULL);
 	info.type = X86_IRQ_ALLOC_TYPE_HPET;
 	info.hpet_id = hpet_id;
-	parent = irq_remapping_get_ir_irq_domain(&info);
-	if (parent)
-		remapped = true;
-	else
-		parent = x86_vector_domain;
-	if (!parent)
-		return NULL;
 
 	domain = irq_domain_add_tree(NULL, &hpet_domain_ops,
 				     (void *)(long)hpet_id);
 	if (domain) {
-		domain->parent = parent;
-		if (remapped)
-			irq_remapping_domain_set_remapped(domain);
+		domain->parent = irq_remapping_get_ir_irq_domain(&info);
+		if (!domain->parent)
+			domain->parent = x86_vector_domain;
 	}
 
 	return domain;
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 0b648772c221..8fcd1497b109 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4260,15 +4260,6 @@ static int get_ioapic_entry(struct irq_data *irq_data,
 	return 0;
 }
 
-static int get_msi_entry(struct irq_data *irq_data, struct msi_msg *msg)
-{
-	struct amd_ir_data *ir_data = irq_data->chip_data;
-
-	*msg = ir_data->msi_entry;
-
-	return 0;
-}
-
 struct irq_remap_ops amd_iommu_irq_ops = {
 	.supported		= amd_iommu_supported,
 	.prepare		= amd_iommu_prepare,
@@ -4282,7 +4273,6 @@ struct irq_remap_ops amd_iommu_irq_ops = {
 	.get_ir_irq_domain	= get_ir_irq_domain,
 	.get_irq_domain		= get_irq_domain,
 	.get_ioapic_entry	= get_ioapic_entry,
-	.get_msi_entry		= get_msi_entry,
 };
 
 static void irq_remapping_prepare_irte(struct amd_ir_data *data,
@@ -4475,7 +4465,7 @@ static int amd_ir_set_affinity(struct irq_data *data,
 	int ret;
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
-	if (ret < 0)
+	if (ret < 0 || ret == IRQ_SET_MASK_OK_DONE)
 		return ret;
 
 	/*
@@ -4494,12 +4484,22 @@ static int amd_ir_set_affinity(struct irq_data *data,
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
-	return ret;
+	return IRQ_SET_MASK_OK_DONE;
+}
+
+static int compose_msi_msg(struct irq_data *irq_data, struct msi_msg *msg)
+{
+	struct amd_ir_data *ir_data = irq_data->chip_data;
+
+	*msg = ir_data->msi_entry;
+
+	return 0;
 }
 
 static struct irq_chip amd_ir_chip = {
 	.irq_ack = ir_ack_apic_edge,
 	.irq_set_affinity = amd_ir_set_affinity,
+	.irq_compose_msi_msg = compose_msi_msg,
 };
 
 int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 9742011190fb..e2ea4eccf9c9 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -1029,6 +1029,7 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		send_cleanup_vector(cfg);
 
 	cpumask_copy(data->affinity, mask);
+
 	return 0;
 }
 
@@ -1089,15 +1090,6 @@ static int intel_get_ioapic_entry(struct irq_data *irq_data,
 	return 0;
 }
 
-static int intel_get_msi_entry(struct irq_data *irq_data, struct msi_msg *msg)
-{
-	struct intel_ir_data *ir_data = irq_data->chip_data;
-
-	*msg = ir_data->msi_entry;
-
-	return 0;
-}
-
 struct irq_remap_ops intel_irq_remap_ops = {
 	.supported		= intel_irq_remapping_supported,
 	.prepare		= dmar_table_init,
@@ -1111,7 +1103,6 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.get_ir_irq_domain	= intel_get_ir_irq_domain,
 	.get_irq_domain		= intel_get_irq_domain,
 	.get_ioapic_entry	= intel_get_ioapic_entry,
-	.get_msi_entry		= intel_get_msi_entry,
 };
 
 /*
@@ -1139,7 +1130,7 @@ intel_ir_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	int ret;
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
-	if (ret < 0)
+	if (ret < 0 || ret == IRQ_SET_MASK_OK_DONE)
 		return ret;
 
 	/*
@@ -1158,12 +1149,22 @@ intel_ir_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
-	return ret;
+	return IRQ_SET_MASK_OK_DONE;
+}
+
+static int intel_compose_msi_msg(struct irq_data *irq_data, struct msi_msg *msg)
+{
+	struct intel_ir_data *ir_data = irq_data->chip_data;
+
+	*msg = ir_data->msi_entry;
+
+	return 0;
 }
 
 static struct irq_chip intel_ir_chip = {
 	.irq_ack = ir_ack_apic_edge,
 	.irq_set_affinity = intel_ir_set_affinity,
+	.irq_compose_msi_msg = intel_compose_msi_msg,
 };
 
 static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 8fabc1d05f93..aa0cacc1486a 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -310,18 +310,3 @@ int irq_remapping_get_ioapic_entry(struct irq_data *irq_data,
 {
 	return remap_ops->get_ioapic_entry(irq_data, entry);
 }
-
-/**
- * irq_remapping_get_ioapic_entry - Get MSI data rewritten by interrupt
- *				    remapping driver
- * @irq_data: irq_data associated with interrupt remapping irqdomain
- * @entry: host returned data
- *
- * Caller must make sure that the interrupt is remapped.
- * Return 0 on success, otherwise return error code
- */
-int irq_remapping_get_msi_entry(struct irq_data *irq_data,
-				struct msi_msg *entry)
-{
-	return remap_ops->get_msi_entry(irq_data, entry);
-}
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index b01a51ed1780..df73f010c326 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -79,9 +79,6 @@ struct irq_remap_ops {
 	/* Get IOAPIC entry content rewritten by interrupt remapping driver */
 	int (*get_ioapic_entry)(struct irq_data *,
 				struct IR_IO_APIC_route_entry *);
-
-	/*  Get MSI data rewritten by interrupt remapping driver */
-	int (*get_msi_entry)(struct irq_data *, struct msi_msg *);
 };
 
 extern struct irq_remap_ops intel_irq_remap_ops;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 0adcbbbf2e87..226449317b78 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -113,10 +113,14 @@ enum {
  *
  * IRQ_SET_MASK_OK	- OK, core updates irq_data.affinity
  * IRQ_SET_MASK_NOCPY	- OK, chip did update irq_data.affinity
+ * IRQ_SET_MASK_OK_DONE	- Same as IRQ_SET_MASK_OK for core. Special code to
+ *			  support stacked irqchips, which indicates skipping
+ *			  all descendent irqchips.
  */
 enum {
 	IRQ_SET_MASK_OK = 0,
 	IRQ_SET_MASK_OK_NOCOPY,
+	IRQ_SET_MASK_OK_DONE,
 };
 
 struct msi_desc;
@@ -356,6 +360,8 @@ struct irq_chip {
 	int		(*irq_request_resources)(struct irq_data *data);
 	void		(*irq_release_resources)(struct irq_data *data);
 
+	int		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
+
 	unsigned long	flags;
 };
 
@@ -443,6 +449,7 @@ extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_nested_irq(unsigned int irq);
 
+extern int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg);
 #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
 extern void irq_chip_ack_parent(struct irq_data *data);
 extern int irq_chip_retrigger_hierarchy(struct irq_data *data);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 12f3e72449eb..50cbbff7e27f 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -867,3 +867,15 @@ int irq_chip_retrigger_hierarchy(struct irq_data *data)
 	return -ENOSYS;
 }
 #endif
+
+int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	int ret = -ENOSYS;
+
+	if (data->parent_data)
+		ret = irq_chip_compose_msi_msg(data->parent_data, msg);
+	if (ret == -ENOSYS && data->chip && data->chip->irq_compose_msi_msg)
+		ret = data->chip->irq_compose_msi_msg(data, msg);
+
+	return ret;
+}
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a9104b4608b..80692373abd6 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -183,6 +183,7 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	ret = chip->irq_set_affinity(data, mask, force);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
+	case IRQ_SET_MASK_OK_DONE:
 		cpumask_copy(data->affinity, mask);
 	case IRQ_SET_MASK_OK_NOCOPY:
 		irq_set_thread_affinity(desc);
@@ -600,6 +601,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
+	case IRQ_SET_MASK_OK_DONE:
 		irqd_clear(&desc->irq_data, IRQD_TRIGGER_MASK);
 		irqd_set(&desc->irq_data, flags);
 

--------------000402080403060607020904--
