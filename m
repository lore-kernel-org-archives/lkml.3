Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbaETOfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:35:39 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:44253 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaETOfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:35:38 -0400
Date: Tue, 20 May 2014 10:35:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/5] workqueue: Allow changing attributions of ordered
 workqueues
Message-ID: <20140520143534.GD2804@htj.dyndns.org>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
 <1400257015-28222-2-git-send-email-fweisbec@gmail.com>
 <20140516201225.GL5379@htj.dyndns.org>
 <20140517134151.GA32371@localhost.localdomain>
 <20140519201531.GC27506@mtj.dyndns.org>
 <20140520143229.GB17741@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520143229.GB17741@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 20, 2014 at 04:32:31PM +0200, Frederic Weisbecker wrote:
> > But that's the same for other pwqs too.  Back-to-back requeueing will
> > hold back pwq switching on any workqueue.
> 
> I don't think so, because non ordered pwqs aren't created with 0 max_active,
> so they can run before the old pwq is released. It's not holding back the new
> one and creating a starvation there.
> 
> But maybe I forget other details.

Ah, I was thinking about old pwq not being allowed to be released
while one or more work items are requeueing themselves back-to-back.
Yeap, the new ones can still be used for other work items.

> > Maybe I'm confused but I don't think it'd be.  Let's say there was an
> > attribute change with one work item, A, which is performing
> > back-to-back requeueing and another one, B, which queues itself
> > intermittently.  If B is queued while A is executing, followed by A
> > requeueing itself, the expected execution order is A - B - A; however,
> > without the above exception for ordered workqueues, it'd end up A - A
> > - B because B will end up on the new pwq while A on the older one and
> > max_active won't be transferred to the new pwq before it becomes
> > empty.
> 
> Ah right AAB instead of ABA is possible indeed. I don't know if some workqueue
> rely on such guarantee but it's possible.

That's part of the ordering guarantee of ordered workqueues so we
better not break it.

> In which case we have one more reason to make an exception on ordered workqueues
> previous pwq reuse.

Yeah, I agree the special treatment is necessary but the current
comment is misleading.

Thanks.

-- 
tejun
