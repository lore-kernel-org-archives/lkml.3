Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3A2BAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:00:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55016 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3A2BAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:00:32 -0500
Date: Tue, 29 Jan 2013 02:00:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 07/12] perf, x86: Avoid checkpointed counters causing excessive TSX aborts v3
Message-ID: <20130129010029.GY30577@one.firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org> <1359151245-13179-8-git-send-email-andi@firstfloor.org> <CABPqkBTM8w_RVrQNiyhBprMBjL5a0Q7Y9KQsKP3Ld62EZPSufQ@mail.gmail.com> <20130128231659.GW30577@one.firstfloor.org> <CABPqkBS=1gQCiWRQYJ8Y0QqFLvmkf0NiRivK-xpFmqwpXwyByA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS=1gQCiWRQYJ8Y0QqFLvmkf0NiRivK-xpFmqwpXwyByA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 01:30:19AM +0100, Stephane Eranian wrote:
> >> The counter is reinstated to its state before the critical section but
> >> the PMI cannot be
> >> cancelled and there is no state left behind to tell what to do with it.
> >
> > The PMI is effectively spurious, but we use it to set back. Don't know
> > what you mean with "cancel". It already happened of course.
> >
> But when you do this, it seems you making INT_CP events unusable
> for sampling, because you're resetting their value under the cover.
> So what happens when you sample, especially with a fixed period?

Sampling is forbidden for checkpointed events, the setup code
enforces that. It's unlikely to be useful anyways.

The main use case for checkpointing is perf stat -T and related
counting usages.

> >>
> >> > +               if (event->attr.sample_period > 0 &&
> >> > +                   event->attr.sample_period < 0x7fffffff)
> >> > +                       return -EIO;
> >> > +       }
> Explain the 0x7fffffff to me? Is that the max period set by default when you
> just count?

Originally I had just > 0, but then I found that perf stat from the
guest doesn't work anymore because it sets an very high overflow
to accumulate counters.

The 0x7fffffff is a somewhat arbitary threshold to detect this case.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
