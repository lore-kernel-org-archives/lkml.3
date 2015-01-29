Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbbA2Olh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:41:37 -0500
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:44720 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752394AbbA2Olf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:41:35 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2196:2199:2200:2393:2553:2559:2562:2693:2915:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4184:4385:5007:6119:6261:7875:7903:8660:8957:9010:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13148:13230:13311:13357:13618:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: meal35_47c97e8246234
X-Filterd-Recvd-Size: 2789
Date: Thu, 29 Jan 2015 09:41:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jkosina@suse.cz
Subject: Re: Question about ftrace, dynamically allocated trampolines and
 dynamic fops
Message-ID: <20150129094132.1b9c1494@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1501291023000.25445@pobox.suse.cz>
References: <alpine.LNX.2.00.1501291023000.25445@pobox.suse.cz>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2015 10:40:58 +0100 (CET)
Miroslav Benes <mbenes@suse.cz> wrote:

> 
> Hi,
> 
> solving a possible race condition in kGraft and thinking about the same in 
> klp live patching I looked quite a lot at ftrace code. One thing about 
> recent dynamic trampolines seems a bit odd. For dynamic fops 
> (FTRACE_OPS_FL_DYNAMIC is set in ops->flags) arch_ftrace_update_trampoline 
> is called only for nonpreemptive kernels in ftrace_update_trampoline. The 
> reason is obvious and well described in the comment there. However the 
> actual callback function in arch_ftrace_update_trampoline is 
> determined by call to ftrace_ops_get_func which gives generic 
> ftrace_ops_list_func for dynamic ops. This function disables preemption 
> (because of traversing rcu protected list), so it should be safe to use 
> dynamic trampolines even for dynamic fops in preemptive kernels. Is this 
> correct? 

No, the dynamic trampoline itself is not safe. I explained this at the
LinuxConEU/Plumbers conference, although the slides don't explain it
well :-/, otherwise I would have just pointed you to them.

Basically what the issue is, if a task jumps to the dynamic trampoline
and gets preempted, how would you ever free that trampoline again?

Now for live kernel patching, we could add another flag that says
permanent, that means the trampoline and the ops will never be free or
change, and then it would be safe to use dynamic trampolines.

> 
> Or maybe the problem is the opposite. Why does the ftrace use 
> ftrace_ops_list_func in such situation? Even for nonpreemptive kernel and 
> dynamic fops ftrace_ops_list_func has unnecessary overhead.

It points the dynamic ops (in non-preempt) to ftrace_ops_list_func? Are
you sure about that. One way to verify is to
cat /sys/kernel/debug/tracing/enabled_functions, which should show you
want the dynamic ops points to.

-- Steve
