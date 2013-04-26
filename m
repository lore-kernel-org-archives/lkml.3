Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab3DZIWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:22:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:47536 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3DZIWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:22:38 -0400
Date: Fri, 26 Apr 2013 10:22:35 +0200
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
Message-ID: <20130426082235.GA20927@linutronix.de>
References: <1365705214.9609.58.camel@gandalf.local.home>
 <20130425164441.GG5561@linutronix.de>
 <1366909777.10248.17.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1366909777.10248.17.camel@gandalf.local.home>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2013-04-25 13:09:37 [-0400]:

>Thanks, I didn't look hard at the warnings.

Now that I booted the kernel I see this

|INFO: task mce-notify:78 blocked for more than 120 seconds.
|"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
|mce-notify      D 00000086     0    78      2 0x00000000
| f2e1bf2c 00000096 f2e1bebc 00000086 f2e1becc c1466606 f3440000 00000001
| c1689000 c106dd0a f2cdddf0 f3471f50 00000000 c1690f00 00000007 00000006
| c146662d f2cdddf0 00000282 00000001 f3449ef8 00000282 f2e1bf10 c106b67d
|Call Trace:
| [<c1466606>] ? _raw_spin_unlock_irqrestore+0x36/0x70
| [<c106dd0a>] ? try_to_wake_up+0x5a/0x260
| [<c146662d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
| [<c106b67d>] ? sub_preempt_count+0x4d/0xb0
| [<c1466606>] ? _raw_spin_unlock_irqrestore+0x36/0x70
| [<c101b620>] ? set_bank+0x50/0x50
| [<c1464d7e>] schedule+0x1e/0x50
| [<c105bb07>] kthread+0x67/0x90
| [<c1466662>] ? _raw_spin_unlock_irq+0x22/0x60
| [<c14671b7>] ret_from_kernel_thread+0x1b/0x28
| [<c105baa0>] ? __init_kthread_worker+0x80/0x80
|no locks held by mce-notify/78.

because the new thread is still TASK_UNINTERRUPTIBLE and nobody wakes it
up. So I did this:

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index c2d6dc7..332e133 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1371,17 +1371,19 @@ struct task_struct *mce_notify_helper;
 
 static int mce_notify_helper_thread(void *unused)
 {
-	while (!kthread_should_stop()) {
-		__mce_notify_work();
+	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
+		if (kthread_should_stop())
+			break;
+		__mce_notify_work();
 	}
 	return 0;
 }
 
 static int mce_notify_work_init(void)
 {
-	mce_notify_helper = kthread_create(mce_notify_helper_thread, NULL,
+	mce_notify_helper = kthread_run(mce_notify_helper_thread, NULL,
 					   "mce-notify");
 	if (!mce_notify_helper)
 		return -ENOMEM;

>
>-- Steve

Sebastian
