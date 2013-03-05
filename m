Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3CEJf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:35:56 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:6755 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab3CEJfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:35:53 -0500
Message-ID: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH v2 0/4] ipc: reduce ipc lock contention
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 05 Mar 2013 01:35:49 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following set of patches are based on the discussion of holding the 
ipc lock unnecessarily, such as for permissions and security checks:

https://lkml.org/lkml/2013/2/28/540

Patch 1/4: Remove the bogus comment from ipc_checkid() requiring that
the ipc lock be held before calling it. Also simplify the function
return. This is a new patch, not present in the RFC.

Patch 2/4: Introduce functions to obtain the ipc object without holding
the lock. Two functions, ipc_obtain_object() and
ipc_obtained_object_check() are created, which are analogous to
ipc_lock() and ipc_lock_check(). This patch was acked by Michel
Lespinasse and reviewed by Chegu Vinod.

Patch 3/4: Introduce ipcctl_pre_down_nolock() function, which is a
lockless version of ipcctl_pre_down(). This function is common to sem,
msg and shm and does some common checking for IPC_RMID and IPC_SET
commands. The older version was kept but calls the lockless version
without breaking the semantics, and is hence transparent to users. This
was suggested by Linus. Once all users are updated, the
ipcctl_pre_down() function can be removed.

Patch 4/4: Use the new, lockless, functions introduced above to only
hold the ipc lock when necessary. The idea is simple: only check ipc
security and permissions within the rcu read region, *without* holding
the ipc lock. This patch was acked by Michel Lespinasse and reviewed by
Chegu Vinod.

Changes since v1 (RFC):
- Add patches 1 and 3.

- Patch 2: In ipc_lock(), instead of checking the return of
ipc_obtain_object_check() against NULL, use IS_ERR(). Suggested by
Michel Lespinasse.

- Patch 2,4: In order for the rcu read lock/unlock calls to be paired up
more obviously, force the user to call rcu_read_unlock *before* calling
ipc_obtain_object[_check](). Suggested by Michel Lespinasse.

- Patch 4: Return ERR_CAST() in sem_obtain_object[_check]() instead of a
cast to struct sem_array *. Suggested by Linus.

- Patch 4: Change open coded spin_lock calls to ipc_object_lock in
semaphore code. Suggested by Linus.

- Patch 4: Added a 'out_wakup' label to semctl_main() and semtimedop()
to return from the functions without having to call sem_unlock (and
hence spin_unlock) without having the lock held.

- More tests: For the past few days I've been running this patchset on
my own laptop, and a 2 and 8 socket machines running my Oracle
swinbbench workloads. I have not encountered any issues so far. The main
fix was suggested by Linus with the bogus ipcctl_pre_down() changes
without updating the callers.

Ok, some numbers...

1) With Rik's semop-multi.c microbenchmark we can see the following
results:

Baseline (3.9-rc1):
cpus 4, threads: 256, semaphores: 128, test duration: 30 secs
total operations: 151452270, ops/sec 5048409

+  59.40%            a.out  [kernel.kallsyms]  [k] _raw_spin_lock
+   6.14%            a.out  [kernel.kallsyms]  [k] sys_semtimedop
+   3.84%            a.out  [kernel.kallsyms]  [k] avc_has_perm_flags
+   3.64%            a.out  [kernel.kallsyms]  [k] __audit_syscall_exit
+   2.06%            a.out  [kernel.kallsyms]  [k] copy_user_enhanced_fast_string
+   1.86%            a.out  [kernel.kallsyms]  [k] ipc_lock

With this patchset:
cpus 4, threads: 256, semaphores: 128, test duration: 30 secs
total operations: 273156400, ops/sec 9105213

+  18.54%            a.out  [kernel.kallsyms]  [k] _raw_spin_lock
+  11.72%            a.out  [kernel.kallsyms]  [k] sys_semtimedop
+   7.70%            a.out  [kernel.kallsyms]  [k] ipc_has_perm.isra.21
+   6.58%            a.out  [kernel.kallsyms]  [k] avc_has_perm_flags
+   6.54%            a.out  [kernel.kallsyms]  [k] __audit_syscall_exit
+   4.71%            a.out  [kernel.kallsyms]  [k] ipc_obtain_object_check


2) While on an Oracle swingbench DSS (data mining) workload the
improvements are not as exciting as with Rik's benchmark, we can see
some positive numbers. For an 8 socket machine the following are the
percentages of %sys time incurred in the ipc lock:

Baseline (3.9-rc1):
100 swingbench users: 8,74%
400 swingbench users: 21,86%
800 swingbench users: 84,35%

With this patchset:
100 swingbench users: 8,11%
400 swingbench users: 19,93%
800 swingbench users: 77,69%

Thanks,
Davidlohr




