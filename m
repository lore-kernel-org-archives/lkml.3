Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab3IZViP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:38:15 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35655 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab3IZViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:38:12 -0400
MIME-Version: 1.0
Date: Thu, 26 Sep 2013 17:38:11 -0400
Message-ID: <CANsc=4X_KrPEYVPuqPBgATNsY3a3M4Penur+9S1JSJ_MUvfxGg@mail.gmail.com>
Subject: Scheduling new work during a context switch
From: =?UTF-8?Q?Adrien_Verg=C3=A9?= <adrienverge@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am modifying the perf internals to avoid the overhead due to a
second copy, when using Intel's BTS (execution tracing). Mainly, I
have a buffer that fills during the execution of the traced process,
and I sometimes need to save its contents.

When my buffer should be emptied, I schedule a task to copy the buffer
contents to disk later. This action should be performed:
- Whenether the buffer is full (in a IRQ handler).
- Whenether the traced task is scheduled out. This is when it blocks.

The problem is, deferring work in a work queue with schedule_work()
during a context switch (in schedule()) leads to a deadlock, because
both want to hold the same lock (&(&pool->lock)->rlock).
I also tried to pre-schedule the task, make it
wait_event_interruptible(), and wake_up() it during the context
switch, but there is also a deadlock due to already-held &p->pi_lock
in try_to_wake_up().

I am certainly doing something not the way it should be done. Is there
a correct way to defer work during a context switch?

Thanks!

Adrien
