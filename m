Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaGUMdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:33:37 -0400
Received: from mail-qc0-f193.google.com ([209.85.216.193]:44039 "EHLO
	mail-qc0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbaGUMde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:33:34 -0400
MIME-Version: 1.0
Date: Mon, 21 Jul 2014 05:33:33 -0700
Message-ID: <CA+80gGbM7HEsrXKJ4iWFToKYwyb-KDbeSNFVNyxxNqaTYErHdw@mail.gmail.com>
Subject: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is intended to improve the support for fine-grain parallel
applications that may sometimes need to change the priority of their threads at
a very high rate, hundreds or even thousands of times per scheduling timeslice.

These are typically applications that have to execute short or very short
lock-holding critical or otherwise time-urgent sections of code at a very high
frequency and need to protect these sections with "set priority" system calls,
one "set priority" call to elevate current thread priority before entering the
critical or time-urgent section, followed by another call to downgrade thread
priority at the completion of the section. Due to the high frequency of
entering and leaving critical or time-urgent sections, the cost of these "set
priority" system calls may raise to a noticeable part of an application's
overall expended CPU time. Proposed "deferred set priority" facility allows to
largely eliminate the cost of these system calls.

Instead of executing a system call to elevate its thread priority, an
application simply writes its desired priority level to a designated memory
location in the userspace. When the kernel attempts to preempt the thread, it
first checks the content of this location, and if the application's stated
request to change its priority has been posted in the designated memory area,
the kernel will execute this request and alter the priority of the thread being
preempted before performing a rescheduling, and then make a scheduling decision
based on the new thread priority level thus implementing the priority
protection of the critical or time-urgent section desired by the application.
In a predominant number of cases however, an application will complete the
critical section before the end of the current timeslice and cancel or alter
the request held in the userspace area. Thus a vast majority of an
application's change priority requests will be handled and mutually cancelled
or coalesced within the userspace, at a very low overhead and without incurring
the cost of a system call, while maintaining safe preemption control. The cost
of an actual kernel-level "set priority" operation is incurred only if an
application is actually being preempted while inside the critical section, i.e.
typically at most once per scheduling timeslice instead of hundreds or
thousands "set priority" system calls in the same timeslice.

One of the intended purposes of this facility (but its not sole purpose) is to
render a lightweight mechanism for priority protection of lock-holding critical
sections that would be an adequate match for lightweight locking primitives
such as futex, with both featuring a fast path completing within the userspace.

More detailed description can be found in:
https://raw.githubusercontent.com/oboguev/dprio/master/dprio.txt

The patch is currently based on 3.15.2.

Patch file:
https://github.com/oboguev/dprio/blob/master/patch/linux-3.15.2-dprio.patch
https://raw.githubusercontent.com/oboguev/dprio/master/patch/linux-3.15.2-dprio.patch

Modified source files:
https://github.com/oboguev/dprio/tree/master/src/linux-3.15.2

User-level library implementing userspace-side boilerplate code:
https://github.com/oboguev/dprio/tree/master/src/userlib

Test set:
https://github.com/oboguev/dprio/tree/master/src/test

The patch is enabled with CONFIG_DEFERRED_SETPRIO.

There is also a config setting for the debug code and a setting that controls
the initial value of authorization list restricting the use of the facility
based on user or group ids. Please see dprio.txt for details.

Comments would be appreciated.

Thanks,
Sergey

Signed-off-by: Sergey Oboguev <oboguev@yahoo.com>
