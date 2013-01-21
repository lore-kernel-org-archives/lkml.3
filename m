Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab3AUGmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:42:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62781 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3AUGmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:42:18 -0500
Message-ID: <1358750523.4994.55.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Mon, 21 Jan 2013 07:42:03 +0100
In-Reply-To: <50FCCCF5.30504@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
	 <1357985943.6796.55.camel@marge.simpson.net>
	 <1358155290.5631.19.camel@marge.simpson.net>
	 <50F79256.1010900@linux.vnet.ibm.com>
	 <1358654997.5743.17.camel@marge.simpson.net>
	 <50FCACE3.5000706@linux.vnet.ibm.com>
	 <1358743128.4994.33.camel@marge.simpson.net>
	 <50FCCCF5.30504@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:HPgrJyF9KYgbVMEQ9lYeqAPYdFNthhPLzu3IKVQmxpc
 VKMrsS7b2HKty0gaJhoYeEqU2m9ryRDeLQcUVWBAbNdfGQRA0V
 QaKNzYASia3VXV7NcpbvB3uc8Q05k1VjmSyAzgTI4+Yxq2wlQC
 sBev5m2D0EU0uc17fpxlgXTFawnmnG1xNmYuI40/NsnFp+sOkG
 UmjGGyQS9c78xz3EU+W5P3TthDkwFzu4g03wGcaxSdJRaf4d1k
 8NNcqqGt3qu+Gt2IhvPI60adYs6rKxz2b1vKurlfQ0VcaAvPPr
 JipXn4rGRmKy+h7Yd4G3mPeicTttNxdzGk1Dq4wHdKJUFDVt0T
 nBtZMK91IetcqmOplXMZG3cVTxnhD1kxCPK2ObtuDiGzAMKjqU
 /SMolA3M9xsNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 13:07 +0800, Michael Wang wrote:

> That seems like the default one, could you please show me the numbers in
> your datapoint file?

Yup, I do not touch the workfile.  Datapoints is what you see in the
tabulated result...

1
1
1
5
5
5
10
10
10
...

so it does three consecutive runs at each load level.  I quiesce the
box, set governor to performance, echo 250 32000 32 4096
> /proc/sys/kernel/sem, then ./multitask -nl -f, and point it
at ./datapoints.

> I'm not familiar with this benchmark, but I'd like to have a try on my
> server, to make sure whether it is a generic issue.

One thing I didn't like about your changes is that you don't ask
wake_affine() if it's ok to pull cross node or not, which I though might
induce imbalance, but twiddling that didn't fix up the collapse, pretty
much leaving only the balance path.

> >> And I'm confusing about how those new parameter value was figured out
> >> and how could them help solve the possible issue?
> > 
> > Oh, that's easy.  I set sched_min_granularity_ns such that last_buddy
> > kicks in when a third task arrives on a runqueue, and set
> > sched_wakeup_granularity_ns near minimum that still allows wakeup
> > preemption to occur.  Combined effect is reduced over-scheduling.
> 
> That sounds very hard, to catch the timing, whatever, it could be an
> important clue for analysis.

(Play with the knobs with a bunch of different loads, I think you'll
find that those settings work well)

> >> Do you have any idea about which part in this patch set may cause the issue?
> > 
> > Nope, I'm as puzzled by that as you are.  When the box had 40 cores,
> > both virgin and patched showed over-scheduling effects, but not like
> > this.  With 20 cores, symptoms changed in a most puzzling way, and I
> > don't see how you'd be directly responsible.
> 
> Hmm...
> 
> > 
> >> One change by designed is that, for old logical, if it's a wake up and
> >> we found affine sd, the select func will never go into the balance path,
> >> but the new logical will, in some cases, do you think this could be a
> >> problem?
> > 
> > Since it's the high load end, where looking for an idle core is most
> > likely to be a waste of time, it makes sense that entering the balance
> > path would hurt _some_, it isn't free.. except for twiddling preemption
> > knobs making the collapse just go away.  We're still going to enter that
> > path if all cores are busy, no matter how I twiddle those knobs.
> 
> May be we could try change this back to the old way later, after the aim
> 7 test on my server.

Yeah, something funny is going on.  I'd like select_idle_sibling() to
just go away, that task be integrated into one and only one short and
sweet balance path.  I don't see why fine_idlest* needs to continue
traversal after seeing a zero.  It should be just fine to say gee, we're
done.  Hohum, so much for pure test and report, twiddle twiddle tweak,
bend spindle mutilate ;-) 
   
-Mike

