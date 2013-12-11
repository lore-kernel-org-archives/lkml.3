Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3LKL2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:28:43 -0500
Received: from www.linutronix.de ([62.245.132.108]:60506 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3LKL2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:28:39 -0500
Date: Wed, 11 Dec 2013 12:28:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
cc: Len Brown <lenb@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
In-Reply-To: <1386732093.5964.6.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>  <1386478624.4748.19.camel@marge.simpson.net>  <CAJvTdKn_2mihtMLiQVNCOp_zokx8CsSr2c5NhbkbfJ-qvma-8Q@mail.gmail.com>  <1386559014.4875.16.camel@marge.simpson.net> 
 <1386652637.5374.72.camel@marge.simpson.net>  <alpine.DEB.2.02.1312101458040.28330@ionos.tec.linutronix.de>  <alpine.DEB.2.02.1312110030330.28330@ionos.tec.linutronix.de> <1386732093.5964.6.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Mike Galbraith wrote:
> Alakazam..
> Yup, magical gremlin repellent works on 8 socket DL980 too.

Now here is a less magical version of the gremlin repellent.

And just for the amusement value: The erratum for the series 7400
says:

AAI65. MONITOR/MWAIT May Have Excessive False Wakeups

Problem:	Normally, if MWAIT is used to enter a C-state that is
		C1 or higher, a store to the address range armed by
		the MONITOR instruction will cause the processor to
		exit MWAIT. Due to this erratum, false wakeups may
		occur when the monitored address range was recently
		written prior to executing the MONITOR instruction.

Implication:	Due to this erratum, performance and power savings may
		be impacted due to excessive false wakeups.

Workaround: 	Execute a CLFLUSH Instruction immediately before every
		MONITOR instruction when the monitored location may
		have been recently written.

Now that looks like the very same issue on these westmere EX
machines.

These false wakeups can be observed already before the idle changes
and now they are just more prominent.

Adding that clflush() unconditionally fixes the issue at least on
Boris machine.

Mike, can you retest on that 8 socket monstrum, please?

So it looks like the idle power regression is actually a software
change which exhibits a hardware "regression".

So much for proper validated advertising which promises core power 0W
at idle for these beasts :)

Thanks,

	tglx
---
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 92d1206..50299ad 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -376,7 +376,7 @@ static int intel_idle(struct cpuidle_device *dev,
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
 	if (!current_set_polling_and_test()) {
-
+		clflush(&current_thread_info()->flags);
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
