Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab3EGJ5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:57:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48861 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab3EGJ5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:57:04 -0400
Date: Tue, 7 May 2013 10:57:16 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Paul Turner <pjt@google.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
Message-ID: <20130507095715.GE4068@e103034-lin>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
 <1367804711-30308-4-git-send-email-alex.shi@intel.com>
 <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com>
 <5187760D.8060900@intel.com>
 <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com>
 <51886460.3020009@intel.com>
 <CAPM31RLsip-PMY73oq58gyi42EQ+-upmPpMQFkukVBX6LTwtCw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPM31RLsip-PMY73oq58gyi42EQ+-upmPpMQFkukVBX6LTwtCw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 07 May 2013 09:57:00.0012 (UTC) FILETIME=[379C92C0:01CE4B09]
X-MC-Unique: 113050710570101601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 04:06:33AM +0100, Paul Turner wrote:
> On Mon, May 6, 2013 at 7:18 PM, Alex Shi <alex.shi@intel.com> wrote:
> > On 05/06/2013 06:17 PM, Paul Turner wrote:
> >>>> >> Rather than exposing the representation of load_avg_contrib to
> >>>> >> __sched_fork it might also be better to call:
> >>>> >>   __update_task_entity_contrib(&p->se)
> >>>> >> After the initialization above; this would also avoid potential bugs
> >>>> >> like the missing scale_load() above.
> >>> >
> >>> > Above simple change can not work.
> >> Could you provide additional detail here?  Note that the sum change I
> >> was suggesting above was:
> >>
> >> __sched_fork():
> >> +       p->se.avg.decay_count = 0;
> >> +       p->se.avg.runnable_avg_period = 1024;
> >> +       p->se.avg.runnable_avg_sum = 1024;
> >> +       __update_task_entity_contrib(&p->se);
> >>
> >> [ Also: move __sched_fork() beyond p->sched_reset_on_fork in sched_fork(). ]
> >
> > Thanks Paul!
> > It seems work with this change if new __sched_fork move after the
> > p->sched_reset_on_fork setting.
> >
> > But why we initial avg sum to 1024? new task may goes to sleep, the
> > initial 1024 give a unreasonable initial value.
> >
> > guess let the task accumulate itself avg sum and period is more natural.
> 
> 1024 is a full single unit period representing ~1ms of time.
> 
> The reason to store a small initial "observation" here is so that as
> when we reach our next period edge our load converges (presumably
> down) towards its true target more smoothly; as well as providing a
> task additional protection from being considered "small" through
> start-up.
> 

Agree. The tracked load of new tasks is often very unstable during first
couple of ms on loaded systems. I'm not sure if 1024 is the right
initial value. It may need to be larger.

Morten

> >>
> >>> > We had talked this solution months ago. And get agreement on this patch.
> >>> > https://lkml.org/lkml/2013/2/20/48  :)
> >> Yes, I made the same suggestion in the last round, see:
> >> https://lkml.org/lkml/2013/2/19/176
> >>
> >> Your reply there seems like an ack of my suggestion, the only
> >> difference I'm seeing is that using __update_task_entity_contrib() as
> >> originally suggested is safer since it keeps the representation of
> >> load_avg_contrib opaque.
> >
> > Yes, using __update_task_entity_contrib make load_avg_contrib opaque.
> > but just initial value 1024 is a bit arbitrary.
> >>
> >
> >
> > --
> > Thanks
> >     Alex
> 

