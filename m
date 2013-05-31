Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab3EaQIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:08:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab3EaQIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:08:05 -0400
Date: Fri, 31 May 2013 18:04:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: 1533963612@qq.com, john.stultz@linaro.org, linux-kernel@vger.kernel.org
Subject: man 7 signal && delivering order
Message-ID: <20130531160404.GA30121@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

could you please look at

	https://bugzilla.kernel.org/show_bug.cgi?id=58711

?

This part of man 7 signal

       3.  Real-time signals are delivered in a  guaranteed  order.   Multiple
           real-time  signals of the same type are delivered in the order they
           were sent.  If different real-time signals are sent to  a  process,
           they  are  delivered  starting  with  the  lowest-numbered  signal.
           (I.e., low-numbered signals have highest priority.)

looks really confusing.

Yes, the kernel delivers (in fact, the task dequeus) them in order,
but this doesn't mean that the signal handlers will run in the same
order.

And let me repeat, whatever the kernel does, depending on the timing
kill(task, 62) + kill(task, 63) can "call" the signal handlers in any
order (as it seen by task). Unless this task plays with sa_mask or the
sender knows that at least SIG_63 is blocked.

Well. of course we could change dequeue_signal()->next_signal() so that,
say, SIG_63 will be chosen before SIG_62, this will "fix" the test-case.
But at the same time, this will break sigtimedwait().

Oleg.

