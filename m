Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaHOO2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 10:28:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaHOO2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 10:28:30 -0400
Date: Fri, 15 Aug 2014 16:26:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
	seqlock
Message-ID: <20140815142601.GA13222@redhat.com>
References: <20140813133526.1eb5526f@cuia.bos.redhat.com> <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com> <20140813170324.544aaf2d@cuia.bos.redhat.com> <20140814004318.GA2582@lerouge> <53EC176D.6080201@redhat.com> <CAFTL4hwfNyQPMfpca-=Ou7WoPjB6sE_7BVAcQrVDkBjjPVmPRw@mail.gmail.com> <20140814143902.GA29052@redhat.com> <CAFTL4hw2uAmyW61_U-hzmAfTeeAkMUg7OZy8zmbAFfbSLpzcqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hw2uAmyW61_U-hzmAfTeeAkMUg7OZy8zmbAFfbSLpzcqg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15, Frederic Weisbecker wrote:
>
> 2014-08-14 16:39 GMT+02:00 Oleg Nesterov <oleg@redhat.com>:
> > On 08/14, Frederic Weisbecker wrote:
> >>
> >> I mean the read side doesn't use a lock with seqlocks. It's only made
> >> of barriers and sequence numbers to ensure the reader doesn't read
> >> some half-complete update. But other than that it can as well see the
> >> update n - 1 since barriers don't enforce latest results.
> >
> > Yes, sure, read_seqcount_begin/read_seqcount_retry "right after"
> > write_seqcount_begin-update-write_seqcount_begin can miss "update" part
> > along with ->sequence modifications.
> >
> > But I still can't understand how this can lead to non-monotonic results,
> > could you spell?
>
> Well lets say clock = T.
> CPU 0 updates at T + 1.
> Then I call clock_gettime() from CPU 1 and CPU 2. CPU 1 reads T + 1
> while CPU 1 still reads T.
> If I do yet another round of clock_gettime() on CPU 1 and CPU 2, it's
> possible that CPU 2 still sees T. With the spinlocked version that
> thing can't happen, the second round would read at least T + 1 for
> both CPUs.

But this is fine? And CPU 2 doesn't see a non-monotonic result?

OK, this could be wrong if, say,

	void print_clock(void)
	{
		lock(SOME_LOCK);
		printk(..., clock_gettime());
		unlock(SOME_LOCK);
	}
	
printed the non-monotonic numbers if print_clock() is called on CPU_1 and
then on CPU_2. But in this case CPU_2 can't miss the changes on CPU_0 if
they were already visible to CPU_1 under the same lock. IOW,

	int T = 0;	/* can be incremented at any time */

	void check_monotony(void)
	{
		static int t = 0;

		lock(SOME_LOCK);
		BUG(t > T);
		T = t;
		unlock(SOME_LOCK);
	}

must work corrrectly (ignoring overflow) even if T is changed without
SOME_LOCK.

Otherwise, without some sort of synchronization the different results on
CPU_1/2 should be fine.

Or I am still missing your point?

Oleg.

