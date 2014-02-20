Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaBTWVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 17:21:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbaBTWVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 17:21:19 -0500
Date: Thu, 20 Feb 2014 19:39:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, eparis@redhat.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 5/7] pid: rewrite task helper function is_global_init()
	avoiding task->pid
Message-ID: <20140220183958.GB23993@redhat.com>
References: <cover.1390495874.git.rgb@redhat.com> <a8c13f38e0ecfa2c842f0075dbbde77f3e6befc9.1390495874.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8c13f38e0ecfa2c842f0075dbbde77f3e6befc9.1390495874.git.rgb@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23, Richard Guy Briggs wrote:
>
>  static inline int is_global_init(struct task_struct *tsk)
>  {
> -	return tsk->pid == 1;
> +	return task_pid_nr(tsk) == 1;
>  }

ACK, but we need to fix it.

With or without this change is_global_init() actually means
is-the-main-thread-of-global-init.

This is not what the callers actually want. Just look at
oom_unkillable_task(). Suppose that p is the sub-thread of
/sbin/init, if we kill this thread we kill the whole process.

The same of other callers. is_global_init() should return T
if this task is the part of init's thread group.

Oleg.

