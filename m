Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaBDX0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:26:14 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:2254 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaBDX0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:26:12 -0500
From: Greg Pearson <greg.pearson@hp.com>
To: akpm@linux-foundation.org, vgoyal@redhat.com, d.hatayama@jp.fujitsu.com,
        holzheu@linux.vnet.ibm.com, dhowells@redhat.com,
        paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, greg.pearson@hp.com
Subject: [PATCH v3] vmcore: prevent PT_NOTE p_memsz overflow during header update
Date: Tue,  4 Feb 2014 16:25:52 -0700
Message-Id: <1391556352-15881-1-git-send-email-greg.pearson@hp.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, update_note_header_size_elf64() and
update_note_header_size_elf32() will add the size
of a PT_NOTE entry to real_sz even if that causes real_sz
to exceeds max_sz. This patch corrects the while loop logic
in those routines to ensure that does not happen and prints
a warning if a PT_NOTE entry is dropped. If zero PT_NOTE
entries are found or this condition is encountered because
the only entry was dropped, a warning is printed and an
error is returned.

One possible negative side effect of exceeding the max_sz
limit is an allocation failure in merge_note_headers_elf64()
or merge_note_headers_elf32() which would produce console
output such as the following while booting the crash
kernel.

vmalloc: allocation failure: 14076997632 bytes
swapper/0: page allocation failure: order:0, mode:0x80d2
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-gbp1 #7
ffffffff817dcc30 ffff88003025fc28 ffffffff815bdb0b ffff88003025fcb0
ffffffff8113b3d0 ffffffff817dcc30 ffff88003025fc48 ffffc90000000018
ffff88003025fcc0 ffff88003025fc60 ffff88003025fc80 ffff88002b5df980
Call Trace:
[<ffffffff815bdb0b>] dump_stack+0x19/0x1b
[<ffffffff8113b3d0>] warn_alloc_failed+0xf0/0x160
[<ffffffff81a1267d>] ? merge_note_headers_elf64.constprop.9+0x116/0x24a
[<ffffffff8116d34e>] __vmalloc_node_range+0x19e/0x250
[<ffffffff81210454>] ? read_from_oldmem.part.0+0xa4/0xe0
[<ffffffff8116d4ec>] vmalloc_user+0x4c/0x70
[<ffffffff81a1267d>] ? merge_note_headers_elf64.constprop.9+0x116/0x24a
[<ffffffff81a1267d>] merge_note_headers_elf64.constprop.9+0x116/0x24a
[<ffffffff81a12cce>] vmcore_init+0x2d4/0x76c
[<ffffffff8120f9f0>] ? kcore_update_ram+0x1f0/0x1f0
[<ffffffff81063b92>] ? walk_system_raange+0x112/0x130
[<ffffffff81a129fa>] ? merge_note_headers_elf32.constprop.8+0x249/0x249
[<ffffffff810020e2>] do_one_initcall+0xe2/0x190
[<ffffffff819e20c4>] kernel_init_freeable+0x17c/0x207
[<ffffffff819e18d0>] ? do_early_param+0x88/0x88
[<ffffffff815a0d20>] ? rest_init+0x80/0x80
[<ffffffff815a0d2e>] kernel_init+0xe/0x180
[<ffffffff815cd8ac>] ret_from_fork+0x7c/0xb0
[<ffffffff815a0d20>] ? rest_init+0x80/0x80

Kdump: vmcore not initialized

kdump: dump target is /dev/sda4
kdump: saving to /sysroot//var/crash/127.0.0.1-2014.01.28-13:58:52/
kdump: saving vmcore-dmesg.txt
Cannot open /proc/vmcore: No such file or directory
kdump: saving vmcore-dmesg.txt failed
kdump: saving vmcore
kdump: saving vmcore failed

This type of failure has been seen on a four socket prototype
system with certain memory configurations. Most PT_NOTE sections
have a single entry similar to:

  n_namesz = 0x5
  n_descsz = 0x150
  n_type   = 0x1

Occasionally, a second entry is encountered with very
large n_namesz and n_descsz sizes:

  n_namesz = 0x80000008
  n_descsz = 0x510ae163
  n_type   = 0x80000008

Not yet sure of the source of these extra entries, they
seem bogus, but they shouldn't cause crash dump to fail.

Signed-off-by: Greg Pearson <greg.pearson@hp.com>
---
 fs/proc/vmcore.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 2ca7ba0..88d4585 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -468,17 +468,24 @@ static int __init update_note_header_size_elf64(const Elf64_Ehdr *ehdr_ptr)
 			return rc;
 		}
 		nhdr_ptr = notes_section;
-		while (real_sz < max_sz) {
-			if (nhdr_ptr->n_namesz == 0)
-				break;
+		while (nhdr_ptr->n_namesz != 0) {
 			sz = sizeof(Elf64_Nhdr) +
 				((nhdr_ptr->n_namesz + 3) & ~3) +
 				((nhdr_ptr->n_descsz + 3) & ~3);
+			if ((real_sz + sz) > max_sz) {
+				pr_warn("Warning: Exceeded p_memsz, dropping PT_NOTE entry n_namesz=0x%x, n_descsz=0x%x\n",
+					nhdr_ptr->n_namesz, nhdr_ptr->n_descsz);
+				break;
+			}
 			real_sz += sz;
 			nhdr_ptr = (Elf64_Nhdr*)((char*)nhdr_ptr + sz);
 		}
 		kfree(notes_section);
 		phdr_ptr->p_memsz = real_sz;
+		if (real_sz == 0) {
+			pr_warn("Warning: Zero PT_NOTE entries found\n");
+			return -EINVAL;
+		}
 	}
 
 	return 0;
@@ -648,17 +655,24 @@ static int __init update_note_header_size_elf32(const Elf32_Ehdr *ehdr_ptr)
 			return rc;
 		}
 		nhdr_ptr = notes_section;
-		while (real_sz < max_sz) {
-			if (nhdr_ptr->n_namesz == 0)
-				break;
+		while (nhdr_ptr->n_namesz != 0) {
 			sz = sizeof(Elf32_Nhdr) +
 				((nhdr_ptr->n_namesz + 3) & ~3) +
 				((nhdr_ptr->n_descsz + 3) & ~3);
+			if ((real_sz + sz) > max_sz) {
+				pr_warn("Warning: Exceeded p_memsz, dropping PT_NOTE entry n_namesz=0x%x, n_descsz=0x%x\n",
+					nhdr_ptr->n_namesz, nhdr_ptr->n_descsz);
+				break;
+			}
 			real_sz += sz;
 			nhdr_ptr = (Elf32_Nhdr*)((char*)nhdr_ptr + sz);
 		}
 		kfree(notes_section);
 		phdr_ptr->p_memsz = real_sz;
+		if (real_sz == 0) {
+			pr_warn("Warning: Zero PT_NOTE entries found\n");
+			return -EINVAL;
+		}
 	}
 
 	return 0;
-- 
1.8.3.2

