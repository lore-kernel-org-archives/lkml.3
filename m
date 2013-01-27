Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3A0Pjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 10:39:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab3A0Pjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 10:39:46 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, Jianguo Wu <wujianguo@huawei.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        "Brown, Len" <len.brown@intel.com>
Subject: [PATCH] acpi, memory-hotplug: parse SRAT before memblock is ready fix
Date: Sun, 27 Jan 2013 16:38:54 +0100
Message-Id: <1359301134-421-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alnoconfig complains:
arch/x86/kernel/setup.c: In function ‘setup_arch’:
arch/x86/kernel/setup.c:917: error: implicit declaration of function ‘early_parse_srat’

because early_parse_srat is not declared for !CONFIG_ACPI. Moreover it
is defined only for CONFIG_ACPI_NUMA.

I am not sure what is the correct way to fix this but I guess that
providing an empty definition for !CONFIG_ACPI_NUMA is OK.

Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/acpi.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index b29e0aa..4c66ac0 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -83,7 +83,6 @@ int acpi_boot_init (void);
 void acpi_boot_table_init (void);
 int acpi_mps_check (void);
 int acpi_numa_init (void);
-void __init early_parse_srat(void);
 
 int acpi_table_init (void);
 int acpi_table_parse (char *id, acpi_table_handler handler);
@@ -421,6 +420,14 @@ static inline int acpi_nvs_for_each_region(int (*func)(__u64, __u64, void *),
 
 #endif	/* !CONFIG_ACPI */
 
+#ifdef CONFIG_ACPI_NUMA
+void __init early_parse_srat(void);
+#else
+static inline void early_parse_srat(void)
+{
+}
+#endif
+
 #ifdef CONFIG_ACPI
 void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
-- 
1.7.10.4

