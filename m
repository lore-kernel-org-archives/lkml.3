Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbaAHMwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:52:31 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:12969 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755200AbaAHMw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:52:28 -0500
Date: Wed, 8 Jan 2014 12:52:28 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "amit.kucheria@linaro.org" <amit.kucheria@linaro.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [RFC] sched: CPU topology try
Message-ID: <20140108125228.GJ2936@e103034-lin>
References: <52B87149.4010801@arm.com>
 <CAKfTPtDmb1fa8PUcrqEGaoQLxoPBddu-Yn_oS8KwsCJJWJzQug@mail.gmail.com>
 <20140106163123.GN31570@twins.programming.kicks-ass.net>
 <CAKfTPtDind8HGJwu0odSnNdRpaxp3VB3JWw3eADAp4bL4Ex-Mw@mail.gmail.com>
 <20140107132220.GZ31570@twins.programming.kicks-ass.net>
 <20140107141059.GY3694@twins.programming.kicks-ass.net>
 <20140107154154.GH2936@e103034-lin>
 <20140107204951.GD2480@laptop.programming.kicks-ass.net>
 <52CD0D12.6020108@linaro.org>
 <20140108083716.GA7572@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108083716.GA7572@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 08:37:16AM +0000, Peter Zijlstra wrote:
> On Wed, Jan 08, 2014 at 04:32:18PM +0800, Alex Shi wrote:
> > In my old power aware scheduling patchset, I had tried the 95 to 99. But
> > all those values will lead imbalance when we test while(1) like cases.
> > like in a 24LCPUs groups, 24*5% > 1. So, finally use 100% as overload
> > indicator. And in testing 100% works well to find overload since few
> > system service involved. :)
> 
> Ah indeed, so 100% it is ;-)

If I remember correctly, Alex used the rq runnable_avg_sum (in rq->avg)
for this. It is the most obvious choice, but it takes ages to reach
100%.

#define LOAD_AVG_MAX_N 345

Worst case it takes 345 ms from the system is becomes fully utilized
after a long period of idle until the rq runnable_avg_sum reaches 100%.

An unweigthed version of cfs_rq->runnable_load_avg and blocked_load_avg
wouldn't have that delay.

Also, if we are changing the load balance behavior when all cpus are
fully utilized we may need to think about cases where the load is
hovering around the saturation threshold. But I don't think that is
important yet.
