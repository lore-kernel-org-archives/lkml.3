Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3LCXi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:38:58 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:55066
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630Ab3LCXix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:38:53 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 18:38:53 EST
Message-Id: <20131203233232.928771708@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:32:32 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 00/41] percpu: Consistent per cpu operations V1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel has never been audited to ensure that this_cpu operations are
consistently used throughout the kernel. The code generated in many
places can be improved through the use of this_cpu operations (which uses
a segment register for relocation of per cpu offsets instead of
performing address calculations).

The patchset also addresses various consistency issues in general with
the per cpu macros.

A. The semantics of __this_cpu_ptr() differs from this_cpu_ptr only
   because checks are skipped. This is typically shown through a raw_
   prefix. So this patchset changes the places where __this_cpu_ptr()
   is used to raw_cpu_ptr().

B. There has been the long term wish by some that __this_cpu operations
   would check for preemption. However, there are cases where preemption
   checks need to be skipped. This patchset adds raw_cpu operations that
   do not check for preemption and then adds preemption checks to the
   __this_cpu operations.

C. The use of __get_cpu_var is always a reference to a percpu variable
   that can also be handled via a this_cpu operation. This patchset
   replaces all uses of __get_cpu_var with this_cpu operations.

D. We can then use this_cpu RMW operations in various places replacing
   sequences of instructions by a single one.

E. The use of this_cpu operations throughout will allow other arches than
   x86 to implement optimized references and RMV operations to work with
   per cpu local data.

F. The use of this_cpu operations opens up the possibility to
   further optimize code that relies on synchronization through
   per cpu data.


The patchset works in a couple of stages:

I. Patches 1-12 are patches that simply replace uses of __get_cpu_var
   with this_cpu_ptr. They do not depend on any changes to the percpu
   code.

II. Patch 13 adds the additional raw_cpu operations and raw_cpu_ptr().
    Patch 14 converts the existing __this_cpu_xx_# primitive in the x86
    code to raw_cpu_xx_#.

III. Patch 15-17 use the raw_cpu operations in places that would give
     us false positives once they are enabled.

IV. Patch 18 adds preemption checks to __this_cpu operations to allow
    checking if preemption is properly disabled when these functions
    are used.

V. Patches 19-39 are conversion patches that use this_cpu operations
   in various kernel subsystems/drivers or arch code.

VI. Patches 41/42 remove no longer used functions (__this_cpu_ptr
    and __get_cpu_var).  These should only be applied after all the
    conversion patches have made it and after we have done additonal
    passes through the kernel to ensure that none of the uses of these
    functions remain.

