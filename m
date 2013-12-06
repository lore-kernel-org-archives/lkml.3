Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3LFQeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:34:11 -0500
Received: from forward5m.mail.yandex.net ([37.140.138.5]:45330 "EHLO
	forward5m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3LFQeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:34:09 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1386343162-53574-1-git-send-email-paul.gortmaker@windriver.com>
References: <1386343162-53574-1-git-send-email-paul.gortmaker@windriver.com>
Subject: Re: [RFC 0/1] wait queue head; locking considerations
MIME-Version: 1.0
Message-Id: <7411386347644@web22m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 06 Dec 2013 20:34:04 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

06.12.2013, 19:24, "Paul Gortmaker" <paul.gortmaker@windriver.com>:
> Peter pointed out[1] that the simple wait queues in RT could
> run any number of wakeups with the wait queue head lock held.
>
> It turns out that this isnt really specific to RT, but it is
> mainline too -- all the __wake_up_XYZ that in turn use the
> __wake_up_common boiler plate end up looping over all the
> callbacks (normally ttwu) while holding the head lock.
<snip>

One more problem with wait queues in RT case.

Wait queues moving from spinlocks to rt_mutexes makes timerfd
not irqsafe on RT. This makes it unusable for some user tasks.

> šfs/timerfd.c šššššššššššššššššššššššššššššššššššššš| 26 ++++++-------
> šinclude/linux/wait.h šššššššššššššššššššššššššššššš| 36 +++++++++++++++---
> škernel/sched/completion.c ššššššššššššššššššššššššš| 24 ++++++------
> škernel/sched/core.c ššššššššššššššššššššššššššššššš| š8 ++--
> škernel/sched/wait.c ššššššššššššššššššššššššššššššš| 44 +++++++++++-----------
> šmm/filemap.c šššššššššššššššššššššššššššššššššššššš| š4 +-
> šnet/sunrpc/sched.c šššššššššššššššššššššššššššššššš| š4 +-
> š14 files changed, 150 insertions(+), 126 deletions(-)
