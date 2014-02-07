Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaBGOIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:08:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:58172 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751461AbaBGOIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:08:39 -0500
Date: Fri, 7 Feb 2014 09:08:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>, Ulrich Obergfell <uobergfe@redhat.com>
Subject: Re: [PATCH RT] rt: Make cpu_chill() use hrtimer instead of msleep()
Message-ID: <20140207090834.72774272@gandalf.local.home>
In-Reply-To: <20140207113006.GD23668@linutronix.de>
References: <20140205115125.3cc950ce@gandalf.local.home>
	<20140207113006.GD23668@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014 12:30:06 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> * Steven Rostedt | 2014-02-05 11:51:25 [-0500]:
> 
> >Ulrich Obergfell pointed out that cpu_chill() calls msleep() which is woken
> >up by the ksoftirqd running the TIMER softirq. But as the cpu_chill() is
> >called from softirq context, it may block the ksoftirqd() from running, in
> >which case, it may never wake up the msleep() causing the deadlock.
> >
> >I checked the vmcore, and irq/74-qla2xxx is stuck in the msleep() call,
> >running on CPU 8. The one ksoftirqd that is stuck, happens to be the one that
> >runs on CPU 8, and it is blocked on a lock held by irq/74-qla2xxx. As that
> >ksoftirqd is the one that will wake up irq/74-qla2xxx, and it happens to be
> >blocked on a lock that irq/74-qla2xxx holds, we have our deadlock.
> 
> could you please tell me which two locks are invovled here?
> 

Looks to be the lock of the block softirq. I don't have the core dump
anymore, but from what I could tell the ksoftirqd was blocked on the
block softirq lock, where the block softirq handler did a msleep
(called by the qla2xxx interrupt handler).

Looking at trigger_softirq() in block/blk-softirq.c, it can do a
smp_callfunction() to another cpu to run the block softirq. If that
happens to be the cpu where the qla2xx irq handler is doing the block
softirq and is in a middle of a msleep(), I believe the ksoftirqd will
try to run the softirq. If it does that, then BOOM, it's deadlocked
because the ksoftirqd will never run the timer softirq either.

-- Steve
