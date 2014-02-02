Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaBBQuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 11:50:35 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:65252 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaBBQue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 11:50:34 -0500
MIME-Version: 1.0
In-Reply-To: <20140201165122.GA7478@redhat.com>
References: <1390895840.8373.2.camel@beeld>
	<20140128164320.GB7596@redhat.com>
	<CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com>
	<20140129145535.GA12562@redhat.com>
	<CADZ9YHjEfEWJx5z_5KZnfQAVHXY3u613XV7vdZqjts4zFR3_=g@mail.gmail.com>
	<20140129183204.GA22808@redhat.com>
	<CADZ9YHj4D7aDAznt5rWvn45aVXZ8r-c+G0EeaH6AGdE_TLu9Bg@mail.gmail.com>
	<CADZ9YHgYsibaVm9c+Ho+XXZKxZatHY-+pm=w+jj0EQ94qfFt5Q@mail.gmail.com>
	<20140201165122.GA7478@redhat.com>
Date: Sun, 2 Feb 2014 22:50:32 +0600
Message-ID: <CADZ9YHg-8XrQ0p+uQNRNBhvnHE83xVxLKais0DrT9vfoQvm=uA@mail.gmail.com>
Subject: Re: Do we really need curr_target in signal_struct ?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 10:51 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/01, Rakib Mullick wrote:
>>
>> On Thu, Jan 30, 2014 at 1:02 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>> > On Thu, Jan 30, 2014 at 12:32 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >> On 01/29, Rakib Mullick wrote:
>> >
>> >>> Are you thinking that , since things are not broken, then we shouldn't
>> >>> try to do anything?
>> >>
>> >> Hmm. No.
>> >>
>> >> I am thinking that, since you misunderstood the purpose of ->curr_target,
>> >> I should probably try to argue with your patch which blindly removes this
>> >> optimization ?
>> >>
>> > Since the optimization (usages of ->curr_target) isn't perfect, so there's
>> > chance of being misunderstood. This optimization is misleading too (I think),
>> > cause curr_target don't have anything to do with wants_signal()
>
> can't understand... curr_target is obviously connected to wants_signal() ?
No. I meant, curr_target doesn't makes sure that it really wants the
signal, it's likely
choice.

> As I already said it caches the last wants_signal(t) thread?
Yes, you said. But, gets messed up at exit path, not useful everytime.
If fails, p gets checked twice.

>> > and
>> >  ->curr_target is used only for this optimization and to get this optimization
>> > needs to maintain it properly, and this maintenance does have cost and if
>> > we don't get benefited too much, then it doesn't worth it (my pov).
>
> but you need to prove this somehow.
>
Right, I'll try, I'll do it as per my understanding and everyone might
not agree.

>> I took a look and found that using while_each_thread()
>> can make things better than current.
>
> Why?
>
using while_each_thread() we can start thread traversing from p, which
is a likely
pick and also gets away from redundant checking of p.

>> What do you think?
>
> The patch is technically wrong, a group-wide signal doesn't check all
> threads after this change.
If group is empty, we don't need to check other than t.

> And I do not understand why complete_signal()
> still updates ->curr_target.
Didn't want to remove it blindly :-/

> Plus thread_group_empty() doesn't buy too
> much if we use while_each_thread(). But this doesn't really matter, easy
> to fix.
>
> Rakib. It is not that I like ->curr_target very much. But let me repeat,
> if you want to remove this optimization you need to explain why it doesn't
> make sense. You claim that this "can make things better" without any
> argument.
>
Well, I had other way of looking at it and didn't find any real usages
of ->curr_target and got confused though the code comment in curr_target.

> As for me - I simply do not know. This logic is very old, I am not even
> sure that the current usage of ->curr_signal matches the original intent.
> But it can obviously help in some cases, and you need to explain why we
> do not care.
>
Actually, this is exactly what i wanted to know. What is the purpose
of ->curr_signal, *do we really need it?* If I knew or seen any reason
I'd have never asked this question. You guys knows this domain better than
me, that's why I asked. Git log didn't help much, neither it's documentation
. As a result, I asked and thought about cleaning it up, (as i rarely do if
it meets my capability of course), so appended a sort of rough patch.

> So I won't argue if you submit the technically correct patch, but you
> need to convince Andrew or Ingo to take it. I think the right change in
> complete_signal() is something like below. It can be even simpler and use
> the single do/while loop, but then we need to check "group" inside that
> loop. With the change below ->curr_target can be simply removed.
>
I'll try to make points to convince Andrew or Ingo, I'll try to show
up my points,
and the rest will be upon them.

And here's what i think about ->curr_target removal (as per my understanding):

 a) ->curr_target is only might be useful in group wide case.
 b) Usually signals are sent particularly to a thread so ->curr_signal
 doesn't makes sense.
 c) If ->curr_signal pointed thread is killed, curr_signal points to
the next thread,
but nothing can make sure that it's a right pick.
 d) also current in implementation p is checked twice.
 e) One use case of ->curr_signal is, it always points to the lastly
created thread,
as it's a better candidate for want_signal cause newly created thread don't
usually have any signal pending. We can acheive the same without ->curr_signal
by traversing thread group from the lastly created thread.

So, this is what I think. Let me know if these reason's looks reasonable to you,
cause before Ingo or Andrew taking it, it requires your ack.

Thanks,
Rakib.
