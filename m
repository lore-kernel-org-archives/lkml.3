Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaE1N7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:59:08 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:40345 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbaE1N7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:59:06 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <ebiederm@xmission.com>
CC: <kexec@lists.infradead.org>, <kumagai-atsushi@mxc.nes.nec.co.jp>,
        <anderson@redhat.com>, <peifeiyue@huawei.com>, <wangnan0@huawei.com>,
        <linux-kernel@vger.kernel.org>, <liusdu@126.com>,
        <hui.geng@huawei.com>, Liu Hua <sdu.liu@huawei.com>
Subject: [RESEND PATCH] kexec : add sparse memory related values to vmcore
Date: Wed, 28 May 2014 21:49:56 +0800
Message-ID: <1401284996-44873-1-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch deales with sparse memory model.

For ARM32 platforms, different vendors may define different
SECTION_SIZE_BITS, which we did not write to vmcore.

For example:

  1 arch/arm/mach-clps711x/include/mach/memory.h
    #define SECTION_SIZE_BITS 24
  2 arch/arm/mach-exynos/include/mach/memory.h
    #define SECTION_SIZE_BITS 28
  3 arch/arm/mach-sa1100/include/mach/memory.h
    #define SECTION_SIZE_BITS 27

It is really a bad news for user space tools such as
makedumpfile and crash, who have to defines them as
macros. So for the same architecture, we may need to
recomile them to parse vmcores with different
SECTION_SIZE_BITS.

And if we enable LPAE, MAX_PHYSMEM_SIZE can alse
be variable.

This patch adds these SECTION_SIZE_BITS and MAX_PHYSMEM_SIZE
to vmcore. which makes user space tools more compatible.

BTW, makedumpfile has queued the related patch.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 kernel/kexec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index bf0b929e..8b1a193 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1577,6 +1577,8 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
 	VMCOREINFO_STRUCT_SIZE(mem_section);
 	VMCOREINFO_OFFSET(mem_section, section_mem_map);
+	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
+	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
 #endif
 	VMCOREINFO_STRUCT_SIZE(page);
 	VMCOREINFO_STRUCT_SIZE(pglist_data);
-- 
1.9.0

