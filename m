Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab3HUKSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:18:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58595 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab3HUKSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:18:09 -0400
X-IronPort-AV: E=Sophos;i="4.89,927,1367942400"; 
   d="scan'208";a="8261329"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: konrad.wilk@oracle.com, robert.moore@intel.com, lv.zheng@intel.com,
        rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH 3/8] x86, acpi: Move table_sigs[] to stack.
Date: Wed, 21 Aug 2013 18:15:38 +0800
Message-Id: <1377080143-28455-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377080143-28455-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1377080143-28455-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/21 18:15:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/21 18:15:17,
	Serialize complete at 2013/08/21 18:15:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64bit, we will do acpi_initrd_override() in x86_64_start_kernel(). This is
after CPU enables paging, but before direct mapping page tables are setup.
This is OK because we have an early page fault handler to help to access data
without direct mapping page tables.

But on 32bit, in order to keep the x86_32 and x86_64 unified code clean, we want
to do acpi_initrd_override() in head_32.S, before CPU enables paging. Without
direct mapping page tables, we need to access data with physical address.

For global variables, if we access them, we are using va. So on 32bit, we have
to convert them into pa. But for a global array, it could be too messy.

So this patch move table_sigs[] to stack. Define it in acpi_initrd_override().
It is no more than 36 pointers, so it is OK to put it on stack.

Originally-From: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/osl.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index e7effc1..06996d8 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -551,18 +551,6 @@ u8 __init acpi_table_checksum(u8 *buffer, u32 length)
 	return sum;
 }
 
-/* All but ACPI_SIG_RSDP and ACPI_SIG_FACS: */
-static const char * const table_sigs[] = {
-	ACPI_SIG_BERT, ACPI_SIG_CPEP, ACPI_SIG_ECDT, ACPI_SIG_EINJ,
-	ACPI_SIG_ERST, ACPI_SIG_HEST, ACPI_SIG_MADT, ACPI_SIG_MSCT,
-	ACPI_SIG_SBST, ACPI_SIG_SLIT, ACPI_SIG_SRAT, ACPI_SIG_ASF,
-	ACPI_SIG_BOOT, ACPI_SIG_DBGP, ACPI_SIG_DMAR, ACPI_SIG_HPET,
-	ACPI_SIG_IBFT, ACPI_SIG_IVRS, ACPI_SIG_MCFG, ACPI_SIG_MCHI,
-	ACPI_SIG_SLIC, ACPI_SIG_SPCR, ACPI_SIG_SPMI, ACPI_SIG_TCPA,
-	ACPI_SIG_UEFI, ACPI_SIG_WAET, ACPI_SIG_WDAT, ACPI_SIG_WDDT,
-	ACPI_SIG_WDRT, ACPI_SIG_DSDT, ACPI_SIG_FADT, ACPI_SIG_PSDT,
-	ACPI_SIG_RSDT, ACPI_SIG_XSDT, ACPI_SIG_SSDT, NULL };
-
 #define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
 
 /* Must not increase 10 or needs code modification below */
@@ -577,6 +565,17 @@ void __init acpi_initrd_override(void *data, size_t size)
 	struct cpio_data file;
 	struct cpio_data early_initrd_files[ACPI_OVERRIDE_TABLES];
 	char *p;
+	/* All but ACPI_SIG_RSDP and ACPI_SIG_FACS: */
+	const char * const table_sigs[] = {
+		ACPI_SIG_BERT, ACPI_SIG_CPEP, ACPI_SIG_ECDT, ACPI_SIG_EINJ,
+		ACPI_SIG_ERST, ACPI_SIG_HEST, ACPI_SIG_MADT, ACPI_SIG_MSCT,
+		ACPI_SIG_SBST, ACPI_SIG_SLIT, ACPI_SIG_SRAT, ACPI_SIG_ASF,
+		ACPI_SIG_BOOT, ACPI_SIG_DBGP, ACPI_SIG_DMAR, ACPI_SIG_HPET,
+		ACPI_SIG_IBFT, ACPI_SIG_IVRS, ACPI_SIG_MCFG, ACPI_SIG_MCHI,
+		ACPI_SIG_SLIC, ACPI_SIG_SPCR, ACPI_SIG_SPMI, ACPI_SIG_TCPA,
+		ACPI_SIG_UEFI, ACPI_SIG_WAET, ACPI_SIG_WDAT, ACPI_SIG_WDDT,
+		ACPI_SIG_WDRT, ACPI_SIG_DSDT, ACPI_SIG_FADT, ACPI_SIG_PSDT,
+		ACPI_SIG_RSDT, ACPI_SIG_XSDT, ACPI_SIG_SSDT, NULL };
 
 	if (data == NULL || size == 0)
 		return;
-- 
1.7.1

