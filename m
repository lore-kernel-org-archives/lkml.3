Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3KNTfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:35:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53501 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755049Ab3KNTfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:35:42 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Amit Pundir <amit.pundir@linaro.org>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [RFC][PATCH v2] epoll: allow EPOLLWAKEUP flag if PM_SLEEP is enabled
Date: Thu, 14 Nov 2013 20:48:13 +0100
Message-ID: <2226686.lJvXUupyWo@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAMi1Hd2F5iWGztjMOM7UarEeXdUTCGh7ZV=XxhX1u-kKCRt-LQ@mail.gmail.com>
References: <1384289548-26015-1-git-send-email-amit.pundir@linaro.org> <26648741.38OpUJA4ry@vostro.rjw.lan> <CAMi1Hd2F5iWGztjMOM7UarEeXdUTCGh7ZV=XxhX1u-kKCRt-LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 14, 2013 09:59:44 PM Amit Pundir wrote:
> On 14 November 2013 03:14, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, November 13, 2013 01:35:38 PM Amit Pundir wrote:
> >> On 13 November 2013 05:29, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Wednesday, November 13, 2013 02:22:28 AM Amit Pundir wrote:
> >> >> ep_create_wakeup_source() reports ENOMEM
> >> >
> >> > That needs to be fixed too.  I suppose we can make the wakeup_source_register()
> >> > stub for CONFIG_PM_SLEEP unset return ERR_PTR(-ENOSYS) or something like that
> >> > and ep_create_wakeup_source() return that instead of -ENOMEM.  It looks like
> >> > eventpoll.c is the only user of it built for CONFIG_PM_SLEEP unset, but that
> >> > needs to be double checked.
> >>
> >> Instead of modifying wakeup_source_register() stub, what if I make
> >> ep_create_wakeup_source() static inline as well and use its stub to
> >> return -ENOSYS when CONFIG_PM_SLEEP is not set?
> >> ep_create_wakeup_source() is used only in fs/eventpoll.c anyway.
> >
> > Well, you can do that too.
> >
> 
> On second thought we may skip modifying ep_create_wakeup_source() or
> wakeup_source_register() altogether because once we drop EPOLLWAKEUP
> from epoll events mask(if PM_SLEEP is unset) then I don't see us
> running into ep_create_wakeup_source() again. And the only reason for
> ep_create_wakeup_source() failure will be -ENOMEM as far as I can see.

OK

> >> >> if wakeup_source_register()
> >> >> returns NULL. ep_create_wakeup_source() assumes that NULL is only
> >> >> returned if we run into ENOMEM but NULL is also returned when
> >> >> CONFIG_PM_SLEEP is disabled.
> >> >>
> >> >> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> >> >> ---
> >> >> Changed in v2:
> >> >> Using static inline functions instead of #ifdefs
> >> >> ---
> >> >>  fs/eventpoll.c                 |    3 +--
> >> >>  include/uapi/linux/eventpoll.h |   12 ++++++++++++
> >> >>  2 files changed, 13 insertions(+), 2 deletions(-)
> >> >>
> >> >> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> >> >> index 473e09d..10f9c43 100644
> >> >> --- a/fs/eventpoll.c
> >> >> +++ b/fs/eventpoll.c
> >> >> @@ -1820,8 +1820,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
> >> >>               goto error_tgt_fput;
> >> >>
> >> >>       /* Check if EPOLLWAKEUP is allowed */
> >> >> -     if ((epds.events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
> >> >> -             epds.events &= ~EPOLLWAKEUP;
> >> >> +     ep_epollwakeup_check(&epds.events);
> >> >
> >> > The "check" part of the name kind of suggests that the function will not change
> >> > things.  What about ep_adjust_epollwakeup() or something along these lines?
> >>
> >> I see couple of ep_set_* functions in eventpoll.c. Does it make sense
> >> to have something like ep_set_epollwakeup()?
> >
> > This particular one doesn't really set anything.  I suppose that a name like
> > "ep_take_care_of_epollwakeup" might be somewhat closer to what it really does ...
> 
> I'm running out of ideas on this one, lets go with
> "ep_take_care_of_epollwakeup".

Well, that's fine by me, if no one else has any better ideas.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
