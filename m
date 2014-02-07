Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaBGONQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:13:16 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:43082 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751785AbaBGONP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:13:15 -0500
Date: Fri, 7 Feb 2014 09:13:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>, Ulrich Obergfell <uobergfe@redhat.com>
Subject: Re: [PATCH RT] rt: Make cpu_chill() use hrtimer instead of msleep()
Message-ID: <20140207091313.097f9059@gandalf.local.home>
In-Reply-To: <20140207090834.72774272@gandalf.local.home>
References: <20140205115125.3cc950ce@gandalf.local.home>
	<20140207113006.GD23668@linutronix.de>
	<20140207090834.72774272@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014 09:08:34 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:


> > could you please tell me which two locks are invovled here?

I should have also stated that it was only one lock that was involved.
But the lock owner was doing a msleep() that requires a wakeup by
ksoftirqd to continue. If ksoftirqd happens to be blocked on a lock
held by the msleep() caller, then you have your deadlock.

It's best not to have any softirqs going to sleep requiring another
softirq to wake it up. Note, if we ever require a timer softirq to do a
cpu_chill() it will most definitely hit this deadlock.

-- Steve
