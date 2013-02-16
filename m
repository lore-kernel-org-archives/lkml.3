Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3BPRHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 12:07:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab3BPRHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 12:07:08 -0500
Date: Sat, 16 Feb 2013 18:05:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/5] vfork: don't freezer_count() for in-kernel users
	of CLONE_VFORK
Message-ID: <20130216170545.GB4910@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361008406-2307-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Mandeep Singh Baines wrote:
>
> We don't need to call freezer_do_not_count() for in-kernel users
> of CLONE_VFORK since exec will get called in bounded time.
>
> We don't want to call freezer_count() for in-kernel users because
> they may be holding locks. freezer_count() calls try_to_freeze().
> We don't want to freeze an in-kernel user because it may be
> holding locks.

I can only repeat my question ;)

	Who? We should not do this anyway. And __call_usermodehelper() doesn't
	afaics.

	OK, its caller (process_one_work) does lock_map_acquire() for debugging
	purposes, this can "confuse" print_held_locks_bug(). But this thread is
	PF_NOFREEZE ?

Previously this was needed to suppress the false positive. Now that 2/5
checks PF_NOFREEZE, why do we need this change?

> @@ -722,9 +722,11 @@ static int wait_for_vfork_done(struct task_struct *child,
>  {
>  	int killed;
>
> -	freezer_do_not_count();
> +	if (!(current->flags & PF_KTHREAD))
> +		freezer_do_not_count();

If I missed something and we really need this, imho this needs a comment.

Oleg.

