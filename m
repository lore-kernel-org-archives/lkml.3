Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaKWUEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 15:04:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:35083 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaKWUEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 15:04:54 -0500
Date: Sun, 23 Nov 2014 21:04:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vikas Shivappa <vikas.shivappa@intel.com>
cc: Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tj@kernel.org, matt.flemming@intel.com, will.auld@intel.com,
        peterz@infradead.org
Subject: Re: [PATCH] x86: Intel Cache Allocation Technology support
In-Reply-To: <alpine.DEB.2.10.1411211123150.30781@vshiva-Udesk>
Message-ID: <alpine.DEB.2.11.1411232057470.6439@nanos>
References: <1416445539-24856-1-git-send-email-vikas.shivappa@linux.intel.com> <alpine.DEB.2.11.1411211224070.6439@nanos> <alpine.DEB.2.10.1411211123150.30781@vshiva-Udesk>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Vikas Shivappa wrote:
> On Fri, 21 Nov 2014, Thomas Gleixner wrote:
> > On Wed, 19 Nov 2014, Vikas Shivappa wrote:
> > > +	rdmsr(IA32_PQR_ASSOC, l, h);
> > 
> > Why on earth do we want to read an MSR on every context switch? What's
> > wrong with having
> > 
> > DEFINE_PER_CPU(u64, cacheqe_pqr);
> > 
> > 	u64 next_pqr, cur_pqr = this_cpu_read(cacheqe_pqr);
> > 
> > 	cq = task_cacheqe(task);
> > 	next_pqr = cq ? cq->pqr : 0;
> > 
> > 	if (next_pqr != cur_pqr) {
> > 	   	wrmsrl(IA32_PQR_ASSOC, next_pqr);
> 
> when cqm(cache monitoring) and cqe are both running together , cant corrupt
> the low 32 bits, the rdmsr was a fix for that.
> If there are better alternatives at low cost , certainly acceptable

Sure there are. If cache monitoring and this runs together then they
should better synchronize the cached PQR bits for the current cpu
instead of enforcing useless MSR reads into the hot path.

What you provided is certainly unacceptable.
 
> > > +/* Create a new cacheqe cgroup.*/
> > > +static struct cgroup_subsys_state *
> > > +cqe_css_alloc(struct cgroup_subsys_state *parent_css)
> > > +{
> > > +	struct cacheqe *parent = css_cacheqe(parent_css);
> > > +	struct cacheqe *cq;
> > > +
> > > +	/* This is the call before the feature is detected */
> > 
> > Huch? We know at early boot that this is available. So why do you need
> > this? The first call to this should never happen before the whole
> > thing is initialized. If it happens, it's a design failure.
> > 
> > > +	if (!parent) {
> > > +		root_cqe_group.clos = 0;
> > > +		return &root_cqe_group.css;
> > > +	}
> > > +
> > > +	/* To check if cqe is enabled.*/
> > > +	if (!cqe_genable)
> > > +		return ERR_PTR(-ENODEV);
> > 
> > So we first check for !parent and return &root_cqe_group.css and later
> > we return an error pointer? Really consistent behaviour.
> 
> this is due to how the cgroup init works.

Sorry, I can't follow that argument. Why enforces the cgroup init this
inconsistency? Why is cgroup init BEFORE we detect the feature?
 
Thanks,

	tglx
