Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3CJScT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:32:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab3CJScS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:32:18 -0400
Date: Sun, 10 Mar 2013 19:31:40 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 2/5] signal x86: Clear RF EFLAGS bit for signal handler
Message-ID: <20130310183140.GB1724@krava.brq.redhat.com>
References: <1362161512-16803-1-git-send-email-jolsa@redhat.com>
 <1362161512-16803-3-git-send-email-jolsa@redhat.com>
 <5130FA2E.9010502@zytor.com>
 <20130303104321.GA1024@krava.redhat.com>
 <20130310171518.GA1724@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130310171518.GA1724@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 06:15:18PM +0100, Jiri Olsa wrote:
> On Sun, Mar 03, 2013 at 11:43:21AM +0100, Jiri Olsa wrote:
> > On Fri, Mar 01, 2013 at 10:57:50AM -0800, H. Peter Anvin wrote:
> > > On 03/01/2013 10:11 AM, Jiri Olsa wrote:
> > > > Clearing RF EFLAGS bit for signal handler. The reason is,
> > > > that this flag is set by debug exception code to prevent
> > > > the recursive exception entry.
> > > > 
> > > > Leaving it set for signal handler might prevent debug
> > > > exception of the signal handler itself.
> > > > 
> > > > diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> > > > index b6fe116..e273571 100644
> > > > --- a/arch/x86/kernel/signal.c
> > > > +++ b/arch/x86/kernel/signal.c
> > > > @@ -726,6 +726,13 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
> > > >  	regs->flags &= ~X86_EFLAGS_DF;
> > > >  
> > > >  	/*
> > > > +	 * Clear RF when entering the signal handler, because
> > > > +	 * it might disable possible debug exception from the
> > > > +	 * signal handler.
> > > > +	 */
> > > > +	regs->flags &= ~X86_EFLAGS_RF;
> > > > +
> > > > +	/*
> > > >  	 * Clear TF when entering the signal handler, but
> > > >  	 * notify any tracer that was single-stepping it.
> > > >  	 * The tracer may want to single-step inside the
> > > > 
> > > 
> > > Makes sense.  However, can you combine all the flags-clearing into one
> > > statement while you are at it?
> 
> Is there any other reason for this besides having just signal

s/signal/single/ ;-)

jirka
> instruction doing this update?
> 
> It looks like gcc is smart enough to do that anyway:
> 
> ...
> andq   $0xfffffffffffffaff,(%rdi)
> ...
> 
> 
> I need to send V2 anyway, since the patchset no longer
> applies into latest tip.
> 
> thanks,
> jirka
