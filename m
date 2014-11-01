Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886AbaKAT3D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 15:29:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33232 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbaKAT3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 15:29:01 -0400
Date: Sat, 1 Nov 2014 12:28:32 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-4750a0d112cbfcc744929f1530ffe3193436766c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, konrad.wilk@oracle.com, mingo@kernel.org,
        bp@suse.de, tglx@linutronix.de, hpa@zytor.com
Reply-To: hpa@zytor.com, tglx@linutronix.de, bp@suse.de,
        konrad.wilk@oracle.com, mingo@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20141101100100.GA4462@pd.tnic>
References: <20141101100100.GA4462@pd.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode, AMD:
  Fix early ucode loading on 32-bit
Git-Commit-ID: 4750a0d112cbfcc744929f1530ffe3193436766c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4750a0d112cbfcc744929f1530ffe3193436766c
Gitweb:     http://git.kernel.org/tip/4750a0d112cbfcc744929f1530ffe3193436766c
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Fri, 31 Oct 2014 23:23:43 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 1 Nov 2014 20:24:21 +0100

x86, microcode, AMD: Fix early ucode loading on 32-bit

Konrad triggered the following splat below in a 32-bit guest on an AMD
box. As it turns out, in save_microcode_in_initrd_amd() we're using the
*physical* address of the container *after* we have enabled paging and
thus we #PF in load_microcode_amd() when trying to access the microcode
container in the ramdisk range.

Because the ramdisk is exactly there:

[    0.000000] RAMDISK: [mem 0x35e04000-0x36ef9fff]

and we fault at 0x35e04304.

And since this guest doesn't relocate the ramdisk, we don't do the
computation which will give us the correct virtual address and we end up
with the PA.

So, we should actually be using virtual addresses on 32-bit too by the
time we're freeing the initrd. Do that then!

Unpacking initramfs...
BUG: unable to handle kernel paging request at 35d4e304
IP: [<c042e905>] load_microcode_amd+0x25/0x4a0
*pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.1-302.fc21.i686 #1
Hardware name: Xen HVM domU, BIOS 4.4.1 10/01/2014
task: f5098000 ti: f50d0000 task.ti: f50d0000
EIP: 0060:[<c042e905>] EFLAGS: 00010246 CPU: 0
EIP is at load_microcode_amd+0x25/0x4a0
EAX: 00000000 EBX: f6e9ec4c ECX: 00001ec4 EDX: 00000000
ESI: f5d4e000 EDI: 35d4e2fc EBP: f50d1ed0 ESP: f50d1e94
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 35d4e304 CR3: 00e33000 CR4: 000406d0
Stack:
 00000000 00000000 f50d1ebc f50d1ec4 f5d4e000 c0d7735a f50d1ed0 15a3d17f
 f50d1ec4 00600f20 00001ec4 bfb83203 f6e9ec4c f5d4e000 c0d7735a f50d1ed8
 c0d80861 f50d1ee0 c0d80429 f50d1ef0 c0d889a9 f5d4e000 c0000000 f50d1f04
Call Trace:
? unpack_to_rootfs
? unpack_to_rootfs
save_microcode_in_initrd_amd
save_microcode_in_initrd
free_initrd_mem
populate_rootfs
? unpack_to_rootfs
do_one_initcall
? unpack_to_rootfs
? repair_env_string
? proc_mkdir
kernel_init_freeable
kernel_init
ret_from_kernel_thread
? rest_init

Reported-and-tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: https://bugzilla.redhat.com/show_bug.cgi?id=1158204
Fixes: 75a1ba5b2c52 ("x86, microcode, AMD: Unify valid container checks")
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org> # v3.14+
Link: http://lkml.kernel.org/r/20141101100100.GA4462@pd.tnic
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/microcode/amd_early.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 7aa1acc..8b75f70 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -348,6 +348,7 @@ int __init save_microcode_in_initrd_amd(void)
 {
 	unsigned long cont;
 	enum ucode_state ret;
+	u8 *cont_va;
 	u32 eax;
 
 	if (!container)
@@ -355,13 +356,15 @@ int __init save_microcode_in_initrd_amd(void)
 
 #ifdef CONFIG_X86_32
 	get_bsp_sig();
-	cont = (unsigned long)container;
+	cont	= (unsigned long)container;
+	cont_va = __va(container);
 #else
 	/*
 	 * We need the physical address of the container for both bitness since
 	 * boot_params.hdr.ramdisk_image is a physical address.
 	 */
-	cont = __pa(container);
+	cont    = __pa(container);
+	cont_va = container;
 #endif
 
 	/*
@@ -372,6 +375,8 @@ int __init save_microcode_in_initrd_amd(void)
 	if (relocated_ramdisk)
 		container = (u8 *)(__va(relocated_ramdisk) +
 			     (cont - boot_params.hdr.ramdisk_image));
+	else
+		container = cont_va;
 
 	if (ucode_new_rev)
 		pr_info("microcode: updated early to new patch_level=0x%08x\n",
