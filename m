Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbaDGTGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:06:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbaDGTGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:06:00 -0400
Date: Mon, 7 Apr 2014 21:06:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matthew Dempsky <mdempsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] ptrace: Fix fork event messages across pid
	namespaces
Message-ID: <20140407190610.GA24607@redhat.com>
References: <1396391358-22367-1-git-send-email-mdempsky@chromium.org> <1396492005-23811-1-git-send-email-mdempsky@chromium.org> <20140403154413.GA16684@redhat.com> <CAF52+S5aTOJL-Xn-yji3RmCS60=R7qaLqzADbdSH91oLPPYOug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF52+S5aTOJL-Xn-yji3RmCS60=R7qaLqzADbdSH91oLPPYOug@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03, Matthew Dempsky wrote:
>
> On Thu, Apr 3, 2014 at 8:44 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Some notes for potential future changes...
> >
> >         - I do not not see any potential user of ptrace_event_pid() outside
> >           of fork.c, so perhaps this helper should not be exported.
> >
> >           In fact I wouldn't mind if you send v5 which moves it into fork.c ;)
>
> Like you mentioned, it's potentially used by fs/exec.c too, which I
> was intending to send a followup patch for.

OK, agreed. Probably we can tolerate the extra get/put_pid() but make
this code look better.

> >         - OTOH, calculating pid_nr in the namespace of ->parent can probably
> >           go into another simple (exported) helper. do_notify_parent_*() and
> >           exec_binprm() could use it, even they do not have the problem with
> >           task_active_pid_ns(parent) == NULL. Not sure.
>
> I think do_notify_parent_*() are safe from task_active_pid_ns(parent)
> == NULL because they're under tasklist_lock,

Yes, they are fine correctness-wise, just this task_pid_nr_ns(...) doesn't
look readable. OK, please forget, from_kuid_munged() doesn't look better.

> but it looks like
> exec_binprm() is theoretically racy

No (if you meant task_pid_nr_ns() == NULL). Note that __task_pid_nr_ns()
checks ns != NULL. In fact this is bad, this just reminds that we have
too many helpers with the subtle differences ;)

But if you meant that it can report the wrong pid then yes, of course,
it can race with detach/attach too.

Oleg.

