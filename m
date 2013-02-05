Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3BEEta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 23:49:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54175 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab3BEEt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 23:49:28 -0500
X-IronPort-AV: E=Sophos;i="4.84,603,1355068800"; 
   d="scan'208";a="6689748"
Subject: Re: [PATCH v2 1/4] acpi: move x86/mm/srat.c to
 x86/kernel/acpi/srat.c
From: li guang <lig.fnst@cn.fujitsu.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org,
        rientjes@google.com
In-Reply-To: <51108E25.6070300@jp.fujitsu.com>
References: <1360031838-26898-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1360031838-26898-2-git-send-email-lig.fnst@cn.fujitsu.com>
	 <51108E25.6070300@jp.fujitsu.com>
Date: Tue, 05 Feb 2013 12:49:10 +0800
Message-ID: <1360039750.4449.10.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 12:48:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 12:48:08,
	Serialize complete at 2013/02/05 12:48:08
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-02-05二的 13:44 +0900，Yasuaki Ishimatsu写道：
> Hi Liguang,
> 
> 2013/02/05 11:37, liguang wrote:
> > srat table should present only on acpi domain,
> > seems mm/ is not the right place for it.
> > 
> > Reviewed-by: David Rientjes <rientjes@google.com>
> > Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> > ---
> >
> >   arch/x86/kernel/acpi/srat.c |  197 +++++++++++++++++++++++++++++++++++++++++++
> >   arch/x86/mm/srat.c          |  197 -------------------------------------------
> >   2 files changed, 197 insertions(+), 197 deletions(-)
> >   create mode 100644 arch/x86/kernel/acpi/srat.c
> >   delete mode 100644 arch/x86/mm/srat.c
> 
> Changes of Makefile disappeared.
> 
> Thanks,
> Yasuaki Ishimatsu

Oh, fogot it, 
Thank you so much for reminding me!

