Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbaFZKRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 06:17:37 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:12999 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaFZKRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 06:17:34 -0400
From: Wang Nan <wangnan0@huawei.com>
To: <linux@arm.linux.org.uk>, <horms@verge.net.au>, <will.deacon@arm.com>
CC: <takahiro.akashi@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kexec@lists.infradead.org>,
        Wang Nan <wangnan0@huawei.com>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH] ARM: kdump: 2nd kernel should use strict pfn_valid in SPARSEMEM platform
Date: Thu, 26 Jun 2014 18:07:39 +0800
Message-ID: <1403777259-28949-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.53ABF306.0067,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: b818d9592ef59c9a283abdf44283f6fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an irrational limitation for crash dump kernel on ARM
platform when SPARSEMEM enabled.

Without this patch, crash reservation area for a crash dump kernel with
SPARSEMEM selected must occupy a full section plus 1MiB. If not,
elfcorehdr and some memory space used by the first kernel will unable to
get accessed. This is caused by pfn_valid: fast pfn_valid ragards any
pfn in a valid section as valid and prevents it to be ioremapped.

This limitation wastes memory, because sections are always large and
crash dump kernel should be as small as possible.

This patch selects HAVE_ARCH_PFN_VALID for CRASH_DUMP, makes crash dump
kernel to use strict version of pfn_valid().

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>
---

This is the forth time I post this patch. The previous discussions can be
retrived from:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/256498.html
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/257472.html
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/260322.html

The second thread discusses the limitation in detail, but non of previous
discussion reaches a conclusion.

---
 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 87b63fd..aca8ee0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1725,7 +1725,7 @@ config ARCH_SELECT_MEMORY_MODEL
 	def_bool ARCH_SPARSEMEM_ENABLE
 
 config HAVE_ARCH_PFN_VALID
-	def_bool ARCH_HAS_HOLES_MEMORYMODEL || !SPARSEMEM
+	def_bool ARCH_HAS_HOLES_MEMORYMODEL || !SPARSEMEM || CRASH_DUMP
 
 config HIGHMEM
 	bool "High Memory Support"
-- 
1.8.4

