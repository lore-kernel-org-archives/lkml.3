Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080Ab3HSRqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:46:37 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:50180 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3HSRqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:46:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130819172524.GA22268@redhat.com>
References: <20130819172524.GA22268@redhat.com>
Date: Mon, 19 Aug 2013 10:46:34 -0700
X-Google-Sender-Auth: T2FTa8K15FvQvHWv-rfMVEu1kek
Message-ID: <CA+55aFzTr7zm2uyZOxMA8wP3FoKPtk__kgGBqf7peMW2Ov8KJA@mail.gmail.com>
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Colin Walters <walters@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 10:25 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Colin reports that vfork() doesn't work after unshare(PIDNS). The
> reason is trivial, copy_process() does:
>
>         /*
>          * If the new process will be in a different pid namespace
>          * don't allow the creation of threads.
>          */
>         if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
>             (task_active_pid_ns(current) != current->nsproxy->pid_ns))
>                 return ERR_PTR(-EINVAL);
>
> and CLONE_VM obviously nacks vfork(). So perhaps we can relax
> this check to CLONE_THREAD? Or should we really nack CLONE_VM
> by security reasons?
>
> OTOH. Perhaps we should also deny CLONE_PARENT in this case?

I agree that we should probably deny CLONE_PARENT, which makes more
sense paired with CLONE_NEWPID. I think we should also disallow
CLONE_THREAD, which is the thread goup.

And I *think* we can drop CLONE_VM. I suspect that snuck in as a
(misguided) attempt at CLONE_THREAD, as implied by the comment.

In fact, if you go look at the history of that CLONE_VM test, it came from

    unshare(CLONE_NEWPID)
    clone(CLONE_THREAD|CLONE_SIGHAND|CLONE_VM)

and the commit message talks about not setting pid_ns->child_reaper.
Which is very much about the PID, not about the shared VM space.

So I think your patch is correct, although I'm not sure why you move
the test. The new test you have look complicated as hell, so I think
you're actually making things worse by making them unreadable.

                  Linus
