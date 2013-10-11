Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3JKPZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:25:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53673 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab3JKPZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:25:04 -0400
Date: Fri, 11 Oct 2013 17:24:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/8] ACPI, x86: Extended error log driver for x86 platform
Message-ID: <20131011152451.GF5925@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-4-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381473166-29303-4-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 02:32:41AM -0400, Chen, Gong wrote:
> This error log driver (a.k.a eMCA driver) is implemented based on
> http://www.intel.com/content/www/us/en/architecture-and-technology/enhanced-mca-logging-xeon-paper.html.
> After errors are captured, more valuable information can be
> got with this new enhanced error log driver.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  arch/x86/include/asm/mce.h       |   5 +
>  arch/x86/kernel/cpu/mcheck/mce.c |  10 ++
>  drivers/acpi/Kconfig             |   8 +
>  drivers/acpi/Makefile            |   2 +
>  drivers/acpi/acpi_extlog.c       | 339 +++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/bus.c               |   3 +-
>  include/linux/acpi.h             |   1 +
>  7 files changed, 367 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/acpi/acpi_extlog.c
> 
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index cbe6b9e..f8c33e2 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -12,6 +12,7 @@
>  #define MCG_CTL_P		(1ULL<<8)    /* MCG_CTL register available */
>  #define MCG_EXT_P		(1ULL<<9)    /* Extended registers available */
>  #define MCG_CMCI_P		(1ULL<<10)   /* CMCI supported */
> +#define MCG_EXT_ERR_LOG		(1ULL<<26)   /* Extended error log supported */
>  #define MCG_EXT_CNT_MASK	0xff0000     /* Number of Extended registers */
>  #define MCG_EXT_CNT_SHIFT	16
>  #define MCG_EXT_CNT(c)		(((c) & MCG_EXT_CNT_MASK) >> MCG_EXT_CNT_SHIFT)

Let's keep them numerically sorted by the bit numbers so put
MCG_EXT_ERR_LOG after bit 24, MCG_SER_P.

Besides, this bit should be called MCG_ELOG_P as it is in the docs
although your name is much more descriptive than what the hw guys came
up with but I know they like to abbreviate to the lowest letter count
possible :)

> @@ -204,6 +205,10 @@ extern void mce_disable_bank(int bank);
>   * Exception handler
>   */
>  
> +extern spinlock_t mce_elog_lock;

Uuh, I don't think we want to expose the naked spinlock. Rather, we'd
need a couple of functions

mce_elog_lock
mce_elog_unlock

which get called by users.

Actually, it would be even better to keep all those details private
to acpi_extlog.c and have machine_check_poll() call extlog_print()
and in the cases where there's no extlog support, you have an empty
extlog_print function.

> +extern int (*mce_extlog_support)(void);

Unused leftover?

> +/* Call the installed extended error log print function */
> +extern int (*mce_ext_err_print)(const char *, int cpu, int bank);
>  /* Call the installed machine check handler for this CPU setup. */
>  extern void (*machine_check_vector)(struct pt_regs *, long error_code);
>  void do_machine_check(struct pt_regs *, long);
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index b3218cd..6802637 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -48,6 +48,12 @@
>  
>  #include "mce-internal.h"
>  
> +DEFINE_SPINLOCK(mce_elog_lock);
> +EXPORT_SYMBOL_GPL(mce_elog_lock);

Yeah, private to acpi_extlog and it can be simply 'elog_lock' there,
without the "mce_" prefix.

> +
> +int (*mce_ext_err_print)(const char *, int, int) = NULL;
> +EXPORT_SYMBOL_GPL(mce_ext_err_print);
> +
>  static DEFINE_MUTEX(mce_chrdev_read_mutex);
>  
>  #define rcu_dereference_check_mce(p) \
> @@ -624,6 +630,10 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>  		    (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC)))
>  			continue;
>  
> +		spin_lock(&mce_elog_lock);
> +		if (mce_ext_err_print)
> +			mce_ext_err_print(NULL, m.extcpu, i);
> +		spin_unlock(&mce_elog_lock);

private to acpi_extlog.c

>  		mce_read_aux(&m, i);
>  
>  		if (!(flags & MCP_TIMESTAMP))
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 22327e6..1465fa8 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -372,4 +372,12 @@ config ACPI_BGRT
>  
>  source "drivers/acpi/apei/Kconfig"
>  
> +config ACPI_EXTLOG
> +	tristate "Extended Error Log support"
> +	depends on X86 && X86_MCE

I guess we can depend only on X86_MCE

> +	default n
> +	help
> +	  This driver adds support for decoding extended errors from hardware.
> +	  which allows the operating system to obtain data from trace.

Let's make this description a bit better:

"Enhanced MCA Logging allows firmware to provide additional error
information to system software, synchronous with MCE or CMCI. This
driver adds support for that functionality plus an additional special
tracepoint which carries that information to userspace."


