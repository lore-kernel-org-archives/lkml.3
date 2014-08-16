Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaHPRwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 13:52:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbaHPRw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 13:52:29 -0400
Date: Sat, 16 Aug 2014 19:50:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        umgwanakikbuti@gmail.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, srao@redhat.com, lwoodman@redhat.com,
        atheurer@redhat.com
Subject: Re: [PATCH v2 2/3] time,signal: protect resource use statistics
	with seqlock
Message-ID: <20140816175002.GA24994@redhat.com>
References: <1408133138-22048-1-git-send-email-riel@redhat.com> <1408133138-22048-3-git-send-email-riel@redhat.com> <20140816141159.GA8709@redhat.com> <20140816134010.26a9b572@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140816134010.26a9b572@annuminas.surriel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Rik van Riel wrote:
>
> +	do {
> +		seq = nextseq;
> +		read_seqbegin_or_lock(&sig->stats_lock, &seq);
> +		times->utime = sig->utime;
> +		times->stime = sig->stime;
> +		times->sum_exec_runtime = sig->sum_sched_runtime;
> +
> +		for_each_thread(tsk, t) {
> +			task_cputime(t, &utime, &stime);
> +			times->utime += utime;
> +			times->stime += stime;
> +			times->sum_exec_runtime += task_sched_runtime(t);
> +		}
> +		/* If lockless access failed, take the lock. */
> +		nextseq = 1;

Yes, thanks, this answers my concerns.

Cough... can't resist, and I still think that we should take rcu_read_lock()
only around for_each_thread() and the patch expands the critical section for
no reason. But this is minor, I won't insist.

Oleg.

