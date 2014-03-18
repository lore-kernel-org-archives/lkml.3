Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaCRPsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:48:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbaCRPsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:48:18 -0400
Date: Tue, 18 Mar 2014 16:47:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Peng Tao <bergwolf@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
Message-ID: <20140318154724.GA5669@redhat.com>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com> <20140318133331.GA23193@laptop.programming.kicks-ass.net> <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com> <20140318140504.GD23193@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318140504.GD23193@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18, Peter Zijlstra wrote:
>
> I think we can avoid the entire function if we add
> WQ_FLAG_LIFO and make prepare_to_wait_event() DTRT.

Agreed, this looks very natural.

prepare_to_wait_event(WQ_FLAG_LIFO) should probably skip all "flags == 0"
entries before list_add(). Given that it is supposed that the users won't
mix exclusive and !exclusive, perhaps the additional list_for_each() won't
hurt?

> Then we only need to teach ___wait() about this; and I suppose we could
> make .exclusive=-1 be the LIFO flag.

Or we can change ___wait_event()

	-	if (exclusive)							\
	-		__wait.flags = WQ_FLAG_EXCLUSIVE;			\
	-	else								\
	-		__wait.flags = 0;					\
	+	__wait.flags = exclusive;					\

and obviously change the callers. Perhaps this argument should be renamed
then.

But I am fine either way, just I like the idea to extend the current
interface.

Oleg.