> +
>  endif	# ACPI
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index cdaf68b..bce34af 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -82,3 +82,5 @@ processor-$(CONFIG_CPU_FREQ)	+= processor_perflib.o
>  obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
>  
>  obj-$(CONFIG_ACPI_APEI)		+= apei/
> +
> +obj-$(CONFIG_ACPI_EXTLOG)	+= acpi_extlog.o
> diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
> new file mode 100644
> index 0000000..3e3e286
> --- /dev/null
> +++ b/drivers/acpi/acpi_extlog.c
> @@ -0,0 +1,339 @@
> +/*
> + * Extended Error Log driver
> + *
> + * Copyright (C) 2013 Intel Corp.
> + * Author: Chen, Gong <gong.chen@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

Please no more of that boilerplate. Simply say that this file is
licensed under GPLv2 and that's it.

> + */
> +
> +#include <linux/module.h>
> +#include <linux/acpi.h>
> +#include <acpi/acpi_bus.h>
> +#include <linux/cper.h>
> +#include <linux/ratelimit.h>
> +#include <asm/mce.h>
> +
> +#include "apei/apei-internal.h"
> +
> +#define EXT_ELOG_ENTRY_MASK	0xfffffffffffff /* elog entry address mask */

Am I reading this correctly that these are bits [51:0]?

Btw, we have a GENMASK macro in drivers/edac/amd64_edac.h which can be used for
generating contiguous bitmasks:

#define EXT_ELOG_ENTRY_MASK	GENMASK(0, 51)

which makes it much more readable.

You could lift it into a more global header like, say,
arch/x86/include/asm/edac.h maybe...

> +
> +#define EXTLOG_DSM_REV		0x0
> +#define	EXTLOG_FN_QUERY		0x0
> +#define	EXTLOG_FN_ADDR		0x1
> +
> +#define FLAG_OS_OPTIN		BIT(0)
> +#define EXTLOG_QUERY_L1_EXIST	BIT(1)
> +#define ELOG_ENTRY_VALID	(1ULL<<63)
> +#define ELOG_ENTRY_LEN		0x1000
> +
> +#define EMCA_BUG \
> +	"Can not request iomem region <0x%016llx-0x%016llx> - eMCA disabled\n"
> +
> +struct extlog_l1_head {
> +	u32 ver;	/* Header Version */
> +	u32 hdr_len;	/* Header Length */
> +	u64 total_len;	/* entire L1 Directory length including this header */
> +	u64 elog_base;	/* MCA Error Log Directory base address */
> +	u64 elog_len;	/* MCA Error Log Directory length */
> +	u32 flags;	/* bit 0 - OS/VMM Opt-in */
> +	u8  rev0[12];
> +	u32 entries;	/* Valid L1 Directory entries per logical processor */
> +	u8  rev1[12];
> +};
> +
> +static u8 extlog_dsm_uuid[] = "663E35AF-CC10-41A4-88EA-5470AF055295";
> +
> +/* L1 table related physical address */
> +static u64 elog_base;
> +static size_t elog_size;
> +static u64 l1_dirbase;
> +static size_t l1_size;
> +
> +/* L1 table related virtual address */
> +static void __iomem *extlog_l1_addr;
> +static void __iomem *elog_addr;
> +
> +static void *elog_buf;
> +
> +static u64 *l1_entry_base;
> +static u32 l1_percpu_entry;
> +
> +#define ELOG_IDX(cpu, bank) \
> +	(cpu_physical_id(cpu) * l1_percpu_entry + (bank))
> +
> +#define ELOG_ENTRY_DATA(idx) \
> +	(*(l1_entry_base + (idx)))
> +
> +#define ELOG_ENTRY_ADDR(phyaddr) \
> +	(phyaddr - elog_base + (u8 *)elog_addr)
> +
> +static struct acpi_generic_status *extlog_elog_entry_check(int cpu, int bank)
> +{
> +	int idx;
> +	u64 data;
> +	struct acpi_generic_status *estatus;
> +
> +	BUG_ON(cpu < 0);

What is this supposed to guard? And why such a heavy hammer?

> +	idx = ELOG_IDX(cpu, bank);
> +	data = ELOG_ENTRY_DATA(idx);
> +	if ((data & ELOG_ENTRY_VALID) == 0)
> +		return NULL;
> +
> +	data &= EXT_ELOG_ENTRY_MASK;
> +	estatus = (struct acpi_generic_status *)ELOG_ENTRY_ADDR(data);
> +
> +	/* if no valid data in elog entry, just return */
> +	if (estatus->block_status == 0)
> +		return NULL;
> +
> +	return estatus;
> +}
> +
> +static void __print_extlog_rcd(const char *pfx,
> +		struct acpi_generic_status *estatus, int cpu)

Please align args after the opening bracket.

