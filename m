Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3AaKIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:08:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:37758 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab3AaKIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:08:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,575,1355126400"; 
   d="scan'208";a="280767690"
Date: Thu, 31 Jan 2013 18:09:27 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] rwsem-spinlock: let rwsem write lock stealable
Message-ID: <20130131100927.GY12678@yliu-dev.sh.intel.com>
References: <1359537244-20588-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20130131093931.GA398@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131093931.GA398@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 10:39:31AM +0100, Ingo Molnar wrote:
> 
> * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> 
> > We(Linux Kernel Performance project) found a regression introduced by
> > commit 5a50508, which just convert all mutex lock to rwsem write lock.
> > The semantics is same, but the results is quite huge in some cases.
> > After investigation, we found the root cause: mutex support lock
> > stealing. Here is the link for the detailed regression report:
> >     https://lkml.org/lkml/2013/1/29/84
> > 
> > Ingo suggests to add write lock stealing to rwsem as well:
> >     "I think we should allow lock-steal between rwsem writers - that
> >      will not hurt fairness as most rwsem fairness concerns relate to
> >      reader vs. writer fairness"
> > 
> > I then tried it with rwsem-spinlock first as I found it much easier to
> > implement it than lib/rwsem.c. And here I sent out this patch first for
> > comments. I'd try lib/rwsem.c later once the change to rwsem-spinlock
> > is OK to you guys.
> > 
> > With this patch, we got a double performance increase in one test box
> > with following aim7 workfile:
> >     FILESIZE: 1M
> >     POOLSIZE: 10M
> >     10 fork_test
> > 
> > some /usr/bin/time output w/o patch      some /usr/bin/time_output with patch
> > ----------------------------------------------------------------------------
> > Percent of CPU this job got: 369%        Percent of CPU this job got: 537%
> > Voluntary context switches: 640595016    Voluntary context switches: 157915561
> > ----------------------------------------------------------------------------
> > You will see we got a 45% increase of CPU usage and saves about 3/4
> > voluntary context switches.
> > 
> > 
> > Here is the .nr_running filed for all CPUs from /proc/sched_debug.
> > 
> > output w/o this patch:
> > ----------------------
> > cpu 00:   0   0   ...   0   0   0   0   0   0   0   1   0   1 .... 0   0
> > cpu 01:   0   0   ...   1   0   0   0   0   0   1   1   0   1 .... 0   0
> > cpu 02:   0   0   ...   1   1   0   0   0   1   0   0   1   0 .... 1   1
> > cpu 03:   0   0   ...   0   1   0   0   0   1   1   0   1   1 .... 0   0
> > cpu 04:   0   1   ...   0   0   2   1   1   2   1   0   1   0 .... 1   0
> > cpu 05:   0   1   ...   0   0   2   1   1   2   1   1   1   1 .... 0   0
> > cpu 06:   0   0   ...   2   0   0   1   0   0   1   0   0   0 .... 0   0
> > cpu 07:   0   0   ...   2   0   0   0   1   0   1   1   0   0 .... 1   0
> > cpu 08:   0   0   ...   1   0   0   0   1   0   0   1   0   0 .... 0   1
> > cpu 09:   0   0   ...   1   0   0   0   1   0   0   1   0   0 .... 0   1
> > cpu 10:   0   0   ...   0   0   0   2   0   0   1   0   1   1 .... 1   2
> > cpu 11:   0   0   ...   0   0   0   2   2   0   1   0   1   0 .... 1   2
> > cpu 12:   0   0   ...   2   0   0   0   1   1   3   1   1   1 .... 1   0
> > cpu 13:   0   0   ...   2   0   0   0   1   1   3   1   1   0 .... 1   1
> > cpu 14:   0   0   ...   0   0   0   2   0   0   1   1   0   0 .... 1   0
> > cpu 15:   0   0   ...   1   0   0   2   0   0   1   1   0   0 .... 0   0
> > 
> > output with this patch:
> > -----------------------
> > cpu 00:   0   0   ...   1   1   2   1   1   1   2   1   1   1 .... 1   3
> > cpu 01:   0   0   ...   1   1   1   1   1   1   2   1   1   1 .... 1   3
> > cpu 02:   0   0   ...   2   2   3   2   0   2   1   2   1   1 .... 1   1
> > cpu 03:   0   0   ...   2   2   3   2   1   2   1   2   1   1 .... 1   1
> > cpu 04:   0   1   ...   2   0   0   1   0   1   3   1   1   1 .... 1   1
> > cpu 05:   0   1   ...   2   0   1   1   0   1   2   1   1   1 .... 1   1
> > cpu 06:   0   0   ...   2   1   1   2   0   1   2   1   1   1 .... 2   1
> > cpu 07:   0   0   ...   2   1   1   2   0   1   2   1   1   1 .... 2   1
> > cpu 08:   0   0   ...   1   1   1   1   1   1   1   1   1   1 .... 0   0
> > cpu 09:   0   0   ...   1   1   1   1   1   1   1   1   1   1 .... 0   0
> > cpu 10:   0   0   ...   1   1   1   0   0   1   1   1   1   1 .... 0   0
> > cpu 11:   0   0   ...   1   1   1   0   0   1   1   1   1   2 .... 1   0
> > cpu 12:   0   0   ...   1   1   1   0   1   1   0   0   0   1 .... 2   1
> > cpu 13:   0   0   ...   1   1   1   0   1   1   1   0   1   2 .... 2   0
> > cpu 14:   0   0   ...   2   0   0   0   0   1   1   1   1   1 .... 2   2
> > cpu 15:   0   0   ...   2   0   0   1   0   1   1   1   1   1 .... 2   2
> > ------------------------------------------------------------------------
> > Where you can see that CPU is much busier with this patch.
> 
> That looks really good - quite similar to how it behaved with 
> mutexes, right?

Yes :)

And the result is almost same with mutex lock when MUTEX_SPIN_ON_OWNER
is disabled, and that's the reason you will see massive processes(about
100) queued on each CPU in my last report:
    https://lkml.org/lkml/2013/1/29/84

> 
> Does this recover most of the performance regression?

Yes, there is only a 10% gap here then. I guess that's because I used
the general rwsem lock implementation(lib/rwsem-spinlock.c), but not the
XADD one(lib/rwsem.c). I guess the gap may be a little smaller if we do
the same thing to lib/rwsem.c.


Thanks.

	--yliu