> 
> > 
> > diff --git a/arch/x86/kernel/acpi/srat.c b/arch/x86/kernel/acpi/srat.c
> > new file mode 100644
> > index 0000000..4ddf497
> > --- /dev/null
> > +++ b/arch/x86/kernel/acpi/srat.c
> > @@ -0,0 +1,197 @@
> > +/*
> > + * ACPI 3.0 based NUMA setup
> > + * Copyright 2004 Andi Kleen, SuSE Labs.
> > + *
> > + * Reads the ACPI SRAT table to figure out what memory belongs to which CPUs.
> > + *
> > + * Called from acpi_numa_init while reading the SRAT and SLIT tables.
> > + * Assumes all memory regions belonging to a single proximity domain
> > + * are in one chunk. Holes between them will be included in the node.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/acpi.h>
> > +#include <linux/mmzone.h>
> > +#include <linux/bitmap.h>
> > +#include <linux/module.h>
> > +#include <linux/topology.h>
> > +#include <linux/bootmem.h>
> > +#include <linux/memblock.h>
> > +#include <linux/mm.h>
> > +#include <asm/proto.h>
> > +#include <asm/numa.h>
> > +#include <asm/e820.h>
> > +#include <asm/apic.h>
> > +#include <asm/uv/uv.h>
> > +
> > +int acpi_numa __initdata;
> > +
> > +static __init int setup_node(int pxm)
> > +{
> > +	return acpi_map_pxm_to_node(pxm);
> > +}
> > +
> > +static __init void bad_srat(void)
> > +{
> > +	printk(KERN_ERR "SRAT: SRAT not used.\n");
> > +	acpi_numa = -1;
> > +}
> > +
> > +static __init inline int srat_disabled(void)
> > +{
> > +	return acpi_numa < 0;
> > +}
> > +
> > +/* Callback for SLIT parsing */
> > +void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
> > +{
> > +	int i, j;
> > +
> > +	for (i = 0; i < slit->locality_count; i++)
> > +		for (j = 0; j < slit->locality_count; j++)
> > +			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
> > +				slit->entry[slit->locality_count * i + j]);
> > +}
> > +
> > +/* Callback for Proximity Domain -> x2APIC mapping */
> > +void __init
> > +acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
> > +{
> > +	int pxm, node;
> > +	int apic_id;
> > +
> > +	if (srat_disabled())
> > +		return;
> > +	if (pa->header.length < sizeof(struct acpi_srat_x2apic_cpu_affinity)) {
> > +		bad_srat();
> > +		return;
> > +	}
> > +	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
> > +		return;
> > +	pxm = pa->proximity_domain;
> > +	apic_id = pa->apic_id;
> > +	if (!apic->apic_id_valid(apic_id)) {
> > +		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
> > +			 pxm, apic_id);
> > +		return;
> > +	}
> > +	node = setup_node(pxm);
> > +	if (node < 0) {
> > +		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
> > +		bad_srat();
> > +		return;
> > +	}
> > +
> > +	if (apic_id >= MAX_LOCAL_APIC) {
> > +		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
> > +		return;
> > +	}
> > +	set_apicid_to_node(apic_id, node);
> > +	node_set(node, numa_nodes_parsed);
> > +	acpi_numa = 1;
> > +	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
> > +	       pxm, apic_id, node);
> > +}
> > +
> > +/* Callback for Proximity Domain -> LAPIC mapping */
> > +void __init
> > +acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
> > +{
> > +	int pxm, node;
> > +	int apic_id;
> > +
> > +	if (srat_disabled())
> > +		return;
> > +	if (pa->header.length != sizeof(struct acpi_srat_cpu_affinity)) {
> > +		bad_srat();
> > +		return;
> > +	}
> > +	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
> > +		return;
> > +	pxm = pa->proximity_domain_lo;
> > +	if (acpi_srat_revision >= 2)
> > +		pxm |= *((unsigned int*)pa->proximity_domain_hi) << 8;
> > +	node = setup_node(pxm);
> > +	if (node < 0) {
> > +		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
> > +		bad_srat();
> > +		return;
> > +	}
> > +
> > +	if (get_uv_system_type() >= UV_X2APIC)
> > +		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
> > +	else
> > +		apic_id = pa->apic_id;
> > +
> > +	if (apic_id >= MAX_LOCAL_APIC) {
> > +		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
> > +		return;
> > +	}
> > +
> > +	set_apicid_to_node(apic_id, node);
> > +	node_set(node, numa_nodes_parsed);
> > +	acpi_numa = 1;
> > +	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
> > +	       pxm, apic_id, node);
> > +}
> > +
> > +#ifdef CONFIG_MEMORY_HOTPLUG
> > +static inline int save_add_info(void) {return 1;}
> > +#else
> > +static inline int save_add_info(void) {return 0;}
> > +#endif
> > +
> > +/* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
> > +int __init
> > +acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
> > +{
> > +	u64 start, end;
> > +	int node, pxm;
> > +
> > +	if (srat_disabled())
> > +		return -1;
> > +	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity)) {
> > +		bad_srat();
> > +		return -1;
> > +	}
> > +	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
> > +		return -1;
> > +
> > +	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
> > +		return -1;
> > +	start = ma->base_address;
> > +	end = start + ma->length;
> > +	pxm = ma->proximity_domain;
> > +	if (acpi_srat_revision <= 1)
> > +		pxm &= 0xff;
> > +	node = setup_node(pxm);
> > +	if (node < 0) {
> > +		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
> > +		bad_srat();
> > +		return -1;
> > +	}
> > +
> > +	if (numa_add_memblk(node, start, end) < 0) {
> > +		bad_srat();
> > +		return -1;
> > +	}
> > +
> > +	node_set(node, numa_nodes_parsed);
> > +
> > +	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
> > +	       node, pxm,
> > +	       (unsigned long long) start, (unsigned long long) end - 1);
> > +	return 0;
> > +}
> > +
> > +void __init acpi_numa_arch_fixup(void) {}
> > +
> > +int __init x86_acpi_numa_init(void)
> > +{
> > +	int ret;
> > +
> > +	ret = acpi_numa_init();
> > +	if (ret < 0)
> > +		return ret;
> > +	return srat_disabled() ? -EINVAL : 0;
> > +}
> > diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
> > deleted file mode 100644
> > index 4ddf497..0000000
> > --- a/arch/x86/mm/srat.c
> > +++ /dev/null
> > @@ -1,197 +0,0 @@
> > -/*
> > - * ACPI 3.0 based NUMA setup
> > - * Copyright 2004 Andi Kleen, SuSE Labs.
> > - *
> > - * Reads the ACPI SRAT table to figure out what memory belongs to which CPUs.
> > - *
> > - * Called from acpi_numa_init while reading the SRAT and SLIT tables.
> > - * Assumes all memory regions belonging to a single proximity domain
> > - * are in one chunk. Holes between them will be included in the node.
> > - */
> > -
> > -#include <linux/kernel.h>
> > -#include <linux/acpi.h>
> > -#include <linux/mmzone.h>
> > -#include <linux/bitmap.h>
> > -#include <linux/module.h>
> > -#include <linux/topology.h>
> > -#include <linux/bootmem.h>
> > -#include <linux/memblock.h>
> > -#include <linux/mm.h>
> > -#include <asm/proto.h>
> > -#include <asm/numa.h>
> > -#include <asm/e820.h>
> > -#include <asm/apic.h>
> > -#include <asm/uv/uv.h>
> > -
> > -int acpi_numa __initdata;
> > -
> > -static __init int setup_node(int pxm)
> > -{
> > -	return acpi_map_pxm_to_node(pxm);
> > -}
> > -
> > -static __init void bad_srat(void)
> > -{
> > -	printk(KERN_ERR "SRAT: SRAT not used.\n");
> > -	acpi_numa = -1;
> > -}
> > -
> > -static __init inline int srat_disabled(void)
> > -{
> > -	return acpi_numa < 0;
> > -}
> > -
> > -/* Callback for SLIT parsing */
> > -void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
> > -{
> > -	int i, j;
> > -
> > -	for (i = 0; i < slit->locality_count; i++)
> > -		for (j = 0; j < slit->locality_count; j++)
> > -			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
> > -				slit->entry[slit->locality_count * i + j]);
> > -}
> > -
> > -/* Callback for Proximity Domain -> x2APIC mapping */
> > -void __init
> > -acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
> > -{
> > -	int pxm, node;
> > -	int apic_id;
> > -
> > -	if (srat_disabled())
> > -		return;
> > -	if (pa->header.length < sizeof(struct acpi_srat_x2apic_cpu_affinity)) {
> > -		bad_srat();
> > -		return;
> > -	}
> > -	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
> > -		return;
> > -	pxm = pa->proximity_domain;
> > -	apic_id = pa->apic_id;
> > -	if (!apic->apic_id_valid(apic_id)) {
> > -		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
> > -			 pxm, apic_id);
> > -		return;
> > -	}
> > -	node = setup_node(pxm);
> > -	if (node < 0) {
> > -		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
> > -		bad_srat();
> > -		return;
> > -	}
> > -
> > -	if (apic_id >= MAX_LOCAL_APIC) {
> > -		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
> > -		return;
> > -	}
> > -	set_apicid_to_node(apic_id, node);
> > -	node_set(node, numa_nodes_parsed);
> > -	acpi_numa = 1;
> > -	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
> > -	       pxm, apic_id, node);
> > -}
> > -
> > -/* Callback for Proximity Domain -> LAPIC mapping */
> > -void __init
> > -acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
> > -{
> > -	int pxm, node;
> > -	int apic_id;
> > -
> > -	if (srat_disabled())
> > -		return;
> > -	if (pa->header.length != sizeof(struct acpi_srat_cpu_affinity)) {
> > -		bad_srat();
> > -		return;
> > -	}
> > -	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
> > -		return;
> > -	pxm = pa->proximity_domain_lo;
> > -	if (acpi_srat_revision >= 2)
> > -		pxm |= *((unsigned int*)pa->proximity_domain_hi) << 8;
> > -	node = setup_node(pxm);
> > -	if (node < 0) {
> > -		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
> > -		bad_srat();
> > -		return;
> > -	}
> > -
> > -	if (get_uv_system_type() >= UV_X2APIC)
> > -		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
> > -	else
> > -		apic_id = pa->apic_id;
> > -
> > -	if (apic_id >= MAX_LOCAL_APIC) {
> > -		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
> > -		return;
> > -	}
> > -
> > -	set_apicid_to_node(apic_id, node);
> > -	node_set(node, numa_nodes_parsed);
> > -	acpi_numa = 1;
> > -	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
> > -	       pxm, apic_id, node);
> > -}
> > -
> > -#ifdef CONFIG_MEMORY_HOTPLUG
> > -static inline int save_add_info(void) {return 1;}
> > -#else
> > -static inline int save_add_info(void) {return 0;}
> > -#endif
> > -
> > -/* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
> > -int __init
> > -acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
> > -{
> > -	u64 start, end;
> > -	int node, pxm;
> > -
> > -	if (srat_disabled())
> > -		return -1;
> > -	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity)) {
> > -		bad_srat();
> > -		return -1;
> > -	}
> > -	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
> > -		return -1;
> > -
> > -	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
> > -		return -1;
> > -	start = ma->base_address;
> > -	end = start + ma->length;
> > -	pxm = ma->proximity_domain;
> > -	if (acpi_srat_revision <= 1)
> > -		pxm &= 0xff;
> > -	node = setup_node(pxm);
> > -	if (node < 0) {
> > -		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
> > -		bad_srat();
> > -		return -1;
> > -	}
> > -
> > -	if (numa_add_memblk(node, start, end) < 0) {
> > -		bad_srat();
> > -		return -1;
> > -	}
> > -
> > -	node_set(node, numa_nodes_parsed);
> > -
> > -	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
> > -	       node, pxm,
> > -	       (unsigned long long) start, (unsigned long long) end - 1);
> > -	return 0;
> > -}
> > -
> > -void __init acpi_numa_arch_fixup(void) {}
> > -
> > -int __init x86_acpi_numa_init(void)
> > -{
> > -	int ret;
> > -
> > -	ret = acpi_numa_init();
> > -	if (ret < 0)
> > -		return ret;
> > -	return srat_disabled() ? -EINVAL : 0;
> > -}
> > 
> 
> 


