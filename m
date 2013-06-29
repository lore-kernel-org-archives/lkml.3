Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab3F2WXv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 18:23:51 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:36022 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3F2WXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 18:23:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130629201311.GA23838@redhat.com>
References: <20130624173510.GA1321@redhat.com>
	<20130625153520.GA7784@redhat.com>
	<20130626191853.GA29049@redhat.com>
	<20130627002255.GA16553@redhat.com>
	<20130627075543.GA32195@dastard>
	<20130627100612.GA29338@dastard>
	<20130627125218.GB32195@dastard>
	<20130627152151.GA11551@redhat.com>
	<20130628011301.GC32195@dastard>
	<20130628035825.GC29338@dastard>
	<20130629201311.GA23838@redhat.com>
Date: Sat, 29 Jun 2013 15:23:48 -0700
X-Google-Sender-Auth: xMCG-TV_P72Ay5TtKC48wqzWyFU
Message-ID: <CA+55aFz8rz=c8DsNHpBJW1K=FH-ztuPAMNOoGfM6HQyZByQ9mQ@mail.gmail.com>
Subject: Re: frequent softlockups with 3.10rc6.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 1:13 PM, Dave Jones <davej@redhat.com> wrote:
>
> So with that patch, those two boxes have now been fuzzing away for
> over 24hrs without seeing that specific sync related bug.

Ok, so at least that confirms that yes, the problem is the excessive
contention on inode_sb_list_lock.

Ugh. There's no way we can do that patch by DaveC for 3.10. Not only
is it scary, Andi pointed out that it's actively buggy and will miss
inodes that need writeback due to moving things to private lists.

So I suspect we'll have to do 3.10 with this starvation issue in
place, and mark for stable backporting whatever eventual fix we find.

> I did see the trace below, but I think that's a different problem..
> Not sure who to point at for that one though. Linus?

Hmm.

> [ 1583.293952] RIP: 0010:[<ffffffff810dd856>]  [<ffffffff810dd856>] stop_machine_cpu_stop+0x86/0x110

I'm not sure how sane the watchdog is over stop_machine situations. I
think we disable the watchdog for suspend/resume exactly because
stop-machine can take almost arbitrarily long. I'm assuming you're
stress-testing (perhaps unintentionally) the cpu offlining/onlining
and/or memory migration, which is just fundamentally big expensive
things.

Does the machine recover? Because if it does, I'd be inclined to just
ignore it. Although it would be interesting to hear what triggers this
- normal users - and I'm assuming you're still running trinity as
non-root - generally should not be able to trigger stop-machine
events..

                  Linus
