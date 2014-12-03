Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaLCJBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:01:16 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:54340 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaLCJBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:01:15 -0500
From: Alex Dubov <alex.dubov@gmail.com>
X-Google-Original-From: Alex Dubov <oakad@yahoo.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, corbet@lwn.net, richardcochran@gmail.com
Subject: syscall: introduce sendfd() syscall (v.2)
Date: Wed,  3 Dec 2014 20:00:54 +1100
Message-Id: <1417597255-32530-1-git-send-email-oakad@yahoo.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to present my second attempt at file descriptor duplication over
Posix.1b real-time signal transport. All the constructive points raised
in the previous discussion are believed to be addressed.

To this end, I would like to address some concerns raised in the preceding
discussion:

1. Claim: signals as a transport would not scale

Each task_struct allocated by kernel has its own signal queue, reliable, when
Posix.1b signals are concerned. This queue essentially serves as per-task
mail box, enabling complex applications to send signals from each thread to
each thread directly, with very low overhead, and thus avoid any shared
contention points outright (originating task's pid is passed along with
the siginfo data, so source based dispatching is perfectly possible).

Also, signals can be trivially integrated with other communication mediums,
as signalfd() syscall is perfectly compatible with epoll.

2. Claim: adding new functionality to the signal transport will create new
attack/DoS vectors.

Nothing can be further from truth.

2.a. If task A has sufficient capabilities to send signals to task B, then
task A is already in position to do anything it wants with task B, including
killing it outright.

2.b. Flood attacks on signal queues are not dangerous to the system, as signal
queues are relatively shallow and consume little memory even when full. Compare
with infamous "recursive fd" attack against AF_UNIX fd transport , which plagues
application development to this day (due to safeguards introduced to alleviate
it).

2.c. Natural decoupling of signal transport from vfs internals prevents any
sort of "recursive fd" attacks altogether (it is even safe to send the
signalfd() fd through - this can be considered a convenient feature to
replicate signal delivery masks around; of course, the receiving task will only
receive its own signals through it, peeking on other task's signals will not be
possible).

3. Suggestion: new file desriptors should not appear in destination processes
out of the blue.

3.a. To receive the signal, process must make non-trivial preparations (
manipulate signal masks, etc), which would only happen if certain signals
are expected.

3.b. In present implementation, file desriptor is only created at the
destination when destination task explictly elects to receive the associated
signal info with sigtimedwait/signalfd. In the absence of destination task
cooperation, the only overhead on the kernel side will be a single pair
of ref_count increment/decrement, that is, completely negligible.

3.c. Due to the nature of siginfo delivery, operations on file descriptor table
are completely safe and indistinguishable from a normal dup() system call.

I would appreciate any additional constructive criticism, as it is in my
interest as well to end up with safe and simple solution. However, I would
prefer the criticism to target particular technical shortcomings, and not be
derived from personal preferences, if possible.

