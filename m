Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3FXTMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:12:30 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:40460 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3FXTM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:12:29 -0400
Date: Mon, 24 Jun 2013 21:12:03 +0200
From: Marcus Gelderie <redmnic@gmail.com>
To: john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org
Subject: Race condition in time/alarmtimer.c
Message-ID: <20130624191202.GA22643@cantor.Speedport_W_503V_Typ_C>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there seems to be a race condition in kernel/time/alarmtimer.c

More specifically, the following function (line numbers correspond to actual file):

584 static int alarmtimer_do_nsleep(struct alarm *alarm, ktime_t absexp)
585 {
586         alarm->data = (void *)current;
587         do {
588                 set_current_state(TASK_INTERRUPTIBLE);
589                 alarm_start(alarm, absexp);
590                 if (likely(alarm->data))
591                         schedule();
592 
593                 alarm_cancel(alarm);
594         } while (alarm->data && !signal_pending(current));
595 
596         __set_current_state(TASK_RUNNING);
597 
598         return (alarm->data == NULL);
599 }

has a race: If the task is preempted after set_current_state(TASK_INTERRUPTIBLE) 
but before the alarm is started in the next line, the task never wakes up.

Swapping both lines is not an option either, because then the alarm might trigger before 
the thread sets itself to TASK_INTERRUPTIBLE, thereby loosing the wakeup. 

A spinlock would disable preemption and protect alarm->data against the race from another CPU. 
We could wrap lines 588 and 589 with a spin lock. Then the wakeup code would also aquire the 
lock, of course. The lock could be attached to struct alarm. 

An alternative would be a waitqueue, of course.

If folks agree with me, I will provide a patch.


Cheers
Marcus
