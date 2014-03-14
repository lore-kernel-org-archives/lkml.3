Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbaCNSGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:06:11 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:59886 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbaCNSGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:06:09 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [RFC PATCH 0/3] workqueue: Control cpu affinity of !WQ_SYSFS unbound workqueues
References: <1394815131-17271-1-git-send-email-fweisbec@gmail.com>
Date: Fri, 14 Mar 2014 11:06:06 -0700
In-Reply-To: <1394815131-17271-1-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Fri, 14 Mar 2014 17:38:48 +0100")
Message-ID: <7h4n30k641.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> There are several types of workqueues. Some of them are bound to specific
> CPUs, some others are unbound and can be executed on any CPU.
>
> A tiny subset of the unbound workqueues have a sysfs representation
> in /sys/devices/virtual/workqueue/ and have a cpumask file than can
> be used to tweak their CPU affinity.
>
> But the vast majority of unbound workqueues aren't visible in sysfs.
>
> They are a problem nowaday because people who work on CPU isolation
> (HPC, Real time, etc...) want to be able to migrate all the unbound
> workqueues away from specific CPUs.
>
> There are several possible solutions to solve this:
>
> 1) Affine the !WQ_SYSFS unbound workqueues to the CPUs outside the
> full dynticks mask. Full dynticks is expected to be a component in
> many CPU isolation configurations and its CPU mapping can be a good
> way to retrieve the desired set of isolated CPUs.
>
> On the drawbacks though we can notice the lack of consistency with
> WQ_SYSFS workqueue affinity interface, issues with ordering between
> workqueue and dynticks subsystem initialization, intrusion from
> the workqueue subsystem on dynticks internals.
>
> 2) Implement a sysfs directory for each unbound !WQ_SYSFS. That sounds
> like a very nice solution as it uses existing and known interface.
> But workqueues appearing in the sysfs hierarchy are subject to become
> stable ABIs. And this is definetly not what we want.
>
> This could be worked around with a specific Kconfig to make sure that
> these workqueues won't be considered as a stable ABI. But we all know
> that all distros will enable this Kconfig symbol and that nobody
> reads, nor care about, warnings in Kconfig help text which thereby won't
> protect us against anything.
>
> 3) Implement a single sysfs directory to map properties of all !WQ_SYSFS
> unbound workqueues. It would contain only the cpumask file to control
> the affinity of all these workqueues. But more can be added later.
>
> This complexifies the code a bit although not that much compared to
> solution 2 which requires some plumbling to cope with workqueues created
> before sysfs, as reported by Mike (I played with that a bit as well, as I
> took that direction initially). But it deals with all issues previously
> described.

Since I also tinkered with (1) and (2) and ran into some of the same
issues, I think (3) is a good way.  It also doesn't tie the affinity to
full_nohz, and leaves it up to userspace which addresses a concern of
Mike's in earlier proposals as well.

Kevin
