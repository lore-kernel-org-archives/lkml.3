Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab3BWTY2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 14:24:28 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:45436 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278Ab3BWTY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 14:24:27 -0500
MIME-Version: 1.0
In-Reply-To: <20130223182059.GA23049@somewhere>
References: <1361496971-16939-1-git-send-email-fweisbec@gmail.com>
	<1361496971-16939-3-git-send-email-fweisbec@gmail.com>
	<alpine.LFD.2.02.1302221528470.22263@ionos>
	<20130222150444.GD18149@somewhere.redhat.com>
	<alpine.LFD.2.02.1302221605520.22263@ionos>
	<CA+55aFxOreKQ-uzfMtXEb6XH4D8By2i=qOxfDLJnchSYsa34PQ@mail.gmail.com>
	<20130223182059.GA23049@somewhere>
Date: Sat, 23 Feb 2013 11:24:26 -0800
X-Google-Sender-Auth: CEGZU-JgossKkn0zmc5oczjHF9o
Message-ID: <CA+55aFzQ+7_oLgp6Evdn0yiJYO9psOpdMbZMy7goXktLsBYUYg@mail.gmail.com>
Subject: Re: [PATCH 2/2] irq: Cleanup context state transitions in irq_exit()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 10:21 AM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
>
> But tick_nohz_irq_exit() may trigger the timer softirq itself.

Suggestion: merge it with the whole softirq handler.

The softirq code *already* knows about the whole "oops, one softirq
may trigger another" issue, and has a loop - with protection against
excess - for exactly this reason. See the whole "goto restart" thing.

And tick_nohz_irq_exit() really has very similar semantics to
softiq's, it's just "CPU is idle and no pending reschedule" instead of
a softirq. But the basic rules are the same ("only run this at the
top-level context when exiting the last irq").

So maybe the right thing to do is move the whole "goto restart" one
level up, and do softirq's and tick_nohz_irq_exit both inside that
loop.

              Linus
