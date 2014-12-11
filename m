Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880AbaLKLdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 06:33:16 -0500
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:41626 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932200AbaLKLdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 06:33:15 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3871:3872:3873:3874:4321:5007:6119:6261:7875:9108:10004:10400:10848:10967:11026:11232:11658:11914:12043:12296:12517:12519:12555:12740:13069:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: thing72_565cb32cc5f1b
X-Filterd-Recvd-Size: 2900
Date: Thu, 11 Dec 2014 06:33:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: Re: [GIT PULL] tracing/NMI/printk: Use seq_buf for safe printing
 from NMI context
Message-ID: <20141211063307.6f429b78@gandalf.local.home>
In-Reply-To: <CA+55aFz5-_LKW4JHEBoWinN9_ouNcGRWAF2FUA35u46FRN-Kxw@mail.gmail.com>
References: <20141208100528.5f97106f@gandalf.local.home>
	<20141208100851.3906cc0a@gandalf.local.home>
	<CA+55aFwUrFysQU1y-r_jWtA=NuXaNA06UYT-bF_hvA7mexj4=g@mail.gmail.com>
	<CA+55aFz5-_LKW4JHEBoWinN9_ouNcGRWAF2FUA35u46FRN-Kxw@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014 21:29:40 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Dec 10, 2014 at 8:20 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Would it perhaps be possible/reasonable to also use this to get rid of
> > the horrible "early_printk()" stuff [...]
> 
> Another question: the "preempt_disable/enable()" around the use of the
> per-cpu vprintk_func thing seems dubious.
> 
> Why do I say that? I think it cannot possibly make sense. Anybody who
> sets that function pointer to any per-cpu value has to disable
> preemption for that to make sense, so doing it inside the printk()
> paths seems dubious at best.
> 
> No?

So you are saying that anytime the printk_func is not the default, the
caller had to have disable preemption? Even if the caller changes all
per cpu calls, it is probably still safe as other cpus will be either
using the default or the one that is going to be the "default" (I say
that as being global).

Thus something like this?

-- Steve

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5af2b8bc88f0..9b896e7a50a9 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1859,10 +1859,16 @@ asmlinkage __visible int printk(const char *fmt, ...)
 	int r;
 
 	va_start(args, fmt);
-	preempt_disable();
+
+	/*
+	 * If a caller overrides the per_cpu printk_func, then it needs
+	 * to disable preemption when calling printk(). Otherwise
+	 * the printk_func should be set to the default. No need to
+	 * disable preemption here.
+	 */
 	vprintk_func = this_cpu_read(printk_func);
 	r = vprintk_func(fmt, args);
-	preempt_enable();
+
 	va_end(args);
 
 	return r;
