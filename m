Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab3BPRLe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 12:11:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab3BPRLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 12:11:32 -0500
Date: Sat, 16 Feb 2013 18:10:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ben Chan <benchan@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 5/5] coredump: ignore non-fatal signals when core
	dumping to a pipe
Message-ID: <20130216171010.GE4910@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org> <1361008406-2307-5-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361008406-2307-5-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Mandeep Singh Baines wrote:
>
> Make wait_for_dump_helpers() not abort piping the core dump data when the
> crashing process has received a non-fatal signal.  The abort still occurs
> in the case of SIGKILL.
>
> Testing:
>
> localhost ~ # echo "|/usr/bin/sleep 1d" > /proc/sys/kernel/core_pattern
> localhost ~ # sleep 1d &

As I already said, this is not enough. And if we change send_signal() paths
to "ignore" the non-fatal signals sent to the dumping process (and I think
we should do this anyway), this change is not needed.

Except we have other problems with the freezer.

> +static int sigkill_pending(struct task_struct *tsk)
> +{
> +	return	signal_pending(tsk) &&
> +		(sigismember(&tsk->pending.signal, SIGKILL) ||
> +		 sigismember(&tsk->signal->shared_pending.signal, SIGKILL));
> +}

Why? __fatal_signal_pending() is enough, you do not need to check
->shared_pending. And once again, ignoring the freezer problems I
do not think we need this check at all.

IOW. Yes, we will probably need to do this change but only to be
freezer-friendly.

>  static void wait_for_dump_helpers(struct file *file)
>  {
>  	struct pipe_inode_info *pipe;
> +	sigset_t blocked, previous;
> +
> +	/* Block all but fatal signals. */
> +	siginitsetinv(&blocked, sigmask(SIGKILL));
> +	sigprocmask(SIG_BLOCK, &blocked, &previous);

(sigprocmask() must die, please never use, we have set_current_blocked().
 Although in this particular case this doesn't matter...)

Heh. When I suggested this change a looong ago, my attempt was NACK'ed
because the core handler looks at /proc/pid/status.

If we could do this, we could simply ignore all signals except SIGKILL
at the start, in zap_threads(). This could solve almost all problems
with the signals/SIGKILL.

But see above, we can't.

Anyway. Please look at the patch below. I need to recheck it, and I was
going to send it later, along with other changes I am _trying_ to do. But
if it is correct, it looks certainly better and perhaps it can go ahead.

Afaics it could equally fix the mentioned problems (again, if correct ;).
"equally" also means it is equally incomplete.

Oleg.

--- x/fs/coredump.c
+++ x/fs/coredump.c
@@ -416,17 +416,17 @@ static void wait_for_dump_helpers(struct
 	pipe_lock(pipe);
 	pipe->readers++;
 	pipe->writers--;
+	// TODO: wake_up_interruptible_sync_poll ?
+	wake_up_interruptible_sync(&pipe->wait);
+	kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
+	pipe_unlock(pipe);
 
-	while ((pipe->readers > 1) && (!signal_pending(current))) {
-		wake_up_interruptible_sync(&pipe->wait);
-		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
-		pipe_wait(pipe);
-	}
+	wait_event_freezekillable(&pipe->wait, pipe->readers == 1);
 
+	pipe_lock(pipe);
 	pipe->readers--;
 	pipe->writers++;
 	pipe_unlock(pipe);
-
 }
 
 /*

