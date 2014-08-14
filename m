Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaHNNzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 09:55:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976AbaHNNzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 09:55:47 -0400
Date: Thu, 14 Aug 2014 15:53:18 +0200
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
Message-ID: <20140814135318.GA26891@redhat.com>
References: <20140812191218.GA15210@redhat.com> <53EA94DD.5040900@redhat.com> <20140813172230.GA6296@redhat.com> <20140813133526.1eb5526f@cuia.bos.redhat.com> <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com> <20140813170324.544aaf2d@cuia.bos.redhat.com> <20140814132239.GA24465@redhat.com> <CAFTL4hwvPobNwm39qzLdP1mPLya7Wg-bLQnWn-Bt5mSV_i3QsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hwvPobNwm39qzLdP1mPLya7Wg-bLQnWn-Bt5mSV_i3QsA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Frederic Weisbecker wrote:
>
> 2014-08-14 15:22 GMT+02:00 Oleg Nesterov <oleg@redhat.com>:
> > On 08/13, Rik van Riel wrote:
> >>
> >> @@ -646,6 +646,7 @@ struct signal_struct {
> >>        * Live threads maintain their own counters and add to these
> >>        * in __exit_signal, except for the group leader.
> >>        */
> >> +     seqlock_t stats_lock;
> >
> > Ah. Somehow I thought that you were going to use seqcount_t and fallback
> > to taking ->siglock if seqcount_retry, but this patch adds the "full blown"
> > seqlock_t.
> >
> > OK, I won't argue, this can make the seqbegin_or_lock simpler...
>
> Is this really needed? seqlock are useful when we have concurrent
> updaters. But updaters of thread stats should be under the thread lock
> already, right? If we have only one updater at a time, seqcount should
> be enough.

Yes, this is what I meant. Although I can see 2 reasons to use seqlock_t:

	1. It can simplify the seqbegin-or-lock logic. If nothing else,
	   you simply can't use read_seqbegin_or_lock() to take ->siglock.
	   But this is just syntactic sugar.

	2. If we use ->siglock in fallback path, we need to verify that
	   thread_group_cputime() is never called with ->siglock held first.

	   Or, we need a fat comment to explain that need_seqrtry == T is not
	   possible if it is called under ->siglock, and thus "fallback to
	   lock_task_sighand" must be always safe. But in this case we need
	   to ensure that the caller didn't do write_seqcount_begin().

So perhaps seqlock_t makes more sense at least initially...

Oleg.

