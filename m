Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab3IWOQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:16:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48736 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3IWOQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:16:38 -0400
Message-ID: <52404DBD.6010607@oracle.com>
Date: Mon, 23 Sep 2013 10:18:37 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xen.org, david.vrabel@citrix.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/5] xen/PMU: Initialization code for Xen PMU
References: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com> <1378827110-4192-4-git-send-email-boris.ostrovsky@oracle.com> <20130923132618.GD3175@phenom.dumpdata.com>
In-Reply-To: <20130923132618.GD3175@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 09:26 AM, Konrad Rzeszutek Wilk wrote:
> On Tue, Sep 10, 2013 at 11:31:48AM -0400, Boris Ostrovsky wrote:
>> Map shared data structure that will hold CPU registers, VPMU context,
>> VCPU/PCPI IDs of the VCPU interrupted by PMU interrupt. Hypervisor
>> fills this information in its handler and passes it to the guest for
>> further processing.
>>
>> Set up PMU VIRQ.
>>
>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> ---
>>   arch/x86/xen/Makefile          |   2 +-
>>   arch/x86/xen/pmu.c             | 122 +++++++++++++++++++++++++++++++++++++++++
>>   arch/x86/xen/pmu.h             |  12 ++++
>>   arch/x86/xen/smp.c             |  31 ++++++++++-
>>   include/xen/interface/xen.h    |   1 +
>>   include/xen/interface/xenpmu.h |  77 ++++++++++++++++++++++++++
>>   6 files changed, 243 insertions(+), 2 deletions(-)
>>   create mode 100644 arch/x86/xen/pmu.c
>>   create mode 100644 arch/x86/xen/pmu.h
>>
>> diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
>> index 96ab2c0..b187df5 100644
>> --- a/arch/x86/xen/Makefile
>> +++ b/arch/x86/xen/Makefile
>> @@ -13,7 +13,7 @@ CFLAGS_mmu.o			:= $(nostackp)
>>   obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
>>   			time.o xen-asm.o xen-asm_$(BITS).o \
>>   			grant-table.o suspend.o platform-pci-unplug.o \
>> -			p2m.o
>> +			p2m.o pmu.o
> Perhaps guard the build of this based on CONFIG_PERF_EVENTS?
>
> That would of course mean you also have to create in xenpmu.h
> static inline empy functions for xen_pmu_finish and xen_pmu_init in case
> CONFIG_PERF_EVENTS is not set.

This is interface header, am I allowed to do those sorts of things there?

Also, *theoretically* other performance-measuring tools can use this 
framework, expect for perf-specific things like callbacks and the 
handler call. So maybe I should put CONFIG_PERF_EVENTS in pmu.c?

