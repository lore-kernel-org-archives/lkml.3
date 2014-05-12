Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbaELQZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:25:51 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:44002 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbaELQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:25:50 -0400
Date: Mon, 12 May 2014 11:25:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org
Subject: Re: vmstat: On demand vmstat workers V4
In-Reply-To: <20140508142903.c2ef166c95d2b8acd0d7ea7d@linux-foundation.org>
Message-ID: <alpine.DEB.2.10.1405121120081.17673@gentwo.org>
References: <alpine.DEB.2.10.1405081033090.23786@gentwo.org> <20140508142903.c2ef166c95d2b8acd0d7ea7d@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Andrew Morton wrote:

> Some explanation of the changes to kernel/time/tick-common.c would be
> appropriate.

I dropped those after the discussion related to housekeepig cpus.

> > +		cancel_delayed_work_sync(d);
> > +		cpumask_set_cpu(smp_processor_id(), monitored_cpus);
> > +		cpumask_clear_cpu(s, monitored_cpus);
> > +		INIT_DELAYED_WORK(d, vmstat_shepherd);
>
> INIT_DELAYED_WORK() seems inappropriate here.  It's generally used for
> once-off initialisation of a freshly allocated work item.  Look at all
> the stuff it does - do we really want to run debug_object_init()
> against an active object?

Well this function is the one off initialization. INIT_DEFERRABLE_WORK in
vmstat_shepherd() is a case of repeatedly initializing the per cpu
structure when the worker thread is started again. In order to remove
that I would have to do a loop initializing the structures at startup
time. In V4 there were different function depending on the processor
and they could change. With the housekeeping processor fixed that is no
longer the case. Should I loop over the whole structure and set the
functions at init time?

> >  	case CPU_DOWN_PREPARE_FROZEN:
> > -		cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
> > +		if (!cpumask_test_cpu(cpu, monitored_cpus))
>
> This test is inverted isn't it?

If the monitoring cpu bit is not set then the worker thread is active
and needs to be cancelled. There is a race here so I used test_and_clear
here in the new revision.
