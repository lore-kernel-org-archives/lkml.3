Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaG2MFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:05:34 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:41776 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaG2MFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:05:32 -0400
Date: Tue, 29 Jul 2014 08:05:25 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@gentwo.org>, Sasha Levin <sasha.levin@oracle.com>,
        akpm@linux-foundation.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org
Subject: Re: vmstat: On demand vmstat workers V8
Message-ID: <20140729120525.GA28366@mtj.dyndns.org>
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org>
 <53D31101.8000107@oracle.com>
 <alpine.DEB.2.11.1407281353450.15405@gentwo.org>
 <20140729075637.GA19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729075637.GA19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 09:56:37AM +0200, Peter Zijlstra wrote:
> On Mon, Jul 28, 2014 at 01:55:17PM -0500, Christoph Lameter wrote:
> > On Fri, 25 Jul 2014, Sasha Levin wrote:
> > 
> > > This patch doesn't interact well with my fuzzing setup. I'm seeing
> > > the following:
> > >
> > > [  490.446927] BUG: using __this_cpu_read() in preemptible [00000000] code: kworker/16:1/7368
> > > [  490.447909] caller is __this_cpu_preempt_check+0x13/0x20
> > 
> > __this_cpu_read() from vmstat_update is only called from a kworker that
> > is bound to a single cpu. A false positive?
> 
> kworkers are never guaranteed to be so, its a 'feature' :/

It's because we don't distinguish work items which are per-cpu for
optimization and per-cpu for correctness and can't automatically flush
/ cancel / block per-cpu work items when a cpu goes down.  I like the
idea of distingushing them but it's gonna take a lot of auditing.

Any work item usage which requires per-cpu for correctness should
implement cpu down hook to flush in-flight work items and block
further issuance.  This hasn't changed from the beginning and was
necessary even before cmwq.

Thanks.

-- 
tejun
