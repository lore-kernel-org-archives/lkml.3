Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab3EWJV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:21:29 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:63470 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155Ab3EWJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:21:28 -0400
Message-ID: <519DDF8D.70700@gmail.com>
Date: Thu, 23 May 2013 11:21:17 +0200
From: Wladislav Wiebe <wladislav.kw@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>, david.daney@cavium.com,
        Maxim Uvarov <muvarov@gmail.com>, davem@davemloft.net
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] MIPS: Octeon: fix for held reboot_mutex lock at task
 exit time
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kernel halt's will reboot_mutex lock still hold at exit.
It will issue with 'halt' command:
$ halt
..
Sent SIGKILL to all processes
Requesting system halt
[66.729373] System halted.
[66.733244]
[66.734761] =====================================
[66.739473] [ BUG: lock held at task exit time! ]
[66.744188] 3.8.7-0-sampleversion-fct #49 Tainted: G           O
[66.750202] -------------------------------------
[66.754913] init/21479 is exiting with locks still held!
[66.760234] 1 lock held by init/21479:
[66.763990]  #0:  (reboot_mutex){+.+...}, at: [<ffffffff801776c8>] SyS_reboot+0xe0/0x218
[66.772165]
[66.772165] stack backtrace:
[66.776532] Call Trace:
[66.778992] [<ffffffff805780a8>] dump_stack+0x8/0x34
[66.783972] [<ffffffff801618b0>] do_exit+0x610/0xa70
[66.788948] [<ffffffff801777a8>] SyS_reboot+0x1c0/0x218
[66.794186] [<ffffffff8013d6a4>] handle_sys64+0x44/0x64

With this commit we will still have a proper halt sequence
and the reboot_mutex held bug is gone: (added printk's to affected functions)
$ halt
..
ent SIGKILL to all processes
Requesting system halt
[70.258665] DBG: kernel/sys.c, 486, SYSC_reboot: (case LINUX_REBOOT_CMD_HALT:)
[70.268953] DBG: kernel/sys.c, 396, kernel_halt: (kernel_shutdown_prepare(..);)
[70.284069] DBG: kernel/sys.c, 398, kernel_halt: (syscore_shutdown();)
[70.294364] DBG: kernel/sys.c, 400, kernel_halt: (kmsg_dump(KMSG_DUMP_HALT);)
[70.304640] System halted.
[70.307363] DBG: kernel/sys.c, 403, kernel_halt: (machine_halt();)
[70.317640] DBG: arch/mips/cavium-octeon/setup.c, 502, octeon_halt:
[70.329582] DBG: arch/mips/cavium-octeon/setup.c, 485, octeon_kill_core: (core1)
[70.329588] DBG: arch/mips/cavium-octeon/setup.c, 485, octeon_kill_core: (core2)
[70.329594] DBG: arch/mips/cavium-octeon/setup.c, 485, octeon_kill_core: (core3)
[70.329600] DBG: arch/mips/cavium-octeon/setup.c, 485, octeon_kill_core: (core4)
[70.329607] DBG: arch/mips/cavium-octeon/setup.c, 485, octeon_kill_core: (core5)
[70.329614] DBG: arch/mips/cavium-octeon/setup.c, 485, octeon_kill_core: (core6)

In this case on a 6 Core Cavium Octeon board.

Acked-by: Maxim Uvarov <muvarov@gmail.com>
Signed-off-by: Wladislav Wiebe <wladislav.kw@gmail.com>
---
 arch/mips/cavium-octeon/setup.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index b0baa29..04ce396 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -457,6 +457,10 @@ static void octeon_halt(void)
 	}

 	octeon_kill_core(NULL);
+
+	/* We stop here */
+	while (1)
+		;
 }

 /**
-- 
1.7.9.5

