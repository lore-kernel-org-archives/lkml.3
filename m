Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbaGZH4P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 03:56:15 -0400
Received: from mail-qg0-f66.google.com ([209.85.192.66]:45912 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaGZH4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 03:56:14 -0400
MIME-Version: 1.0
In-Reply-To: <53D2BA45.8030502@amacapital.net>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	<53D2BA45.8030502@amacapital.net>
Date: Sat, 26 Jul 2014 00:56:13 -0700
Message-ID: <CA+80gGa3kkgA=JVdO2xcqFrhQ3QkocjEBRE+YDf3QGJtA3na+Q@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 1:12 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On 07/25/2014 12:45 PM, Sergey Oboguev wrote:
>> [This is a repost of the message from few day ago, with patch file
>> inline instead of being pointed by the URL.]
>>
>> This patch is intended to improve the support for fine-grain parallel
>> applications that may sometimes need to change the priority of their threads at
>> a very high rate, hundreds or even thousands of times per scheduling timeslice.
>
> What is the authlist stuff for?  It looks complicated and it seems like
> it should be unnecessary.

The authlist controls who is allowed to use the DPRIO facility.

DPRIO works by making a check at __schedule() time for whether a deferred set
priority request is pending, and if so, then performing an equivalent of
sched_setattr(), minus security checks, before the rescheduling.

This introduces additional latency at task switch time when a deferred set
priority request is pending -- albeit normally a very small latency, but
non-zero one and a malicious user can also manoeuvre into increasing it. There
are two parts to this latency. One is more or less constant part in the order
of 1 usec, that's basic __sched_setscheduler() code. The other part is due to
possible priority inheritance chain adjustment in rt_mutex_adjust_pi() and
depends on the length of the chain. Malicious user might conceivably construct
a very long chain, long enough for processing of this chain at the time of
__schedule to cause an objectionable latency. On systems where this might be a
concern, administrator may therefore want to restrict the use of DPRIO to
legitimate trusted applications (or rather users of those).

If a common feeling is that such a safeguard is overly paranoid, I would be
happy to drop it, but I feel some security control option may be desirable
for the mentioned reason.

Rethinking it now though, perhaps a simpler alternative could be adding a
capability for DPRIO plus a system-wide setting as to whether this capability
is required for the use of DPRIO or DPRIO is allowed for everyone on the
system. The benefit of this approach might also be that the administrator can
use setcap on trusted executable files installed in the system to grant them
this capability.

> What's with the save/restore code?  What's it saving and restoring?

It is used inside execve.

There are two DPRIO-related elements stored in task_struct (plus one more for
the debug code only).

One is an address of a location in the userspace that is used for
the userspace <-> kernel communication.

Another element stored in task_struct is the pointer to per-task DPRIO
information block kept inside the kernel. This block holds pre-authorized
priorities.

(The address of userspace location is stored in task_struct itself, rather than
in DPRIO info block to avoid extra indirection in the frequent path.)

Successful execve must result in shutting down DPRIO for the task, i.e.
resetting these two pointers to NULL (this must be performed before new
executable image is loaded, otherwise a corruption of new image memory can
result) and also the deallocation of DPRIO information block. If execve fails
however and control returns to the original image, DPRIO settings should be
retained.

Before calling image loader, execve (i.e. do_execve_common) invokes
dprio_save_reset_context() to save these two pointers in on-stack backup
structure and to reset their values in task_struct to NULL. If new image loads
fine, DPRIO information block is deallocated by dprio_free_context() and
control is passed on to the new image, with pointers in task_struct already
reset to NULL. If image loading fails, error recovery path invokes
dprio_restore_context() to restore the pointers from the backup structure back
into task_struct.

- Sergey
