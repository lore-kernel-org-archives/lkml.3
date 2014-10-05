Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaJEWcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 18:32:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbaJEWcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 18:32:07 -0400
Date: Mon, 6 Oct 2014 00:28:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH] posix-timers: fix stack info leak in timer_create()
Message-ID: <20141005222858.GA12662@redhat.com>
References: <1412456799-32339-1-git-send-email-minipli@googlemail.com> <20141005210614.GA28899@redhat.com> <CA+rthh96tG+9ZjWa=9WyaWABbUyxJ2z6YVaX4ApL424c31yCRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rthh96tG+9ZjWa=9WyaWABbUyxJ2z6YVaX4ApL424c31yCRw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05, Mathias Krause wrote:
>
> On 5 October 2014 23:06, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 10/04, Mathias Krause wrote:
> >>
> >> Cc: <stable@vger.kernel.org>  # v2.6.28+
> >
> > not sure this is -stable material but I won't really argue.
> >
>
> This should fall into the class "security fixes". Info leaks like that
> -- if flagged as such -- got backported regularly in the past. They
> tend to get CVE IDs, even.

And imo, very often we do this for absolutely no reason. Like this fix
tries to do ;) But again, I won't really argue.

> >> --- a/kernel/time/posix-timers.c
> >> +++ b/kernel/time/posix-timers.c
> >> @@ -636,6 +636,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
> >>                       goto out;
> >>               }
> >>       } else {
> >> +             memset(&event.sigev_value, 0, sizeof(event.sigev_value));
> >>               event.sigev_notify = SIGEV_SIGNAL;
> >>               event.sigev_signo = SIGALRM;
> >>               event.sigev_value.sival_int = new_timer->it_id;
> >
> > How about
> >
> >         -       event.sigev_value.sival_int = new_timer->it_id;
> >         +       event.sigev_value = (sigval_t) { .sival_int = new_timer_id };
> >
> > ?
>
> Oh, well. It's a matter of taste, I guess.

Sure.

> It won't fit mine ;) I
> think it makes it slightly less readable.

To me it looks more readable, that is why I suggested this change.
But of course, of course, this is subjective, so I won't insist.

So I think this patch is fine.

Oleg.

