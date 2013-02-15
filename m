Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935872Ab3BOPaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:30:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933003Ab3BOPaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:30:00 -0500
Date: Fri, 15 Feb 2013 16:28:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/5] vfork: don't freezer_count() for in-kernel users
	of CLONE_VFORK
Message-ID: <20130215152840.GC30829@redhat.com>
References: <1360885096-21207-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360885096-21207-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Mandeep Singh Baines wrote:
>
> We don't need to call freezer_do_not_count() for in-kernel users
> of CLONE_VFORK since exec will get called in bounded time.

OK,

> We don't want to call freezer_count() for in-kernel users because
> they may be holding locks.

Who? We should not do this anyway. And __call_usermodehelper() doesn't
afaics.

OK, its caller (process_one_work) does lock_map_acquire() for debugging
purposes, this can "confuse" print_held_locks_bug(). But this thread is
PF_NOFREEZE ?

> @@ -722,9 +722,11 @@ static int wait_for_vfork_done(struct task_struct *child,
>  {
>  	int killed;
>
> -	freezer_do_not_count();
> +	if (current->mm)
> +		freezer_do_not_count();

And if you want to exclude in-kernel users, then perhaps PF_KTHREAD check
will look a bit better.

Oleg.

