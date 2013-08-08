Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157Ab3HHIzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:55:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28553 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934042Ab3HHIzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:55:33 -0400
X-IronPort-AV: E=Sophos;i="4.89,837,1367942400"; 
   d="scan'208";a="8153190"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH part3 0/5] acpi, acpica: Initialize acpi_gbl_root_table_list earlier and override it later.
Date: Thu, 8 Aug 2013 16:54:01 +0800
Message-Id: <1375952046-28490-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 16:54:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 16:54:05,
	Serialize complete at 2013/08/08 16:54:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to prevent bootmem allocator (memblock) from allocating hotpluggable 
memory for the kernel, we need to obtain SRAT earlier.

In part1 patch-set, we have split acpi_gbl_root_table_list initialization into
two steps: install and override.

This patch-set will do install step earlier. This will help us to find SRAT provided 
by firmware earlier in later patches. 

The current kernel looks like this:

setup_arch()
 |->acpi_initrd_override()         /* Find all tables specified by users in initrd,
 |                                    and store them in acpi_tables_addr array. */
 |......
 |->acpi_boot_table_init()         /* Find all tables in firmware and install them
                                      into acpi_gbl_root_table_list. Check acpi_tables_addr,
                                      if any table needs to be overrided, override it. */

After this patch-set, the kernel will look like this:

setup_arch()
 |->early_acpi_boot_table_init()   /* Find all tables in firmware and install them 
 |                                    into acpi_gbl_root_table_list. No override. */
 |
 |->acpi_initrd_override()         /* Find all tables specified by users in initrd,
 |                                    and store them in acpi_tables_addr array. */
 |......
 |->acpi_boot_table_init()         /* Check acpi_tables_addr, if any table needs to 
                                      be overrided, override it. */


Tang Chen (5):
  x86, acpi: Call two new functions instead of acpi_initialize_tables()
    in acpi_table_init().
  x86, acpi: Split acpi_table_init() into two parts.
  x86, acpi: Rename check_multiple_madt() and make it global.
  x86, acpi: Split acpi_boot_table_init() into two parts.
  x86, acpi: Initialize acpi golbal root table list earlier.

 arch/x86/kernel/acpi/boot.c |   32 ++++++++++++++++++++------------
 arch/x86/kernel/setup.c     |    8 +++++++-
 drivers/acpi/tables.c       |   29 +++++++++++++++++++++++------
 include/acpi/acpixf.h       |    4 ++++
 include/linux/acpi.h        |    4 ++++
 5 files changed, 58 insertions(+), 19 deletions(-)

