Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144Ab3JPRCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:02:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53850 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761039Ab3JPRC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:02:29 -0400
Date: Wed, 16 Oct 2013 19:02:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, joe@perches.com, naveen.n.rao@linux.vnet.ibm.com,
        m.chehab@samsung.com, arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/9] ACPI, x86: Extended error log driver for x86
 platform
Message-ID: <20131016170214.GJ13608@pd.tnic>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-5-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381935366-11731-5-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:56:01AM -0400, Chen, Gong wrote:
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index b3218cd..c11a53f 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -48,6 +48,8 @@
>  
>  #include "mce-internal.h"
>  
> +static int (*mce_ext_err_print)(const char *, int, int) = NULL;

Applying: ACPI, x86: Extended error log driver for x86 platform
ERROR: do not initialise statics to 0 or NULL
#32: FILE: arch/x86/kernel/cpu/mcheck/mce.c:51:
+static int (*mce_ext_err_print)(const char *, int, int) = NULL;

> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 22327e6..819c06b 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -372,4 +372,13 @@ config ACPI_BGRT
>  
>  source "drivers/acpi/apei/Kconfig"
>  
> +config ACPI_EXTLOG
> +	tristate "Extended Error Log support"
> +	depends on X86_MCE
> +	default n
> +	help
> +	  Enhanced MCA Logging allows firmware to provide additional error
> +	  information to system software, synchronous with MCE or CMCI. This
> +	  driver adds support for that functionality.

Yep, you can use the description from your 0/9 mail here.

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
> index 0000000..d55b072
> --- /dev/null
> +++ b/drivers/acpi/acpi_extlog.c
> @@ -0,0 +1,319 @@
> +/*
> + * Extended Error Log driver
> + *
> + * Copyright (C) 2013 Intel Corp.
> + * Author: Chen, Gong <gong.chen@intel.com>
> + *
> + * This file is licensed under GPLv2.
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
> +#define EXT_ELOG_ENTRY_MASK	GENMASK_ULL(52, 0) /* elog entry address mask */

So was this supposed to be 0xfffffffffffff, right?

Because that's bits 0 up to and including 51. In which case, it should
be GENMASK_ULL(51,0).

The rest are checkpatch minor issues below.

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

CHECK: braces {} should be used on all arms of this statement
#280: FILE: drivers/acpi/acpi_extlog.c:178:
+       if (obj->type == ACPI_TYPE_INTEGER)
[...]
+       else if (obj->type == ACPI_TYPE_BUFFER) {
[...]

> +		if (obj->buffer.length <= 8) {
> +			for (i = 0; i < obj->buffer.length; i++)
> +				*ret |= (obj->buffer.pointer[i] << (i * 8));
> +		}
> +	}
> +	kfree(buf.pointer);
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
> +		return false;
> +
> +	if (extlog_get_dsm(handle, EXTLOG_DSM_REV, EXTLOG_FN_QUERY, &ret) ||
> +			!(ret & EXTLOG_QUERY_L1_EXIST))

CHECK: Alignment should match open parenthesis
#302: FILE: drivers/acpi/acpi_extlog.c:200:
+       if (extlog_get_dsm(handle, EXTLOG_DSM_REV, EXTLOG_FN_QUERY, &ret) ||
+                       !(ret & EXTLOG_QUERY_L1_EXIST))

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
