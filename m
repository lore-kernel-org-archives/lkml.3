Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3A3Ivp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:51:45 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:46683 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab3A3Ivn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:51:43 -0500
MIME-Version: 1.0
In-Reply-To: <20130129010029.GY30577@one.firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org>
	<1359151245-13179-8-git-send-email-andi@firstfloor.org>
	<CABPqkBTM8w_RVrQNiyhBprMBjL5a0Q7Y9KQsKP3Ld62EZPSufQ@mail.gmail.com>
	<20130128231659.GW30577@one.firstfloor.org>
	<CABPqkBS=1gQCiWRQYJ8Y0QqFLvmkf0NiRivK-xpFmqwpXwyByA@mail.gmail.com>
	<20130129010029.GY30577@one.firstfloor.org>
Date: Wed, 30 Jan 2013 09:51:42 +0100
Message-ID: <CABPqkBTUfwTcG5U_LMAz6MKDHiCbCkTs5yzqYiRBqcWkJDzDew@mail.gmail.com>
Subject: Re: [PATCH 07/12] perf, x86: Avoid checkpointed counters causing
 excessive TSX aborts v3
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 2:00 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> On Tue, Jan 29, 2013 at 01:30:19AM +0100, Stephane Eranian wrote:
> > >> The counter is reinstated to its state before the critical section but
> > >> the PMI cannot be
> > >> cancelled and there is no state left behind to tell what to do with it.
> > >
> > > The PMI is effectively spurious, but we use it to set back. Don't know
> > > what you mean with "cancel". It already happened of course.
> > >
> > But when you do this, it seems you making INT_CP events unusable
> > for sampling, because you're resetting their value under the cover.
> > So what happens when you sample, especially with a fixed period?
>
> Sampling is forbidden for checkpointed events, the setup code
> enforces that. It's unlikely to be useful anyways.
>
> The main use case for checkpointing is perf stat -T and related
> counting usages.
>
> > >>
> > >> > +               if (event->attr.sample_period > 0 &&
> > >> > +                   event->attr.sample_period < 0x7fffffff)
> > >> > +                       return -EIO;
> > >> > +       }
> > Explain the 0x7fffffff to me? Is that the max period set by default when you
> > just count?
>
> Originally I had just > 0, but then I found that perf stat from the
> guest doesn't work anymore because it sets an very high overflow
> to accumulate counters.
>
> The 0x7fffffff is a somewhat arbitary threshold to detect this case.
>
When I come in with the default frequency mode, then sample_period
is a frequency and not a period anymore. So I could do:

$ perf record -F 100 -e instructions:intx_cp ....

sample_period = 100; freq=1;

That's a very low sampling rate, yet I think it would be rejected by your code.
But I guess in frequency mode, there is no guarantee on the period. The kernel
may lower the period to 1 in an attempt to achieve the desired rate for the tick
period. And that may cause the spurious interrupts.

But if I come in with frequency 0x7fffffff+1, then that's a very high
frequency, thus
small period, I would pass the test. So I think you need to reinforce the test
for freq=1.
