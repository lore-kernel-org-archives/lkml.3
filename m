Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaAQPSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:18:50 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:39144
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591AbaAQPSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:18:38 -0500
Message-Id: <20140117151812.770437629@linux.com>
Date: Fri, 17 Jan 2014 09:18:12 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 00/41] percpu: Consistent per cpu operations V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2->V3:
- Rediff patches
- Fix breakage caused by mips patches. Add a mips patch to convert from local_t.
- Update some descriptions.

V1->V2:
- Move legacy definition for __this_cpu_ptr into include/asm-generic/percpu.h
  so that users bypassing include/linux/percpu.h do not break (affects
  tile and s390)
- Merge raw_cpu_ops core and the patch to rename x86 __this_cpu primitives
  into one. Otherwise breakage will occur since x86 __this_cpu ops will fall
  back to generic ops which is not tolerated well by the preempt hackery
  in x86.
- Add notes to each patch that depends on another to avoid mismerges.
  Add acks etc.
- Use quilt-0.61 with the bug fix that ensures all mailing lists
  receive the postings intended for them.


The kernel has never been audited to ensure that this_cpu operations are
consistently used throughout the kernel. The code generated in many
places can be improved through the use of this_cpu operations (which uses
a segment register for relocation of per cpu offsets instead of
performing address calculations).

The patch set also addresses various consistency issues in general with
the per cpu macros.

A. The semantics of __this_cpu_ptr() differs from this_cpu_ptr only
   because checks are skipped. This is typically shown through a raw_
   prefix. So this patch set changes the places where __this_cpu_ptr()
   is used to raw_cpu_ptr().

B. There has been the long term wish by some that __this_cpu operations
   would check for preemption. However, there are cases where preemption
   checks need to be skipped. This patch set adds raw_cpu operations that
   do not check for preemption and then adds preemption checks to the
   __this_cpu operations.

C. The use of __get_cpu_var is always a reference to a percpu variable
   that can also be handled via a this_cpu operation. This patch set
   replaces all uses of __get_cpu_var with this_cpu operations.

D. We can then use this_cpu RMW operations in various places replacing
   sequences of instructions by a single one.

E. The use of this_cpu operations throughout will allow other arches than
   x86 to implement optimized references and RMV operations to work with
   per cpu local data.

F. The use of this_cpu operations opens up the possibility to
   further optimize code that relies on synchronization through
   per cpu data.


The patch set works in a couple of stages:

I. Patches 1-13 are patches that simply replace uses of __get_cpu_var
   with this_cpu_ptr. They do not depend on any changes to the percpu
   code. No preemption tests are skipped if they are applied.

II. Patch 14 adds the additional raw_cpu operations and raw_cpu_ptr().
    Also converts the existing __this_cpu_xx_# primitive in the x86
    code to raw_cpu_xx_#.

III. Patch 15-17 use the raw_cpu operations in places that would give
     us false positives once they are enabled.

IV. Patch 18 adds preemption checks to __this_cpu operations to allow
    checking if preemption is properly disabled when these functions
    are used.

V. Patches 19-39 are conversion patches that use this_cpu operations
   in various kernel subsystems/drivers or arch code.

VI. Patches 40/41 remove no longer used functions (__this_cpu_ptr
    and __get_cpu_var).  These should only be applied after all the
    conversion patches have made it and after we have done additional
    passes through the kernel to ensure that none of the uses of these
    functions remain.

