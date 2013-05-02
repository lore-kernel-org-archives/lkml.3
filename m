Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3EBXYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 19:24:13 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:62621 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3EBXYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 19:24:12 -0400
Date: Thu, 2 May 2013 16:24:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 02/10] freezer: skip waking up tasks with
 PF_FREEZER_SKIP set
Message-ID: <20130502232407.GV19814@mtj.dyndns.org>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
 <1367458508-9133-3-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367458508-9133-3-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 06:35:00PM -0700, Colin Cross wrote:
> Android goes through suspend/resume very often (every few seconds when
> on a busy wifi network with the screen off), and a significant portion
> of the energy used to go in and out of suspend is spent in the
> freezer.  If a task has called freezer_do_not_count(), don't bother
> waking it up.  If it happens to wake up later it will call
> freezer_count() and immediately enter the refrigerator.
> 
> Combined with patches to convert freezable helpers to use
> freezer_do_not_count() and convert common sites where idle userspace
> tasks are blocked to use the freezable helpers, this reduces the
> time and energy required to suspend and resume.
> 
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
> v2:  move check to freeze_task()
> 
>  kernel/freezer.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index c38893b..8b2afc1 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -110,6 +110,18 @@ bool freeze_task(struct task_struct *p)
>  {
>  	unsigned long flags;
>  
> +	/*
> +	 * This check can race with freezer_do_not_count, but worst case that
> +	 * will result in an extra wakeup being sent to the task.  It does not
> +	 * race with freezer_count(), the barriers in freezer_count() and
> +	 * freezer_should_skip() ensure that either freezer_count() sees
> +	 * freezing == true in try_to_freeze() and freezes, or
> +	 * freezer_should_skip() sees !PF_FREEZE_SKIP and freezes the task
> +	 * normally.
> +	 */
> +	if (freezer_should_skip(p))
> +		return false;

Maybe a line or two explaining that this matters for power saving?
Other than that,

Acked-by: Tejun Heo <tj@kernel.org>

Oleg, this looks correct to me.  Can you please ack too?

Thanks.

-- 
tejun
