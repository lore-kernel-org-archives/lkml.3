Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab3GCP7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 11:59:41 -0400
Received: from smtp.citrix.com ([66.165.176.89]:42758 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab3GCP7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 11:59:39 -0400
X-IronPort-AV: E=Sophos;i="4.87,988,1363132800"; 
   d="scan'208";a="34987863"
Date: Wed, 3 Jul 2013 16:59:37 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Jaeyong Yoo <jaeyong.yoo@samsung.com>
CC: <xen-devel@lists.xen.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [Xen-devel] [PATCH RFC] xen/arm: domain kernel: Small fixes for
 making suspendable for arm
In-Reply-To: <1372842988-27547-1-git-send-email-jaeyong.yoo@samsung.com>
Message-ID: <alpine.DEB.2.02.1307031440350.5067@kaball.uk.xensource.com>
References: <1372842988-27547-1-git-send-email-jaeyong.yoo@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jul 2013, Jaeyong Yoo wrote:
> Modify makefile to compile driver/xen/manage.c for arm and implement
> resuming the shared page info. This patch is required for domu kernel
> to test the xen-on-arndale migration.
> 
> Since there are lot of missing functions for compiling hibernation mode,
> temporarily I put empty functions in xen/dummy.c, but they are originally
> belong to such as arch/arm/power directories (which is not existing).
> I think there would be any better way...
> 
> Signed-off-by: Jaeyong Yoo <jaeyong.yoo@samsung.com>
>
>  arch/arm/Kconfig                |  3 ++
>  arch/arm/boot/dts/xenvm-4.2.dts |  2 +-
>  arch/arm/xen/Makefile           |  2 +-
>  arch/arm/xen/dummy.c            | 30 ++++++++++++++++
>  arch/arm/xen/mmu.c              | 12 +++++++
>  arch/arm/xen/suspend.c          | 76 +++++++++++++++++++++++++++++++++++++++++
>  arch/arm/xen/time.c             |  7 ++++

Be careful that xen for arm64 just went upstream and it's just
recompiling the same Xen files under arm64.  See arch/arm64/xen.
The changes you make to c files under arch/arm/xen need to compile on
arm64 too.


>  drivers/xen/Makefile            |  2 +-
>  drivers/xen/manage.c            |  8 +++++
>  9 files changed, 139 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/xen/dummy.c
>  create mode 100644 arch/arm/xen/mmu.c
>  create mode 100644 arch/arm/xen/suspend.c
>  create mode 100644 arch/arm/xen/time.c
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 2c3bdce..77309f7 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1469,6 +1469,9 @@ config ARCH_NO_VIRT_TO_BUS
>  config ISA_DMA_API
>  	bool
>  
> +config ARCH_HIBERNATION_POSSIBLE
> +        def_bool y
> +

This could be an issue because if you introduce this symbol you allow
users to compile hibernation code on all arm platforms.
At the very least it should have "depends on XEN".



>  config PCI
>  	bool "PCI support" if MIGHT_HAVE_PCI
>  	help
>
> diff --git a/arch/arm/boot/dts/xenvm-4.2.dts b/arch/arm/boot/dts/xenvm-4.2.dts
> index 2f4136b..33df5e6 100644
> --- a/arch/arm/boot/dts/xenvm-4.2.dts
> +++ b/arch/arm/boot/dts/xenvm-4.2.dts
> @@ -17,7 +17,7 @@
>  
>  	chosen {
>  		/* this field is going to be adjusted by the hypervisor */
> -		bootargs = "console=hvc0 root=/dev/xvda";
> +		bootargs = "console=hvc0 root=/dev/xvda1 rw init";
>  	};
>  
>  	cpus {

please remove this change, this dts is just an example


> diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
> index 4384103..6fdc47a 100644
> --- a/arch/arm/xen/Makefile
> +++ b/arch/arm/xen/Makefile
> @@ -1 +1 @@
> -obj-y		:= enlighten.o hypercall.o grant-table.o
> +obj-y		:= enlighten.o hypercall.o grant-table.o suspend.o mmu.o time.o dummy.o
> diff --git a/arch/arm/xen/dummy.c b/arch/arm/xen/dummy.c
> new file mode 100644
> index 0000000..daa949c
> --- /dev/null
> +++ b/arch/arm/xen/dummy.c
> @@ -0,0 +1,30 @@
> +#include <linux/kernel.h>
> +#include <linux/printk.h>
> +
> +void save_processor_state(void)
> +{
> +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> +}
> +
> +void restore_processor_state(void)
> +{
> +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> +}
> +
> +int swsusp_arch_suspend(void)
> +{
> +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> +	return 0;
> +}
> +
> +int swsusp_arch_resume(void)
> +{
> +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> +	return 0;
> +}
> +
> +int pfn_is_nosave(unsigned long pfn)
> +{
> +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> +	return 0;
> +}

These functions are not Xen specific, they should not be under
arch/arm/xen.
Maybe we could put them under arch/arm/power or drivers/xen?



> diff --git a/arch/arm/xen/mmu.c b/arch/arm/xen/mmu.c
> new file mode 100644
> index 0000000..cc0ccc9
> --- /dev/null
> +++ b/arch/arm/xen/mmu.c
> @@ -0,0 +1,12 @@
> +#include <linux/kernel.h>
> +#include <xen/xen.h>
> +
> +void xen_mm_pin_all(void)
> +{
> +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> +}
> +
> +void xen_mm_unpin_all(void)
> +{
> +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> +}

No need to print an error here, I would just add a comment saying "no
need to pin/unpin anything because we are always using second stage
translation".


> diff --git a/arch/arm/xen/suspend.c b/arch/arm/xen/suspend.c
> new file mode 100644
> index 0000000..946a960
> --- /dev/null
> +++ b/arch/arm/xen/suspend.c
> @@ -0,0 +1,76 @@
> +#include <xen/xen.h>
> +#include <xen/events.h>
> +#include <xen/grant_table.h>
> +#include <xen/hvm.h>
> +#include <xen/interface/vcpu.h>
> +#include <xen/interface/xen.h>
> +#include <xen/interface/memory.h>
> +#include <xen/interface/hvm/params.h>
> +#include <xen/features.h>
> +#include <xen/platform_pci.h>
> +#include <xen/xenbus.h>
> +#include <xen/page.h>
> +#include <xen/xen-ops.h>
> +#include <asm/xen/hypervisor.h>
> +#include <asm/xen/hypercall.h>
> +#include <linux/interrupt.h>
> +#include <linux/irqreturn.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_address.h>
> +
> +#include <linux/mm.h>
> +
> +void xen_arch_pre_suspend(void)
> +{
> +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> +}

if we don't need to do anything, it's not an error.


> +void xen_arch_hvm_post_suspend(int suspend_cancelled)
> +{
> +	if( !suspend_cancelled ) {
> +		int cpu;
> +		struct xen_add_to_physmap xatp;
> +		static struct shared_info *shared_info_page = 0;
> +
> +		if( !shared_info_page )
> +			shared_info_page = (struct shared_info *)
> +				get_zeroed_page(GFP_KERNEL);
> +		if (!shared_info_page) {
> +			pr_err("not enough memory\n");
> +			return;
> +		}
> +
> +		xatp.domid = DOMID_SELF;
> +		xatp.idx = 0;
> +		xatp.space = XENMAPSPACE_shared_info;
> +		xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
> +		if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
> +			BUG();
> +
> +		HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
> +
> +		/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
> +		 * page, we use it in the event channel upcall */
> +		for_each_online_cpu(cpu) {
> +			per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
> +		}
> +		printk(KERN_ERR"%s: remmaping shared info...\n", __func__);
> +	}
> +}

It would be good to refactor the shared_info page setup on a separate
function that can be called from xen_guest_init and from
xen_arch_hvm_post_suspend, like we do on x86.


> +void xen_arch_post_suspend(int suspend_cancelled)
> +{
> +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> +}
> +
> +static void xen_vcpu_notify_restore(void *data)
> +{
> +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> +}
> +
> +void xen_arch_resume(void)
> +{
> +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> +}

if don't need to do anything, it's not an error.


> diff --git a/arch/arm/xen/time.c b/arch/arm/xen/time.c
> new file mode 100644
> index 0000000..af90e53
> --- /dev/null
> +++ b/arch/arm/xen/time.c
> @@ -0,0 +1,7 @@
> +#include <linux/kernel.h>
> +#include <xen/xen.h>
> +
> +void xen_timer_resume(void)
> +{
> +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> +}

same here


> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index eabd0ee..3d24a95 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -1,10 +1,10 @@
>  ifneq ($(CONFIG_ARM),y)
> -obj-y	+= manage.o
>  obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>  endif
>  obj-$(CONFIG_X86)			+= fallback.o
>  obj-y	+= grant-table.o features.o events.o balloon.o
>  obj-y	+= xenbus/
> +obj-y	+= manage.o
>  
>  nostackp := $(call cc-option, -fno-stack-protector)
>  CFLAGS_features.o			:= $(nostackp)
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index 412b96c..140c7a9 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -17,6 +17,7 @@
>  #include <xen/events.h>
>  #include <xen/hvc-console.h>
>  #include <xen/xen-ops.h>
> +#include <xen/interface/sched.h>
>  
>  #include <asm/xen/hypercall.h>
>  #include <asm/xen/page.h>
> @@ -86,7 +87,14 @@ static int xen_suspend(void *data)
>  	 * or the domain was merely checkpointed, and 0 if it
>  	 * is resuming in a new domain.
>  	 */
> +#ifdef CONFIG_ARM
> +	{
> +		struct sched_shutdown r = { .reason = SHUTDOWN_suspend };
> +		HYPERVISOR_sched_op(SCHEDOP_shutdown, &r);
> +	}
> +#else
>  	si->cancelled = HYPERVISOR_suspend(si->arg);
> +#endif
>  
>  	if (si->post)
>  		si->post(si->cancelled);

We should implement HYPERVISOR_suspend on ARM
