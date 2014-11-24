Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaKXJhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:37:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:18633 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaKXJhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:37:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,447,1413270000"; 
   d="scan'208";a="627288821"
From: "Shivappa, Vikas" <vikas.shivappa@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "tj@kernel.org" <tj@kernel.org>, "Auld, Will" <will.auld@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: RE: [PATCH] x86: Intel Cache Allocation Technology support
Thread-Topic: [PATCH] x86: Intel Cache Allocation Technology support
Thread-Index: AQHQBF4nifFQ9ahEB0ySBAUEEzvqKZxrqc4A///ZDICAA6v/AIAAWf2Q
Date: Mon, 24 Nov 2014 09:36:20 +0000
Message-ID: <AE6A669FE32F67438CA1EEE4C5D6E3E092E2B31D@ORSMSX108.amr.corp.intel.com>
References: <1416445539-24856-1-git-send-email-vikas.shivappa@linux.intel.com>
 <alpine.DEB.2.11.1411211224070.6439@nanos>
 <alpine.DEB.2.10.1411211123150.30781@vshiva-Udesk>
 <alpine.DEB.2.11.1411232057470.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411232057470.6439@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Thomas Gleixner [mailto:tglx@linutronix.de] 
Sent: Sunday, November 23, 2014 12:05 PM
To: Shivappa, Vikas
Cc: Vikas Shivappa; linux-kernel@vger.kernel.org; hpa@zytor.com; mingo@kernel.org; tj@kernel.org; matt.flemming@intel.com; Auld, Will; peterz@infradead.org
Subject: Re: [PATCH] x86: Intel Cache Allocation Technology support

On Fri, 21 Nov 2014, Vikas Shivappa wrote:
> On Fri, 21 Nov 2014, Thomas Gleixner wrote:
> > On Wed, 19 Nov 2014, Vikas Shivappa wrote:
> > > +	rdmsr(IA32_PQR_ASSOC, l, h);
> > 
> > Why on earth do we want to read an MSR on every context switch? 
> > What's wrong with having
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
> when cqm(cache monitoring) and cqe are both running together , cant 
> corrupt the low 32 bits, the rdmsr was a fix for that.
> If there are better alternatives at low cost , certainly acceptable

Sure there are. If cache monitoring and this runs together then they should better synchronize the cached PQR bits for the current cpu instead of enforcing useless MSR reads into the hot path.

What you provided is certainly unacceptable.
 
> > > +/* Create a new cacheqe cgroup.*/ static struct 
> > > +cgroup_subsys_state * cqe_css_alloc(struct cgroup_subsys_state 
> > > +*parent_css) {
> > > +	struct cacheqe *parent = css_cacheqe(parent_css);
> > > +	struct cacheqe *cq;
> > > +
> > > +	/* This is the call before the feature is detected */
> > 
> > Huch? We know at early boot that this is available. So why do you 
> > need this? The first call to this should never happen before the 
> > whole thing is initialized. If it happens, it's a design failure.
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
> > So we first check for !parent and return &root_cqe_group.css and 
> > later we return an error pointer? Really consistent behaviour.
> 
> this is due to how the cgroup init works.

Sorry, I can't follow that argument. Why enforces the cgroup init this inconsistency? Why is cgroup init BEFORE we detect the feature?

Actually this can be fixed by disabling the earlyinit for the subsystem.. so the above order will be reversed meaning we first return error ptr

Thanks,
Vikas
 
Thanks,

	tglx
