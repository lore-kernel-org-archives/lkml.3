Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbaE1Ixr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:53:47 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:39221 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaE1Ixo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:53:44 -0400
From: Wang Nan <wangnan0@huawei.com>
To: Russell King <linux@arm.linux.org.uk>, Simon Horman <horms@verge.net.au>,
        Will Deacon <will.deacon@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kexec@lists.infradead.org>, Geng Hui <hui.geng@huawei.com>,
        Wang Nan <wangnan0@huawei.com>
Subject: [PATCH RESEND] ARM: kdump: 2nd kernel should use strict pfn_valid in SPARSEMEM platform
Date: Wed, 28 May 2014 16:44:28 +0800
Message-ID: <1401266668-34365-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an irrational limitation for crash dump kernel on ARM
platform with SPARSEMEM enabled.

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
---

This is the third time I post this patch. The previous records can be
retrived from:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/256498.html
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/257472.html

Different from previous version, this patch select HAVE_ARCH_PFN_VALID
right after CRASH_DUMP config entry.

---

 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c57ddcb..d5ffbb1 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2160,6 +2160,7 @@ config ATAGS_PROC
 
 config CRASH_DUMP
 	bool "Build kdump crash kernel (EXPERIMENTAL)"
+	select HAVE_ARCH_PFN_VALID if SPARSEMEM
 	help
 	  Generate crash dump after being started by kexec. This should
 	  be normally only set in special crash dump kernels which are
-- 
1.8.4

