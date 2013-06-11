Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab3FKRRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:17:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab3FKRRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:17:04 -0400
Date: Tue, 11 Jun 2013 19:13:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tomas Janousek <tjanouse@redhat.com>,
        Tomas Smetana <tsmetana@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] de_thread() should update ->real_start_time
Message-ID: <20130611171300.GA7920@redhat.com>
References: <20130610183300.GA14379@redhat.com> <CANcMJZCr+Jr+J495MHX+1wnet_UtM6hSR+mgAGMma_YvLaxn4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANcMJZCr+Jr+J495MHX+1wnet_UtM6hSR+mgAGMma_YvLaxn4A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10, John Stultz wrote:
>
> On Mon, Jun 10, 2013 at 11:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > 1/3 is the obvious bugfix, 2 and 3 are minor cleanups
>
> Acked-by: John Stultz <john.stultz@linaro.org> for these three patches.

Thanks!

> > simply change copy_process
> >
> >         -       do_posix_clock_monotonic_gettime(&p->start_time);
> >         +       get_monotonic_boottime(&p->start_time);
> >
> > ?
> >
> > Afaics, this will only affect do_acct_process() and bacct_add_tsk(),
> > but do we really want to exclude the suspended time in this case?
>
> So bacct_add_tsk seems easy to change, since its just:
>     do_posix_clock_monotonic_gettime(&uptime);
>     ts = timespec_sub(uptime, tsk->start_time);
>
> So grabbing the monotonic boot time for uptime would provide the same
> relative delta.

Not really, or I misunderstood monotonic/boottime interaction.

IIUC, monotonic doesn't grow during suspend, so the delta can grow if
we use get_monotonic_boottime() in copy_process() and bacct_add_tsk()
and the system was suspended in between. Right?

But perhaps this is fine and even more correct?

> > Another user of ->start_time is cgroup.c and it looks wrong... But
> > the change above should not make any difference.
>
> The cgroup usage I'm unfamiliar with. Though from the comments in the
> code, it seems like using boottime would be ok for this.

Yes, this change can't make any difference. But this code looks wrong
although I'll try to recheck later.  We can't trust started_after()
exactly because ->start_time can be changed by mt-exec. But this is
offtopic.


> An additional thought: task_struct covers quite a bit of stuff, so I
> don't know if this would be too useful, but we could further change
> start_time to be a ktime_t, allowing possible additional space savings
> in the task_struct on 64bit systems.

Agreed.

Oleg.


