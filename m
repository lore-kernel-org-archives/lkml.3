Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab3CDReR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:34:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758545Ab3CDReP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:34:15 -0500
Date: Mon, 4 Mar 2013 18:32:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lianwei Wang <lianwei.wang@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: PATCH: freezer: add fake signal clearing back when thaw task
Message-ID: <20130304173231.GA5442@redhat.com>
References: <CAJFUiJhxqWeQ9PiinpRYCUF8U_3dpaAdvsEKHW2i-QqZ=vkYsQ@mail.gmail.com> <20130225235313.GE2679@htj.dyndns.org> <CAJFUiJjy-7sS9xH76XMLs5SU6fUQ1Bk4Xn67jjHeZNQRjC54dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFUiJjy-7sS9xH76XMLs5SU6fUQ1Bk4Xn67jjHeZNQRjC54dg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Lianwei Wang wrote:
>
> Freeze/Thaw is a hot path for the Linux based mobile OS, e.g. Android.
> If we don't remove the pending fake signal, then the user space apps
> or the related kernel driver has to handle such error.

But if we add recalc_sigpending() we penalize the common case which
doesn't need this.

> And yes, the
> user can handle such case by checking the return value,

Yes.

> but it mislead
> the user and confuse to them that why wait_event_freezable and friends
> return a error on resume path every time? Can we avoid such useless
> error return?

Agreed, it looks strange. It is only for kthreads, I think. And we can
simplify wait_event_freezable() or even kill it.

But if we add new user-space users, I do not know... Fortunately I am
not maintainer ;)

> >> +static void fake_signal_clear(struct task_struct *p)
> >> +{
> >> + unsigned long flags;
> >> +
> >> + if (lock_task_sighand(p, &flags)) {
> >> +     recalc_sigpending();

This looks strange. p is always current, otherwise recalc_sigpending()
can't help.

And since it is current you do not need lock_task_sighand().

Oleg.

