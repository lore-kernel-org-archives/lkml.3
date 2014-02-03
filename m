Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaBCQuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:50:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaBCQt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:49:58 -0500
Date: Mon, 3 Feb 2014 17:39:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Do we really need curr_target in signal_struct ?
Message-ID: <20140203163921.GA25698@redhat.com>
References: <1390895840.8373.2.camel@beeld> <20140128164320.GB7596@redhat.com> <CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com> <20140129145535.GA12562@redhat.com> <CADZ9YHjEfEWJx5z_5KZnfQAVHXY3u613XV7vdZqjts4zFR3_=g@mail.gmail.com> <20140129183204.GA22808@redhat.com> <CADZ9YHj4D7aDAznt5rWvn45aVXZ8r-c+G0EeaH6AGdE_TLu9Bg@mail.gmail.com> <CADZ9YHgYsibaVm9c+Ho+XXZKxZatHY-+pm=w+jj0EQ94qfFt5Q@mail.gmail.com> <20140201165122.GA7478@redhat.com> <CADZ9YHg-8XrQ0p+uQNRNBhvnHE83xVxLKais0DrT9vfoQvm=uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADZ9YHg-8XrQ0p+uQNRNBhvnHE83xVxLKais0DrT9vfoQvm=uA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02, Rakib Mullick wrote:
>
> On Sat, Feb 1, 2014 at 10:51 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 02/01, Rakib Mullick wrote:
> >>
> >> > Since the optimization (usages of ->curr_target) isn't perfect, so there's
> >> > chance of being misunderstood. This optimization is misleading too (I think),
> >> > cause curr_target don't have anything to do with wants_signal()
> >
> > can't understand... curr_target is obviously connected to wants_signal() ?
> No. I meant, curr_target doesn't makes sure that it really wants the
> signal, it's likely
> choice.

Sure. But why this is "misleading" and "don't have anything to do with
wants_signal()" ? OK, nevermind.

> > As I already said it caches the last wants_signal(t) thread?
> Yes, you said. But, gets messed up at exit path, not useful everytime.

Yes.

> If fails, p gets checked twice.

Yes, but this is minor, I think.

> >> I took a look and found that using while_each_thread()
> >> can make things better than current.
> >
> > Why?
> >
> using while_each_thread() we can start thread traversing from p, which
> is a likely
> pick and also gets away from redundant checking of p.

Heh. We always check "p" first. And (in general) we do not want to start
from "p" if we want to find a wants_signal() thread, and ->curr_target can
help to avoid this.

> >> What do you think?
> >
> > The patch is technically wrong, a group-wide signal doesn't check all
> > threads after this change.
> If group is empty, we don't need to check other than t.

I didn't meant the thread_group_empty() case. Please look at your code:


	if (!group || thread_group_empty(p)) {
		if (wants_signal(sig, t))
			goto found;
	} else {
		while_each_thread(p, t) {
			if (wants_signal(sig, t))
				goto found;
		}
	}

Suppose that group == T, thread_group_empty(p) == F. Suppose that all
sub-threads except "p" blocked this signal. With this change "p" (and
thus the whole thread group) won't be notified. IOW, with your change
we do not check "p" at all. This is wrong.

> > Rakib. It is not that I like ->curr_target very much. But let me repeat,
> > if you want to remove this optimization you need to explain why it doesn't
> > make sense. You claim that this "can make things better" without any
> > argument.
> >
> Well, I had other way of looking at it and didn't find any real usages
> of ->curr_target and got confused though the code comment in curr_target.

The only user of ->curr_target is complete_signal(), you have found it.

> > As for me - I simply do not know. This logic is very old, I am not even
> > sure that the current usage of ->curr_signal matches the original intent.
> > But it can obviously help in some cases, and you need to explain why we
> > do not care.
> >
> Actually, this is exactly what i wanted to know. What is the purpose
> of ->curr_signal, *do we really need it?* If I knew or seen any reason
> I'd have never asked this question. You guys knows this domain better than
> me, that's why I asked.

I can only read the current code. I do not know the original intent.

> > So I won't argue if you submit the technically correct patch, but you
> > need to convince Andrew or Ingo to take it. I think the right change in
> > complete_signal() is something like below. It can be even simpler and use
> > the single do/while loop, but then we need to check "group" inside that
> > loop. With the change below ->curr_target can be simply removed.
> >
> I'll try to make points to convince Andrew or Ingo, I'll try to show
> up my points,
> and the rest will be upon them.
>
> And here's what i think about ->curr_target removal (as per my understanding):
>
>  a) ->curr_target is only might be useful in group wide case.

Yes.

>  b) Usually signals are sent particularly to a thread

Really?

> so ->curr_signal
> doesn't makes sense.

Well. I do not know what else I can say ;)

>  c) If ->curr_signal pointed thread is killed, curr_signal points to
> the next thread,
> but nothing can make sure that it's a right pick.

Yes (except a thread can't be killed), so what? Obviously, if ->curr_targer
exits we should update this pointer. We could even nullify it.

>  d) also current in implementation p is checked twice.

Yes, "p" can be checked twice. I don't think this is that bad, and I
do not think this particular "problem" should be fixed.

>  e) One use case of ->curr_signal is, it always points to the lastly
> created thread,
> as it's a better candidate for want_signal cause newly created thread don't
> usually have any signal pending.

I simply can't understand. Why? I do not think so.

> We can acheive the same without ->curr_signal
> by traversing thread group from the lastly created thread.

We certainly can't "achieve the same" this way, although I am not sure
what this "the same" actually means.

> So, this is what I think. Let me know if these reason's looks reasonable to you,

No. Contrary, whatever I personally think about ->curr_signal, I feel
that you do not understand the code you are trying to change. Sorry,
I can be wrong. But I still do not see any argument.

> cause before Ingo or Andrew taking it, it requires your ack.

Not really. And of course I'll review the patch correctness-wise, and
I already sent the change in complete_signal() which looks right to me.

But I am not going to ack the behaviour change, simply because I have
no idea how this can impact the existing applications. Perhaps nobody
will notice this change, but we can't know this.

Oleg.

