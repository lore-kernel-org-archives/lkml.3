Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965491AbaLKVmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:42:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:63891 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933570AbaLKVmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:42:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,559,1413270000"; 
   d="scan'208";a="622432787"
Date: Thu, 11 Dec 2014 13:42:02 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [ftrace/fgraph/x86] BUG: unable to handle kernel paging request
 at 3d00c17d
Message-ID: <20141211214202.GA23344@wfg-t540p.sh.intel.com>
References: <20141210231732.GA24163@wfg-t540p.sh.intel.com>
 <20141210230913.0bcbb124@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210230913.0bcbb124@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Wed, Dec 10, 2014 at 11:09:13PM -0500, Steven Rostedt wrote:
> On Wed, 10 Dec 2014 15:17:32 -0800
> Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > Hi Steven,
> > 
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > commit 6a06bdbf7f9c669743f58084991ba280f2925586
> > Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
> > AuthorDate: Mon Nov 24 21:00:34 2014 -0500
> > Commit:     Steven Rostedt <rostedt@goodmis.org>
> > CommitDate: Mon Dec 1 14:08:58 2014 -0500
> > 
> >     ftrace/fgraph/x86: Have prepare_ftrace_return() take ip as first parameter
> >     
> >     The function graph helper function prepare_ftrace_return() which does the work
> >     to hijack the parent pointer has that parent pointer as its first parameter.
> >     Instead, if we make it the second parameter and have ip as the first parameter
> >     (self_addr), then it can use the %rdi from save_mcount_regs that loads it
> >     already.
> >     
> >     Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1411262304010.3961@nanos
> >     
> >     Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> >     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Crap! Yeah, I was wondering how this could be the bug, but then I
> realized this was i386 not x86_64 and I never updated the i386 call to
> prepare_ftrace_return().
> 
> Does this patch fix it?

Yes, it fixed the issue.

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks,
Fengguang

> 
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index b553ed89e5f5..df3e608d409b 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1192,10 +1192,10 @@ ENTRY(ftrace_graph_caller)
>  	pushl %eax
>  	pushl %ecx
>  	pushl %edx
> -	movl 0xc(%esp), %edx
> -	lea 0x4(%ebp), %eax
> +	movl 0xc(%esp), %eax
> +	lea 0x4(%ebp), %edx
>  	movl (%ebp), %ecx
> -	subl $MCOUNT_INSN_SIZE, %edx
> +	subl $MCOUNT_INSN_SIZE, %eax
>  	call prepare_ftrace_return
>  	popl %edx
>  	popl %ecx
