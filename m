Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaBKUYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:24:20 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:35154 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaBKUYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:24:16 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Feb 2014 12:23:55 -0800
Message-ID: <CALCETrVL44ewQPJXNwPAm2s5aj9auo2p4tYYieNcxANoL91VWw@mail.gmail.com>
Subject: Too many rescheduling interrupts (still!)
To: Mike Galbraith <bitbucket@online.de>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rumor has it that Linux 3.13 was supposed to get rid of all the silly
rescheduling interrupts.  It doesn't, although it does seem to have
improved the situation.

A small number of reschedule interrupts appear to be due to a race:
both resched_task and wake_up_idle_cpu do, essentially:

set_tsk_need_resched(t);
smb_mb();
if (!tsk_is_polling(t))
  smp_send_reschedule(cpu);

The problem is that set_tsk_need_resched wakes the CPU and, if the CPU
is too quick (which isn't surprising if it was in C0 or C1), then it
could *clear* TS_POLLING before tsk_is_polling is read.

Is there a good reason that TIF_NEED_RESCHED is in thread->flags and
TS_POLLING is in thread->status?  Couldn't both of these be in the
same field in something like struct rq?  That would allow a real
atomic op here.

The more serious issue is that AFAICS default_wake_function is
completely missing the polling check.  It goes through
ttwu_queue_remote, which unconditionally sends an interrupt.

--Andy
