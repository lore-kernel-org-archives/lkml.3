Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaC3NBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 09:01:45 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38782 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaC3NBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 09:01:43 -0400
Date: Sun, 30 Mar 2014 09:01:39 -0400
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/4] workqueue: Add anon workqueue sysfs hierarchy
Message-ID: <20140330130139.GD8942@htj.dyndns.org>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
 <1395940862-31428-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395940862-31428-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 06:21:01PM +0100, Frederic Weisbecker wrote:
> We call "anon workqueues" the set of unbound workqueues that don't
> carry the WQ_SYSFS flag.
> 
> They are a problem nowadays because people who work on CPU isolation
> (HPC, Real time, etc...) want to be able to migrate all the unbound
> workqueues away to a single housekeeping CPU. This control is possible
> through sysfs but only with WQ_SYSFS workqueues.
> 
> Now we need to deal with the other unbound workqueues. There is two
> possible solutions:
> 
> 1) Implement a sysfs directory for each unbound !WQ_SYSFS. This could
> be done with a specific Kconfig to make sure that these workqueue
> won't be considered as a stable ABI. But we all know that all distros
> will enable this Kconfig symbol and that a warning in the Kconfig help
> text won't protect against anything.
> 
> 2) Implement a single sysfs directory containing only the cpumask file
> to the control the affinity of all the !WQ_SYSFS workqueues.
> 
> This patch implements the second solution but only for non-ordered
> unbound workqueues. Ordered workqueues need a special treatment and
> will be handled in a subsequent patch.

I'm not really sure this is the good approach.  I think I wrote this
way back but wouldn't it make more sense to allow userland to restrict
the cpus which are allowed to all unbound cpus.  As currently
implemented, setting WQ_SYSFS to give userland more control would
escape that workqueue from this global mask as a side effect, which is
a surprising behavior and doesn't make much sense to me.  I think it
would make far more sense to implement a knob which controls which
cpus are available to *all* unbound workqueue including the default
fallback one.  That way it's way more consistent and I'm pretty sure
the code would be fairly simple too.  All it needs to do is
restricting the online cpus that unbound workqueues see.

Thanks.

-- 
tejun
