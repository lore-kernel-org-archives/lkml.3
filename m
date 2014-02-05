Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaBEQ5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:57:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:33317 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753091AbaBEQ5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:57:06 -0500
Date: Wed, 5 Feb 2014 11:57:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>, Ulrich Obergfell <uobergfe@redhat.com>,
        stable-rt@vger.kernel.org
Subject: Re: [PATCH RT] rt: Make cpu_chill() use hrtimer instead of msleep()
Message-ID: <20140205115700.3107d0e2@gandalf.local.home>
In-Reply-To: <20140205115125.3cc950ce@gandalf.local.home>
References: <20140205115125.3cc950ce@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014 11:51:25 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ulrich Obergfell pointed out that cpu_chill() calls msleep() which is woken
> up by the ksoftirqd running the TIMER softirq. But as the cpu_chill() is
> called from softirq context, it may block the ksoftirqd() from running, in
> which case, it may never wake up the msleep() causing the deadlock.
> 
> I checked the vmcore, and irq/74-qla2xxx is stuck in the msleep() call,
> running on CPU 8. The one ksoftirqd that is stuck, happens to be the one that
> runs on CPU 8, and it is blocked on a lock held by irq/74-qla2xxx. As that
> ksoftirqd is the one that will wake up irq/74-qla2xxx, and it happens to be
> blocked on a lock that irq/74-qla2xxx holds, we have our deadlock.
> 
> The solution is not to convert the cpu_chill() back to a cpu_relax() as that
> will re-create a possible live lock that the cpu_chill() fixed earlier, and may
> also leave this bug open on other softirqs. The fix is to remove the
> dependency on ksoftirqd from cpu_chill(). That is, instead of calling
> msleep() that requires ksoftirqd to wake it up, use the
> hrtimer_nanosleep() code that does the wakeup from hard irq context.
> 
> Found-by: Ulrich Obergfell <uobergfe@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 

I should have added:

Cc: stable-rt@vger.kernel.org

-- Steve
