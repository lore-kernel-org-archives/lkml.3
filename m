Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808AbaGRS1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:27:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34599 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422692AbaGRS1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:27:09 -0400
Date: Fri, 18 Jul 2014 14:26:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Elena Ufimtseva <ufimtseva@gmail.com>
Cc: xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, akpm@linux-foundation.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/1] xen: vnuma for pv guests
Message-ID: <20140718182633.GA15947@laptop.dumpdata.com>
References: <1405663045-31620-1-git-send-email-ufimtseva@gmail.com>
 <1405663045-31620-2-git-send-email-ufimtseva@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405663045-31620-2-git-send-email-ufimtseva@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 01:57:25AM -0400, Elena Ufimtseva wrote:
> Issues Xen hypercall subop XENMEM_get_vnumainfo and sets the
> NUMA topology, otherwise sets dummy NUMA node and prevents
> numa_init from calling other numa initializators as they dont
> work with pv guests.
> 
> Signed-off-by: Elena Ufimtseva <ufimtseva@gmail.com>
> ---
>  arch/x86/include/asm/xen/vnuma.h |   10 ++++
>  arch/x86/mm/numa.c               |    3 +
>  arch/x86/xen/Makefile            |    1 +
>  arch/x86/xen/setup.c             |    6 +-
>  arch/x86/xen/vnuma.c             |  120 ++++++++++++++++++++++++++++++++++++++
>  include/xen/interface/memory.h   |   50 ++++++++++++++++
>  6 files changed, 189 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/include/asm/xen/vnuma.h
>  create mode 100644 arch/x86/xen/vnuma.c
> 
> diff --git a/arch/x86/include/asm/xen/vnuma.h b/arch/x86/include/asm/xen/vnuma.h
> new file mode 100644
> index 0000000..8c8b098
> --- /dev/null
> +++ b/arch/x86/include/asm/xen/vnuma.h
> @@ -0,0 +1,10 @@
> +#ifndef _ASM_X86_VNUMA_H
> +#define _ASM_X86_VNUMA_H
> +
> +#ifdef CONFIG_XEN
> +int xen_numa_init(void);
> +#else
> +static inline int xen_numa_init(void) { return -1; };
> +#endif
> +
> +#endif /* _ASM_X86_VNUMA_H */
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index a32b706..045a8b3 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -18,6 +18,7 @@
>  #include <asm/acpi.h>
>  #include <asm/amd_nb.h>
>  
> +#include "asm/xen/vnuma.h"
>  #include "numa_internal.h"
>  
>  int __initdata numa_off;
> @@ -687,6 +688,8 @@ static int __init dummy_numa_init(void)
>  void __init x86_numa_init(void)
>  {
>  	if (!numa_off) {
> +		if (!numa_init(xen_numa_init))
> +			return;
>  #ifdef CONFIG_ACPI_NUMA
>  		if (!numa_init(x86_acpi_numa_init))
>  			return;
> diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
> index 96ab2c0..185ec9b 100644
> --- a/arch/x86/xen/Makefile
> +++ b/arch/x86/xen/Makefile
> @@ -22,3 +22,4 @@ obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
>  obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
>  obj-$(CONFIG_XEN_DOM0)		+= apic.o vga.o
>  obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
> +obj-$(CONFIG_NUMA)		+= vnuma.o
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 2e555163..9dc0d3b 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -20,6 +20,7 @@
>  #include <asm/numa.h>
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
> +#include <asm/xen/vnuma.h>
>  
>  #include <xen/xen.h>
>  #include <xen/page.h>
> @@ -642,6 +643,9 @@ void __init xen_arch_setup(void)
>  	WARN_ON(xen_set_default_idle());
>  	fiddle_vdso();
>  #ifdef CONFIG_NUMA
> -	numa_off = 1;
> +	if (xen_initial_domain())
> +		numa_off = 1;
> +	else
> +		numa_off = 0;
>  #endif
>  }
> diff --git a/arch/x86/xen/vnuma.c b/arch/x86/xen/vnuma.c
> new file mode 100644
> index 0000000..73f052f
> --- /dev/null
> +++ b/arch/x86/xen/vnuma.c
> @@ -0,0 +1,120 @@
> +#include <linux/err.h>
> +#include <linux/memblock.h>
> +#include <xen/interface/xen.h>
> +#include <xen/interface/memory.h>
> +#include <asm/xen/interface.h>
> +#include <asm/xen/hypercall.h>
> +#include <asm/xen/vnuma.h>
> +
> +/*
> + * Called from numa_init if numa_off = 0.
> + */
> +int __init xen_numa_init(void)
> +{
> +	unsigned int i, j, idx;
> +	unsigned int cpu, pcpus, nr_nodes, nr_cpus;
> +	unsigned int *vdistance, *cpu_to_node;
> +	unsigned long mem_size, dist_size, cpu_to_node_size;
> +	struct vmemrange *vmem;
> +	u64 physm, physd, physc;
> +	int rc;
> +
> +	struct vnuma_topology_info numa_topo = {
> +		.domid = DOMID_SELF
> +	};
> +
> +	rc = -EINVAL;
> +	physm = physd = physc = 0;
> +
> +	if (!xen_pv_domain())
> +		return rc;
> +
> +	/* get the number of nodes for allocation of memblocks. */
> +	pcpus = num_possible_cpus();
> +	nr_cpus = setup_max_cpus < pcpus ? setup_max_cpus : pcpus;

Why do you need to check setup_max_cpus? (Which is CONFIG_NR_CPUS)

Can't you just use num_possible_cpus() - which is appropiate
bitmap macro to figure out the maximum amount of CPUs the kernel
will ever support once it has enumerated the ACPI tables.

Like so:
	nr_cpus = num_possible_cpus();

and get rid of pcpus.
> +
> +	/* support for nodes with at least one cpu per node. */
> +	nr_nodes = nr_cpus;
> +
> +	/*
> +	 * Allocate arrays for nr_cpus/nr_nodes sizes and let
> +	 * hypervisor know that these are the boundaries. Partial
> +	 * copy is not allowed and hypercall will fail.
> +	 */
> +
> +	mem_size =  nr_nodes * sizeof(struct vmemrange);
> +	dist_size = nr_nodes * nr_nodes * sizeof(*numa_topo.distance.h);
> +	cpu_to_node_size = nr_cpus * sizeof(*numa_topo.cpu_to_node.h);
> +
> +	physm = memblock_alloc(mem_size, PAGE_SIZE);
> +	physd = memblock_alloc(dist_size, PAGE_SIZE);
> +	physc = memblock_alloc(cpu_to_node_size, PAGE_SIZE);
> +
> +	if (!physm || !physd || !physc)
> +		goto out;
> +
> +	vmem = __va(physm);
> +	vdistance  = __va(physd);
> +	cpu_to_node  = __va(physc);
> +
> +	numa_topo.nr_nodes = nr_nodes;
> +	numa_topo.nr_cpus = nr_cpus;
> +
> +	set_xen_guest_handle(numa_topo.memrange.h, vmem);
> +	set_xen_guest_handle(numa_topo.distance.h, vdistance);
> +	set_xen_guest_handle(numa_topo.cpu_to_node.h, cpu_to_node);
> +
> +	if (HYPERVISOR_memory_op(XENMEM_get_vnuma_info, &numa_topo) < 0)
> +		goto out;
> +
> +	/*
> +	 * NUMA nodes memory ranges are in pfns, constructed and
> +	 * aligned based on e820 ram domain map.
> +	 */

Shouldn't you use the hypervisor value of 'nr_nodes' as it might
have an updated version?

Or would the 'vmem' be empty when the guest's nr_nodes != how
much the nr_nodes is reflected by the hypervisor?

> +	for (i = 0; i < nr_nodes; i++) {
> +		if (numa_add_memblk(i, vmem[i].start, vmem[i].end))
> +			goto out;
> +		node_set(i, numa_nodes_parsed);
> +	}
> +
> +	setup_nr_node_ids();
> +	/* Setting the cpu, apicid to node. */
> +	for_each_cpu(cpu, cpu_possible_mask) {

Could you add a comment saying that the 'cpu_to_node' is locally
created and not the generic one.

Or better yet, change 'cpu_to_node' to 'cpu_to_vnode'.

> +		set_apicid_to_node(cpu, cpu_to_node[cpu]);
> +		numa_set_node(cpu, cpu_to_node[cpu]);
> +		cpumask_set_cpu(cpu, node_to_cpumask_map[cpu_to_node[cpu]]);
> +	}
> +
> +	for (i = 0; i < nr_nodes; i++) {
> +		for (j = 0; j < nr_nodes; j++) {
> +			idx = (i * nr_nodes) + j;
> +			numa_set_distance(i, j, *(vdistance + idx));
> +		}
> +	}
> +
> +	rc = 0;
> +out:
> +	if (physm)
> +		memblock_free(__pa(physm), mem_size);
> +	if (physd)
> +		memblock_free(__pa(physd), dist_size);
> +	if (physc)
> +		memblock_free(__pa(physc), cpu_to_node_size);
> +	/*
> +	 * Set a dummy node and return success.  This prevents calling any
> +	 * hardware-specific initializers which do not work in a PV guest.
> +	 * Taken from dummy_numa_init code.
> +	 */
> +	if (rc) {
> +		for (i = 0; i < MAX_LOCAL_APIC; i++)
> +			set_apicid_to_node(i, NUMA_NO_NODE);
> +		nodes_clear(numa_nodes_parsed);
> +		nodes_clear(node_possible_map);
> +		nodes_clear(node_online_map);
> +		node_set(0, numa_nodes_parsed);
> +		/* cpus up to max_cpus will be assigned to one node. */
> +		numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
> +		setup_nr_node_ids();
> +	}
> +	return 0;
> +}
> diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> index 2ecfe4f..96d6387 100644
> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -263,4 +263,54 @@ struct xen_remove_from_physmap {
>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
>  
> +/* vNUMA structures */
> +struct vmemrange {
> +	uint64_t start, end;
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(vmemrange);
> +
> +struct vnuma_topology_info {
> +	/* OUT */
> +	domid_t domid;
> +	/*
> +	 * nr_nodes and nr_cpus are used for retreival of sizes

retrieval

> +	 * of will be allocated arrays for vnuma topology.

s/will be//
> +	 * We need to know vcpus numberfor domain as NR_CPUS

s/numberfor/number for/
> +	 * is less then domain max_vcpus, number of possible
> +	 * cpus will equal to NR_CPUS and we have no way of
> +	 * learning domain vcpus number.

Uh? NR_CPUS can > of max_vcpus or lower or exact.

Are you saying that the amount of CPUs that the guest
has been allocated and expected to run might be different
than what the kernel has been built to support?

And what you want is the theoritical maximum of what the
kernel can support (as it does not matter if the kernel
is built with 4 CPUs and is booted with 64 CPUs - it will
never be able to use the 60 other CPUs).

I think what you are saying is that you want to use
num_possible_cpus() here to advertise to the hypervisor that
the is the maximum number of CPUs it can support.
> +	 */
> +	/* number of virtual numa nodes */
> +	unsigned int nr_nodes;

Or those in or out type paremters? There should be an IN/OUT
if it goes both ways.

> +	unsigned int nr_cpus;
> +	/* distance table */
> +	union {
> +		GUEST_HANDLE(uint) h;
> +		uint64_t    _pad;
> +	} distance;
> +	/* cpu mapping to vnodes */
> +	union {
> +		GUEST_HANDLE(uint) h;
> +		uint64_t    _pad;
> +	} cpu_to_node;
> +	/*
> +	* memory areas constructed by Xen, start and end
> +	* of the ranges are specific to domain e820 map.
> +	* Xen toolstack constructs these ranges for domain
> +	* when building it.

OK, What is the size of this? Do you use nr_nodes that was
supplied or what the hypervisor has written in nr_nodes?

> +	*/
> +	union {
> +		GUEST_HANDLE(vmemrange) h;
> +		uint64_t    _pad;
> +	} memrange;
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(vnuma_topology_info);
> +
> +/*
> + * Used to retreive vnuma topology info.
> + * Use XENMEM_get_vnuma_nodes to obtain number of
> + * nodes before allocating memory for topology.
> + */
> +#define XENMEM_get_vnuma_info	26
> +
>  #endif /* __XEN_PUBLIC_MEMORY_H__ */
> -- 
> 1.7.10.4
> 
