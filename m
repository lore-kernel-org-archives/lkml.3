Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3IJVss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab3IJVpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 01/16] mm: vm_brk(), align the length to page boundary
Date: Tue, 10 Sep 2013 17:44:16 -0400
Message-Id: <1378849471-10521-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was writing some code where I was locking all pages of a process
during exec() time by setting VM_LOCKED flag in mm->def_flags. But
that lead to errors because length of mapping is not page aligned.

login: [  174.669002] INFO: rcu_sched self-detected stall on CPU { 2}  (t=60000
jiffies g=2580 c=2579 q=1085)
[  174.669002] Pid: 4894, comm: kexec Not tainted 3.9.0-rc6+ #243
[  174.669002] Call Trace:
[  174.669002]  <IRQ>  [<ffffffff810c413a>] rcu_check_callbacks+0x21a/0x760
[  174.669002]  [<ffffffff810c7c0c>] ? acct_account_cputime+0x1c/0x20
[  174.669002]  [<ffffffff8104fd08>] update_process_times+0x48/0x80
[  174.669002]  [<ffffffff810913dd>] tick_sched_handle+0x3d/0x50
[  174.669002]  [<ffffffff810915e5>] tick_sched_timer+0x45/0x70
[  174.669002]  [<ffffffff81066951>] __run_hrtimer+0x81/0x220
[  174.669002]  [<ffffffff810915a0>] ? tick_nohz_handler+0xa0/0xa0
[  174.669002]  [<ffffffff8108ae0c>] ? ktime_get_update_offsets+0x4c/0xd0
[  174.669002]  [<ffffffff81067297>] hrtimer_interrupt+0xf7/0x250
[  174.669002]  [<ffffffff81886739>] smp_apic_timer_interrupt+0x69/0x99
[  174.669002]  [<ffffffff818859ca>] apic_timer_interrupt+0x6a/0x70
[  174.669002]  <EOI>  [<ffffffff8111e557>] ?  __mlock_vma_pages_range+0x57/0x70
[  174.669002]  [<ffffffff8111e568>] ? __mlock_vma_pages_range+0x68/0x70
[  174.669002]  [<ffffffff8111ea01>] __mm_populate+0x71/0x140
[  174.669002]  [<ffffffff81121b5f>] vm_brk+0x7f/0xa0
[  174.669002]  [<ffffffff81199633>] load_elf_binary+0x1a73/0x1b10
[  174.669002]  [<ffffffff812d25a5>] ? ima_bprm_check+0x55/0x70
[  174.669002]  [<ffffffff8114890a>] search_binary_handler+0x12a/0x3b0
[  174.669002]  [<ffffffff81197bc0>] ? load_elf_library+0x210/0x210
[  174.669002]  [<ffffffff8114aa00>] do_execve_common+0x500/0x5c0
[  174.669002]  [<ffffffff8114aaf7>] do_execve+0x37/0x40
[  174.669002]  [<ffffffff8114ad9d>] sys_execve+0x3d/0x60
[  174.669002]  [<ffffffff81885379>] stub_execve+0x69/0xa0

Thanks to Michel and Hugh Dickens that they identified that __mm_populate()
will loop forever if passed in length is not page aligned. Similar
issues related to mmap() have already been fixed. This patch fixes
vm_brk().

sys_brk() seems to be only other caller of do_brk() and sys_brk()
already aligns lenth to page boundary. So looks like page alignment
logic can be removed from do_brk().

Signed-off-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 mm/mmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index fbad7b0..3d806be 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2586,10 +2586,6 @@ static unsigned long do_brk(unsigned long addr, unsigned long len)
 	pgoff_t pgoff = addr >> PAGE_SHIFT;
 	int error;
 
-	len = PAGE_ALIGN(len);
-	if (!len)
-		return addr;
-
 	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
 
 	error = get_unmapped_area(NULL, addr, len, 0, MAP_FIXED);
@@ -2672,6 +2668,10 @@ unsigned long vm_brk(unsigned long addr, unsigned long len)
 	unsigned long ret;
 	bool populate;
 
+	len = PAGE_ALIGN(len);
+	if (!len)
+		return addr;
+
 	down_write(&mm->mmap_sem);
 	ret = do_brk(addr, len);
 	populate = ((mm->def_flags & VM_LOCKED) != 0);
-- 
1.8.3.1

