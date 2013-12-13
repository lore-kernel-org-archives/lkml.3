Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3LMIJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:09:32 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:39187 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3LMIJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:09:31 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        ulli.kroll@googlemail.com, arnd@arndb.de, olof@lixom.net,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] ARM: reinsert ARCH_MULTI_V4 Kconfig option
Date: Fri, 13 Dec 2013 09:09:09 +0100
Message-Id: <1386922149-4561-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU_FA526 lacks thumb state support and doesn't get along with some
of the options enabled by ARCH_MULTI_V4T.

More specifically it doesn't get along with CPU_ARM920T:

CPU_ABRT_EV4T
CPU_CACHE_V4WT
CPU_COPY_V4WB
CPU_TLB_V4WBI

One or a combination of the above cause trouble for userspace, the
following happens when kernel tries to exec init:

[   11.790000] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000004
[   11.790000]
[   11.790000] CPU: 0 PID: 1 Comm: init Not tainted 3.13.0-rc3-next-20131212+ #1332
[   11.790000] [<c000d620>] (unwind_backtrace) from [<c000ba54>] (show_stack+0x18/0x1c)
[   11.790000] [<c000ba54>] (show_stack) from [<c027f498>] (dump_stack+0x20/0x28)
[   11.790000] [<c027f498>] (dump_stack) from [<c027ce80>] (panic+0x98/0x1ec)
[   11.790000] [<c027ce80>] (panic) from [<c0016d4c>] (do_exit+0x80c/0x8e8)
[   11.790000] [<c0016d4c>] (do_exit) from [<c0016ea4>] (do_group_exit+0x44/0xb8)
[   11.790000] [<c0016ea4>] (do_group_exit) from [<c0022dbc>] (get_signal_to_deliver+0x2fc/0x5a4)
[   11.790000] [<c0022dbc>] (get_signal_to_deliver) from [<c027ca38>] (do_signal+0xac/0x3e0)
[   11.790000] [<c027ca38>] (do_signal) from [<c000b460>] (do_work_pending+0xcc/0xe8)
[   11.790000] [<c000b460>] (do_work_pending) from [<c0009374>] (work_pending+0xc/0x20)

Reinsert ARCH_MULTI_V4 so it can be used on platforms with CPU_FA526.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    I don't know how to handle this so I'm making it standalone for
    your feedback (it was broken out from MOXA ART SoC series).
    
    This is important for MOXA ART (and other FA526 platforms),
    please have a look.
    
    Applies to next-20131213

 arch/arm/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b64a8ef..4f88ff3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -863,6 +863,11 @@ menu "Multiple platform selection"
 
 comment "CPU Core family selection"
 
+config ARCH_MULTI_V4
+	bool "ARMv4 based platforms (FA526, StrongARM)"
+	depends on !ARCH_MULTI_V6_V7
+	select ARCH_MULTI_V4_V5
+
 config ARCH_MULTI_V4T
 	bool "ARMv4T based platforms (ARM720T, ARM920T, ...)"
 	depends on !ARCH_MULTI_V6_V7
-- 
1.8.2.1

