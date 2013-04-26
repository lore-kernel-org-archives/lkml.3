Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab3DZIYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:24:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:47546 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3DZIYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:24:08 -0400
Date: Fri, 26 Apr 2013 10:24:07 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH RT v2] x86/mce: Defer mce wakeups to threads for
 PREEMPT_RT
Message-ID: <20130426082407.GB20927@linutronix.de>
References: <1365705214.9609.58.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1365705214.9609.58.camel@gandalf.local.home>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2013-04-11 14:33:34 [-0400]:

>diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
>index e8d8ad0..060e473 100644
>--- a/arch/x86/kernel/cpu/mcheck/mce.c
>+++ b/arch/x86/kernel/cpu/mcheck/mce.c
>@@ -1308,6 +1309,61 @@ static void mce_do_trigger(struct work_struct *work)
> 
> static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
> 
>+static void __mce_notify_work(void)
>+{
>+	/* Not more than two messages every minute */
>+	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
>+
>+	/* wake processes polling /dev/mcelog */
>+	wake_up_interruptible(&mce_chrdev_wait);
>+
>+	/*
>+	 * There is no risk of missing notifications because
>+	 * work_pending is always cleared before the function is
>+	 * executed.
>+	 */
>+	if (mce_helper[0] && !work_pending(&mce_trigger_work))
>+		schedule_work(&mce_trigger_work);

Why is here this work_pending() check? You can't enqueue a work item
twice.

Sebastian
