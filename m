Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaHNTjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 15:39:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbaHNTjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 15:39:36 -0400
Date: Thu, 14 Aug 2014 21:37:00 +0200
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
Message-ID: <20140814193700.GA9747@redhat.com>
References: <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com> <20140813170324.544aaf2d@cuia.bos.redhat.com> <20140814142404.GA28211@redhat.com> <53ECD7C8.6040202@redhat.com> <20140814161247.GA32715@redhat.com> <53ECF390.40403@redhat.com> <20140814181542.GB5091@redhat.com> <53ED080F.9010305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ED080F.9010305@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Rik van Riel wrote:
>
> On 08/14/2014 02:15 PM, Oleg Nesterov wrote:
> > On 08/14, Rik van Riel wrote:
> >>
> >> On 08/14/2014 12:12 PM, Oleg Nesterov wrote:
> >>>
> >>> Or you can expand the scope of write_seqlock/write_sequnlock, so that
> >>> __unhash_process in called from inside the critical section. This looks
> >>> simpler at first glance.
> >>
> >> The problem with that is that wait_task_zombie() calls
> >> thread_group_cputime_adjusted() in that if() branch, and
> >> that code ends up taking the seqlock for read...
> >
> > Not sure I understand... This modifies parent->signal->c* counters,
> > and obviously the exiting thread is not the member of parent's thread
> > group, so thread_group_cputime_adjusted(parent) can never account the
> > exiting child twice simply because it won't see it?
>
> You are right, the tree of processes only goes one way,
> so there should be no deadlock in taking psig->stats_lock
> and having thread_group_cputime_adjusted take sig->stats_lock
> for read within that section.
>
> However, it might need some lockdep annotation to keep
> lockdep from thinking we might the same lock recursively :)

But wait_task_zombie() can (and should) call
thread_group_cputime_adjusted(zombie_child) outside of parent's ->siglock
or ->stats_lock so this this should be safe.

Oleg.

