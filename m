Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822Ab3EBOdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:33:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17420 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758893Ab3EBOdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:33:21 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=P6hlpVgoKeYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ayLHJbDuenQA:10 a=Vyq7-WjqqOR9Jb61Tt0A:9 a=QEXdDO2ut3YA:10 a=3qSQYlg-AHRLqm-h:21 a=P0vd1kVwOOQwZ-Dh:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367505199.30667.132.camel@gandalf.local.home>
Subject: Re: [PATCH RT v2] x86/mce: Defer mce wakeups to threads for
 PREEMPT_RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 02 May 2013 10:33:19 -0400
In-Reply-To: <20130426084137.GC20927@linutronix.de>
References: <1365705214.9609.58.camel@gandalf.local.home>
	 <20130426084137.GC20927@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 10:41 +0200, Sebastian Andrzej Siewior wrote:
> * Steven Rostedt | 2013-04-11 14:33:34 [-0400]:
> 
> >As wait queue locks are notorious for long hold times, we can not
> >convert them to raw_spin_locks without causing issues with -rt. But
> >Thomas has created a "simple-wait" structure that uses raw spin locks
> >which may have been a good fit.
> >
> >Unfortunately, wait queues are not the only issue, as the mce_notify_irq
> >also does a schedule_work(), which grabs the workqueue spin locks that
> >have the exact same issue.
> 
> mce_notify_irq() can use simple_waitqueue, no?

Yeah, and I went down that path.

But it also schedules work, which has the issue.

> The other issue is that mce_report_event() is scheduling a per-cpu
> workqueue (mce_schedule_work) in case of a memory fault. This has the
> same issue.

Yeah, that looks like it can be an issue too. I wonder if we can use the
same thread and use flags check what to do. Atomically set the flag for
the function to perform, and then have the thread clear it before doing
the function and only go to sleep when all flags are cleared.

-- Steve


