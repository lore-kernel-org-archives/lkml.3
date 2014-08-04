Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaHDSh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:37:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaHDSh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:37:57 -0400
Date: Mon, 4 Aug 2014 20:35:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 1/7] wait: Provide infrastructure to deal with
	nested blocking
Message-ID: <20140804183500.GA20127@redhat.com>
References: <20140804103025.478913141@infradead.org> <20140804103537.356311360@infradead.org> <20140804134455.GT19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804134455.GT19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Peter Zijlstra wrote:
>
> I just noticed that poll_schedule_timeout() uses set_mb() for clearing
> its triggered variable. But I'm not entirely sure I see why..

At least we need to ensure that this "pwq->triggered = 0" can't be reordered
after the next ->poll() returns 0. In this case we should sleep unless pollwake()
was called and it set "->triggered = 1". So without this mb() we can miss an
event.

But I can hardly understand the "data written before wake up is always visible
after wake up" part... Probably this means that if we didn't actually sleep
because pwq->triggered == 1 we need to ensure that the next ->poll(file) should
see all changes which were the reason for wakeup.

Oleg.

