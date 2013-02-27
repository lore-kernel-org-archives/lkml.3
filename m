Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab3B0SK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:10:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760052Ab3B0SK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:10:26 -0500
Date: Wed, 27 Feb 2013 19:08:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] freezer: do not send a fake signal to a
	PF_DUMPCORE thread
Message-ID: <20130227180844.GA6015@redhat.com>
References: <20130224173144.GA32179@redhat.com> <20130224173206.GA32206@redhat.com> <20130224183656.GA8903@redhat.com> <CACBanvoOdfZr1x5kU1+fmtex1Cuoas_LwBKwZ_giiLE511E-jg@mail.gmail.com> <CACBanvr5vbkH1J+waRHMBq8hRuKqJtF0sD0+95v6Qmnd=3Zd_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACBanvr5vbkH1J+waRHMBq8hRuKqJtF0sD0+95v6Qmnd=3Zd_w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Mandeep Singh Baines wrote:
>
> >> Change freeze_task() to check PF_DUMPCORE along with PF_KTHREAD. We
> >> need to recheck PF_DUMPCORE under ->siglock to avoid the race with
> >> zap_threads() which can set this flag right before we take the lock.
> >>
> >
> > Won't this prevent suspend?

Hmm. I guess you mean that pipe_write() can hang in pipe_wait() if the
user-space handler was already freezed... Damn, and I even mentioned
this race when we discussed this 2 weeks ago.

I need to think, but most probably you are right, and we need another
solution...

> You'd rather have reliable suspend than coredumps that aren't
> truncated so you need to set TIF_SIGPENDING to break waits in the
> dump_write path.

Oh, I agree. In this case the necessary changes look simple.

> static void wait_for_dump_helpers(struct file *file)
> {
>         struct pipe_inode_info *pipe;
>
>         pipe = file->f_path.dentry->d_inode->i_pipe;
>
>         pipe_lock(pipe);
>         pipe->readers++;
>         pipe->writers--;
>
>         while (pipe->readers > 1) {
>                 unsigned long flags;
>
>                 wake_up_interruptible_sync(&pipe->wait);
>                 kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>                 pipe_wait(pipe);
>
>                 pipe_unlock(pipe);
>                 try_to_freeze();
>                 pipe_lock(pipe);
>
>                 if (fatal_signal_pending(current))
>                         break;
>
>                 /* Clear fake signal from freeze_task(). */
>                 spin_lock_irqsave(&current->sighand->siglock, flags);
>                 recalc_sigpending();
>                 spin_unlock_irqrestore(&current->sighand->siglock, flags);

IIRC, this is what you added into your tree. But note that
recalc_sigpending() is wrong, exactly because (say) SIGCHLD can
be pending if it was sent before we set SIGNAL_GROUP_COREDUMP.

So this code needs something like

	spin_lock_irq(siglock);
	if (!fatal_signal_pending)
		clear_thread_flag(TIF_SIGPENDING);
	spin_unlock_irq(siglock);

Or we need to change recalc_sigpending() to check SIGNAL_GROUP_COREDUMP
or PF_DUMPCORE. I'd like to avoid this, but perhaps we have to do this...

(Btw, this is offtopic, but whatever we do 3/3 still looks like a nice
 cleanup to me, although it probably needs more changes)

> What do you think? That would fix most cases. You'll still get a
> truncated core if you were to receive the signal during pipe_write or
> something.

Let me think a bit...

Right now I can only say that personally I do not really like the
idea to fix wait_for_dump_helpers() but not pipe_write(). I mean,
if pipe_write() can fail due to freezing(), then why should we care
about wait_for_dump_helpers() ? Let them all fail, suspend is not
that often.

Or we should try to make everything freezer-friendly. But if
freeze_task() sets TIF_SIGPENDING then we need the ugly "retry"
logic in dump_write()... Not good.

Thanks Mandeep. If you have other ideas please tell me ;)

Oleg.

