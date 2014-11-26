Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaKZW1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:27:08 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49093 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaKZW1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:27:06 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: david.vrabel@citrix.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Davidlohr Bueso <dbueso@suse.de>, Joerg Roedel <jroedel@suse.de>,
        Borislav Petkov <bp@suse.de>, Jan Beulich <JBeulich@suse.com>,
        Juergen Gross <JGross@suse.com>, Olaf Hering <ohering@suse.de>
Subject: [PATCH] xen: privcmd: schedule() after private hypercall when non CONFIG_PREEMPT
Date: Wed, 26 Nov 2014 14:26:45 -0800
Message-Id: <1417040805-15857-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Some folks had reported that some xen hypercalls take a long time
to complete when issued from the userspace private ioctl mechanism,
this can happen for instance with some hypercalls that have many
sub-operations, this can happen for instance on hypercalls that use
multi-call feature whereby Xen lets one hypercall batch out a series
of other hypercalls on the hypervisor. At times such hypercalls can
even end up triggering the TASK_UNINTERRUPTIBLE hanger check (default
120 seconds), this a non-issue issue on preemptible kernels though as
the kernel may deschedule such long running tasks. Xen for instance
supports multicalls to be preempted as well, this is what Xen calls
continuation (see xen commit 42217cbc5b which introduced this [0]).
On systems without CONFIG_PREEMPT though -- a kernel with voluntary
or no preemption -- a long running hypercall will not be descheduled
until the hypercall is complete and the ioctl returns to user space.

To help with this David had originally implemented support for use
of preempt_schedule_irq() [1] for non CONFIG_PREEMPT kernels. This
solution never went upstream though and upon review to help refactor
this I've concluded that usage of preempt_schedule_irq() would be
a bit abussive of existing APIs -- for a few reasons:

0) we want to avoid spreading its use on non CONFIG_PREEMPT kernels

1) we want try to consider solutions that might work for other
   hypervisors for this same problem, and identify it its an issue
   even present on other hypervisors or if this is a self
   inflicted architectural issue caused by use of multicalls

2) there is no documentation or profiling of the exact hypercalls
   that were causing these issues, nor do we have any context
   to help evaluate this any further

I at least checked with kvm folks and it seems hypercall preemption
is not needed there. We can survey other hypervisors...

If 'something like preemption' is needed then CONFIG_PREEMPT
should just be enabled and encouraged, it seems we want to
encourage CONFIG_PREEMPT on xen, specially when multicalls are
used. In the meantime this tries to address a solution to help
xen on non CONFIG_PREEMPT kernels.

One option tested and evaluated was to put private hypercalls in
process context, however this would introduce complexities such
originating hypercalls from different contexts. Current xen
hypercall callback handlers would need to be changed per architecture,
for instance, we'd also incur the cost of switching states from
user / kernel (this cost is also present if preempt_schedule_irq()
is used). There may be other issues which could be introduced with
this strategy as well. The simplest *shared* alternative is instead
to just explicitly schedule() at the end of a private hypercall on non
preempt kernels. This forces our private hypercall call mechanism
to try to be fair only on non CONFIG_PREEMPT kernels at the cost of
more context switch but keeps the private hypercall context intact.

[0] http://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=42217cbc5b3e84b8c145d8cfb62dd5de0134b9e8;hp=3a0b9c57d5c9e82c55dd967c84dd06cb43c49ee9
[1] http://ftp.suse.com/pub/people/mcgrof/xen-preempt-hypercalls/0001-x86-xen-allow-privcmd-hypercalls-to-be-preempted.patch

Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Juergen Gross <JGross@suse.com>
Cc: Olaf Hering <ohering@suse.de>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/xen/privcmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 569a13b..e29edba 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -60,6 +60,9 @@ static long privcmd_ioctl_hypercall(void __user *udata)
 			   hypercall.arg[0], hypercall.arg[1],
 			   hypercall.arg[2], hypercall.arg[3],
 			   hypercall.arg[4]);
+#ifndef CONFIG_PREEMPT
+	schedule();
+#endif
 
 	return ret;
 }
-- 
2.1.1

