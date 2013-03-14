Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab3CNK5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:57:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51849 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab3CNKhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 31/88] xen/pat: Disable PAT using pat_enabled value.
Date: Thu, 14 Mar 2013 10:35:24 +0000
Message-Id: <1363257381-15900-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit c79c49826270b8b0061b2fca840fc3f013c8a78a upstream.

The git commit 8eaffa67b43e99ae581622c5133e20b0f48bcef1
(xen/pat: Disable PAT support for now) explains in details why
we want to disable PAT for right now. However that
change was not enough and we should have also disabled
the pat_enabled value. Otherwise we end up with:

mmap-example:3481 map pfn expected mapping type write-back for
[mem 0x00010000-0x00010fff], got uncached-minus
 ------------[ cut here ]------------
WARNING: at /build/buildd/linux-3.8.0/arch/x86/mm/pat.c:774 untrack_pfn+0xb8/0xd0()
mem 0x00010000-0x00010fff], got uncached-minus
------------[ cut here ]------------
WARNING: at /build/buildd/linux-3.8.0/arch/x86/mm/pat.c:774
untrack_pfn+0xb8/0xd0()
...
Pid: 3481, comm: mmap-example Tainted: GF 3.8.0-6-generic #13-Ubuntu
Call Trace:
 [<ffffffff8105879f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810587fa>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8104bcc8>] untrack_pfn+0xb8/0xd0
 [<ffffffff81156c1c>] unmap_single_vma+0xac/0x100
 [<ffffffff81157459>] unmap_vmas+0x49/0x90
 [<ffffffff8115f808>] exit_mmap+0x98/0x170
 [<ffffffff810559a4>] mmput+0x64/0x100
 [<ffffffff810560f5>] dup_mm+0x445/0x660
 [<ffffffff81056d9f>] copy_process.part.22+0xa5f/0x1510
 [<ffffffff81057931>] do_fork+0x91/0x350
 [<ffffffff81057c76>] sys_clone+0x16/0x20
 [<ffffffff816ccbf9>] stub_clone+0x69/0x90
 [<ffffffff816cc89d>] ? system_call_fastpath+0x1a/0x1f
---[ end trace 4918cdd0a4c9fea4 ]---

(a similar message shows up if you end up launching 'mcelog')

The call chain is (as analyzed by Liu, Jinsong):
do_fork
  --> copy_process
    --> dup_mm
      --> dup_mmap
       	--> copy_page_range
          --> track_pfn_copy
            --> reserve_pfn_range
              --> line 624: flags != want_flags
It comes from different memory types of page table (_PAGE_CACHE_WB) and MTRR
(_PAGE_CACHE_UC_MINUS).

Stefan Bader dug in this deep and found out that:
"That makes it clearer as this will do

reserve_memtype(...)
--> pat_x_mtrr_type
  --> mtrr_type_lookup
    --> __mtrr_type_lookup

And that can return -1/0xff in case of MTRR not being enabled/initialized. Which
is not the case (given there are no messages for it in dmesg). This is not equal
to MTRR_TYPE_WRBACK and thus becomes _PAGE_CACHE_UC_MINUS.

It looks like the problem starts early in reserve_memtype:

       	if (!pat_enabled) {
                /* This is identical to page table setting without PAT */
                if (new_type) {
                        if (req_type == _PAGE_CACHE_WC)
                                *new_type = _PAGE_CACHE_UC_MINUS;
                        else
                               	*new_type = req_type & _PAGE_CACHE_MASK;
               	}
                return 0;
        }

This would be what we want, that is clearing the PWT and PCD flags from the
supported flags - if pat_enabled is disabled."

This patch does that - disabling PAT.

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reported-and-Tested-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/xen/enlighten.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c1656e0..18b55fa 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -65,6 +65,7 @@
 #include <asm/hypervisor.h>
 #include <asm/mwait.h>
 #include <asm/pci_x86.h>
+#include <asm/pat.h>
 
 #ifdef CONFIG_ACPI
 #include <linux/acpi.h>
@@ -1368,6 +1369,14 @@ asmlinkage void __init xen_start_kernel(void)
 
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
+#ifdef CONFIG_X86_PAT
+	/*
+	 * For right now disable the PAT. We should remove this once
+	 * git commit 8eaffa67b43e99ae581622c5133e20b0f48bcef1
+	 * (xen/pat: Disable PAT support for now) is reverted.
+	 */
+	pat_enabled = 0;
+#endif
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
-- 
1.8.1.2

