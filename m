Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935524Ab3DINVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:21:53 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:63681 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447Ab3DINVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:21:51 -0400
MIME-Version: 1.0
In-Reply-To: <1365499591.30071.3.camel@laptop>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
	<1365266760-24725-3-git-send-email-fweisbec@gmail.com>
	<1365499591.30071.3.camel@laptop>
Date: Tue, 9 Apr 2013 15:21:49 +0200
Message-ID: <CAFTL4hxcQyv_J4ky8wL0rzVemWPpBcjuCV=FeHBvXn5Bht-3OA@mail.gmail.com>
Subject: Re: [PATCH 2/7] sched: Update rq clock on nohz CPU before setting
 fair group shares
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/9 Peter Zijlstra <peterz@infradead.org>:
> On Sat, 2013-04-06 at 18:45 +0200, Frederic Weisbecker wrote:
>> Because we may update the execution time (sched_group_set_shares()->
>>         update_cfs_shares()->reweight_entity()->update_curr()) before
>> reweighting the entity after updating the group shares and this
>> requires
>> an uptodate version of the runqueue clock. Let's update it on the
>> target
>> CPU if it runs tickless because scheduler_tick() is not there to
>> maintain
>> it.
>
> Same as the last comment, we should never rely on the tick to update
> ->clock except for the work done by the tick itself.

Ok!

>
> Therefore you seem to have found another missing clock update.

Yep, as in the other patches I believe, I'll reiterate that by
removing that rely-on-tick assumption.

> The problem seems to be that we haven't been able to come up with a
> sane debug framework for the ->clock updates. But we should have at
> least one (and preferably no more) update_sched_clock() calls per
> scheduler entry point.

I'll check if I can factorize some update_rq_clock() calls on some
upper sched_class callback wrappers. Many of them have that update
before calling the callbacks already. But there may be a few missing.
I'll check the other sched entrypoints as well.

Also please check those two patches in my series, it's a draft for an
rq clock debug framework. For now it's just a brainless stale clock
check but that's a start:

* http://thread.gmane.org/gmane.linux.kernel/1470769/focus=1470786
* http://thread.gmane.org/gmane.linux.kernel/1470769/focus=1470750
