Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936522Ab3DHObr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:31:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936162Ab3DHObq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:31:46 -0400
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for
 !PREEMPT_COUNT
From: Steven Rostedt <srostedt@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1365428274.2609.160.camel@laptop>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>
	 <1364998282-21437-1-git-send-email-vgupta@synopsys.com>
	 <20130404152808.GB15261@ab42.lan> <515E54BD.2090300@synopsys.com>
	 <51602459.3040105@synopsys.com>
	 <CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com>
	 <51624591.4010303@synopsys.com>
	 <CA+55aFyFWjpSVQM6M266tKrG_ZXJzZ-nYejpmXYQXbrr42mGPQ@mail.gmail.com>
	 <1365428274.2609.160.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Mon, 08 Apr 2013 10:31:10 -0400
Message-ID: <1365431470.2733.16.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 15:37 +0200, Peter Zijlstra wrote:

> That said, I can't remember ever having seen a BUG like this, even
> though !PREEMPT is (or at least was) the most popular distro setting.

It requires gcc reordering the code to where a preempt can happen inside
preempt_disable. And also put in a position where the preempt_disable
code it gets added matters.

Then if gcc does this, we need a page fault to occur with a get_user()
operation, which in practice seldom happens as most get user operations
are done on freshly modified memory.

And then, it would require the page fault to cause a schedule. This is
the most likely of the things needed to occur, but itself is not a
problem.

Then, the schedule would have to cause the data that is being protect by
the preempt_disable() to be corrupted. Either by scheduling in another
process that monkeys with the data. Or if it protects per-cpu data,
scheduling to another CPU (for the SMP case only).

If any of the above does not occur, then you wont see a bug. This is
highly unlikely to happen, but that's no excuse to not fix it. But it
probably explains why we never saw a bug report. Heck, it may have
happened, but it would be hard to reproduce, and just forgotten about.

-- Steve



