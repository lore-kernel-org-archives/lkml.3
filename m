Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab3ILKEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:04:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26287 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757921Ab3ILKDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:03:45 -0400
X-IronPort-AV: E=Sophos;i="4.90,890,1371052800"; 
   d="scan'208";a="8503614"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tj@kernel.org, rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de,
        mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, toshi.kani@hp.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [RESEND PATCH v2 7/9] x86, acpi, crash, kdump: Do reserve_crashkernel() after SRAT is parsed.
Date: Thu, 12 Sep 2013 17:52:15 +0800
Message-Id: <1378979537-21196-8-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378979537-21196-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1378979537-21196-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/12 17:47:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/12 18:01:06,
	Serialize complete at 2013/09/12 18:01:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory reserved for crashkernel could be large. So we should not allocate
this memory bottom up from the end of kernel image.

When SRAT is parsed, we will be able to know whihc memory is hotpluggable,
and we can avoid allocating this memory for the kernel. So reorder
reserve_crashkernel() after SRAT is parsed.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/kernel/setup.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 7372be7..fa56a57 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1130,8 +1130,6 @@ void __init setup_arch(char **cmdline_p)
 	acpi_initrd_override((void *)initrd_start, initrd_end - initrd_start);
 #endif
 
-	reserve_crashkernel();
-
 	vsmp_init();
 
 	io_delay_init();
@@ -1146,6 +1144,12 @@ void __init setup_arch(char **cmdline_p)
 	initmem_init();
 	memblock_find_dma_reserve();
 
+	/*
+	 * Reserve memory for crash kernel after SRAT is parsed so that it
+	 * won't consume hotpluggable memory.
+	 */
+	reserve_crashkernel();
+
 #ifdef CONFIG_KVM_GUEST
 	kvmclock_init();
 #endif
-- 
1.7.1

