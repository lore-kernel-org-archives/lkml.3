Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717Ab3BOPCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:02:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab3BOPCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:02:34 -0500
Date: Fri, 15 Feb 2013 16:01:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ben Chan <benchan@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 5/5] coredump: abort core dump piping only due to a
	fatal signal
Message-ID: <20130215150117.GB30829@redhat.com>
References: <1360885096-21207-1-git-send-email-msb@chromium.org> <1360885096-21207-5-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360885096-21207-5-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Mandeep Singh Baines wrote:
>
> This patch makes wait_for_dump_helpers() not to abort piping the core
> dump data when the crashing process has received any but a fatal signal
> (SIGKILL). The rationale is that a crashing process may still receive
> uninteresting signals such as SIGCHLD when its core dump data is being
> redirected to a helper application.

You already sent this change in the past ;) and I already reviewed it.

It is not enough and imho not good. Damn, I'll try very much to make the
patches on weekend...

> -	while ((pipe->readers > 1) && (!signal_pending(current))) {
> +	while ((pipe->readers > 1) && (!fatal_signal_pending(current))) {

This turns pipe_wait() belowe into the busy-wait loop if signal_pending().
Not good. And not enough, there are other reasons why coredump can fail
if the signal is pending.

>  		wake_up_interruptible_sync(&pipe->wait);
>  		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>  		pipe_wait(pipe);
> +		pipe_unlock(pipe);
> +		try_to_freeze();

Oh, yes. One of the problems with coredump/signals is freezer. Not sure
what should we do...

But if we add try_to_freeze() here, we need to add more try_to_freeze's,
think about dumping the huge core on the slow media.

Oleg.

