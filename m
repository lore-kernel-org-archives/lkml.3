Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab3CBAQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 19:16:39 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:44140 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3CBAQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 19:16:38 -0500
Message-ID: <1362183392.3420.23.camel@buesod1.americas.hpqcorp.net>
Subject: [RFC PATCH 0/2] ipc: do not hold ipc lock more than necessary
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 01 Mar 2013 16:16:32 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of not-thoroughly-tested patches are based on the
discussion of holding the ipc lock unnecessarily, such as for permissions
and security checks:

https://lkml.org/lkml/2013/2/28/540

Patch 0/1: Introduces new functions, analogous to ipc_lock and ipc_lock_check
in the ipc utility code, allowing to obtain the ipc object without holding the lock.

Patch 0/2: Use the new functions and only acquire the ipc lock when needed.

With Rik's semop-multi.c microbenchmark we can see the following
results:

256 sems without patches:
+  59.40%            a.out  [kernel.kallsyms]  [k] _raw_spin_lock
+   6.14%            a.out  [kernel.kallsyms]  [k] sys_semtimedop
+   3.84%            a.out  [kernel.kallsyms]  [k] avc_has_perm_flags
+   3.64%            a.out  [kernel.kallsyms]  [k] __audit_syscall_exit
+   2.06%            a.out  [kernel.kallsyms]  [k] copy_user_enhanced_fast_string
+   1.86%            a.out  [kernel.kallsyms]  [k] ipc_lock
+   1.75%            a.out  [kernel.kallsyms]  [k] __audit_syscall_entry
+   1.69%            a.out  [kernel.kallsyms]  [k] ipc_has_perm.isra.21
+   1.47%            a.out  [kernel.kallsyms]  [k] do_smart_update
+   1.43%            a.out  [kernel.kallsyms]  [k] pid_vnr
+   1.39%            a.out  [kernel.kallsyms]  [k] try_atomic_semop.isra.5

total operations: 151452270, ops/sec 5048409

256 sems with patches:
+  17.47%            a.out  [kernel.kallsyms]  [k] _raw_spin_lock
+  11.08%            a.out  [kernel.kallsyms]  [k] sys_semtimedop
+   8.81%            a.out  [kernel.kallsyms]  [k] avc_has_perm_flags
+   7.96%            a.out  [kernel.kallsyms]  [k] ipc_has_perm.isra.21
+   6.50%            a.out  [kernel.kallsyms]  [k] __audit_syscall_exit
+   4.67%            a.out  [kernel.kallsyms]  [k] ipc_obtain_object_check
+   4.19%            a.out  [kernel.kallsyms]  [k] ipcperms
+   3.75%            a.out  [kernel.kallsyms]  [k] copy_user_enhanced_fast_string
+   3.38%            a.out  [kernel.kallsyms]  [k] system_call
+   3.05%            a.out  [kernel.kallsyms]  [k] try_atomic_semop.isra.5
+   2.70%            a.out  [kernel.kallsyms]  [k] do_smart_update
+   2.60%            a.out  [kernel.kallsyms]  [k] __audit_syscall_entry

total operations: 266502912, ops/sec 8883430

While the _raw_spin_lock time is drastically reduced, others do increase.
This results in an overall speedup of ~1.7x regarding ops/sec.


