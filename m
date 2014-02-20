Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaBTT5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:57:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbaBTT5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:57:06 -0500
Date: Thu, 20 Feb 2014 20:01:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, eparis@redhat.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
        stable@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 7/7] pid: get pid_t ppid of task in init_pid_ns
Message-ID: <20140220190114.GC23993@redhat.com>
References: <cover.1390495874.git.rgb@redhat.com> <328c85752a7eb053e72d9194827b91fc228d4f67.1390495874.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <328c85752a7eb053e72d9194827b91fc228d4f67.1390495874.git.rgb@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23, Richard Guy Briggs wrote:
>
> Added the functions task_ppid_nr_ns() and task_ppid_nr() to abstract the lookup
> of the PPID (real_parent's pid_t) of a process, including rcu locking, in the
> arbitrary and init_pid_ns.
> This provides an alternative to sys_getppid(), which is relative to the child
> process' pid namespace.

I agree, this makes sense.


imho it would be better to send this patch along with sys_getppid()
conversions, but I won't argue.

> +static int pid_alive(const struct task_struct *p);
> +static inline pid_t task_ppid_nr_ns(const struct task_struct *tsk, struct pid_namespace *ns)
> +{
> +	pid_t pid = 0;
> +
> +	rcu_read_lock();
> +	if (pid_alive(tsk))
> +		pid = task_tgid_nr_ns(rcu_dereference(tsk->real_parent), ns);
> +	rcu_read_unlock();
> +
> +	return pid;
> +}

Perhaps it should be named task_ptgid_nr_ns() or even parent_tgid_nr_ns().
Since it returns tgid, not pid (== tid).

But this is cosmetic, I won't insist.

Oleg.

