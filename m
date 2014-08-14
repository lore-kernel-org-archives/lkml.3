Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaHNO0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:26:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbaHNO03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:26:29 -0400
Date: Thu, 14 Aug 2014 16:24:04 +0200
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
Message-ID: <20140814142404.GA28211@redhat.com>
References: <20140812142539.01851e52@annuminas.surriel.com> <20140812191218.GA15210@redhat.com> <53EA94DD.5040900@redhat.com> <20140813172230.GA6296@redhat.com> <20140813133526.1eb5526f@cuia.bos.redhat.com> <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com> <20140813170324.544aaf2d@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813170324.544aaf2d@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13, Rik van Riel wrote:
>
> @@ -862,11 +862,9 @@ void do_sys_times(struct tms *tms)
>  {
>  	cputime_t tgutime, tgstime, cutime, cstime;
>
> -	spin_lock_irq(&current->sighand->siglock);
>  	thread_group_cputime_adjusted(current, &tgutime, &tgstime);
>  	cutime = current->signal->cutime;
>  	cstime = current->signal->cstime;
> -	spin_unlock_irq(&current->sighand->siglock);

Ah, wait, there is another problem afaics...

thread_group_cputime_adjusted()->cputime_adjust() plays with
signal->prev_cputime and thus it needs siglock or stats_lock to ensure
it can't race with itself. Not sure it is safe to simply take the lock
in cputime_adjust(), this should be checked.

OTOH, do_task_stat() already calls task_cputime_adjusted() lockless and
this looks wrong or I missed something. So perhaps we need a lock in or
around cputime_adjust() anyway.

Oleg.

