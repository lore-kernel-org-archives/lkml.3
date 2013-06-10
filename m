Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3FJTsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:48:43 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:63779 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3FJTsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:48:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130610183300.GA14379@redhat.com>
References: <20130610183300.GA14379@redhat.com>
Date: Mon, 10 Jun 2013 12:48:42 -0700
X-Google-Sender-Auth: 6hMhF4FnM0_k4GO0xZA2M0gMyO8
Message-ID: <CANcMJZCr+Jr+J495MHX+1wnet_UtM6hSR+mgAGMma_YvLaxn4A@mail.gmail.com>
Subject: Re: [PATCH 0/3] de_thread() should update ->real_start_time
From: John Stultz <john.stultz@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tomas Janousek <tjanouse@redhat.com>,
        Tomas Smetana <tsmetana@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 11:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> 1/3 is the obvious bugfix, 2 and 3 are minor cleanups

Acked-by: John Stultz <john.stultz@linaro.org> for these three patches.



> I am wondering, can't we kill task->real_start_time? What if we

Yea this sounds like a good idea.  Additionally the name
real_start_time is also confusing, since it naively  seems it might be
the CLOCK_REALTIME start time, which is incorrect.

> simply change copy_process
>
>         -       do_posix_clock_monotonic_gettime(&p->start_time);
>         +       get_monotonic_boottime(&p->start_time);
>
> ?
>
> Afaics, this will only affect do_acct_process() and bacct_add_tsk(),
> but do we really want to exclude the suspended time in this case?

So bacct_add_tsk seems easy to change, since its just:
    do_posix_clock_monotonic_gettime(&uptime);
    ts = timespec_sub(uptime, tsk->start_time);

So grabbing the monotonic boot time for uptime would provide the same
relative delta.

It looks like the same is true in do_acct_process().

> Another user of ->start_time is cgroup.c and it looks wrong... But
> the change above should not make any difference.

The cgroup usage I'm unfamiliar with. Though from the comments in the
code, it seems like using boottime would be ok for this.

thanks
-john
