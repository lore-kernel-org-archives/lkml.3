Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab3DLSOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:14:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab3DLSOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:14:02 -0400
Date: Fri, 12 Apr 2013 14:13:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: 3.9-rc5: Encountedred INFO: rcu_sched self-detected stall on CPU due
 to 09a9f1d27
Message-ID: <20130412181348.GA2253@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I am writing some code where I lock down a process memory at exec() time.
My patches were working fine till 3.9-rc4 and suddendly things broke down
in 3.9-rc5.

Whenever I tried to exec() a process with memory locked down, my bash
session hangs and after a while I get following warning.

login: [  174.669002] INFO: rcu_sched self-detected stall on CPU { 2}  (t=60000 jiffies g=2580 c=2579 q=1085)
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

I did a git bisect and bisection says that following is first bad
commit.

commit 09a9f1d27892255cfb9c91203f19476765e2d8d1
Author: Michel Lespinasse <walken@google.com>
Date:   Thu Mar 28 16:26:23 2013 -0700

    Revert "mm: introduce VM_POPULATE flag to better deal with racy userspace pr
    
    This reverts commit 186930500985 ("mm: introduce VM_POPULATE flag to
    better deal with racy userspace programs").

I reverted above commit and problem gets fixed.

Following is my simple patch to lock down a selected process memory.

Index: linux-2.6/fs/binfmt_elf.c
===================================================================
--- linux-2.6.orig/fs/binfmt_elf.c      2013-04-13 01:50:26.380184101
-0400
+++ linux-2.6/fs/binfmt_elf.c   2013-04-13 01:50:49.827184821 -0400
@@ -721,6 +721,10 @@ static int load_elf_binary(struct linux_

        /* OK, This is the point of no return */
        current->mm->def_flags = def_flags;
+       if (!strcmp(bprm->filename, "/sbin/kexec")) {
+               printk("Memlocking /sbin/kexec\n");
+               current->mm->def_flags |= VM_LOCKED;
+       }

        /* Do this immediately, since STACK_TOP as used in setup_arg_pages
           may depend on the personality.  */


Do you have any thoughts on what's going on. I am wondering if it indicates
a bigger problem which can then be triggered from other paths too.

Thanks
Vivek
