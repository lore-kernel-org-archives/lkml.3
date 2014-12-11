Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725AbaLKEJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 23:09:26 -0500
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:55163 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933529AbaLKEJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 23:09:25 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2859:2895:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3653:3865:3867:3868:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6261:7875:8599:8660:8957:9025:9040:10004:10400:10450:10455:10848:10967:11026:11232:11473:11658:11914:12043:12050:12295:12438:12517:12519:12555:12740:12783:13069:13148:13230:13311:13357:14096:14097:19904:19999:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: salt84_8c3851d36c249
X-Filterd-Recvd-Size: 2725
Date: Wed, 10 Dec 2014 23:09:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [ftrace/fgraph/x86] BUG: unable to handle kernel paging request
 at 3d00c17d
Message-ID: <20141210230913.0bcbb124@gandalf.local.home>
In-Reply-To: <20141210231732.GA24163@wfg-t540p.sh.intel.com>
References: <20141210231732.GA24163@wfg-t540p.sh.intel.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014 15:17:32 -0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> Hi Steven,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit 6a06bdbf7f9c669743f58084991ba280f2925586
> Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
> AuthorDate: Mon Nov 24 21:00:34 2014 -0500
> Commit:     Steven Rostedt <rostedt@goodmis.org>
> CommitDate: Mon Dec 1 14:08:58 2014 -0500
> 
>     ftrace/fgraph/x86: Have prepare_ftrace_return() take ip as first parameter
>     
>     The function graph helper function prepare_ftrace_return() which does the work
>     to hijack the parent pointer has that parent pointer as its first parameter.
>     Instead, if we make it the second parameter and have ip as the first parameter
>     (self_addr), then it can use the %rdi from save_mcount_regs that loads it
>     already.
>     
>     Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1411262304010.3961@nanos
>     
>     Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Crap! Yeah, I was wondering how this could be the bug, but then I
realized this was i386 not x86_64 and I never updated the i386 call to
prepare_ftrace_return().

Does this patch fix it?

-- Steve

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index b553ed89e5f5..df3e608d409b 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1192,10 +1192,10 @@ ENTRY(ftrace_graph_caller)
 	pushl %eax
 	pushl %ecx
 	pushl %edx
-	movl 0xc(%esp), %edx
-	lea 0x4(%ebp), %eax
+	movl 0xc(%esp), %eax
+	lea 0x4(%ebp), %edx
 	movl (%ebp), %ecx
-	subl $MCOUNT_INSN_SIZE, %edx
+	subl $MCOUNT_INSN_SIZE, %eax
 	call prepare_ftrace_return
 	popl %edx
 	popl %ecx
