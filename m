Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983Ab3EBO1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:27:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5101 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab3EBO04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:26:56 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=P6hlpVgoKeYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ayLHJbDuenQA:10 a=VwQbUJbxAAAA:8 a=r9PutziMfofqZBGXxBMA:9 a=QEXdDO2ut3YA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367504813.30667.128.camel@gandalf.local.home>
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
Date: Thu, 02 May 2013 10:26:53 -0400
In-Reply-To: <20130426082407.GB20927@linutronix.de>
References: <1365705214.9609.58.camel@gandalf.local.home>
	 <20130426082407.GB20927@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grumble, somehow these emails got lost in the crowd.

On Fri, 2013-04-26 at 10:24 +0200, Sebastian Andrzej Siewior wrote:
> * Steven Rostedt | 2013-04-11 14:33:34 [-0400]:
> 
> >diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> >index e8d8ad0..060e473 100644
> >--- a/arch/x86/kernel/cpu/mcheck/mce.c
> >+++ b/arch/x86/kernel/cpu/mcheck/mce.c
> >@@ -1308,6 +1309,61 @@ static void mce_do_trigger(struct work_struct *work)
> > 
> > static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
> > 
> >+static void __mce_notify_work(void)
> >+{
> >+	/* Not more than two messages every minute */
> >+	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
> >+
> >+	/* wake processes polling /dev/mcelog */
> >+	wake_up_interruptible(&mce_chrdev_wait);
> >+
> >+	/*
> >+	 * There is no risk of missing notifications because
> >+	 * work_pending is always cleared before the function is
> >+	 * executed.
> >+	 */
> >+	if (mce_helper[0] && !work_pending(&mce_trigger_work))
> >+		schedule_work(&mce_trigger_work);
> 
> Why is here this work_pending() check? You can't enqueue a work item
> twice.

Yep, that doesn't look needed. Looking at the current code we have this
commit:

commit 4d899be584d4b4c5d6b49d655176b25cebf6ff1a
Author: Tejun Heo <tj@kernel.org>
Date:   Fri Dec 21 17:57:05 2012 -0800

    x86/mce: don't use [delayed_]work_pending()
    
    There's no need to test whether a (delayed) work item in pending
    before queueing, flushing or cancelling it.  Most uses are unnecessary
    and quite a few of them are buggy.
    
    Remove unnecessary pending tests from x86/mce.  Only compile tested.
    
    v2: Local var work removed from mce_schedule_work() as suggested by
        Borislav.


-- Steve


