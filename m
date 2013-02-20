Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab3BTSJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:09:17 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:42368 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab3BTSJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:09:15 -0500
MIME-Version: 1.0
In-Reply-To: <20130216171228.GF4910@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org>
	<1361008406-2307-4-git-send-email-msb@chromium.org>
	<20130216170644.GD4910@redhat.com>
	<20130216171228.GF4910@redhat.com>
Date: Wed, 20 Feb 2013 10:09:14 -0800
X-Google-Sender-Auth: 5pA9PhRRyf0r7Uii6dI2_kSDsnc
Message-ID: <CACBanvoArjZ=7rjXjt5fN6MrhLohPY7NAjQwhWepnMLZbqpHdQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] freezer: clear fake signal on exit from __refrigerator
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>,
        adurbin@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 9:12 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Forgot to mention...
>
> On 02/16, Oleg Nesterov wrote:
>> On 02/16, Mandeep Singh Baines wrote:
>> >
>> > --- a/kernel/freezer.c
>> > +++ b/kernel/freezer.c
>> > @@ -81,6 +81,9 @@ bool __refrigerator(bool check_kthr_stop)
>> >      */
>> >     set_current_state(save);
>> >
>> > +   /* Clear fake signal from freeze_task(). */
>> > +   recalc_sigpending();
>>
>> NACK. We can't do this lockless.
>>
>> And I am not sure we should reinstantiate it here.
>
> And note that with the fix I propose in reply to 5/5 this change is
> not needed.
>

I think we need something like this in order to be able to fix
wait_event_freezable and friends. Here is one idea:

#define __wait_event_freezable(wq, condition, ret)                  \
do {                                                                    \
        DEFINE_WAIT(__wait);                                            \
                                                                        \
        for (;;) {                                                      \
                prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);      \
                if (condition)                                          \
                        break;                                          \
                if (!signal_pending(current)) {                         \
                        freezable_schedule();
           \
                        continue;                                       \
                }                                                       \
                ret = -ERESTARTSYS;                                     \
                break;                                                  \
        }                                                               \
        finish_wait(&wq, &__wait);                                      \
} while (0)


#define wait_event_freezable(wq, condition)                         \
({                                                                      \
        int __ret = 0;                                                  \
        if (!(condition))                                               \
                __wait_event_freezable(wq, condition, __ret);       \
        __ret;                                                          \
})


If you cleaned up the fake signal in __refrigerator() then this
implementation of wait_event_freezable should address all the fake
signal bugs.
By the time you get to signal_pending() the fake signal is cleared and
the bug it avoided.

Regards,
Mandeep

> Oleg.
>
