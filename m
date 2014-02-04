Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaBDEdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 23:33:08 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:52127 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaBDEc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 23:32:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140203163921.GA25698@redhat.com>
References: <1390895840.8373.2.camel@beeld>
	<20140128164320.GB7596@redhat.com>
	<CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com>
	<20140129145535.GA12562@redhat.com>
	<CADZ9YHjEfEWJx5z_5KZnfQAVHXY3u613XV7vdZqjts4zFR3_=g@mail.gmail.com>
	<20140129183204.GA22808@redhat.com>
	<CADZ9YHj4D7aDAznt5rWvn45aVXZ8r-c+G0EeaH6AGdE_TLu9Bg@mail.gmail.com>
	<CADZ9YHgYsibaVm9c+Ho+XXZKxZatHY-+pm=w+jj0EQ94qfFt5Q@mail.gmail.com>
	<20140201165122.GA7478@redhat.com>
	<CADZ9YHg-8XrQ0p+uQNRNBhvnHE83xVxLKais0DrT9vfoQvm=uA@mail.gmail.com>
	<20140203163921.GA25698@redhat.com>
Date: Tue, 4 Feb 2014 10:32:57 +0600
Message-ID: <CADZ9YHgeKjgffbrfRMOzDZu7qv4YVMzLhQz3NDya827=gsvJ5g@mail.gmail.com>
Subject: Re: Do we really need curr_target in signal_struct ?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 10:39 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/02, Rakib Mullick wrote:
>
>> > As I already said it caches the last wants_signal(t) thread?
>> Yes, you said. But, gets messed up at exit path, not useful everytime.
>
> Yes.
>
>> If fails, p gets checked twice.
>
> Yes, but this is minor, I think.
>
Right.

>> >> I took a look and found that using while_each_thread()
>> >> can make things better than current.
>> >
>> > Why?
>> >
>> using while_each_thread() we can start thread traversing from p, which
>> is a likely
>> pick and also gets away from redundant checking of p.
>
> Heh. We always check "p" first. And (in general) we do not want to start
> from "p" if we want to find a wants_signal() thread, and ->curr_target can
> help to avoid this.
>
>> >> What do you think?
>> >
>> > The patch is technically wrong, a group-wide signal doesn't check all
>> > threads after this change.
>> If group is empty, we don't need to check other than t.
>
> I didn't meant the thread_group_empty() case. Please look at your code:
>
>
>         if (!group || thread_group_empty(p)) {
>                 if (wants_signal(sig, t))
>                         goto found;
>         } else {
>                 while_each_thread(p, t) {
>                         if (wants_signal(sig, t))
>                                 goto found;
>                 }
>         }
>
> Suppose that group == T, thread_group_empty(p) == F. Suppose that all
> sub-threads except "p" blocked this signal. With this change "p" (and
> thus the whole thread group) won't be notified. IOW, with your change
> we do not check "p" at all. This is wrong.
>
Oh, sorry, my bad. That was wrong.

> The only user of ->curr_target is complete_signal(), you have found it.
>
Indeed.

>
> I can only read the current code. I do not know the original intent.
>
This is where things are confusing.


> Really?
>
Sometimes, 100% correct (!group case) ;-).

>
> Yes (except a thread can't be killed), so what? Obviously, if ->curr_targer
> exits we should update this pointer. We could even nullify it.
>
That's makes ->curr_target less useful, that's what I meant.

>
> Yes, "p" can be checked twice. I don't think this is that bad, and I
> do not think this particular "problem" should be fixed.
>
Yes, it's minor.

>
> I simply can't understand. Why? I do not think so.
>
Cause, want_signal logic checks these thread attributes to find whether it's
eligible or not.

>> We can acheive the same without ->curr_signal
>> by traversing thread group from the lastly created thread.
>
> We certainly can't "achieve the same" this way, although I am not sure
> what this "the same" actually means.
>
>> So, this is what I think. Let me know if these reason's looks reasonable to you,
>
> No. Contrary, whatever I personally think about ->curr_signal, I feel
> that you do not understand the code you are trying to change. Sorry,
> I can be wrong. But I still do not see any argument.
>
Yes, right. I do not fully understand this code, also how it exactly puts impact
on signaling subsystems. And, therefore, I think I should not make any
changes in this code.

>> cause before Ingo or Andrew taking it, it requires your ack.
>
> Not really. And of course I'll review the patch correctness-wise, and
> I already sent the change in complete_signal() which looks right to me.
>
> But I am not going to ack the behaviour change, simply because I have
> no idea how this can impact the existing applications. Perhaps nobody
> will notice this change, but we can't know this.
>
Yes, I'm not also sure about the behavior change and it's impact over
existing applications, so, I'm skipping it.

I usually try to make small fixes, cleanup; cause it's less error-prone and
requires less follow-up. Since the things here becoming sort of "don't know"
thing, I think I should stop. But, thank you for helping and replying in this
thread.

Again thanks,
Rakib.