>>   
>>   obj-$(CONFIG_EVENT_TRACING) += trace.o
>>   
>> diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
>> new file mode 100644
>> index 0000000..da061d4
>> --- /dev/null
>> +++ b/arch/x86/xen/pmu.c
>> @@ -0,0 +1,122 @@
>> +#include <linux/types.h>
>> +#include <linux/interrupt.h>
>> +
>> +#include <asm/xen/hypercall.h>
>> +#include <xen/page.h>
>> +#include <xen/interface/xen.h>
>> +#include <xen/interface/vcpu.h>
>> +#include <xen/interface/xenpmu.h>
>> +
>> +#include "xen-ops.h"
>> +#include "pmu.h"
>> +
>> +/* x86_pmu.handle_irq definition */
>> +#include <../kernel/cpu/perf_event.h>
>> +
>> +
>> +/* Shared page between hypervisor and domain */
>> +DEFINE_PER_CPU(struct xenpmu_data *, xenpmu_shared);
>> +
>> +/* perf callbacks*/
>> +int xen_is_in_guest(void)
>> +{
>> +	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
>> +						  smp_processor_id());
>> +
>> +	if (!xen_initial_domain() ||
>> +	    xenpmu_data->domain_id > DOMID_SELF || xenpmu_data->domain_id == 0)
>> +		return 0;
>> +
>> +	return 1;
>> +}
>> +
>> +static int xen_is_user_mode(void)
>> +{
>> +	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
>> +						  smp_processor_id());
>> +	return ((xenpmu_data->regs.cs & 3) == 3);
>> +}
>> +
>> +static unsigned long xen_get_guest_ip(void)
>> +{
>> +	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
>> +						  smp_processor_id());
>> +	return xenpmu_data->regs.eip;
>> +}
>> +
>> +static struct perf_guest_info_callbacks xen_guest_cbs = {
>> +	.is_in_guest            = xen_is_in_guest,
>> +	.is_user_mode           = xen_is_user_mode,
>> +	.get_guest_ip           = xen_get_guest_ip,
>> +};
>> +
>> +/* Convert registers from Xen's format to Linux' */
>> +static void xen_convert_regs(struct cpu_user_regs *xen_regs,
>> +			     struct pt_regs *regs)
>> +{
>> +	regs->ip = xen_regs->eip;
>> +	regs->cs = xen_regs->cs;
>> +}
>> +
>> +irqreturn_t xen_pmu_irq_handler(int irq, void *dev_id)
>> +{
>> +	int ret = IRQ_NONE;
>> +	struct pt_regs regs;
>> +	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
>> +						  smp_processor_id());
>> +
>> +	xen_convert_regs(&xenpmu_data->regs, &regs);
>> +	if (x86_pmu.handle_irq(&regs))
>> +		ret = IRQ_HANDLED;
>> +
>> +	return ret;
>> +}
>> +
>> +int xen_pmu_init(int cpu)
>> +{
>> +	int ret = 0;
>> +	struct xenpmu_params xp;
>> +	unsigned long pfn;
>> +	struct xenpmu_data *xenpmu_data;
>> +
>> +	BUILD_BUG_ON(sizeof(struct xenpmu_data) > PAGE_SIZE);
>> +	xenpmu_data = vmalloc(PAGE_SIZE);
>> +	if (!xenpmu_data) {
>> +		ret = -ENOMEM;
>> +		goto fail;
>> +	}
>> +	pfn = vmalloc_to_pfn((char *)xenpmu_data);
>> +
>> +	xp.mfn = pfn_to_mfn(pfn);
>> +	xp.vcpu = cpu;
>> +	xp.version.maj = XENPMU_VER_MAJ;
>> +	xp.version.min = XENPMU_VER_MIN;
>> +	ret = HYPERVISOR_xenpmu_op(XENPMU_init, &xp);
>> +	if (ret)
>> +		goto fail;
>> +
>> +	per_cpu(xenpmu_shared, cpu) = xenpmu_data;
>> +
>> +	if (cpu == 0)
>> +		perf_register_guest_info_callbacks(&xen_guest_cbs);
>> +
>> +	return ret;
>> +
>> +fail:
>> +	vfree(xenpmu_data);
>> +	return ret;
>> +}
>> +
>> +void xen_pmu_finish(int cpu)
>> +{
>> +	struct xenpmu_params xp;
>> +
>> +	xp.vcpu = cpu;
>> +	xp.version.maj = XENPMU_VER_MAJ;
>> +	xp.version.min = XENPMU_VER_MIN;
>> +
>> +	(void)HYPERVISOR_xenpmu_op(XENPMU_finish, &xp);
>> +
>> +	vfree(per_cpu(xenpmu_shared, cpu));
>> +	per_cpu(xenpmu_shared, cpu) = NULL;
> I think you are missing:
>
> perf_unregister_guest_info_callbacks when this is the bootup CPU.

But there is always at least one CPU running, so I think I should keep 
the callbacks. The only reason I have 'if (cpu == 0)' when I register 
the callbacks is because I only want to do this once and when we are 
coming up cpu 0 is always the boot cpu (right?).

>
> And you should probably move this around to be:
>
> 	if (cpu == 0 && num_online_cpus() == 1)
> 		perf_unregister_guest_info_callbacks(..)
> 	per_cpu(xenpmu_shared, cpu) = NULL;
> 	vfree(per_cpu(xenpmu_shared, cpu))

Then I'd be calling vfree(NULL), wouldn't I?

-boris

