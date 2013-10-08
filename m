Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3JHOlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:41:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab3JHOlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:41:01 -0400
Date: Tue, 8 Oct 2013 16:34:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131008143400.GA14721@redhat.com>
References: <20131005234430.GA22485@localhost> <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll try to find other messages to understand what you are talking
about, just one note for now....

On 10/07, Linus Torvalds wrote:
>
> Your oops makes very little sense, it looks like task_work_run() just
> called out to random crap, probably because the work was already
> released, so "work->func()" ends up being bad.

Or task_work_run() can hit work->func == NULL if do_exit() is called
twice if, say, the task does BUG() after exit_task_work().

> participants anyway, just in case there is some race. The comment says
> that it can race with task_work_cancel() playing with *work. Oleg,
> comments?

The comment tries to say that if we are racing with task_work_cancel()
it can't delete the first entry == work, we won the race, its
cmpxchg(task->task_works) should fail.

Howver, task_work_cancel() can delete one of the next entries and
change, say, work->next. And we need to wait anyway if it scans this
list.

I'll try to recheck, but so far I do not see anything wrong.

Oleg.

