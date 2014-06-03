Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbaFCRjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:39:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:42683 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaFCRjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:39:43 -0400
Date: Tue, 3 Jun 2014 19:39:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140603173923.GF13930@laptop.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <20140603154058.GY30445@twins.programming.kicks-ass.net>
 <20140603171628.GE29593@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603171628.GE29593@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 06:16:28PM +0100, Morten Rasmussen wrote:
> > So the per-task-load-tracking stuff already does that. It updates the
> > per-cpu load metrics on migration. See {de,en}queue_entity_load_avg().
> 
> I think there is some confusion here. There are two per-cpu load metrics
> that tracks differently.
> 
> The cfs.runnable_load_avg is basically the sum of the load contributions
> of the tasks on the cfs rq. The sum gets updated whenever tasks are
> {en,de}queued by adding/subtracting the load contribution of the task
> being added/removed. That is the one you are referring to.
> 
> The rq runnable_avg_sum (actually rq->avg.runnable_avg_{sum, period}) is
> tracking whether the cpu has something to do or not. It doesn't matter
> many tasks are runnable or what their load is. It is updated in
> update_rq_runnable_avg(). It increases when rq->nr_running > 0 and
> decays if not. It also takes time spent running rt tasks into account in
> idle_{enter, exit}_fair(). So if you remove tasks from the rq, this
> metric will start decaying and eventually get to 0, unlike the
> cfs.runnable_load_avg where the task load contribution subtracted every
> time a task is removed. The rq runnable_avg_sum is the one being used in
> this patch set.
> 
> Ben, pjt, please correct me if I'm wrong.

Argh, ok I completely missed that. I think the cfs.runnable_load_avg is
the sane number, not entirely sure what good rq->avg.runnable_avg is
good for, it seems a weird metric on first consideration.

Will have to ponder that a bit more.
