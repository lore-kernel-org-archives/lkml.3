Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab3LFPBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:01:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:25208 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab3LFPBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:01:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,841,1378882800"; 
   d="scan'208";a="445781840"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>
CC: Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Peter Jones <pjones@redhat.com>
Subject: RE: [PATCH v3 6/6] ACPI/IBFT: Fix wrong <acpi/acpi.h> inclusion in
 iSCSI boot firmware module.
Thread-Topic: [PATCH v3 6/6] ACPI/IBFT: Fix wrong <acpi/acpi.h> inclusion in
 iSCSI boot firmware module.
Thread-Index: AQHO8mCocEYSzfc0pE6KYbBeZ8ggRJpHQP1w
Date: Fri, 6 Dec 2013 15:01:06 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024950FD@SHSMSX101.ccr.corp.intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com>
 <cover.1386316208.git.lv.zheng@intel.com>
 <7d10180ca652b4a20a07517946fc0fed6a591650.1386316208.git.lv.zheng@intel.com>
In-Reply-To: <7d10180ca652b4a20a07517946fc0fed6a591650.1386316208.git.lv.zheng@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Zheng, Lv
> Sent: Friday, December 06, 2013 4:52 PM
> 
> In Linux kernel, ACPICA is wrapped and safely exported by CONFIG_ACPI.  So
> all external modules should depend on CONFIG_ACPI rather than using ACPICA
> header directly for stubbing.  But if we moves <acpi/acpi.h> inclusions
> into "#ifdef CONFIG_ACPI", build breakge can help to detect wrong ACPICA
> dependent modules.
> 
> One of the build breakage is:
> drivers/firmware/iscsi_ibft_find.c: In function 'find_ibft_region':
> drivers/firmware/iscsi_ibft_find.c:106:12: error: dereferencing pointer to incomplete type
> drivers/firmware/iscsi_ibft_find.c:106:12: error: dereferencing pointer to incomplete type
> drivers/firmware/iscsi_ibft_find.c:106:12: error: dereferencing pointer to incomplete type
> 
> The root cause of this breakage is:
> 1. iBFT locating is implemented by looking up it in the memory.  This is
>    based on the specification.  Specification doesn't mention if it can
>    appear on a non-ACPI platforms but mentions it is defined in ACPI 3.0b.
>    The current CONFIG_ISCSI_IBFT_FIND doesn't use ACPI table APIs to locate
>    the table, thus it doesn't rely on CONFIG_ACPI.
> 
> Since ACPI iSCSI Boot Firmware is an ACPI-based mechanism (please refer to
> the Doclink below), we can make CONFIG_ISCSI_IBFT_FIND dependent on
> CONFIG_ACPI though the locating mechanism can be implemented without using
> ACPI table APIs.  But please let me know if this is wrong.

Ping Konrad or Peter, will this fix mess up some situations?
Originally, this patch is marked as RFC.
But since I can see it in linux-pm/bleeding-edge branch and this patchset refreshes what have been accepted, I took the "RFC" off.

Thanks and best regards
-Lv

> 
> Doclink: http://www.microsoft.com/whdc/system/platform/firmware/ibft.mspx
> Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
> Cc: Peter Jones <pjones@redhat.com>
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> ---
>  drivers/firmware/Kconfig   |    2 +-
>  include/linux/iscsi_ibft.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 0747872..a6ef6ac 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -110,7 +110,7 @@ config DMI_SYSFS
> 
>  config ISCSI_IBFT_FIND
>  	bool "iSCSI Boot Firmware Table Attributes"
> -	depends on X86
> +	depends on X86 && ACPI
>  	default n
>  	help
>  	  This option enables the kernel to find the region of memory
> diff --git a/include/linux/iscsi_ibft.h b/include/linux/iscsi_ibft.h
> index 82f9673..605cc5c 100644
> --- a/include/linux/iscsi_ibft.h
> +++ b/include/linux/iscsi_ibft.h
> @@ -21,7 +21,7 @@
>  #ifndef ISCSI_IBFT_H
>  #define ISCSI_IBFT_H
> 
> -#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
> +#include <linux/acpi.h>
> 
>  /*
>   * Logical location of iSCSI Boot Format Table.
> --
> 1.7.10

