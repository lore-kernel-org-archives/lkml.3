Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbaBAQvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 11:51:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320AbaBAQvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 11:51:12 -0500
Date: Sat, 1 Feb 2014 17:51:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Do we really need curr_target in signal_struct ?
Message-ID: <20140201165122.GA7478@redhat.com>
References: <1390895840.8373.2.camel@beeld> <20140128164320.GB7596@redhat.com> <CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com> <20140129145535.GA12562@redhat.com> <CADZ9YHjEfEWJx5z_5KZnfQAVHXY3u613XV7vdZqjts4zFR3_=g@mail.gmail.com> <20140129183204.GA22808@redhat.com> <CADZ9YHj4D7aDAznt5rWvn45aVXZ8r-c+G0EeaH6AGdE_TLu9Bg@mail.gmail.com> <CADZ9YHgYsibaVm9c+Ho+XXZKxZatHY-+pm=w+jj0EQ94qfFt5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADZ9YHgYsibaVm9c+Ho+XXZKxZatHY-+pm=w+jj0EQ94qfFt5Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, Rakib Mullick wrote:
>
> On Thu, Jan 30, 2014 at 1:02 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> > On Thu, Jan 30, 2014 at 12:32 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> On 01/29, Rakib Mullick wrote:
> >
> >>> Are you thinking that , since things are not broken, then we shouldn't
> >>> try to do anything?
> >>
> >> Hmm. No.
> >>
> >> I am thinking that, since you misunderstood the purpose of ->curr_target,
> >> I should probably try to argue with your patch which blindly removes this
> >> optimization ?
> >>
> > Since the optimization (usages of ->curr_target) isn't perfect, so there's
> > chance of being misunderstood. This optimization is misleading too (I think),
> > cause curr_target don't have anything to do with wants_signal()

can't understand... curr_target is obviously connected to wants_signal() ?
As I already said it caches the last wants_signal(t) thread?

> > and
> >  ->curr_target is used only for this optimization and to get this optimization
> > needs to maintain it properly, and this maintenance does have cost and if
> > we don't get benefited too much, then it doesn't worth it (my pov).

but you need to prove this somehow.

> I took a look and found that using while_each_thread()
> can make things better than current.

Why?

> What do you think?

The patch is technically wrong, a group-wide signal doesn't check all
threads after this change. And I do not understand why complete_signal()
still updates ->curr_target. Plus thread_group_empty() doesn't buy too
much if we use while_each_thread(). But this doesn't really matter, easy
to fix.

Rakib. It is not that I like ->curr_target very much. But let me repeat,
if you want to remove this optimization you need to explain why it doesn't
make sense. You claim that this "can make things better" without any
argument.

As for me - I simply do not know. This logic is very old, I am not even
sure that the current usage of ->curr_signal matches the original intent.
But it can obviously help in some cases, and you need to explain why we
do not care.

So I won't argue if you submit the technically correct patch, but you
need to convince Andrew or Ingo to take it. I think the right change in
complete_signal() is something like below. It can be even simpler and use
the single do/while loop, but then we need to check "group" inside that
loop. With the change below ->curr_target can be simply removed.

Oleg.

--- x/kernel/signal.c
+++ x/kernel/signal.c
@@ -944,7 +944,7 @@ static inline int wants_signal(int sig, 
 static void complete_signal(int sig, struct task_struct *p, int group)
 {
 	struct signal_struct *signal = p->signal;
-	struct task_struct *t;
+	struct task_struct *t = p;
 
 	/*
 	 * Now find a thread we can wake up to take the signal off the queue.
@@ -952,32 +952,16 @@ static void complete_signal(int sig, str
 	 * If the main thread wants the signal, it gets first crack.
 	 * Probably the least surprising to the average bear.
 	 */
-	if (wants_signal(sig, p))
-		t = p;
-	else if (!group || thread_group_empty(p))
-		/*
-		 * There is just one thread and it does not need to be woken.
-		 * It will dequeue unblocked signals before it runs again.
-		 */
-		return;
-	else {
-		/*
-		 * Otherwise try to find a suitable thread.
-		 */
-		t = signal->curr_target;
-		while (!wants_signal(sig, t)) {
-			t = next_thread(t);
-			if (t == signal->curr_target)
-				/*
-				 * No thread needs to be woken.
-				 * Any eligible threads will see
-				 * the signal in the queue soon.
-				 */
-				return;
+	if (!wants_signal(sig, t)) {
+		if (group) {
+			while_each_thread(p, t) {
+				if (wants_signal(sig, t))
+					goto notify;
+			}
 		}
-		signal->curr_target = t;
+		return;
 	}
-
+ notify:
 	/*
 	 * Found a killable thread.  If the signal will be fatal,
 	 * then start taking the whole group down immediately.

