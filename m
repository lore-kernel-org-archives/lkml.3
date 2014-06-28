Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbaF1RxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:53:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbaF1RxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Kevin Hilman <khilman@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3.15 102/139] ARM: mvebu: DT: fix OpenBlocks AX3-4 RAM size
Date: Sat, 28 Jun 2014 10:47:43 -0700
Message-Id: <20140628174610.071408891@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Cooper <jason@lakedaemon.net>

commit e47043aea3853a74a9aa5726a1faa916d7462ab7 upstream.

The OpenBlocks AX3-4 has a non-DT bootloader.  It also comes with 1GB of
soldered on RAM, and a DIMM slot for expansion.

Unfortunately, atags_to_fdt() doesn't work in big-endian mode, so we see
the following failure when attempting to boot a big-endian kernel:

  686 slab pages
  17 pages shared
  0 pages swap cached
  [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
  Kernel panic - not syncing: Out of memory and no killable processes...

  CPU: 1 PID: 351 Comm: kworker/u4:0 Not tainted 3.15.0-rc8-next-20140603 #1
  [<c0215a54>] (unwind_backtrace) from [<c021160c>] (show_stack+0x10/0x14)
  [<c021160c>] (show_stack) from [<c0802500>] (dump_stack+0x78/0x94)
  [<c0802500>] (dump_stack) from [<c0800068>] (panic+0x90/0x21c)
  [<c0800068>] (panic) from [<c02b5704>] (out_of_memory+0x320/0x340)
  [<c02b5704>] (out_of_memory) from [<c02b93a0>] (__alloc_pages_nodemask+0x874/0x930)
  [<c02b93a0>] (__alloc_pages_nodemask) from [<c02d446c>] (handle_mm_fault+0x744/0x96c)
  [<c02d446c>] (handle_mm_fault) from [<c02cf250>] (__get_user_pages+0xd0/0x4c0)
  [<c02cf250>] (__get_user_pages) from [<c02f3598>] (get_arg_page+0x54/0xbc)
  [<c02f3598>] (get_arg_page) from [<c02f3878>] (copy_strings+0x278/0x29c)
  [<c02f3878>] (copy_strings) from [<c02f38bc>] (copy_strings_kernel+0x20/0x28)
  [<c02f38bc>] (copy_strings_kernel) from [<c02f4f1c>] (do_execve+0x3a8/0x4c8)
  [<c02f4f1c>] (do_execve) from [<c025ac10>] (____call_usermodehelper+0x15c/0x194)
  [<c025ac10>] (____call_usermodehelper) from [<c020e9b8>] (ret_from_fork+0x14/0x3c)
  CPU0: stopping
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.15.0-rc8-next-20140603 #1
  [<c0215a54>] (unwind_backtrace) from [<c021160c>] (show_stack+0x10/0x14)
  [<c021160c>] (show_stack) from [<c0802500>] (dump_stack+0x78/0x94)
  [<c0802500>] (dump_stack) from [<c021429c>] (handle_IPI+0x138/0x174)
  [<c021429c>] (handle_IPI) from [<c02087f0>] (armada_370_xp_handle_irq+0xb0/0xcc)
  [<c02087f0>] (armada_370_xp_handle_irq) from [<c0212100>] (__irq_svc+0x40/0x50)
  Exception stack(0xc0b6bf68 to 0xc0b6bfb0)
  bf60:                   e9fad598 00000000 00f509a3 00000000 c0b6a000 c0b724c4
  bf80: c0b72458 c0b6a000 00000000 00000000 c0b66da0 c0b6a000 00000000 c0b6bfb0
  bfa0: c027bb94 c027bb24 60000313 ffffffff
  [<c0212100>] (__irq_svc) from [<c027bb24>] (cpu_startup_entry+0x54/0x214)
  [<c027bb24>] (cpu_startup_entry) from [<c0ac5b30>] (start_kernel+0x318/0x37c)
  [<c0ac5b30>] (start_kernel) from [<00208078>] (0x208078)
  ---[ end Kernel panic - not syncing: Out of memory and no killable processes...

A similar failure will also occur if ARM_ATAG_DTB_COMPAT isn't selected.

Fix this by setting a sane default (1 GB) in the dts file.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Tested-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
+++ b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
@@ -25,7 +25,7 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0 0x00000000 0 0xC0000000>; /* 3 GB */
+		reg = <0 0x00000000 0 0x40000000>; /* 1 GB soldered on */
 	};
 
 	soc {


