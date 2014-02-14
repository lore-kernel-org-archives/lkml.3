Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaBNXYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 18:24:39 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:52534 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaBNXYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 18:24:38 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient workqueue
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
	<52F8A51F.4090909@cn.fujitsu.com>
	<20140210184729.GL4250@linux.vnet.ibm.com>
	<20140212182336.GD5496@localhost.localdomain>
	<20140212190241.GD4250@linux.vnet.ibm.com>
	<20140212192354.GC26809@htj.dyndns.org>
Date: Fri, 14 Feb 2014 15:24:35 -0800
In-Reply-To: <20140212192354.GC26809@htj.dyndns.org> (Tejun Heo's message of
	"Wed, 12 Feb 2014 14:23:54 -0500")
Message-ID: <7hk3cx46rw.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Wed, Feb 12, 2014 at 11:02:41AM -0800, Paul E. McKenney wrote:
>> +2.	Use the /sys/devices/virtual/workqueue/*/cpumask sysfs files
>> +	to force the WQ_SYSFS workqueues to run on the specified set
>> +	of CPUs.  The set of WQ_SYSFS workqueues can be displayed using
>> +	"ls sys/devices/virtual/workqueue".
>
> One thing to be careful about is that once published, it becomes part
> of userland visible interface.  Maybe adding some words warning
> against sprinkling WQ_SYSFS willy-nilly is a good idea?

In the NO_HZ_FULL case, it seems to me we'd always want all unbound
workqueues to have their affinity set to the housekeeping CPUs.

Is there any reason not to enable WQ_SYSFS whenever WQ_UNBOUND is set so
the affinity can be controlled?  I guess the main reason would be that 
all of these workqueue names would become permanent ABI.

At least for NO_HZ_FULL, maybe this should be automatic.  The cpumask of
unbound workqueues should default to !tick_nohz_full_mask?  Any WQ_SYSFS
workqueues could still be overridden from userspace, but at least the
default would be sane, and help keep full dyntics CPUs isolated.

Example patch below, only boot tested on 4-CPU ARM system with
CONFIG_NO_HZ_FULL_ALL=y and verified that 'cat
/sys/devices/virtual/workqueue/writeback/cpumask' looked sane.  If this
looks OK, I can maybe clean it up a bit and make it runtime check
instead of a compile time check.

Kevin



>From 902a2b58d61a51415457ea6768d687cdb7532eff Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@linaro.org>
Date: Fri, 14 Feb 2014 15:10:58 -0800
Subject: [PATCH] workqueue: for NO_HZ_FULL, set default cpumask to
 !tick_nohz_full_mask

To help in keeping NO_HZ_FULL CPUs isolated, keep unbound workqueues
from running on full dynticks CPUs.  To do this, set the default
workqueue cpumask to be the set of "housekeeping" CPUs instead of all
possible CPUs.

This is just just the starting/default cpumask, and can be overridden
with all the normal ways (NUMA settings, apply_workqueue_attrs and via
sysfs for workqueus with the WQ_SYSFS attribute.)

Cc: Tejun Heo <tj@kernel.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 kernel/workqueue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 987293d03ebc..9a9d9b0eaf6d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -48,6 +48,7 @@
 #include <linux/nodemask.h>
 #include <linux/moduleparam.h>
 #include <linux/uaccess.h>
+#include <linux/tick.h>
 
 #include "workqueue_internal.h"
 
@@ -3436,7 +3437,11 @@ struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask)
 	if (!alloc_cpumask_var(&attrs->cpumask, gfp_mask))
 		goto fail;
 
+#ifdef CONFIG_NO_HZ_FULL
+	cpumask_complement(attrs->cpumask, tick_nohz_full_mask);
+#else
 	cpumask_copy(attrs->cpumask, cpu_possible_mask);
+#endif
 	return attrs;
 fail:
 	free_workqueue_attrs(attrs);
-- 
1.8.3

