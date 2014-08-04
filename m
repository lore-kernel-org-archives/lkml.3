Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaHDT0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:26:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaHDT0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:26:36 -0400
Date: Mon, 4 Aug 2014 21:23:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>
Subject: Re: [RFC][PATCH 4/7] inotify: Deal with nested sleeps
Message-ID: <20140804192358.GA23283@redhat.com>
References: <20140804103025.478913141@infradead.org> <20140804103537.564978189@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804103537.564978189@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Peter Zijlstra wrote:
>
>  	while (1) {
> -		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
> -
>  		mutex_lock(&group->notification_mutex);

So yes, even these 2 lines look obviously buggy. Even if
fsnotify_add_notify_event()->wake_up(&group->notification_waitq) uses
TASK_NORMAL, so at least this can't miss an event.

It is too later for me, but I am wondering if we can do another thing.
Something like

		int state;

		prepare_to_wait(wait, TASK_INTERRUPTIBLE);

		PUSH(&wait, state);
		mutex_lock();
		mutex_unlock();
		POP(&wait, state);

and, ignoring all races, lack of barriers, etc

	#define PUSH(w, s)	s = current->state; current->state = RUNNING;

	#define POP(w, s)	current->state = WOKEN(w) ? RUNNING : s;

Probably not... just curious.

Oleg.

