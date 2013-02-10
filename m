Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191Ab3BJUOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 15:14:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828Ab3BJUOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 15:14:48 -0500
Date: Sun, 10 Feb 2013 21:13:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        tj@kernel.org, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        rjw@sisk.pl, sbw@mit.edu, fweisbec@gmail.com, linux@arm.linux.org.uk,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 04/45] percpu_rwlock: Implement the core design of
	Per-CPU Reader-Writer Locks
Message-ID: <20130210201312.GB6236@redhat.com>
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com> <20130122073347.13822.85876.stgit@srivatsabhat.in.ibm.com> <20130208231017.GK2666@linux.vnet.ibm.com> <5117F0C0.2030605@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5117F0C0.2030605@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11, Srivatsa S. Bhat wrote:
>
> On 02/09/2013 04:40 AM, Paul E. McKenney wrote:
> >> +static void announce_writer_inactive(struct percpu_rwlock *pcpu_rwlock)
> >> +{
> >> +	unsigned int cpu;
> >> +
> >> +	drop_writer_signal(pcpu_rwlock, smp_processor_id());
> >
> > Why do we drop ourselves twice?  More to the point, why is it important to
> > drop ourselves first?
> >
>
> I don't see where we are dropping ourselves twice. Note that we are no longer
> in the cpu_online_mask, so the 'for' loop below won't include us. So we need
> to manually drop ourselves. It doesn't matter whether we drop ourselves first
> or later.

Yes, but this just reflects its usage in cpu-hotplug. cpu goes away under
_write_lock.

Perhaps _write_lock/unlock shoud use for_each_possible_cpu() instead?

Hmm... I think this makes sense anyway. Otherwise, in theory,
percpu_write_lock(random_non_hotplug_lock) can race with cpu_up?

Oleg.

