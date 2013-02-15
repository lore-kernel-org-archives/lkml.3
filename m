Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab3BOXZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 18:25:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3BOXZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 18:25:40 -0500
Date: Fri, 15 Feb 2013 15:25:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ben Chan <benchan@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 5/5] coredump: abort core dump piping only due to a
 fatal signal
Message-Id: <20130215152538.9a61a44e.akpm@linux-foundation.org>
In-Reply-To: <1360885096-21207-5-git-send-email-msb@chromium.org>
References: <1360885096-21207-1-git-send-email-msb@chromium.org>
	<1360885096-21207-5-git-send-email-msb@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2013 15:38:16 -0800
Mandeep Singh Baines <msb@chromium.org> wrote:

> From: Ben Chan <benchan@chromium.org>
> 
> This patch makes wait_for_dump_helpers() not to abort piping the core
> dump data when the crashing process has received any but a fatal signal
> (SIGKILL). The rationale is that a crashing process may still receive
> uninteresting signals such as SIGCHLD when its core dump data is being
> redirected to a helper application. While it's necessary to allow
> terminating the core dump piping via SIGKILL, it's practically more
> useful for the purpose of debugging and crash reporting if the core dump
> piping is not aborted due to other non-fatal signals.

Sounds sensible.  The changelog is rather hard to understand.  Is the
below accurate?

: Make wait_for_dump_helpers() not abort piping the core dump data when the
: crashing process has received a non-fatal signal.  The abort still occurs
: in the case of SIGKILL.
: 
: The rationale is that a crashing process may still receive uninteresting
: signals such as SIGCHLD when its core dump data is being redirected to a
: helper application.  While it's necessary to allow terminating the core
: dump piping via SIGKILL, it's practically more useful for the purpose of
: debugging and crash reporting if the core dump piping is not aborted due
: to other non-fatal signals.

> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -32,6 +32,7 @@
>  #include <linux/pipe_fs_i.h>
>  #include <linux/oom.h>
>  #include <linux/compat.h>
> +#include <linux/freezer.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/mmu_context.h>
> @@ -417,10 +418,13 @@ static void wait_for_dump_helpers(struct file *file)
>  	pipe->readers++;
>  	pipe->writers--;
>  
> -	while ((pipe->readers > 1) && (!signal_pending(current))) {
> +	while ((pipe->readers > 1) && (!fatal_signal_pending(current))) {
>  		wake_up_interruptible_sync(&pipe->wait);
>  		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>  		pipe_wait(pipe);
> +		pipe_unlock(pipe);
> +		try_to_freeze();
> +		pipe_lock(pipe);
>  	}

The new call to try_to_freeze() is unchangelogged and uncommented.  Can
we please fix both these things?

