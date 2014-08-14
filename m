Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaHNQPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 12:15:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaHNQPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 12:15:14 -0400
Date: Thu, 14 Aug 2014 18:12:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
	seqlock
Message-ID: <20140814161247.GA32715@redhat.com>
References: <20140812191218.GA15210@redhat.com> <53EA94DD.5040900@redhat.com> <20140813172230.GA6296@redhat.com> <20140813133526.1eb5526f@cuia.bos.redhat.com> <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com> <20140813170324.544aaf2d@cuia.bos.redhat.com> <20140814142404.GA28211@redhat.com> <53ECD7C8.6040202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ECD7C8.6040202@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Rik van Riel wrote:
>
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 08/14/2014 10:24 AM, Oleg Nesterov wrote:
> > On 08/13, Rik van Riel wrote:
> >>
> >> @@ -862,11 +862,9 @@ void do_sys_times(struct tms *tms) {
> >> cputime_t tgutime, tgstime, cutime, cstime;
> >>
> >> -	spin_lock_irq(&current->sighand->siglock);
> >> thread_group_cputime_adjusted(current, &tgutime, &tgstime);
> >> cutime = current->signal->cutime; cstime =
> >> current->signal->cstime; -
> >> spin_unlock_irq(&current->sighand->siglock);
> >
> > Ah, wait, there is another problem afaics...
>
> Last night I worked on another problem with this code.
>
> After propagating the stats from a dying task to the signal struct,
> we need to make sure that that task's stats are not counted twice.

Heh indeed ;) Can't understand how I missed that.

> This requires zeroing the stats under the write_seqlock, which was
> easy enough to add.

Or you can expand the scope of write_seqlock/write_sequnlock, so that
__unhash_process in called from inside the critical section. This looks
simpler at first glance.

Hmm, wait, it seems there is yet another problem ;) Afaics, you also
need to modify __exit_signal() so that ->sum_sched_runtime/etc are
accounted unconditionally, even if the group leader exits.

Probably this is not a big problem, and sys_times() or clock_gettime()
do not care at all because they use current.

But without this change thread_group_cputime(reaped_zombie) won't look
at this task_struct at all, this can lead to non-monotonic result if
it was previously called when this task was alive (non-reaped).

Oleg.

