Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaHREo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 00:44:57 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:48045 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaHREox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 00:44:53 -0400
Message-ID: <1408337089.5570.16.camel@marge.simpson.net>
Subject: Re: [PATCH v2 2/3] time,signal: protect resource use statistics
 with seqlock
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, akpm@linux-foundation.org,
        srao@redhat.com, lwoodman@redhat.com, atheurer@redhat.com
Date: Mon, 18 Aug 2014 06:44:49 +0200
In-Reply-To: <20140816175002.GA24994@redhat.com>
References: <1408133138-22048-1-git-send-email-riel@redhat.com>
	 <1408133138-22048-3-git-send-email-riel@redhat.com>
	 <20140816141159.GA8709@redhat.com>
	 <20140816134010.26a9b572@annuminas.surriel.com>
	 <20140816175002.GA24994@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-08-16 at 19:50 +0200, Oleg Nesterov wrote: 
> On 08/16, Rik van Riel wrote:
> >
> > +	do {
> > +		seq = nextseq;
> > +		read_seqbegin_or_lock(&sig->stats_lock, &seq);
> > +		times->utime = sig->utime;
> > +		times->stime = sig->stime;
> > +		times->sum_exec_runtime = sig->sum_sched_runtime;
> > +
> > +		for_each_thread(tsk, t) {
> > +			task_cputime(t, &utime, &stime);
> > +			times->utime += utime;
> > +			times->stime += stime;
> > +			times->sum_exec_runtime += task_sched_runtime(t);
> > +		}
> > +		/* If lockless access failed, take the lock. */
> > +		nextseq = 1;
> 
> Yes, thanks, this answers my concerns.
> 
> Cough... can't resist, and I still think that we should take rcu_read_lock()
> only around for_each_thread() and the patch expands the critical section for
> no reason. But this is minor, I won't insist.

Hm.  Should traversal not also disable preemption to preserve the error
bound Peter mentioned?

-Mike

