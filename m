Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaBLTUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:20:19 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55144 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaBLTUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:20:17 -0500
Date: Wed, 12 Feb 2014 11:02:41 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kevin Hilman <khilman@linaro.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
Message-ID: <20140212190241.GD4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
 <52F8A51F.4090909@cn.fujitsu.com>
 <20140210184729.GL4250@linux.vnet.ibm.com>
 <20140212182336.GD5496@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212182336.GD5496@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021219-0928-0000-0000-000006449F2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 07:23:38PM +0100, Frederic Weisbecker wrote:
> On Mon, Feb 10, 2014 at 10:47:29AM -0800, Paul E. McKenney wrote:
> > On Mon, Feb 10, 2014 at 06:08:31PM +0800, Lai Jiangshan wrote:
> > > Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > Thank you all, queued for 3.15.
> > 
> > We should also have some facility for moving the SRCU workqueues to
> > housekeeping/timekeeping kthreads in the NO_HZ_FULL case.  Or does
> > this patch already have that effect?
> 
> Kevin Hilman and me plan to try to bring a new Kconfig option that could let
> us control the unbound workqueues affinity through sysfs.

Please CC me or feel free to update Documentation/kernel-per-CPU-kthreads.txt
as part of this upcoming series.

> The feature actually exist currently but is only enabled for workqueues that
> have WQ_SYSFS. Writeback and raid5 are the only current users.
> 
> See for example: /sys/devices/virtual/workqueue/writeback/cpumask

Ah, news to me!  I have queued the following patch, seem reasonable?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
index 827104fb9364..09f28841ee3e 100644
--- a/Documentation/kernel-per-CPU-kthreads.txt
+++ b/Documentation/kernel-per-CPU-kthreads.txt
@@ -162,7 +162,11 @@ Purpose: Execute workqueue requests
 To reduce its OS jitter, do any of the following:
 1.	Run your workload at a real-time priority, which will allow
 	preempting the kworker daemons.
-2.	Do any of the following needed to avoid jitter that your
+2.	Use the /sys/devices/virtual/workqueue/*/cpumask sysfs files
+	to force the WQ_SYSFS workqueues to run on the specified set
+	of CPUs.  The set of WQ_SYSFS workqueues can be displayed using
+	"ls sys/devices/virtual/workqueue".
+3.	Do any of the following needed to avoid jitter that your
 	application cannot tolerate:
 	a.	Build your kernel with CONFIG_SLUB=y rather than
 		CONFIG_SLAB=y, thus avoiding the slab allocator's periodic

