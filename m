Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab3BWTm6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 14:42:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698Ab3BWTmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 14:42:55 -0500
Date: Sat, 23 Feb 2013 20:41:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>,
        adurbin@chromium.org
Subject: Re: [PATCH 4/5] freezer: clear fake signal on exit from
	__refrigerator
Message-ID: <20130223194125.GB9405@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org> <1361008406-2307-4-git-send-email-msb@chromium.org> <20130216170644.GD4910@redhat.com> <20130216171228.GF4910@redhat.com> <CACBanvoArjZ=7rjXjt5fN6MrhLohPY7NAjQwhWepnMLZbqpHdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACBanvoArjZ=7rjXjt5fN6MrhLohPY7NAjQwhWepnMLZbqpHdQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Mandeep Singh Baines wrote:
>
> I think we need something like this in order to be able to fix
> wait_event_freezable and friends. Here is one idea:
>
> #define __wait_event_freezable(wq, condition, ret)                  \
> do {                                                                    \
>         DEFINE_WAIT(__wait);                                            \
>                                                                         \
>         for (;;) {                                                      \
>                 prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);      \
>                 if (condition)                                          \
>                         break;                                          \
>                 if (!signal_pending(current)) {                         \
>                         freezable_schedule();

...

> If you cleaned up the fake signal in __refrigerator()

Perhaps. Or we can add recalc_sigpending into wait_freezable().
But note that

	if (!signal_pending(current))
		freezable_schedule();

is not actually right, wait_event_freezable() should be interruptible,
but not by freezer.

And let me repeat, as for coredump this can only solve the problems in
wait_for_dump_handler(). As for other users, I simply do not see any
valid user today, so perhaps wait_event_freezable() should die... Or
I missed something.

I'll try to make the coredumping fixes tomorrow, then we discuss this
again.

Oleg.