> +{
> +	static atomic_t seqno;
> +	unsigned int curr_seqno;
> +	char pfx_seq[64];
> +
> +	if (pfx == NULL) {

	if (!pfx)

> +		if (estatus->error_severity <= CPER_SEV_CORRECTED)
> +			pfx = KERN_INFO;
> +		else
> +			pfx = KERN_ERR;
> +	}
> +	curr_seqno = atomic_inc_return(&seqno);
> +	snprintf(pfx_seq, sizeof(pfx_seq), "%s{%u}", pfx, curr_seqno);
> +	printk("%s""Hardware error detected on CPU%d\n", pfx_seq, cpu);
> +	cper_estatus_print(pfx_seq, estatus);
> +}
> +
> +static int print_extlog_rcd(const char *pfx,
> +		struct acpi_generic_status *estatus, int cpu)a

Ditto.

> +{
> +	/* Not more than 2 messages every 5 seconds */
> +	static DEFINE_RATELIMIT_STATE(ratelimit_corrected, 5*HZ, 2);
> +	static DEFINE_RATELIMIT_STATE(ratelimit_uncorrected, 5*HZ, 2);
> +	struct ratelimit_state *ratelimit;
> +
> +	if (estatus->error_severity == CPER_SEV_CORRECTED ||
> +			(estatus->error_severity == CPER_SEV_INFORMATIONAL))

alignment:

	if ( estatus->error_severity == CPER_SEV_CORRECTED ||
	    (estatus->error_severity == CPER_SEV_INFORMATIONAL))

> +		ratelimit = &ratelimit_corrected;
> +	else
> +		ratelimit = &ratelimit_uncorrected;
> +	if (__ratelimit(ratelimit)) {
> +		__print_extlog_rcd(pfx, estatus, cpu);

Btw, __print_extlog_rcd is only called once, AFAICT. Why not fold it
in here?

> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
> +static int extlog_print(const char *pfx, int cpu, int bank)
> +{
> +	struct acpi_generic_status *estatus;
> +	int rc;
> +
> +	estatus = extlog_elog_entry_check(cpu, bank);
> +	if (estatus == NULL)
> +		return -EINVAL;
> +
> +	memcpy(elog_buf, (void *)estatus, ELOG_ENTRY_LEN);
> +	/* clear record status to enable BIOS to update it again */
> +	estatus->block_status = 0;
> +
> +	rc = print_extlog_rcd(pfx, (struct acpi_generic_status *)elog_buf, cpu);
> +
> +	return rc;
> +}
> +
> +static int extlog_get_dsm(acpi_handle handle, int rev, int func, u64 *ret)
> +{
> +	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
> +	struct acpi_object_list input;
> +	union acpi_object params[4], *obj;
> +	u8 uuid[16];
> +	int i;
> +
> +	acpi_str_to_uuid(extlog_dsm_uuid, uuid);
> +	input.count = 4;
> +	input.pointer = params;
> +	params[0].type = ACPI_TYPE_BUFFER;
> +	params[0].buffer.length = 16;
> +	params[0].buffer.pointer = uuid;
> +	params[1].type = ACPI_TYPE_INTEGER;
> +	params[1].integer.value = rev;
> +	params[2].type = ACPI_TYPE_INTEGER;
> +	params[2].integer.value = func;
> +	params[3].type = ACPI_TYPE_PACKAGE;
> +	params[3].package.count = 0;
> +	params[3].package.elements = NULL;
> +
> +	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DSM", &input, &buf)))
> +		return -1;
> +
> +	*ret = 0;
> +	obj = (union acpi_object *)buf.pointer;
> +	if (obj->type == ACPI_TYPE_INTEGER)
> +		*ret = obj->integer.value;
> +	else if (obj->type == ACPI_TYPE_BUFFER) {
> +		if (obj->buffer.length <= 8) {
> +			for (i = 0; i < obj->buffer.length; i++)
> +				*ret |= (obj->buffer.pointer[i] << (i * 8));
> +		}
> +	}
> +	kfree(buf.pointer);

I'm guessing this is how acpi does allocation - ACPI_ALLOCATE_BUFFER and
caller has to free it?

> +
> +	return 0;
> +}
> +
> +static bool extlog_get_l1addr(void)
> +{
> +	acpi_handle handle;
> +	u64 ret;
> +
> +	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
> +		goto fail;
> +
> +	if (extlog_get_dsm(handle, EXTLOG_DSM_REV, EXTLOG_FN_QUERY, &ret) ||
> +			!(ret & EXTLOG_QUERY_L1_EXIST))
> +		goto fail;
> +
> +	if (extlog_get_dsm(handle, EXTLOG_DSM_REV, EXTLOG_FN_ADDR, &ret))
> +		goto fail;
> +
> +	l1_dirbase = ret;
> +	/* Spec says L1 directory must be 4K aligned, bail out if it isn't */
> +	if (l1_dirbase & ((1 << 12) - 1)) {

		       & (PAGE_SIZE - 1)

> +		pr_warn(FW_BUG "L1 Directory is invalid at physical %llx\n",
> +			l1_dirbase);
> +		goto fail;
> +	}
> +
> +	return true;
> +fail:
> +	return false;

You probably could drop the labels and simply do "return false" in the
error cases as it is obvious.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
